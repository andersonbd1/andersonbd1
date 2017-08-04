<?php error_reporting (E_ALL ^ E_NOTICE); ?>
<?php
include 'pinboard-api.php';
$tag = null;
try {
  $tag = $_REQUEST['tag'];
} catch (Exception $e) {
}
if (empty($tag)) {
  $tag = "dtags";
}
$pinboard = new PinboardAPI('andersonbd1', 'andersonbd1:4DEBB6082A92E6F70A14');
$pinbookmarks = $pinboard->get_all(null, null, array($tag));
$innerContent = '';
if (count($pinbookmarks) == 1) {
  header('Location: ' . $pinbookmarks[0]->url );
}
?>
<html>
  <head>
  </head>
  <body>
    <table id="content">
      <?php
      foreach ($pinbookmarks as $pb) {
        $innerContent .= '<tr>';
        $innerContent .= '<td>';
        $tmp = split('/', $pb->url);
        $innerContent .= $tmp[2];
        $innerContent .= '</td>';
        $innerContent .= '<td>';
        $innerContent .= '<a href="' . $pb->url . '" rel="noreferrer">' . $pb->title . '</a><br />';
        $innerContent .= '</td>';
        $innerContent .= '</tr>';
      }
      echo $innerContent;
      ?>
    </table>
  </body>
</html>
