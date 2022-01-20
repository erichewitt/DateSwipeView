//
//  Extensions.swift
//  DateSwipeView
//
//  Created by Eric Hewitt on 1/19/22.
//

import Foundation

extension Date {
    func toDayString(withFormat format: String = "yyyy-MM-dd") -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let str = dateFormatter.string(from: self)
        
        return str
    }
}

struct DateRange : Sequence {
    
    var calendar: Calendar
    var startDate: Date
    var endDate: Date
    var stepUnits: Calendar.Component
    var stepValue: Int
    var multiplier: Int
    
    func makeIterator() -> Generator {
        return Generator(range: self)
    }
    
    struct Generator: IteratorProtocol {
        
        var range: DateRange
        
        mutating func next() -> Date? {
            guard let nextDate = range.calendar.date(byAdding: range.stepUnits,
                                                     value: range.stepValue * range.multiplier,
                                                     to: range.startDate) else {
                return nil
            }
            if nextDate > range.endDate {
                return nil
            }
            else {
                range.multiplier += 1
                return nextDate
            }
        }
    }
}

extension Calendar {
    func dateRange(startDate: Date,
                   endDate: Date,
                   stepUnits: Calendar.Component,
                   stepValue: Int) -> DateRange {
        let dateRange = DateRange(calendar: self,
                                  startDate: startDate,
                                  endDate: endDate,
                                  stepUnits: stepUnits,
                                  stepValue: stepValue,
                                  multiplier: 0)
        return dateRange
    }
    
    func daysBetween(_ from: Date, and to: Date) -> Int {
        let fromDate = startOfDay(for: from) // <1>
        let toDate = startOfDay(for: to) // <2>
        let numberOfDays = dateComponents([.day], from: fromDate, to: toDate) // <3>
        
        return numberOfDays.day!
    }
}
