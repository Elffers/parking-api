require 'spec_helper'

describe Request do
  let(:params) { { coords: "foo", bounds: "-122.341331, 47.657289, -122.310042, 47.693368", size: "400,400"}}
  let(:request) { Request.new(params) }

  describe "validations" do
    it { should validate_presence_of(:coords) }
    it { should validate_presence_of(:bounds) }
    it { should validate_presence_of(:client) }
  end

  describe '.get_overlay' do
    it 'should set the .query attribute' do
      request.get_overlay
      expect(request.query).to_not be_nil
      expect(request.query).to eq "http://gisrevprxy.seattle.gov/ArcGIS/rest/services/SDOT_EXT/sdot_parking/MapServer/export?bbox=47.657289%2C-122.341331%2C47.693368%2C-122.310042&bboxSR=4326&dpi=96&f=image&format=png8&imageSR=2926&layers=show%3A7%2C6%2C8%2C9&size=400%2C400&transparent=true"
    end

    it 'should point to temp file as overlay.url' do
      request.get_overlay
      id = /\d+-\d+-\d+/
      expect(request.overlay.url).to match "/uploads/tmp/#{id}/export.png"
    end
  end

  describe '.set_client' do

  end

  describe '.request_params_to_query' do
  end

end
