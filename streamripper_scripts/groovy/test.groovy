scores = [ "Brett":100, "Pete":"Did not finish", "Andrew":86.87934 ]
println scores["Brett"];

myFile = new File("../static_files/temp.txt")

println myFile.getClass()

printFileLine = { println "File line: " + it }

myFile.eachLine( printFileLine )

