//
//  ViewController.swift
//  AlzayedPrayerTimes
//
//  Created by Abdulrazzaq Alzayed on 9/5/18.
//  Copyright © 2018 Kuwait-It. All rights reserved.
//
//  Version 1.0
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate, SettingDelegate {
    
    
    

    @IBOutlet weak var hadithScreen: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var fajr: UILabel!
    @IBOutlet weak var sunrise: UILabel!
    @IBOutlet weak var dhuhr: UILabel!
    @IBOutlet weak var asr: UILabel!
    @IBOutlet weak var maghrib: UILabel!
    @IBOutlet weak var isha: UILabel!
    
    @IBOutlet weak var midNight: UILabel!
    @IBOutlet weak var nightLong: UILabel!
    @IBOutlet weak var thirdLong: UILabel!
    
    @IBOutlet weak var lastThirdHeader: UILabel!
    @IBOutlet weak var lastThird: UILabel!
    
    // Stack view (Ar & En)
    @IBOutlet weak var arabicView: UIStackView!
    @IBOutlet weak var englishView: UIStackView!
    
    
    
    // Local variables
    var locationManager = CLLocationManager()
    var coords = Coordinates(lat: 0, lng: 0)
    var userSettings = UserSettings()
    let userScreen = UserScreen()
    var prayersDate = Date()
    
    
    
    
    // ------------------------------------------------
    // viewDidAppear
    // ------------------------------------------------
    override func viewDidAppear(_ animated: Bool) {
        //showSimpleAlert()
    }
    
    
    // ------------------------------------------------
    // viewDidLoad
    // ------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        if userSettings.language == .Arabic {
            englishView.isHidden = true
            arabicView.isHidden = false
        } else {
            englishView.isHidden = false
            arabicView.isHidden = true
        }
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "dd - MM - yyyy"
        
        date.text = dateFormatterPrint.string(from: prayersDate)
        hadithScreen.text = userScreen.hadith[userSettings.language]
        lastThirdHeader.text = userScreen.lastThird[userSettings.language]
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled(){
            locationManager.startUpdatingLocation()
        } else {

        }
        
    }

    
    
    // ------------------------------------------------
    // didReceiveMemoryWarning
    // ------------------------------------------------
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // ------------------------------------------------
    // settingReceived
    // ------------------------------------------------
    func settingReceived(setting: UserSettings) {
        userSettings = setting
        viewDidLoad()
    }
    
    
    // ------------------------------------------------
    // locationManager - didFailWithError
    // ------------------------------------------------
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        lastThird.text = "Location Unavailable"
    }
    
    
    
    // ------------------------------------------------
    // locationManager - didUpdateLocations
    // ------------------------------------------------
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations[locations.count - 1]
        
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            updatePrayerTimes(coords: Coordinates(lat: latitude, lng: longitude))
        }
    }
    
    
    
    // ------------------------------------------------
    // updatePrayerTimes
    // ------------------------------------------------
    func updatePrayerTimes(coords: Coordinates) {
        print("\(coords.lat), \(coords.lng)")
        
        let times = PrayerTimes()
        
        isha.text = "\(times.getTimes(date: prayersDate, coords: coords)["isha"] ?? "Not Available")"
        
        if let ishaTime = isha.text {
            if(isPassMoreThanHourOfIsha(time: ishaTime)) {
                let today = Date()
                if let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: today) {
                    prayersDate = tomorrow
                }
            }
        }
        
        fajr.text = "\(times.getTimes(date: prayersDate, coords: coords)["fajr"] ?? "Not Available")"
        sunrise.text = "\(times.getTimes(date: prayersDate, coords: coords)["sunrise"] ?? "Not Available")"
        dhuhr.text = "\(times.getTimes(date: prayersDate, coords: coords)["dhuhr"] ?? "Not Available")"
        asr.text = "\(times.getTimes(date: prayersDate, coords: coords)["asr"] ?? "Not Available")"
        maghrib.text = "\(times.getTimes(date: prayersDate, coords: coords)["maghrib"] ?? "Not Available")"
        midNight.text = "\(times.getTimes(date: prayersDate, coords: coords)["midnight"] ?? "Not Available")"
        lastThird.text = "\(times.getTimes(date: prayersDate, coords: coords)["lastthird"] ?? "Not Available")"
        nightLong.text = "\(times.getTimes(date: prayersDate, coords: coords)["nightlong"] ?? "Not Available")"
        thirdLong.text = "\(times.getTimes(date: prayersDate, coords: coords)["onethirdnight"] ?? "Not Available")"
    }
    
    
    
    
    
    
    // ------------------------------------------------
    // isPassMoreThanHourOfIsha
    // ------------------------------------------------
    func isPassMoreThanHourOfIsha(time: String) -> Bool {
        if let h = Int(time.split(separator: ":")[0]), let m = Int(time.split(separator: ":")[1]) {
            let ishaFrom0Hour = h * 60 + m
            let calendar = Calendar.current
            let hour = calendar.component(.hour, from: Date())
            let min = calendar.component(.minute, from: Date())
            let currentTimeFrom0Hour = hour * 60 + min
            return (currentTimeFrom0Hour - ishaFrom0Hour > 60)
        }
        return false
    }
    
    
    
    // ------------------------------------------------
    // prepare
    // ------------------------------------------------
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let settingVC = segue.destination as! SettingViewController
        settingVC.delegate = self
    }
    
    
    // ------------------------------------------------
    // goToSetting
    // ------------------------------------------------
    @IBAction func goToSetting(_ sender: Any) {
        performSegue(withIdentifier: "goToSetting", sender: self)
    }
    
    

}



