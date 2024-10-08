//
//  SceneDelegate.swift
//  Spotify
//
//  Created by Rami Elwan on 23.07.24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    var observer: NSObjectProtocol?
    
    func scene(_ scene: UIScene, willConnectTo _: UISceneSession, options _: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        
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
    }
    
    func sceneDidDisconnect(_: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
}
