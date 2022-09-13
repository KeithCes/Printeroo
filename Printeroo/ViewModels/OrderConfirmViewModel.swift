//
//  OrderConfirmViewModel.swift
//  Printeroo
//
//  Created by Admin on 9/13/22.
//

import Foundation
import SwiftUI
import Stripe
import FirebaseAuth
import FirebaseDatabase

final class OrderConfirmViewModel: ObservableObject {
    
    @Published var totalCost: Double = 0
    
    @Published var userStripeCustomerID: String = ""
    
    @Published var paymentIntentID: String = ""
    @Published var paymentSheet: PaymentSheet?
    @Published var paymentResult: PaymentSheetResult?
    
    
    func getUserInfo() {
        
        guard let userID = Auth.auth().currentUser?.uid else {
            return
        }
        
        let ref = Database.database().reference()
        
        ref.child("users").child(userID).child("userInfo").observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let snapshotDict = snapshot.value as? [String: Any] else {
                return
            }
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: snapshotDict, options: [])
                let userInfo = try JSONDecoder().decode(UserInfo.self, from: jsonData)
                
                self.userStripeCustomerID = userInfo.stripeCustomerID
                
                self.preparePaymentSheet(completion: { _ in })
            }
            catch let error {
                print(error)
            }

        })
    }
    
    func preparePaymentSheet(completion: @escaping (String?) -> Void) {
        let url = URL(string: MainAPI.url + "/payment-sheet")!
        
        // TODO: calc tax based on location (change 0.0625 to be dynamic)
        let estTax = round(self.totalCost * 0.0625 * 100)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONEncoder().encode([
            "customerID" : self.userStripeCustomerID,
            "totalCost" : "\(Int((self.totalCost * 100) + estTax))"
        ])
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data,
                  error == nil,
                  (response as? HTTPURLResponse)?.statusCode == 200,
                  let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any],
                  let customerId = json["customer"] as? String,
                  let customerEphemeralKeySecret = json["ephemeralKey"] as? String,
                  let intentClientSecret = json["paymentIntent"] as? String,
                  let paymentIntentID = json["paymentIntentID"] as? String,
                  let publishableKey = json["publishableKey"] as? String else {
                completion(nil)
                return
            }
            
            DispatchQueue.main.async {
                self.paymentIntentID = paymentIntentID
            }
            
            STPAPIClient.shared.publishableKey = publishableKey
            // MARK: Create a PaymentSheet instance
            var configuration = PaymentSheet.Configuration()
            configuration.merchantDisplayName = "Printeroo"
            configuration.customer = .init(id: customerId, ephemeralKeySecret: customerEphemeralKeySecret)
            // Set `allowsDelayedPaymentMethods` to true if your business can handle payment
            // methods that complete payment after a delay, like SEPA Debit and Sofort.
            configuration.allowsDelayedPaymentMethods = true
            
            DispatchQueue.main.async {
                self.paymentSheet = PaymentSheet(paymentIntentClientSecret: intentClientSecret, configuration: configuration)
            }
            
            completion(intentClientSecret)
        }.resume()
    }
    
    func onPaymentCompletion(result: PaymentSheetResult) {
        self.paymentResult = result
        
        switch self.paymentResult {
        case .completed:
            print("complete")
        case .failed(let error):
            print("failed: \(error.localizedDescription)")
        case .canceled:
            print("canceled")
        case .none:
            print("none...")
        }
    }
}