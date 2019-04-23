//
//  CreateEvent.swift
//  Motivating Reminders
//
//  Not a tab in the navigation controller.
//  Accessed by tapping on a displayed reminder or on the add an event button.
//  Allows the creating and editing of reminders.
//
//  Created by Andrew Lubinger on 2/3/19.
//  Copyright © 2019 Andrew Lubinger. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications

class CreateEvent: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let categories = ["Education", "Exercise", "Relaxation", "Social", "Work", "Other"]
    let repetitions = ["Never", "Daily", "Weekly", "Monthly", "Yearly"]
    var chosenCategory = "Education"
    var chosenRepetition = "Never"
    var chosenDate = Date()
    var chosenTitle = ""
    var chosenNote = ""
    
    // MARK: IBOutlets
    
    // TODO: Add a label and picker or something for reminding before the set date/time.
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var categoryPicker: UIPickerView!
    @IBOutlet weak var repetitionPicker: UIPickerView!
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var noteField: UITextView!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var addAnEventLabel: UILabel!
    @IBOutlet weak var optionalNoteLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var repetitionLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var finishButton: UIButton!
    
    // MARK: IBActions
    
    //Finish and save
    @IBAction func finishButton(_ sender: UIButton) {
        chosenCategory = categories[categoryPicker.selectedRow(inComponent: 0)]
        chosenRepetition = repetitions[repetitionPicker.selectedRow(inComponent: 0)]
        chosenDate = datePicker.date
        chosenTitle = titleField.text ?? ""
        chosenNote = noteField.text ?? ""
        
        //Want other to be sorted last when sorting by category, so store it as Zzz behind the scenes
        if chosenCategory == "Other" {
            chosenCategory = "Zzz"
        }
        
        let reminder = ReminderObject(title: chosenTitle, date: chosenDate, repetition: chosenRepetition, category: chosenCategory, note: chosenNote)
        
        if Globals.reminderTappedOn != ReminderObject(title: "___EMPTY-REMINDER___", date: Calendar.current.date(from: DateComponents(calendar: Calendar.current, timeZone: TimeZone.current, era: 1, year: 1, month: 1, day: 1, hour: 1, minute: 1, second: 1, nanosecond: 1))!, repetition: "Never", category: "Other", note: "___EMPTY-REMINDER___") {
            Globals.reminders.removeAll(where: { $0 == Globals.reminderTappedOn })
            
            //Update notification here
            Globals.reminderTappedOn.notifRemove()
        }
        
        Globals.reminders.append(reminder)
        
        //Add notification here
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge, .sound]) { (success, error) in
            if error == nil {
                if success == true {
                    //print("Permission granted")
                }
                else {
                    //print("Permission denied")
                }
            } else {
                print(error as Any)
            }
        }
        let notifRequest = reminder.notifRequest()
        center.add(notifRequest) { (error : Error?) in
            if let theError = error {
                print(theError.localizedDescription)
            }
        }
        
        self.present((self.storyboard?.instantiateInitialViewController())!, animated: true, completion: nil)
    }
    
    //Delete the reminder
    @IBAction func deleteButtonPushed(_ sender: UIButton) {
        let alert = UIAlertController(title: "Delete Reminder?", message: "Are you sure you want to permanently remove this reminder?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
            
        }))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (_) in
            Globals.reminders.removeAll(where: { $0 == Globals.reminderTappedOn })
            //Remove notification here
            Globals.reminderTappedOn.notifRemove()
            
            self.present((self.storyboard?.instantiateInitialViewController())!, animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: View setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        titleField.adjustsFontSizeToFitWidth = true
        
        if Globals.reminderTappedOn != ReminderObject(title: "___EMPTY-REMINDER___", date: Calendar.current.date(from: DateComponents(calendar: Calendar.current, timeZone: TimeZone.current, era: 1, year: 1, month: 1, day: 1, hour: 1, minute: 1, second: 1, nanosecond: 1))!, repetition: "Never", category: "Other", note: "___EMPTY-REMINDER___") {
            
            datePicker.setDate(Globals.reminderTappedOn.date, animated: true)
            switch Globals.reminderTappedOn.category {
            case "Education":
                categoryPicker.selectRow(0, inComponent: 0, animated: true)
            case "Exercise":
                categoryPicker.selectRow(1, inComponent: 0, animated: true)
            case "Relaxation":
                categoryPicker.selectRow(2, inComponent: 0, animated: true)
            case "Social":
                categoryPicker.selectRow(3, inComponent: 0, animated: true)
            case "Work":
                categoryPicker.selectRow(4, inComponent: 0, animated: true)
            case "Zzz":
                categoryPicker.selectRow(5, inComponent: 0, animated: true)
            default:
                categoryPicker.selectRow(0, inComponent: 0, animated: true)
            }
            switch Globals.reminderTappedOn.repetition {
            case "Never":
                repetitionPicker.selectRow(0, inComponent: 0, animated: true)
            case "Daily":
                repetitionPicker.selectRow(1, inComponent: 0, animated: true)
            case "Weekly":
                repetitionPicker.selectRow(2, inComponent: 0, animated: true)
            case "Monthly":
                repetitionPicker.selectRow(3, inComponent: 0, animated: true)
            case "Yearly":
                repetitionPicker.selectRow(4, inComponent: 0, animated: true)
            default:
                repetitionPicker.selectRow(0, inComponent: 0, animated: true)
            }
            titleField.text = Globals.reminderTappedOn.title
            noteField.text = Globals.reminderTappedOn.note
            
            deleteButton.isHidden = false
            deleteButton.isUserInteractionEnabled = true
            deleteButton.isEnabled = true
            
        } else {
            deleteButton.isHidden = true
            deleteButton.isUserInteractionEnabled = false
            deleteButton.isEnabled = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setColorScheme()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return Globals.colorScheme == 3 ? .lightContent : .default
    }
    
    func setColorScheme() {
        view.backgroundColor = Globals.colors[Globals.colorScheme].background
        titleField.backgroundColor = Globals.colors[Globals.colorScheme].textBack
        titleField.textColor = Globals.colors[Globals.colorScheme].text4
        noteField.backgroundColor = Globals.colors[Globals.colorScheme].textBack
        noteField.textColor = Globals.colors[Globals.colorScheme].text4
        addAnEventLabel.textColor = Globals.colors[Globals.colorScheme].label1
        optionalNoteLabel.textColor = Globals.colors[Globals.colorScheme].label2
        repetitionLabel.textColor = Globals.colors[Globals.colorScheme].label2
        categoryLabel.textColor = Globals.colors[Globals.colorScheme].label2
        cancelButton.setTitleColor(Globals.colors[Globals.colorScheme].buttonText, for: UIControl.State.normal)
        cancelButton.backgroundColor = Globals.colors[Globals.colorScheme].button
        finishButton.setTitleColor(Globals.colors[Globals.colorScheme].buttonText, for: UIControl.State.normal)
        finishButton.backgroundColor = Globals.colors[Globals.colorScheme].button
        datePicker.setValue(Globals.colors[Globals.colorScheme].picker, forKey: "textColor")
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    // MARK: Picker view functions.
    
    //Setup number of components
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //Setup number of rows
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == categoryPicker {
            return categories.count
        } else if pickerView == repetitionPicker {
            return repetitions.count
        } else {
            return -1
        }
    }
    
    //Setup labels for each row
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        if pickerView == categoryPicker {
            return NSAttributedString(string: categories[row], attributes: [NSAttributedString.Key.foregroundColor: Globals.colors[Globals.colorScheme].picker])
        } else if pickerView == repetitionPicker {
            return NSAttributedString(string: repetitions[row], attributes: [NSAttributedString.Key.foregroundColor: Globals.colors[Globals.colorScheme].picker])
        } else {
            return NSAttributedString(string: "NULL")
        }
    }
    
    //A picker has been changed
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == categoryPicker {
            chosenCategory = categories[row]
        } else if pickerView == repetitionPicker {
            chosenRepetition = repetitions[row]
        }
    }
    
}
