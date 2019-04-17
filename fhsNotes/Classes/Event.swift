//
//  Event.swift
//  fhsNotes
//
//  Created by Peter J So on 4/12/19.
//  Copyright © 2019 Peter J So. All rights reserved.
//

import Foundation
import UIKit

public class Event {
    var subject: String = ""
    var category: String = ""
    var label: String = ""
    var date: String = ""
    
    init(subject: String, category: String, label: String, date: String)
    {
        self.subject = subject
        self.category = category
        self.label = label
        self.date = date
    }
    
    func getSubject() -> String
    {
        return subject
    }
    
    func getCategory() -> String
    {
        return category
    }
    
    func getLabel() -> String
    {
        return label
    }
    
    func getDate() -> String
    {
        return date
    }
    
    func setLabel(newLabel: String)
    {
        label = newLabel
    }
    
    func setSubject(newSubject: String)
    {
        subject = newSubject
    }
    
    func setCategory(newCategory: String)
    {
        category = newCategory
    }
    
    func setDate(newDate: String)
    {
        date = newDate
    }
    
}
