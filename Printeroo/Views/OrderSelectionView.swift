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
            
            ScrollView {
                HStack {
                    CheckoutItem(itemID: 0, image: selectedImage, price: 5, itemName: "Test1", selectedItems: $viewModel.selectedItems)
                    CheckoutItem(itemID: 1, image: selectedImage, price: 3.99, itemName: "Test2", selectedItems: $viewModel.selectedItems)
                }
                HStack {
                    CheckoutItem(itemID: 2, image: selectedImage, price: 69, itemName: "Test3", selectedItems: $viewModel.selectedItems)
                    CheckoutItem(itemID: 3, image: selectedImage, price: 69.69, itemName: "Test4", selectedItems: $viewModel.selectedItems)
                }
                HStack {
                    CheckoutItem(itemID: 4, image: selectedImage, price: 15, itemName: "Test5", selectedItems: $viewModel.selectedItems)
                    CheckoutItem(itemID: 5, image: selectedImage, price: 0, itemName: "Test6", selectedItems: $viewModel.selectedItems)
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
