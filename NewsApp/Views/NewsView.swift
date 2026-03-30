//
//  ContentView.swift
//  NewsApp
//
//  Created by Praveen on 27/03/26.
//

import SwiftUI
import Combine
import SwiftData

struct NewsView: View {
    @ObservedObject var viewModel: NewsViewModel
    @State private var didSetup = false
    
    var body: some View {
        NavigationStack {
            contentView
                .navigationTitle(NewsConstants.navigationNewsTitle)
                .searchable(
                    text: $viewModel.searchText,
                    placement: .navigationBarDrawer(displayMode: .always)
                )
                .toolbar { refreshButton }
                .onAppear(perform: setup)
        }
    }
}
// MARK: - Private Methods
private extension NewsView {
    func setup() {
        guard !didSetup else { return }
        didSetup = true
        Task {
            await viewModel.fetchNews()
        }
    }
}


// MARK: - Private Views
private extension NewsView {
    @ViewBuilder
    var contentView: some View {
        if viewModel.isLoading {
            ProgressView()
            
        } else if let errorMessage = viewModel.errorMessage {
            errorView(message: errorMessage)
            
        } else if viewModel.filteredArticles.isEmpty {
            emptyView
            
        } else {
            listView
        }
    }
    
    func errorView(message: String) -> some View {
        ContentUnavailableView(
            NewsConstants.someThingWentWrong,
            systemImage: NewsConstants.Image.exclamationmarkTriangle,
            description: Text(message)
        )
    }
    
    var emptyView: some View {
        if viewModel.searchText.isEmpty {
            ContentUnavailableView(
                NewsConstants.noArticles,
                systemImage: NewsConstants.Image.newsPaper,
                description: Text(NewsConstants.noNewsAvailable)
            )
        } else {
            ContentUnavailableView(
                NewsConstants.noResultsFound,
                systemImage: NewsConstants.Image.magnifyingGlass,
                description: Text(NewsConstants.tryDifferentKey)
            )
        }
    }
    
    var listView: some View {
        List(viewModel.filteredArticles) { article in
            NavigationLink {
                NewsArticleDetailView(article: article)
            } label: {
                NewsArticleRowView(article: article)
            }
            .buttonStyle(.plain)
            .listStyle(.plain)
        }
        .tint(.clear)
    }
    
    var refreshButton: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button {
                Task {
                    await viewModel.fetchNews(forceRefresh: true)
                }
            } label: {
                Image(systemName: NewsConstants.Image.arrowClockWise)
            }
        }
    }
}
final class PreviewNewsRepository: NewsRepositoryProtocol {
    func getNews() async throws -> [Article] {
        return [
            Article(
                title: "Preview Title",
                description: "Preview Description",
                url: "https://test.com",
                urlToImage: nil,
                publishedAt: "2024-03-29T12:00:00Z"
            )
        ]
    }

    func saveArticles(_ articles: [Article]) { }

    func loadArticles() -> [Article] {
        return []
    }
}

struct NewsView_Previews: PreviewProvider {
    @MainActor
    static var previews: some View {
        let vm = NewsViewModel(repository: PreviewNewsRepository())
        vm.articles = [
            Article(
                title: "Preview Title",
                description: "Preview Description",
                url: "https://test.com",
                urlToImage: nil,
                publishedAt: "2024-03-29T12:00:00Z"
            )
        ]

        return NewsView(viewModel: vm)
    }
}

