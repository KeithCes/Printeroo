//
//  PrelogView.swift
//  Printeroo
//
//  Created by Admin on 9/8/22.
//

import Foundation
import SwiftUI
import Combine
import FirebaseAuth

struct PrelogView: View {
    
    @StateObject private var viewModel = PrelogViewModel()
    
    var body: some View {
        VStack {
            if Auth.auth().currentUser == nil {
                Button("LOGIN") {
                    viewModel.isShowingLogin.toggle()
                }
                .padding(EdgeInsets(top: 35, leading: 20, bottom: 35, trailing: 20))
                .font(.system(size: 30, weight: .bold, design: .rounded))
                .foregroundColor(Color.white)
                .background(Rectangle()
                                .fill(CustomColors.darkGray.opacity(0.6))
                                .frame(width: 300, height: 70)
                                .cornerRadius(15))
                
                .sheet(isPresented: $viewModel.isShowingLogin, onDismiss: {
                    viewModel.checkUserLoggedIn()
                }) {
                    LoginView(isShowingLogin: $viewModel.isShowingLogin)
                }
                
                Button("CREATE") {
                    viewModel.isShowingCreate.toggle()
                }
                .padding(EdgeInsets(top: 35, leading: 20, bottom: 35, trailing: 20))
                .font(.system(size: 30, weight: .bold, design: .rounded))
                .foregroundColor(Color.white)
                .background(Rectangle()
                                .fill(CustomColors.darkGray.opacity(0.6))
                                .frame(width: 300, height: 70)
                                .cornerRadius(15))
                
                .sheet(isPresented: $viewModel.isShowingCreate, onDismiss: {
                    viewModel.checkUserLoggedIn()
                }) {
                    CreateAccountView(isShowingCreate: $viewModel.isShowingCreate)
                }
            }
        }
        .onAppear {
            viewModel.checkUserLoggedIn()
        }
        .fullScreenCover(isPresented: $viewModel.isLoggedIn) {
            CameraView()
        }
        .fullScreenCover(isPresented: $viewModel.isShowingTutorial, onDismiss: {
            viewModel.checkUserLoggedIn()
        }) {
            TutorialView(isShowingTutorial: $viewModel.isShowingTutorial)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(CustomColors.sand)
        .ignoresSafeArea()
    }
}


