//
//  AppDelegate.swift
//  Pattonville School District App
//
//  Created by Developer on 9/27/16.
//  Copyright © 2017 Pattonville School District. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    /// Method called as the app is launching, checks to see if the application is launched before, if so sets the isSubscribedTo values in SchoolsArray.allSchools 
    ///
    /// - Parameters:
    ///   - application: The PSD App
    ///   - launchOptions: the launching options used
    /// - Returns: true
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        
       
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        if launchedBefore{
            
            for school in SchoolsArray.allSchools{
                school.isSubscribedTo = UserDefaults.standard.bool(forKey: school.name)
            }
            
            SchoolsEnum.district.isSubscribedTo = true
    
            
        
        } else {
            print("First launch, setting UserDefault.")
            
            
            
        }
        
        return true
        
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        print("App delegate did finish launcing entry")
        // Override point for customization after application launch.
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        //let mainStoryboard: UIStoryboard = UIStoryboard(name: "UINavigationController", bundle: Bundle.main)
        let initialViewController = UITabBarController()
        
        
        self.window?.rootViewController = initialViewController
        
        let calendar = Calendar.instance
        
        let news = NewsReel.instance
        let commitString = "committing to switch computers"
        let pushstring = "pushing"
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        print(launchedBefore)
        if launchedBefore{
            /*let mainStoryboard: UIStoryboard = UIStoryboard(name: "Home", bundle: nil)
            initialViewController: UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "PSDViewController") as! PSDViewController*/
            print("did finish launching, if launched before method, if clause")
            let navBarController = window!.rootViewController as! UITabBarController
            print("navBarController")
            let navHomeController = navBarController.viewControllers?[0] as! UINavigationController
            let homeController = navHomeController.topViewController as! PSDViewController
            
            
            let navNewsController = navBarController.viewControllers?[1] as! UINavigationController
            let newsController = navNewsController.topViewController as! NewsViewController
            
            let navCalController = navBarController.viewControllers?[2] as! UINavigationController
            let calendarController = navCalController.topViewController as! CalendarViewController
            
            homeController.news = news
            homeController.calendar = calendar
            newsController.news = news
            calendarController.calendar = calendar
            calendarController.selectedDate = Date()
            
            calendar.getEvents(completionHandler: {
                homeController.calendar = calendar
                calendarController.calendar = calendar
            })
            
            news.getNews(beforeStartHandler: nil, onCompletionHandler: {
                homeController.news = news
                newsController.news = news
            })
            UITabBar.appearance().tintColor = UIColor(red: 0/255.0, green: 122/255.0, blue: 51/255.0, alpha: 1.0)
        }
        else{
            print("did finish launching, if launched before method, else clause at beginning of code")
            let nav = self.window?.rootViewController as! UITabBarController
            print(nav)
            let storyBoard = UIStoryboard(name: "More", bundle: nil)
            nav.present(storyBoard.instantiateViewController(withIdentifier: "MoreViewController") as! MoreViewController, animated: false)
           /* let mainStoryboard: UIStoryboard = UIStoryboard(name: "More", bundle: nil)
            initialViewController = mainStoryboard.instantiateViewController(withIdentifier: "MoreViewController") as! MoreViewController*/
            /*let navBarController = window!.rootViewController as! UINavigationController
            
            let navHomeController = navBarController.viewControllers[0] as! UINavigationController
            let homeController = navHomeController.topViewController as! PSDViewController
            
            let navNewsController = navBarController.viewControllers[1] as! UINavigationController
            let newsController = navNewsController.topViewController as! NewsViewController
            
            let navCalController = navBarController.viewControllers[2] as! UINavigationController
            let calendarController = navCalController.topViewController as! CalendarViewController
            
            homeController.news = news
            homeController.calendar = calendar
            newsController.news = news
            calendarController.calendar = calendar
            calendarController.selectedDate = Date()
            
            calendar.getEvents(completionHandler: {
                homeController.calendar = calendar
                calendarController.calendar = calendar
            })
            
            news.getNews(beforeStartHandler: nil, onCompletionHandler: {
                homeController.news = news
                newsController.news = news
            })*/

            print("did finish launching, if launched before method, else clause at end of code")
            self.window?.makeKeyAndVisible()
        }
        
        /*let calendar = Calendar.instance
        
        let news = NewsReel.instance*/
        
        /*let navBarController = window!.rootViewController as! UINavigationController
        
        let navHomeController = navBarController.viewControllers[0] as! UINavigationController
        let homeController = navHomeController.topViewController as! PSDViewController
        
        let navNewsController = navBarController.viewControllers[1] as! UINavigationController
        let newsController = navNewsController.topViewController as! NewsViewController
        
        let navCalController = navBarController.viewControllers[2] as! UINavigationController
        let calendarController = navCalController.topViewController as! CalendarViewController
        
        homeController.news = news
        homeController.calendar = calendar
        newsController.news = news
        calendarController.calendar = calendar
        calendarController.selectedDate = Date()
        
        calendar.getEvents(completionHandler: {
            homeController.calendar = calendar
            calendarController.calendar = calendar
        })
        
        news.getNews(beforeStartHandler: nil, onCompletionHandler: {
            homeController.news = news
            newsController.news = news
        })
        */
        /*UITabBar.appearance().tintColor = UIColor(red: 0/255.0, green: 122/255.0, blue: 51/255.0, alpha: 1.0)*/
      
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    /// Method called when application enters the background, sets the launched before bool value to equal true, in order to activate the persistence
    ///
    /// - Parameter application: the application being quit
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
       
        UserDefaults.standard.set(true, forKey: "launchedBefore")
        
        
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

