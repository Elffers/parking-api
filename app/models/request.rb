class Request
  include Mongoid::Document
  field :coords, type: String
  field :bounds, type: String
  field :client, type: String
  field :version, type: String
  field :overlay, type: String
  validates :coords, :bounds, :client, presence: true

  def get_overlay
    bounds = {"bbox"=>self.bounds}.to_query
    image = HTTParty.get("http://gisrevprxy.seattle.gov/ArcGIS/rest/services/SDOT_EXT/sdot_parking/MapServer/export?#{bounds}&bboxSR=4326&layers=7&layerdefs=&size=&imageSR=&format=png&transparent=false&dpi=&time=&layerTimeOptions=&f=image")
    # img_file = Tempfile.new('overlay.png', "#{Rails.root.to_s}/public/", :encoding => 'ASCII-8BIT')
    data = Magick::Image.from_blob(image.parsed_response)
    filename = "/overlays/#{Time.now.to_i}.png"

    img_file = File.new("#{Rails.root.to_s}/public/#{filename}", 'w', :encoding => 'ASCII-8BIT')

    img_file.write(data[0])
    # save the image somewhere else

    self.overlay = filename
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
end