//
//  CameraView.swift
//  Printeroo
//
//  Created by Admin on 9/9/22.
//

import Foundation
import SwiftUI
import AVFoundation
import Mantis

struct CameraView: View {
    
    @StateObject var viewModel = CameraViewModel()
    
    var body: some View {
        ZStack {
            CameraPreview(viewModel: viewModel).ignoresSafeArea(.all, edges: .all)
            VStack {
                HStack {
                    if viewModel.isTaken && !viewModel.retakeTapped {
                        Button(action: {
                            viewModel.retakeTapped = true
                            viewModel.reTake()
                        }, label: {
                            Image(systemName: "x.circle")
                                .foregroundColor(.white)
                                .padding()
                                .background(CustomColors.sand)
                                .clipShape(Circle())
                        })
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 30)
                    }
                    else {
                        Button(action: {
                            viewModel.isShowingSettings.toggle()
                        }, label: {
                            Image(systemName: "gear")
                                .foregroundColor(.white)
                                .padding()
                                .background(CustomColors.sand)
                                .clipShape(Circle())
                        })
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 30)
                    }
                    
                    Button(action: viewModel.switchCamera, label: {
                        Image(systemName: "arrow.triangle.2.circlepath.camera")
                            .foregroundColor(.white)
                            .padding()
                            .background(CustomColors.sand)
                            .clipShape(Circle())
                    })
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.trailing, 30)
                }
                
                Spacer()
                
                if viewModel.isTaken {
                    Button(action: {viewModel.isShowingEditor.toggle()}, label: {
                        Image(systemName: "crop")
                            .foregroundColor(.white)
                            .padding()
                            .background(CustomColors.sand)
                            .clipShape(Circle())
                    })
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.trailing, 30)
                }
                
                Spacer()
                
                HStack {
                    if viewModel.isTaken {
                        Button(action: {
                            if !viewModel.isSaved {
                                viewModel.savePic()
                            }
                        }, label: {
                            Image(systemName: "square.and.arrow.down")
                                .foregroundColor(.white)
                                .padding()
                                .background(CustomColors.sand)
                                .clipShape(Circle())
                        })
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 30)
                        
                        Button(action: {
                            viewModel.continueWithPic()
                            viewModel.isShowingOrderSelection.toggle()
                        }, label: {
                            Text("Continue →")
                                .foregroundColor(.white)
                                .fontWeight(.semibold)
                                .padding(.vertical, 10)
                                .padding(.horizontal, 20)
                                .background(CustomColors.sand)
                                .clipShape(Capsule())
                        })
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .padding(.trailing, 30)
                    }
                    else {
                        HStack {
                            Button(action: viewModel.takePic, label: {
                                ZStack {
                                    Circle()
                                        .fill(CustomColors.sand)
                                        .frame(width: 40, height: 40)
                                    Circle()
                                        .stroke(CustomColors.sand, lineWidth: 2)
                                        .frame(width: 50, height: 50)
                                }
                            })
                            .padding(.trailing, 20)
                            
                            Button(action: {
                                viewModel.selectedImage = UIImage()
                                viewModel.showPicker.toggle()
                            }, label: {
                                ZStack {
                                    Rectangle()
                                        .fill(CustomColors.sand)
                                        .frame(width: 12, height: 30)
                                        .cornerRadius(1)
                                    Rectangle()
                                        .stroke(CustomColors.sand, lineWidth: 2)
                                        .frame(width: 20, height: 40)
                                        .cornerRadius(1)
                                }
                            })
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.leading, 45)
                    }
                }
            }
        }
        .fullScreenCover(isPresented: $viewModel.showPicker, onDismiss: {
            if viewModel.selectedImage != UIImage() {
                viewModel.isShowingOrderSelection.toggle()
            }
        }) {
            ImagePicker(sourceType: viewModel.source == "library" ? .photoLibrary : .camera, selectedImage: $viewModel.selectedImage)
        }
        .fullScreenCover(isPresented: $viewModel.isShowingOrderSelection, onDismiss: {
            viewModel.selectedImage = UIImage()
        }) {
            OrderSelectionView(isShowingOrderSelection: $viewModel.isShowingOrderSelection, selectedImage: $viewModel.selectedImage)
        }
        .fullScreenCover(isPresented: $viewModel.isShowingEditor, onDismiss: {
            // if editting done successfully
            if viewModel.selectedImage != UIImage() {
                viewModel.isShowingOrderSelection.toggle()
            }
        }) {
            ImageEditor(image: $viewModel.selectedImage, isShowingEditor: $viewModel.isShowingEditor, imageData: $viewModel.picData)
        }
        .fullScreenCover(isPresented: $viewModel.isShowingSettings) {
            YourProfileView(isShowingSettings: $viewModel.isShowingSettings)
        }
        .onAppear(perform: {
            viewModel.checkCameraPermissions()
        })
    }
}
