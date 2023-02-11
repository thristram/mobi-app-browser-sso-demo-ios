//
//  AppDelegate.swift
//  com.ackapp.mobitest
//
//  Created by Li, Fang on 4/13/22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
               // Get URL components from the incoming user activity.
               guard userActivity.activityType == NSUserActivityTypeBrowsingWeb,
                   let incomingURL = userActivity.webpageURL,
                   let components = NSURLComponents(url: incomingURL, resolvingAgainstBaseURL: true) else {
                   return false
               }

               // Check for specific URL components that you need.
               guard let path = components.path,
               let params = components.queryItems else {
                   return false
               }
               print("path = \(path)")
            switch path {
            case "/ivvlanding":
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "dismissIVV"), object: nil, userInfo: [:])
                return true

            default:
                var userInfo:[String: String] = ["redirectURI": "none", "browser": "known"]
                if let url = params.first(where: { $0.name == "redirectURI" } )?.value, let browser = params.first(where: { $0.name == "browser" })?.value {
                    print("url = \(url)")
                    print("browser = \(browser)")
                    userInfo["redirectURI"] = url
                    userInfo["browser"] = browser
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "getDeekLinkURI"), object: nil, userInfo: userInfo)
                    return true
                }
                
            }

            return true

           }
}
