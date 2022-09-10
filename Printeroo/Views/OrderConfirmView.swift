//
//  OrderConfirmView.swift
//  Printeroo
//
//  Created by Admin on 9/10/22.
//

import Foundation
import SwiftUI

struct OrderConfirmView: View {
    
    @Binding var isShowingOrderConfirm: Bool
    @Binding var selectedItems: [Int: [String: Any]]
    
    var body: some View {
        VStack {
            Text("PLEASE CONFIRM THE FOLLOWING: ")
            Text("SELECTED ITEMS")
            // this is terrible please change this to by dynamic and not just 100x
            ForEach(0..<100) { itemNumber in
                if let selectedItem = selectedItems[itemNumber] {
                    HStack {
                        Text(selectedItem["itemName"] as! String)
                        Text("$" + String(format: "%.2f", selectedItem["price"] as! Double))
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(CustomColors.sand)
        .ignoresSafeArea()
    }
}
