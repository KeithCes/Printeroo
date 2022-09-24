//
//  PlacedOrder.swift
//  Printeroo
//
//  Created by Admin on 9/16/22.
//

import Foundation
import SwiftUI
import FirebaseStorage
import FirebaseDatabase

struct PlacedOrder: View {
    
    private var order: OrderInfo
    
    @State var image: Image = Image(uiImage: UIImage())
    @State var isProgressViewHidden: Bool = false
    
    @State var paymentIntentID: String = ""
    
    @State var isShowingToast: Bool = false
    @State var toastMessage: String = "Error"
    
    @State var isOrderCancelledSuccessfully: Bool = false
    
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
            
            Group {
                Text("Total Cost: $" + String(format: "%.2f", self.order.totalCost))
                Spacer()
                
                if self.isOrderCancelledSuccessfully || self.order.status == "cancelled" {
                    Text("Order Status: ") + Text("cancelled").foregroundColor(.red)
                }
                else {
                    Text("Order Status: " + self.order.status)
                }
                
                Spacer()
                Text("Date Placed: " + self.order.dateOfCreation)
                Spacer()
                Text("Items Ordered:")
                Text(self.order.itemNamesAmounts.map { String($0.1) + "x " + $0.0 }.joined(separator: "\n"))
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            Spacer()
            
            // only show cancel option if package isnt packed, shipping, or already cancelled
            if !self.isOrderCancelledSuccessfully && self.order.status != "cancelled" && self.order.status != "packed" && self.order.status != "shipping" {
                Button("CANCEL ORDER") {
                    self.deactivateOrder(orderID: self.order.orderID)
                }
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .background(Rectangle()
                    .fill(Color.red.opacity(0.6))
                    .frame(width: 200, height: 30)
                    .cornerRadius(15)
                )
                .padding(.top, 10)
            }
            
        }
        .padding(.horizontal, 20)
        .toast(message: self.toastMessage,
               isShowing: self.$isShowingToast,
               duration: Toast.long
        )
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
    
    func deactivateOrder(orderID: String) {
        let ref = Database.database().reference()
        
        sendCancelOrder(orderID: orderID) { success in
            guard let success = success, success == true else {
                DispatchQueue.main.async {
                    self.toastMessage = "Error canceling order"
                    self.isShowingToast.toggle()
                }
                return
            }
            
            ref.child("orders").child(orderID).updateChildValues(["status" : "cancelled"])
            
            self.isOrderCancelledSuccessfully = true
        }
    }
    
    func sendCancelOrder(orderID: String, completion: @escaping (Bool?) -> Void) {
        let url = URL(string: MainAPI.url + "/cancel-order")!

        getOrderChargeID(orderID: orderID) { _ in
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try! JSONEncoder().encode([
                "paymentIntentID" : self.paymentIntentID,
            ])
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                guard let _ = data, error == nil,
                      (response as? HTTPURLResponse)?.statusCode == 200 else {
                          completion(nil)
                          return
                      }
                completion(true)
            }.resume()
        }
    }
    
    func getOrderChargeID(orderID: String, completion: @escaping (Bool?) -> Void) {
        let ref = Database.database().reference()
        
        ref.child("orders").child(orderID).observeSingleEvent(of: .value, with: { (snapshot) in
            guard let currentOrder = (snapshot.value as? [AnyHashable : Any]) else {
                completion(nil)
                return
            }
            
            guard let paymentIntentID = (currentOrder["paymentIntentID"] as? String) else {
                completion(nil)
                return
            }

            self.paymentIntentID = paymentIntentID
            completion(true)
        })
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
