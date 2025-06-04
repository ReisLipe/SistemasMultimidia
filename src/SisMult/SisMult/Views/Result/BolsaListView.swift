//
//  BolsaListView.swift
//  SisMult
//
//  Created by Joao Filipe Reis Justo da Silva on 03/06/25.
//

import SwiftUI

struct BolsaListView: View {
    let bolsas: [BolsaModel]
    
    var body: some View {
        List(bolsas) { bolsa in
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(bolsa.title)
                        .font(.headline)
                        .lineLimit(2)
                    
                    Spacer()
                    
                    Text(bolsa.situacao)
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.blue.opacity(0.1))
                        .foregroundColor(.blue)
                        .cornerRadius(4)
                }
                
                Text(bolsa.programa)
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                
                HStack {
                    Link("Ver detalhes", destination: URL(string: bolsa.link)!)
                        .font(.caption)
                        .foregroundColor(.accentColor)
                    
                    Spacer()
                    
                    Text("ID: \(bolsa.id)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .padding(.vertical, 4)
        }
        .listStyle(PlainListStyle())
    }
}

