#!/usr/bin/env node

var http = require('http');

http.createServer(function (req, res) {
	res.writeHead(200, {'Content-Type': 'text/plain'});
	res.end("you got node\n");
}).listen(2011);
