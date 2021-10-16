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
    var subject: String
    var label: String
    var date: String
    var red: String
    var green: String
    var blue: String
    
    init(subject: String, label: String, date: String, red: String, green: String, blue: String)
    {
        self.subject = subject
        self.label = label
        self.date = date
        self.red = red
        self.green = green
        self.blue = blue
    }
    
    func getSubject() -> String
    {
        return subject
    }
    
    func getLabel() -> String
    {
        return label
    }
    
    func getDate() -> String
    {
        return date
    }
    
    func setLabel(to newLabel: String)
    {
        self.label = newLabel
    }
    
    func setSubject(to newSubject: String)
    {
        self.subject = newSubject
    }
    
    func setDate(to newDate: String)
    {
        self.date = newDate
    }
    
}
