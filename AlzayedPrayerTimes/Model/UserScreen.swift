//
//  UserInterface.swift
//  AlzayedPrayerTimes
//
//  Created by Abdulrazzaq Alzayed on 9/16/18.
//  Copyright © 2018 Kuwait-It. All rights reserved.
//

import Foundation

// ------------------------------------------------
// ------------------------------------------------
// UserScreen class
// ------------------------------------------------
// ------------------------------------------------
struct UserScreen {
    let noLocationServiceAlert = [
        UserSettings.Language.English : "Please enable location service, the application need it for calculations.",
        UserSettings.Language.Arabic : " الرجاء تفعيل خدمة تحديد الموقع ، البرنامج يحتاجها في حساباته "
    ]
    let fajr = [
        UserSettings.Language.English : "Fajr",
        UserSettings.Language.Arabic : "الفجر"
    ]
    let sunrise = [
        UserSettings.Language.English : "Sunrise",
        UserSettings.Language.Arabic : "الشروق"
    ]
    let dhuhr = [
        UserSettings.Language.English : "Dhuhr",
        UserSettings.Language.Arabic : "الظهر"
    ]
    let asr = [
        UserSettings.Language.English : "Asr",
        UserSettings.Language.Arabic : "العصر"
    ]
    let maghrib = [
        UserSettings.Language.English : "Maghrib",
        UserSettings.Language.Arabic : "المغرب"
    ]
    let isha = [
        UserSettings.Language.English : "Isha",
        UserSettings.Language.Arabic : "العشاء"
    ]
    let sunset = [
        UserSettings.Language.English : "Sunset",
        UserSettings.Language.Arabic : "الغروب"
    ]
    let lastThird = [
        UserSettings.Language.English : "Last Third",
        UserSettings.Language.Arabic : "الثلث الأخير"
    ]
    let ok = [
        UserSettings.Language.English : "OK",
        UserSettings.Language.Arabic : "حسنا"
    ]
    let alert = [
        UserSettings.Language.English : "Alert",
        UserSettings.Language.Arabic : "تنبيه"
    ]
    let hadith = [
        UserSettings.Language.Arabic : "عَنْ أَبِي هُرَيْرَةَ ـ رضى الله عنه ـ أَنَّ رَسُولَ اللَّهِ صلى الله عليه وسلم قَالَ يَنْزِلُ رَبُّنَا تَبَارَكَ وَتَعَالَى كُلَّ لَيْلَةٍ إِلَى السَّمَاءِ الدُّنْيَا حِينَ يَبْقَى ثُلُثُ اللَّيْلِ الآخِرُ يَقُولُ مَنْ يَدْعُونِي فَأَسْتَجِيبَ لَهُ مَنْ يَسْأَلُنِي فَأُعْطِيَهُ مَنْ يَسْتَغْفِرُنِي فَأَغْفِرَ لَهُ - صحيح البخاري",
        UserSettings.Language.English : "Allah's Messenger (ﷺ) (p.b.u.h) said, \"Our Lord, the Blessed, the Superior, comes every night down on the nearest Heaven to us when the last third of the night remains, saying: \"Is there anyone to invoke Me, so that I may respond to invocation? Is there anyone to ask Me, so that I may grant him his request? Is there anyone seeking My forgiveness, so that I may forgive him?\" - Sahih al-Bukhari"
    ]
}
