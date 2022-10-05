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
        
        ref.child("users").child(userID).child("userInfo").updateChildValues([
            "address" : (self.address != "" && self.address.count > 5) ? self.address : userInfo.address,
            "state" : self.state != "" ? self.state : userInfo.state,
            "city" : (self.city != "" && self.city.count > 2) ? self.city : userInfo.city,
            "zipcode" : (self.zipcode != "" && self.zipcode.count == 5) ? self.zipcode : userInfo.zipcode,
            "country" : self.country != "" ? self.country : userInfo.country,
        ])
    }
}
