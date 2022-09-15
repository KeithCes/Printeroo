//
//  ChangeAddressViewModel.swift
//  Printeroo
//
//  Created by Admin on 9/15/22.
//

import Foundation
import SwiftUI
import FirebaseAuth
import FirebaseDatabase

final class ChangeAddressViewModel: ObservableObject {
    
    @Published var address: String = ""
    @Published var city: String = ""
    @Published var zipcode: String = ""
    @Published var state: String = ""
    @Published var country: String = ""
    
    @Published var isShowingToast: Bool = false
    @Published var toastMessage: String = "Error"
    
    @Published var countryColor: SwiftUI.Color = CustomColors.darkGray.opacity(0.5)
    @Published var stateColor: SwiftUI.Color = CustomColors.darkGray.opacity(0.5)
    
    
    func updateUserValue(userInfo: UserInfo?) {
        let ref = Database.database().reference()
        let userID = Auth.auth().currentUser!.uid
        
        guard let userInfo = userInfo else {
            return
        }
        
        self.updateUserValueStripe(userInfo: userInfo) { _ in
            ref.child("users").child(userID).child("userInfo").updateChildValues([
                "address" : (self.address != "" && self.address.count > 5) ? self.address : userInfo.address,
                "state" : self.state != "" ? self.state : userInfo.state,
                "city" : (self.city != "" && self.city.count > 2) ? self.city : userInfo.city,
                "zipcode" : (self.zipcode != "" && self.zipcode.count == 5) ? self.zipcode : userInfo.zipcode,
                "country" : self.country != "" ? self.country : userInfo.country,
            ])
        }
    }
    
    private func updateUserValueStripe(userInfo: UserInfo?, completion: @escaping (String?) -> Void) {
        let url = URL(string: MainAPI.url + "/update-customer-address")!
        
        guard let userInfo = userInfo else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONEncoder().encode([
            "customerID" : userInfo.stripeCustomerID,
            "addressLine1" : (self.address != "" && self.address.count > 5) ? self.address : userInfo.address,
            "addressCity" : (self.city != "" && self.city.count > 2) ? self.city : userInfo.city,
            "addressCountry" : self.country != "" ? self.country : userInfo.country,
            "addressState": self.state != "" ? self.state : userInfo.state,
            "addressPostalCode" : (self.zipcode != "" && self.zipcode.count == 5) ? self.zipcode : userInfo.zipcode,
        ])
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil,
                  (response as? HTTPURLResponse)?.statusCode == 200,
                  let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any],
                  let customerID = json["customerID"] as? String else {
                      completion(nil)
                      return
                  }
            completion(customerID)
        }.resume()
    }
}
