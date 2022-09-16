//
//  PlacedOrdersView.swift
//  Printeroo
//
//  Created by Admin on 9/16/22.
//

import Foundation
import SwiftUI

struct PlacedOrdersView: View {
    
    @StateObject private var viewModel = PlacedOrdersViewModel()
    
    
    init() {
        UITableView.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        VStack {
            
            CustomTitleText(labelText: "Orders:")
            
            List(viewModel.allOrders, id: \.self) { order in
                VStack {
                    
                    PlacedOrder(order: order)
                    
                    
                }
                .background(Rectangle()
                    .fill(Color.white.opacity(0.5))
                    .overlay(RoundedRectangle(cornerRadius: 15)
                        .stroke(CustomColors.darkGray, lineWidth: 1)
                    )
                    .cornerRadius(15)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                )
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
            }
            .background(Rectangle()
                .fill(Color.white.opacity(0.5))
                .cornerRadius(15)
            )
            .padding(.all, 20)
        }
        .padding(.vertical, 20)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(CustomColors.sand)
        .ignoresSafeArea()
        .onAppear {
            viewModel.getOrders()
        }
    }
}
