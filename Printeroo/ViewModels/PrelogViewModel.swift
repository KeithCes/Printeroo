//
//  PrelogViewModel.swift
//  Printeroo
//
//  Created by Admin on 9/10/22.
//

import Foundation
import SwiftUI
import FirebaseAuth
import FirebaseDatabase

final class PrelogViewModel: ObservableObject {
    
    @Published var isShowingLogin: Bool = false
    @Published var isShowingCreate: Bool = false
    @Published var isCreateSuccessful: Bool = false
    @Published var isShowingTutorial: Bool = false
    
    @Published var isLoggedIn: Bool = false
    
    @AppStorage("hasUserSeenTutorial") private var hasUserSeenTutorial: Bool = false
    
    func checkUserLoggedIn() {
        
        // uncomment to log user out
        //try! Auth.auth().signOut()
        
        if Auth.auth().currentUser == nil {
            return
        }
        
        if !UserDefaults.standard.bool(forKey: "hasUserSeenTutorial") {
            self.isShowingTutorial.toggle()
        }
        else {
            self.isLoggedIn.toggle()
        }
    }
}
