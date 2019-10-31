//
//  TodayViewController.swift
//  Motivating Reminders Widget
//
//  Created by Andrew Lubinger on 10/25/19.
//  Copyright © 2019 Andrew Lubinger. All rights reserved.
//

import UIKit
import NotificationCenter

// MARK: Globals struct.

struct Globals {
    static var reminders: [ReminderObject] = []
    static var reminderTappedOn: ReminderObject = ReminderObject(title: "___EMPTY-REMINDER___", date: Calendar.current.date(from: DateComponents(calendar: Calendar.current, timeZone: TimeZone.current, era: 1, year: 1, month: 1, day: 1, hour: 1, minute: 1, second: 1, nanosecond: 1))!, repetition: "Never", category: "Other", note: "___EMPTY-REMINDER___")
    
    static var colors: [ColorSchemeObject] = []
    static var colorScheme = 0
    
    static var defaultSorting = 0
    
    static var tableFontSize: Float = 17.0
}

class TodayViewController: UIViewController, NCWidgetProviding, UITableViewDataSource, UITableViewDelegate {
    
    let defaults = UserDefaults(suiteName: "group.com.AndrewLubinger.Motivating-Reminders")
    var remindersToDisplay = [ReminderObject]()
        
    @IBOutlet weak var chronologicalTable: UITableView!
    @IBOutlet weak var noRemindersLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        extensionContext?.widgetLargestAvailableDisplayMode = .expanded
    }
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        let expanded = activeDisplayMode == .expanded
        preferredContentSize = expanded ? CGSize(width: maxSize.width, height: 285) : maxSize
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
        
    // MARK: Data loading.
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        //Using NSEncoding since it is storing objects
        do {
            Globals.reminders = try [ReminderObject].readFromPersistence()
        }
        catch let error as NSError {
            if error.domain == NSCocoaErrorDomain && error.code == NSFileReadNoSuchFileError {
                NSLog("No persistence file found, not necessarily an error...")
            } else {
                NSLog("Error loading from persistence: \(error)")
                completionHandler(NCUpdateResult.failed)
            }
        }
        
        //Using defaults since these are settings
        Globals.colorScheme = defaults!.integer(forKey: "colorScheme") //returns 0 if there is no data yet, which is what we want anyway
        Globals.defaultSorting = defaults!.integer(forKey: "defaultSorting")
        Globals.tableFontSize = defaults!.float(forKey: "tableFontSize")
        if Globals.tableFontSize == 0 {
            Globals.tableFontSize = 17.0
        }
        
        //Makes the Globals struct less chaotic
        Globals.colors = ColorSchemeObject.loadColorSchemes()
        
        chronologicalTable.backgroundColor = Globals.colors[Globals.colorScheme].tableBack
        
        //Incompleted reminders only
        for x in Globals.reminders {
            if !x.isCompleted() {
                remindersToDisplay.append(x)
            }
        }
        remindersToDisplay.sort(by: { $0.nextAlert() < $1.nextAlert() })
        
        noRemindersLabel.isHidden = !remindersToDisplay.isEmpty
        view.backgroundColor = Globals.colors[Globals.colorScheme].background
        noRemindersLabel.textColor = Globals.colors[Globals.colorScheme].label1
        chronologicalTable.isHidden = remindersToDisplay.isEmpty
        
        chronologicalTable.reloadData()
        
        completionHandler(NCUpdateResult.newData)
    }
    
    // MARK: Table view functions.
    
    //Setup number of sections
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    //Setup number of rows/cells
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //Only 5 fit in the max height.
        return remindersToDisplay.count < 5 ? remindersToDisplay.count : 5
    }
    
    //Creating each cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reminderCell2", for: indexPath)
        
        cell.textLabel!.font = UIFont.systemFont(ofSize: CGFloat(Globals.tableFontSize))
        cell.detailTextLabel!.font = UIFont.systemFont(ofSize: CGFloat(Globals.tableFontSize - 4.0))
        
        let reminder = remindersToDisplay[indexPath.row]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        dateFormatter.dateFormat = "EEEE, " + dateFormatter.dateFormat
        
        let dateString = dateFormatter.string(from: reminder.date)
        
        cell.textLabel?.text = reminder.title
        cell.detailTextLabel?.text =  dateString + " repeated " + reminder.repetition
        cell.textLabel?.textColor = Globals.colors[Globals.colorScheme].text1
        cell.detailTextLabel?.textColor = Globals.colors[Globals.colorScheme].text2
        cell.backgroundColor = Globals.colors[Globals.colorScheme].tableCell
        
        return cell
    }
}
