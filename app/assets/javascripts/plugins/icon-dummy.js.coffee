utils  = Dante.utils
config = Dante.config

dummyWidget = {}

dummyWidget.name = "icon-dummy"

dummyWidget.icon = "icon-dummy"

dummyWidget.title = "Add a dummy"

dummyWidget.action = "dummy" 

displayDummyText = ()->
  $paragraph = $("<p></p>")
  Dante.Editor.prototype.addClassesToElement($paragraph[0])
  $paragraph.html("This is some dummy text").attr("name", utils.generateUniqueName())
  $(".is-selected").replaceWith($paragraph)
  Dante.Editor.prototype.setRangeAt($paragraph[0])


dummyWidget.actionEvent = displayDummyText

Dante.widgets.register(dummyWidget)