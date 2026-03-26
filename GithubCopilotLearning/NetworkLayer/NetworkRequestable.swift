//
//  NetworkRequestable.swift
//  GithubCopilotLearning
//
//  Created by Rishita Panchal on 26/03/2026.
//  Copyright © 2026 Simform Solutions. All rights reserved.
//
import Foundation
import NetworkEngine
/// Defines the network call methods
protocol NetworkRequestable {
    /// Request the data in form of `T`
    /// - Parameters:
    ///   - type: The type of `T`
    ///   - callback: The callback handler
    func request<T: Decodable>(type: T.Type,
                               callback: @escaping (Result<T, CustomError>) -> Void)
    /// Request the data in form of `T`
    /// - Parameters:
    ///   - type: The type of `T`
    /// - Returns: The result of decodable type T and `CustomError`
    func request<T: Decodable>(type: T.Type) async -> Result<T, CustomError>
}