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
                .frame(width: 200, height: 200)
                .overlay(CanvasView(canvasView: $canvasView, onSaved: onChanged), alignment: .bottomLeading)
            
            CustomTextbox(field: self.$amount, placeholderText: "Enter how many you'd like")
                .padding(.bottom, 30)
                .keyboardType(.numberPad)
            
            Button("ADD TO CART") {
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
    
    private func onChanged() -> Void {
        self.drawingOnImage = canvasView.drawing.image(
            from: canvasView.bounds, scale: UIScreen.main.scale)
    }
    
    private func initCanvas() -> Void {
        self.canvasView = PKCanvasView();
        self.canvasView.isOpaque = false
        self.canvasView.backgroundColor = UIColor.clear
        self.canvasView.becomeFirstResponder()
    }
}
