class RangeChecker
  attr_accessor :swX, :swY, :neX, :neY, :coords

  NORTH_BOUND  = 47.736352
  SOUTH_BOUND  = 47.524361
  WEST_BOUND   = -122.435749
  EAST_BOUND   = -122.245548

  LAT_ZOOM     = 0.046308417435767524
  LONG_ZOOM    = 0.06866455078125

  # :coords come in as "(47.62862941481989, -122.39090529990231)"
  # :bounds come in as SW and NE coords
  # "((47.62166982344883, -122.31682166721191), (47.624562336539235, -122.31253013278808))"

  def initialize(request_params)
    bounds    = request_params["bounds"].delete("()").split(/\s*,\s*/)
    @swX      = bounds[0].to_f
    @swY      = bounds[1].to_f
    @neX      = bounds[2].to_f
    @neY      = bounds[3].to_f
    @coords   = request_params["coords"].delete("()").split(/\s*,\s*/)
  end

  def in_seattle?
    valid_latitude(@coords[0].to_f) && valid_longitude(@coords[1].to_f)
  end

  def check_zoom
    (@swX - @neX).abs <= LAT_ZOOM && (@swY - @neY).abs <= LONG_ZOOM
  end

  private

  def valid_longitude(y)
    within_range(y, WEST_BOUND, EAST_BOUND)
  end

  def valid_latitude(x)
    within_range(x, SOUTH_BOUND, NORTH_BOUND)
  end

  def within_range(point, a, b)
    a < point && point < b
  end

end
