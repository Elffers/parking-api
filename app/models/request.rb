class Request

  include Mongoid::Document
  #comes in from client
  field :coords, type: String
  field :bounds, type: String
  field :size, type: String

  # set in .get_overlay
  field :client, type: String
  field :version, type: String
  field :query, type: String

  # defined by CarrierWave
  field :overlay, type: String
  mount_uploader :overlay, OverlayUploader

  validates :coords, :bounds, :client, presence: true

  # sets .query to be the request string sent to query the Seattle ArcGIS API
  # .overlay.url will be set to the tmp file until the request object is saved, at which point CarrierWave automatically updates .overlay.url to point to the S3 bucket address
  def get_overlay
    uri = "http://gisrevprxy.seattle.gov/ArcGIS/rest/services/SDOT_EXT/sdot_parking/MapServer/export"
    query = self.request_params_to_query
    self.query = "#{uri}?#{query}"
    self.remote_overlay_url = self.query
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
  # "((lat1, long1), (lat2, long2))", e.g.
  # ((47.62166982344883, -122.31682166721191), (47.624562336539235, -122.31253013278808)).# Following method formats the bounds for ArcGIS bounding box query param, e.g.
  # "long1, lat1, long2, lat2"

  def format_bounds(bounds)
    bounds = bounds.delete("()").split(/\s*,\s*/)
    [bounds[1], bounds[0], bounds[3], bounds[2]].join(",")
  end

  # Bounding box spatial reference 4326 refers to Geographic Coordinate System (GCS).
  # Image spatial reference 3857 refers to EPSG:3857 - Projection used in many popular web mapping applications (Google/Bing/OpenStreetMap/etc).
  # Layers (http://gisrevprxy.seattle.gov/ArcGIS/rest/services/SDOT_EXT/sdot_parking/MapServer) include:
    # Temporary No Parking (6)
    # Street Parking by Category (7)
    # Peak Hour No Parking (8)
    # One-Way Streets (9)

  def request_params_to_query
    layers = "7,6,8,9"
    bboxSR = 4326
    # imageSR corresponds to GoogleMaps spatial reference
    imageSR = 3857
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

  def in_seattle?
    coords = RangeChecker.new(self.attributes)
    coords.in_seattle?
  end

  def zoomed?
    bounds = RangeChecker.new(self.attributes)
    bounds.zoomed?
  end

  def queue_save
    self.attributes.delete "_id"
    Resque.enqueue(SaveRequestJob, attributes)
  end

  def get_dragons
    mapsize = size.sub(/,/, 'x')
    "https://s3-us-west-2.amazonaws.com/seattle-parking/dragons/#{mapsize}.png"
  end

  def get_ladies
    mapsize = size.sub(/,/, 'x')
    "https://s3-us-west-2.amazonaws.com/seattle-parking/ladies/#{mapsize}.png"
  end
end
