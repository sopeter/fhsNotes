//
//  DayByDay.swift
//  fhsNotes
//
//  Created by Peter J So on 4/11/19.
//  Copyright © 2019 Peter J So. All rights reserved.
//

import Foundation
import UIKit

public class DayByDay {
    var arrayEvents: [Event]
    var date: Date
    
    init(date: Date, arrayEvents: [Event])
    {
        self.arrayEvents = arrayEvents
        self.date = date
    }
    
    func addToArray(newEvent: Event)
    {
        arrayEvents.append(newEvent)
    }
    
    func getEvents() -> String
    {
        for i in 0...arrayEvents.count
        {
            return arrayEvents[i].getLabel()
        }
        // return to string array and add each label to the array
        
        return ""
    }

}
