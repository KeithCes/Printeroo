//
//  YourProfileView.swift
//  Printeroo
//
//  Created by Admin on 9/15/22.
//

import Foundation
import SwiftUI
import Combine

struct YourProfileView: View {
    
    @StateObject var viewModel = YourProfileViewModel()
    
    @Binding var isShowingSettings: Bool
    
    
    var body: some View {
        VStack {
            Button(action: {
                self.isShowingSettings = false
            }) {
                Image(systemName: "x.circle")
                    .resizable()
                    .frame(width: 32, height: 32)
                    .foregroundColor(CustomColors.darkGray)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 30)
            .padding(.top, 50)
            
            Spacer()
            
            VStack {
                HStack {
                    
                    Spacer()
                    
                    // logout
                    Button(action: {
                        viewModel.logoutUser()
                    }) {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                            .resizable()
                            .frame(width: 32, height: 32)
                            .foregroundColor(CustomColors.darkGray)
                            .background(Rectangle()
                                .fill(Color.white.opacity(0.5))
                                .frame(width: 64, height: 64)
                                .cornerRadius(15))
                    }
                    
                    Spacer()
                    
                    // address
                    Button(action: {
                        viewModel.isShowingChangeAddress.toggle()
                    }) {
                        Image(systemName: "character.book.closed")
                            .resizable()
                            .frame(width: 28, height: 32)
                            .foregroundColor(CustomColors.darkGray)
                            .background(Rectangle()
                                .fill(Color.white.opacity(0.5))
                                .frame(width: 64, height: 64)
                                .cornerRadius(15))
                    }
                    .sheet(isPresented: $viewModel.isShowingChangeAddress, content: {
                        ChangeAddressView(userInfo: $viewModel.userInfo)
                    })
                    
                    Spacer()
                    
                    // password
                    Button(action: {
                        viewModel.isShowingChangePassword.toggle()
                    }) {
                        Image(systemName: "key.fill")
                            .resizable()
                            .frame(width: 17, height: 32)
                            .foregroundColor(CustomColors.darkGray)
                            .background(Rectangle()
                                .fill(Color.white.opacity(0.5))
                                .frame(width: 64, height: 64)
                                .cornerRadius(15))
                    }
                    .sheet(isPresented: $viewModel.isShowingChangePassword, content: {
                        ChangePasswordView()
                    })
                    .fullScreenCover(isPresented: $viewModel.isUserLoggedOut) {
                        PrelogView()
                    }
                    
                    Spacer()
                }
                .padding(.top, 30)
                .padding(.bottom, 30)
                //.padding(.horizontal, 20)
                
                
                CustomTextboxTitleText(field: $viewModel.firstname, placeholderText: viewModel.userInfo?.firstName ?? "", titleText: "FIRST NAME")
                    .padding(EdgeInsets(top: 30, leading: 20, bottom: 20, trailing: 20))
                    .submitLabel(.done)
                    .onSubmit {
                        if viewModel.firstname.count > 1 {
                            viewModel.updateUserValue()
                        }
                        else {
                            viewModel.toastMessage = "Name must be at least 2 characters long"
                            viewModel.isShowingToast.toggle()
                        }
                    }
                
                CustomTextboxTitleText(field: $viewModel.lastname, placeholderText: viewModel.userInfo?.lastName ?? "", titleText: "LAST NAME")
                    .padding(EdgeInsets(top: 0, leading: 20, bottom: 20, trailing: 20))
                    .submitLabel(.done)
                    .onSubmit {
                        if viewModel.lastname.count > 2 {
                            viewModel.updateUserValue()
                        }
                        else {
                            viewModel.toastMessage = "Name must be at least 2 characters long"
                            viewModel.isShowingToast.toggle()
                        }
                    }
                
                CustomTextboxTitleText(field: $viewModel.email, placeholderText: viewModel.userInfo?.email ?? "", charLimit: 30, titleText: "EMAIL")
                    .padding(EdgeInsets(top: 0, leading: 20, bottom: 20, trailing: 20))
                    .submitLabel(.done)
                    .onSubmit {
                        if viewModel.checkValidEmail(email: viewModel.email) {
                            viewModel.updateUserValue()
                        }
                        else {
                            viewModel.toastMessage = "Email is not valid"
                            viewModel.isShowingToast.toggle()
                        }
                    }
                    .textInputAutocapitalization(.never)
                
                CustomTextboxTitleText(field: $viewModel.phoneNumber, placeholderText: viewModel.userInfo?.phoneNumber ?? "", titleText: "PHONE NUMBER")
                    .submitLabel(.done)
                    .onReceive(Just(viewModel.phoneNumber)) { newValue in
                        let filtered = newValue.filter { "0123456789".contains($0) }
                        if filtered != newValue {
                            viewModel.phoneNumber = filtered
                        }
                    }
                    .onSubmit {
                        if viewModel.phoneNumber.count == 10 || viewModel.phoneNumber.count == 11 {
                            viewModel.updateUserValue()
                        }
                        else {
                            viewModel.toastMessage = "Phone Number is not valid"
                            viewModel.isShowingToast.toggle()
                        }
                    }
            }
            .background(Rectangle()
                .fill(Color.white.opacity(0.5))
                .cornerRadius(15)
                .padding(.bottom, -50)
            )
            .overlay(
                ProgressView()
                    .scaleEffect(x: 2, y: 2, anchor: .center)
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height, alignment: .center)
                    .background(RoundedRectangle(cornerRadius: 3)
                        .fill(CustomColors.sand))
                    .progressViewStyle(CircularProgressViewStyle(tint: CustomColors.darkGray))
                    .isHidden(viewModel.isProgressViewHidden)
            )
            .padding(.bottom, 250)
        }
        .toast(message: viewModel.toastMessage,
               isShowing: $viewModel.isShowingToast,
               duration: Toast.long
        )
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(CustomColors.sand)
        .ignoresSafeArea()
        .gesture(DragGesture().onChanged{_ in UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)})
        .onAppear {
            viewModel.clearText()
            viewModel.getYourProfile()
        }
        .onChange(of: viewModel.isShowingChangeAddress) { _ in
            viewModel.getYourProfile()
        }
    }
}
