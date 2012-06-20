Canvas = require 'canvas'
Image = Canvas.Image
exec = require('child_process').exec
fs = require 'fs'

createImage = (req,node,i,taskId,cb)->
  canvas = new Canvas(600,450)
  context = canvas.getContext('2d')

  context.clearRect(0, 0, canvas.width, canvas.height)

  lingrad = context.createLinearGradient(0,0,canvas.width,canvas.height)
  lingrad.addColorStop(0, '#'+req.body.gradientColor1)
  lingrad.addColorStop(1, '#'+req.body.gradientColor2)
  console.log 'longrad'
  context.fillStyle = lingrad
  context.fillRect(0,0,canvas.width,canvas.height)

  console.log 'before image '
  if req.files.backgroundImage.size > 0
    file = fs.readFileSync(req.files.backgroundImage.path)
    console.log file
    img = new Image
    img.src = file
    context.drawImage(img,0,0,canvas.width,canvas.height)

  console.log 'after image'
  context.textAlign="center"
  context.font = req.body.fontSize+'pt '+req.body.fontFamily
  context.fillStyle = '#'+req.body.fontColor
  context.fillText(node.name, canvas.width/2, 150)

  out=fs.createWriteStream(__dirname+'/../public/tasks/'+taskId+'/'+i+'.png')
  stream=canvas.createPNGStream()

  console.log 'before save'
  stream.on 'data',(chunk)->
    out.write chunk
  stream.on 'end', ->
    console.log 'save '+__dirname+'/../public/tasks/'+taskId+'/'+i+'.png done'
    cb 'save '+__dirname+'/../public/tasks/'+taskId+'/'+i+'.png done'
  console.log 'after save'

exports.index = (req, res) ->
  res.render "index",
    title: "10xVideoLab"

exports.generateVideo = (req,res) ->
  chapterNodes = JSON.parse(req.body.chapterNodes)
  console.log req.files

  taskId = Date.now()
  fs.mkdir __dirname+'/../public/tasks/'+taskId,'0777'

  out = []
  await
    for node,i in chapterNodes
      console.log i
      createImage req,node,i,taskId,defer out[i]
  console.log out

  command = 'cd '+__dirname+'/../public/tasks/'+taskId+';ffmpeg -f image2 -r 1  -i %d.png video.mp4'
  console.log command
  exec command,(error,result)->
    console.log result
    if error
      console.log error
      res.send 409,error.message
    else
      res.render "video",
        title: "10xVideoLab"
        video: '/tasks/'+taskId+'/video.mp4'