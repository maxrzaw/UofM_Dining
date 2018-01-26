 //
//  LocationAnnotation.swift
//  UofM_Dining
//
//  Created by Benjamin Boss on 11/30/17.
//  Copyright © 2017 teamzucc. All rights reserved.
//

import MapKit
 
 class locationAnnotation: NSObject, MKAnnotation {
    var title: String?
    var coordinate: CLLocationCoordinate2D
    
    init(title: String?, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.coordinate = coordinate
    }
    
 }
