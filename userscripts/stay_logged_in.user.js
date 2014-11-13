// ==UserScript==
// @author      Ben Anderson
// @name        stay_logged_in
// @namespace   http://www.benanderson.us/greasemonkey/favicon
// @include     /https?://beluga/.*/
// @version     1.0
// @grant       none
// ==/UserScript==

function myLog(m) {
  console.info(m);
}
myLog('on');

try {
  var urlToPing = null;
  var host = window.location.host;
  var href = window.location.href;

  if (host.indexOf('url_to_stay_logged_in_to') != -1) {
    urlToPing = 'https://url_to_ping';
  } else if (host.indexOf('beluga') != -1 && host.indexOf('v2') != -1) {
    urlToPing = 'beluga'
  }

  myLog(window.location);
  myLog('host: '+host);
  myLog('href: '+href);
  myLog('urlToPing: '+urlToPing);

  if (urlToPing != null) {
    setTimeout(function(){ping(urlToPing);}, 60000);
  }
} catch (t) {
  myLog(t);
}


function ping(url) {
  try {
    var xmlhttp;
    if (window.XMLHttpRequest) {
      // code for IE7+, Firefox, Chrome, Opera, Safari
      xmlhttp=new XMLHttpRequest();
    } else {
      // code for IE6, IE5
      xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
    }
    xmlhttp.onreadystatechange = function() {
      if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
        setTimeout(function(){ping(url)}, 60000);
      }
    }
    xmlhttp.open("GET", url,true);
    xmlhttp.send();
  } catch (t) {
    myLog(t);
  }
}

