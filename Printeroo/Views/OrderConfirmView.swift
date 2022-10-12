//
//  OrderConfirmView.swift
//  Printeroo
//
//  Created by Admin on 9/10/22.
//

import Foundation
import SwiftUI
import Stripe

struct OrderConfirmView: View {
    
    @StateObject var viewModel: OrderConfirmViewModel = OrderConfirmViewModel()
    
    @Binding var isShowingOrderConfirm: Bool
    @Binding var selectedItems: [OrderItem]
    
    @Binding var selectedImage: UIImage
    
    @Binding var isFromCameraRoll: Bool
    
    
    var body: some View {
        VStack {
            
            Button(action: {
                isShowingOrderConfirm = false
            }) {
                Image(systemName: "arrow.backward.circle")
                    .resizable()
                    .frame(width: 32, height: 32)
                    .foregroundColor(CustomColors.darkGray)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 20)
            .padding(.top, 50)
            
            CustomTitleText(labelText: "PLEASE CONFIRM THE FOLLOWING: ")
            CustomTitleText(labelText: "SELECTED ITEMS", fontSize: 24)
                .padding(.top, 20)
            
            ZStack {
                VStack {
                    ForEach(self.selectedItems, id: \.itemID) { item in
                        if let selectedItem = item {
                            HStack {
                                Text(selectedItem.itemName)
                                
                                //remove from cart
                                Button {
                                    guard let index = self.selectedItems.firstIndex(of: item) else {
                                        return
                                    }
                                    selectedItems.remove(at: index)
                                } label: {
                                    Image(systemName: "x.circle")
                                        .resizable()
                                        .frame(width: 15, height: 15)
                                        .foregroundColor(CustomColors.darkGray)
                                        .background(.red.opacity(0.7))
                                        .cornerRadius(15)
                                }
                                
                                Spacer()
                                
                                HStack {
                                    let price = selectedItem.price
                                    let amount = selectedItem.amount
                                    let totalCost = price * Double(amount)
                                    let finalString = "$" + String(format: "%.2f", price) + " x " + String(amount) + " ="
                                    
                                    Text(finalString)
                                    
                                    Spacer()
                                    
                                    Text("$" + String(format: "%.2f", totalCost))
                                }
                                .frame(width: 160)
                                .padding(.leading, 20)
                            }
                        }
                    }
                    
                    if !self.isFromCameraRoll {
                        HStack {
                            Text("Picture Taken in App (10% OFF")
                            Spacer()
                            Text("-$" + String(format: "%.2f", viewModel.pictureTakenInAppDiscount))
                        }
                        .padding(.top, 10)
                    }
                    
                    HStack {
                        Text("Subtotal")
                        Spacer()
                        Text("$" + String(format: "%.2f", viewModel.totalCost))
                    }
                    HStack {
                        Text("Estimated Tax")
                        Spacer()
                        Text("$" + String(format: "%.2f", viewModel.estimatedTax))
                    }
                    .padding(.top, 10)
                    
                    Spacer()
                        .frame(height: 50)
                    
                    HStack {
                        Text("TOTAL COST")
                            .bold()
                        Spacer()
                        Text("$" + String(format: "%.2f", viewModel.totalCost + viewModel.estimatedTax))
                            .bold()
                    }
                }
                .padding(.all, 10)
            }
            .background(Rectangle()
                .foregroundColor(.white.opacity(0.1))
                .cornerRadius(10)
            )
            .padding(.all, 20)
            
            Button("CHANGE SAVED ADDRESS") {
                viewModel.isShowingAddressView.toggle()
            }
            .font(.system(size: 16, weight: .bold, design: .rounded))
            .foregroundColor(.white)
            .background(Rectangle()
                .fill(CustomColors.darkGray.opacity(0.6))
                .frame(width: 275, height: 30)
                .cornerRadius(15)
            )
            .padding(.bottom, 50)
            .sheet(isPresented: $viewModel.isShowingAddressView, onDismiss: {
                viewModel.getUserInfo()
            }) {
                ChangeAddressView(userInfo: $viewModel.userInfo)
            }
            
            Spacer()
            
            VStack {
                if let paymentSheet = viewModel.paymentSheet {
                    PaymentSheet.PaymentButton(
                        paymentSheet: paymentSheet,
                        onCompletion: viewModel.onPaymentCompletion
                    ) {
                        Text("CONFIRM")
                            .font(.system(size: 30, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .background(Rectangle()
                                .fill(CustomColors.darkGray.opacity(0.6))
                                .frame(width: 200, height: 50)
                                .cornerRadius(15)
                            )
                            .padding(.bottom, 50)
                    }
                }
                else {
                    Text("LOADING...")
                        .font(.system(size: 30, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .padding(.bottom, 50)
                }
            }
        }
        .fullScreenCover(isPresented: $viewModel.isOrderComplete) {
            CameraView()
        }
        .onAppear() {
            for item in selectedItems {
                viewModel.totalCost += item.price * Double(item.amount)
                
                let itemName = item.itemName.replacingOccurrences(of: "\"", with: "")
                let itemType = item.itemType.replacingOccurrences(of: " ", with: "").lowercased()
                
                viewModel.itemNamesPictures[itemType + itemName + "_" + item.itemID] = item.editedImage
                viewModel.itemNamesAmounts[itemType + itemName + "_" + item.itemID] = item.amount
                
            }
            
            viewModel.pictureTakenInAppDiscount = viewModel.totalCost * 0.1
            
            viewModel.totalCost -= viewModel.pictureTakenInAppDiscount
            
            // TODO: calc tax based on location (change 0.0625 to be dynamic)
            viewModel.estimatedTax = round(viewModel.totalCost * 0.0625 * 100) / 100
            
            viewModel.getUserInfo()
            viewModel.selectedImage = self.selectedImage
            
            viewModel.isFromCameraRoll = self.isFromCameraRoll
        }
        .onChange(of: self.selectedItems, perform: { _ in
            
            viewModel.totalCost = 0
            viewModel.itemNamesPictures = [:]
            viewModel.itemNamesAmounts = [:]
            
            for item in selectedItems {
                viewModel.totalCost += item.price * Double(item.amount)
                
                let itemName = item.itemName.replacingOccurrences(of: "\"", with: "").replacingOccurrences(of: " ", with: "").lowercased()
                let itemType = item.itemType.replacingOccurrences(of: " ", with: "").lowercased()
                
                viewModel.itemNamesPictures[itemType + itemName + "_" + item.itemID] = item.editedImage
                viewModel.itemNamesAmounts[itemType + itemName + "_" + item.itemID] = item.amount
                
            }
            
            viewModel.pictureTakenInAppDiscount = viewModel.totalCost * 0.1
            
            viewModel.totalCost -= viewModel.pictureTakenInAppDiscount
            
            // TODO: calc tax based on location (change 0.0625 to be dynamic)
            viewModel.estimatedTax = round(viewModel.totalCost * 0.0625 * 100) / 100
            
            viewModel.getUserInfo()
            viewModel.selectedImage = self.selectedImage
            
            viewModel.isFromCameraRoll = self.isFromCameraRoll
        })
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(CustomColors.sand)
        .ignoresSafeArea()
    }
}
