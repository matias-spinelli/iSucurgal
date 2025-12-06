//
//  RegistrosView.swift
//  iSucurgal
//
//  Created by Matías Spinelli on 06/12/2025.
//

//
//  RegistrosView.swift
//  iSucurgal
//
//  Created by Matías Spinelli on 06/12/2025.
//

import SwiftUI
import CoreData

struct RegistrosView: View {

    @StateObject private var vm = RegistroViewModel()

    var body: some View {
        Group {
            if let error = vm.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .padding()

            } else if vm.registros.isEmpty {
                Text("No hay registros aún")
                    .foregroundColor(.gray)

            } else {
                List(vm.registros) { reg in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(reg.tipo.capitalized)
                                .font(.headline)

                            Text(reg.timestamp.formatted(date: .abbreviated, time: .shortened))
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }

                        Spacer()

                        Text("Suc: \(reg.sucursalID.uuidString.prefix(4))…")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 4)
                }
            }
        }
        .navigationTitle("Registros")
        .onAppear {
            vm.cargar()
        }
    }
}

#Preview {
    NavigationView {
        RegistrosView()
            .environment(\.managedObjectContext, DataController.preview.container.viewContext)
    }
}
