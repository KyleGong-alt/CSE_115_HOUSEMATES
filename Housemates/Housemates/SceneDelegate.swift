//
//  SceneDelegate.swift
//  Housemates
//
//  Created by Jackson Tran on 4/18/22.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
        
        let email = UserDefaults.standard.string(forKey: "email")
        
        var components = URLComponents(string: "http://127.0.0.1:8080/get_user")!
        components.queryItems = [
            URLQueryItem(name: "email", value: email)
        ]
        components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        
        var request = URLRequest(url: components.url!)

        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        request.httpMethod = "GET"
        let semaphore = DispatchSemaphore.init(value: 0)
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            var result:user
            do {
                result = try JSONDecoder().decode(user.self, from: data!)
                print(result)
                DispatchQueue.main.async {
                    let main = UIStoryboard(name: "Main", bundle: nil)
                    let tabBarNavigation = main.instantiateViewController(withIdentifier: "TabBarController") as! TabBarController
                    tabBarNavigation.currentUser = result
                    self.window?.rootViewController = tabBarNavigation
                }
                semaphore.signal()
            } catch {
                print(error.localizedDescription)
                semaphore.signal()
            }
        }
        dataTask.resume()
        semaphore.wait()
        
        
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

