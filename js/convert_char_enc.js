var packages = JavaImporter(
    java.lang.reflect,
    java.lang);
with (packages) {
  var argOffset = 0;
  var encoding = "utf8";
  if (arguments[0].startsWith("utf")) {
    argOffset = 1;
    encoding = arguments[0];
  }
  var s = null;
  var byteArr = Array.newInstance(Byte.TYPE, (arguments.length - argOffset));
  for (var i=argOffset; i<arguments.length; i++) {
    var intValue = Integer.parseInt(arguments[i], 16);
    if (intValue > 127) {
      var newIntValue = intValue-256;
      byteArr[i-argOffset] = newIntValue;
    } else {
      byteArr[i-argOffset] = intValue;
    }
  }
  if ("utf32".equals(arguments[0])) {
    var sb = new StringBuilder();
    var sbAppendCharArr = sb["append(char[])"];
    for (var i=0; i<byteArr.length; i=i+4) {
      var codepoint = 0;
      for (var j=3; j>=0; j--) {
        var b = byteArr[i+j];
        if (b < 0) {
          b = b + 256;
        }
        var incrValue = (b * Math.pow(256, 3-j));
        codepoint = codepoint + incrValue;
      }
      sbAppendCharArr.call(sb, Character.toChars(codepoint));
    }
    s = sb.toString();
  } else {
    s = new String(byteArr, encoding);
  }
  println('char\t\tutf8\t\tutf16\t\tutf32');
  println('----\t\t----\t\t-----\t\t-----');
  for (var i=0; i<s.length(); i++) {
    var c = s.charAt(i);
    var substr = null;
    var utf32 = '';
    var utf16 = '';
    if (c >= Character.MIN_SURROGATE) {
      sub = s.substring(i, i+2);
      utf32 = Integer.toHexString(Character.toCodePoint(s.charAt(i), s.charAt(i+1)));
      utf16 = Integer.toHexString(c+0)+Integer.toHexString(s.charAt(i+1)+0);
      i++;
    } else {
      sub = s.substring(i, i+1);
      utf16 = Integer.toHexString(c+0);
      utf32 = Integer.toHexString(s.charAt(i));
    }
    var utf8Bytes = sub.getBytes("utf-8");
    var utf8BytesStr = "";
    for (var j=0; j<utf8Bytes.length; j++) {
      if (utf8Bytes[j] < 0) {
        utf8BytesStr += Integer.toHexString(utf8Bytes[j]+256);
      } else {
        utf8BytesStr += Integer.toHexString(utf8Bytes[j]);
      }
    }
    println(sub+"\t\t"+utf8BytesStr+"\t\t"+utf16+"\t\t"+utf32);
  }
}
