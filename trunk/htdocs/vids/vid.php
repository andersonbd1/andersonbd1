
<?
  //var url = 'http://www.youtube.com/' + empty($_REQUEST['type']) ? 'v' : $_REQUEST['type'] +'/'+ $_REQUEST['id'] +'?rel=1&color1=0x2b405b&color2=0x6b8ab6&border=1&fs=1'
  $type = "v";
  if (!empty($_REQUEST['type'])) {
    $type = $_REQUEST['type'];
  }
  $url = "http://www.youtube.com/".$type."/". $_REQUEST['id']."?loop=1&fs=1&autoplay=1&playlist=".$_REQUEST['id'];
?>

<object width="425" height="355">
  <param name="movie" value="<?= $url ?>"</param>
  <param name="allowFullScreen" value="true"></param>
  <param name="allowScriptAccess" value="always"></param>
  <embed src="<?= $url ?>"
    type="application/x-shockwave-flash"
    allowscriptaccess="always"
    width="425" height="355" 
    allowfullscreen="true"></embed>
</object>

<?
/*
<iframe id="ytplayer" type="text/html" width="640" height="390"
  src="http://www.youtube.com/<?= empty($_REQUEST['type']) ? 'v' : $_REQUEST['type'] ?>/<?= $_REQUEST['id'] ?>?loop=1&fs=1&autoplay=1"
  frameborder="0"/>
*/
?>


<br />
<br />
<br />
id can by an individual video or a playlist
if its a playlist add type=p
