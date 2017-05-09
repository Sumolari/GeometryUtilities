//
//  MKPolygon+MinMaxLatLon.swift
//  GeometryUtilities
//
//  Created by Lluís Ulzurrun on 20/7/16.
//

import MapKit

extension MKPolygon {

	/**
	 Creates a rectangular polygon covering given `MinMaxLonLat`.

	 - parameter minMaxLonLat: `MinMaxLonLat` to be covered by polygon.

	 - returns: Rectangular polygon covering given `MinMaxLonLat`.
	 */
    @available(*, introduced: 1.4.0)
	public convenience init(minMaxLatLon: MinMaxLatLon) {
        
        let coordinates = [
            (minMaxLatLon.minLat, minMaxLatLon.minLon),
            (minMaxLatLon.maxLat, minMaxLatLon.minLon),
            (minMaxLatLon.maxLat, minMaxLatLon.maxLon),
            (minMaxLatLon.minLat, minMaxLatLon.maxLon),
            (minMaxLatLon.minLat, minMaxLatLon.minLon)
        ].map { CLLocationCoordinate2D(latitude: $0.0, longitude: $0.1) }
        
        let points = UnsafeMutablePointer<CLLocationCoordinate2D>.allocate(
            capacity: coordinates.count
        )
        
        for (index, coordinate) in coordinates.enumerated() {
            points[index] = coordinate
        }
		
        self.init(coordinates: points, count: coordinates.count)
        
		points.deinitialize(count: coordinates.count)

	}

}

extension Collection where Iterator.Element == MKPolygon {
    
    /**
     Returns `MinMaxLonLat` covered by polygons in this collection.
     
     - returns: `MinMaxLonLat` covered by polygons in this collection. `nil` iff
     collection has no polygons.
     */
    public func minMaxLatLon() -> MinMaxLatLon? {
        
        let coordinates = self
            .map { $0.coordinates() }
            .joined()
        
        return coordinates.minMaxLatLon()
        
    }
    
}
