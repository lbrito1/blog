console.log("Hello! Not to worry, I'm just getting the userAgent, location and IP for this request. You can check the code yourself at https://github.com/lbrito1/sane-tracker-js. Happy coding!")
const HOSTNAME = "https://android-analytics.duckdns.net/"

function sane_track() {
  debugger
  fetch(HOSTNAME, {
    body: "userAgent=" + navigator.userAgent + "&url=" + window.location,
    headers: { "Content-Type": "application/x-www-form-urlencoded" },
    method: "POST"
  })
}
