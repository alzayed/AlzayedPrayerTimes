//
//  ViewController.swift
//  AlzayedPrayerTimes
//
//  Created by Abdulrazzaq Alzayed on 9/5/18.
//  Copyright © 2018 Kuwait-It. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var fajr: UILabel!
    @IBOutlet weak var sunset: UILabel!
    @IBOutlet weak var lastThird: UILabel!
    
    var locationManager: CLLocationManager!
    
    var coords = Coords(lat: 0, lng: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled(){
            locationManager.startUpdatingLocation()
        }
        
        print("viewDidLoad() called")
        
        
        
    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status != .authorizedWhenInUse {return}
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        let locValue: CLLocationCoordinate2D = manager.location!.coordinate
        print("locations = \(locValue.latitude), \(locValue.longitude)")
        
        let coords = Coords(lat: locValue.latitude, lng: locValue.longitude)
        
        let times = PrayerTimes()
        
        let date = Date()
        
        fajr.text = "\(times.getTimes(date: date, coords: coords)["fajr"] ?? "Not Available")"
        sunset.text = "\(times.getTimes(date: date, coords: coords)["sunset"] ?? "Not Available")"
        lastThird.text = "\(times.getTimes(date: date, coords: coords)["lastthird"] ?? "Not Available")"
    }
    
    
    

}



