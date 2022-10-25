//
//  HUGPETGITHUBApp.swift
//  HUGPETGITHUB
//
//  Created by Ahad Obaid Albaqami on 29/03/1444 AH.
//

import SwiftUI
import Firebase

@main
struct HUGPETGITHUBApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
         TabBarViews()
        }
    }
}
