//
//  Untitled.swift
//  SisMult
//
//  Created by Joao Filipe Reis Justo da Silva on 03/06/25.
//


struct IPEAResponseModel: Codable {
    let items: [BolsaModel]
    let status: String
    let timestamp: String
    let totalItems: Int
    
    enum CodingKeys: String, CodingKey {
        case items, status, timestamp
        case totalItems = "total_items"
    }
}
