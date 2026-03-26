//
//  UserList.swift
//  GithubCopilotLearning
//
//  Created by Rishita Panchal on 26/03/2026.
//  Copyright © 2026 Simform Solutions. All rights reserved.
//
import Foundation
#warning("The model is just for demo purpose. Pls remove.")
// MARK: - UserListElement
struct UserListElement: Codable, Hashable {
    let id: Int?
    let uid, password, firstName, lastName: String?
    let username, email: String?
    let avatar: String?
    let gender, phoneNumber, socialInsuranceNumber, dateOfBirth: String?
    let employment: Employment?
    let address: Address?
    let creditCard: CreditCard?
    let subscription: Subscription?
    enum CodingKeys: String, CodingKey {
        case id, uid, password
        case firstName = "first_name"
        case lastName = "last_name"
        case username, email, avatar, gender
        case phoneNumber = "phone_number"
        case socialInsuranceNumber = "social_insurance_number"
        case dateOfBirth = "date_of_birth"
        case employment, address
        case creditCard = "credit_card"
        case subscription
    }
}
// MARK: - Address
struct Address: Codable, Hashable {
    let city, streetName, streetAddress, zipCode: String?
    let state, country: String?
    let coordinates: Coordinates?
    enum CodingKeys: String, CodingKey {
        case city
        case streetName = "street_name"
        case streetAddress = "street_address"
        case zipCode = "zip_code"
        case state, country, coordinates
    }
}
// MARK: - Coordinates
struct Coordinates: Codable, Hashable {
    let lat, lng: Double?
}
// MARK: - CreditCard
struct CreditCard: Codable, Hashable {
    let ccNumber: String?
    enum CodingKeys: String, CodingKey {
        case ccNumber = "cc_number"
    }
}
// MARK: - Employment
struct Employment: Codable, Hashable {
    let title, keySkill: String?
    enum CodingKeys: String, CodingKey {
        case title
        case keySkill = "key_skill"
    }
}
// MARK: - Subscription
struct Subscription: Codable, Hashable {
    let plan, status, paymentMethod, term: String?
    enum CodingKeys: String, CodingKey {
        case plan, status
        case paymentMethod = "payment_method"
        case term
    }
}
typealias UserList = [UserListElement]