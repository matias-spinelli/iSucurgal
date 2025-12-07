//
//  SucursalesView.swift
//  iSucurgal
//
//  Created by Matías Spinelli on 06/12/2025.
//

import SwiftUI
import CoreData

struct SucursalesView: View {

    @EnvironmentObject var vm: SucursalesViewModel

    var body: some View {
        Group {
            if vm.isLoading {
                ProgressView("Cargando sucursales...")
            } else if let error = vm.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .padding()
            } else if vm.sucursales.isEmpty {
                Text("No hay sucursales")
                    .foregroundColor(.gray)
            } else {
                List(vm.sucursales) { suc in
                    NavigationLink(destination: SucursalDetailView(sucursal: suc)) {
                        VStack(alignment: .leading) {
                            Text(suc.name ?? "")
                                .font(.headline)
                            Text(suc.address ?? "")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
        }
        .navigationTitle("Sucursales")
    }
}


#Preview {
    let sucursalesViewModel = SucursalesViewModel()
    sucursalesViewModel.cargarSucursales()
    return NavigationView {
        SucursalesView()
            .environment(\.managedObjectContext,
                          DataController.preview.container.viewContext)
            .environmentObject(sucursalesViewModel)
    }
}

