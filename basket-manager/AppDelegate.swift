//
//  AppDelegate.swift
//  basket-manager
//
//  Created by Nobuhiro Harada on 2018/09/10.
//  Copyright © 2018年 Nobuhiro Harada. All rights reserved.
//

import UIKit

let userdefaults = UserDefaults.standard
let TEAM_A: String  = "team_a"
let TEAM_B: String  = "team_b"
let SCORE_A: String = "score_a"
let SCORE_B: String = "score_b"
let BUZEER_AUTO_BEEP: String = "buzzer_auto_beep"
let IS_SHOTCLOCK_24: String = "is_shotclock_14"
let IS_SYNC_SHOTCLOCK_GAMETIME: String = "is_sync_shotclock_gametime"

var isLandscape: Bool {
    if #available(iOS 13.0, *) {
        return UIApplication.shared.windows
            .first?
            .windowScene?
            .interfaceOrientation
            .isLandscape ?? false
    } else {
        return UIDevice.current.orientation.isLandscape
    }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private(set) lazy var viewController = MainViewController()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        if (userdefaults.object(forKey: BUZEER_AUTO_BEEP) == nil) {
            userdefaults.set(false, forKey: BUZEER_AUTO_BEEP)
        }
        
        if (userdefaults.object(forKey: IS_SYNC_SHOTCLOCK_GAMETIME) == nil) {
            userdefaults.set(false, forKey: IS_SYNC_SHOTCLOCK_GAMETIME)
        }
        
        userdefaults.set(true, forKey: IS_SHOTCLOCK_24)
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
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

