//
//  TutorialView.swift
//  Printeroo
//
//  Created by Admin on 9/24/22.
//

import Foundation
import SwiftUI

struct TutorialView: View {
    
    @StateObject var viewModel = TutorialViewModel()
    
    @Binding var isShowingTutorial: Bool
    
    
    var body: some View {
        TabView {
            CustomTitleText(labelText: "Welcome to Printeroo!!!")
            VStack {
                CustomTitleText(labelText: "Start by taking a picture of anything you want", fontSize: 30)
                    .padding(.horizontal, 50)
                
                PlayerView(videoName: "demoTakingPicture")
                    .aspectRatio(contentMode: .fill)
                    .frame(width: CustomDimensions.width, height: 400)
                    .edgesIgnoringSafeArea(.all)
                    .cornerRadius(10)
                    .background(Rectangle()
                        .fill(Color.white.opacity(0.5))
                        .frame(width: CustomDimensions.width)
                        .cornerRadius(15)
                    )
                    .padding(.vertical, 20)
                
                Text("If you take a picture in-app and immediately check-out you'll get a 10% discount!")
                    .padding(.horizontal, 50)
            }
            VStack {
                CustomTitleText(labelText: "Pick which items you want and check out", fontSize: 30)
                    .padding(.horizontal, 50)
                
                PlayerView(videoName: "demoCheckingOut")
                    .aspectRatio(contentMode: .fill)
                    .frame(width: CustomDimensions.width, height: 400)
                    .edgesIgnoringSafeArea(.all)
                    .cornerRadius(10)
                    .background(Rectangle()
                        .fill(Color.white.opacity(0.5))
                        .frame(width: CustomDimensions.width)
                        .cornerRadius(15)
                    )
                    .padding(.vertical, 20)
            }
            VStack {
                CustomTitleText(labelText: "Or feel free to add existing pictures from your camera roll", fontSize: 30)
                    .padding(.horizontal, 50)
                
                PlayerView(videoName: "demoCameraRoll")
                    .aspectRatio(contentMode: .fill)
                    .frame(width: CustomDimensions.width, height: 400)
                    .edgesIgnoringSafeArea(.all)
                    .cornerRadius(10)
                    .background(Rectangle()
                        .fill(Color.white.opacity(0.5))
                        .frame(width: CustomDimensions.width)
                        .cornerRadius(15)
                    )
                    .padding(.vertical, 20)
            }
            VStack {
                CustomTitleText(labelText: "Let's get started!")
                    .padding(.horizontal, 50)
                
                Button("DIVE IN") {
                    UserDefaults.standard.set(true, forKey: "hasUserSeenTutorial")
                    self.isShowingTutorial.toggle()
                }
                .font(.system(size: 30, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .background(Rectangle()
                    .fill(CustomColors.darkGray.opacity(0.6))
                    .frame(width: 200, height: 50)
                    .cornerRadius(15)
                )
                .padding(.all, 50)
            }
        }
        .tabViewStyle(.page)
        .indexViewStyle(.page(backgroundDisplayMode: .always))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(CustomColors.sand)
        .ignoresSafeArea()
    }
}
