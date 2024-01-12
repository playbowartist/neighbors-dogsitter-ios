//
//  SelectUserTypeView.swift
//  DogSitterApp
//
//  Created by Raymond Yu on 9/28/20.
//  Copyright © 2020 PlayBow Neighbors. All rights reserved.
//

import SwiftUI

struct UserCardView: View {
    
    var image: String
    var title: String
    var subtitle: String
    var textColor: Color
    var background: Color
    var selected: Bool
    
    var body: some View {
        
        ZStack {
            
            HStack(alignment: .center) {
                VStack {
                    Spacer()
                    Image(image)
                        .renderingMode(.original)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 140)
                        .padding(.leading, 20)
                        .padding(.trailing, 20)
                }
                
                VStack(alignment: .leading) {
                    Text(title)
                        .font(.system(size: 24, weight: .bold, design: .default))
                        .foregroundColor(textColor)
                        .padding(.bottom, 10)
                    Text(subtitle)
                        .font(.system(size: 14, weight: .bold, design: .default))
                        .foregroundColor(textColor)
                }.padding(.trailing, 20)
//                Spacer()
            }
            .frame(minWidth: 200, idealWidth: 300, maxWidth: .infinity, minHeight: 160, idealHeight: 160, maxHeight: 160, alignment: .center)
            .background(background)
            .modifier(CardModifier())
            
            VStack {
                Spacer()
                CustomCheckmarkView(checkmarkColor: background, visible: selected)
//                    .padding(.bottom, 5)
                //                .padding(.top, -45)
            }
            
        }
        .frame(height: 185)
        .padding(20)
    }
}

struct UserCardView_Previews: PreviewProvider {
    static var previews: some View {
        UserCardView(
            image: "clipart1-watermarked-removebg",
            title: "Client",
            subtitle: "Looking for dog sitters",
            textColor: ColorManager.purpleText,
            background: Color(.systemYellow),
            selected: true
        )
    }
}

struct CardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .cornerRadius(20)
        //            .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 0)
    }
    
}
