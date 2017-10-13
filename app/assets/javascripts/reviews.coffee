# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


# 1. sets the document to be expressed as a jquery object
#    so we can call methods on it, like 'on'
#
# 2. Attach an event handler to be run when the element with
#    the id 'reviews-toggle' is clicked, where $('#reviews-toggle')
#    finds the element in the DOM and returns it as a jquery object
#    where we then call the 'click' method on it
#
# 3. Then find the element with the id 'reviews-section' to return it
#    as a jquery object to call the toggle method on, which toggles
#    the visibility of the element by changing the css 'display'
#    property. Note this was changed from 'toggle()' to 'fadeToggle()'
#    to add a fade effect

$(document).on "turbolinks:load", ->
  $('#reviews-toggle').click (event) ->
    this.innerHTML = if (this.innerHTML == 'Show Recent Reviews')
      'Hide Recent Reviews'
    else
      'Show Recent Reviews'
    event.preventDefault()
    $('#reviews-section').fadeToggle()



