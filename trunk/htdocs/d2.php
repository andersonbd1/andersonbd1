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
        for (var i=0; i<a.length; i++) {
          innerContent += '<a href="'+a[i].u+'">'+a[i].d+'</a><br />';
        }
        document.getElementById('content').innerHTML=innerContent;
      }
      YUI().use('get', function (Y) {
        // Get is available and ready for use. Add implementation
        // code here.
        var transaction = Y.Get.script(
          'http://feeds.delicious.com/v2/json/andersonbd1/<?= $_REQUEST['tag'] ?>?callback=go&count=100', {
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
