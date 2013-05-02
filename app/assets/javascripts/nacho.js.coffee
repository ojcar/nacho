$('.load-feed').on 'ajax:before', (xhr,data)  ->

$('.load-feed').on 'ajax:success', (xhr,data) ->
  # $('#main').html(data)
  entries = HandlebarsTemplates['feeds/feed_entry'](data);
  $('#main').html(entries)

$('.load-feed').on 'ajax:error', (xhr,data)  ->
  $('#main').html('Error')