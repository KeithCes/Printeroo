//
//  PrinterooApp.swift
//  Printeroo
//
//  Created by Admin on 9/8/22.
//

import SwiftUI
import FirebaseCore
import Stripe

class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        FirebaseApp.configure()
        
        StripeAPI.defaultPublishableKey = "pk_test_51LhHROJmbc8gUulkXbYkJxGKTL21tHZP6oeHi4FCJOvjj2He2kOdagrDC5BYDxRlk12nbmgpQc6xSCoONNzmHiN700tmbMHZ3n"
        
        return true
    }
}


@main

struct YourApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
