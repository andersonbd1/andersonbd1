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

def rawData = null;

def responseStr = null;
def responseList = null;

// perform a GET request, expecting JSON response data
http.request( GET, TEXT ) {
  uri.path = '/spreadsheet/pub'
  uri.query = [ key:'0AkWmZX8HtwWHdENUNFcxdG9XdzBTaWhlVkZ0RU1QcXc', output: 'csv' ]

  headers.'User-Agent' = 'Mozilla/5.0 Ubuntu/8.10 Firefox/3.0.4'

  response.success = { resp, reader ->
    assert resp.status == 200
    println "My response handler got response: ${resp.statusLine}"
    println "Response length: ${resp.headers.'Content-Length'}"
    //System.out << reader // print response reader
    //responseStr << (reader+"") // print response reader
    //responseList = reader.readLines() // print response reader
    responseStr = reader.getText() // print response reader
  }
 
  // called only for a 404 (not found) status code:
  response.'404' = { resp ->
    println 'Not found'
  }

}

println responseStr.getClass();

columnNames = [];
rows = [];
CSVParser csvp = new CSVParser();
responseStr.eachLine { line, lineNumber ->
  String[] cols = csvp.parseLine(line); 
  cols.eachWithIndex{ p, i -> 
    if (StringUtils.isEmpty(p)) {
      return false; 
    }
    if (lineNumber == 0) {
      columnNames[i] = p;
    } else {
      def row = rows[lineNumber - 1]
      if (row == null) {
        row = [:]
        rows.add(row);
      }
      def existingValue = row.get(columnNames[i]);
      if (existingValue != null) {
        if (existingValue instanceof java.util.List) {
          println "is a list";
          existingValue.add(p);
        } else {
          println "creating a list "+existingValue.getClass();
          row.put(columnNames[i], [existingValue, p]);
        }
      } else {
        row.put(columnNames[i], p); 
      }
    }
  };
}
println columnNames;
println rows;

def format = 'wp';
def writer = new BufferedWriter(new FileWriter("velocity_out/${format}.xml"))
Template template = Velocity.getTemplate("velocity/${format}.vm");
Context context = new VelocityContext();

context.put("columnNames", columnNames);
context.put("rows", rows);

template.merge(context, writer);

writer.close();
println new File('.').getAbsolutePath();
