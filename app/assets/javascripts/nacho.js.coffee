$('.load-feed').on 'ajax:before', (xhr,data)  ->

$('.load-feed').on 'ajax:success', (xhr,data) ->
  $('#main').html(data)

$('.load-feed').on 'ajax:error', (xhr,data)  ->
  $('#main').html('Error')