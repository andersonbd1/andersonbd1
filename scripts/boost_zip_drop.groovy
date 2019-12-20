import java.io.*;
import java.util.*;

def void p(String m) {
  System.out.println(m);
}

def album="25-Esther"
//String audioDir = "/Users/banderso/Google Drive File Stream/My Drive/audio";
//String audioDir = "/Users/banderso/audio"
String audioDir = "/myaudio/spoken/DR-Bible"
String tmp_dir  = "/myaudio/spoken/ready2transfer"
//String drop_dir = "/Users/banderso/Dropbox/bookmobile"
def tmpDirFile = new File(tmp_dir);
def testMode = false;
if (!testMode) {
  if (tmpDirFile.exists()) {
    println "tmp_dir exists"
    for (def f : tmpDirFile.listFiles()) {
      println "deleting ${f.getAbsolutePath()}"
      f.delete();
    }
  } else {
    println "tmp_dir does not exist"
    tmpDirFile.mkdir();
  }
}
def books = new ArrayList<>();
def bookChaps = new Object[3];
def bookBoosts = [2,2,2];
def bookAndChaps = new ArrayList<>();
def boostLevels = new ArrayList<>();
BufferedReader br = new BufferedReader(new FileReader("reading_plan/$album"));
String l;
int lineIdx = 0;
while ((l = br.readLine()) != null) {
  if (lineIdx < 3) {
    //p("");
    //p("book: " + l);
    String[] lArr = l.split(" ");
    String l1 = lArr[0];
    // attempting to handle spaces in folder names,
    // but ended up with the solution of just removing 
    // the spaces in the original folders
    l1 = l1.replaceAll("=", " ");
    if (lArr.length > 1) {
      bookBoosts[lineIdx] = Integer.parseInt(lArr[1]);
    }
    books.add(l1);
    File dir = new File(audioDir + "/" + l1);
    p(dir.getAbsolutePath());
    def chapSet = new TreeSet();
    if (dir.exists()) {
      for (String fn : dir.list()) {
        if (fn.indexOf("mp3") != -1) {
          //p(fn);
          chapSet.add(dir.getAbsolutePath() + "/" + fn);
        }
      }
    }
    bookChaps[lineIdx] = new ArrayList(chapSet);
    for (String bookChap : bookChaps[lineIdx]) {
      p(bookChap);
    }
  } else {
    p(l);
    String[] cols = l.replaceAll("( +)"," ").trim().split(" ");
    p(cols.join("==="));
    int colIdx=0;
    for (String col : cols) {
      col = col.trim();
      if (col.length() <= 0 || "-".equals(col)) {
        colIdx++;
        continue;
      }
      String[] chaps = col.split("-");
      def startingChap = Integer.parseInt(chaps[0]);
      def endingChap = startingChap;
      if (chaps.length != 1) {
        endingChap = Integer.parseInt(chaps[1]);
      }
      for (def k=startingChap; k <= endingChap; k++) {
        def bc = (List)bookChaps[colIdx];
        p("k: " + k);
        p("colIdx: " + colIdx);
        bookAndChaps.add(((List)bookChaps[colIdx]).get(k - 1));
        boostLevels.add(bookBoosts[colIdx]);
      }
      colIdx++;
    }
  }
  lineIdx++;
}

def trackNum=0;
for (String absFileName : bookAndChaps) {
  if (new File(absFileName).exists()) {
    trackNum++;
    def fileName = new File(absFileName).getName();
    //def abf = absFileName.replaceAll(" ", "\\\\ ");
    def abf = absFileName
    //abf = abf.replaceAll("mp3", "zzz");
    //println abf;
    proc("sox -t mp3 -v ${boostLevels.get(trackNum-1)} $abf -r 24k -c 1 $tmp_dir/$fileName", testMode)
    // for mac
    //proc("id3tag -2 -t${trackNum} -A${album} $tmp_dir/$fileName", testMode)
    // for linux
    proc("id3v2 -2 -t${fileName} -T${trackNum} -A${album} $tmp_dir/$fileName", testMode)
    println ""
  }
}
proc("zip zips/${album}.zip $tmp_dir/*.mp3", testMode)

def String proc(def cmd, def testMode=false) {
  println cmd;
  if (!testMode) {
    def proc = cmd.execute();
    proc.waitFor();
    println "return code: ${proc.exitValue()}"
    println "stderr: ${proc.err.text}"
    String outStr = proc.in.text
    println "stdout: ${outStr}"
    return outStr
  }
}

