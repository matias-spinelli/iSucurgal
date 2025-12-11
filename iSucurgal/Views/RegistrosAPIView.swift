//
//  RegistrosAPIView.swift
//  iSucurgal
//
//  Created by Matías Spinelli on 11/12/2025.
//

import SwiftUI
import CoreData
import LocationRegisterKit

struct RegistrosAPIView: View {

    @EnvironmentObject var registroViewModel: RegistroViewModel
    @EnvironmentObject var sucursalesViewModel: SucursalesViewModel

    var body: some View {
        Group {
            if let error = registroViewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .padding()

            } else if registroViewModel.registrosAPI.isEmpty {
                Text("No hay registros aún")
                    .foregroundColor(.gray)

            } else {
                List {
                    ForEach(registroViewModel.registrosAPI) { registro in
                        let sucursal = sucursalesViewModel.sucursales.first { $0.id == registro.sucursalID }

                        RegistroDTORowView(registro: registro, sucursal: sucursal)
                    }
                }
            }
        }
        .navigationTitle("Registros")
        .task {
            await registroViewModel.getRegistrosFromAPI()
        }
    }
}


#Preview {
    let registroViewModel = LocationRegisterKitModule.shared.registroViewModel
    Task {
        await registroViewModel.getRegistrosFromAPI()
    }
    
    return NavigationView {
        RegistrosAPIView()
            .environment(\.managedObjectContext, DataController.preview.container.viewContext)
            .environmentObject(registroViewModel)
            .environmentObject(LocationRegisterKitModule.shared.sucursalesViewModel)
    }
}
