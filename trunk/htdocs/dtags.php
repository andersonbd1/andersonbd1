<html>
  <head>
    <script src="http://yui.yahooapis.com/3.4.1/build/yui/yui-min.js"></script>
    <script>
      // Create a new YUI instance and populate it with the required modules.
      function go(a) {
        console.log(a);
        var innerContent = '';
        if (a.length == 1) {
          window.location = a[0].u;
        }
        var sortedKeys = [];
        var sortedKeysIdx=0;
        var sortedKey2idx = {};
        for (var k in a) {
          sortedKey2idx[k.toUpperCase()] = k;
          sortedKeys[sortedKeysIdx++] = k.toUpperCase();
        }
        sortedKeys.sort();
        //for (var k in a) {
        for (var i=0; i<sortedKeys.length; i++) {
          k = sortedKey2idx[sortedKeys[i]];
          innerContent += '<a href="d2.php?tag='+k+'">'+k+': '+a[k]+'</a><br />';
        }
        document.getElementById('content').innerHTML=innerContent;
      }
      YUI().use('get', function (Y) {
        // Get is available and ready for use. Add implementation
        // code here.
        var transaction = Y.Get.script(
          'http://feeds.delicious.com/v2/json/tags/andersonbd1?callback=go', {
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
