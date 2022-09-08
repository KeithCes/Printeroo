//
//  CheckoutItem.swift
//  Printeroo
//
//  Created by Admin on 9/8/22.
//

import Foundation
import SwiftUI

struct CheckoutItem: View {
    
    private var imageName: String
    private var price: Double
    private var itemName: String
    
    @State var isSelected: Bool = false
    
    init(imageName: String, price: Double, itemName: String) {
        self.imageName = imageName
        self.price = price
        self.itemName = itemName
    }
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.white.opacity(0.5))
                .frame(width: 172, height: 315)
                .cornerRadius(10)
            Image(self.imageName)
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
        }
        .onTapGesture {
            self.isSelected.toggle()
        }
    }
}
