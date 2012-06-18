express = require 'express'
stylus = require 'stylus'
assets = require 'connect-assets'

app = express()
app.use assets()
app.set 'view engine', 'jade'

app.get '/', (req, resp) ->
	Canvas = require('canvas')
	canvas = new Canvas(150, 150)
	ctx = canvas.getContext('2d')
	fs = require('fs')

	ctx.fillRect(0,0,150,150)
	ctx.save()

	ctx.fillStyle = '#09F'
	ctx.fillRect(15,15,120,120)

	ctx.save()
	ctx.fillStyle = '#FFF'
	ctx.globalAlpha = 0.5
	ctx.fillRect(30,30,90,90)

	ctx.restore()
	ctx.fillRect(45,45,60,60)

	ctx.restore()
	ctx.fillRect(60,60,30,30)

	out = fs.createWriteStream(__dirname + '/state.png')
	stream = canvas.createPNGStream();

	stream.on 'data', (chunk)->
		out.write(chunk);

	resp.send '<img src="' + canvas.toDataURL() + '" />'
	#resp.render 'index'

app.listen process.env.VMC_APP_PORT or 3000, -> console.log 'Listening...'