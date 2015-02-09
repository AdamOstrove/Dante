utils = Dante.utils

imageWidget = {}

imageWidget.name = "icon-image"

imageWidget.icon = "icon-image"

imageWidget.title = "Add an image"

imageWidget.action = "image"

imageSelect = (ev)->
  @placeholder = "<p>PLACEHOLDER</p>"
  $selectFile = $('<input type="file" multiple="multiple">').click()
  self = @
  $selectFile.change ()->
    t = this
    self.uploadFiles(t.files)
    

imageWidget.actionEvent = imageSelect
    
imageWidget.uploadFiles = (files)=>
  acceptedTypes =
    "image/png": true
    "image/jpeg": true
    "image/gif": true

  i = 0
  while i < files.length
    file = files[i]
    if acceptedTypes[file.type] is true
      $(@placeholder).append "<progress class=\"progress\" min=\"0\" max=\"100\" value=\"0\">0</progress>"
      @displayAndUploadImages(file)
    i++

imageWidget.displayAndUploadImages = (file)->
  @displayCachedImage file
  

imageWidget.displayCachedImage = (file)->
  @current_editor.tooltip_view.hide()

  reader = new FileReader()
  reader.onload = (e)=>
    img = new Image
    img.src = e.target.result
    node = @current_editor.getNode()
    self = this
    img.onload = ()->
      new_tmpl = $(self.insertTemplate())

      replaced_node = $( new_tmpl ).insertBefore($(node))

      img_tag = new_tmpl.find('img.graf-image').attr('src', e.target.result)
      img_tag.height = this.height
      img_tag.width  = this.width

      utils.log "UPLOADED SHOW FROM CACHE"

      ar = self.getAspectRatio(this.width, this.height)

      replaced_node.find(".aspectRatioPlaceholder").css
        'max-width': ar.width
        'max-height': ar.height

      replaced_node.find(".graf-image").attr
        "data-height": this.height
        "data-width": this.width

      replaced_node.find(".aspect-ratio-fill").css
        "padding-bottom": "#{ar.ratio}%"

      self.uploadFile file, replaced_node

  reader.readAsDataURL(file)
  
imageWidget.insertTemplate = ()->
  "<figure contenteditable='false' class='graf graf--figure is-defaultValue' name='#{utils.generateUniqueName()}' tabindex='0'>
    <div style='' class='aspectRatioPlaceholder is-locked'>
      <div style='padding-bottom: 100%;' class='aspect-ratio-fill'></div>
      <img src='' data-height='' data-width='' data-image-id='' class='graf-image' data-delayed-src=''>
    </div>
    <figcaption contenteditable='true' data-default-value='Type caption for image (optional)' class='imageCaption'>
      <span class='defaultValue'>Type caption for image (optional)</span>
      <br>
    </figcaption>
  </figure>"
    
    
imageWidget.getAspectRatio = (w , h)->
  maxWidth = 700
  maxHeight = 700
  ratio = 0
  width = w # Current image width
  height = h # Current image height

  # Check if the current width is larger than the max
  if width > maxWidth
    ratio = maxWidth / width # get ratio for scaling image
    height = height * ratio # Reset height to match scaled image
    width = width * ratio # Reset width to match scaled image

  # Check if current height is larger than max
  else if height > maxHeight
    ratio = maxHeight / height # get ratio for scaling image
    width = width * ratio # Reset width to match scaled image
    height = height * ratio # Reset height to match scaled image

  fill_ratio = height / width * 100
  result = { width: width, height: height, ratio: fill_ratio }
  utils.log result
  result
    
imageWidget.uploadFile = (file, node)=>
  n = node
  handleUp = (jqxhr)=>
    @uploadCompleted jqxhr, n

  $.ajax
    type: "post"
    url: @current_editor.upload_url
    xhr: =>
      xhr = new XMLHttpRequest()
      xhr.upload.onprogress = @updateProgressBar
      xhr
    cache: false
    contentType: false

    success: (response) =>
      handleUp(response)
      return
    error: (jqxhr)=>
      utils.log("ERROR: got error uploading file #{jqxhr.responseText}")

    processData: false
    data: @formatData(file)
      
imageWidget.uploadCompleted = (url, node)=>
  node.find("img").attr("src", url)
  #return false
  
imageWidget.updateProgressBar = (e)=>
  $progress = $('.progress:first', this.$el)
  complete = ""

  if (e.lengthComputable)
    complete = e.loaded / e.total * 100
    complete = complete ? complete : 0
    #$progress.attr('value', complete)
    #$progress.html(complete)
    utils.log "complete"
    utils.log complete
    
imageWidget.formatData = (file)->
  formData = new FormData()
  formData.append('file', file)
  return formData
  
# Adds this widget to the array registeredWidgets
Dante.widgets.register(imageWidget)
utils.log(Dante)
