//
//  APITarget.swift
//  GithubCopilotLearning
//
//  Created by Rishita Panchal on 26/03/2026.
//  Copyright © 2026 Simform Solutions. All rights reserved.
//
import NetworkEngine
/// Defines the APIs available
public enum APITarget: NetworkRepo {
    case refreshToken(request: RefreshTokenRequest)
    case randomUser(request: UserListRequest)
    // MARK: - Signup
    case signupLookup(request: SignupLookupRequest)
    case signupResendOTP(request: ResendOTPRequest)
    case signupVerifyOTP(request: OTPVerificationRequest)
    case signupCreatePassword(request: CreatePasswordRequest)
    case signupAcceptTerms(request: TermsAcceptanceRequest)
}
extension APITarget {
    
    public var timeoutInterval: TimeInterval {
        60.0 // Seconds
    }
    public var baseURL: URL {
        guard let baseURL = URL(string: AppSecrets.baseURL) else {
            fatalError("Invalid base URL: \(AppSecrets.baseURL)")
        }
        return baseURL
    }
    public var path: String {
        switch self {
        case .refreshToken:
            return "refreshtoken/"
        case .randomUser:
            return "/api/users/random_user"
        case .signupLookup:
            return "/signup/lookup"
        case .signupResendOTP:
            return "/signup/resend-otp"
        case .signupVerifyOTP:
            return "/signup/verify-otp"
        case .signupCreatePassword:
            return "/signup/create-password"
        case .signupAcceptTerms:
            return "/signup/accept-terms"
        }
    }
    public var method: NetworkEngine.Method {
        switch self {
        case .refreshToken:
            return .post
        case .randomUser:
            return .get
        case .signupLookup, .signupResendOTP, .signupVerifyOTP,
             .signupCreatePassword, .signupAcceptTerms:
            return .post
        }
    }
    public var task: NetworkTask {
        switch self {
        case .refreshToken(let request):
            return .requestJSONEncodable(request)
        case .randomUser(let request):
            return .requestParameterEncodable(request)
        case .signupLookup(let request):
            return .requestJSONEncodable(request)
        case .signupResendOTP(let request):
            return .requestJSONEncodable(request)
        case .signupVerifyOTP(let request):
            return .requestJSONEncodable(request)
        case .signupCreatePassword(let request):
            return .requestJSONEncodable(request)
        case .signupAcceptTerms(let request):
            return .requestJSONEncodable(request)
        }
    }
    public var keyDecodingStrategy: NetworkEngine.KeyDecodingStrategy {
        switch self {
        case .refreshToken, .randomUser,
             .signupLookup, .signupResendOTP, .signupVerifyOTP,
             .signupCreatePassword, .signupAcceptTerms:
            return .convertFromSnakeCase
        }
    }
    public var headers: [String: String]? {
        switch self {
        case .refreshToken:
            return NetworkHelper.httpPreTokenHeader
        case .randomUser:
            return NetworkHelper.httpPreTokenHeader
        case .signupLookup, .signupResendOTP, .signupVerifyOTP,
             .signupCreatePassword, .signupAcceptTerms:
            return NetworkHelper.httpPreTokenHeader
        }
    }
}
// MARK: Static objects for network calls
extension APITarget {
    static let interceptor = DefaultInterceptor(refreshTokenCall)
    static let provider = NetworkProvider<APITarget>(interceptor: interceptor)
    static func refreshTokenCall(_ completion: @escaping (Bool) -> Void) {
        let requestParameter = RefreshTokenRequest(
            token: KeychainStorageContainer.apiToken ?? "",
            refreshToken: AppSecrets.refreshToken)
        refreshToken(request: requestParameter)
            .request(type: BaseResponseModel<RefreshTokenResponse>.self) { result in
            do {
                let response = try result.get()
                KeychainStorageContainer.apiToken = response.result?.token ?? ""
                completion(response.result?.token != nil)
            } catch {
                completion(false)
            }
        }
    }
}
// MARK: NetworkRequestable conformance
extension APITarget {
    func request<T>(type: T.Type) async -> Result<T, CustomError> where T: Decodable {
        guard ReachabilityManager.shared.isNetworkReachable else {
            return .failure(CustomError.noInternet)
        }
        return await APITarget.provider.request(self, type: type).mapError { error in
            return ErrorConverter.convert(error)
        }
    }
    func request<T: Decodable>(type: T.Type,
                               callback: @escaping (Result<T, CustomError>) -> Void) {
        guard ReachabilityManager.shared.isNetworkReachable else {
            callback(.failure(CustomError.noInternet))
            return
        }
        APITarget.provider.request(self, type: type) { result in
            callback(result.mapError { return ErrorConverter.convert($0) })
        }
    }
}
