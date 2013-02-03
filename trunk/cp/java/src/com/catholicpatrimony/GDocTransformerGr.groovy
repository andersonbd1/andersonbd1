import groovyx.net.http.*
import static groovyx.net.http.ContentType.*
import static groovyx.net.http.Method.*
import au.com.bytecode.opencsv.CSVParser;
import org.apache.velocity.app.Velocity;
import org.apache.velocity.Template;
import org.apache.velocity.context.Context;
import org.apache.velocity.VelocityContext;

import org.apache.commons.lang.StringUtils;

def http = new HTTPBuilder( 'https://docs.google.com')

/*
https://docs.google.com/spreadsheet/pub?key=0AkWmZX8HtwWHdENUNFcxdG9XdzBTaWhlVkZ0RU1QcXc&output=csv&single=true&gid=0
https://docs.google.com/spreadsheet/pub?key=0AkWmZX8HtwWHdENUNFcxdG9XdzBTaWhlVkZ0RU1QcXc&output=csv&single=true&gid=1
*/

for (gid in 0..1) {
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
    }
   
    // called only for a 404 (not found) status code:
    response.'404' = { resp ->
      println 'Not found'
    }

  }
  println '2'

  println responseStr.getClass();

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
      }
    };
  }
  println classLabels;
  println classes;

  def format = 'wp';
  def writer = new BufferedWriter(new FileWriter("velocity_out/${seriesData.normalized_name}-${format}.xml"))
  Template template = Velocity.getTemplate("velocity/${format}.vm");
  Context context = new VelocityContext();

  context.put("seriesData", seriesData);
  context.put("classLabels", classLabels);
  context.put("classes", classes);

  template.merge(context, writer);

  writer.close();

  println '3'
}
