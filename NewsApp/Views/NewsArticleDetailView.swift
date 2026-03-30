//
//  NewsArticleDetailView.swift
//  NewsApp
//
//  Created by Praveen on 29/03/26.
//

import SwiftUI

struct NewsArticleDetailView: View {
    let article: Article
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: NewsConstants.Spacing.spacing12) {
                ArticleImageView(urlString: article.urlToImage,
                                 height: nil,
                                 width: nil)
                .scaledToFit()
                .frame(maxWidth: .infinity, minHeight: NewsConstants.Spacing.height)
                titleView
                descriptionView
                dateView
                linkView
            }
            .padding()
        }
        .navigationTitle(NewsConstants.navigationDetailsTitle)
        .navigationBarTitleDisplayMode(.inline)
    }
}

//MARK: - Private Views
private extension NewsArticleDetailView {
    var titleView: some View {
        Text(article.title)
            .font(.title2)
            .fontWeight(.semibold)
    }
    
    @ViewBuilder
    var descriptionView: some View {
        if let description = article.description, !description.isEmpty {
            Text(description)
                .font(.body)
                .lineSpacing(4)
        }
    }
    
    var dateView: some View {
        Text(article.publishedAt?.toFormattedDate() ?? "")
            .font(.footnote)
            .foregroundStyle(.secondary)
    }
    
    var articleLink: URL? {
        guard let urlString = article.url,
              let url = URL(string: urlString) else {
            return nil
        }
        return url
    }
    
    @ViewBuilder
    var linkView: some View {
        if let url = articleLink {
            Link(NewsConstants.readFullArticle, destination: url)
                .font(.headline)
        }
    }
}

#Preview {
    NewsArticleDetailView(
        article:
            Article(title: "Title",
                    description: "Preview description",
                    url: "https://example.com",
                    urlToImage: nil,
                    publishedAt: "2024-03-29T12:00:00Z"))
}
