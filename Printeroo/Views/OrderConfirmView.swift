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
    @Binding var selectedItems: [Int: [String: Any]]
    
    
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
            .padding(.leading, 30)
            .padding(.top, 50)
            
            CustomTitleText(labelText: "PLEASE CONFIRM THE FOLLOWING: ")
            CustomTitleText(labelText: "SELECTED ITEMS", fontSize: 24)
                .padding(.top, 20)
            
            // this is terrible please change this to by dynamic and not just 100x
            ZStack {
                Rectangle()
                    .foregroundColor(.white.opacity(0.1))
                    .frame(width: CustomDimensions.width, height: 100 + CGFloat((selectedItems.count * 12)))
                    .cornerRadius(10)
                VStack {
                    ForEach(0..<100) { itemNumber in
                        if let selectedItem = selectedItems[itemNumber] {
                            HStack {
                                Text(selectedItem["itemName"] as! String)
                                Text("$" + String(format: "%.2f", selectedItem["price"] as! Double))
                            }
                        }
                    }
                    // TODO: calc tax based on location (change 0.0625 to be dynamic)
                    HStack {
                        Text("Estimated Tax")
                            .bold()
                        Text("$" + String(format: "%.2f", round(viewModel.totalCost * 0.0625)))
                            .bold()
                    }
                    HStack {
                        Text("TOTAL COST")
                            .bold()
                        Text("$" + String(format: "%.2f", viewModel.totalCost))
                            .bold()
                    }
                }
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
            for item in selectedItems.values {
                viewModel.totalCost += item["price"] as! Double
                viewModel.itemNames.append(item["itemName"] as! String)
            }
            viewModel.getUserInfo()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(CustomColors.sand)
        .ignoresSafeArea()
    }
}
