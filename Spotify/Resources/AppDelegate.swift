//
//  AppDelegate.swift
//  Spotify
//
//  Created by Rami Elwan on 23.07.24.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    private var observer: NSObjectProtocol?
    
    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        
        let setViewController = {
            DispatchQueue.main.async {
                if AuthManager.shared.isSignedIn {
                    window.rootViewController = TabBarViewController()
                } else {
                    let navVC = UINavigationController(rootViewController: WelcomeViewController())
                    navVC.navigationBar.prefersLargeTitles = true
                    navVC.viewControllers.first?.navigationItem.largeTitleDisplayMode = .always
                    window.rootViewController = navVC
                }
                UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve,animations: {})
            }
        }
        
        observer = NotificationCenter.default.addObserver(
            forName: .userLoggedOut,
            object: nil,
            queue: .main,
            using: {_  in
                setViewController()
            }
        )
        
        if !AuthManager.shared.isSignedIn {
            AuthManager.shared.refreshAccessToken(completion: { _ in
                DispatchQueue.main.async {
                    setViewController()
                }
            })
        } else {
            setViewController()
        }
        
        window.makeKeyAndVisible()
        self.window = window
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options _: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_: UIApplication, didDiscardSceneSessions _: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}
