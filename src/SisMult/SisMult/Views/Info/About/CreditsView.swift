//
//  CreditsView.swift
//  SisMult
//
//  Created by Joao Filipe Reis Justo da Silva on 29/05/25.
//

import SwiftUI

struct CreditsView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    
                    // Descrição principal
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Descrição")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.redEducation)
                        
                        Text(AboutStrings.about)
                            .font(.body)
                            .lineLimit(nil)
                            .foregroundColor(.primary)
                    }
                    .padding(.vertical)
                    
                    Divider()
                    
                    // Informações técnicas
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Informações Técnicas")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.redEducation)
                        
                        // Universidade
                        InfoRowView(
                            icon: "building.2.fill",
                            title: "Instituição",
                            content: "Universidade de Pernambuco"
                        )
                        
                        // Disciplina
                        InfoRowView(
                            icon: "book.fill",
                            title: "Disciplina",
                            content: "Sistemas Multimídia"
                        )
                        
                        // ODS
                        InfoRowView(
                            icon: "target",
                            title: "Objetivo",
                            content: "Promover ODS 4 - Educação de Qualidade"
                        )
                        
                        // Licença com link
                        VStack(alignment: .leading, spacing: 8) {
                            HStack(spacing: 12) {
                                Image(systemName: "doc.text.fill")
                                    .font(.title3)
                                    .foregroundColor(.redEducation)
                                    .frame(width: 24)
                                
                                Text("Licença")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .foregroundColor(.secondary)
                            }
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(AboutStrings.aboutLicense)
                                    .font(.body)
                                    .foregroundColor(.primary)
                                
                                Link(destination: URL(string: AboutStrings.aboutLink)!) {
                                    HStack(spacing: 6) {
                                        Image(systemName: "link")
                                            .font(.caption)
                                        
                                        Text("GitHub Repository")
                                            .font(.body)
                                            .underline()
                                    }
                                    .foregroundColor(.blue)
                                }
                            }
                            .padding(.leading, 36)
                        }
                    }
                    
                    Divider()
                    
                    // Footer com data/versão
                    VStack(spacing: 8) {
                        Text("Desenvolvido em 2025")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        HStack(spacing: 4) {
                            Text("Feito com")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            
                            Image(systemName: "heart.fill")
                                .font(.caption)
                                .foregroundColor(.redEducation)
                            
                            Text("usando SwiftUI")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, 20)
                    
                    Spacer(minLength: 20)
                }
                .padding(.horizontal, 20)
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack {
                        Text("Sobre o Aplicativo")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.redEducation)
                        Image(systemName: "info.circle.fill")
                            .font(.title3)
                            .fontWeight(.medium)
                            .foregroundColor(.redEducation)
                    }
                    
                }
            }
        }
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
    }
}

#Preview {
    CreditsView()
}
