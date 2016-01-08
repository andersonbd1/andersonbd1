<?php error_reporting (E_ALL ^ E_NOTICE); ?>
<?php
$tag = null;
try {
  $tag = $_REQUEST['tag'];
} catch (Exception $e) {
}
if (empty($tag)) {
  $tag = "dtags";
}
/*
echo substr_compare("abcde", "bc", 1, 2); // 0
echo substr_compare("abcde", "de", -2, 2); // 0
echo substr_compare("abcde", "bcg", 1, 2); // 0
echo substr_compare("abcde", "BC", 1, 2, true); // 0
echo substr_compare("abcde", "bc", 1, 3); // 1
echo substr_compare("abcde", "cd", 1, 2); // -1
echo substr_compare($tag, "vids ", 0, 5);
 */
//echo substr_compare("abcde", "abc", 5, 1); // warning

//if (strlen($tag) >= 5) {
if (strlen($tag) > 4 && 0 == substr_compare($tag, "vid ", 0, 4)) {
  header( 'Location: http://gd.benanderson.us/vids/vid.php?id=' . substr($tag, 4) );
?>
<?php
} else if (strlen($tag) > 2 && 0 == substr_compare($tag, "lws ", 0, 3)) {
  $st = 'StaticContent_17.4.249';
  $url = 'Location: http://10.222.128.36.ip.next.ci.westlaw.com/routing';
  $url = $url . '?Css=c1.next.ci.westlaw.com/' . $st;
  $url = $url . '&CssInternal=css.next.ci.westlaw.com/' . $st;
  $url = $url . '&Images=i1.next.ci.westlaw.com/' . $st;
  $url = $url . '&ImagesInternal=images.next.ci.westlaw.com/' . $st;
  $url = $url . '&JavaScript=j1.next.ci.westlaw.com/' . $st;
  $url = $url . '&JavaScriptInternal=javascript.next.ci.westlaw.com/' . $st;
  header($url);
} else {
?>
<html>
  <head>
    <script src="http://yui.yahooapis.com/3.4.1/build/yui/yui-min.js"></script>
    <script>
      // Create a new YUI instance and populate it with the required modules.
      function go(a) {
        var innerContent = '';
        if (a.length == 1) {
          window.location = a[0].u;
        }
        var sortedKeys = [];
        var sortedKeysIdx=0;
        var sortedKey2idx = {};
        for (var k in a) {
          var key = a[k].d.toUpperCase();
          sortedKeys[sortedKeysIdx] = key
          sortedKey2idx[key] = sortedKeysIdx;
          sortedKeysIdx++;
        }
        sortedKeys.sort();
        console.log(sortedKeys);
        console.log(sortedKey2idx);
        //for (var i=0; i<a.length; i++) {
        for (var i=0; i<sortedKeys.length; i++) {
          k = sortedKeys[i];
          console.log('i: '+i);
          console.log('k: '+k);
          var o = a[sortedKey2idx[k]];
          console.log(o.u);
          console.log(o.u.split('/'));
          console.log('beluga');
          innerContent += '<tr>';
          innerContent += '<td>';
          innerContent += o.u.split('/')[2]
          innerContent += '</td>';
          innerContent += '<td>';
          innerContent += '<a href="'+o.u+'" rel="noreferrer">'+o.d+'</a><br />';
          innerContent += '</td>';
          innerContent += '</tr>';
        }
        console.log(innerContent);
        document.getElementById('content').innerHTML=innerContent;
      }
      YUI().use('get', function (Y) {
        // Get is available and ready for use. Add implementation
        // code here.
        console.log('<?= $tag ?>');
        var transaction = Y.Get.script(
          //'https://api.del.icio.us/v1/json/posts/all?tag=<?= urlencode($tag) ?>&format=json', {
          //'http://feeds.delicious.com/v2/json/andersonbd1/<?= urlencode($tag) ?>?callback=go&count=100', {
          'http://previous.delicious.com/v2/json/andersonbd1/<?= urlencode($tag) ?>?callback=go&count=100', {
          onSuccess: function (e) {
          }
        });
      });
    </script>
  </head>
  <body>
    <table id="content">
    </table>
  </body>
</html>
<?php
}
?>
