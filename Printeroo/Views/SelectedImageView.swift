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
    
    
    var body: some View {
        VStack {
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(CustomColors.sand)
        .ignoresSafeArea()
    }
}
