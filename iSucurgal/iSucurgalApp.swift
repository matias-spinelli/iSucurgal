//
//  iSucurgalApp.swift
//  iSucurgal
//
//  Created by Matías Spinelli on 05/12/2025.
//

import SwiftUI
import CoreData

@main
struct iSucurgalApp: App {
    let dataController = DataController.shared

    var body: some Scene {
        WindowGroup {
            HomeView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
