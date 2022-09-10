//
//  CheckoutItem.swift
//  Printeroo
//
//  Created by Admin on 9/8/22.
//

import Foundation
import SwiftUI

struct CheckoutItem: View {
    
    private var itemID: Int
    private var image: UIImage
    private var price: Double
    private var itemName: String

    @State var isSelected: Bool = false
    
    @Binding var selectedItems: [Int: [String: Any]]
    
    
    init(itemID: Int, image: UIImage, price: Double, itemName: String, selectedItems: Binding<[ Int: [String: Any]]>) {
        self.itemID = itemID
        self.image = image
        self.price = price
        self.itemName = itemName
        self._selectedItems = selectedItems
    }
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.white.opacity(0.3))
                .frame(width: 172, height: 318)
                .cornerRadius(10)
            Image(uiImage: self.image)
                .resizable()
                .frame(width: 150, height: 270)
                .cornerRadius(10)
                .padding(.bottom, 20)
                .blur(radius: !self.isSelected ? 0 : 2)
            Image(systemName: "checkmark.circle")
                .resizable()
                .frame(width: 48, height: 48)
                .foregroundColor(.green)
                .isHidden(!self.isSelected)
            VStack {
                HStack {
                    Spacer()
                    ZStack {
                        Rectangle()
                            .foregroundColor(CustomColors.sand.opacity(0.5))
                            .cornerRadius(10)
                        Text("$" + String(format: "%.2f", self.price))
                            .foregroundColor(CustomColors.darkGray)
                            .fontWeight(.semibold)
                    }
                    .frame(width: 63, height: 42)
                    .padding(.trailing, 11)
                    .padding(.top, 14)
                }
                Spacer()
                ZStack {
                    Rectangle()
                        .foregroundColor(.white.opacity(0.3))
                        .cornerRadius(10)
                    Text(self.itemName)
                        .foregroundColor(CustomColors.darkGray)
                        .fontWeight(.semibold)
                }
                .frame(width: 172, height: 34)
            }

        }
        .onTapGesture {
            if self.isSelected {
                self.selectedItems.removeValue(forKey: self.itemID)
                self.isSelected = false
            }
            else {
                self.selectedItems[self.itemID] = ["itemName": self.itemName, "price": self.price]
                self.isSelected = true
            }
        }
    }
}
