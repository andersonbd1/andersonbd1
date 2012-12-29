import groovyx.net.http.*
import static groovyx.net.http.ContentType.*
import static groovyx.net.http.Method.*

// pull in gdoc
/*
id,title,detail,date,folder,audio,handout #1 title,handout #1 file,handout #2 title,handout #2 file,handout #3 title,handout #3 file
1,Opening Rites,"History of the Eucharistic Liturgy, Introductory Rites, Sign of the Cross, Opening Greeting, Penitential Act, Kyrie, Gloria",1/17/2011,new_mass_translation,missal_class_for_jan17.MP3,Handout,Session01-OpeningRites.pdf,,,,
2,Sacrosanctum Concilium,The Second Vatican Council's Sacrosanctum concilium and the Liturgy as a participation in Christ's own Priestly Service to the Father.,1/24/2011,new_mass_translation,missal_class_for_jan24.MP3,Handout,"Session02-SacrosanctumConcilium.pdf""",,,,
3,Liturgy of the Word,"Liturgy of the Word, Gospel, Creed, ""consubstantial""",1/31/2011,new_mass_translation,missal_class_for_jan31.MP3,Handout,Session03-LiturgyOfTheWord.pdf,,,,
4,Offertory and Roman Canon,"Offertory Prayers, Roman Canon, ""precious chalice"", ""for many""",2/7/2011,new_mass_translation,missal_class_for_feb7.MP3,Handout,Session04-OffertoryAndRomanCanon.pdf,,,,
5,Preface and Theology of Eucharist,"Preface, ""and with your spirit"", Eucharistic Prayer Two, Real Presence",2/14/2011,new_mass_translation,missal_class_for_feb14.MP3,Handout,Session05-PrefaceAndTheologyOfEucharist.pdf,,,,
6,Theology of the Eucharist,"The Eucharist as Sacrifice, Transubstantiation, Manner of Christ's Eucharistic Presence, Effects of Communion",2/21/2011,new_mass_translation,missal_class_for_feb21.MP3,Handout,Session06-TheologyOfTheEucharist.pdf,,,,
7,Liturgiam authenticam and the Propers,"Tying Up Loose Ends from Last Week, the Propers, and the Philosophy of Translation behind Liturgiam authenticam",2/28/2011,new_mass_translation,missal_class_for_feb28.MP3,Handout 1,Session07-LiturgiamAuthenticamAndThePropers.pdf,Handout 2,Session07-PropersHandout.pdf,,
*/

def http = new HTTPBuilder( 'https://docs.google.com')

// perform a GET request, expecting JSON response data
http.request( GET, TEXT ) {
  uri.path = '/spreadsheet/pub'
  uri.query = [ key:'0AkWmZX8HtwWHdENUNFcxdG9XdzBTaWhlVkZ0RU1QcXc', output: 'csv' ]

  headers.'User-Agent' = 'Mozilla/5.0 Ubuntu/8.10 Firefox/3.0.4'

  response.success = { resp, reader ->
    assert resp.status == 200
    println "My response handler got response: ${resp.statusLine}"
    println "Response length: ${resp.headers.'Content-Length'}"
    System.out << reader // print response reader
  }
 
  // called only for a 404 (not found) status code:
  response.'404' = { resp ->
    println 'Not found'
  }

}

/*

public String c(arr, String n) {
  return arr[columnNames[n]];
}

classes = [
  {
    'title': 'The New Roman Missal',
    'normalizedTitle': 'new_roman_missal',
    'description': 'Understanding the New Roman Missal, Understanding Our Liturgy',
    'gdocUrl': 'https://docs.google.com/spreadsheet/pub?key=0AkWmZX8HtwWHdENUNFcxdG9XdzBTaWhlVkZ0RU1QcXc&output=csv',
  }
]

for (class in classes) {

  columnNames = [];
  for (cols in firstLine) {
    columnNames[cols[i]] = i;
  }

  for (line in lines) {
            
  }
}
*/
