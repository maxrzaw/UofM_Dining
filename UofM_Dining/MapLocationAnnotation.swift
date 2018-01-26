//
//  MapLocationAnnotation.swift
//  UofM_Dining
//
//  Created by Benjamin Boss on 12/1/17.
//  Copyright © 2017 teamzucc. All rights reserved.
//

import MapKit

class locationAnnotation: NSObject, MKAnnotation {
    var title: String?
    var coordinate: CLLocationCoordinate2D
    
    init(title: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.coordinate = coordinate
    }
}
