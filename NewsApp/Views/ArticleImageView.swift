//
//  ArticleImageView.swift
//  NewsApp
//
//  Created by Praveen on 30/03/26.
//

import SwiftUI

struct ArticleImageView: View {
    let urlString: String?
    let height: CGFloat?
    let width: CGFloat?
    
    var body: some View {
        Group {
            if let urlString,
               let url = URL(string: urlString) {
                
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                        
                    default:
                        placeholder
                    }
                }
                
            } else {
                placeholder
            }
        }
        .frame(width: width, height: height)
        
        .clipped()
        .cornerRadius(NewsConstants.Spacing.spacing8)
    }
}

private extension ArticleImageView {
    
    var placeholder: some View {
        ZStack {
            Color.gray.opacity(0.2)
            Image(systemName: NewsConstants.Image.photo)
                .foregroundColor(.gray)
        }
    }
}

#Preview {
    ArticleImageView(urlString: "https://example.com/image.jpg", height: 120, width: 120)
}
