//
//  RegistroRowView.swift
//  iSucurgal
//
//  Created by Matías Spinelli on 08/12/2025.
//

import SwiftUI
import CoreData
import LocationRegisterKit

struct RegistroRowView: View {
    let registro: Registro
    let sucursal: Sucursal?

    var body: some View {
        HStack(spacing: 12) {

            Image(systemName: registro.tipoEnum == .entrada ?
                  "arrow.down.circle.fill" :
                  "arrow.up.circle.fill")
                .font(.system(size: 28))
                .foregroundColor(registro.tipoEnum == .entrada ? .green : .red)

            VStack(alignment: .leading, spacing: 4) {

                Text(registro.tipoEnum.rawValue.capitalized)
                    .font(.headline)
                    .foregroundColor(registro.tipoEnum == .entrada ? .green : .red)

                Text(registro.timestamp.formatted(date: .abbreviated, time: .shortened))
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                if let sucursal = sucursal {
                    Text(sucursal.name)
                        .font(.subheadline)
                        .foregroundColor(.blue)
                } else {
                    Text("Sucursal desconocida")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }

            Spacer()
        }
        .padding(.vertical, 6)
    }
}

#Preview {
    let context = DataController.preview.container.viewContext

    let reg = Registro(context: context)
    reg.id = UUID()
    reg.timestamp = Date()
    reg.tipo = "entrada"
    reg.sucursalID = UUID()
    reg.userID = UUID()

    let sucursal = Sucursal(context: context)
    sucursal.id = reg.sucursalID
    sucursal.name = "Sucursal Demo"

    return RegistroRowView(registro: reg, sucursal: sucursal)
}
