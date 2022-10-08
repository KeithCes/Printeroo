//
//  AddToCartEditView.swift
//  Printeroo
//
//  Created by Admin on 10/7/22.
//

import Foundation
import SwiftUI

struct AddToCartEditView: View {
    
    private var itemID: Int
    private var price: Double
    private var itemName: String
    private var itemType: String
    
    @State var amount: String = ""
    
    @Binding var isShowingCart: Bool
    @Binding var edittedImage: UIImage
    @Binding var selectedItems: [Int: [String: Any]]
    
    init(itemID: Int, price: Double, itemName: String, itemType: String, isShowingCart: Binding<Bool>, selectedItems: Binding<[ Int: [String: Any]]>, edittedImage: Binding<UIImage>) {
        self.itemID = itemID
        self.price = price
        self.itemName = itemName
        self.itemType = itemType
        self._isShowingCart = isShowingCart
        self._selectedItems = selectedItems
        self._edittedImage = edittedImage
    }
    
    var body: some View {
        VStack {
            Image(uiImage: self.edittedImage)
                .resizable()
                .cornerRadius(10)
                .scaledToFit()
                .frame(width: 200, height: 200)
            
            CustomTextbox(field: self.$amount, placeholderText: "Enter how many you'd like")
                .padding(.bottom, 30)
                .keyboardType(.numberPad)
            
            Button("ADD TO CART") {
                self.selectedItems[self.itemID] = ["itemName": self.itemName, "price": self.price, "amount": Int(self.amount) ?? 0, "editedImage": self.edittedImage, "itemType": self.itemType]
                self.isShowingCart.toggle()
            }
            .font(.system(size: 30, weight: .bold, design: .rounded))
            .foregroundColor(.white)
            .background(Rectangle()
                .fill(CustomColors.darkGray.opacity(0.6))
                .frame(width: 250, height: 50)
                .cornerRadius(15)
            )
            
            Spacer()
        }
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(CustomColors.sand)
        .ignoresSafeArea()
    }
}
