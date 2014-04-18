class Request

  include Mongoid::Document
  field :coords, type: String
  field :bounds, type: String
  field :client, type: String
  field :version, type: String
  field :overlay, type: String
  field :size, type: String
  field :query, type: String
  field :url, type: String

  mount_uploader :overlay, OverlayUploader
  store_in_background :overlay

  validates :coords, :bounds, :client, presence: true

  def get_overlay
    uri = "http://gisrevprxy.seattle.gov/ArcGIS/rest/services/SDOT_EXT/sdot_parking/MapServer/export"
    query = self.request_params_to_query

    self.query = "#{uri}?#{query}"
    self.remote_overlay_url = self.query
    self.url = self.overlay.path
  end

  def reset_url
    self.url = self.overlay.to_s
    # destroy tempfile
  end

  # Identifies type of browser/device the query is coming from
  def set_client(user_agent_string)
    user_agent = AgentOrange::UserAgent.new(user_agent_string)
    device = user_agent.device
    if device.is_mobile?
      self.client = device.platform
      self.version = device.platform.version
    else device.is_computer?
      self.client = device.engine.browser.name
      self.version = device.engine.browser.version
    end
  end

  # Google Maps API returns the NE and SW corners of bounding box formatted as
  # "((latitude_1, longitude_1), (latitude_2, longitude_2))", e.g.
  # ((47.62166982344883, -122.31682166721191), (47.624562336539235, -122.31253013278808)).# Following method formats the bounds for ArcGIS bounding box query param, e.g.
  # "longitude_1, latitude_1, longitude_2, latitude_2"

  def format_bounds(bounds)
    bounds = bounds.delete("()").split(/\s*,\s*/)
    [bounds[1], bounds[0], bounds[3], bounds[2]].join(",")
  end

  # Bounding box spatial reference 4326 refers to Geographic Coordinate System (GCS).
  # Image spatial reference 2926 refers to Washington State Plane North, NAD83 HARN, US Survey feet
  # Layers (http://gisrevprxy.seattle.gov/ArcGIS/rest/services/SDOT_EXT/sdot_parking/MapServer) include:
    # Temporary No Parking (6)
    # Street Parking by Category (7)
    # Peak Hour No Parking (8)
    # One-Way Streets (9)

  def request_params_to_query
    layers = "7,6,8,9"
    bboxSR = 4326
    imageSR = 2926
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