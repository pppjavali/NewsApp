//
//  NewsAppApp.swift
//  NewsApp
//
//  Created by Praveen on 27/03/26.
//

import SwiftUI
import SwiftData

@main
struct NewsAppApp: App {
    
    // Create container
    private let container: ModelContainer
    
    init() {
        do {
            container = try ModelContainer(for: ArticleEntity.self)
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            
            // Inject context into repository
            let context = container.mainContext
            
            let repository = NewsRepository(
                apiService: APIService(),
                context: context
            )
            
            let viewModel = NewsViewModel(repository: repository)
            
            NewsView(viewModel: viewModel)
        }
        .modelContainer(container)
    }
}
