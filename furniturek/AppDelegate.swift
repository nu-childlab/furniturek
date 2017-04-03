//
//  AppDelegate.swift
//  furniturek
//
//  Created by Casey Colby on 10/20/16.
//  Copyright © 2016 ccolby. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let brightGreen: UIColor = UIColor(red: 184/255, green:254/255, blue: 124/255, alpha:1)
        let brightPurple: UIColor = UIColor(red: 128/255, green: 0/255, blue: 255/255, alpha: 1)
        //let darkColor = UIColor(red: 25/255, green: 25/255, blue: 25/255, alpha: 1) //#191919
        let lightColor = UIColor(red: 223/255, green: 226/255, blue: 219/255, alpha: 1) //#dfe2db
        
        // Bugfix: Tint not fully Applied to Alert Controller without Reapplying (e.g. on device rotation)
        window?.tintColor = brightPurple //affects alert controller buttons
        window?.backgroundColor = lightColor
        UITextField.appearance().tintColor = brightGreen //affects cursor color
        UIToolbar.appearance().tintColor = brightPurple
        UINavigationBar.appearance().tintColor = brightPurple
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

