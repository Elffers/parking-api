class Request
  include Mongoid::Document
  field :coords, type: String
  field :bounds, type: String
  # Time a valid type?
  # field :timestamp, type: Time
  field :client, type: String
  field :version, type: String
  field :overlay, type: String
  field :size, type: String
  field :url, type: String

  mount_uploader :overlay, OverlayUploader

  validates :coords, :bounds, :client, presence: true
  # TODO: validation on coordinates being within Seattle lat/long range

  def get_overlay
    uri = "http://gisrevprxy.seattle.gov/ArcGIS/rest/services/SDOT_EXT/sdot_parking/MapServer/export"
    query = self.request_params_to_query
    self.url = "#{uri}?#{query}"
    self.remote_overlay_url = "#{uri}?#{query}"
  end

  def set_client(user_agent_string)
    user_agent = AgentOrange::UserAgent.new(user_agent_string)
    device = user_agent.device

    if device.is_mobile?
      self.client = device.platform
      self.version = device.platform.version
    else device.is_computer?
      self.client = device.engine.browser.name
      self.version = device.engine.browser.version
    # elsif other conditions for not mobile or computer? BOT?
    end
  end

  def format_bounds(bounds)
    bounds = bounds.delete("()").split(/\s*,\s*/)
    [bounds[1], bounds[0], bounds[3], bounds[2]].join(",")
  end

  def request_params_to_query
    layers = "7,6,8,9"
    bboxSR = 4326
    imageSR = 2926
    # TODO: figure out how size affects bounding box
    # size = "500,500"
    dpi = 96

    {
      "dpi"=> dpi,
      "transparent"=>"true",
      "format"=>"png8",
      "layers"=>"show:#{layers}",
      "bbox"=> format_bounds(self.bounds),
      "bboxSR"=> bboxSR,
      "imageSR"=> imageSR,
      "size"=> self.size,
      "f"=>"image"
    }.to_query
  end
end