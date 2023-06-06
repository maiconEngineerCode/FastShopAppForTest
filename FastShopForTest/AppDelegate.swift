//
//  AppDelegate.swift
//  FastShopForTest
//
//  Created by ACT on 02/06/23.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
//        let router = MarvelRouter()
//        
//        let navigation = UINavigationController()
//        navigation.setViewControllers([router.instanceMarvelScrenn()], animated: false)
//        
//        window = UIWindow()
//        window?.rootViewController = navigation
//        window?.makeKeyAndVisible()
        
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

    public lazy var persistentContainer: PersistentContainer = {
        let persistent = PersistentContainer(name: "MarvelHQ")
        persistent.loadPersistentStores { store, error in
            if let error = error {
                fatalError(error.localizedDescription)
            }
        }
        return persistent
    }()
    
}

class PersistentContainer: NSPersistentContainer {
    
    public func saveContext(backgroundContext: NSManagedObjectContext? = nil){
        
        let context = backgroundContext ?? viewContext
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch let error as NSError {
            print("\(error) - \(error.userInfo)")
        }
    }
}



