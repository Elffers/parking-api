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

  validates :coords, :bounds, :client, :overlay, presence: true
  # TODO: validation on coordinates being within Seattle lat/long range

  def get_overlay
    uri = "http://gisrevprxy.seattle.gov/ArcGIS/rest/services/SDOT_EXT/sdot_parking/MapServer/export"
    query = self.request_params_to_query
    image = HTTParty.get("#{uri}?#{query}")
    self.url = uri + "?" + query
    temp = "overlays/#{Time.now.to_i}.png"
    img_file = File.new("#{Rails.root.to_s}/app/assets/images/#{temp}", 'w', :encoding => 'ASCII-8BIT')
    img_file.write(image.parsed_response)
    self.overlay = img_file
    # self.overlay = image.parsed_response, obviates 20-22
  end

  def set_client(user_agent_string)
    ua = AgentOrange::UserAgent.new(user_agent_string)
    device = ua.device
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
    # ((47.605372956656076, -122.33883241802977), (47.612606193258024, -122.3281035819702))
    bounds = bounds.gsub(/\(/, "").gsub(/\)/, "").split(",")
    bounds = bounds.map {|coordinate| coordinate.strip }
    bounds = [bounds[1], bounds[0], bounds[3], bounds[2]].join(",")
  end

  def request_params_to_query
    layers = "7,6,8,9"
    spatial_reference = 4326
    # TODO: figure out how size affects bounding box
    # size = "500,500"
    dpi = 96

    {
      "dpi"=> dpi,
      "transparent"=>"true",
      "format"=>"png8",
      "layers"=>"show:#{layers}",
      "bbox"=>self.bounds,
      "bboxSR"=> spatial_reference,
      "imageSR"=> spatial_reference,
      "size"=> self.size,
      "f"=>"image"
    }.to_query
  end
end