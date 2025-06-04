//
//  LoadingView.swift
//  SisMult
//
//  Created by Joao Filipe Reis Justo da Silva on 03/06/25.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        VStack(spacing: 20) {
            ProgressView()
                .scaleEffect(2)
                .progressViewStyle(
                    CircularProgressViewStyle(tint: Color.white)
                )
                
            Text("Carregando...")
                .font(.headline)
                .bold()
                .foregroundStyle(.white)
        }
    }
}

#Preview {
    LoadingView()
}
