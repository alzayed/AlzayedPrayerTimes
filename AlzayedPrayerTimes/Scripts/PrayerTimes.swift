//
//  PrayerTimes.swift
//  AlzayedPrayerTimes
//
//  Created by Abdulrazzaq Alzayed on 9/5/18.
//  Copyright © 2018 Kuwait-It. All rights reserved.
//

import Foundation

class PrayerTimes {
    
    // --------------- Constant ---------------
    
    // Time Names
    let timeNames = [
        "imsak": "Imsak",
        "fajr": "Fajr",
        "sunrise": "Sunrise",
        "dhuhr": "Dhuhr",
        "asr": "Asr",
        "sunset": "Sunset",
        "maghrib": "Maghrib",
        "isha": "Isha",
        "midnight": "Midnight",
        "nightlong": "NightLong",
        "onethirdnight": "OneThirdNight",
        "lastthird": "LastThird"
    ]
    
    // Calculation Methods
    let methods = [
        "MWL": [
            "name": "Muslim World League",
            "params": [
                "fajr": 18.0,
                "isha": 17.0
            ]
        ],
        "ISNA": [
            "name": "Islamic Society of North America (ISNA)",
            "params": [
                "fajr": 15.0,
                "isha": 15.0
            ]
        ],
        "Egypt": [
            "name": "Egyptian General Authority of Survey",
            "params": [
                "fajr": 19.5,
                "isha": 17.5
            ]
        ],
        "Makkah": [
            "name": "Umm Al-Qura University, Makkah",
            "params": [
                "fajr": 18.5,
                "isha": "90 min"
            ]
        ],
        "Karachi": [
            "name": "University of Islamic Sciences, Karachi",
            "params": [
                "fajr": 18.0,
                "isha": 18.0
            ]
        ],
        "Tehran": [
            "name": "Institute of Geophysics, University of Tehran",
            "params": [
                "fajr": 17.7,
                "isha": 14.0,
                "maghrib": 4.5,
                "midnight": "Jafari"
            ]
        ],
        "Jafari": [
            "name": "Shia Ithna-Ashari, Leva Institue, Qum",
            "params": [
                "fajr": 16.0,
                "isha": 14.0,
                "maghrib": 4,
                "midnight": "Jafari"
            ]
        ]
    ]
    
    // Default parameters in calculation methods
    let defaultParams = [
        "maghrib": "0 min", "midnight": "Standard"
    ]
    
    // ----------------- Defaut setting -----------------
    var calcMethod = "MWL"
    
    var setting = [
        "imsak": "10 min",
        "dhuhr": "0 min",
        "asr": "Standard",
        "highLats": "NightMiddle"
    ]
    var timeFormat = "24h"
    var timeSuffixes = ["am", "pm"]
    let invalidTime = "-----"
    
    // --------------- Local variables
    var dst: Double
    var jDate: Double
    let coords: Coords
    
    // ------------------------------------------------
    // init
    // ------------------------------------------------
    init() {
        dst = TimeZone.current.isDaylightSavingTime() ? 1 : 0
        jDate = 0
        coords = Coords(lat: 29.3, lng: 48)
    }
    
    // ------------------------------------------------
    // getTimes
    // ------------------------------------------------
    func getTimes(date: Date, coords: Coords, timezone: Int = 0, format: String = "24h") -> String {
        
        
        
        // Save the coords to the local variable
        self.coords.lat = coords.lat
        self.coords.lng = coords.lng
        self.coords.elv = coords.elv
        
        // Extract the Year, Month and the day from the date
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        let year = Double(formatter.string(from: date))
        formatter.dateFormat = "M"
        let month = Double(formatter.string(from: date))
        formatter.dateFormat = "d"
        let day = Double(formatter.string(from: date))
        
        let jDate = julian(year: year!, month: month!, day: day!) - coords.lng / (15 * 24)
        
        computeTimes()
        
        
        
        return "\(jDate)"
    }
    
    // ------------------------------------------------
    // computeTimes()
    // ------------------------------------------------
    func computeTimes() -> String {
        var times: Dictionary<String, Double> = [
            "imsak" : 5, "fajr" : 5, "sunrise" : 6, "dhuhr" : 12, "asr" : 13, "sunset" : 18, "isha" : 18, "maghrib": 18
        ]
        
        times = computePrayerTimes(times: times)
        
        return "\(times)"
    }
    
    // ------------------------------------------------
    // computePrayerTimes()
    // ------------------------------------------------
    func computePrayerTimes(times: Dictionary<String, Double>) -> Dictionary<String, Double> {
        let times = dayPortion(times: times)
        
        
        
        return times
    }
    
    // ------------------------------------------------
    // dayPortion()
    // ------------------------------------------------
    func dayPortion(times: Dictionary<String, Double>) -> Dictionary<String, Double> {
        var times = times
        
        for (key, value) in times {
            times[key] = value/24
        }
        
        return times
    }
    
    
    
    // ------------------------------------------------
    // get julian day
    // ------------------------------------------------
    func julian(year: Double, month: Double, day: Double) -> Double {
        var year = year
        var month = month
        
        if (month <= 2) {
            year -= 1
            month += 12
        }
        let A = floor(year/100)
        let B = 2 - A + floor(A/4)
        let C = floor(365.25 * (year + 4716))
        let JD = C + floor(30.6001 * (month+1)) + day + B - 1524.5
        return JD
    }
    
    
    
    
    // ------------------------------------------------
    // get GMT offset
    // ------------------------------------------------
    func gmtOffset(date: Date) -> Int {
        let seconds = TimeZone.current.secondsFromGMT()
        return seconds / 60 / 60
    }
    
    // convert utc to local time
    func getLocalDateTime(dateUTC: Date) -> Date {
        let seconds = TimeZone.current.secondsFromGMT()
        return dateUTC.addingTimeInterval(TimeInterval(seconds))
    }
    
}




// ------------------------------------------------
// Coords class
// ------------------------------------------------
class Coords {
    var lat: Double, lng: Double, elv: Double
    
    init(lat: Double, lng: Double, elv: Double = 0) {
        self.lat = lat
        self.lng = lng
        self.elv = elv
    }
}


