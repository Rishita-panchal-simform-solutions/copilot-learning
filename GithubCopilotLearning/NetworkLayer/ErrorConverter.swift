//
//  ErrorConverter.swift
//  GithubCopilotLearning
//
//  Created by Rishita Panchal on 26/03/2026.
//  Copyright © 2026 Simform Solutions. All rights reserved.
//
import Foundation
import Alamofire
import NetworkEngine
/// Error converter to convert the errors thrown from NetworkEngine's `NetworkError` to project's `CustomError`
class ErrorConverter {
    /// Convert `NetworkError` to `CustomError`
    /// - Parameter error: The `NetworkError`
    /// - Returns: The `CustomError`
    static func convert(_ error: NetworkError) -> CustomError {
        switch error {
        case .networkError(let error, let response, let data):
            let decoder = JSONDecoder()
            if let jsonData = data,
               let serverError = try? decoder.decode(ServerErrorModel.self,
                                                     from: jsonData) {
                return CustomError(title: AppStrings.somethingWentWrong(),
                                   body: serverError.error)
            }
            if case .responseSerializationFailed = error {
                return CustomError(title: AppStrings.somethingWentWrong(),
                                   body: error.localizedDescription)
            }
            if let statusCode = response?.statusCode,
               !StatusCodes.successAndRedirectCodes.contains(statusCode) {
                return convertStatusCodeError(statusCode)
            } else {
                return CustomError.genericError
            }
        case .encodableParameterFailure(let error):
            return CustomError(title: AppStrings.somethingWentWrong(),
                               body: error.localizedDescription)
        case .jsonDictionaryConversionFailed:
            return CustomError(title: AppStrings.somethingWentWrong(),
                               body: error.localizedDescription)
        @unknown default:
            return CustomError.genericError
        }
    }
    /// Convert the status code error to `CustomError`
    /// - Parameter statusCode: The status code
    /// - Returns: The `CustomError`
    private static func convertStatusCodeError(_ statusCode: Int) -> CustomError {
        let code = StatusCodes.init(rawValue: statusCode)
        if let code = code {
            switch code {
            case .parameterRequired, .unProcessableEntity, .unexpectedServerError, .internalServerError:
                return CustomError.genericError
            case .unAuthorized:
                return CustomError(title: AppStrings.somethingWentWrong(),
                                   body: AppStrings.unauthorisedUser())
            case .forbidden:
                return CustomError(title: AppStrings.somethingWentWrong(),
                                   body: AppStrings.serverNotFound())
            case .notFound:
                return CustomError(title: AppStrings.somethingWentWrong(),
                                   body: AppStrings.urlNotFound())
            @unknown default:
                return CustomError.genericError
            }
        }
        return CustomError.genericError
    }
}