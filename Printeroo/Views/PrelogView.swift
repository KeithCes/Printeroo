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
    @StateObject var vm = PrelogViewModel()
    
    var body: some View {
        VStack {
            if let image = vm.image {
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
                vm.source = "camera"
                vm.showPicker = true
            }
            Button("PICTURES") {
                vm.source = "library"
                vm.showPicker = true
            }
            Button("GO TO ORDER FLOW") {
                isShowingOrderSelection = true
            }
        }
        .sheet(isPresented: $vm.showPicker) {
            ImagePicker(sourceType: vm.source == "library" ? .photoLibrary : .camera, selectedImage: $vm.image)
        }
        .fullScreenCover(isPresented: $isShowingOrderSelection) {
            OrderSelectionView(isShowingOrderSelection: $isShowingOrderSelection)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(CustomColors.sand)
        .ignoresSafeArea()
    }
}

