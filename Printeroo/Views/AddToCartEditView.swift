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
    @Binding var selectedItems: [OrderItem]
    
    @State var isShowingToast: Bool = false
    @State var toastMessage: String = "Error"
    
    init(itemID: Int, price: Double, itemName: String, itemType: String, isShowingCart: Binding<Bool>, selectedItems: Binding<[OrderItem]>, edittedImage: Binding<UIImage>) {
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
                if Int(self.amount) ?? 0 != 0 {
                    let orderItem = OrderItem(
                        itemID: UUID().uuidString,
                        itemName: self.itemName,
                        price: self.price,
                        amount: Int(self.amount) ?? 0,
                        editedImage: self.edittedImage,
                        itemType: self.itemType
                    )
                    self.selectedItems.append(orderItem)
                    self.isShowingCart.toggle()
                }
                else {
                    self.toastMessage = "You need to add at least 1 item!"
                    self.isShowingToast.toggle()
                }
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
        .toast(message: self.toastMessage,
               isShowing: self.$isShowingToast,
               duration: Toast.long
        )
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(CustomColors.sand)
        .ignoresSafeArea()
    }
}
