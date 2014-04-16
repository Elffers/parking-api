class RangeChecker
  attr_accessor :latitude, :longitude

  NORTH_BOUND  = 47.736352
  SOUTH_BOUND  = 47.524361
  WEST_BOUND   = -122.435749
  EAST_BOUND   = -122.245548

  def initialize(bbox_string)
    bounds = bbox_string.delete("()").split(/\s*,\s*/)
    @longitude = [bounds[1], bounds[3]]
    @latitude = [bounds[0], bounds[2]]
  end

  def longitude
    bools = @longitude.map do |coord|
      WEST_BOUND < coord.to_f && coord.to_f < EAST_BOUND
    end
    bools.first && bools.last
  end

  def latitude
    bools = @latitude.map do |coord|
      SOUTH_BOUND < coord.to_f && coord.to_f < NORTH_BOUND
    end
    bools.first && bools.last
  end

end
