//
//  Helper.swift
//  NewsApp
//
//  Created by Praveen on 30/03/26.
//

import Foundation

extension String {
    
    func toFormattedDate() -> String {
        let isoFormatter = ISO8601DateFormatter()
        
        guard let date = isoFormatter.date(from: self) else {
            return self
        }
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        
        return formatter.string(from: date)
    }
}
