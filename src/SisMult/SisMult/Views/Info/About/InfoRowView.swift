//
//  InfoRowView.swift
//  SisMult
//
//  Created by Joao Filipe Reis Justo da Silva on 29/05/25.
//

import SwiftUI

struct InfoRowView: View {
    let icon: String
    let title: String
    let content: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.redEducation)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
                
                Text(content)
                    .font(.body)
                    .foregroundColor(.primary)
            }
        }
    }
}
