//
//  ColorSchemeObject.swift
//  Motivating Reminders
//
//  An object to store color scheme data.
//
//  Created by Andrew Lubinger on 2/24/19.
//  Copyright © 2019 Andrew Lubinger. All rights reserved.
//

import Foundation
import UIKit
import Charts

class ColorSchemeObject {
    
    var name: String
    var background: UIColor
    var button: UIColor
    var buttonText: UIColor
    var textBack: UIColor
    var label1: UIColor
    var label2: UIColor
    var text1: UIColor
    var text2: UIColor
    var text3: UIColor
    var text4: UIColor
    var contrast: UIColor
    var tableBack: UIColor
    var tableCell: UIColor
    var segmentTint: UIColor
    var segmentBack: UIColor
    var picker: UIColor
    var chartScheme: [NSUIColor]
    
    public init(name: String, background: UIColor, button: UIColor, buttonText: UIColor, textBack: UIColor, label1: UIColor, label2: UIColor, text1: UIColor, text2: UIColor, text3: UIColor, text4: UIColor, contrast: UIColor, tableBack: UIColor, tableCell: UIColor, segmentTint: UIColor, segmentBack: UIColor, picker: UIColor, chartScheme: [NSUIColor]) {
        self.name = name
        self.background = background
        self.button = button
        self.buttonText = buttonText
        self.textBack = textBack
        self.label1 = label1
        self.label2 = label2
        self.text1 = text1
        self.text2 = text2
        self.text3 = text3
        self.text4 = text4
        self.contrast = contrast
        self.tableBack = tableBack
        self.tableCell = tableCell
        self.segmentTint = segmentTint
        self.segmentBack = segmentBack
        self.picker = picker
        self.chartScheme = chartScheme
    }
}

// MARK: Color Scheme list - loaded into Globals.colors
// TODO: Change to a set and go by the name
//Set/Modify ChartColorTemplates in Pods.xcodeproj->Pods->Charts->Core->ChartColorTemplates.swift

extension ColorSchemeObject {
    public class func loadColorSchemes() -> [ColorSchemeObject] {
        return [
            ColorSchemeObject(name: "Sand", background: UIColor(red: 251.0/255.0, green: 211.0/255.0, blue: 178.0/255.0, alpha: 1), button: UIColor(red: 146.0/255.0, green: 146.0/255.0, blue: 146.0/255.0, alpha: 1), buttonText: UIColor(red: 1, green: 1, blue: 1, alpha: 1), textBack: UIColor(red: 1, green: 1, blue: 1, alpha: 0.3), label1: UIColor(red: 146.0/255.0, green: 146.0/255.0, blue: 146.0/255.0, alpha: 1), label2: UIColor(red: 0, green: 0, blue: 0, alpha: 1), text1: UIColor(red: 146.0/255.0, green: 146.0/255.0, blue: 146.0/255.0, alpha: 1), text2: UIColor(red: 1, green: 1, blue: 1, alpha: 1), text3: UIColor(red: 0, green: 0, blue: 0, alpha: 1), text4: UIColor(red: 0, green: 0, blue: 0, alpha: 1), contrast: UIColor(red: 1, green: 1, blue: 1, alpha: 1), tableBack: UIColor(red: 212.0/255.0, green: 211.0/255.0, blue: 209.0/255.0, alpha: 1), tableCell: UIColor(red: 251.0/255.0, green: 211.0/255.0, blue: 178.0/255.0, alpha: 1), segmentTint: UIColor(red: 212.0/255.0, green: 211.0/255.0, blue: 209.0/255.0, alpha: 1), segmentBack: UIColor(red: 146.0/255.0, green: 146.0/255.0, blue: 146.0/255.0, alpha: 1), picker: UIColor(red: 0, green: 0, blue: 0, alpha: 1), chartScheme: ChartColorTemplates.vordiplom()),
            ColorSchemeObject(name: "Coral", background: UIColor(red: 245.0/255.0, green: 144.0/255.0, blue: 124.0/255.0, alpha: 1), button: UIColor(red: 251.0/255.0, green: 211.0/255.0, blue: 178.0/255.0, alpha: 1), buttonText: UIColor(red: 245.0/255.0, green: 144.0/255.0, blue: 124.0/255.0, alpha: 1), textBack: UIColor(red: 251.0/255.0, green: 211.0/255.0, blue: 178.0/255.0, alpha: 1), label1: UIColor(red: 251.0/255.0, green: 211.0/255.0, blue: 178.0/255.0, alpha: 1), label2: UIColor(red: 251.0/255.0, green: 211.0/255.0, blue: 178.0/255.0, alpha: 1), text1: UIColor(red: 251.0/255.0, green: 211.0/255.0, blue: 178.0/255.0, alpha: 1), text2: UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1), text3: UIColor(red: 212.0/255.0, green: 211.0/255.0, blue: 209.0/255.0, alpha: 1), text4: UIColor(red: 146.0/255.0, green: 146.0/255.0, blue: 146.0/255.0, alpha: 1), contrast: UIColor(red: 0, green: 0, blue: 0, alpha: 1), tableBack: UIColor(red: 251.0/255.0, green: 211.0/255.0, blue: 178.0/255.0, alpha: 1), tableCell: UIColor(red: 245.0/255.0, green: 144.0/255.0, blue: 124.0/255.0, alpha: 1), segmentTint: UIColor(red: 212.0/255.0, green: 211.0/255.0, blue: 209.0/255.0, alpha: 1), segmentBack: UIColor(red: 146.0/255.0, green: 146.0/255.0, blue: 146.0/255.0, alpha: 1), picker: UIColor(red: 0, green: 0, blue: 0, alpha: 1), chartScheme: ChartColorTemplates.liberty()),
            ColorSchemeObject(name: "Classic", background: UIColor(red: 0.0/255.0, green: 177.0/255.0, blue: 255.0/255.0, alpha: 1), button: UIColor(red: 244.0/255.0, green: 180/255.0, blue: 63.0/255.0, alpha: 1), buttonText: UIColor(red: 0, green: 0, blue: 0, alpha: 1), textBack: UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 0.3), label1: UIColor(red: 244.0/255.0, green: 180/255.0, blue: 63.0/255.0, alpha: 1), label2: UIColor(red: 0, green: 0, blue: 0, alpha: 1), text1: UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1), text2: UIColor(red: 0, green: 0, blue: 0, alpha: 1), text3: UIColor(red: 1, green: 1, blue: 1, alpha: 1), text4: UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1), contrast: UIColor(red: 0, green: 0, blue: 0, alpha: 1), tableBack: UIColor(red: 1, green: 1, blue: 1, alpha: 1), tableCell: UIColor(red: 0.0/255.0, green: 177.0/255.0, blue: 255.0/255.0, alpha: 1), segmentTint: UIColor(red: 244.0/255.0, green: 180/255.0, blue: 63.0/255.0, alpha: 1), segmentBack: UIColor(red: 0.0/255.0, green: 177.0/255.0, blue: 255.0/255.0, alpha: 1), picker: UIColor(red: 0, green: 0, blue: 0, alpha: 1), chartScheme: ChartColorTemplates.material()),
            ColorSchemeObject(name: "Ultra Dark", background: UIColor(red: 0, green: 0, blue: 0, alpha: 1), button: UIColor(red: 1, green: 1, blue: 1, alpha: 0.5), buttonText: UIColor(red: 0, green: 0, blue: 0, alpha: 1), textBack: UIColor(red: 1, green: 1, blue: 1, alpha: 0.15), label1: UIColor(red: 1, green: 1, blue: 1, alpha: 0.8), label2: UIColor(red: 1, green: 1, blue: 1, alpha: 0.7), text1: UIColor(red: 1, green: 1, blue: 1, alpha: 0.7), text2: UIColor(red: 1, green: 1, blue: 1, alpha: 1), text3: UIColor(red: 1, green: 1, blue: 1, alpha: 0.3), text4: UIColor(red: 1, green: 1, blue: 1, alpha: 1), contrast: UIColor(red: 1, green: 1, blue: 1, alpha: 1), tableBack: UIColor(red: 15.0/255.0, green: 15.0/255.0, blue: 15.0/255.0, alpha: 1), tableCell: UIColor(red: 0, green: 0, blue: 0, alpha: 1), segmentTint: UIColor(red: 160.0/255.0, green: 160.0/255.0, blue: 160.0/255.0, alpha: 1), segmentBack: UIColor(red: 30.0/255.0, green: 30.0/255.0, blue: 30.0/255.0, alpha: 1), picker: UIColor(red: 1, green: 1, blue: 1, alpha: 1), chartScheme: ChartColorTemplates.pastel())
        ]
    }
}
