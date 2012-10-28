window.YoutubeVideo = (id, callback) ->
  $.ajax(
    url: "http://www.youtube.com/get_video_info?video_id=#{id}"
    dataType: "text"
  ).done (video_info) ->
    a = new URI("http://bla.com/?" + video_info,
      decodeQuery: true
    )
    video = a.query
    if video.status == "fail"
      return callback(video)
    video.sources = {}
    window.bla = video
    parts = a.query.url_encoded_fmt_stream_map.split("&url")
    for part in parts
      b = new URI("http://bla.com/?url" + part,
        decodeQuery: true
      )
      b.query.url = "#{b.query.url}&signature=#{b.query.sig}"
      
      if b.query.quality
        type = b.query.type.split(";")[0]
        quality = b.query.quality.split(",")[0]
        video.sources["#{type} #{quality}"] = b.query

    video.getSource = (type, quality) ->
      lowest = null
      exact = null
      for key, source of @sources
        if source.type.match type
          if source.quality.match quality
            exact = source
          else
            lowest = source
      exact || lowest

    callback(video)