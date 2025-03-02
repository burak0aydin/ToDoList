//
//  toDoListApp.swift
//  toDoList
//
//  Created by Burak Aydın on 17.02.2025.
//

import SwiftUI

@main
struct toDoListApp: App {
    @StateObject private var viewModel = TaskViewModel()
    @StateObject private var languageManager = LanguageManager()
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
                    .environmentObject(viewModel)
                    .environmentObject(languageManager)
            }
        }
    }
}
