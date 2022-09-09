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
                    CheckoutItem(image: selectedImage, price: 0, itemName: "Test1")
                    CheckoutItem(image: selectedImage, price: 0, itemName: "Test2")
                }
                HStack {
                    CheckoutItem(image: selectedImage, price: 0, itemName: "Test3")
                    CheckoutItem(image: selectedImage, price: 0, itemName: "Test4")
                }
                HStack {
                    CheckoutItem(image: selectedImage, price: 0, itemName: "Test5")
                    CheckoutItem(image: selectedImage, price: 0, itemName: "Test6")
                }
            }
            .background() {
                Rectangle()
                    .foregroundColor(.red.opacity(0.5))
                    .cornerRadius(10)
            }
            .cornerRadius(10)
            .padding()
            
            Button("ORDER") {
                // TODO: transition to confirm order + cc page
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
    }
}
