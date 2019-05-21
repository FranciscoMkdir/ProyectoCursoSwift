//
//  extensions.swift
//  ejemplo1
//
//  Created by macbook on 20/05/19.
//  Copyright © 2019 macbook. All rights reserved.
//

import UIKit


extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}


extension Date{
    func isCurrentBirthday(_ birthday: Date) -> Bool {
        let calendar = Calendar(identifier: .gregorian)
        let month = calendar.component(.month, from: birthday)
        let day = calendar.component(.day, from: birthday)
        let currentMonth = calendar.component(.month, from: self)
        let currentDay = calendar.component(.day, from: self)
        if month == currentMonth{
            if (currentDay...currentDay + 5).contains(day){
                return true
            }else{
                return false
            }
        }else{
            return false
        }
    }
    
    func calculate(birthday: Date) -> Int {
        let calendar = Calendar(identifier: .gregorian)
        let calcAge = calendar.dateComponents([Calendar.Component.year], from: birthday, to: self)
        let age = calcAge.year
        return age!
    }
}
