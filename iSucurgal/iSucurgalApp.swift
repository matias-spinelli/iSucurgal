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

    @StateObject private var locationManager = LocationManager()
    @StateObject private var sucursalesVM = SucursalesViewModel()

    var body: some Scene {
        WindowGroup {
            HomeView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
                .environmentObject(locationManager)
                .environmentObject(sucursalesVM)
                .onAppear {
                    locationManager.requestAuthorization()
                    locationManager.startUpdatingLocation()
                    sucursalesVM.cargarSucursales()
                }
        }
    }
}
