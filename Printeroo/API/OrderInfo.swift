//
//  OrderInfo.swift
//  Printeroo
//
//  Created by Admin on 9/16/22.
//

import Foundation

struct OrderInfo: Codable, Hashable {
    var dateOfCreation: String
    var imagePath: String
    var itemNamesAmounts: [String: Int]
    var orderID: String
    var paymentIntentID: String
    var status: String
    var totalCost: Double
    var userID: String
}
