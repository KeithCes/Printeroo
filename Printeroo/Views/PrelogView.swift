//
//  PrelogView.swift
//  Printeroo
//
//  Created by Admin on 9/8/22.
//

import Foundation
import SwiftUI

struct PrelogView: View {
    
    @State var isShowingOrderSelection: Bool = false
    @State var isShowingCamera: Bool = false
    
    @StateObject var viewModel = PrelogViewModel()
    
    var body: some View {
        VStack {
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(minWidth: 0, maxWidth: .infinity)
            }
            else {
                Image(systemName: "photo.fill")
                    .resizable()
                    .scaledToFit()
                    .opacity(0.6)
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding(.horizontal)
            }
            Button("CAMERA") {
                self.isShowingCamera = true
            }
            Button("PICTURES") {
                viewModel.source = "library"
                viewModel.showPicker = true
            }
            Button("GO TO ORDER FLOW") {
                self.isShowingOrderSelection = true
            }
        }
        .fullScreenCover(isPresented: $viewModel.showPicker) {
            ImagePicker(sourceType: viewModel.source == "library" ? .photoLibrary : .camera, selectedImage: $viewModel.image)
        }
        .fullScreenCover(isPresented: $isShowingOrderSelection) {
            OrderSelectionView(isShowingOrderSelection: $isShowingOrderSelection)
        }
        .fullScreenCover(isPresented: $isShowingCamera) {
            CameraView(isShowingCamera: $isShowingCamera, selectedImage: $viewModel.image)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(CustomColors.sand)
        .ignoresSafeArea()
    }
}

