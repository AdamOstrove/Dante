utils  = Dante.utils
config = Dante.config
videoWidget = {}

videoWidget.name = "icon-video"

videoWidget.icon = "icon-video"

videoWidget.title = "Add a video"

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

videoWidget.handleKeyDown = (e, node) -> 
  editor  = Dante.Editor.prototype
  tooltip = Dante.Editor.Tooltip.prototype
  $target = $(node)

  utils.log("VIDEO HANDLE KEYDOWN")

  utils.log("TARGET IS: ")
  utils.log($target)

  if e.which is 13

    #embeds or extracts
    if $target.hasClass("is-embedable")
      getEmbedFromNode(node)
    else if $target.hasClass("is-extractable")
      getExtractFromNode(node)

    #supress linebreak into embed page text unless last char
    if $target.hasClass("graf--mixtapeEmbed") or $target.hasClass("graf--iframe") or $target.hasClass("graf--figure")
      utils.log("supress linebreak from embed !(last char)")
      return false unless editor.isLastChar()

    #supress linebreak or create new <p> into embed caption unless last char el
    if $target.hasClass("graf--iframe") or $target.hasClass("graf--figure")
      if editor.isLastChar()
        editor.handleLineBreakWith("p", parent)
        editor.setRangeAtText($(".is-selected")[0])

        $(".is-selected").trigger("mouseup") #is not making any change
        return false
      else
        return false

  else
    return false

getEmbedFromNode = (node)->
  @node = $(node)
  @node_name = @node.attr("name")
  @node.addClass("spinner")

  $.getJSON("#{config.current_editor.oembed_url}#{$(@node).text()}")
    .success (data)=>
      @node = $("[name=#{@node_name}]")
      iframe_src = $(data.html).prop("src")
      tmpl = $(embedTemplate())
      tmpl.attr("name", @node.attr("name"))
      $(@node).replaceWith(tmpl)
      replaced_node = $(".graf--iframe[name=#{@node.attr("name")}]")
      replaced_node.find("iframe").attr("src", iframe_src)
      url = data.url || data.author_url
      utils.log "URL IS #{url}"
      replaced_node.find(".markup--anchor").attr("href", url ).text(url)
      Dante.Editor.Tooltip.prototype.hide()

getExtractFromNode = (node)=>
  @node = $(node)
  @node_name = @node.attr("name")
  @node.addClass("spinner")

  $.getJSON("#{config.current_editor.extract_url}#{$(@node).text()}").success (data)=>
    @node = $("[name=#{@node_name}]")
    iframe_src = $(data.html).prop("src")
    tmpl = $(extractTemplate())
    tmpl.attr("name", @node.attr("name"))
    $(@node).replaceWith(tmpl)
    replaced_node = $(".graf--mixtapeEmbed[name=#{@node.attr("name")}]")
    replaced_node.find("strong").text(data.title)
    replaced_node.find("em").text(data.description)
    replaced_node.append(data.provider_url)
    replaced_node.find(".markup--anchor").attr("href", data.url )
    unless _.isEmpty data.images
      image_node = replaced_node.find(".mixtapeImage")
      image_node.css("background-image", "url(#{data.images[0].url})")
      image_node.removeClass("mixtapeImage--empty u-ignoreBlock")
    Dante.Editor.Tooltip.prototype.hide()

extractTemplate = ()->
  "<div class='graf graf--mixtapeEmbed is-selected' name=''>
    <a target='_blank' data-media-id='' class='js-mixtapeImage mixtapeImage mixtapeImage--empty u-ignoreBlock' href=''>
    </a>
    <a data-tooltip-type='link' data-tooltip-position='bottom' data-tooltip='' title='' class='markup--anchor markup--mixtapeEmbed-anchor' data-href='' href='' target='_blank'>
      <strong class='markup--strong markup--mixtapeEmbed-strong'></strong>
      <em class='markup--em markup--mixtapeEmbed-em'></em>
    </a>
  </div>"

embedTemplate = ()->
  "<figure contenteditable='false' class='graf--figure graf--iframe graf--first' name='504e' tabindex='0'>
    <div class='iframeContainer'>
      <iframe frameborder='0' width='700' height='393' data-media-id='' src='' data-height='480' data-width='854'>
      </iframe>
    </div>
    <figcaption contenteditable='true' data-default-value='Type caption for embed (optional)' class='imageCaption'>
      <a rel='nofollow' class='markup--anchor markup--figure-anchor' data-href='' href='' target='_blank'>

      </a>
    </figcaption>
  </figure>"

Dante.widgets.register(videoWidget)