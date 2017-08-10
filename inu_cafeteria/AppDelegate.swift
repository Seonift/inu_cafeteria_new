//
//  AppDelegate.swift
//  inu_cafeteria
//
//  Created by SeonIl Kim on 2017. 7. 17..
//  Copyright © 2017년 appcenter. All rights reserved.
//

import UIKit
import UserNotifications
import Firebase
import FirebaseInstanceID
import FirebaseMessaging
import KYDrawerController

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, FIRMessagingDelegate {

//    https://www.youtube.com/watch?v=pVtIVfJJ35w
//    https://www.appcoda.com/firebase-push-notifications/
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
//        FIRApp.configure()
//        
//        let settings: UIUserNotificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
//        application.registerUserNotificationSettings(settings)
//        application.registerForRemoteNotifications()
        
        
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            // For iOS 10 data message (sent via FCM
            FIRMessaging.messaging().remoteMessageDelegate = self
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
        FIRApp.configure()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.tokenRefreshNotification(notification:)), name: .firInstanceIDTokenRefresh, object: nil)
        
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let firstVC = storyboard.instantiateViewController(withIdentifier: "firststartvc")
        let sb = UIStoryboard(name: "Splash", bundle: nil)
        let firstVC = sb.instantiateViewController(withIdentifier: "splashvc")
        self.window?.rootViewController = firstVC
        self.window?.makeKeyAndVisible()
        
        Network().getCookie()
        
//        SocketIOManager.sharedInstance.establishConnection()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        FIRMessaging.messaging().disconnect()
        print("Disconnected from FCM.")
        
        removeFlag()
//        print("socket end")
        
        SocketIOManager.sharedInstance.closeConnection()
        
        Network().saveCookie()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        connectToFcm()
        
        Network().getCookie()
        
        SocketIOManager.sharedInstance.establishConnection()
        
        DispatchQueue.main.async {
            if let vc = self.window?.visibleViewController as? KYDrawerController {
                //            if vc.mainViewController.childViewControllers[0].isKind(of: MyNumberVC.self) {
                //                && userPreferences.object(forKey: "socket") != nil {
                //                print("socket restart")
                //                SocketIOManager.sharedInstance.establishConnection()
                //                let vc =
                //여기서 갯수 확인해서 없으면 dismiss 해야함.
                //            }
                
                if let numvc = vc.mainViewController.childViewControllers[0] as? MyNumberVC {
                    numvc.wakeUp()
                }
                
                if let drawerController = vc.mainViewController.parent as? KYDrawerController {
                    //                drawerController.setDrawerState(.opened, animated: true)
                    if drawerController.drawerState == .opened {
                        let model = FlagModel()
                        model.activeBarcode(1)
                        
                    }
                }
            }
        }
        
//        SocketIOManager.sharedInstance.reconnectConnection()
        
//        print("Becomeactive")
        
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
        removeFlag()
        Network().saveCookie()
//        print("socket end")
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        FIRMessaging.messaging().appDidReceiveMessage(userInfo)
        
        
        //푸시 메시지 클릭했을 때 이벤트
        UIApplication.shared.applicationIconBadgeNumber = 0
        userPreferences.set(false, forKey: "socket")
        userPreferences.removeObject(forKey: "code")
        userPreferences.removeObject(forKey: "num1")
        userPreferences.removeObject(forKey: "num2")
        userPreferences.removeObject(forKey: "num3")
        
//        let dict = userInfo["aps"] as! NSDictionary
//        let message = dict["alert"]
//        print(message)
        
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        FIRInstanceID.instanceID().setAPNSToken(deviceToken, type: FIRInstanceIDAPNSTokenType.prod)
    }
    
    func applicationReceivedRemoteMessage(_ remoteMessage: FIRMessagingRemoteMessage) {
        print(remoteMessage.appData)
    }
    
    func tokenRefreshNotification(notification: NSNotification) {
        // NOTE: It can be nil here
        if let refreshedToken = FIRInstanceID.instanceID().token() {
            print("InstanceID token: \(refreshedToken)")
        }
        connectToFcm()
    }
    
    func connectToFcm() {
        // Won't connect since there is no token
        guard FIRInstanceID.instanceID().token() != nil else {
            return
        }
        
        // Disconnect previous FCM connection if it exists.
        FIRMessaging.messaging().disconnect()
        
        FIRMessaging.messaging().connect { (error) in
            if error != nil {
                print("Unable to connect with FCM. \(error)")
            } else {
                print("Connected to FCM.")
            }
        }
    }
    
    func removeFlag(){
        let model = FlagModel()
        model.activeBarcode(0)
    }
    
//    func connectToFcm() {
//        FIRMessaging.messaging().connect { (error) in
//            if (error != nil) {
//                print("Unable to connect with FCM. \(error)")
//            } else {
//                print("Connected to FCM.")
//            }
//        }
//    }

}

public extension UIWindow {
    public var visibleViewController: UIViewController? {
        return UIWindow.getVisibleViewControllerFrom(self.rootViewController)
    }
    
    public static func getVisibleViewControllerFrom(_ vc: UIViewController?) -> UIViewController? {
        if let nc = vc as? UINavigationController {
            return UIWindow.getVisibleViewControllerFrom(nc.visibleViewController)
        } else if let tc = vc as? UITabBarController {
            return UIWindow.getVisibleViewControllerFrom(tc.selectedViewController)
        } else {
            if let pvc = vc?.presentedViewController {
                return UIWindow.getVisibleViewControllerFrom(pvc)
            } else {
                return vc
            }
        }
    }
}

