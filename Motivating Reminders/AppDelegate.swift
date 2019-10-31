//
//  AppDelegate.swift
//  Motivating Reminders
//
//  Created by Andrew Lubinger on 12/19/18.
//  Copyright © 2018 Andrew Lubinger. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    let defaults = UserDefaults(suiteName: "group.com.AndrewLubinger.Motivating-Reminders")

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //IQKeyboardManager - Great addition from hackiftekhar on GitHub. Makes keyboard appear and disappear when it is supposed to. Also adds buttons to jump between text fields and a "Done" button.
        //Found on stack overflow initially at https://stackoverflow.com/questions/28813339/move-a-view-up-only-when-the-keyboard-covers-an-input-field/28813720
        //Link to IQKeyboardManager on GitHub: https://github.com/hackiftekhar/IQKeyboardManager
        //More copyright information can be found in any of the files in teh IQKeyboardManagerSwift folder.
        //Thank you hackiftekhar
        IQKeyboardManager.shared.enable = true
        
        return true
    }
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        //Want to load the data only the first time the app is launched, otherwise it is kept in Globals
        
        //Using NSEncoding since it is storing objects
        do {
            Globals.reminders = try [ReminderObject].readFromPersistence()
        }
        catch let error as NSError {
            if error.domain == NSCocoaErrorDomain && error.code == NSFileReadNoSuchFileError {
                NSLog("No persistence file found, not necessarily an error...")
            } else {
                NSLog("Error loading from persistence: \(error)")
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
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        //Want to save the data whenever the user might be done with it
        
        //Using NSEncoding since it is storing objects
        do {
            try Globals.reminders.writeToPersistence()
        }
        catch let error {
            NSLog("Error writing to persistence: \(error)")
        }
        
        //Using defaults since these are settings
        defaults!.set(Globals.colorScheme, forKey: "colorScheme")
        defaults!.set(Globals.defaultSorting, forKey: "defaultSorting")
        defaults!.set(Globals.tableFontSize, forKey: "tableFontSize")
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        UIApplication.shared.applicationIconBadgeNumber = 0
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

}

