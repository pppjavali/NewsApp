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
            ArticleImageView(
                urlString: article.urlToImage,
                height: NewsConstants.Spacing.height,
                width: NewsConstants.Spacing.width
            )
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
