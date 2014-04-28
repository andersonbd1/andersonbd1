<?php error_reporting (E_ALL ^ E_NOTICE); ?>
<?
$setid = null;
try {
  $setid = $_REQUEST['setid'];
} catch (Exception $e) {
}
if (strlen($setid) < 1 || $setid == null) {
?>
Get the setid from one of the flick urls.  For example:
<pre>
http:/www.flickr.com/photos/benanderson/9210242463/
</pre>

You see that id at the end?  Grab that number and plug it into this url like this:
<pre>
http://gd.benanderson.us/flickr.php?setid=72157634490833516
</pre>
<?
} else {
?>
<textarea rows="10" cols="80">
<object width="500" height="375"> <param name="flashvars" value="offsite=true&lang=en-us&page_show_url=%2Fphotos%2Fbenanderson%2Fsets%2F<?= $setid?>%2Fshow%2F&page_show_back_url=%2Fphotos%2Fbenanderson%2Fsets%2F<?= $setid?>%2F&set_id=<?= $setid?>&jump_to="></param> <param name="movie" value="http://www.flickr.com/apps/slideshow/show.swf?v=124984"></param> <param name="allowFullScreen" value="true"></param><embed type="application/x-shockwave-flash" src="http://www.flickr.com/apps/slideshow/show.swf?v=124984" allowFullScreen="true" flashvars="offsite=true&lang=en-us&page_show_url=%2Fphotos%2Fbenanderson%2Fsets%2F<?= $setid?>%2Fshow%2F&page_show_back_url=%2Fphotos%2Fbenanderson%2Fsets%2F<?= $setid?>%2F&set_id=<?= $setid?>&jump_to=" width="500" height="375"></embed></object>
</textarea>
<? } ?>

