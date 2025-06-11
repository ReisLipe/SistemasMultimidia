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
                        .foregroundColor(.redEducation)
                    
                    Spacer()
                }
                
                Text(bolsa.descricao)
                    .font(.subheadline)
                    .foregroundColor(.grayText)
 
                HStack {
                    Link("Ver mais", destination: URL(string: bolsa.link)!)
                        .font(.caption)
                        .foregroundColor(.redEducation)
                    
                    Spacer()
                }
            }
            .padding()
            .background(Color.redSoft)
            .cornerRadius(12)
        }
        .listStyle(PlainListStyle())
        .cornerRadius(12)
        .shadow(radius: 12)
    }
}

