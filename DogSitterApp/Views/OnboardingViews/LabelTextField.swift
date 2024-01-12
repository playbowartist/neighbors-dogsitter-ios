//
//  LabelTextField.swift
//  DogSitterApp
//
//  Created by Raymond Yu on 7/14/20.
//  Copyright © 2020 PlayBow Neighbors. All rights reserved.
//

import SwiftUI

struct LabelTextField: View {
    
    @Binding var inputText: String
    var label: String
    var placeholder: String
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            Text(label)
                .font(.subheadline)
            TextField(placeholder, text: $inputText)
                .padding(.bottom)
            Divider()
                .padding(.bottom)
        }
        .padding(.horizontal, 20.0)
    }
}


struct LabelTextField_Previews: PreviewProvider {
    static var previews: some View {
        LabelTextField(inputText: .constant(""), label: "Test Label", placeholder: "Test Placeholder")
    }
}
