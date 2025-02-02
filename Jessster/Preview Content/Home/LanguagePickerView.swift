//
//  LanguagePickerView.swift
//  Jessster
//
//  Created by TEST on 11.01.2025.
//

import SwiftUI

struct LanguagePickerView: View {
    @Binding var selectedLanguage: String // Binding to the parent view's selected language
    @Environment(\.colorScheme) var colorScheme // Detect current color scheme
    
    var body: some View {
        Picker("Select Language", selection: $selectedLanguage) {
            Text("English").tag("en")
            Text("Русский").tag("ru")
            Text("عربي").tag("ar")
        }
        .pickerStyle(SegmentedPickerStyle())
        .padding()
    }
}

struct LanguagePickerView_Previews: PreviewProvider {
    static var previews: some View {
        LanguagePickerView(selectedLanguage: .constant("en"))
    }
}


    
            
