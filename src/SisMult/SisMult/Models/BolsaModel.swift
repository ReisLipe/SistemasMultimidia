//
//  BolsaModel.swift
//  SisMult
//
//  Created by Joao Filipe Reis Justo da Silva on 03/06/25.
//


struct BolsaModel: Codable, Identifiable {
    let id: Int
    let title: String
    let programa: String
    let situacao: String
    let link: String
}
