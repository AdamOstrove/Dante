widgets = {}
config = Dante.config

window.Dante.widgets = widgets
widgets.registeredWidgets = []


widgets.register = (widget)->

  @registeredWidgets.push(widget)


# Remove widgets from registered widgets if they are not listed in config.buttons (buttons to be shown to end users)  
widgets.initialize = (widgetNames) ->
  widgetNames = Dante.config.buttons
  for registeredWidget in @registeredWidgets
    if registeredWidget.name not in widgetNames
      @registeredWidgets.splice(@registeredWidgets.indexOf(registeredWidget), 1 )
