drawCanvas = (text) ->
  canvas = document.getElementById("canvas")
  context = canvas.getContext("2d")
  context.clearRect(0, 0, canvas.width, canvas.height)

  lingrad = context.createLinearGradient(0,0,canvas.width,canvas.height)
  lingrad.addColorStop(0, '#000000')
  # lingrad.addColorStop(0.5, '#fff')
  # lingrad.addColorStop(0.5, '#66CC00')
  lingrad.addColorStop(1, '#ffffff')
  context.fillStyle = lingrad
  context.fillRect(0,0,canvas.width,canvas.height)

  context.font = "20pt Calibri"
  context.fillStyle = "blue"
  context.fillText(text, 150, 100)

$ ->
  $('#previewButton').click ->
    zTree = $.fn.zTree.getZTreeObj("treeDemo")
    nodes = zTree.getSelectedNodes()
    if nodes.length<1
      alert 'please select a node first'
    else
      nodeName = nodes[0].name
      drawCanvas nodeName