//
//  ChangePasswordView.swift
//  Printeroo
//
//  Created by Admin on 9/15/22.
//

import Foundation
import SwiftUI
import FirebaseAuth

struct ChangePasswordView: View {
    
    @Environment(\.presentationMode) private var presentationMode
    
    @State private var newPassword: String = ""
    @State private var confirmPassword: String = ""
    
    @State private var isShowingToast: Bool = false
    @State private var toastMessage: String = "Invalid password"
    
    @FocusState private var isNewPasswordFocused: Bool
    @FocusState private var isConfirmPasswordFocused: Bool
    
    
    var body: some View {
        VStack {
            CustomTitleText(labelText: "CHANGE PASSWORD")
                .padding(EdgeInsets(top: 20, leading: 0, bottom: 0, trailing: 0))
            
            VStack {
                CustomSecureTextboxTitleText(field: $newPassword, placeholderText: "-", titleText: "NEW PASSWORD")
                    .padding(EdgeInsets(top: 0, leading: 20, bottom: 21, trailing: 20))
                    .focused($isNewPasswordFocused)
                    .submitLabel(.next)
                    .onSubmit {
                        isConfirmPasswordFocused.toggle()
                    }
                
                CustomSecureTextboxTitleText(field: $confirmPassword, placeholderText: "-", titleText: "CONFIRM PASSWORD")
                    .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                    .focused($isConfirmPasswordFocused)
                    .submitLabel(.done)
                    .onSubmit {
                        if newPassword == confirmPassword {
                            Auth.auth().currentUser?.updatePassword(to: confirmPassword) { error in
                                if error != nil {
                                    // TODO: require user to log in before change password, otherwise can tick error
                                    print(error?.localizedDescription ?? "")
                                    toastMessage = "Error: " + String(error?.localizedDescription ?? "")
                                    isShowingToast.toggle()
                                }
                                else {
                                    presentationMode.wrappedValue.dismiss()
                                }
                            }
                        }
                        else {
                            toastMessage = "Password confirmation must match"
                            isShowingToast.toggle()
                        }
                    }
            }
            .background(Rectangle()
                            .fill(Color.white.opacity(0.5))
                            .frame(width: CustomDimensions.width, height: CustomDimensions.height200)
                            .cornerRadius(15))
            .padding(EdgeInsets(top: 100, leading: 0, bottom: 0, trailing: 0))
        }
        .toast(message: toastMessage,
               isShowing: $isShowingToast,
               duration: Toast.long
        )
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(EdgeInsets(top: 0, leading: 0, bottom: 250, trailing: 0))
        .background(CustomColors.sand)
        .ignoresSafeArea()
    }
}
