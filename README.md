#Service API for Seattle street parking information

Receives parameters from front-end clients to query the Seattle government ArcGIS server (http://gisrevprxy.seattle.gov/ArcGIS/rest/services/SDOT_EXT/sdot_parking/MapServer) for parking information.

Parameters needed in :request key of parameters:

* :coords - Latitude, Longitude coordinates using Geographic Coordinate System as string, e.g. "(47.609023, -122.33373610000001)"
* :bounds - Southwest and Northeast cordners of bounding box formatted as string, e.g. "((Lat1, Long1), (Lat2, Long2))"
* :size - width x height (in pixels) as integers in a string, e.g. "400,400". The size of the image must be not be floats. Use "640,946", not "640.000,946.000".

Information returned:
* BSON id
* bounding box (:bounds)
* web/mobile client (:client and :version)
* coordinates of request (:coords)
* map overlay URL (stored in S2 bucket)
* Seattle ArcGIS map URL (:query)

Example:

    {
    "_id": null,
    "bounds": "((47.56364247772959, -122.32194293442382), (47.56943376219384, -122.31335986557616))",
    "client": "Chrome",
    "coords": "test",
    "overlay": {
        "url": "/uploads/tmp/1398105651-24395-7471/export.png"
                },
    "query": "http://gisrevprxy.seattle.gov/ArcGIS/rest/services/SDOT_EXT/sdot_parking/MapServer/export?bbox=-122.32194293442382%2C47.56364247772959%2C-122.31335986557616%2C47.56943376219384&bboxSR=4326&dpi=96&f=image&format=png8&imageSR=2926&layers=show%3A7%2C6%2C8%2C9&size=500%2C500&transparent=true",
    "size": "500,500",
    "version": "34.0.1847.116"
    }

=======
Requirements:
* Ruby 2.1.1

* Rails 4.0.3

* MongoDB

* Redis/Resque

* Rspec test suite

* Currently deployed on Amazon EC2 instance using Ubuntu, Apache2 and Passenger


