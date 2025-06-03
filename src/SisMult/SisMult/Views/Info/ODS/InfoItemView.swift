//
//  InfoItemView.swift
//  SisMult
//
//  Created by Joao Filipe Reis Justo da Silva on 29/05/25.
//

import SwiftUI

struct InfoItem: View {
    let number: String
    let text: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // Número do objetivo
            Text(number)
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.redEducation)
                .clipShape(RoundedRectangle(cornerRadius: 6))
            
            // Texto do objetivo
            Text(text)
                .font(.body)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}
