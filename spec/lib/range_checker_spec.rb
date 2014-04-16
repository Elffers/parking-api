require 'spec_helper'

# north lat: 47.736352
# south lat: 47.524361
# west long: -122.435749
# east long: -122.245548

describe RangeChecker do
  let(:valid_bbox) { RangeChecker.new("((47.62166982344883, -122.31682166721191), (47.624562336539235, -122.31253013278808))")}
  let(:invalid_bbox) { RangeChecker.new("((48.62166982344883, -125.31682166721191), (47.624562336539235, -122.31253013278808))")}

  describe 'longitude' do
    it 'returns false if outside range' do
      expect(invalid_bbox.longitude).to eq false
    end

    it 'returns true if within range' do
      expect(valid_bbox.longitude).to eq true
    end
  end

  describe 'latitude' do
    it 'returns false if outside range' do
      expect(invalid_bbox.longitude).to eq false
    end

    it 'returns true if within range' do
      expect(valid_bbox.latitude).to eq true
    end
  end
end

