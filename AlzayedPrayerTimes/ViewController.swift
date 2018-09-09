//
//  ViewController.swift
//  AlzayedPrayerTimes
//
//  Created by Abdulrazzaq Alzayed on 9/5/18.
//  Copyright © 2018 Kuwait-It. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var sunrise: UILabel!
    @IBOutlet weak var sunset: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let myTime = PrayerTimes()
        
        let coords = Coords(lat: 29.3, lng: 47.9)
        
        sunrise.text = "jDate\(myTime.getTimes(date: Date(), coords: coords))"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}



