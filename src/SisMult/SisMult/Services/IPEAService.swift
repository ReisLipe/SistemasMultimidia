//
//  IPEAService.swift
//  SisMult
//
//  Created by Joao Filipe Reis Justo da Silva on 03/06/25.
//

import SwiftUI

class IPEAService: ObservableObject {
    private var baseURL: String {
        #if targetEnvironment(simulator)
            return "http://localhost:8080/api/scrape"
        #else
            let localIP = "172.20.10.8" // IP local 
            return "http://\(localIP):8080/api/scrape"
        #endif
    }
    
    @Published var bolsas: [BolsaModel] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    private var urlSession: URLSession {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 120.0    // 2 minutos
        config.timeoutIntervalForResource = 300.0   // 5 minutos
        return URLSession(configuration: config)
    }
    
    func fetchBolsas() async {
        await MainActor.run {
            self.isLoading = true
            self.errorMessage = nil
        }
        
        guard let url = URL(string: baseURL) else {
            await MainActor.run {
                errorMessage = "URL inválida"
                isLoading = false
            }
            return
        }
        
        do {
            let (data, response) = try await urlSession.data(from: url)
            print("Data: \(data)")
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                await MainActor.run {
                    self.errorMessage = "Erro ao obter dados"
                    self.isLoading = false
                }
                return
            }
            
            let decoder = JSONDecoder()
            let ipeaResponse = try decoder.decode(IPEAResponseModel.self, from: data)
            
            await MainActor.run {
                self.bolsas = ipeaResponse.items
                self.isLoading = false
            }
        } catch {
            await MainActor.run {
                if error.localizedDescription.contains("timeout") {
                    self.errorMessage = "Tempo limite excedido"
                } else {
                    self.errorMessage = "Erro: \(error.localizedDescription)"
                }
                
                self.isLoading = false
            }
        }
    }
}
