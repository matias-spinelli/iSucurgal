//
//  RegistroDTORowView.swift
//  iSucurgal
//
//  Created by Matías Spinelli on 11/12/2025.
//

import SwiftUI
import CoreData
import LocationRegisterKit

struct RegistroDTORowView: View {
    let registro: RegistroDTO
    let sucursal: Sucursal?

    var body: some View {
        HStack(spacing: 12) {

            Image(systemName: registro.tipo == .entrada ?
                  "arrow.down.circle.fill" :
                  "arrow.up.circle.fill")
                .font(.system(size: 28))
                .foregroundColor(registro.tipo == .entrada ? .green : .red)

            VStack(alignment: .leading, spacing: 4) {

                Text(registro.tipo.rawValue.capitalized)
                    .font(.headline)
                    .foregroundColor(registro.tipo == .entrada ? .green : .red)

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
