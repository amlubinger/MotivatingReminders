//
//  ReminderObject.swift
//  Motivating Reminders
//
//  An object to store the reminder data.
//
//  Created by Andrew Lubinger on 1/30/19.
//  Copyright © 2019 Andrew Lubinger. All rights reserved.
//

import Foundation
import UserNotifications

//No longer with Equatable since NSCoding needs NSObject
class ReminderObject: NSObject, NSCoding {
    
    //Conform to NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.title, forKey: "title")
        aCoder.encode(self.date, forKey: "date")
        aCoder.encode(self.repetition, forKey: "repetition")
        aCoder.encode(self.category, forKey: "category")
        aCoder.encode(self.note, forKey: "note")
        aCoder.encode(self.remindMessage, forKey: "remindMessage")
    }
    
    // MARK: Encoding init
    
    required init?(coder aDecoder: NSCoder) {
        if let title = aDecoder.decodeObject(forKey: "title") as? String {
            self.title = title
        } else {
            return nil
        }
        if let date = aDecoder.decodeObject(forKey: "date") as? Date {
            self.date = date
        } else {
            return nil
        }
        if let repetition = aDecoder.decodeObject(forKey: "repetition") as? String {
            self.repetition = repetition
        } else {
            return nil
        }
        if let category = aDecoder.decodeObject(forKey: "category") as? String {
            self.category = category
        } else {
            return nil
        }
        if let note = aDecoder.decodeObject(forKey: "note") as? String {
            self.note = note
        } else {
            return nil
        }
        if let remindMessage = aDecoder.decodeObject(forKey: "remindMessage") as? String {
            self.remindMessage = remindMessage
        } else {
            return nil
        }
    }
    
    // MARK: Equality
    
    override func isEqual(_ object: Any?) -> Bool {
        //return self == (object as? ReminderObject)
        if let reminder = object as? ReminderObject {
            return (self.title == reminder.title) && (self.date == reminder.date) && (self.repetition == reminder.repetition) && (self.category == reminder.category) && (self.note == reminder.note) && (self.remindMessage == reminder.remindMessage)
        }
        
        return false
    }
    
    var title: String
    var date: Date
    var repetition: String //in a switch statement check if it matches "Never", "Daily", "Weekly", "Monthly", or "Yearly"
    var category: String //in a switch statement check if it matches each category
    var note: String
    var remindMessage: String
    
    // MARK: init
    
    public init(title: String, date: Date, repetition: String, category: String, note: String) {
        self.title = title
        self.date = date
        self.repetition = repetition
        self.category = category
        self.note = note
        
        //Set a nice remindMessage as a smart feature based on the given information
        let titleIgnoreCase = title.lowercased()
        var message = ""
        switch self.category {
        case "Exercise":
            if titleIgnoreCase.contains("workout") {
                let messages = ["Have a nice workout!", "Work hard!", "Give it your all!"]
                message = messages.randomElement()!
            } else if titleIgnoreCase.contains("lift") {
                let messages = ["Go pump that iron!", "#Gainz"]
                message = messages.randomElement()!
            } else if titleIgnoreCase.contains("basketball") {
                let messages = ["Play hard!", "Have fun hooping!", "Go ball out!"]
                message = messages.randomElement()!
            } else if titleIgnoreCase.contains("run") {
                let messages = ["Have a nice run!", "Run hard!", "Run fast!", "Run Forest, run!"]
                message = messages.randomElement()!
            }
            self.remindMessage = message
        case "Education":
            if titleIgnoreCase.contains("exam") {
                let messages = ["You can do great on your Exam!", "You're the smartest person I know!", "Go ace that Exam!", "You can do it!", "Show them what you know!"]
                message = messages.randomElement()!
            } else if titleIgnoreCase.contains("quiz") {
                let messages = ["You can do great on your Quiz!", "You're the smartest person I know!", "Go ace that Quiz!", "You can do it!", "Show them what you know!"]
                message = messages.randomElement()!
            } else if titleIgnoreCase.contains("test") {
                let messages = ["You can do great on your Test!", "You're the smartest person I know!", "Go ace that Test!", "You can do it!", "Show them what you know!"]
                message = messages.randomElement()!
            } else if titleIgnoreCase.contains("homework") {
                let messages = ["Work hard on your homework!", "You're the smartest person I know!", "Get it done!", "You can do it!", "Show them what you know!"]
                message = messages.randomElement()!
            } else if titleIgnoreCase.contains("read") {
                let messages = ["Reading grows expands your knowledge!", "Always read when you can!", "Go learn something new!"]
                message = messages.randomElement()!
            }
            self.remindMessage = message
        case "Relaxation":
            self.remindMessage = message
        case "Social":
            if titleIgnoreCase.contains("party") {
                let messages = ["Have fun at the party!", "Party safely!"]
                message = messages.randomElement()!
            } else if titleIgnoreCase.contains("date") {
                let messages = ["Have a nice date!", "Excited for your date? I am!", "Got everything you need for your date?", "You can do it!", "Be yourself!", "Be your best you!"]
                message = messages.randomElement()!
            } else if titleIgnoreCase.contains("bar") {
                let messages = ["Be responsible!", "Have fun!", "Don't drink and drive!"]
                message = messages.randomElement()!
            } else if titleIgnoreCase.contains("birthday") {
                let messages = ["Happy Birthday!", "Have fun!", "Celebrate!", "Yay!"]
                message = messages.randomElement()!
            }
            self.remindMessage = message
        case "Work":
            self.remindMessage = message
        case "Zzz":
            //Other - Stored behind the scenes as Zzz so it is sorted in the correct order
            self.remindMessage = message
        default:
            self.remindMessage = message
        }
    }
    
    //Test if the reminder has completed
    func isCompleted() -> Bool {
        return (self.repetition == "Never") && (self.date < Date()) //Completed iff reminder is never repeated and the current date is past the reminder
    }
    
    //Returns a date of corresponding to the next expected alert based on repetition and current date
    func nextAlert() -> Date {
        var dateToReturn = Date()
        
        if self.isCompleted() {
            dateToReturn = Date.distantPast
        } else if self.date.timeIntervalSinceNow > 0 {
            dateToReturn = self.date
        } else if self.repetition == "Yearly" {
            dateToReturn = Calendar.current.nextDate(after: Date(), matching: Calendar.current.dateComponents([.month, .day, .hour, .minute, .second], from: self.date), matchingPolicy: Calendar.MatchingPolicy.strict)!
        } else if self.repetition == "Monthly" {
            dateToReturn = Calendar.current.nextDate(after: Date(), matching: Calendar.current.dateComponents([.day, .hour, .minute, .second], from: self.date), matchingPolicy: Calendar.MatchingPolicy.strict)!
        } else if self.repetition == "Weekly" {
            dateToReturn = Calendar.current.nextDate(after: Date(), matching: Calendar.current.dateComponents([.hour, .minute, .second, .weekday], from: self.date), matchingPolicy: Calendar.MatchingPolicy.strict)!
        } else if self.repetition == "Daily" {
            dateToReturn = Calendar.current.nextDate(after: Date(), matching: Calendar.current.dateComponents([.hour, .minute, .second], from: self.date), matchingPolicy: Calendar.MatchingPolicy.strict)!
        }
        return dateToReturn
    }
    
    //Returns boolean based on whether or not the event is scheduled for within 1 week into the future
    func isInWeek() -> Bool {
        let now = Date()
        let weekLater = Date().addingTimeInterval(86400 * 7) //86400 seconds in a day
        
        let weekRange = now...weekLater
        
        return weekRange.contains(self.nextAlert())
    }
    
    // MARK: Notification functions
    
    func notifRequest() -> UNNotificationRequest {
        return UNNotificationRequest(identifier: self.identifier(), content: self.notifContent(), trigger: self.notifTrigger())
    }
    
    func notifRemove() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [self.identifier()])
    }
    
    private func notifTrigger() -> UNCalendarNotificationTrigger {
        var componentsToMatch: Set = [Calendar.Component.hour, Calendar.Component.minute]
        var shouldRepeat: Bool
        switch self.repetition {
        case "Never":
            componentsToMatch = componentsToMatch.union([Calendar.Component.day, Calendar.Component.month, Calendar.Component.year])
            shouldRepeat = false
        case "Daily":
            shouldRepeat = true
        case "Weekly":
            componentsToMatch = componentsToMatch.union([Calendar.Component.weekday])
            shouldRepeat = true
        case "Monthly":
            componentsToMatch = componentsToMatch.union([Calendar.Component.day])
            shouldRepeat = true
        case "Yearly":
            componentsToMatch = componentsToMatch.union([Calendar.Component.day, Calendar.Component.month])
            shouldRepeat = true
        default:
            componentsToMatch = componentsToMatch.union([Calendar.Component.day, Calendar.Component.month, Calendar.Component.year])
            shouldRepeat = false
        }
        
        let notification = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents(componentsToMatch, from: self.date), repeats: shouldRepeat)
        
        return notification
    }
    
    private func notifContent() -> UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = self.title
        content.subtitle = self.remindMessage
        content.body = self.note
        content.badge = 1
        content.sound = UNNotificationSound.default
        
        return content
    }
    
    private func identifier() -> String {
        return "Reminder-" + self.title + "-" + self.date.description + "-" + self.repetition + "-" + self.category + "-" +  self.note + "-" + self.remindMessage
    }
}

// MARK: Encoding

extension Collection where Iterator.Element == ReminderObject {
    private static func persistencePath() -> URL? {
        let url = try? FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        return url?.appendingPathComponent("reminderobjects.bin")
    }
    
    func writeToPersistence() throws {
        if let url = Self.persistencePath(), let array = self as? NSArray {
            let data = try? NSKeyedArchiver.archivedData(withRootObject: array, requiringSecureCoding: false)
            try? FileManager.default.removeItem(at: url)
            try data?.write(to: url)
        } else {
            throw NSError(domain: "com.AndrewLubinger.Motivating-Reminders", code: 10, userInfo: nil)
        }
    }
    
    static func readFromPersistence() throws -> [ReminderObject] {
        if let url = Self.persistencePath(), let data = (try Data(contentsOf: url) as Data?) {
            if let array = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [ReminderObject] {
                return array ?? [ReminderObject(title: "___EMPTY-REMINDER___", date: Calendar.current.date(from: DateComponents(calendar: Calendar.current, timeZone: TimeZone.current, era: 1, year: 1, month: 1, day: 1, hour: 1, minute: 1, second: 1, nanosecond: 1))!, repetition: "Never", category: "Other", note: "___EMPTY-REMINDER___")]
            } else {
                throw NSError(domain: "com.AndrewLubinger.Motivating-Reminders", code: 11, userInfo: nil)
            }
        } else {
            throw NSError(domain: "com.AndrewLubinger.Motivating-Reminders", code: 12, userInfo: nil)
        }
    }
}

// MARK: Mock Data
extension ReminderObject {
    public class func getMockData() -> [ReminderObject] {
        return [
            ReminderObject(title: "Calculus Exam", date: Calendar.current.date(from: DateComponents(calendar: Calendar.current, timeZone: TimeZone.current, year: 2019, month: 2, day: 16, hour: 15, minute: 30))!, repetition: "Never", category: "Education", note: "Sullivant Hall Room 120"),
            ReminderObject(title: "Valentines Day Date", date: Calendar.current.date(from: DateComponents(calendar: Calendar.current, timeZone: TimeZone.current, year: 2019, month: 2, day: 14, hour: 19, minute: 0))!, repetition: "Never", category: "Social", note: "Bring flowers."),
            ReminderObject(title: "Math Homework", date: Calendar.current.date(from: DateComponents(calendar: Calendar.current, timeZone: TimeZone.current, year: 2019, month: 2, day: 12, hour: 14, minute: 30))!, repetition: "Never", category: "Education", note: "Pages 270-273 Problems 12-43 even only"),
            ReminderObject(title: "Play Soccer", date: Calendar.current.date(from: DateComponents(calendar: Calendar.current, timeZone: TimeZone.current, year: 2019, month: 2, day: 12, hour: 10, minute: 15))!, repetition: "Never", category: "Exercise", note: "At the ARC"),
            ReminderObject(title: "Dad's Birthday", date: Calendar.current.date(from: DateComponents(calendar: Calendar.current, timeZone: TimeZone.current, year: 2019, month: 2, day: 17, hour: 0, minute: 0))!, repetition: "Yearly", category: "Social", note: "Buy a gift and give call."),
            ReminderObject(title: "Linear Algebra Exam", date: Calendar.current.date(from: DateComponents(calendar: Calendar.current, timeZone: TimeZone.current, year: 2019, month: 2, day: 5, hour: 13, minute: 45))!, repetition: "Never", category: "Education", note: "Study in ECE before."),
            ReminderObject(title: "Mario Party", date: Calendar.current.date(from: DateComponents(calendar: Calendar.current, timeZone: TimeZone.current, year: 2019, month: 2, day: 2, hour: 18, minute: 0))!, repetition: "Never", category: "Social", note: "Have fun")
        ]
    }
}

// MARK: Recommended Reminders
//Used when the add recommendations button is tapped in the overview tab to help balance the user's reminders
//Date().addingTimeInterval(86400) returns a date that is the current date plus one day
//79200 is the number of seconds in a day minus two hours. This is used to avoid overlap when creating multiple daily events. Also the education events arent created and instantly alerted using this strategy
extension ReminderObject {
    public class func getRecommendedData() -> [String:[ReminderObject]] {
        return [
            "NoneExist": [ //Used when the recommended options have been exhausted
                ReminderObject(title: "NoneExist", date: Date.distantPast, repetition: "Never", category: "Other", note: "NO")
                ],
            "Education": [
                ReminderObject(title: "Read a Book", date: Date().addingTimeInterval(79200), repetition: "Daily", category: "Education", note: "Read for 30 minutes"),
                ReminderObject(title: "Read the News", date: Date().addingTimeInterval(79200), repetition: "Daily", category: "Education", note: "Spend time following current events"),
                ReminderObject(title: "Learn Programming", date: Date().addingTimeInterval(79200), repetition: "Daily", category: "Education", note: "Go to codeacademy.com (or another website) to learn how to code!")
                ],
            "Social": [
                ReminderObject(title: "Call a Friend", date: Date().addingTimeInterval(79200 * 2), repetition: "Weekly", category: "Social", note: "Talk for 15 minutes"),
                ReminderObject(title: "Get Food With a Friend", date: Date().addingTimeInterval(79200 * 2), repetition: "Weekly", category: "Social", note: "Eat some yummy food while in good company!")
                ],
            "Exercise": [
                ReminderObject(title: "Exercise", date: Date().addingTimeInterval(79200 * 3), repetition: "Daily", category: "Exercise", note: "Do 15 push ups, 10 sit ups, and 30 jumping jacks.")
                ],
            "Work": [
                ReminderObject(title: "Volunteer", date: Date().addingTimeInterval(79200 * 4), repetition: "Weekly", category: "Work", note: "Volunteer at the local food bank."),
                ReminderObject(title: "Volunteer", date: Date().addingTimeInterval(79200 * 4), repetition: "Weekly", category: "Work", note: "Volunteer at the local parks.")
                ],
            "Relaxation": [
                ReminderObject(title: "Take a Nap", date: Date().addingTimeInterval(79200 * 5), repetition: "Daily", category: "Relaxation", note: "Rest for 20 minutes"),
                ReminderObject(title: "Meditate", date: Date().addingTimeInterval(79200 * 5), repetition: "Daily", category: "Relaxation", note: "For 30 minutes. You can search online to find guided meditation videos."),
                ReminderObject(title: "Walk in a Park", date: Date().addingTimeInterval(79200 * 5), repetition: "Weekly", category: "Relaxation", note: "A nice relaxing walk.")
                ],
        ]
    }
}
