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
    
    @State var totalCost: Double = 0
    
    var body: some View {
        VStack {
            
            CustomTitleText(labelText: "PLEASE CONFIRM THE FOLLOWING: ")
            CustomTitleText(labelText: "SELECTED ITEMS", fontSize: 24)
                .padding(.top, 20)
            
            // this is terrible please change this to by dynamic and not just 100x
            ZStack {
                Rectangle()
                    .foregroundColor(.white.opacity(0.1))
                    .frame(width: CustomDimensions.width, height: 100 + CGFloat((selectedItems.count * 12)))
                    .cornerRadius(10)
                VStack {
                    ForEach(0..<100) { itemNumber in
                        if let selectedItem = selectedItems[itemNumber] {
                            HStack {
                                Text(selectedItem["itemName"] as! String)
                                Text("$" + String(format: "%.2f", selectedItem["price"] as! Double))
                            }
                        }
                    }
                    HStack {
                        Text("TOTAL COST")
                            .bold()
                        Text("$" + String(format: "%.2f", self.totalCost))
                            .bold()
                    }
                }
            }
            Button("CONFIRM") {
                // TODO: add stripe payment
            }
            .font(.system(size: 30, weight: .bold, design: .rounded))
            .foregroundColor(.white)
            .background(Rectangle()
                .fill(CustomColors.darkGray.opacity(0.6))
                .frame(width: 200, height: 50)
                .cornerRadius(15)
            )
            .padding(.top, 50)
        }
        .onAppear() {
            for item in selectedItems.values {
                self.totalCost += item["price"] as! Double
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(CustomColors.sand)
        .ignoresSafeArea()
    }
}
