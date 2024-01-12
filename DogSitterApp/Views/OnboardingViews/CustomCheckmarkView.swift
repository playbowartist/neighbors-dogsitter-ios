//
//  CustomCheckmarkView.swift
//  DogSitterApp
//
//  Created by Raymond Yu on 9/29/20.
//  Copyright © 2020 PlayBow Neighbors. All rights reserved.
//

import SwiftUI

struct CustomCheckmarkView: View {
    
    let checkmarkColor: Color
    let visible: Bool
    
    var body: some View {
        
        VStack {
            if visible {
                ZStack {
                
                VStack {
                    Circle()
                        .foregroundColor(Color(.systemGray6))
                        .overlay(
                            Circle()
                                .stroke(checkmarkColor, lineWidth: 2.0)
                    )
                }
                .frame(width: 24.0, height: 24.0, alignment: .center)
                .padding(1.0)
                .overlay(
                    RoundedRectangle(cornerRadius: 13.0)
                        .stroke(Color(.systemGray6), lineWidth: 2.0)
                )
                
                Image(systemName: "checkmark")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 10.0, height: 10.0)
                    .foregroundColor(checkmarkColor)
                }
            } else {
                /*@START_MENU_TOKEN@*/EmptyView()/*@END_MENU_TOKEN@*/
            }
        }
    }
}

struct CustomCheckmarkView_Previews: PreviewProvider {
    static var previews: some View {
        CustomCheckmarkView(checkmarkColor: Color(.systemBlue), visible: true)
    }
}
