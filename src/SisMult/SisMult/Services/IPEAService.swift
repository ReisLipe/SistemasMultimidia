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
            let localIP = "192.168.1.65" // IP local // ifconfig | grep "inet " | grep -v 127.0.0.1
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
        await updateLoadingStatus(isLoading: true, error: nil)
        
        do {
            let bolsas = try await performNetworkRequest()
            await updateLoadingStatus(isLoading: false, error: nil)
            await updateBolsas(bolsas)
        } catch {
            let fetchError = mapToFetchError(error)
            await updateLoadingStatus(isLoading: false, error: fetchError.localizedDescription)
        }
    }
    
    private func performNetworkRequest() async throws -> [BolsaModel] {
        let url = try createURL()
        let (data, response) = try await urlSession.data(from: url)
        print("Response obtaind from server: \(data)")
              
        try validateResponse(response)
        let bolsas = try parseResponse(data)
        
        return bolsas
    }
    
    private func createURL() throws -> URL {
        guard let url = URL(string: baseURL) else {
            throw FetchError.invalidURL
        }
        return url
    }
    
    private func validateResponse(_ response: URLResponse) throws {
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw FetchError.invalidResponse
        }
    }

    private func parseResponse(_ data: Data) throws -> [BolsaModel] {
        let decoder = JSONDecoder()
        do {
            let ipeaResponse = try decoder.decode(IPEAResponseModel.self, from: data)
            return ipeaResponse.items
        } catch let DecodingError.keyNotFound(key, context) {
            print("Chave não encontrada: \(key)")
            print("Contexto: \(context)")
            throw FetchError.invalidResponse
        } catch let DecodingError.typeMismatch(type, context) {
            print("Tipo incompatível: \(type)")
            print("Contexto: \(context)")
            throw FetchError.invalidResponse
        }
    }
    
    private func mapToFetchError(_ error: Error) -> FetchError {
        if error.localizedDescription.contains("timeout") {
            return .timeout
        } else if error is FetchError {
            return error as! FetchError
        } else {
            return .network(error)
        }
    }
    
    @MainActor private func updateLoadingStatus(isLoading: Bool, error: String?) {
        self.isLoading = isLoading
        self.errorMessage = error
    }
    @MainActor private func updateBolsas(_ bolsas: [BolsaModel]) {
        // self.bolsas = bolsas
        self.bolsas = bolsas.filter { $0.situacao == "Situação:ABERTA" || $0.situacao == nil }
    }
}
