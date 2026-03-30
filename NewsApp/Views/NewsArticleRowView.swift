//
//  NewsArticleView.swift
//  NewsApp
//
//  Created by Praveen on 29/03/26.
//

import SwiftUI

struct NewsArticleRowView: View {
    let article: Article

    var body: some View {
        HStack(alignment: .top, spacing: NewsConstants.Spacing.spacing8) {
            
            articleImage
                .frame(width: NewsConstants.Spacing.width,
                       height: NewsConstants.Spacing.height)
                .clipped()
                .cornerRadius(NewsConstants.Spacing.spacing8)
            textContent
        }
    }
}

private extension NewsArticleRowView {
    
    var textContent: some View {
        VStack(alignment: .leading, spacing: NewsConstants.Spacing.spacing6) {
            Text(article.title)
                .font(.headline)
                .foregroundStyle(.primary)
                .lineLimit(2)
            
            if let description = article.description, !description.isEmpty {
                Text(description)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }
        }
        .padding(.vertical, NewsConstants.Spacing.spacing6)
    }
    
    @ViewBuilder
    var articleImage: some View {
        if let imageURL = article.urlToImage,
           let url = URL(string: imageURL) {
            
            AsyncImage(url: url) { phase in
                switch phase {
                case .success(let image):
                    image.resizable().scaledToFill()
                default:
                    placeholderImage
                }
            }
            
        } else {
            placeholderImage
        }
    }
    @ViewBuilder
    var placeholderImage: some View {
        ZStack {
            Color.gray.opacity(0.2)
            Image(systemName: NewsConstants.Image.photo)
                .foregroundColor(.gray)
        }
        .frame(width: NewsConstants.Spacing.width,
               height: NewsConstants.Spacing.height)
        .cornerRadius(NewsConstants.Spacing.spacing8)
        
    }
}
#Preview {
    NewsArticleRowView(
        article: Article(
            title: "Title",
            description: "Preview description",
            url: "https://example.com",
            urlToImage: nil,
            publishedAt: "2024-03-29T12:00:00Z"))
}
