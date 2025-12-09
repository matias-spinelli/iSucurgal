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
    @StateObject private var sucursalesViewModel = SucursalesViewModel()
    @StateObject private var registroViewModel = RegistroViewModel()
    @StateObject private var registroManager: RegistroManager
    @StateObject private var geofencingManager = GeofencingManager()

    init() {

        let sucursalesViewModel = SucursalesViewModel()
        let registroViewModel = RegistroViewModel()
        let registroManager = RegistroManager(registroViewModel: registroViewModel, sucursalesViewModel: sucursalesViewModel)

        _sucursalesViewModel = StateObject(wrappedValue: sucursalesViewModel)
        _registroViewModel = StateObject(wrappedValue: registroViewModel)
        _registroManager = StateObject(wrappedValue: registroManager)
    }

    var body: some Scene {
        WindowGroup {
            HomeView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
                .environmentObject(locationManager)
                .environmentObject(sucursalesViewModel)
                .environmentObject(registroViewModel)
                .environmentObject(registroManager)
            
                .onAppear {

                    sucursalesViewModel.cargarSucursales()
                    registroManager.rebuildCache()

                    locationManager.registroManager = registroManager
                    locationManager.requestAuthorization()
                    locationManager.start()

                    geofencingManager.registroManager = registroManager
                }
            
                .onChange(of: sucursalesViewModel.sucursales) { _, nuevasSucursales in
                    guard !nuevasSucursales.isEmpty else { return }
                    print("📍 Sucursales listas → configurando geofences")
                    geofencingManager.setupGeofences(for: nuevasSucursales)
                }

                .onReceive(NotificationCenter.default.publisher(for: UIApplication.didEnterBackgroundNotification)) { _ in
                    locationManager.enterBackground()
                }

                .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
                    locationManager.enterForeground()
                }
        }
    }
}
