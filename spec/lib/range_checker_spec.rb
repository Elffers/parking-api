require 'spec_helper'

# north lat: 47.736352
# south lat: 47.524361
# west long: -122.435749
# east long: -122.245548

describe RangeChecker do
  let(:valid_bbox) { RangeChecker.new("((47.62166982344883, -122.31682166721191), (47.624562336539235, -122.31253013278808))")}
  let(:invalid_bbox) { RangeChecker.new("((48.62166982344883, -125.31682166721191), (47.624562336539235, -122.31253013278808))")}

  let(:zoomed_out_seattle){ RangeChecker.new({
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
# Portland coordinates : 45.522691, -122.673044
# Portland BBOX: ((45.51972139168435, -122.67725739209595), (45.52573491524078, -122.6686743232483))

# zoomed_out_seattle bbox: ((47.5823335998115, -122.45956985068358), (47.674884258347305, -122.32224074912108))
# zoomed_out_seattle coords: (47.62862941481989, -122.39090529990231)

  describe '#in_seattle?' do
    it 'returns false if coordinates are not in Seattle limits' do
      expect(portland.in_seattle?).to eq false
    end
  end

  describe '#longitude' do
    xit 'returns false if outside range' do
      expect(invalid_bbox.longitude).to eq false
    end

    xit 'returns true if within range' do
      expect(valid_bbox.longitude).to eq true
    end
  end

  describe '#latitude' do
    xit 'returns false if outside range' do
      expect(invalid_bbox.longitude).to eq false
    end

    xit 'returns true if within range' do
      expect(valid_bbox.latitude).to eq true
    end
  end

  describe '#validate' do
    xit 'returns true if all coordinates are within bounds' do
      expect(valid_bbox.validate).to eq true
    end

    xit 'returns false if at least one coordinate is out of bounds' do
      expect(invalid_bbox.validate).to eq false
    end
  end
end

