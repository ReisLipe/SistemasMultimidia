//
//  MainView.swift
//  SisMult
//
//  Created by Joao Filipe Reis Justo da Silva on 29/05/25.
//

import SwiftUI

struct MainView: View {
    @State var showingInfoSheet: Bool = false
    @State var showingAboutSheet: Bool = false
    
    var body: some View {
        ZStack {
            // Background
            Color.redEducation
                .ignoresSafeArea()
            
            VStack {
                // Title
                HStack{
                    Text("Sistemas Multimídia")
                        .font(.largeTitle)
                        .bold()
                        .font(.Header)
                        .foregroundStyle(.white)
                }
                Spacer()
                
                // Buttons
                VStack(spacing: 32) {
                    Button(action: search) {
                        HStack {
                            Text("Procurar")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundStyle(.redEducation)
                            Image(systemName: "magnifyingglass.circle")
                                .font(.title2)
                                .fontWeight(.medium)
                                .foregroundStyle(.redEducation)
                        }
                        .frame(minWidth: 184, minHeight: 52)
                        .background {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.white)
                                .shadow(color: Color.black.opacity(0.3), radius: 0, x: 8, y: 8)
                        }
                    }
                    
                    HStack(spacing: 8) {
                        Button(action: openInfoWindow) {
                            HStack {
                                Text("ODS 4")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                    .foregroundStyle(.redEducation)
                                Image(systemName: "book")
                                    .font(.headline)
                                    .fontWeight(.medium)
                                    .foregroundStyle(.redEducation)
                            }
                            .frame(minWidth: 156, minHeight: 48)
                            .background {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.white)
                                    .shadow(color: Color.black.opacity(0.2), radius: 0, x: 8, y: 8)
                            }
                        }
                        
                        Button(action: openAboutWindow) {
                            HStack {
                                Text("Sobre")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                    .foregroundStyle(.redEducation)
                                Image(systemName: "pencil.and.scribble")
                                    .font(.headline)
                                    .fontWeight(.medium)
                                    .foregroundStyle(.redEducation)
                            }
                            .frame(minWidth: 156, minHeight: 48)
                            .background {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.white)
                                    .shadow(color: Color.black.opacity(0.2), radius: 0, x: 8, y: 8)
                            }
                        }
                    }
                }
            }
            .padding()
        }
        .sheet(isPresented: $showingInfoSheet) {
            EducationView()
        }
        .sheet(isPresented: $showingAboutSheet) {
            CreditsView()
        }
    }
    
    private func openInfoWindow() { self.showingInfoSheet = true }
    private func openAboutWindow() { self.showingAboutSheet = true }
    private func search() {}
}

#Preview {
    MainView()
}
