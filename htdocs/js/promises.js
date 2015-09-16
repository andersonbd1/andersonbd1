// Make an async HTTP request
var async = true;
var xhr = new XMLHttpRequest();
xhr.open('get', 'data.json', async);
xhr.send();

// Create a three second delay (don't do this in real life)
var timestamp = Date.now() + 3000;
while (Date.now() < timestamp);

// Now that three seconds have passed,
// add a listener to the xhr.load and xhr.error events
function listener() {
    console.log('greetings from listener');
}
xhr.addEventListener('load', listener);
xhr.addEventListener('error', listener);


loadImage('test.png',
    function onsuccess(img) {
        // Add the image to the current web page
        document.body.appendChild(img);
    },
    function onerror(e) {
        console.log('Error occurred while loading image');
        console.log(e);
    }
);

function loadImage(url, success, error) {
    var img = new Image();
    img.src = url;

    img.onload = function () {
        success(img);
    };

    img.onerror = function (e) {
        error(e);
    };
}
