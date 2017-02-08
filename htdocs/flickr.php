<?php error_reporting (E_ALL ^ E_NOTICE); ?>
<?php
$setid = null;
$user = null;
try {
  $setid = $_REQUEST['setid'];
  $user = $_REQUEST['user'];
  $vparam = $_REQUEST['v'];
} catch (Exception $e) {
}
if (strlen($user) < 1 || $user == null) {
  $user = 'benanderson';
}
if (strlen($vparam) < 1 || $vparam == null) {
  $user = '124984';
}
?>
Get the setid from a flick url.  For example:
<pre>
http:/www.flickr.com/photos/benanderson/9210242463/
</pre>

You see that id at the end?  Grab that number and plug it into this url like this:
<pre>
http://gd.benanderson.us/flickr.php?setid=9210242463
</pre>
You can also add a user param (it defaults to benanderson if none is provided)
<br />
<br />
<?php
if (strlen($setid) < 1 || $setid == null) {
} else {
?>
<textarea rows="10" cols="80">
<object width="500" height="375"> <param name="flashvars" value="offsite=true&lang=en-us&page_show_url=%2Fphotos%2F<?= $user ?>%2Fsets%2F<?= $setid?>%2Fshow%2F&page_show_back_url=%2Fphotos%2F<?= $user ?>%2Fsets%2F<?= $setid?>%2F&set_id=<?= $setid?>&jump_to="></param> <param name="movie" value="http://www.flickr.com/apps/slideshow/show.swf?v=<?= $vparam ?>"></param> <param name="allowFullScreen" value="true"></param><embed type="application/x-shockwave-flash" src="http://www.flickr.com/apps/slideshow/show.swf?v=<?= $vparam ?>" allowFullScreen="true" flashvars="offsite=true&lang=en-us&page_show_url=%2Fphotos%2F<?= $user ?>%2Fsets%2F<?= $setid?>%2Fshow%2F&page_show_back_url=%2Fphotos%2F<?= $user ?>%2Fsets%2F<?= $setid?>%2F&set_id=<?= $setid?>&jump_to=" width="500" height="375"></embed></object>
</textarea>

<?php } 

/*
<object width="400" height="300">
	<param name="flashvars" value="offsite=true&lang=en-us&page_show_url=%2Fphotos%2F{USERNAME}%2Fsets%2F{SET_ID}%2Fshow%2F&page_show_back_url=%2Fphotos%2F{USERNAME}%2Fsets%2F{SET_ID}%2F&set_id={SET_ID}&jump_to="></param>
	<param name="movie" value="http://www.flickr.com/apps/slideshow/show.swf?v=71649"></param>
	<param name="allowFullScreen" value="true"></param>
	<embed type="application/x-shockwave-flash" src="http://www.flickr.com/apps/slideshow/show.swf?v=71649" allowFullScreen="true" flashvars="offsite=true&lang=en-us&page_show_url=%2Fphotos%2F{USERNAME}%2Fsets%2F{SET_ID}%2Fshow%2F&page_show_back_url=%2Fphotos%2F{USERNAME}%2Fsets%2F{SET_ID}%2F&set_id={SET_ID}&jump_to=" width="400" height="300"></embed>
</object>
*/
?>

<br />
<br />
<object width="500" height="375"> <param name="flashvars" value="offsite=true&lang=en-us&page_show_url=%2Fphotos%2F<?= $user ?>%2Fsets%2F<?= $setid?>%2Fshow%2F&page_show_back_url=%2Fphotos%2F<?= $user ?>%2Fsets%2F<?= $setid?>%2F&set_id=<?= $setid?>&jump_to="></param> <param name="movie" value="http://www.flickr.com/apps/slideshow/show.swf?v=<?= $vparam ?>"></param> <param name="allowFullScreen" value="true"></param><embed type="application/x-shockwave-flash" src="http://www.flickr.com/apps/slideshow/show.swf?v=<?= $vparam ?>" allowFullScreen="true" flashvars="offsite=true&lang=en-us&page_show_url=%2Fphotos%2F<?= $user ?>%2Fsets%2F<?= $setid?>%2Fshow%2F&page_show_back_url=%2Fphotos%2F<?= $user ?>%2Fsets%2F<?= $setid?>%2F&set_id=<?= $setid?>&jump_to=" width="500" height="375"></embed></object>
