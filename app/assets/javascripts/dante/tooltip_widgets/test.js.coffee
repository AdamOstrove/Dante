window.mapWidget = Dante.View.TooltipWidget.extend({

  initialize: (opts={})->
    #super
    @icon        = opts.icon  || "icon-map"
    @title       = opts.title || "This is just a test widget"
    @action      = opts.action || "fakeAction"
    @current_editor = opts.current_editor
    @map_placeholder = "<span class='defaultValue defaultValue--prompt'>Enter an Address for a Map</span><br>"

  handleClick: (ev)->
    @displayMapPlaceHolder(ev)

  displayMapPlaceHolder: ()->
    ph = @map_placeholder
    @node = @current_editor.getNode()
    $(@node).html(ph).addClass("is-mappable")

    @current_editor.setRangeAt(@node)
    @hide()
    false
})
