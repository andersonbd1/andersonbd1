// ==UserScript==
// @author      Ben Anderson
// @name        favicon
// @namespace   http://www.benanderson.us/greasemonkey/favicon
// @include     https://www.google.com/*
// @include     /https?://easel.thomson.com/.*/
// @include     /^https?://v2[^/]*taxnetpro.com/.*/
// @include     /^https?://nsawiki.*/
// @include     /^https?://theshare.thomsonreuters.com/.*/
// @include     /^https?://v3.(ci|demo).taxnetpro.com/.*/
// @version     1.0
// @grant       none
// ==/UserScript==

function myLog(m) {
  console.info(m);
}
myLog('on');

try {
  var newFavIcon = null;
  var host = window.location.host;
  var href = window.location.href;

  if (host.indexOf('easel') != -1) {
    newFavIcon = 'http://eddiebauer.com/favicon.ico';
  } else if (host.indexOf('taxnetpro.com') != -1 && host.indexOf('v2') != -1) {
    newFavIcon = 'http://www.tampabay.com/favicon.ico';
  } else if (host.indexOf('nsawiki') != -1) {
    newFavIcon = 'http://www.nsa.gov/_root/images/favicon.gif';
  } else if (href.indexOf('OpsLinks') != -1) {
    //newFavIcon = 'http://www.goarmy.com/static/images/favicon.ico';
    newFavIcon = 'http://www.socom.mil/favicon.ico';
  } else if (host.indexOf('v3.ci.taxnetpro') != -1) {
    //newFavIcon = 'http://www.ci-support.com/favicon.ico';
    newFavIcon = 'http://gd.benanderson.us/img/tnp-ci.ico'
  } else if (host.indexOf('v3.demo.taxnetpro') != -1) {
    newFavIcon = 'http://gd.benanderson.us/img/tnp-demo.ico'
  } else if (host.indexOf('next.ci.westlaw') != -1) {
    newFavIcon = 'http://gd.benanderson.us/img/wln-ci.ico'
  } else if (host.indexOf('next.demo.westlaw') != -1) {
    newFavIcon = 'http://gd.benanderson.us/img/wln-demo.ico'
  } else if (host.indexOf('v3.demo.taxnetpro') != -1) {
    newFavIcon = 'http://www.demo-africa.com/design/demo/images/favicon.ico';
  }

  myLog(window.location);
  myLog('host: '+host);
  myLog('href: '+href);
  myLog('newFavIcon: '+newFavIcon);

  if (newFavIcon != null) {
    var favicon_link_html = document.createElement('link');
    favicon_link_html.rel = 'icon';
    favicon_link_html.href = newFavIcon
    favicon_link_html.type = 'image/x-icon';
    document.getElementsByTagName('head')[0].appendChild( favicon_link_html );
  }
} catch (t) {
  myLog(t);
}

