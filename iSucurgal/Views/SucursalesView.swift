//
//  SucursalesView.swift
//  iSucurgal
//
//  Created by Matías Spinelli on 06/12/2025.
//

import SwiftUI
import CoreData
import LocationRegisterKit

struct SucursalesView: View {

    @EnvironmentObject var sucursalesViewModel: SucursalesViewModel

    var body: some View {
        Group {
            if sucursalesViewModel.isLoading {
                ProgressView("Cargando sucursales...")
            } else if let error = sucursalesViewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .padding()
            } else if sucursalesViewModel.sucursales.isEmpty {
                Text("No hay sucursales")
                    .foregroundColor(.gray)
            } else {
                List {
                    NavigationLink(destination: SucursalesAllView(sucursales: sucursalesViewModel.sucursales)) {
                        Text("Todas las sucursales")
                            .font(.headline)
                            .foregroundColor(.blue)
                    }

                    ForEach(sucursalesViewModel.sucursales) { sucursal in
                        NavigationLink(destination: SucursalDetailView(sucursal: sucursal)) {
                            VStack(alignment: .leading) {
                                Text(sucursal.name)
                                    .font(.headline)
                                Text(sucursal.address)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
            }

        }
        .navigationTitle("Sucursales")
    }
}


#Preview {
    let sucursalesViewModel = LocationRegisterKitModule.shared.sucursalesViewModel
    sucursalesViewModel.cargarSucursales()
    return NavigationView {
        SucursalesView()
            .environment(\.managedObjectContext,
                          DataController.preview.container.viewContext)
            .environmentObject(sucursalesViewModel)
    }
}

