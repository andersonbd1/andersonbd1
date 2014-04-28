// ==UserScript==
// @author      Ben Anderson
// @name        stay_logged_in
// @namespace   http://www.benanderson.us/greasemonkey/favicon
// @include     /https?://easel.thomson.com/.*/
// @include     /^https?://v2[^/]*taxnetpro.com/.*/
// @include     /^https?://v3.(ci|demo).taxnetpro.com/.*/
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

  if (host.indexOf('easel') != -1) {
    urlToPing = 'https://easel.thomson.com/easel/ViewOnlyAccess.do';
  } else if (host.indexOf('taxnetpro.com') != -1 && host.indexOf('v2') != -1) {
    urlToPing = 'http://v2.taxnetpro.com/welcome/tnpHome/default.wl?errhost=EG-CHMLN-B54&fn=_top&MT=tnpHome&rs=TNPR14.04&ssl=y&strrecreate=no&sv=Split&vr=2.0'
  } else if (host.indexOf('nsawiki') != -1) {
  } else if (href.indexOf('OpsLinks') != -1) {
  } else if (host.indexOf('v3.ci.taxnetpro') != -1) {
  } else if (host.indexOf('v3.demo.taxnetpro') != -1) {
  } else if (host.indexOf('next.ci.westlaw') != -1) {
  } else if (host.indexOf('next.demo.westlaw') != -1) {
  } else if (host.indexOf('v3.demo.taxnetpro') != -1) {
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

