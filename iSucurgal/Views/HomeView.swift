//
//  HomeView.swift
//  iSucurgal
//
//  Created by Matías Spinelli on 06/12/2025.
//

import SwiftUI
import CoreData

struct HomeView: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: SucursalesView()) {
                    Label("Sucursales", systemImage: "building.2")
                        .font(.headline)
                        .padding(.vertical, 8)
                }

                NavigationLink(destination: RegistrosView()) {
                    Label("Registros", systemImage: "clock.arrow.circlepath")
                        .font(.headline)
                        .padding(.vertical, 8)
                }
            }
            .navigationTitle("iSucurgal")
        }
    }
}

#Preview {
    HomeView()
        .environment(\.managedObjectContext,
                      DataController.preview.container.viewContext)
}
