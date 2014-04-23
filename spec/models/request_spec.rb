require 'spec_helper'

describe Request do

  let(:partly_in){ {
                    coords: '(47.7263275, -122.3520191)',
                    bounds: '((47.71477902988729, -122.36918523769532), (47.7378734102129, -122.3348529623047))'
                    }
                  }

  let(:fully_in){ {
                    coords: '(47.67666029999999, -122.33759450000002)',
                    bounds: '((47.66510082328286, -122.35476063769534), (47.68821721639755, -122.32042836230471))'
                  }
                }

  let(:portland) { {
                    "coords" => "(45.522691, -122.673044)",
                    "bounds" => "((45.51972139168435, -122.67725739209595), (45.52573491524078, -122.6686743232483))",
                    "size"=>"500,500"
                    }
                  }
  let(:zoomed_out){ {
                      "coords" => "(47.62862941481989, -122.39090529990231)",
                      "bounds" => "((47.5823335998115, -122.45956985068358), (47.674884258347305, -122.32224074912108))"
                      }
                    }

  describe 'validations' do
    it { should validate_presence_of(:coords) }
    it { should validate_presence_of(:bounds) }
    it { should validate_presence_of(:client) }
  end

  describe '#get_overlay' do
    context 'for bounds fully contained in Seattle' do
      let(:request){ Request.new(fully_in) }
      it 'should set the .query attribute' do
        request.get_overlay
        expect(request.query).to_not be_nil
        expect(request.query).to eq "http://gisrevprxy.seattle.gov/ArcGIS/rest/services/SDOT_EXT/sdot_parking/MapServer/export?bbox=-122.35476063769534%2C47.66510082328286%2C-122.32042836230471%2C47.68821721639755&bboxSR=4326&dpi=96&f=image&format=png8&imageSR=3857&layers=show%3A7%2C6%2C8%2C9&size=&transparent=true"
      end

      it 'should point to temp file as overlay.url' do
        request.get_overlay
        id = /\d+-\d+-\d+/
        expect(request.overlay.url).to match "/uploads/tmp/#{id}/export.png"
      end
    end

    context 'for bounds partly contained in Seattle' do
      let(:request){ Request.new(partly_in) }

      it 'should set the .query attribute' do
        request.get_overlay
        expect(request.query).to_not be_nil
        expect(request.query).to eq 'http://gisrevprxy.seattle.gov/ArcGIS/rest/services/SDOT_EXT/sdot_parking/MapServer/export?bbox=-122.36918523769532%2C47.71477902988729%2C-122.3348529623047%2C47.7378734102129&bboxSR=4326&dpi=96&f=image&format=png8&imageSR=3857&layers=show%3A7%2C6%2C8%2C9&size=&transparent=true'
      end

      it 'should point to temp file as overlay.url' do
        request.get_overlay
        id = /\d+-\d+-\d+/
        expect(request.overlay.url).to match "/uploads/tmp/#{id}/export.png"
      end
    end
  end

  describe '#in_seattle?' do
    it 'returns false if coords not within Seattle' do
      request = Request.new(portland)
      expect(request.in_seattle?).to eq false
    end

    it 'returns true if coords are within Seattle' do
      request1 = Request.new(partly_in)
      request2 = Request.new(fully_in)
      expect(request1.in_seattle?).to eq true
      expect(request2.in_seattle?).to eq true
    end
  end

  describe '#zoomed?' do
    it 'returns true if zoomed in' do
      request = Request.new(partly_in)
      expect(request.zoomed?).to eq true
    end

    it 'returns false if not zoomed in' do
      request = Request.new(zoomed_out)
      expect(request.zoomed?).to eq false
    end
  end

  describe '#save_queue' do
    let(:request) { Request.new(fully_in) }
    before do
      request.client = "Chrome"
      request.get_overlay
    end

    it 'removes the id from parameters' do
      request.queue_save
      expect(request.attributes).to_not include '_id'
    end

  end
end
