//
//  UserSettings.swift
//  AlzayedPrayerTimes
//
//  Created by Abdulrazzaq Alzayed on 9/17/18.
//  Copyright © 2018 Kuwait-It. All rights reserved.
//

import Foundation

// ------------------------------------------------
// ------------------------------------------------
// UserSettings class
// ------------------------------------------------
// ------------------------------------------------
class UserSettings {
    public enum Language: Int {
        case English = 0, Arabic
    }
    
    public var language = Language.Arabic
    
    func changeLanguage(language: Language) {
        self.language = language
    }
}
