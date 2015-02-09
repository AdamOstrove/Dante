utils  = Dante.utils
config = Dante.config
videoWidget = {}

videoWidget.name = "icon-video"

videoWidget.icon = "icon-video"

videoWidget.title = "Add an video"

videoWidget.action = "video"

displayEmbedPlaceHolder = ()->
  current_editor = config.current_editor
  utils.log(current_editor)
  ph = current_editor.embed_placeholder
  @node = current_editor.getNode()
  $(@node).html(ph).addClass("is-embedable")

  current_editor.setRangeAt(@node)
  false

videoWidget.actionEvent = displayEmbedPlaceHolder

$(Dante.Editor).on("keydown", (e) =>
  utils.log("THIS IS INSIDE OF THE VIDEO WIDGET")

  # utils.log(Dante.Editor.getNode)

  utils.log("THE ANCHOR NODE IS: ")

  anchor_node = Dante.Editor.prototype.getNode() #current node on which cursor is positioned
  parent = $(anchor_node)

  utils.log(anchor_node)

#   #embeds or extracts
#   if parent.hasClass("is-embedable")
#     Dante.Editor.tooltip_view.getEmbedFromNode($(anchor_node))
#   else if parent.hasClass("is-extractable")
#     Dante.Editor.tooltip_view.getExtractFromNode($(anchor_node))

#   #supress linebreak into embed page text unless last char
#   if parent.hasClass("graf--mixtapeEmbed") or parent.hasClass("graf--iframe") or parent.hasClass("graf--figure")
#     utils.log("supress linebreak from embed !(last char)")
#     return false unless Dante.Editor.isLastChar()

#   #supress linebreak or create new <p> into embed caption unless last char el
#   if parent.hasClass("graf--iframe") or parent.hasClass("graf--figure")
#     if Dante.Editor.isLastChar()
#       Dante.Editor.handleLineBreakWith("p", parent)
#       Dante.Editor.setRangeAtText($(".is-selected")[0])

#       $(".is-selected").trigger("mouseup") #is not making any change
#       return false
#     else
#       return false
)

Dante.widgets.register(videoWidget)