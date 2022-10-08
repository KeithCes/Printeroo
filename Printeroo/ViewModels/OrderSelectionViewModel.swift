//
//  OrderSelectionViewModel.swift
//  Printeroo
//
//  Created by Admin on 9/10/22.
//

import Foundation
import SwiftUI

final class OrderSelectionViewModel: ObservableObject {

    @Published var isShowingOrderConfirm: Bool = false
    @Published var selectedItems: [OrderItem] = []
}
