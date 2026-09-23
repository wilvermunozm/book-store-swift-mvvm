//
//  BookCoverView.swift
//  BookStoreSwiftMVVM
//
//  Created by Wilver Muñoz on 23/09/26.
//

import SwiftUI
import Kingfisher

struct BookCoverView : View {
    let url : URL?
    var width : CGFloat = 44
    var height : CGFloat = 66

    var body: some View {
        KFImage(url)
            .placeholder { placeholder }
            .retry(maxCount: 2, interval: .seconds(1))
            .fade(duration: 0.2)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: width, height: height)
            .clipShape(.rect(cornerRadius: 4))
    }

    private var placeholder : some View {
        ZStack {
            Color(.secondarySystemFill)
            Image(systemName: "book.closed")
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    HStack(spacing: 16) {
        BookCoverView(url: URL(string: "https://covers.openlibrary.org/b/id/8225261-M.jpg"))
        BookCoverView(url: nil)
    }
}
