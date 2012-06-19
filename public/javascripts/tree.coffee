beforeDrag = (treeId, treeNodes) ->
  false

beforeEditName = (treeId, treeNode) ->
  className = (if className is "dark" then "" else "dark")
  showLog "[ " + getTime() + " beforeEditName ]&nbsp;&nbsp;&nbsp;&nbsp; " + treeNode.name
  zTree = $.fn.zTree.getZTreeObj("treeDemo")
  zTree.selectNode treeNode
  confirm "Start node '" + treeNode.name + "' editorial status?"

beforeRemove = (treeId, treeNode) ->
  className = (if className is "dark" then "" else "dark")
  showLog "[ " + getTime() + " beforeRemove ]&nbsp;&nbsp;&nbsp;&nbsp; " + treeNode.name
  zTree = $.fn.zTree.getZTreeObj("treeDemo")
  zTree.selectNode treeNode
  confirm "Confirm delete node '" + treeNode.name + "' it?"

onRemove = (e, treeId, treeNode) ->
  showLog "[ " + getTime() + " onRemove ]&nbsp;&nbsp;&nbsp;&nbsp; " + treeNode.name

beforeRename = (treeId, treeNode, newName) ->
  className = (if className is "dark" then "" else "dark")
  showLog "[ " + getTime() + " beforeRename ]&nbsp;&nbsp;&nbsp;&nbsp; " + treeNode.name
  if newName.length is 0
    alert "Node name can not be empty."
    zTree = $.fn.zTree.getZTreeObj("treeDemo")
    setTimeout (->
      zTree.editName treeNode
    ), 10
    return false
  true

onRename = (e, treeId, treeNode) ->
  showLog "[ " + getTime() + " onRename ]&nbsp;&nbsp;&nbsp;&nbsp; " + treeNode.name

showLog = (str) ->
  log = $("#log")  unless log
  log.append "<li class='" + className + "'>" + str + "</li>"
  log.get(0).removeChild log.children("li")[0]  if log.children("li").length > 8

getTime = ->
  now = new Date()
  h = now.getHours()
  m = now.getMinutes()
  s = now.getSeconds()
  ms = now.getMilliseconds()
  h + ":" + m + ":" + s + " " + ms

addHoverDom = (treeId, treeNode) ->
  sObj = $("#" + treeNode.tId + "_span")
  return  if treeNode.editNameFlag or $("#addBtn_" + treeNode.id).length > 0
  addStr = "<span class='button add' id='addBtn_" + treeNode.id + "' title='add node' onfocus='this.blur();'></span>"
  sObj.append addStr
  btn = $("#addBtn_" + treeNode.id)
  if btn
    btn.bind "click", ->
      zTree = $.fn.zTree.getZTreeObj("treeDemo")
      zTree.addNodes treeNode,
        id: (100 + newCount)
        pId: treeNode.id
        name: "new node" + (newCount++)

      false

removeHoverDom = (treeId, treeNode) ->
  $("#addBtn_" + treeNode.id).unbind().remove()

selectAll = ->
  zTree = $.fn.zTree.getZTreeObj("treeDemo")
  zTree.setting.edit.editNameSelectAll = $("#selectAll").attr("checked")

setting =
  view:
    addHoverDom: addHoverDom
    removeHoverDom: removeHoverDom
    selectedMulti: false

  edit:
    enable: true
    editNameSelectAll: true

  data:
    simpleData:
      enable: true

  callback:
    beforeDrag: beforeDrag
    beforeEditName: beforeEditName
    beforeRemove: beforeRemove
    beforeRename: beforeRename
    onRemove: onRemove
    onRename: onRename

zNodes = [
  id: 1
  pId: 0
  name: "root node"
  open: true
 ]

className = "dark"
newCount = 1
$(document).ready ->
  $.fn.zTree.init $("#treeDemo"), setting, zNodes
  $("#selectAll").bind "click", selectAll
