//
//  OrderItem.swift
//  Printeroo
//
//  Created by Admin on 10/8/22.
//

import Foundation
import UIKit

struct OrderItem: Equatable {
    let itemID: String
    let itemName: String
    let price: Double
    let amount: Int
    let editedImage: UIImage
    let itemType: String
}
