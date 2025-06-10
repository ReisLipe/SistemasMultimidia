//
//  ServiceErrors.swift
//  SisMult
//
//  Created by Joao Filipe Reis Justo da Silva on 10/06/25.
//

import SwiftUI

enum FetchError: LocalizedError {
    case invalidURL
    case invalidResponse
    case timeout
    case network(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "URL inválida"
        case .invalidResponse:
            return "Erro ao obter dados"
        case .timeout:
            return "Tempo limite excedido"
        case .network(let error):
            return "Erro: \(error.localizedDescription)"
        }
    }
}
