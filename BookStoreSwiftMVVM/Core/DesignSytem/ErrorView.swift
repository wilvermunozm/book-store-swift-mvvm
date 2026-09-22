//
//  ErrorView.swift
//  BookStoreSwiftMVVM
//
//  Created by Wilver Muñoz on 22/09/26.
//

import SwiftUI

struct ErrorView : View {
    let errorMenssage : String
    
    var body: some View {
        Text(errorMenssage)
    }
}
