//
//  Events.swift
//  Motivating Reminders
//
//  The first view shown upon launch.
//  Displays list of all reminders which can be sorted in different ways.
//  Button displayed to create a new reminder and reminders displayed can be tapped on to be edited.
//
//  Created by Andrew Lubinger on 12/19/18.
//  Copyright © 2018 Andrew Lubinger. All rights reserved.
//

import UIKit

// MARK: Globals struct.

struct Globals {
    static var reminders: [ReminderObject] = []
    static var reminderTappedOn: ReminderObject = ReminderObject(title: "___EMPTY-REMINDER___", date: Calendar.current.date(from: DateComponents(calendar: Calendar.current, timeZone: TimeZone.current, era: 1, year: 1, month: 1, day: 1, hour: 1, minute: 1, second: 1, nanosecond: 1))!, repetition: "Never", category: "Other", note: "___EMPTY-REMINDER___")
    
    static var colors: [ColorSchemeObject] = []
    static var colorScheme = 0
    
    static var defaultSorting = 0
    
    static var tableFontSize: Float = 17.0
}

class Events: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var state = Globals.defaultSorting
    var remindersToDisplay = [[ReminderObject](), [ReminderObject](), [ReminderObject](), [ReminderObject](), [ReminderObject](), [ReminderObject](), [ReminderObject]()]
    var completedCount = 0

    // MARK: IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addAnEventButton: UIButton!
    @IBOutlet weak var tableAddAnEventButton: UIButton!
    @IBOutlet weak var sortByLabel: UILabel!
    @IBOutlet weak var sortByPicker: UISegmentedControl!
    
    // MARK: IBActions
    
    //Selecting a new segment
    @IBAction func segments(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            //Chronological
            Globals.reminders.sort(by: { $0.nextAlert() < $1.nextAlert() })
            state = 0
            tableView.reloadData()
        case 1:
            //Categorical
            Globals.reminders.sort(by: { $0.category < $1.category })
            state = 1
            tableView.reloadData()
        case 2:
            //Completed
            Globals.reminders.sort(by: { $0.isCompleted() && !$1.isCompleted() }) //sorts so true is first in the array
            state = 2
            tableView.reloadData()
        default:
            break
        }
    }
    
    // MARK: View setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        //Removed and replaced in viewDidAppear. Check if needed
        Globals.reminderTappedOn = ReminderObject(title: "___EMPTY-REMINDER___", date: Calendar.current.date(from: DateComponents(calendar: Calendar.current, timeZone: TimeZone.current, era: 1, year: 1, month: 1, day: 1, hour: 1, minute: 1, second: 1, nanosecond: 1))!, repetition: "Never", category: "Other", note: "___EMPTY-REMINDER___")
        
        state = Globals.defaultSorting
        setUpTableAndSegments()
    }
    
    //was viewDidAppear. Changed to viewWillAppear to fix bug where it loaded the data after the view appeared already, so the reminders visibly jumped to their correct spots.
    override func viewWillAppear(_ animated: Bool) {
        setColorScheme()
        setUpTableAndSegments()
    }
    
    //Segment buttons for sorting
    func setUpTableAndSegments() {
        switch state {
        case 0:
            //Chronological
            Globals.reminders.sort(by: { $0.nextAlert() < $1.nextAlert() })
            tableView.reloadData()
        case 1:
            //Categorical
            Globals.reminders.sort(by: { $0.category < $1.category })
            tableView.reloadData()
        case 2:
            //Completed
            Globals.reminders.sort(by: { $0.isCompleted() && !$1.isCompleted() }) //sorts so true is first in the array
            tableView.reloadData()
        default:
            break
        }
        
        sortByPicker.selectedSegmentIndex = state
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return Globals.colorScheme == 3 ? .lightContent : .default
    }
    
    func setColorScheme() {
        view.backgroundColor = Globals.colors[Globals.colorScheme].background
        addAnEventButton.setTitleColor(Globals.colors[Globals.colorScheme].buttonText, for: UIControl.State.normal)
        addAnEventButton.backgroundColor = Globals.colors[Globals.colorScheme].button
        tableAddAnEventButton.setTitleColor(Globals.colors[Globals.colorScheme].buttonText, for: UIControl.State.normal)
        tableAddAnEventButton.backgroundColor = Globals.colors[Globals.colorScheme].button
        sortByLabel.textColor = Globals.colors[Globals.colorScheme].label2
        sortByPicker.backgroundColor = Globals.colors[Globals.colorScheme].segmentBack
        sortByPicker.tintColor = Globals.colors[Globals.colorScheme].segmentTint
        tableView.backgroundColor = Globals.colors[Globals.colorScheme].tableBack
        if Globals.colorScheme == 3 {
            tabBarController?.tabBar.barTintColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        } else {
            tabBarController?.tabBar.barTintColor = nil
        }
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    // MARK: Table view functions.
    
    //Setup number of sections
    func numberOfSections(in tableView: UITableView) -> Int {
        remindersToDisplay = [[ReminderObject](), [ReminderObject](), [ReminderObject](), [ReminderObject](), [ReminderObject](), [ReminderObject](), [ReminderObject]()]
        
        switch state {
        case 0:
            return 1
        case 1:
            return remindersToDisplay.count - 1
        case 2:
            return 2
        default:
            return 0
        }
    }

    //Setup number of rows/cells
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        completedCount = 0

        switch state {
        case 0:
            //Completed reminders should only show in the completed tab
            var rows = 0
            for x in Globals.reminders {
                if !x.isCompleted() {
                    remindersToDisplay[0].append(x)
                    rows += 1
                }
            }
            return rows
        case 1:
            //Completed reminders should only show in the completed tab
            var rows = 0
            switch section {
            case 0:
                for x in Globals.reminders {
                    if x.category == "Education" && !x.isCompleted() {
                        remindersToDisplay[1].append(x)
                        rows += 1
                    }
                }
                return rows
            case 1:
                for x in Globals.reminders {
                    if x.category == "Exercise" && !x.isCompleted() {
                        remindersToDisplay[2].append(x)
                        rows += 1
                    }
                }
                return rows
            case 2:
                for x in Globals.reminders {
                    if x.category == "Relaxation" && !x.isCompleted() {
                        remindersToDisplay[3].append(x)
                        rows += 1
                    }
                }
                return rows
            case 3:
                for x in Globals.reminders {
                    if x.category == "Social" && !x.isCompleted() {
                        remindersToDisplay[4].append(x)
                        rows += 1
                    }
                }
                return rows
            case 4:
                for x in Globals.reminders {
                    //Other is stored as Zzz behind the scenes to be sorted in the correct order
                    if x.category == "Work" && !x.isCompleted() {
                        remindersToDisplay[5].append(x)
                        rows += 1
                    }
                }
                return rows
            case 5:
                for x in Globals.reminders {
                    //Other is stored as Zzz behind the scenes to be sorted in the correct order
                    if x.category == "Zzz" && !x.isCompleted() {
                        remindersToDisplay[6].append(x)
                        rows += 1
                    }
                }
                return rows
            default:
                return 0
            }
        case 2:
            var rows = 0
            for x in Globals.reminders {
                if x.isCompleted() {
                    rows += 1
                }
            }
            completedCount = rows
            if section == 0 {
                return rows
            } else {
                return Globals.reminders.count - rows
            }
        default:
            return Globals.reminders.count
        }
    }
    
    //Setup sections
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch state {
        case 0:
            return "Chronological"
        case 1:
            switch section {
            case 0:
                return "Education"
            case 1:
                return "Exercise"
            case 2:
                return "Relaxation"
            case 3:
                return "Social"
            case 4:
                return "Work"
            case 5:
                return "Other"
            default:
                return ""
            }
        case 2:
            switch section {
            case 0:
                return "Completed"
            case 1:
                return "Not Completed"
            default:
                return ""
            }
        default:
            return ""
        }
    }
    
    //Creating each cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reminderCell2", for: indexPath)
        
        cell.textLabel!.font = UIFont.systemFont(ofSize: CGFloat(Globals.tableFontSize))
        cell.detailTextLabel!.font = UIFont.systemFont(ofSize: CGFloat(Globals.tableFontSize - 4.0))
        
        var reminder: ReminderObject
        
        switch state {
        case 0:
            reminder = remindersToDisplay[0][indexPath.row]
        case 1:
            reminder = remindersToDisplay[indexPath.section + 1][indexPath.row]
        case 2:
            if indexPath.section == 0 {
                reminder = Globals.reminders[indexPath.row]
            } else {
                reminder = Globals.reminders[indexPath.row + completedCount]
            }
        default:
            reminder = Globals.reminders[indexPath.row]
        }
        
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
    
    //Selecting a cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch state {
        case 0:
            Globals.reminderTappedOn = remindersToDisplay[0][indexPath.row]
        case 1:
            Globals.reminderTappedOn = remindersToDisplay[indexPath.section + 1][indexPath.row]
        case 2:
            if indexPath.section == 0 {
                Globals.reminderTappedOn = Globals.reminders[indexPath.row]
            } else {
                Globals.reminderTappedOn = Globals.reminders[indexPath.row + completedCount]
            }
        default:
            Globals.reminderTappedOn = ReminderObject(title: "___EMPTY-REMINDER___", date: Calendar.current.date(from: DateComponents(calendar: Calendar.current, timeZone: TimeZone.current, era: 1, year: 1, month: 1, day: 1, hour: 1, minute: 1, second: 1, nanosecond: 1))!, repetition: "Never", category: "Other", note: "___EMPTY-REMINDER___")
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        self.present((self.storyboard?.instantiateViewController(withIdentifier: "CreateEvent"))!, animated: true, completion: nil)
    }
    
    //Slide actions for reminders in the table. Actions available: edit, delete
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            //Select reminder
            switch self.state {
            case 0:
                Globals.reminderTappedOn = self.remindersToDisplay[0][indexPath.row]
            case 1:
                Globals.reminderTappedOn = self.remindersToDisplay[indexPath.section + 1][indexPath.row]
            case 2:
                if indexPath.section == 0 {
                    Globals.reminderTappedOn = Globals.reminders[indexPath.row]
                } else {
                    Globals.reminderTappedOn = Globals.reminders[indexPath.row + self.completedCount]
                }
            default:
                Globals.reminderTappedOn = ReminderObject(title: "___EMPTY-REMINDER___", date: Calendar.current.date(from: DateComponents(calendar: Calendar.current, timeZone: TimeZone.current, era: 1, year: 1, month: 1, day: 1, hour: 1, minute: 1, second: 1, nanosecond: 1))!, repetition: "Never", category: "Other", note: "___EMPTY-REMINDER___")
            }
            
            //Delete?
            let alert = UIAlertController(title: "Delete Reminder?", message: "Are you sure you want to permanently remove this reminder?", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
                
            }))
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (_) in
                Globals.reminders.removeAll(where: { $0 == Globals.reminderTappedOn })
                //Remove notification here
                Globals.reminderTappedOn.notifRemove()
                
                //Remove from table
                tableView.deleteRows(at: [indexPath], with: .fade)
            }))
            
            self.present(alert, animated: true, completion: nil)
        }
        
        let edit = UITableViewRowAction(style: .default, title: "Edit") { (action, indexPath) in
            switch self.state {
            case 0:
                Globals.reminderTappedOn = self.remindersToDisplay[0][indexPath.row]
            case 1:
                Globals.reminderTappedOn = self.remindersToDisplay[indexPath.section + 1][indexPath.row]
            case 2:
                if indexPath.section == 0 {
                    Globals.reminderTappedOn = Globals.reminders[indexPath.row]
                } else {
                    Globals.reminderTappedOn = Globals.reminders[indexPath.row + self.completedCount]
                }
            default:
                Globals.reminderTappedOn = ReminderObject(title: "___EMPTY-REMINDER___", date: Calendar.current.date(from: DateComponents(calendar: Calendar.current, timeZone: TimeZone.current, era: 1, year: 1, month: 1, day: 1, hour: 1, minute: 1, second: 1, nanosecond: 1))!, repetition: "Never", category: "Other", note: "___EMPTY-REMINDER___")
            }
            
            self.present((self.storyboard?.instantiateViewController(withIdentifier: "CreateEvent"))!, animated: true, completion: nil)
        }
        edit.backgroundColor = UIColor.lightGray
        
        return [edit, delete]
    }
    
}

