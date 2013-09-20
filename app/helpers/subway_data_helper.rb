module SubwayDataHelper
  def minutes_seconds(time)
    sec = time
    min = time/60
    sec -= min * 60
    "#{min} min #{sec} sec"
  end
end
