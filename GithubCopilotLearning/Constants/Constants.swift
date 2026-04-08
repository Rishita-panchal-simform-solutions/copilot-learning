//
//  Constants.swift
//  GithubCopilotLearning
//
//  Created by Rishita Panchal on 26/03/2026.
//  Copyright © 2026 Simform Solutions. All rights reserved.
//
import UIKit
/// Constants of the project
/// All the hardcoded literals should be places here with proper naming and proper namespace
enum Constants {
    enum CurrentScreen {
        static var screenHeight: CGFloat {
            return UIScreen.main.bounds.height
        }
        static var screenWidth: CGFloat {
            return UIScreen.main.bounds.width
        }
    }
    enum APIManager {
        static let networkRequestRetryDelay = 0.3 // seconds
        static let networkRequestRetryLimit = 1
        static let timeOutInterval = 60.0 // seconds
    }
    enum HeaderKeys {
        static let contentType = "Content-Type"
        static let authorization = "Authorization"
    }

    enum Signup {
        static let supportEmail = "support@incommbenefits.com"
        static let otpResendCooldownSeconds = 60
    }
}

// MARK: - Signup UI strings
enum SignupStrings {
    static let welcomeTitle = "Welcome to InComm Benefits!"
    static let welcomeSignUpButton = "Sign Up"
    static let welcomeLogInPrompt = "Already registered? Log In"

    static let personalInfoTitle = "Let's find your account."
    static let personalInfoSsnLabel = "Last 4 Digits of Social Security Number"
    static let personalInfoDobLabel = "Date of Birth"
    static let personalInfoEmailLabel = "Work Email"
    static let personalInfoSubmitButton = "Submit"
    static let personalInfoContactUs = "Contact Us"

    static let personalInfoErrorNotReady = "Your account is not ready. Your account start date is %@. Please check back on or after this date."
    static let personalInfoErrorDuplicate = "It looks like you already have an account."
    static let personalInfoErrorHsaNotFound = "We were unable to locate an HSA for you. Please contact us for assistance."
    static let personalInfoGoToLogin = "Go to Login"

    static let verifyIdentityTitle = "Verify your identity."
    static let verifyIdentityOtpLabel = "Enter the 6-digit code sent to %@"
    static let verifyIdentityVerifyButton = "Verify"
    static let verifyIdentityResendButton = "Resend"
    static let verifyIdentityResendCooldown = "Resend in %ds"
    static let verifyIdentityErrorInvalidCode = "The code you entered is invalid. Please try again."

    static let createPasswordTitle = "Let's create your login."
    static let createPasswordFieldLabel = "Email"
    static let createPasswordInputLabel = "Password"
    static let createPasswordNextButton = "Next"
    static let createPasswordRuleUppercase = "At least one capital letter"
    static let createPasswordRuleLowercase = "At least one lowercase letter"
    static let createPasswordRuleNumber = "At least one number"
    static let createPasswordRuleLength = "At least 8 characters"

    static let termsTitle = "One final step!"
    static let termsSubtitle = "By clicking Create Login, you agree to, and have read:"
    static let termsCreateLoginButton = "Create Login"
    static let termsESIGN = "E-SIGN Consent Disclosure"
    static let termsPrivacyPolicy = "Privacy Policy and User Agreement"
    static let termsCCBHSA = "Coastal Community Bank Privacy Policy and HSA Agreement"
    static let termsCCBCardholder = "Coastal Community Bank Privacy Policy and Cardholder Agreement"
    static let termsCCBPrivacy = "Coastal Community Bank Privacy Policy"
    static let termsFSACertification = "By checking this box, I certify that the expenses I submit for reimbursement through my FSA or DCFSA will be exclusively for eligible health care expenses."

    static let notificationsTitle = "Login created successfully!"
    static let notificationsPrompt = "Would it be ok if we send notifications?"
    static let notificationsAgreeButton = "Agree to Notifications"
    static let notificationsSkipButton = "Skip This Step"

    static let biometricPromptFaceID = "Do you want to use Face ID to log into InComm Benefits?"
    static let biometricPromptTouchID = "Do you want to use Touch ID to log into InComm Benefits?"
    static let biometricSetupFaceIDButton = "Set Up Face ID Login"
    static let biometricSetupTouchIDButton = "Set Up Touch ID Login"
    static let biometricSkipButton = "Skip This Step"
}