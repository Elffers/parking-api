require 'spec_helper'

# north lat: 47.736352
# south lat: 47.524361
# west long: -122.435749
# east long: -122.245548

describe RangeChecker do

  let(:over_zoomed_seattle){ RangeChecker.new({
                                              "coords" => "(47.62862941481989, -122.39090529990231)",
                                              "bounds" => "((47.5823335998115, -122.45956985068358), (47.674884258347305, -122.32224074912108))"
                                              }
                                            )
                            }
  let(:portland){ RangeChecker.new({
                                    "coords" => "(45.522691, -122.673044)",
                                    "bounds" => "((45.51972139168435, -122.67725739209595), (45.52573491524078, -122.6686743232483))"
                                    }
                                  )
                }
  let(:partly_in){ RangeChecker.new({
                                    "coords" => "(47.7263275, -122.3520191)",
                                    "bounds" => "((47.71477902988729, -122.36918523769532), (47.7378734102129, -122.3348529623047))"
                                    })
                  }

  let(:fully_in){ RangeChecker.new({
                                    "coords" => "(47.67666029999999, -122.33759450000002)",
                                    "bounds" => "((47.66510082328286, -122.35476063769534), (47.68821721639755, -122.32042836230471))"
                                  })
                }
  describe '#in_seattle?' do
    it 'returns false if coordinates are not in Seattle limits' do
      expect(portland.in_seattle?).to eq false
    end

    it 'returns true if coordinates are within Seattle limits' do
      expect(fully_in.in_seattle?).to eq true
      expect(partly_in.in_seattle?).to eq true
    end
  end

  describe '#check_zoom' do
    it 'returns true if zoomed in enough' do
      expect(fully_in.check_zoom).to eq true
    end

    it 'returns false if not zoomed in enough' do
      expect(over_zoomed_seattle.check_zoom).to eq false
    end
  end

end

