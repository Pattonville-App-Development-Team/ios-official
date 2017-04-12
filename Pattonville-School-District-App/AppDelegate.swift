//
//  AppDelegate.swift
//  Pattonville School District App
//
//  Created by Developer on 9/27/16.
//  Copyright © 2017 Pattonville School District. All rights reserved.
//

import UIKit
import UserNotifications
import Firebase
import FirebaseInstanceID
import FirebaseMessaging

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, FIRMessagingDelegate {
    
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
            let value = 3
            UserDefaults.standard.set(value, forKey:"recentNews")
            UserDefaults.standard.set(value, forKey: "upcomingNews")
            UserDefaults.standard.set(value, forKey: "pinnedEvents")
            
        }
        
        return true
        
        
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        print("App delegate did finish launcing entry")
        // Override point for customization after application launch.
        //SchoolsArray.readFromFile()
        
        let calendar = Calendar.instance
        let news = NewsReel.instance
        
        let navBarController = window!.rootViewController as! UITabBarController
        print("navBarController")
        let navHomeController = navBarController.viewControllers?[0] as! UINavigationController
        let homeController = navHomeController.topViewController as! PSDViewController
        
        let navNewsController = navBarController.viewControllers?[1] as! UINavigationController
        let newsController = navNewsController.topViewController as! NewsViewController
        
        let navCalController = navBarController.viewControllers?[2] as! UINavigationController
        let calendarController = navCalController.topViewController as! CalendarViewController

        let launchedBeforeForSelectSchools = UserDefaults.standard.bool(forKey: "launchedBeforeForSelectSchools")
        //print(launchedBeforeForSelectSchools)
        
        if !launchedBeforeForSelectSchools{
            //print("did finish launching, if launched before method, else clause at beginning of code")
            self.window = UIWindow(frame: UIScreen.main.bounds)
            
            let initialViewController = UINavigationController()
            
            self.window?.rootViewController = initialViewController

            let nav = self.window?.rootViewController as! UINavigationController
            //print(nav)
            let storyBoard = UIStoryboard(name: "SelectSchoolsTableViewController", bundle: nil)
            nav.pushViewController(storyBoard.instantiateViewController(withIdentifier: "SelectSchoolsController") as! SelectSchoolsTableViewController, animated: false)
           
            //print("did finish launching, if launched before method, else clause at end of code")
            self.window?.makeKeyAndVisible()
            UserDefaults.standard.set(true, forKey: "launchedBeforeForSelectSchools")
            
        }
        
        homeController.news = news
        homeController.calendar = calendar
        newsController.news = news
        calendarController.calendar = calendar
        calendarController.selectedDate = Date()
        
        news.getNews(beforeStartHandler: nil, onCompletionHandler: {
            homeController.news = news
            newsController.news = news
        })
        
        calendar.getEvents(completionHandler: {
            homeController.news = news
            newsController.news = news
        })
        
        UITabBar.appearance().tintColor = UIColor(red: 0/255.0, green: 122/255.0, blue: 51/255.0, alpha: 1.0)
        
        if #available(iOS 10.0, *) {
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            // For iOS 10 data message (sent via FCM)
            FIRMessaging.messaging().remoteMessageDelegate = self
            
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
        FIRApp.configure()
            
        let subscribed = SchoolsArray.getSubscribedSchools()
        
        if(subscribed.contains(SchoolsEnum.bridgewayElementary) || subscribed.contains(SchoolsEnum.drummondElementary) || subscribed.contains(SchoolsEnum.parkwoodElementary) || subscribed.contains(SchoolsEnum.remingtonTraditional) || subscribed.contains(SchoolsEnum.roseAcresElementary) || subscribed.contains(SchoolsEnum.willowBrookElementary)){
            
            FIRMessaging.messaging().subscribe(toTopic: "/topics/All-Elementary-Schools")
            
        }else if(subscribed.contains(SchoolsEnum.heightsMiddleSchool) || subscribed.contains(SchoolsEnum.holmanMiddleSchool) || subscribed.contains(SchoolsEnum.remingtonTraditional)){
            
            FIRMessaging.messaging().subscribe(toTopic: "/topics/All-Middle-Schools")
            
        }
        
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
        
        SchoolsArray.saveToFile()
        FIRMessaging.messaging().disconnect()
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
    
    func applicationReceivedRemoteMessage(_ remoteMessage: FIRMessagingRemoteMessage){
        
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        
        if let messageID = userInfo["gcm.message_id"] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        
    }
    
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        for school in SchoolsArray.getSubscribedSchools(){
            FIRMessaging.messaging().subscribe(toTopic: "/teams/\(school.name.replacingOccurrences(of: " ", with: "-"))")
        }
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        if let messageID = userInfo["gcm.message_id"] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        
        completionHandler(UIBackgroundFetchResult.newData)
        
        if application.applicationState == UIApplicationState.active{
            
            application.applicationIconBadgeNumber = 0
            
            let notification = ((userInfo["aps"] as! [String:AnyObject])["alert"] as! [String:AnyObject])
            
            let alert = UIAlertController(title: notification["title"] as! String, message: notification["body"] as! String, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
            self.window?.rootViewController?.present(alert, animated: true, completion: nil)

        }
        
    }
    
    
    func tokenRefreshNotification(_ notification: Notification) {
        if let refreshedToken = FIRInstanceID.instanceID().token() {
            print("InstanceID token: \(refreshedToken)")
        }
        
        // Connect to FCM since connection may have failed when attempted before having a token.
        connectToFcm()
    }
    
    func connectToFcm() {
        // Won't connect since there is no token
        guard FIRInstanceID.instanceID().token() != nil else {
            return;
        }
        
        // Disconnect previous FCM connection if it exists.
        FIRMessaging.messaging().disconnect()
        
        FIRMessaging.messaging().connect { (error) in
            if error != nil {
                print("Unable to connect with FCM. \(String(describing: error))")
            } else {
                print("Connected to FCM.")
            }
        }
    }
    
    /// Called to in the will finish launching method, to create the SelectSchoolsView on the first user launch
    func showSelectSchoolsViewControllerOnInitialLaunch(){
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let initialViewController = UINavigationController()
        self.window?.rootViewController = initialViewController
        let nav = self.window?.rootViewController as! UINavigationController
        //print(nav)
        let storyBoard = UIStoryboard(name: "SelectSchoolsTableViewController", bundle: nil)
        nav.pushViewController(storyBoard.instantiateViewController(withIdentifier: "SelectSchoolsController") as! SelectSchoolsTableViewController, animated: false)
        //print("did finish launching, if launched before method, else clause at end of code")
        self.window?.makeKeyAndVisible()
    }
    /// Called to show PSDViewController on every launch that is not the first time
    func showPSDViewControllerOnRegularLaunch(){
        let calendar = Calendar.instance
        
        let news = NewsReel.instance
    
            print("did finish launching, if launched before method, if clause")
            let navBarController = window!.rootViewController as! UITabBarController
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
    
}
