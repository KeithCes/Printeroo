//
//  UserInfo.swift
//  Printeroo
//
//  Created by Admin on 9/13/22.
//

import Foundation

struct UserInfo: Codable {
    var dateOfBirth: String
    var dateOfCreation: String
    var email: String
    var firstName: String
    var lastName: String
    var phoneNumber: String
    var profilePictureURL: String
    var stripeCustomerID: String
    var address: String
    var state: String
    var city: String
    var country: String
    var zipcode: String
}
