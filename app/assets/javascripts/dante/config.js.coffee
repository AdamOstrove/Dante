utils = Dante.utils

config = {}

window.Dante.config = config
 
config.initialize = (opts ={})->
  utils.log(opts)
  @el = opts.el || "#editor"
  @upload_url      = opts.upload_url  || "/uploads.json"
  @oembed_url      = opts.oembed_url  || "http://api.embed.ly/1/oembed?url="
  @extract_url     = opts.extract_url || "http://api.embed.ly/1/extract?key=86c28a410a104c8bb58848733c82f840&url="
  @default_loading_placeholder = opts.default_loading_placeholder || Dante.defaults.image_placeholder
  @store_url       = opts.store_url
  @spell_check     = opts.spellcheck || false
  @disable_title   = opts.disable_title || false
  @store_interval  = opts.store_interval || 15000
  @editor_options  = opts
  window.debugMode = opts.debug || false
  
  utils.log @

  # Users list the names of the widgets to be displayed in the tooltip. 
  @buttons = [ "icon-image", "icon-video" ]