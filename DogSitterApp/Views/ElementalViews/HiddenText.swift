//
//  HiddenText.swift
//  DogSitterApp
//
//  Created by Raymond Yu on 11/1/20.
//  Copyright © 2020 PlayBow Neighbors. All rights reserved.
//

import SwiftUI

struct HiddenText: View {
    @Binding var text: String
    @State var hidden: Bool = true
    
    var body: some View {
        HStack {
            if hidden {
                SecureField("", text: $text)
                    .frame(width: 150.0)
                    .frame(alignment: .center)
                    .disabled(true)
            } else {
                TextField("", text: $text)
                    .frame(width: 150.0)
                    .frame(alignment: .center)
                    .disabled(true)
            }
        
            Button(action: {
                self.hidden.toggle()
            }) {
                if hidden {
                    SystemImage(name: "eye")
                } else {
                    SystemImage(name: "eye.slash")
                }
            }
        }
    }
}

struct HiddenText_Previews: PreviewProvider {
    static var previews: some View {
        HiddenText(text: .constant("testHiddenText"))
    }
}

