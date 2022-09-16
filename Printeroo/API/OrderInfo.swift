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
    var itemNames: [String]
    var orderID: String
    var status: String
    var totalCost: Double
    var userID: String
}
