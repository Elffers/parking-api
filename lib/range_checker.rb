class RangeChecker
  attr_accessor :latitude, :longitude

  NORTH_BOUND  = 47.736352
  SOUTH_BOUND  = 47.524361
  WEST_BOUND   = -122.435749
  EAST_BOUND   = -122.245548

  # SW and NE
  #((47.62166982344883, -122.31682166721191), (47.624562336539235, -122.31253013278808))
  def initialize(bbox_string)
    bounds = bbox_string.delete("()").split(/\s*,\s*/)
    @longitude = [bounds[1], bounds[3]]
    @latitude = [bounds[0], bounds[2]]
  end

  def longitude
    bools = @longitude.map { |coord| within_range(coord.to_f, WEST_BOUND, EAST_BOUND) }
    bools.first && bools.last
  end

  def latitude
    valid_coords = @latitude.select { |p| within_range(p.to_f, SOUTH_BOUND, NORTH_BOUND) }
    valid_coords.length == 2
  end

  private

  def within_range(point, a, b)
    a < point && point < b
  end

end
