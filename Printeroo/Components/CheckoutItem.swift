//
//  CheckoutItem.swift
//  Printeroo
//
//  Created by Admin on 9/8/22.
//

import Foundation
import SwiftUI
import Mantis

struct CheckoutItem: View {
    
    private var itemID: Int
    private var image: UIImage
    private var price: Double
    private var itemName: String
    private var itemType: String
    
    private var imageWidth: CGFloat
    private var imageHeight: CGFloat
    private var viewWidth: CGFloat
    private var viewHeight: CGFloat
    
    @State var isShowingEditor: Bool = false
    @State var isShowingCart: Bool = false
    @State var isShowingDieCut: Bool = false
    
    @State var croppedImage: UIImage = UIImage()
    @State var cropStyle: CropShapeType = CropShapeType.circle(maskOnly: false)
    
    @Binding var selectedItems: [OrderItem]
    @Binding var selectedImage: UIImage
    
    
    init(itemID: Int, image: UIImage, price: Double, itemName: String, itemType: String, selectedItems: Binding<[OrderItem]>, selectedImage: Binding<UIImage>) {
        self.itemID = itemID
        self.image = image
        self.price = price
        self.itemName = itemName
        self.itemType = itemType
        self._selectedItems = selectedItems
        self._selectedImage = selectedImage
        
        self.viewWidth = 142
        self.viewHeight = self.viewWidth
        self.imageWidth = self.viewWidth - 22
        self.imageHeight = self.viewHeight - 48
    }
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.white.opacity(0.3))
                .frame(width: self.viewWidth, height: self.viewHeight)
                .cornerRadius(10)
            Image(uiImage: self.image)
                .resizable()
                .frame(width: self.imageWidth, height: self.imageHeight)
                .cornerRadius(10)
                .padding(.bottom, 20)
            VStack {
                HStack {
                    Spacer()
                    ZStack {
                        Rectangle()
                            .foregroundColor(CustomColors.sand.opacity(0.8))
                            .cornerRadius(10)
                        Text("$" + String(format: "%.2f", self.price))
                            .foregroundColor(.white)
                            .fontWeight(.semibold)
                    }
                    .frame(width: 63, height: 42)
                    .padding(.trailing, 11)
                    .padding(.top, 14)
                }
                Spacer()
                ZStack {
                    Rectangle()
                        .foregroundColor(.white.opacity(0.3))
                        .cornerRadius(10)
                    Text(self.itemName)
                        .foregroundColor(CustomColors.darkGray)
                        .fontWeight(.semibold)
                }
                .frame(width: self.viewWidth, height: 34)
            }
            
        }
        .sheet(isPresented: self.$isShowingCart, onDismiss: {
            self.croppedImage = UIImage()
        }) {
            AddToCartEditView(itemID: self.itemID, price: self.price, itemName: self.itemName, itemType: self.itemType, isShowingCart: self.$isShowingCart, selectedItems: self.$selectedItems, edittedImage: self.$croppedImage)
        }
        .sheet(isPresented: self.$isShowingDieCut, onDismiss: {
            self.croppedImage = UIImage()
        }) {
            AddToCartDieCutView(itemID: self.itemID, price: self.price, itemName: self.itemName, itemType: self.itemType, isShowingDieCut: self.$isShowingDieCut, selectedItems: self.$selectedItems, selectedImage: self.$selectedImage)
        }
        .fullScreenCover(isPresented: self.$isShowingEditor, onDismiss: {
            
            // if editting done successfully
            
            if self.itemType == "Circle Sticker" || self.itemType == "Square Sticker" || self.itemType == "Diamond Sticker" || self.itemType == "Heart Sticker" {
                
                if self.croppedImage != UIImage() {
                    self.isShowingCart.toggle()
                }
            }
        }) {
            ImageEditor(image: self.$croppedImage, isShowingEditor: self.$isShowingEditor, selectedImage: self.$selectedImage, cropStyle: self.$cropStyle)
        }
        .onTapGesture {
            if self.itemType == "Circle Sticker" {
                self.cropStyle = CropShapeType.circle(maskOnly: false)
                self.isShowingEditor.toggle()
            }
            else if self.itemType == "Square Sticker" {
                self.cropStyle = CropShapeType.square
                self.isShowingEditor.toggle()
            }
            else if self.itemType == "Diamond Sticker" {
                self.cropStyle = CropShapeType.diamond(maskOnly: false)
                self.isShowingEditor.toggle()
            }
            else if self.itemType == "Heart Sticker" {
                self.cropStyle = CropShapeType.heart(maskOnly: false)
                self.isShowingEditor.toggle()
            }
            else if self.itemType == "Die-Cut Sticker" {
                self.isShowingDieCut.toggle()
            }
        }
    }
}
