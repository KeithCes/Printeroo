//
//  AddToCartDieCutView.swift
//  Printeroo
//
//  Created by Admin on 10/12/22.
//

import Foundation
import SwiftUI
import PencilKit

struct AddToCartDieCutView: View {
    
    private var itemID: Int
    private var price: Double
    private var itemName: String
    private var itemType: String
    
    @State var amount: String = ""
    
    @Binding var isShowingDieCut: Bool
    @Binding var selectedImage: UIImage
    @Binding var selectedItems: [OrderItem]
    
    @State private var drawingOnImage: UIImage = UIImage()
    @State private var canvasView: PKCanvasView = PKCanvasView()
    
    @State var isShowingToast: Bool = false
    @State var toastMessage: String = "Error"
    
    init(itemID: Int, price: Double, itemName: String, itemType: String, isShowingDieCut: Binding<Bool>, selectedItems: Binding<[OrderItem]>, selectedImage: Binding<UIImage>) {
        self.itemID = itemID
        self.price = price
        self.itemName = itemName
        self.itemType = itemType
        self._isShowingDieCut = isShowingDieCut
        self._selectedItems = selectedItems
        self._selectedImage = selectedImage
    }
    
    var body: some View {
        VStack {
            Image(uiImage: self.selectedImage)
                .resizable()
                .cornerRadius(10)
                .scaledToFit()
                .frame(width: CustomDimensions.width - 80)
                .overlay(CanvasView(
                    canvasView: $canvasView,
                    onSaved: onChanged), alignment: .bottomLeading)
            
            CustomTextbox(field: self.$amount, placeholderText: "Enter how many you'd like")
                .padding(.bottom, 30)
                .keyboardType(.numberPad)
            
            Button("CLEAR SELECTION") {
                self.canvasView.drawing = PKDrawing()
            }
            .font(.system(size: 30, weight: .bold, design: .rounded))
            .foregroundColor(.white)
            .background(Rectangle()
                .fill(CustomColors.darkGray.opacity(0.6))
                .frame(width: 250, height: 50)
                .cornerRadius(15)
            )
            
            Button("ADD TO CART") {
                if Int(self.amount) ?? 0 != 0 && !self.canvasView.drawing.bounds.isEmpty {
                    let orderItem = OrderItem(
                        itemID: UUID().uuidString,
                        itemName: self.itemName,
                        price: self.price,
                        amount: Int(self.amount) ?? 0,
                        editedImage: self.selectedImage.mergeWith(topImage: drawingOnImage),
                        itemType: self.itemType
                    )
                    self.selectedItems.append(orderItem)
                    self.isShowingDieCut.toggle()
                }
                else if self.canvasView.drawing.bounds.isEmpty {
                    self.toastMessage = "You need to select what part of you image you'd like die-cut!"
                    self.isShowingToast.toggle()
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
    
    private func onChanged() -> Void {
        self.drawingOnImage = canvasView.drawing.image(
            from: canvasView.bounds, scale: UIScreen.main.scale)
    }
}
