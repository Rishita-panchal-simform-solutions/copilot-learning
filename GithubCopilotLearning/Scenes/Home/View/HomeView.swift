//
//  HomeView.swift
//  GithubCopilotLearning
//
//  Created by Rishita Panchal on 06/04/2026.
//  Copyright © 2026 Simform Solutions. All rights reserved.
//

import SwiftUI

// MARK: - variables
struct HomeView {
    @State private var isLoading: Bool = false
}

// MARK: - view
extension HomeView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                headerView
                Spacer()
                contentView
                Spacer()
            }
            .padding()
            .navigationTitle("Home")
        }
    }
}

// MARK: - subviews
private extension HomeView {
    var headerView: some View {
        Text("Welcome to Home")
            .font(.title)
            .fontWeight(.bold)
    }
    
    var contentView: some View {
        VStack(spacing: 16) {
            Text("This is the home view")
                .font(.body)
                .foregroundColor(.secondary)
            
            Button(action: {
                isLoading = true
            }) {
                Text("Get Started")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
        }
        .padding(.horizontal)
    }
}

// MARK: - preview
#Preview {
    HomeView()
}
