Service API for Seattle street parking information

Receives parameters from front-end clients to query the Seattle government ArcGIS server for parking information.

Parameters needed in :request key of parameters:

*:coords - Latitude, Longitude coordinates using Geographic Coordinate System
*:bounds - Southwest and Northeast cordners of bounding box formatted as ((Lat1, Long1), (Lat2, Long2))
*:size - width x height (in pixels) as string, e.g. "400,400"

(http://gisrevprxy.seattle.gov/ArcGIS/rest/services/SDOT_EXT/sdot_parking/MapServer)

Requirements:
* Ruby 2.1.1

* Rails 4.0.3

* MongoDB

* Redis/Resque

* Rspec test suite

* Currently deployed on Amazon EC2 instance using Ubuntu, Apache2 and Passenger


