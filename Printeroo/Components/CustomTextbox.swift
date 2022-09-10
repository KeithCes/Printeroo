//
//  CustomTextbox.swift
//  Printeroo
//
//  Created by Admin on 9/10/22.
//

import Foundation
import SwiftUI
import Combine

struct CustomTextbox: View {

    @Binding var field: String
    private var placeholderText: String
    private var height: CGFloat
    private var width: CGFloat
    private var charLimit: Int

    init(field: Binding<String>, placeholderText: String, height: CGFloat = 50, width: CGFloat = CustomDimensions.width, charLimit: Int = 20) {
        self._field = field
        self.placeholderText = placeholderText
        self.height = height
        self.width = width
        self.charLimit = charLimit
    }

    var body: some View {
        TextField(self.field, text: self.$field)
            .font(.system(size: 18, weight: .regular, design: .rounded))
            .placeholder(when: self.field.isEmpty) {
                Text(self.placeholderText).foregroundColor(CustomColors.darkGray.opacity(0.5))
            }
            .foregroundColor(CustomColors.darkGray)
            .fixedSize(horizontal: false, vertical: true)
            .multilineTextAlignment(.center)
            .background(Rectangle()
                            .fill(Color.white.opacity(0.5))
                            .frame(width: self.width, height: self.height)
                            .cornerRadius(15))
            .onReceive(Just(self.field)) { _ in limitText(self.charLimit) }
    }
    
    func limitText(_ upper: Int) {
        if self.field.count > upper {
            self.field = String(self.field.prefix(upper))
        }
    }
}
