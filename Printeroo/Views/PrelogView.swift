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
    
    var body: some View {
        VStack {
            Button("TAKE PICTURE") {
                isShowingOrderSelection = true
            }
        }
        .fullScreenCover(isPresented: $isShowingOrderSelection) {
            OrderSelectionView(isShowingOrderSelection: $isShowingOrderSelection)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(CustomColors.sand)
        .ignoresSafeArea()
    }
}

