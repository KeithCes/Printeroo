//
//  OrderSelectionView.swift
//  Printeroo
//
//  Created by Admin on 9/8/22.
//

import Foundation
import SwiftUI

struct OrderSelectionView: View {
    
    @Binding var isShowingOrderSelection: Bool
    @Binding var selectedImage: UIImage
    
    @StateObject var viewModel: OrderSelectionViewModel = OrderSelectionViewModel()
    
    var body: some View {
        VStack {
            Button(action: {
                isShowingOrderSelection = false
            }) {
                Image(systemName: "x.circle")
                    .resizable()
                    .frame(width: 32, height: 32)
                    .foregroundColor(CustomColors.darkGray)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 30)
            .padding(.top, 50)
            
            ZStack {
                Rectangle()
                    .foregroundColor(.white.opacity(0.1))
                    .frame(width: CustomDimensions.width, height: 250)
                    .cornerRadius(10)
                VStack {
                    CustomTitleText(labelText: "SELECTED PICTURE: ", fontSize: 28)
                        .padding(.top, 10)
                    
                    // TODO: onTap expand image view to full screen so users can preview
                    Image(uiImage: self.selectedImage)
                        .resizable()
                        .cornerRadius(10)
                        .padding(.bottom, 10)
                        .scaledToFit()
                        .frame(width: 100, height: 180)
                }
            }

            
            ScrollView {
                HStack {
                    CheckoutItem(itemID: 0, image: UIImage(named: "SinglePolaroid") ?? UIImage(), price: 5, itemName: "Polaroid", selectedItems: $viewModel.selectedItems)
                    CheckoutItem(itemID: 1, image: UIImage(named: "MultiPolaroid") ?? UIImage(), price: 3.99, itemName: "Polaroid (5)", selectedItems: $viewModel.selectedItems)
                }
                HStack {
                    CheckoutItem(itemID: 2, image: UIImage(named: "GlossPhoto") ?? UIImage(), price: 69, itemName: "Gloss Photo", selectedItems: $viewModel.selectedItems)
                    CheckoutItem(itemID: 3, image: UIImage(named: "GlossPhotoFrame") ?? UIImage(), price: 69.69, itemName: "Framed Gloss Photo", selectedItems: $viewModel.selectedItems)
                }
                HStack {
                    CheckoutItem(itemID: 4, image: UIImage(named: "Mug") ?? UIImage(), price: 15, itemName: "Printed Mug", selectedItems: $viewModel.selectedItems)
                    CheckoutItem(itemID: 5, image: UIImage(named: "Test") ?? UIImage(), price: 0, itemName: "Test", selectedItems: $viewModel.selectedItems)
                }
            }
            .background() {
                Rectangle()
                    .foregroundColor(.white.opacity(0.3))
                    .cornerRadius(10)
            }
            .cornerRadius(10)
            .padding()
            
            Button("ORDER") {
                // TODO: make sure at least one item is slected or hide/disbale button
                viewModel.isShowingOrderConfirm.toggle()
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
        .fullScreenCover(isPresented: $viewModel.isShowingOrderConfirm) {
            OrderConfirmView(isShowingOrderConfirm: $viewModel.isShowingOrderConfirm, selectedItems: $viewModel.selectedItems)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(CustomColors.sand)
        .ignoresSafeArea()
    }
}
