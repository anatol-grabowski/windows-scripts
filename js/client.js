var fs = require('fs')
var net = require('net')
var path = require('path')
var dns = require('dns')
var os = require('os')

//var http_ip = process.argv[2] || '127.0.0.1'
//var http_port = process.argv[3] || '3000'
var http_ip = process.argv[2] || 'files-grabantot.rhcloud.com'
var http_port = process.argv[3] || '80'

function http_make_req(req_path) {
	return 'GET ' + req_path + ' HTTP/1.1\r\n' +
	'Host: ' + http_ip + '\r\n' +
	'Connection: keep-alive\r\n' +
	'Upgrade-Insecure-Requests: 1\r\n' +
	'User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/55.0.2883.87 Safari/537.36\r\n' +
	'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8\r\n' +
	'Accept-Encoding: gzip, deflate, sdch\r\n' +
	'Accept-Language: en-US,en;q=0.8,ru;q=0.6,es;q=0.4,pl;q=0.2\r\n\r\n'
}
var http_test_socket = new net.Socket()
http_test_socket.connect(http_port, http_ip, function() {
	console.log('http server at ' + http_ip + ':' + http_port)
	//http_test_socket.on('data', (data)=>console.log('\r\n[' + data.toString()) + ']\r\n')
	//http_test_socket.write(http_make_req('/ftp/list?path=/'))
	http_test_socket.end()
})

//================================SERVER PORTION===================
var ftp_ip = '127.0.0.1'
var ftp_port = '1234'
var ftp_server = new net.createServer(function(cmd_socket) {
	var wd = '/'
	var file = ''
	var part_number = 1
	var data_socket = new net.Socket()
	var http_socket = new net.Socket()

	function ftp2http(data) {
		console.log('-->data [' + data.length + ']')
		var boundary = 'tot_' + Math.floor((Math.random()*256*256*256*256)).toString(16)
		var pl_header = '--' + boundary + '\r\n'
		pl_header += 'Content-Disposition: form-data; name="file_part ' + part_number + '"; filename=' + file + '\r\n'
		pl_header += 'Content-Type: application/octet-stream\r\n\r\n'
		var pl_footer = '\r\n--' + boundary + '--\r\n'
		payload = pl_header.length + data.length + pl_footer.length
		var req_header = 'POST /ftp/stor?path=' + wd + ' HTTP/1.1\r\n' +
		'Host: ' + http_ip + '\r\n' +
		'Content-Length: ' + payload + '\r\n'
		'Content-Type: multipart/form-data; boundary=' + boundary + '\r\n\r\n'

		console.log('http--> [' + req_header.length + ' + ' + pl_header.length + ' + ' + data.length + ' + ' + pl_footer.length + ' = ' + (req_header.length + payload) + ', part# ' + part_number + ']')
		http_socket.write(req_header)
		http_socket.write(pl_header)
		http_socket.write(data)
		http_socket.write(pl_footer)
		part_number++
	}

	function http2ftp(data) {
		var header = data.slice(0, data.indexOf('\r\n\r\n')+4)
		if (header.toString(null, 0, 15) != 'HTTP/1.1 200 OK') {
			console.log('http error: ' + data.toString())
			return
		}
		cmd_socket.write('150 Sending... \r\n')
		if (header.indexOf('Transfer-Encoding: chunked') != -1) {
			console.log('-->http [' + data.length + ', first chunk]')
			data = data.slice(header.length)
			while (data.length > 0) {
				var chunk_length = parseInt(data.slice(0, data.indexOf('\r\n')), 16)
				if (chunk_length == 0) {
					cmd_socket.write('226 Sent. \r\n')
					data_socket.end()
					http_socket.end()
					return
				}
				data = data.slice(data.indexOf('\r\n') + 2)
				var chunk = data.slice(0, chunk_length)
				console.log('data--> [chunk ' + chunk.length + ']')
				data_socket.write(chunk)
				data = data.slice(chunk_length + 2)
			}

			http_socket.on('data', function(data) {
				console.log('-->http [' + data.length + ', chunked]')
				while (data.length > 0) {
					var chunk_length = parseInt(data.slice(0, data.indexOf('\r\n')), 16)
					if (chunk_length == 0) {
						cmd_socket.write('226 Sent. \r\n')
						data_socket.end()
						http_socket.removeListener('data', arguments.callee)
						http_socket.end()
						return
					}
					data = data.slice(data.indexOf('\r\n') + 2)
					var chunk = data.slice(0, chunk_length)
					console.log('data--> [chunk ' + chunk.length + ']')
					data_socket.write(chunk)
					data = data.slice(chunk_length + 2)
				}
			})
		} else {
			var bytes_left = header.slice(header.indexOf('Content-Length: '))
			bytes_left = bytes_left.slice(16, bytes_left.indexOf('\r\n'))
			bytes_left = parseInt(bytes_left)
			console.log('-->http [' + data.length + ', total payload: '+ bytes_left + ']')
			console.log('data--> [' + (data.length - header.length) + ']')
			data_socket.write(data.slice(header.length))
			bytes_left -= data.length - header.length
			if (bytes_left <= 0) {
				cmd_socket.write('226 Sent. \r\n')
				data_socket.end()
				http_socket.end()
				return
			}

			http_socket.on('data', function(data) {
				console.log('-->http [' + data.length +', payload left: '+ bytes_left + ']')
				console.log('data--> [' + data.length + ']')
				data_socket.write(data)
				bytes_left -= data.length
				if (bytes_left <= 0) {
					cmd_socket.write('226 Sent. \r\n')
					data_socket.end()
					http_socket.removeListener('data', arguments.callee)
					http_socket.end()
					return
				}
			})
		}
	}

	data_socket.on('error', ()=>console.log('XXXdata error'))
	data_socket.on('connect', function() {
		console.log('o--data connected')
		cmd_socket.write('200 Data socket connected. \r\n')
	})
	data_socket.on('close', ()=>console.log('x--data disconnected'))
	data_socket.on('data', ftp2http)

	http_socket.connected = false
	http_socket.on('error', ()=>console.log('XXXhttp error'))
	http_socket.on('connect', function() {
		console.log('o--http connected')
	})
	http_socket.on('close', function() {
		console.log('x--http disconnected')
	})

	cmd_socket.on('error', ()=>console.log('XXXcmd error'))
	cmd_socket.on('end', ()=>console.log('x--cmd disconnected'))
	cmd_socket.on('data', function(data) {
		data = data.slice(0, data.indexOf('\r\n')).toString()
		var cmd = data.substring(0, data.indexOf(' ')).toUpperCase()
		if (cmd.length == 0) cmd = data.toUpperCase()
		console.log('==>cmd ' + data)
		switch (cmd) {
			case 'USER':
				cmd_socket.write('331 Password required. \r\n')
				break
			case 'PASS':
				cmd_socket.write('230 Login succesfull. \r\n')
				break
			case 'PWD':
				cmd_socket.write('257 ' + wd + ' \r\n')
				break
			case 'PORT':
				var ip = data.substring(cmd.length+1).split(',')
				var port = (ip[4]<<8) | ip[5]
				ip = ip[0] +'.'+ ip[1] +'.'+ ip[2] +'.'+ ip[3]
				data_socket.connect(port, ip)
				break
			case 'LIST':
				console.log(http_socket.writable)
				if (root.l)
					break
				l = true
				if (http_socket.writable) {
					http_socket.once('close', function() {
						http_socket.connect(http_port, http_ip, function() {
							http_socket.once('data', http2ftp)
							http_socket.write(http_make_req('/ftp/list?path=' + wd))
						})
					})
				} else {
					http_socket.connect(http_port, http_ip, function() {
						http_socket.once('data', http2ftp)
						http_socket.write(http_make_req('/ftp/list?path=' + wd))
					})
				}
				break
			case 'RETR':
				var filepath = wd + data.substring(cmd.length+1)
				http_socket.once('data', http2ftp)
				http_socket.connect(http_port, http_ip, function() {
					http_socket.write(http_make_req('/ftp/retr?path='+ filepath))
				})
				break
			case 'STOR':
				data_socket.once('close', function() {
					http_socket.once('close', function() {
						cmd_socket.write('226 Received. \r\n')
					})
					http_socket.end()
				})
				http_socket.connect(http_port, http_ip, function() {
					file = data.substring(cmd.length+1)
					part_number = 1
					cmd_socket.write('150 Ready to receive. \r\n')
				})
				break
			case 'SIZE':
				var filepath = wd + data.substring(cmd.length+1)
				http_socket.once('data', function(data) {
					console.log(data.toString())
					http_socket.end()
					data = data.slice(data.indexOf('\r\n\r\n')+4).toString()
					var size = parseInt(data)
					if (Number.isNaN(size))
						cmd_socket.write('404 ' + data.toString() + ' \r\n')
					else
						cmd_socket.write('213 ' + size + ' \r\n')
				})
				http_socket.connect(http_port, http_ip, function() {
					http_socket.write(http_make_req('/ftp/size?path='+ filepath))
				})
				break
			case 'MKD':
				var filepath = wd + data.substring(cmd.length+1)
				http_socket.connect(http_port, http_ip, function() {
					http_socket.write(http_make_req('/ftp/mkd?path='+ filepath))
					http_socket.end()
					cmd_socket.write('257 Directory created ' + filepath + '. \r\n')
				})
				break
			case 'RMD':
				var filepath = wd + data.substring(cmd.length+1)
				http_socket.connect(http_port, http_ip, function() {
					http_socket.write(http_make_req('/ftp/rmd?path='+ filepath))
					http_socket.end()
					cmd_socket.write('257 Deleted ' + filepath + '. \r\n')
				})
				break
			case 'DELE':
				var filepath = wd + data.substring(cmd.length+1)
				http_socket.connect(http_port, http_ip, function() {
					http_socket.write(http_make_req('/ftp/dele?path='+ filepath))
					http_socket.end()
					cmd_socket.write('257 Deleted ' + filepath + '. \r\n')
				})
				break
			case 'CWD':
				if (data.substring(cmd.length+1)[0] == '/')
					wd = data.substring(cmd.length+1)
				else
					wd += data.substring(cmd.length+1)
				if (wd[wd.length-1] != '/')
					wd += '/'
				cmd_socket.write('250 Ok ' + wd + '. \r\n')
				break
			case 'CDUP':
				wd = path.posix.normalize(wd + '..')
				if (wd[wd.length-1] != '/')
					wd += '/'
				cmd_socket.write('250 Ok ' + wd + '. \r\n')
				break
			case 'RNFR':
				file = wd + data.substring(cmd.length+1)
				cmd_socket.write('350 Ready for RNTO. \r\n')
				break
			case 'RNTO':
				filepath = wd + data.substring(cmd.length+1)
				http_socket.connect(http_port, http_ip, function() {
					console.log('http--> GET /ftp/rnto?path='+ file + '&newname=' + filepath + ' HTTP/1.1')
					http_socket.write(http_make_req('/ftp/rnto?path='+ file + '&newname=' + filepath))
					http_socket.end()
					cmd_socket.write('250 Renamed. \r\n')
				})
				break
			case 'QUIT':
				cmd_socket.write('221 Disconnected by client. \r\n')
				cmd_socket.destroy()
				break
			default:
				cmd_socket.write('202 Command not implemented. \r\n')
		}
	})
	cmd_socket.write('220 Server ready. \r\n')
	console.log('o--cmd connected')
})

ftp_server.listen(ftp_port, ftp_ip)
dns.lookup(os.hostname(), (err, ip, fam)=>console.log('ftp server at '+ ip +':'+ ftp_port))
