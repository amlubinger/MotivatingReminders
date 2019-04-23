//
//  Settings.swift
//  Motivating Reminders
//
//  Third tab (farthest right) in the navigation controller.
//  Provides settings for the user to adjust (i.e. color scheme and default sorting mechanism).
//
//  Created by Andrew Lubinger on 2/24/19.
//  Copyright © 2019 Andrew Lubinger. All rights reserved.
//

import Foundation
import UIKit

class Settings: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    // MARK: IBOutlets
    
    @IBOutlet weak var settingsLabel: UILabel!
    @IBOutlet weak var colorSchemeLabel: UILabel!
    @IBOutlet weak var colorSchemePicker: UIPickerView!
    @IBOutlet weak var defaultSortingLabel: UILabel!
    @IBOutlet weak var defaultSortingPicker: UIPickerView!
    @IBOutlet weak var breakerOne: UIView!
    @IBOutlet weak var breakerTwo: UIView!
    @IBOutlet weak var breakerThree: UIView!
    @IBOutlet weak var website: UITextView!
    
    let sortingOptions = ["Chronological", "Category", "Completed"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        setColorScheme()
        colorSchemePicker.selectRow(Globals.colorScheme, inComponent: 0, animated: false)
        defaultSortingPicker.selectRow(Globals.defaultSorting, inComponent: 0, animated: false)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return Globals.colorScheme == 3 ? .lightContent : .default
    }
    
    func setColorScheme() {
        view.backgroundColor = Globals.colors[Globals.colorScheme].background
        settingsLabel.textColor = Globals.colors[Globals.colorScheme].label1
        colorSchemeLabel.textColor = Globals.colors[Globals.colorScheme].label1
        defaultSortingLabel.textColor = Globals.colors[Globals.colorScheme].label1
        breakerOne.backgroundColor = Globals.colors[Globals.colorScheme].contrast
        breakerTwo.backgroundColor = Globals.colors[Globals.colorScheme].contrast
        breakerThree.backgroundColor = Globals.colors[Globals.colorScheme].contrast
        website.textColor = Globals.colors[Globals.colorScheme].text1
        let holdSpot = defaultSortingPicker.selectedRow(inComponent: 0)
        defaultSortingPicker.reloadAllComponents()
        defaultSortingPicker.selectRow(holdSpot, inComponent: 0, animated: false)
        if Globals.colorScheme == 3 {
            tabBarController?.tabBar.barTintColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        } else {
            tabBarController?.tabBar.barTintColor = nil
        }
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    // MARK: Picker view methods.
    
    //Setup number of components
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //Setup number of rows
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == colorSchemePicker {
            return Globals.colors.count
        } else if pickerView == defaultSortingPicker {
            return sortingOptions.count
        } else {
            return -1
        }
    }
    
    //Setup title for each row
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        if pickerView == colorSchemePicker {
            return NSAttributedString(string: Globals.colors[row].name, attributes: [NSAttributedString.Key.foregroundColor: Globals.colors[row].background, NSAttributedString.Key.strokeColor: Globals.colors[row].contrast, NSAttributedString.Key.strokeWidth: -2]) //Set with the color of the scheme
        } else if pickerView == defaultSortingPicker {
            return NSAttributedString(string: sortingOptions[row], attributes: [NSAttributedString.Key.foregroundColor: Globals.colors[Globals.colorScheme].picker])
        } else {
            return NSAttributedString(string: "NULL")
        }
    }
    
    //A picker changed selection
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == colorSchemePicker {
            Globals.colorScheme = row
            setColorScheme()
        } else if pickerView == defaultSortingPicker {
            Globals.defaultSorting = row
        }
    }
}
