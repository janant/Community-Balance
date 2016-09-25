//
//  AppDelegate.swift
//  Community Balance
//
//  Created by Anant Jain on 12/28/14.
//  Copyright (c) 2014 Anant Jain. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {

    var window: UIWindow?
    
    var watchSplitView: UISplitViewController?
    var favoritesSplitView: UISplitViewController?
    var moreSplitView: UISplitViewController?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let tabBarController = window!.rootViewController as! UITabBarController
        
        let websiteTabItem = (tabBarController.viewControllers![0] as! UINavigationController).tabBarItem
        let watchTabItem = (tabBarController.viewControllers![1] as! UISplitViewController).tabBarItem
        
        websiteTabItem?.selectedImage = #imageLiteral(resourceName: "Website Tab Selected")
        watchTabItem?.selectedImage = #imageLiteral(resourceName: "Watch Tab Selected")
        
        watchSplitView = tabBarController.viewControllers![1] as? UISplitViewController
        favoritesSplitView = tabBarController.viewControllers![2] as? UISplitViewController
        moreSplitView = tabBarController.viewControllers![3] as? UISplitViewController
        
        watchSplitView?.delegate = self
        favoritesSplitView?.delegate = self
        moreSplitView?.delegate = self
        
        self.window?.tintColor = #colorLiteral(red: 1, green: 0.5, blue: 0, alpha: 1)
        
        return true
    }
    
    @available(iOS 9.0, *)
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        guard let tabBarController = self.window?.rootViewController as? UITabBarController else {
            completionHandler(false)
            return
        }
        if shortcutItem.type == "edu.self.Community-Balance.watch-episodes" {
            tabBarController.selectedIndex = 1
            completionHandler(true)
        }
        else if shortcutItem.type == "edu.self.Community-Balance.favorites" {
            tabBarController.selectedIndex = 2
            completionHandler(true)
        }
        else {
            completionHandler(false)
        }
    }
//    
//    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: (Bool) -> Void) {
//        
//    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        if splitViewController == watchSplitView || splitViewController == favoritesSplitView {
            if let secondaryNavVC = secondaryViewController as? UINavigationController {
                if let secondaryNavTopVC = secondaryNavVC.topViewController as? WatchDetailViewController {
                    if secondaryNavTopVC.episodeInfo == nil {
                        return true
                    }
                }
            }
        }
        else if splitViewController == moreSplitView {
            if let secondaryNavVC = secondaryViewController as? UINavigationController {
                if let secondaryNavTopVC = secondaryNavVC.topViewController as? MoreDetailViewController {
                    if secondaryNavTopVC.infoType == .aboutNone {
                        return true
                    }
                }
            }
        }
        return false
    }

}

