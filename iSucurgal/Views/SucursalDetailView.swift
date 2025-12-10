//
//  SucursalDetailView.swift
//  iSucurgal
//
//  Created by Matías Spinelli on 06/12/2025.
//

import SwiftUI
import MapKit
import CoreData
import LocationRegisterKit

struct SucursalDetailView: View {

    let sucursal: Sucursal
    @EnvironmentObject var locationManager: LocationManager

    var body: some View {
        VStack {
            if let userLocation = locationManager.userLocation {
                let userCoordinate = userLocation.coordinate
                let sucusalCoordinate = CLLocationCoordinate2D(
                    latitude: sucursal.latitude,
                    longitude: sucursal.longitude
                )

                Map {
                    Marker(sucursal.name, coordinate: sucusalCoordinate)

                    Marker("Vos", coordinate: userCoordinate)
                        .tint(.blue)
                }
                .mapControls {
                    MapUserLocationButton()
                    MapCompass()
                    MapPitchToggle()
                }

            } else {
                ProgressView("Obteniendo ubicación…")
            }
        }
        .navigationTitle(sucursal.name)
    }
}


#Preview {
    let sucursalesViewModel = LocationRegisterKitModule.shared.sucursalesViewModel
    sucursalesViewModel.cargarSucursales()
    let sucursal = sucursalesViewModel.sucursales.first!
    
    let context = DataController.preview.container.viewContext

    let locationManager = LocationRegisterKitModule.shared.locationManager
    locationManager.userLocation = CLLocation(latitude: -34.60, longitude: -58.38)
    
    return NavigationView {
        SucursalDetailView(sucursal: sucursal)
            .environment(\.managedObjectContext, context)
            .environmentObject(locationManager)
    }
}

