//
//  Coordinates.swift
//  AlzayedPrayerTimes
//
//  Created by Abdulrazzaq Alzayed on 9/16/18.
//  Copyright © 2018 Kuwait-It. All rights reserved.
//

import Foundation

// ------------------------------------------------
// ------------------------------------------------
// Coordinates class
// ------------------------------------------------
// ------------------------------------------------
class Coordinates {
    var lat: Double, lng: Double, elv: Double
    init(lat: Double, lng: Double, elv: Double = 0) {
        self.lat = lat
        self.lng = lng
        self.elv = elv
    }
}
