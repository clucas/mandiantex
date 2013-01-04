# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

selectedClass = "selected"
position = -1
itemUp = undefined
itemDown = undefined

$ ->
  $("table").on "click", "tr", ->
    uri = @getAttribute("data-url")
    window.location = uri unless uri is null
	
$ ->
  $(document).keydown (e) ->
    collection = $("#table .tablerow")
    switch e.keyCode
      when 13 # enter
        uri = $("#table .selected").attr("data-url")
        window.location = uri unless typeof (uri) is "undefined"
      when 38 # up
        $(itemUp).removeClass selectedClass
        $(itemDown).removeClass selectedClass
        unless position is 0 or position is -1
          itemUp = collection[position - 1]
          $(itemUp).addClass selectedClass
          position = position - 1
        else
          itemUp = collection[0]
          $(itemUp).addClass selectedClass
          position = 0
      when 40 # down
        $(itemUp).removeClass selectedClass
        $(itemDown).removeClass selectedClass
        unless position is collection.length - 1 or position is -1
          itemDown = collection[position + 1]
          $(itemDown).addClass selectedClass
          position = position + 1
        else
          itemDown = collection[collection.length - 1]
          $(itemDown).addClass selectedClass
          position = collection.length - 1

# $ ->
#   $("tr").not(":first").hover (->
#     $(this).addClass selectedClass
#   ), ->
#     $(this).removeClass selectedClass

$ ->
  $("#search_query").autocomplete
    source: "/search_suggestions"