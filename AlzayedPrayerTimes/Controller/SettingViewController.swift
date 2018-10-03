//
//  SettingViewController.swift
//  AlzayedPrayerTimes
//
//  Created by Abdulrazzaq Alzayed on 9/24/18.
//  Copyright © 2018 Kuwait-It. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let userSettings = UserSettings()
    
    var delegate: SettingDelegate?
    
    let languages = [UserSettings.Language.Arabic, UserSettings.Language.English]
    
    @IBOutlet weak var languagesPicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        languagesPicker.delegate = self
        languagesPicker.dataSource = self
        
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(languages[row])"
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("Current lang: \(userSettings.language)")
        userSettings.language = languages[row]
        print("After changed lang: \(userSettings.language)")
    }
    
    func doSave() {
        print("Save")
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return languages.count
    }
    
    @IBAction func save(_ sender: Any) {
        delegate?.settingReceived(setting: userSettings)
        dismiss(animated: true, completion: doSave)
    }
    
}
