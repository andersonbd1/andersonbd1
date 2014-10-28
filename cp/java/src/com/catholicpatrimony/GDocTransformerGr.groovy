import groovyx.net.http.*; import static groovyx.net.http.ContentType.*;
import static groovyx.net.http.Method.*;
import au.com.bytecode.opencsv.CSVParser;
import org.apache.velocity.app.Velocity;
import org.apache.velocity.Template;
import org.apache.velocity.context.Context;
import org.apache.velocity.VelocityContext;

import org.apache.commons.lang.StringUtils;
import com.fasterxml.jackson.databind.ObjectMapper;
import groovy.json.*;

// steps to setup a new class
//   manually backup audio files and docs on s3
//     s3cmd cp -r s3://tedesche/new_mass_translation/audio s3://tedesche/new_mass_translation/orig
//     s3cmd cp -r s3://tedesche/new_mass_translation/docs s3://tedesche/new_mass_translation/orig
//   manually get orig files
//     s3cmd sync --exclude=orig s3://tedesche/new_mass_translation ./orig
//   run this script with options: audio, zip, wp, podcast
//   upload to s3
//     s3cmd sync -P ./build/new_mass_translation/ s3://tedesche/new_mass_translation/generated/
//   change perms for s3 docs (this is no longer required because of the -P above)
//     s3cmd -P -r setacl s3://tedesche/new_mass_translation
//   delete the existing files - it's cleaner that way
//   upload to cp.com
//     scp -i ~/.ssh/tedesche.pem -r ./build/web/* bitnami@catholicpatrimony.com:~/stack/apache2/htdocs/cp
def ops = []
ops.add("print");
//ops.add("audio");
//ops.add("zip");
ops.add("json");
//ops.add("wp");
//ops.add("podcast");

def http = new HTTPBuilder( 'https://docs.google.com')

def objectMapper = new ObjectMapper(); 

/*
Date d2 = Date.parse("MM/dd/yyyy", '11/17/2012')
println d2.format("EEE, d MMM yyyy HH:mm:ss Z");
d2 = Date.parse("MM/dd/yyyy", '1/1/2012')
println d2.format("EEE, d MMM yyyy HH:mm:ss Z");
System.exit(1);
*/

/*
https://docs.google.com/spreadsheet/pub?key=0AkWmZX8HtwWHdENUNFcxdG9XdzBTaWhlVkZ0RU1QcXc&output=csv&single=true&gid=0
https://docs.google.com/spreadsheet/pub?key=0AkWmZX8HtwWHdENUNFcxdG9XdzBTaWhlVkZ0RU1QcXc&output=csv&single=true&gid=1
*/


//for (gid in 0..1) {
def jsonClassArr = []
for (gid in 0..4) {
  println 'gid: '+gid;
  def responseStr = null;

  // perform a GET request, expecting JSON response data
  http.request( GET, TEXT ) {
    uri.path = '/spreadsheet/pub'
    uri.query = [ key:'0AkWmZX8HtwWHdENUNFcxdG9XdzBTaWhlVkZ0RU1QcXc', output: 'csv', single: true, gid: gid ]

    headers.'User-Agent' = 'Mozilla/5.0 Ubuntu/8.10 Firefox/3.0.4'

    response.success = { resp, reader ->
      assert resp.status == 200
      println "My response handler got response: ${resp.statusLine}"
      println "Response length: ${resp.headers.'Content-Length'}"
      responseStr = reader.getText() // print response reader
      println responseStr
    }
   
    // called only for a 404 (not found) status code:
    response.'404' = { resp ->
      println 'Not found'
    }

  }
  seriesLabels = [];
  seriesData = [:];
  classLabels = [];
  classes = [];
  CSVParser csvp = new CSVParser();
  responseStr.eachLine { line, lineNumber ->
    String[] cols = csvp.parseLine(line); 
    cols.eachWithIndex{ p, i -> 
      if (StringUtils.isEmpty(p)) {
        return false; 
      }
      if (lineNumber == 0) {
        seriesLabels[i] = p;
      } else if (lineNumber == 1) {
          seriesData.put(seriesLabels[i], p); 
      } else if (lineNumber == 2) {
        classLabels[i] = p;
      } else if (lineNumber >= 3) {
        if (classLabels[i].equals('id') && p.length() == 1) {
          p = '0'+p;
        }
        def row = classes[lineNumber - 3]
        if (row == null) {
          row = [:]
          classes.add(row);
        }
        def existingValue = row.get(classLabels[i]);
        if (existingValue != null) {
          if (existingValue instanceof java.util.List) {
            existingValue.add(p);
          } else {
            row.put(classLabels[i], [existingValue, p]);
          }
        } else {
          row.put(classLabels[i], p); 
        }
        if (classLabels[i].equals('date')) {
          Date d = Date.parse("MM/dd/yyyy", p)
          row.put('rssDate', d.format("EEE, d MMM yyyy HH:mm:ss Z"));
        }
      }
    };
  }

  def format = 'wp';
  "mkdir -p ./build/web/${seriesData.normalized_name}".execute().waitFor();
  "mkdir -p ./build/${seriesData.normalized_name}".execute().waitFor();

  for (c in classes) {
    if (c.audio) {
      c['newAudio'] = c.id +"-"+c.title.replaceAll(' ', '_')+'.mp3'
    }
    if (c.handout_file) {
      if (c.handout_file instanceof Collection) {
        c.new_handout_file = [];
        c.new_handout_title = [];
        for (def i=0; i<c.handout_file.size; i++) {
          c.new_handout_file[i] = getNewHandoutFileName(c.id, c.handout_title[i], c.handout_file[i]);
          c.new_handout_title[i] = c.handout_title[i]
        }
      } else {
        c.new_handout_file = [];
        c.new_handout_title = [c.handout_title];
        c.new_handout_file[0] = getNewHandoutFileName(c.id, c.handout_title, c.handout_file);
      }
    }
  }

  if (ops.contains('wp')) {
    runVelocity(
      "velocity/${format}.vm", 
      "build/web/${seriesData.normalized_name}/${format}.php",
      ["seriesData": seriesData, "classLabels": classLabels, "classes": classes]
    );
  }

  if (ops.contains('json')) {
    def jsonMap = [classes: classes, seriesData: seriesData]
    jsonClassArr.add(jsonMap);
  }

  if (ops.contains('print')) {
    println classLabels;
    println classes;
  }

  if (ops.contains('audio')) {
    /*
    "rm -fR ./build/${seriesData.normalized_name}/audio".execute().waitFor();
    */
    println "1"
    try {
      "mkdir -p ./build/${seriesData.normalized_name}/audio".execute().waitFor();
    } catch (t) {
      //do nothing
    }
    println "2"
    if (!new File("orig/${seriesData.normalized_name}").exists()) {
      def proc = "s3cmd sync s3://tedesche/${seriesData.normalized_name} ./orig".execute();
      proc.waitFor();
    }
    println "3"
    for (c in classes) {
      println "4"
      if (!new File("build/${seriesData.normalized_name}/audio/${c.newAudio}").exists()) {
        println "5"
        if (c.audio) {
          println "6"
          def origFile = "orig/${seriesData.normalized_name}/audio/${c.audio}"
          def newFile = "build/${seriesData.normalized_name}/audio/${c.newAudio}"
          println c.audio;
          proc(["sox", origFile, "-r", "24k", "-c", "1", newFile]);
          proc(["id3v2", "-a", "David Tedesche", "-A", seriesData.normalized_name, "-t", c.title, "-T", c.id, newFile]);
        }
      }
    }
  }

  if (ops.contains('podcast')) {
    for (c in classes) {
      if (c.audio) {
        def newFile = "build/${seriesData.normalized_name}/audio/${c.newAudio}"
        def outStr = proc("soxi ${newFile}");
        def matcher = outStr =~ /Duration *: (.*) =/
        c["duration"] = matcher[0][1];
        c["length"] = proc("ls -lad ${newFile}").split(" ")[4]
        c["link2mp3"] = "http://tedesche.s3.amazonaws.com/${seriesData.normalized_name}/generated/audio/${c.newAudio}"
      }
    }
    runVelocity(
      "velocity/podcast.vm", 
      "build/web/${seriesData.normalized_name}/podcast.xml",
      ["seriesData": seriesData, "classLabels": classLabels, "classes": classes]
    );
  }

  if (ops.contains('zip')) {
    "rm -fR ./build/${seriesData.normalized_name}/docs".execute().waitFor();
    "mkdir -p ./build/${seriesData.normalized_name}/docs".execute().waitFor();
    for (c in classes) {
      if (c.handout_file) {
        if (c.handout_file instanceof Collection) {
          for (def i=0; i<c.handout_file.size; i++) {
            def oldFile = c.handout_file[i].replaceAll('%20', ' ');
            copyDoc(seriesData.normalized_name, oldFile, c.new_handout_file[i]);
          }
        } else {
            def oldFile = c.handout_file.replaceAll('%20', ' ');
            copyDoc(seriesData.normalized_name, oldFile, c.new_handout_file);
        }
      }
    }
    /*
    proc("tar -czf ./build/${seriesData.normalized_name}/${seriesData.normalized_name}-all.zip "+
      "-C ./build/${seriesData.normalized_name} audio docs")
    proc("tar -czf ./build/${seriesData.normalized_name}/${seriesData.normalized_name}-docs-only.zip "+
      "-C ./build/${seriesData.normalized_name} docs")
    */
    proc("zip -rj ./build/${seriesData.normalized_name}/${seriesData.normalized_name}-docs.zip "+
      "./build/${seriesData.normalized_name}/docs")
    proc("zip -rj ./build/${seriesData.normalized_name}/${seriesData.normalized_name}-audio.zip "+
      "./build/${seriesData.normalized_name}/audio")
  }

  if (ops.contains('s3-publish')) {
    // put audio back to s3
    // put zips up
    // make files public
  }

}
def jsonStr = new JsonBuilder( jsonClassArr ).toPrettyString()
jsonStr = "cp = " + jsonStr;
new File("../web/cp.json").withWriter { out -> out.write(jsonStr) };

def String proc(def cmd) {
  println cmd;
  def proc = cmd.execute();
  proc.waitFor();
  println "return code: ${proc.exitValue()}"
  println "stderr: ${proc.err.text}"
  String outStr = proc.in.text
  println "stdout: ${outStr}"
  return outStr
}

def getNewHandoutFileName(id, ht, hf) {
  def m = hf =~ /\.(.*)/
  def ext = m[0][1];
  ht = ht.replaceAll(' ', '_');
  println "${id}-${ht}.${ext}"
  return "${id}-${ht}.${ext}"
}

def copyDoc(nn, hf, nhf) {
  proc(["cp", "./orig/${nn}/docs/${hf}", "./build/${nn}/docs/${nhf}"])
}

def runVelocity(def templateFile, def outputFile, def data) {
  def writer = new BufferedWriter(new FileWriter(outputFile))
  Template template = Velocity.getTemplate(templateFile);
  def context = new VelocityContext();
  for (e in data) {
    println "${e.key}: ${e.value}"
    context.put(e.key, e.value);
    
  }
  template.merge(context, writer);
  writer.close();
}
