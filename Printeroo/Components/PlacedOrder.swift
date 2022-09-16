//
//  PlacedOrder.swift
//  Printeroo
//
//  Created by Admin on 9/16/22.
//

import Foundation
import SwiftUI
import FirebaseStorage

struct PlacedOrder: View {
    
    private var order: OrderInfo
    
    @State var image: Image = Image(uiImage: UIImage())
    @State var isProgressViewHidden: Bool = false
    
    init(order: OrderInfo) {
        self.order = order
    }
    
    var body: some View {
        VStack {
            self.image
                .resizable()
                .frame(width: 100, height: 100)
                .cornerRadius(15)
                .padding(.all, 20)
            
            CustomTitleText(labelText: self.order.orderID, fontSize: 16)
                .padding(.bottom, 20)
            
            Text("Total Cost: $" + String(format: "%.2f", self.order.totalCost))
            Spacer()
            Text("Order Status: " + self.order.status)
            Spacer()
            Text("Date Placed: " + self.order.dateOfCreation)
            Spacer()
            Text("Items Ordered: \n" + self.order.itemNames.joined(separator: ", "))
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.bottom, 20)
        .padding(.horizontal, 20)
        .overlay(
            ProgressView()
                .background(RoundedRectangle(cornerRadius: 3)
                    .fill(.clear))
                .progressViewStyle(CircularProgressViewStyle(tint: CustomColors.darkGray))
                .isHidden(self.isProgressViewHidden)
        )
        .onAppear() {
            getOrderImage(orderImagePath: self.order.imagePath)
        }
    }
    
    
    func getOrderImage(orderImagePath: String) {
        
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let orderImageRef = storageRef.child(orderImagePath)
        
        var orderImage = Image(uiImage: UIImage())
        orderImageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let _ = error {
                print(error?.localizedDescription as Any)
            } else {
                guard let data = data else {
                    print("image data nil")
                    return
                }
                
                let orderInputImage = UIImage(data: data)
                guard let inputImage = orderInputImage else {
                    print("orderInputImage nil")
                    return
                }
                orderImage = Image(uiImage: inputImage)
                self.image = orderImage
                self.isProgressViewHidden = true
            }
        }
    }
}
