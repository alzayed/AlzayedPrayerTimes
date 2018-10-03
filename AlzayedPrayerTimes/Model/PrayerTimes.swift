//
//  PrayerTimes.swift
//  AlzayedPrayerTimes
//
//  Created by Abdulrazzaq Alzayed on 9/5/18.
//  Copyright © 2018 Kuwait-It. All rights reserved.
//

import Foundation

// ------------------------------------------------
// ------------------------------------------------
// PrayerTimes class
// ------------------------------------------------
// ------------------------------------------------
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
                "isha": 17.0,
                "maghrib": "0 min",
                "midnight": "Standard"
            ]
        ],
        "KWT": [
            "name": "Muslim World League",
            "params": [
                "fajr": 18.0,
                "isha": 17.5,
                "maghrib": "0.7 min",
                "midnight": "Standard"
            ]
        ],
        "ISNA": [
            "name": "Islamic Society of North America (ISNA)",
            "params": [
                "fajr": 15.0,
                "isha": 15.0,
                "maghrib": "0 min",
                "midnight": "Standard"
            ]
        ],
        "Egypt": [
            "name": "Egyptian General Authority of Survey",
            "params": [
                "fajr": 19.5,
                "isha": 17.5,
                "maghrib": "0 min",
                "midnight": "Standard"
            ]
        ],
        "Makkah": [
            "name": "Umm Al-Qura University, Makkah",
            "params": [
                "fajr": 18.5,
                "isha": "90 min",
                "maghrib": "0 min",
                "midnight": "Standard"
            ]
        ],
        "Karachi": [
            "name": "University of Islamic Sciences, Karachi",
            "params": [
                "fajr": 18.0,
                "isha": 18.0,
                "maghrib": "0 min",
                "midnight": "Standard"
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
    
    // ----------------- Defaut setting -----------------
    var calcMethod = "KWT"
    
    var setting: Dictionary<String, Any> = [
        "imsak": "10 min",
        "dhuhr": "0 min",
        "asr": "Standard",
        "highLats": "NightMiddle"
    ]
    
    // ----------------- Local Variables -----------------
    var timeFormat: String = "24h"
    var timeSuffixes = ["am", "pm"]
    let invalidTime = "-----"
    
    var dst = TimeZone.current.isDaylightSavingTime() ? 1 : 0
    var jDate = 0.0
    var coords = Coordinates(lat: 29.3, lng: 48)
    var timeZone: Double = 0.0
    
    let alzayedMath: AlzayedMath
    
    
    
    
    
    
    // ------------------------------------------------
    // getTimes
    // ------------------------------------------------
    func getTimes(date: Date, coords: Coordinates, timezone: Int = 0, format: String = "24h") -> Dictionary<String, Any> {
        
        // Save the coords to the local variable
        self.coords.lat = coords.lat
        self.coords.lng = coords.lng
        self.coords.elv = coords.elv
        
        timeFormat = format
        timeZone = gmtOffset(date: Date())
        
        // Extract the Year, Month and the day from the date
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        let year = Double(formatter.string(from: date))
        formatter.dateFormat = "M"
        let month = Double(formatter.string(from: date))
        formatter.dateFormat = "d"
        let day = Double(formatter.string(from: date))
        
        if let y = year, let m = month, let d = day {
            jDate = julian(year: y, month: m, day: d) - coords.lng / (15 * 24)
        }
        
        
        return computeTimes()
    }
    
    // ------------------------------------------------
    // computeTimes
    // ------------------------------------------------
    func computeTimes() -> Dictionary<String, Any> {
        var times: Dictionary<String, Double> = ["imsak" : 5, "fajr" : 5, "sunrise" : 6, "dhuhr" : 12, "asr" : 13, "sunset" : 18, "isha" : 18, "maghrib": 18]
        
        times = computePrayerTimes(times: times)
        times = adjustTimes(times: times)
        
        if let midNight = setting["midnight"] {
            times["midnight"] = "\(midNight)" == "jafari" ?
                times["sunset"]! + timeDiff(time1: times["sunset"]!, time2: times["fajr"]!) / 2 :
                times["sunset"]! + timeDiff(time1: times["sunset"]!, time2: times["sunrise"]!) / 2
        }
        
        
        times["nightlong"] = timeDiff(time1: times["sunset"]!, time2: times["fajr"]!)
        
        times["onethirdnight"] = times["nightlong"]! / 3
        
        times["lastthird"] = times["fajr"]! - times["onethirdnight"]!
        
        let editedTimes = modifyFormat(times: times)
        
        return editedTimes
    }
    
    
    
    // ------------------------------------------------
    // modifyFormat
    // ------------------------------------------------
    func modifyFormat(times: Dictionary<String, Double>) -> Dictionary<String, Any> {
        var editedTimes: Dictionary<String, Any> = times
        for (k, _) in times {
            editedTimes[k] = getFormattedTime(time: times[k]!, format: timeFormat)
        }
        return editedTimes
    }
    
    
    // ------------------------------------------------
    // getFormattedTime
    // ------------------------------------------------
    func getFormattedTime(time: Double, format: String, suffixes: String = "") -> String {
        
        if time.isNaN {
            return invalidTime
        }
        if format == "Float" {
            return "\(time)"
        }
        
        let editedTime = alzayedMath.fixHour(a: time + 0.5 / 60)
        
        let hours = floor(editedTime)
        let minutes = floor((editedTime - hours) * 60)
        let suffix = format == "12h" ? timeSuffixes[hours < 12 ? 0 : 1] : ""
        let hour = format == "24h" ? twoDigitFormat(num: hours) : "\((hours + 11).truncatingRemainder(dividingBy: 13))"
        return hour + ":" + twoDigitFormat(num: minutes) + suffix
        
    }
    
    
    // ------------------------------------------------
    // twoDigitFormat
    // ------------------------------------------------
    func twoDigitFormat(num: Double) -> String {
        let intNum = Int(num)
        return intNum < 10 ? "0\(intNum)" : "\(intNum)"
    }
    
    
    // ------------------------------------------------
    // adjustTime
    // ------------------------------------------------
    func adjustTimes(times: Dictionary<String, Double>) -> Dictionary<String, Double> {
        let params = setting
        var editedTimes = times
        for (k, _) in editedTimes {
            editedTimes[k]! += timeZone - coords.lng / 15
        }
        if params["highLats"]! as! String != "None" {
            editedTimes = adjustHighLats(times: editedTimes)
        }
        
        if isMin(arg: params["imsak"] as! String) {
            editedTimes["imsak"] = editedTimes["fajr"]! - eval(str: params["imsak"] as! String) / 60
        }
        
        if isMin(arg: params["maghrib"] as! String) {
            editedTimes["maghrib"] = editedTimes["sunset"]! + eval(str: params["maghrib"] as! String) / 60
        }
        
        if isMin(arg: String(describing: params["isha"])) {
            editedTimes["isha"] = editedTimes["maghrib"]! + eval(str: params["isha"] as! String) / 60
        }
        
        editedTimes["dhuhr"]! += (eval(str: params["dhuhr"] as! String) / 60)
        
        return editedTimes
    }
    
    
    // ------------------------------------------------
    // isMin
    // ------------------------------------------------
    func isMin(arg: String) -> Bool {
        return arg.contains("min")
    }
    
    
    // ------------------------------------------------
    // adjustHighLats
    // ------------------------------------------------
    func adjustHighLats(times: Dictionary<String, Double>) -> Dictionary<String, Double> {
        var editedTimes = times
        let params: Dictionary<String, Any> = setting

        let nightTime = timeDiff(time1: times["sunset"]!, time2: times["sunrise"]!)
        
        editedTimes["imsak"] = adjustHLTime(time: times["imsak"]!, base: times["sunrise"]!, angle: eval(str: params["imsak"] as! String), night: nightTime, direction: "ccw")
        editedTimes["fajr"] = adjustHLTime(time: times["fajr"]!, base: times["sunrise"]!, angle: params["fajr"] as! Double, night: nightTime, direction: "ccw")
        editedTimes["isha"] = adjustHLTime(time: times["isha"]!, base: times["sunset"]!, angle: params["isha"] as! Double, night: nightTime)
        editedTimes["maghrib"] = adjustHLTime(time: times["maghrib"]!, base: times["sunset"]!, angle: eval(str: params["maghrib"] as! String), night: nightTime)
        
        return editedTimes
    }
    
    
    
    
    // ------------------------------------------------
    // adjustHLTime
    // ------------------------------------------------
    func adjustHLTime(time: Double, base: Double, angle: Double, night: Double, direction: String = "") -> Double {
        var editedTime = time
        let portion = nightPortion(angle: angle, night: night)
        let timeDiff = direction == "ccw" ? self.timeDiff(time1: time, time2: base) : self.timeDiff(time1: base, time2: time)
        if time.isNaN || timeDiff > portion {
            editedTime = base + (direction == "ccw" ?  -portion : portion)
        }
        return editedTime
    }
    
    // ------------------------------------------------
    // nightPortion
    // ------------------------------------------------
    func nightPortion(angle: Double, night: Double) -> Double {
        let method: String = setting["highLats"] as! String
        var portion: Double = 1 / 2 // Midnight
        if method == "AngleBased" {
            portion = 1 / 60 * angle
        }
        if method == "OneSeventh" {
            portion = 1 / 7
        }
        return portion * night
    }
    
    
    
    // ------------------------------------------------
    // timeDiff
    // ------------------------------------------------
    func timeDiff(time1: Double, time2: Double) -> Double {
        return alzayedMath.fixHour(a: time2 - time1)
    }
    
    
    
    // ------------------------------------------------
    // eval
    // ------------------------------------------------
    func eval(str: String) -> Double {
        let num = str.split(separator: " ")[0]
        return Double(num)!
    }
    
    
    // ------------------------------------------------
    // computePrayerTimes
    // ------------------------------------------------
    func computePrayerTimes(times: Dictionary<String, Double>) -> Dictionary<String, Double> {
        let times = dayPortion(times: times)
        var params = setting
        
        let imsak = sunAngleTime(angle: eval(str: params["imsak"] as! String), time: times["imsak"]!, direction: "ccw")
        let fajr = sunAngleTime(angle: params["fajr"] as! Double, time: times["fajr"]!, direction: "ccw")
        let sunrise = sunAngleTime(angle: riseSetAngle(), time: times["sunrise"]!, direction: "ccw")
        let dhuhr = midDay(time: times["dhuhr"]!)
        let asr = asrTime(factor: asrFactor(asrParam: params["asr"] as! String), time: times["asr"]!)
        let sunset = sunAngleTime(angle: riseSetAngle(), time: times["sunset"]!)
        let maghrib = sunAngleTime(angle: eval(str: params["maghrib"] as! String), time: times["maghrib"]!)
        let isha = sunAngleTime(angle: params["isha"] as! Double, time: times["isha"]!)
        
        return ["imsak": imsak,"fajr": fajr,"sunrise": sunrise,"dhuhr": dhuhr,"asr": asr,"sunset": sunset,"maghrib": maghrib,"isha": isha]
    }
    
    
    
    // ------------------------------------------------
    // asrTime
    // ------------------------------------------------
    func asrTime(factor: Double, time: Double) -> Double {
        let decl = sunPosition(jd: jDate + time)["declination"]
        let angel = -alzayedMath.Darccot(x: factor + alzayedMath.Dtan(d: abs(coords.lat - decl!)))
        return sunAngleTime(angle: angel, time: time)
    }
    
    
    
    // ------------------------------------------------
    // asrFactor
    // ------------------------------------------------
    func asrFactor(asrParam: String) -> Double {
        let factor = ["Standard": 1, "Hanafi": 2 ][asrParam]! * 1.0
        return factor
    }
    
    
    // ------------------------------------------------
    // riseSetAngle
    // ------------------------------------------------
    func riseSetAngle() -> Double {
        return 0.0347 * sqrt(coords.elv) + 0.833
    }
    
    
    
    
    // ------------------------------------------------
    // dayPortion
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
    func gmtOffset(date: Date) -> Double {
        let seconds = TimeZone.current.secondsFromGMT()
        return Double(seconds / 60 / 60)
    }
    
    
    
    
    // ------------------------------------------------
    // convert utc to local time
    // ------------------------------------------------
    func getLocalDateTime(dateUTC: Date) -> Date {
        let seconds = TimeZone.current.secondsFromGMT()
        return dateUTC.addingTimeInterval(TimeInterval(seconds))
    }
    
    // ------------------------------------------------
    // midDay
    // ------------------------------------------------
    func midDay(time: Double) -> Double {
        let eqt = sunPosition(jd: jDate + time)["equation"]
        let noon = alzayedMath.fixHour(a: 12 - eqt!)
        return noon
    }
    
    
    // ------------------------------------------------
    // sunAngleTime
    // ------------------------------------------------
    func sunAngleTime(angle: Double, time: Double, direction: String = "") -> Double {
        let decl = sunPosition(jd: jDate + time)["declination"]
        let noon = midDay(time: time)
        
        let t = 1 / 15 * alzayedMath.Darccos(d: (-alzayedMath.Dsin(d: angle) - alzayedMath.Dsin(d: decl!) * alzayedMath.Dsin(d: coords.lat)) / (alzayedMath.Dcos(d: decl!) * alzayedMath.Dcos(d: coords.lat)))
        
        return noon + (direction == "ccw" ? -t : t)
    }
    
    
    
    
    
    // ------------------------------------------------
    // sunPosition
    // ------------------------------------------------
    func sunPosition(jd: Double) -> Dictionary<String, Double> {
        
        let D = jd - 2451545.0
        let g = alzayedMath.fixAngle(a: 357.529 + 0.98560028 * D)
        let q = alzayedMath.fixAngle(a: 280.459 + 0.98564736 * D)
        let L = alzayedMath.fixAngle(a: q + 1.915 * alzayedMath.Dsin(d: g) + 0.020 * alzayedMath.Dsin(d: 2 * g))
        
        //let R = 1.00014 - 0.01671 * alzayedMath.Dcos(d: g) - 0.00014 * alzayedMath.Dcos(d: 2 * g)
        let e = 23.439 - 0.00000036 * D
        
        let RA = alzayedMath.Darctan2(y: alzayedMath.Dcos(d: e) * alzayedMath.Dsin(d: L),x: alzayedMath.Dcos(d: L)) / 15
        let eqt = q / 15 - alzayedMath.fixHour(a: RA)
        let decl = alzayedMath.Darcsin(d: alzayedMath.Dsin(d: e) * alzayedMath.Dsin(d: L))
        
        return ["declination": decl, "equation": eqt]
        
    }
    
    
    
    // ------------------------------------------------
    // init
    // ------------------------------------------------
    init() {
        alzayedMath = AlzayedMath()
        let selectedMothod = methods[calcMethod]!
        let params = selectedMothod["params"]! as! Dictionary<String, Any>
        
        for (k, v) in params {
            setting[k] = v
        }
        
    }
    
    
}











