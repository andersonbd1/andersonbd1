<?php error_reporting (E_ALL ^ E_NOTICE); ?>
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
          innerContent += '<a href="'+o.u+'" rel="noreferrer">'+o.d+'</a><br />';
        }
        document.getElementById('content').innerHTML=innerContent;
      }
      YUI().use('get', function (Y) {
        // Get is available and ready for use. Add implementation
        // code here.
        <?
        $tag = null;
        try {
          $tag = $_REQUEST['tag'];
        } catch (Exception $e) {
        }
        if (empty($tag)) {
          $tag = "dtags";
        }
        ?>
        console.log('<?= $tag ?>');
        var transaction = Y.Get.script(
          //'https://api.del.icio.us/v1/json/posts/all?tag=<?= urlencode($tag) ?>&format=json', {
          'http://feeds.delicious.com/v2/json/andersonbd1/<?= urlencode($tag) ?>?callback=go&count=100', {
          onSuccess: function (e) {
          }
        });
      });
    </script>
  </head>
  <body>
    <div id="content" />
  </body>
</html>
