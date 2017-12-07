
<?php
  //http://www.infinitelooper.com/?v=Q2yu13-m-eE&p=n#/44;56
  //var url = 'http://www.youtube.com/' + empty($_REQUEST['type']) ? 'v' : $_REQUEST['type'] +'/'+ $_REQUEST['id'] +'?rel=1&color1=0x2b405b&color2=0x6b8ab6&border=1&fs=1'
  $type = "v";
  if (!empty($_REQUEST['type'])) {
    /*
    if ($_REQUEST['type'] == 'p') {
      $type = 'embed/'
    }
     */
    $type = $_REQUEST['type'];
  }
  $url = "http://www.youtube.com/".$type."/".$_REQUEST['id']."?enablejsapi=1&version=3&playerapiid=ytplayer&autoplay=1&loop=1&rel=0&fs=1&modestbranding=1&iv_load_policy=3&list=".$_REQUEST['id'];

  if (!empty($_REQUEST['start'])) {
    $url = $url . "&start=" . $_REQUEST['start'];
  }
  if (!empty($_REQUEST['end'])) {
    $url = $url . "&end=" . $_REQUEST['end'];
  }
?>
<iframe width="560" height="315" src="https://www.youtube.com/embed/EfLhhmeD5PU?loop=1&fs=1&autoplay=1" frameborder="0" allowfullscreen></iframe>
<!--
<iframe width="560" height="315" src="https://www.youtube.com/embed/jjn3fBTvBjY?list=PLFyz_VaHKmUll1kCZN4sCfbTeLR12dyqq&loop=1&fs=1&autoplay=1" frameborder="0" allowfullscreen></iframe>
-->
<!--
<iframe width="560" height="315" src="https://www.youtube.com/embed/jjn3fBTvBjY?list=PLFyz_VaHKmUll1kCZN4sCfbTeLR12dyqq" frameborder="0" allowfullscreen></iframe>
  <embed src="http://www.youtube.com/embed/jjn3fBTvBjY?enablejsapi=1&version=3&playerapiid=ytplayer&autoplay=1&loop=1&rel=0&fs=1&modestbranding=1&iv_load_policy=3&list=PLFyz_VaHKmUll1kCZN4sCfbTeLR12dyqq"
-->

<!--
<object width="425" height="355">
  <param name="movie" value="<?= $url ?>"</param>
  <param name="allowFullScreen" value="true"></param>
  <param name="allowScriptAccess" value="always"></param>
  <embed src="https://www.youtube.com/embed/jjn3fBTvBjY?list=PLFyz_VaHKmUll1kCZN4sCfbTeLR12dyqq"
    type="application/x-shockwave-flash"
    allowscriptaccess="always"
    width="425" height="355" 
    allowfullscreen="true"></embed>
</object>
-->

<object width="425" height="355">
  <param name="movie" value="<?= $url ?>"</param>
  <param name="allowFullScreen" value="true"></param>
  <param name="allowScriptAccess" value="always"></param>
  <embed src="https://www.youtube.com/embed/EfLhhmeD5PU"
    type="application/x-shockwave-flash"
    allowscriptaccess="always"
    width="425" height="355" 
    allowfullscreen="true"></embed>
</object>

<?php
/*
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


<!--
<object width="640" height="385" type="application/x-shockwave-flash" id="youtubePlayer" data="http://www.youtube.com/v/Q2yu13-m-eE?enablejsapi=1&amp;version=3&amp;playerapiid=ytplayer&amp;autoplay=1&amp;loop=1&amp;rel=0&amp;fs=1&amp;modestbranding=1&amp;iv_load_policy=3" style="visibility: visible;"><param name="allowScriptAccess" value="always"><param name="allowfullscreen" value="true"></object>
-->
