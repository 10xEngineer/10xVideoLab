readURL = (input)->
  reader = new FileReader()
  reader.onload = (e) ->
    $('#previewImage').prop('src',e.target.result)
  reader.readAsDataURL(input.files[0])
window.readURL = readURL

drawCanvas = ->
  text = getNodeText()
  if text ==''
    return

  canvas = document.getElementById("canvas")
  context = canvas.getContext("2d")

  canvas.width = 500
  canvas.height = 375

  context.clearRect(0, 0, canvas.width, canvas.height)

  lingrad = context.createLinearGradient(0,0,canvas.width,canvas.height)
  lingrad.addColorStop(0, '#'+$('#color1').val())
  lingrad.addColorStop(1, '#'+$('#color2').val())

  context.fillStyle = lingrad
  context.fillRect(0,0,canvas.width,canvas.height)

  if $('#previewImage').prop('src')
    img = new Image
    img.src =$('#previewImage').prop('src')
    context.drawImage(img,0,0,canvas.width,canvas.height)

  context.textAlign="center"
  context.font = $('#fontSize').val()+'pt '+$('#fontFamily').val()
  context.fillStyle = '#'+$('#fontColor').val()
  context.fillText(text, canvas.width/2, 150)

getNodeText = ->
  zTree = $.fn.zTree.getZTreeObj("treeDemo")
  nodes = zTree.getSelectedNodes()
  if nodes.length<1
    alert 'please select a node first'
    ''
  else
    nodes[0].name
$ ->
  $('#previewButton').click ->
      drawCanvas()