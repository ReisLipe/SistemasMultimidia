//
//  EducationView.swift
//  SisMult
//
//  Created by Joao Filipe Reis Justo da Silva on 29/05/25.
//

import SwiftUI

struct EducationView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack (alignment: .leading, spacing: 20){
                    
                    // Título principal
                    VStack(alignment: .leading, spacing: 8) {
                        Text(InfoStrings.infoTitle)
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.redEducation)
                        
                        Text(InfoStrings.subTitle)
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                    
                    Divider()
                    
                    VStack(alignment: .leading, spacing: 16) {
                        InfoItem(number: "4.1", text: InfoStrings.quatroUm)
                        InfoItem(number: "4.2", text: InfoStrings.quatroDois)
                        InfoItem(number: "4.3", text: InfoStrings.quatroTres)
                        InfoItem(number: "4.4", text: InfoStrings.quatroQuatro)
                        InfoItem(number: "4.5", text: InfoStrings.quatroCinco)
                        InfoItem(number: "4.6", text: InfoStrings.quatroSeis)
                        InfoItem(number: "4.7", text: InfoStrings.quatroSete)
                        InfoItem(number: "4.a", text: InfoStrings.quatroA)
                        InfoItem(number: "4.b", text: InfoStrings.quatroB)
                        InfoItem(number: "4.c", text: InfoStrings.quatroC)
                    }
                    
                    // Spacer para melhorar a leitura
                    Spacer(minLength: 20)
                }
                .padding()
            }
            .navigationTitle("ODS 4")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack {
                        Text("ODS 4")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.redEducation)
                        
                        Image(systemName: "book")
                            .font(.title3)
                            .fontWeight(.medium)
                            .foregroundStyle(.redEducation)
                    }
                }
            }
        }
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
    }
}

#Preview {
    EducationView()
}
