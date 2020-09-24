//
//  AppDelegate.swift
//  MC
//
//  Created by Developer on 06/03/2020.
//  Copyright © 2020 Developer. All rights reserved.
//

import UIKit
import UserNotifications
import Firebase
import FirebaseInstanceID
import FirebaseMessaging

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        registerForPushNotifications()
        
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        
        return true
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

@available(iOS 13.0, *)
func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    private func registerForPushNotifications() {
        UNUserNotificationCenter.current().delegate = self
        startNotification()
    }
    
    private func startNotification() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
            [weak self] granted, error in
            guard let self = self else { return }
            print("Permission granted: \(granted)")
            guard granted else { return }
            
            self.getNotificationSettings()
        }
    }
    
    private func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            print("Notification settings: \(settings)")
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        Config.Token.notification = tokenParts.joined()
        print(Config.Token.notification)
        FirebaseToken()
    }
    
    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("didFailToRegisterForRemoteNotificationsWithError: ", error)
        FirebaseToken()
    }
    
    private func FirebaseToken() {
        InstanceID.instanceID().instanceID { (result, error) in
            if let error = error {
                print("Error fetching remote instance ID: \(error)")
                return
            }
            if let result = result {
                print("Remote instance ID token: \(result.token)")
                Config.Token.notification = "Remote InstanceID token: \(result.token)"
            }
        }
    }
    
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler:
        @escaping (UIBackgroundFetchResult) -> Void) {
        
        guard let aps = userInfo["aps"] as? JsonDict else { return }
        let msg = aps["alert"] ?? "---"
         
        let win = (UIApplication.shared.windows.filter {$0.isKeyWindow}.first)
        var rootViewController = win?.rootViewController
        if let navigationController = rootViewController as? UINavigationController {
            rootViewController = navigationController.viewControllers.first
        }
        if let tabBarController = rootViewController as? UITabBarController {
            rootViewController = tabBarController.selectedViewController
        }
        let alert = UIAlertController(title: "Notifica" as String,
                                      message: msg as? String,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//        let ctrl = (UIApplication.shared.windows.filter {$0.isKeyWindow}.first)
        rootViewController!.present(alert, animated: true, completion: nil)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
        print("didReceive: ", response)
    }
}

extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        Config.Token.notification = fcmToken
        let dataDict = [
            "token": fcmToken
        ]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
    }
}

//https://shopper.mebius.it/learnings/171/video-mp4?token=MDViZjU4YjE1M2ViMzdlMzk2NWYyYjYwZTBjMWZh
