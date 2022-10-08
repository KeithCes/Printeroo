//
//  SelectedImageView.swift
//  Printeroo
//
//  Created by Admin on 10/6/22.
//

import Foundation
import SwiftUI
import Combine

struct SelectedImageView: View {
    
    @StateObject private var viewModel = SelectedImageViewModel()
    
    @Binding var isShowingSelectedImage: Bool
    
    @Binding var selectedImage: UIImage
    @Binding var isFromCameraRoll: Bool
    
    var body: some View {
        VStack {
            Button(action: {
                isShowingSelectedImage = false
            }) {
                Image(systemName: "x.circle")
                    .resizable()
                    .frame(width: 32, height: 32)
                    .foregroundColor(CustomColors.darkGray)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 20)
            .padding(.top, 50)
            
            ZStack {
                Rectangle()
                    .foregroundColor(.white.opacity(0.1))
                    .frame(width: CustomDimensions.width, height: 560)
                    .cornerRadius(10)
                VStack {
                    CustomTitleText(labelText: "SELECTED PICTURE: ", fontSize: 28)
                        .padding(.top, 10)
                    
                    Image(uiImage: self.selectedImage)
                        .resizable()
                        .cornerRadius(10)
                        .padding(.bottom, 10)
                        .scaledToFit()
                        .frame(width: CustomDimensions.width - 20, height: 500)
                }
            }
            .padding(.vertical, 20)
            
            Button("CONTINUE") {
                viewModel.isShowingOrderSelection.toggle()
            }
            .font(.system(size: 30, weight: .bold, design: .rounded))
            .foregroundColor(.white)
            .background(Rectangle()
                .fill(CustomColors.darkGray.opacity(0.6))
                .frame(width: 200, height: 50)
                .cornerRadius(15)
            )
            .padding(.bottom, 50)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(CustomColors.sand)
        .ignoresSafeArea()
        .onAppear {
            viewModel.isFromCameraRoll = self.isFromCameraRoll
            viewModel.selectedImage = self.selectedImage
        }
        .fullScreenCover(isPresented: $viewModel.isShowingOrderSelection) {
            OrderSelectionView(isShowingOrderSelection: $viewModel.isShowingOrderSelection, selectedImage: $viewModel.selectedImage, isFromCameraRoll: $viewModel.isFromCameraRoll)
        }
    }
}
