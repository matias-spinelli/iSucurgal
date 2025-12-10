//
//  iSucurgalApp.swift
//  iSucurgal
//
//  Created by Matías Spinelli on 05/12/2025.
//

//
//  iSucurgalApp.swift
//  iSucurgal
//
//  Created by Matías Spinelli on 05/12/2025.
//

import SwiftUI
import CoreData
import LocationRegisterKit

@main
struct iSucurgalApp: App {

    let dataController = DataController.shared
    let module = LocationRegisterKitModule.shared

    var body: some Scene {
        WindowGroup {
            HomeView()
                .environment(\.managedObjectContext, dataController.container.viewContext)

                .environmentObject(module.sucursalesViewModel)
                .environmentObject(module.registroViewModel)
                .environmentObject(module.geofencingManager)
                .environmentObject(module.locationManager)
                .environmentObject(module.registroManager)

                .onAppear {
                    LocationRegisterKitModule.shared.startModule()
                }
        }
    }
}
