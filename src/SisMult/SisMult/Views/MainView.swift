//
//  MainView.swift
//  SisMult
//
//  Created by Joao Filipe Reis Justo da Silva on 29/05/25.
//

import SwiftUI

struct MainView: View {
    @StateObject private var service = IPEAService()
    
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
                
                if service.isLoading {
                    Spacer()
                    LoadingView()
                } else {
                    BolsaListView(bolsas: self.service.bolsas)
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
    private func search() {
        Task {
            print("(MainView) Fetching bolsas...")
            await self.service.fetchBolsas()
            
            if !service.isLoading {
                print("(MainView) ErrorMSG: \(String(describing: service.errorMessage))")
                print("(MainView) Bolsas: \n \(service.bolsas)")
            }
        }
    }
}

#Preview {
    MainView()
}
