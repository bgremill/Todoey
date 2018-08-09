//
//  AppDelegate.swift
//  Todoey
//
//  Created by Brandi D Gremillion on 6/25/18.
//  Copyright © 2018 Gremillion Consulting. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    //Gets called when your app gets loaded up, before the ViewDidLoad
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        //print(Realm.Configuration.defaultConfiguration.fileURL)

        do {
            _ = try Realm() //only need the _ because we aren't actually using the realm, just testing to see if we can initialize it
        } catch {
            print("Error initializing new realm, \(error)")
        }
        
        return true
    }
    
}

