//
//  YourProfileViewModel.swift
//  Printeroo
//
//  Created by Admin on 9/15/22.
//

import Foundation
import SwiftUI
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

final class YourProfileViewModel: ObservableObject {
    
    @Published var firstname: String = ""
    @Published var lastname: String = ""
    @Published var email: String = ""
    @Published var phoneNumber: String = ""
    
    @Published var profileInputImage: UIImage?
    @Published var profileImage: Image = Image("placeholder")
    @Published var profileImageUploaded: Bool = false
    
    @Published var savedCreditCard: String = ""
    
    @Published var isShowingChangePassword: Bool = false
    @Published var isShowingChangeAddress: Bool = false
    @Published var isShowingImagePicker = false
    
    @Published var isProgressViewHidden: Bool = false
    
    @Published var isUserLoggedOut: Bool = false
    
    @Published var isShowingToast: Bool = false
    @Published var toastMessage: String = "Error"
    
    @Published var userInfo: UserInfo?
    
    
    func clearText() {
        self.firstname = ""
        self.lastname = ""
        self.email = ""
        self.phoneNumber = ""
    }
    
    func checkValidEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func getYourProfile() {
        
        guard let userID = Auth.auth().currentUser?.uid else {
            return
        }
        
        let ref = Database.database().reference()
        
        ref.child("users").child(userID).child("userInfo").observeSingleEvent(of: .value, with: { (snapshot) in
            
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
                    
                    self.userInfo = userInfo
                    
                    self.isProgressViewHidden = true
                }
                catch let error {
                    print(error)
                }
            })
        })
    }
    
    func loadImage() {
        guard let inputImage = profileInputImage else { return }
        self.profileImage = Image(uiImage: inputImage)
    }
    
    func updateUserValue() {
        let ref = Database.database().reference()
        let userID = Auth.auth().currentUser!.uid
        
        guard let userInfo = self.userInfo else {
            return
        }
        
        let firstname = (self.firstname != "" && self.firstname.count > 1) ? self.firstname : userInfo.firstName
        let lastname = (self.lastname != "" && self.lastname.count > 1) ? self.lastname : userInfo.lastName
        
        
        
        updateUserValueStripe { _ in
            ref.child("users").child(userID).child("userInfo").updateChildValues([
                "firstName" : firstname,
                "lastName" : lastname,
                "email" : (self.email != "" && self.checkValidEmail(email: self.email)) ? self.email : userInfo.email,
                "phoneNumber" : (self.phoneNumber != "" && (self.phoneNumber.count == 10 || self.phoneNumber.count == 11)) ? self.phoneNumber : userInfo.phoneNumber,
            ])
            self.getYourProfile()
        }
    }
    
    func updateUserValueStripe(completion: @escaping (String?) -> Void) {
        let url = URL(string: MainAPI.url + "/update-customer-info")!
        
        guard let userInfo = self.userInfo else {
            return
        }
        
        let firstname = (self.firstname != "" && self.firstname.count > 1) ? self.firstname : userInfo.firstName
        let lastname = (self.lastname != "" && self.lastname.count > 1) ? self.lastname : userInfo.lastName
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONEncoder().encode([
            "customerID" : userInfo.stripeCustomerID,
            "fullName" : firstname + " " + lastname,
            "email" : (self.email != "" && self.checkValidEmail(email: self.email)) ? self.email : userInfo.email,
            "phoneNumber" : (self.phoneNumber != "" && (self.phoneNumber.count == 10 || self.phoneNumber.count == 11)) ? self.phoneNumber : userInfo.phoneNumber,
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
    
    func logoutUser() {
        try! Auth.auth().signOut()
        self.isUserLoggedOut.toggle()
    }
}
