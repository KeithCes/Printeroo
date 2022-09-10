//
//  LoginViewModel.swift
//  Printeroo
//
//  Created by Admin on 9/10/22.
//

import Foundation
import FirebaseAuth

final class LoginViewModel: ObservableObject {
    
    @Published var email: String = ""
    @Published var password: String = ""
    
    @Published var isShowingToast: Bool = false
    @Published var toastMessage: String = "Error"
    
    @Published var isShowingLogin: Bool = true
    
    
    func login() {
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if error != nil {
                self.toastMessage = "Error: " + String(error?.localizedDescription ?? "")
                self.isShowingToast.toggle()
                print(error?.localizedDescription ?? "")
            }
            else {
                self.isShowingLogin = false
            }
        }
    }
}
