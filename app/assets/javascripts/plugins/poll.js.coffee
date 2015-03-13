utils  = Dante.utils
config = Dante.config
pollPlaceholder = "<span class='defaultValue defaultValue--root'>Create a poll title</span><br>"

pollWidget = {}

pollWidget.name   = "icon-poll"
pollWidget.icon   = "icon-poll"
pollWidget.title  = "Create a new poll"
pollWidget.action = "poll"

testPollAction = ()->
  utils.log("POLL...IN THE FUTURE")
  createNewPoll()

pollWidget.actionEvent = testPollAction

createNewPoll = ()->
  currentEditor = config.current_editor
  $node = $(currentEditor.getNode())
  $poll = $(pollTemplate())
  $node.replaceWith($poll)

pollTemplate = ()->
  "<figure class='graf--figure graf--poll graf--first' name = '' contenteditable='false'>
    <div class='poll_body'>

      <div class='poll_head'>
        <p class='poll_head_content' id='poll_title' contenteditable='true'>#{pollPlaceholder}</p>
        <p class='poll_head_content' id='poll_closer'>this will be the delete poll button</p>
      </div>

      <div class='poll_options'>
        <p class='poll_option'>the options will go here</p>
      </div>

      <div class='poll_controls'>
        <p>the control buttons will go here</p>
      </div>

    </div>    
  </figure>"

Dante.widgets.register(pollWidget)