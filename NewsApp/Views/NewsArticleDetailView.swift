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
                articleImage
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
        Text(formattedDate)
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
    
    @ViewBuilder
    var articleImage: some View {
        if let imageURL = article.urlToImage,
           let url = URL(string: imageURL) {
            
            AsyncImage(url: url) { phase in
                switch phase {
                    
                case .empty:
                    placeholderImage
                    
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity, minHeight: NewsConstants.Spacing.height)
                        .clipped()
                        .cornerRadius(NewsConstants.Spacing.spacing8)
                    
                case .failure:
                    placeholderImage
                    
                @unknown default:
                    placeholderImage
                }
            }
            
        } else {
            placeholderImage
        }
    }
    
    var placeholderImage: some View {
        ZStack {
            Color.gray.opacity(0.2)
            Image(systemName: NewsConstants.Image.photo)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity,
               minHeight: NewsConstants.Spacing.height)
        .cornerRadius(NewsConstants.Spacing.spacing8)
    }
}

// MARK: - Private helper
private extension NewsArticleDetailView {
    var formattedDate: String {
        guard let publishedAt = article.publishedAt else { return "" }
        
        let isoFormatter = ISO8601DateFormatter()
        
        if let date = isoFormatter.date(from: publishedAt) {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .short
            return formatter.string(from: date)
        }
        
        return publishedAt
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
