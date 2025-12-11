//
//  HomeView.swift
//  iSucurgal
//
//  Created by Matías Spinelli on 06/12/2025.
//

//
//  HomeView.swift
//  iSucurgal
//

import SwiftUI
import CoreData
import LocationRegisterKit

struct HomeView: View {

    @Environment(\.managedObjectContext) private var context

    @EnvironmentObject var sucursalesViewModel: SucursalesViewModel
    @EnvironmentObject var registroViewModel: RegistroViewModel
    @EnvironmentObject var geofencingManager: GeofencingManager

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {

                    VStack(spacing: 12) {
                        navigationCard(
                            title: "Sucursales",
                            systemImage: "building.2",
                            destination: AnyView(SucursalesView())
                        )

                        navigationCard(
                            title: "Registros (CoreData)",
                            systemImage: "clock.arrow.circlepath",
                            destination: AnyView(RegistrosView())
                        )
                        
                        navigationCard(
                            title: "Registros (API)",
                            systemImage: "clock.arrow.circlepath",
                            destination: AnyView(RegistrosAPIView())
                        )
                    }
                    .padding(.horizontal)

                    Spacer()
                    
                    debugGrid
                        .padding(.horizontal)

                }
                .padding(.vertical)
            }
            .background(Color(.systemGray6))
            .navigationTitle("iSucurgal")
        }
    }

    private func navigationCard(title: String,
                                systemImage: String,
                                destination: AnyView) -> some View {

        NavigationLink(destination: destination) {
            HStack {
                Image(systemName: systemImage)
                    .font(.system(size: 20))
                    .foregroundColor(.blue)

                Text(title)
                    .font(.headline)

                Spacer()

                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 2)
        }
        .buttonStyle(.plain)
    }

    private var debugGrid: some View {

        let columns = [
            GridItem(.flexible(), spacing: 16),
            GridItem(.flexible(), spacing: 16)
        ]

        return LazyVGrid(columns: columns, spacing: 16) {

            debugButton(title: "Clear\nSucursales", systemImage: "trash") {
                sucursalesViewModel.clearAll()
            }

            debugButton(title: "Load JSON\nSucursales", systemImage: "tray.and.arrow.down") {
                sucursalesViewModel.cargarSucursales()
            }

            debugButton(title: "Load API\nSucursales", systemImage: "icloud.and.arrow.down") {
                sucursalesViewModel.cargarSucursales()
            }

            debugButton(title: "Clear\nRegistros", systemImage: "delete.left") {
                registroViewModel.clearAll()
            }

            debugButton(title: "Simular ENTRADA", systemImage: "figure.walk.arrival") {
                if let suc = sucursalesViewModel.sucursales.first {
                    geofencingManager.simulateEnter(regionID: suc.id)
                }
            }

            debugButton(title: "Simular SALIDA", systemImage: "figure.walk.departure") {
                if let suc = sucursalesViewModel.sucursales.first {
                    geofencingManager.simulateExit(regionID: suc.id)
                }
            }
        }
    }

    private func debugButton(title: String,
                             systemImage: String,
                             action: @escaping () -> Void) -> some View {

        Button(action: action) {
            VStack(spacing: 10) {
                Image(systemName: systemImage)
                    .font(.system(size: 26))
                    .foregroundColor(.blue)

                Text(title)
                    .font(.caption)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.primary)
            }
            .padding()
            .frame(maxWidth: .infinity, minHeight: 90)
            .background(Color.white)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 2)
        }
        .buttonStyle(.plain)
    }
}


#Preview {
    HomeView()
        .environment(\.managedObjectContext,
                      DataController.preview.container.viewContext)
        .environmentObject(LocationRegisterKitModule.shared.sucursalesViewModel)
        .environmentObject(LocationRegisterKitModule.shared.registroViewModel)
        .environmentObject(GeofencingManager())
}
