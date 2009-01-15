if (arguments.length != 4) {
  println('');
  println('usage:');
  println('\tjava org.mozilla.javascript.tools.shell.Main send_msg.js <from_user> <from_password> <to_user> <msg>');
  println('');
  println('notes:');
  println('\tmake sure js.jar, smack.jar, and smackx.jar are on the CLASSPATH');
  println('\tmake sure that the gmail users have been enabled to communicate with each other');
  println('');
  println('cygwin tip:');
  println('\texport CLASSPATH=/cygdrive/c/java/rhino1_7R1/js.jar:/cygdrive/c/java/smack_3_0_4/smack.jar');
  println('\tjava -classpath `cygpath -wp $CLASSPATH` org.mozilla.javascript.tools.shell.Main send_msg.js');
  println('');
} else {
try {
    var config = new org.jivesoftware.smack.ConnectionConfiguration("talk.google.com", 5222, "gmail.com");
    //var config = new org.jivesoftware.smack.ConnectionConfiguration("jabber.org");
    var conn = new org.jivesoftware.smack.XMPPConnection(config);
    conn.connect();
    conn.login(arguments[0], arguments[1]);

    var chatmanager = conn.getChatManager();
    var newChat = conn.getChatManager().createChat(arguments[2], 
      function(chat, msg) {print(msg.getBody())});
    
    newChat.sendMessage(arguments[3]);
  } catch (e) {
    print("Error Delivering block");
  }
}
