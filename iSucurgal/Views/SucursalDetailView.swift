//
//  SucursalDetailView.swift
//  iSucurgal
//
//  Created by Matías Spinelli on 06/12/2025.
//

import SwiftUI
import MapKit
import CoreData

struct SucursalDetailView: View {

    let sucursal: Sucursal
    @EnvironmentObject var locationManager: LocationManager

    // detectar si estamos en preview
    private var isPreview: Bool {
        ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
    }

    var body: some View {
        VStack {
            if let userLocation = locationManager.userLocation {
                let userCoord = userLocation.coordinate
                let sucCoord = CLLocationCoordinate2D(
                    latitude: sucursal.latitude,
                    longitude: sucursal.longitude
                )

                Map {
                    Marker(sucursal.name ?? "Sucursal", coordinate: sucCoord)

                    Marker("Vos", coordinate: userCoord)
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
        .navigationTitle(sucursal.name ?? "Sucursal")
        .onAppear {
            if !isPreview {
                // acá NO se pide autorización, ya lo hace iSucurgalApp
                locationManager.startUpdatingLocation()
            }
        }
    }
}


#Preview {
    let sucursalesViewModel = SucursalesViewModel()
    sucursalesViewModel.cargarSucursales()
    let sucursal = sucursalesViewModel.sucursales.first!
    
    let context = DataController.preview.container.viewContext

    // LocationManager con una ubicación mock
    let previewLM = LocationManager()
    previewLM.userLocation = CLLocation(latitude: -34.60, longitude: -58.38)
    
    return NavigationView {
        SucursalDetailView(sucursal: sucursal)
            .environment(\.managedObjectContext, context)
            .environmentObject(previewLM)
    }
}

