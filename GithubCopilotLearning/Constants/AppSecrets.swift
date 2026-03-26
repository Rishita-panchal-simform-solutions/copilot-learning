//
//  AppSecrets.swift
//  GithubCopilotLearning
//
//  Created by Rishita Panchal on 26/03/2026.
//  Copyright © 2026 Simform Solutions. All rights reserved.
//
import Foundation
import GithubCopilotLearningSecrets
import GithubCopilotLearningSecretsInterfaces
/// A namespace for the app secret variables
public struct AppSecrets {
    
	
	private static var environment: SecretsEnvironmentProtocol {
    	#if Staging
		return Secrets.Staging()
		#elseif Development
		return Secrets.Development()
    	#else
    	fatalError("Build environment not found!!")
    	#endif
	}

#warning("The declaration is just for demo purpose. Please remove.")
    static let sentryKey = environment.sentryDNSKey
    static let globalKey = Secrets.Global().globalKey
    static let baseURL = environment.baseURL
    static let refreshToken = environment.refreshToken
    static let awsS3URL = environment.awsS3URL
}