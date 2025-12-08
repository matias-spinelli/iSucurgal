//
//  SucursalesAllView.swift
//  iSucurgal
//
//  Created by Matías Spinelli on 07/12/2025.
//

import SwiftUI
import MapKit
import CoreLocation

struct SucursalesAllView: View {

    let sucursales: [Sucursal]
    @EnvironmentObject var locationManager: LocationManager

    var body: some View {
        VStack {
            if let userLocation = locationManager.userLocation {

                let userCoordinate = userLocation.coordinate

                Map {
                    Marker("Vos", coordinate: userCoordinate)
                        .tint(.blue)

                    ForEach(sucursales, id: \.id) { sucursal in
                        let coordinate = CLLocationCoordinate2D(
                            latitude: sucursal.latitude,
                            longitude: sucursal.longitude
                        )

                        Marker(sucursal.name, coordinate: coordinate)
                    }
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
        .navigationTitle("Todas las sucursales")
    }
}


#Preview {
    let sucursalesViewModel = SucursalesViewModel()
    sucursalesViewModel.cargarSucursales()
    let sucursales = sucursalesViewModel.sucursales

    let locationManager = LocationManager()
    locationManager.userLocation = CLLocation(latitude: -34.60, longitude: -58.38)

    return NavigationView {
        SucursalesAllView(sucursales: sucursales)
            .environmentObject(locationManager)
    }
}

