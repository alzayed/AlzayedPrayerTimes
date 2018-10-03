//
//  DMath.swift
//  AlzayedPrayerTimes
//
//  Created by Abdulrazzaq Alzayed on 9/16/18.
//  Copyright © 2018 Kuwait-It. All rights reserved.
//

import Foundation

// ------------------------------------------------
// ------------------------------------------------
// AlzayedMath class
// ------------------------------------------------
// ------------------------------------------------
class AlzayedMath {
    func dtr(d: Double) -> Double {return d * Double.pi / 180}
    func rtd(r: Double) -> Double {return r * 180 / Double.pi}
    
    func Dsin(d: Double) -> Double {return sin(dtr(d: d))}
    func Dcos(d: Double) -> Double {return cos(dtr(d: d))}
    func Dtan(d: Double) -> Double {return tan(dtr(d: d))}
    
    func Darcsin(d: Double) -> Double {return rtd(r: asin(d))}
    func Darccos(d: Double) -> Double {return rtd(r: acos(d))}
    func Darctan(d: Double) -> Double {return rtd(r: atan(d))}
    
    func Darccot(x: Double) -> Double {return rtd(r: atan(1/x))}
    func Darctan2(y: Double, x: Double) -> Double {return rtd(r: atan2(y, x))}
    
    func fixAngle(a: Double) -> Double {return fix(a: a, b: 360)}
    func fixHour(a: Double) -> Double {return fix(a: a, b: 24)}
    
    func fix(a: Double, b: Double) -> Double {
        var editedA = a
        let floorR = floor(a / b)
        editedA = a - b * floorR
        return editedA < 0 ? editedA + b : editedA
    }
    
}
