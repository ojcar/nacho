$('document').ready ->
  $('.entry').jknavigable()

  $('.entry').waypoint
    handler: (direction) ->
      if direction is 'down'
        $.post '/reader/mark_read',
          id: $(this).data('entry')
          dataType: 'json'
          (data) ->
            msg = ''
            if data.status is 'success'
              msg = '<p><span class="badge badge-success">Read!</span></p>'
            else if data.status is 'error'
              msg = '<p><span class="badge badge-important">Could not mark as read!</span></p>'
            $("div[data-entry=#{data.id}]").find('.meta').append(msg)
    offset: ->
      -$(this).height()/2


  $('.load-feed').on
    'ajax:before': (xhr,data) ->
    'ajax:success': (xhr,data) ->
      entries = HandlebarsTemplates['feeds/feed_entry'](data)
      $('#main').html(entries)
    'ajax:error': (xhr,data) ->
      $('#main').html('Error')


  # handle post submission from modal
  $('#new-post-form').on
    'ajax:success': (xhr,data) ->
      $('#new-post-modal').modal('hide')
    'ajax:error': (xhr,data) ->
      errors = $.parseJSON(xhr.responseText)
      $('#new-post-modal').append("<div class='alert'>#{errors}</div>")


  # Populate post fields from a feed entry
  $('.post-entry').click (e) ->
    source = $(this).parents('.entry').find('h2 > a')
    $('#post_title').val(source.html())
    $('#post_link').val(source.attr('href'))
    $('#new-post-modal').modal()

  # Reset new post modal on Cancel
  $('#new-post-modal').on 'hidden', ->
    $('#post_title').val('')
    $('#post_link').val('')
