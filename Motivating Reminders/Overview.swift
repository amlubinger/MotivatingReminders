//
//  Overview.swift
//  Motivating Reminders
//
//  Middle tab in the navigation controller.
//  Displays information determined from the user's reminders.
//  Suggests ways to improve life and mental wellbeing.
//
//  Created by Andrew Lubinger on 12/19/18.
//  Copyright © 2018 Andrew Lubinger. All rights reserved.
//

import UIKit
import UserNotifications

//Charts Pod - To make a beautiful pie chart.
//https://github.com/danielgindi/Charts
import Charts

class Overview: UIViewController {
    
    var categoryCounts: [[String: Int]] = [[:]]
    var categoriesForCreation: [String] = []
    
    let categories = ["Education", "Exercise", "Relaxation", "Social", "Work"]
    let cMessages = ["Education": "Learn as much as you can!", "Exercise": "You'll feel more powerful, happy, and confident!", "Relaxation": "Some rest will rejuvenate you.", "Social": "Time around people will energize you.", "Work": "You will feel accomplished if you get some work done."]
    let recommendedData = ReminderObject.getRecommendedData()
    
    // MARK: IBOutlets
    
    @IBOutlet weak var overviewTitle: UILabel!
    @IBOutlet weak var countSegments: UISegmentedControl!
    @IBOutlet weak var textBox: UITextView!
    @IBOutlet weak var pieChart: PieChartView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var addRecommendationsButton: UIButton!
    @IBOutlet weak var textFromOnline: UITextView!
    
    @IBAction func countSegments(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            pieChartUpdate()
            analysisUpdate()
        case 1:
            pieChartUpdate()
            analysisUpdate()
        default:
            break
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        categoryCounts = countCategories()
        pieChartUpdate()
        analysisUpdate()
        internetPullUpdate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setColorScheme()
        pieChartUpdate()
        pieChart.animate(yAxisDuration: 0.7)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return Globals.colorScheme == 3 ? .lightContent : .default
    }

    func setColorScheme() {
        view.backgroundColor = Globals.colors[Globals.colorScheme].background
        overviewTitle.textColor = Globals.colors[Globals.colorScheme].label1
        countSegments.tintColor = Globals.colors[Globals.colorScheme].segmentTint
        countSegments.backgroundColor = Globals.colors[Globals.colorScheme].segmentBack
        textBox.textColor = Globals.colors[Globals.colorScheme].text1
        textFromOnline.textColor = Globals.colors[Globals.colorScheme].text1
        addRecommendationsButton.setTitleColor(Globals.colors[Globals.colorScheme].buttonText, for: UIControl.State.normal)
        addRecommendationsButton.backgroundColor = Globals.colors[Globals.colorScheme].button
//        pieChart.chartDescription?.textColor = Globals.colors[Globals.colorScheme].label2
//        pieChart.legend.textColor = Globals.colors[Globals.colorScheme].label2
//        pieChart.centerAttributedText = NSAttributedString(string: "Reminder\nAnalysis", attributes: [NSAttributedString.Key.foregroundColor: Globals.colors[Globals.colorScheme].label1])
//        pieChart.notifyDataSetChanged()
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    //Returns an array of 2 dictionaries.
    //Index 0 has a dictionary with values based on repetition of the reminder while index 1 is a simple count of each category.
    func countCategories() -> [[String: Int]]{
        var counts: [[String: Int]] = [[:],[:]]
        
        for reminder in Globals.reminders {
            
            if reminder.isInWeek() { //smart count: only counts current events (within a week into the future; ignoring far off events to get a better representation of the user's life) and has different weighting based on the repetition
                var increment: Int
                switch reminder.repetition {
                case "Never":
                    increment = 1
                case "Daily":
                    increment = 7
                case "Weekly":
                    increment = 3
                case "Yearly":
                    increment = 2
                default:
                    increment = 1
                }
                
                counts[0].updateValue((counts[0][reminder.category == "Zzz" ? "Other" : reminder.category] ?? 0) + increment, forKey: reminder.category == "Zzz" ? "Other" : reminder.category) //Adds the key/value if its not there already, otherwise adds the increment to the value. Uses the key "Other" in the case that category is "Zzz" as seen in the reminder object implementation.
            }
            
            //basic count: counts every single reminder exactly once
            counts[1].updateValue((counts[1][reminder.category == "Zzz" ? "Other" : reminder.category] ?? 0) + 1, forKey: reminder.category == "Zzz" ? "Other" : reminder.category) //Adds the key/value if its not there already, otherwise adds 1 to the value. Uses the key "Other" in the case that category is "Zzz" as seen in the reminder object implementation.
        }
        
        return counts
    }
    
    func getStringFrom(dictionary: [String: Int]) -> String {
        var string = ""
        
        for pair in dictionary {
            string = string + pair.key + ": " + String(pair.value) + "\n"
        }
        
        return string
    }
    
    // MARK: Pie chart
    //Update the pie chart. When the view loads or a different count tab is chosen.
    func pieChartUpdate() {
        let chartDescription = countSegments.selectedSegmentIndex == 0 ? "Repeating Reminders Have Higher Weighting.\nOnly Counting Reminders Within A Week From Now." : "Every Reminder Counted Once."
        var entries: [PieChartDataEntry] = []
        for pair in categoryCounts[countSegments.selectedSegmentIndex] {
            entries.append(PieChartDataEntry(value: Double(pair.value), label: pair.key))
        }
        let dataSet = PieChartDataSet(values: entries, label: "Categories")
        dataSet.colors = Globals.colors[Globals.colorScheme].chartScheme
        dataSet.valueColors = [UIColor.black]
        let data = PieChartData(dataSet: dataSet)
        
        pieChart.data = data
        pieChart.chartDescription?.text = chartDescription
        pieChart.holeColor = UIColor.clear
        pieChart.animate(yAxisDuration: 0.7)
        
        pieChart.chartDescription?.textColor = Globals.colors[Globals.colorScheme].label2
        pieChart.legend.textColor = Globals.colors[Globals.colorScheme].label2
        pieChart.centerAttributedText = NSAttributedString(string: "Reminder\nAnalysis", attributes: [NSAttributedString.Key.foregroundColor: Globals.colors[Globals.colorScheme].label1])
        
        pieChart.notifyDataSetChanged()
    }
    
    // MARK: Analysis and suggestions
    //Update the text and corresponding buttons, videos, tips, etc based on analysis of the count arrays
    func analysisUpdate() {
        var sum = 0
        for count in categoryCounts[countSegments.selectedSegmentIndex] {
            sum += count.value
        }
        let percents = categoryCounts[countSegments.selectedSegmentIndex].mapValues { $0 * 100 / sum }
        
        var analysisText = ""
        categoriesForCreation = []
        for category in categories {
            if percents.index(forKey: category) == nil {
                analysisText += "There are no events categorized as " + category + ". Try to mix some " + category.lowercased() + " time into your life for a better balance. "
                analysisText += cMessages[category]! + "\n\n"
                
                categoriesForCreation.append(category)
            }
        }
        for pair in percents {
            if pair.key == "Other" && pair.value > (100 / (categories.count + 1)) {
                analysisText += "There are a lot of events categorizes as Other. Try to fit your reminders to a given category when possible so we can analize more accurately.\n\n"
                
            } else if pair.key != "Other" && pair.value < (66 / (categories.count + 1)) { //100 * 2/3 == 66
                analysisText += "There are very few events categorized as " + pair.key + ". Try to mix a little more " + pair.key.lowercased() + " time into your life for a better balance. "
                analysisText += cMessages[pair.key]! + "\n\n"
                
                categoriesForCreation.append(pair.key)
            }
        }
        
        if analysisText == "" {
            analysisText = "You have a well-balanced life! Keep it up!"
            addRecommendationsButton.isHidden = true
        } else {
            //remove the last two extra new lines
            analysisText.removeLast(2)
            
            if analysisText == "There are a lot of events categorizes as Other. Since we don't collect your data, we would appreciate it if you contacted us so we can improve the app by improving our category selection. Please leave a review or email amlubinger@gmail.com." {
                addRecommendationsButton.isHidden = true //if there are too many "Other" reminders, we recommend telling us so we can adjust the categories, not adding more of other categories
            } else if countSegments.selectedSegmentIndex == 1 {
                addRecommendationsButton.isHidden = true //also hide when using the simple count where every single reminder ever is counted once. This is not how the recommendation auto-balance feature is supposed to decide on what to add
            } else {
                addRecommendationsButton.isHidden = false //only show when there is room to add suggested reminders in the smart count tab
            }
        }
        
        textBox.text = analysisText
    }
    
    //Button press confirms with user to add each recommendation before adding it
    @IBAction func addRecommendations(_ sender: Any) {
        var message = "Add Reminder(s)?:\n\n"
        var remindersToAdd: [ReminderObject] = []
        
        for category in categoriesForCreation {
            var list = recommendedData[category]
            var reminder: ReminderObject
            repeat {
                reminder = list?.randomElement() ?? recommendedData["NoneExist"]![0]
                if reminder != recommendedData["NoneExist"]![0] {
                    let index = (list?.firstIndex(of: reminder))! //try maybe putting it how it was before with threads/dispatchqueues and semaphores except put only the semaphore wait in a new synchronous thread
                    list?.remove(at: index)
                }
            } while Globals.reminders.contains(reminder)
            
            if reminder != recommendedData["NoneExist"]![0] {
                message += reminder.category + ": " + reminder.title + " (Note: " + reminder.note + ")\n"
                remindersToAdd.append(reminder)
            }
        }
        
        message += "\nEdit/Delete Reminders at any time."
        
        if remindersToAdd.isEmpty {
            //No available recommendations to add
            message = "Sorry, there are no more reminder suggestions.\nMore will be added occasionally.\nTry creating your own events."
            
            let alert = UIAlertController(title: "Out of Recommendations", message: message, preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
                
            }))
            
            self.present(alert, animated: true, completion: nil)
        } else {
            //There are recommendations to add
            let alert = UIAlertController(title: "Add Recommended Reminder(s)?", message: message, preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
                
            }))
            alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { (_) in
                for reminder in remindersToAdd {
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
                }
                
                self.categoryCounts = self.countCategories()
                self.pieChartUpdate()
                self.analysisUpdate()
            }))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: Internet enabled features
    //Pulls a message from my personal website that I put up. ie "Have a great day!" or an inspirational quote
    func internetPullUpdate() {
        let url = URL(string: "http://web.cse.ohio-state.edu/~lubinger.1/MotivatingReminders/DailyMessage.txt")
        do{
            let contents = try String(contentsOf: url!)
            textFromOnline.text = contents
        } catch{
            textFromOnline.text = "Have a great day!" //Default text to display if the user is not connected to the internet or the try failed
        }
    }
}

