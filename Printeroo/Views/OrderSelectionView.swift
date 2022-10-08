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
    
    @Binding var isFromCameraRoll: Bool
    
    @StateObject var viewModel: OrderSelectionViewModel = OrderSelectionViewModel()
    
    var body: some View {
        VStack {
            Button(action: {
                isShowingOrderSelection = false
            }) {
                Image(systemName: "arrow.backward.circle")
                    .resizable()
                    .frame(width: 32, height: 32)
                    .foregroundColor(CustomColors.darkGray)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 20)
            .padding(.top, 50)
            
            ScrollView {
                VStack {
                    HStack {
                        CustomTitleText(labelText: "Die-Cut Stickers", fontSize: 16)
                            .padding(.top, 10)
                            .padding(.leading, 10)
                        Spacer()
                    }
                    ScrollView(.horizontal) {
                        HStack {
                            CheckoutItem(itemID: 401, image: UIImage(named: "Test") ?? UIImage(), price: 5, itemName: "Best Fit", itemType: "Die-Cut", selectedItems: $viewModel.selectedItems, selectedImage: self.$selectedImage)
                        }
                    }
                }
                VStack {
                    HStack {
                        CustomTitleText(labelText: "Sticker Sheet", fontSize: 16)
                            .padding(.top, 10)
                            .padding(.leading, 10)
                        Spacer()
                    }
                    ScrollView(.horizontal) {
                        HStack {
                            CheckoutItem(itemID: 201, image: UIImage(named: "Test") ?? UIImage(), price: 5, itemName: "8.5\"x11\"", itemType: "Sticker Sheet", selectedItems: $viewModel.selectedItems, selectedImage: self.$selectedImage)
                        }
                    }
                }
                VStack {
                    HStack {
                        CustomTitleText(labelText: "Circle Stickers", fontSize: 16)
                            .padding(.top, 10)
                            .padding(.leading, 10)
                        Spacer()
                    }
                    ScrollView(.horizontal) {
                        HStack {
                            CheckoutItem(itemID: 0, image: UIImage(named: "Test") ?? UIImage(), price: 5, itemName: "1\"x1\"", itemType: "Circle Sticker", selectedItems: $viewModel.selectedItems, selectedImage: self.$selectedImage)
                            CheckoutItem(itemID: 1, image: UIImage(named: "Test") ?? UIImage(), price: 3.99, itemName: "2\"x2\"", itemType: "Circle Sticker", selectedItems: $viewModel.selectedItems, selectedImage: self.$selectedImage)
                            CheckoutItem(itemID: 2, image: UIImage(named: "Test") ?? UIImage(), price: 5, itemName: "3\"x3\"", itemType: "Circle Sticker", selectedItems: $viewModel.selectedItems, selectedImage: self.$selectedImage)
                            CheckoutItem(itemID: 3, image: UIImage(named: "Test") ?? UIImage(), price: 3.99, itemName: "4\"x4\"", itemType: "Circle Sticker", selectedItems: $viewModel.selectedItems, selectedImage: self.$selectedImage)
                        }
                    }
                }
                VStack {
                    HStack {
                        CustomTitleText(labelText: "Square Stickers", fontSize: 16)
                            .padding(.top, 10)
                            .padding(.leading, 10)
                        Spacer()
                    }
                    ScrollView(.horizontal) {
                        HStack {
                            CheckoutItem(itemID: 100, image: UIImage(named: "Test") ?? UIImage(), price: 5, itemName: "1\"x1\"", itemType: "Square Sticker", selectedItems: $viewModel.selectedItems, selectedImage: self.$selectedImage)
                            CheckoutItem(itemID: 101, image: UIImage(named: "Test") ?? UIImage(), price: 3.99, itemName: "2\"x2\"", itemType: "Square Sticker", selectedItems: $viewModel.selectedItems, selectedImage: self.$selectedImage)
                            CheckoutItem(itemID: 102, image: UIImage(named: "Test") ?? UIImage(), price: 5, itemName: "3\"x3\"", itemType: "Square Sticker", selectedItems: $viewModel.selectedItems, selectedImage: self.$selectedImage)
                            CheckoutItem(itemID: 103, image: UIImage(named: "Test") ?? UIImage(), price: 3.99, itemName: "4\"x4\"", itemType: "Square Sticker", selectedItems: $viewModel.selectedItems, selectedImage: self.$selectedImage)
                        }
                    }
                }
                VStack {
                    HStack {
                        CustomTitleText(labelText: "Heart Stickers", fontSize: 16)
                            .padding(.top, 10)
                            .padding(.leading, 10)
                        Spacer()
                    }
                    ScrollView(.horizontal) {
                        HStack {
                            CheckoutItem(itemID: 300, image: UIImage(named: "Test") ?? UIImage(), price: 5, itemName: "1\"x1\"", itemType: "Heart Sticker", selectedItems: $viewModel.selectedItems, selectedImage: self.$selectedImage)
                            CheckoutItem(itemID: 301, image: UIImage(named: "Test") ?? UIImage(), price: 3.99, itemName: "2\"x2\"", itemType: "Heart Sticker", selectedItems: $viewModel.selectedItems, selectedImage: self.$selectedImage)
                            CheckoutItem(itemID: 302, image: UIImage(named: "Test") ?? UIImage(), price: 5, itemName: "3\"x3\"", itemType: "Heart Sticker", selectedItems: $viewModel.selectedItems, selectedImage: self.$selectedImage)
                            CheckoutItem(itemID: 303, image: UIImage(named: "Test") ?? UIImage(), price: 3.99, itemName: "4\"x4\"", itemType: "Heart Sticker", selectedItems: $viewModel.selectedItems, selectedImage: self.$selectedImage)
                        }
                    }
                }
                VStack {
                    HStack {
                        CustomTitleText(labelText: "Diamond Stickers", fontSize: 16)
                            .padding(.top, 10)
                            .padding(.leading, 10)
                        Spacer()
                    }
                    ScrollView(.horizontal) {
                        HStack {
                            CheckoutItem(itemID: 500, image: UIImage(named: "Test") ?? UIImage(), price: 5, itemName: "1\"x1\"", itemType: "Diamond Sticker", selectedItems: $viewModel.selectedItems, selectedImage: self.$selectedImage)
                            CheckoutItem(itemID: 501, image: UIImage(named: "Test") ?? UIImage(), price: 3.99, itemName: "2\"x2\"", itemType: "Diamond Sticker", selectedItems: $viewModel.selectedItems, selectedImage: self.$selectedImage)
                            CheckoutItem(itemID: 502, image: UIImage(named: "Test") ?? UIImage(), price: 5, itemName: "3\"x3\"", itemType: "Diamond Sticker", selectedItems: $viewModel.selectedItems, selectedImage: self.$selectedImage)
                            CheckoutItem(itemID: 503, image: UIImage(named: "Test") ?? UIImage(), price: 3.99, itemName: "4\"x4\"", itemType: "Diamond Sticker", selectedItems: $viewModel.selectedItems, selectedImage: self.$selectedImage)
                        }
                    }
                }
            }
            
            .background() {
                Rectangle()
                    .foregroundColor(.white.opacity(0.3))
                    .cornerRadius(10)
            }
            .cornerRadius(10)
            .padding()
            
            Button("CART") {
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
            OrderConfirmView(isShowingOrderConfirm: $viewModel.isShowingOrderConfirm, selectedItems: $viewModel.selectedItems, selectedImage: $selectedImage,
                             isFromCameraRoll: self.$isFromCameraRoll)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(CustomColors.sand)
        .ignoresSafeArea()
    }
}
