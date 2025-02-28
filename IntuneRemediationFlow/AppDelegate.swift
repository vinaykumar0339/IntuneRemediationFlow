//
//  AppDelegate.swift
//  IntuneRemediationFlow
//
//  Created by vinay kumar on 13/02/25.
//

import UIKit
import MSAL
import IntuneMAMSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    private var complainceDelegate: MAMComplianceDelegate?
    private var policyDelegate: MAMPolicyDelegate?
    private var enrollmentDelegate: MAMEnrollmentDelegate?

    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        self.setIntuneDelegate()
        return true
    }

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
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return MSALPublicClientApplication.handleMSALResponse(url, sourceApplication: options[.sourceApplication] as? String)
    }
    
    func setIntuneDelegate() {
//        Old Flow
//        complainceDelegate = MAMComplianceDelegate()
//        IntuneMAMComplianceManager.instance().delegate = complainceDelegate
        
//        New Flow
        complainceDelegate = MAMComplianceDelegate.shared
        IntuneMAMComplianceManager.instance().delegate = complainceDelegate
        
        policyDelegate = MAMPolicyDelegate()
        IntuneMAMPolicyManager.instance().delegate = policyDelegate
        
        enrollmentDelegate = MAMEnrollmentDelegate()
        IntuneMAMEnrollmentManager.instance().delegate = enrollmentDelegate
    }

}

