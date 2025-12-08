//
//  RegistrosView.swift
//  iSucurgal
//
//  Created by Matías Spinelli on 06/12/2025.
//

import SwiftUI
import CoreData

struct RegistrosView: View {

    @EnvironmentObject var registroViewModel: RegistroViewModel
    @EnvironmentObject var sucursalesViewModel: SucursalesViewModel

    var body: some View {
        Group {
            if let error = registroViewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .padding()

            } else if registroViewModel.registros.isEmpty {
                Text("No hay registros aún")
                    .foregroundColor(.gray)

            } else {
                List {
                    ForEach(registroViewModel.registros) { registro in
                        let sucursal = sucursalesViewModel.sucursales.first { $0.id == registro.sucursalID }

                        RegistroRowView(registro: registro, sucursal: sucursal)
                    }
                }
            }
        }
        .navigationTitle("Registros")
        .onAppear {
            registroViewModel.cargarRegistros()
        }
    }
}

#Preview {
    let registroViewModel = RegistroViewModel()
    registroViewModel.cargarRegistros()

    return NavigationView {
        RegistrosView()
            .environment(\.managedObjectContext, DataController.preview.container.viewContext)
            .environmentObject(registroViewModel)
            .environmentObject(SucursalesViewModel())
    }
}
