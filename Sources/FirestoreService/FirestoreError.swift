//
//  FirestoreError.swift
//  
//
//  Created by Jason Schneider on 8/24/23.
//

import Foundation

public enum FirestoreError: Error {
    case documentNotFound
    case decodingError
    case encodingError
    case updateFailed
    case deleteFailed
    case fetchFailed
    case genericError(String)

    var localizedDescription: String {
        switch self {
        case .documentNotFound:
            return "Document not found."
        case .decodingError:
            return "Failed to decode document."
        case .encodingError:
            return "Failed to encode document."
        case .updateFailed:
            return "Document update failed."
        case .deleteFailed:
            return "Document deletion failed."
        case .fetchFailed:
            return "Failed to fetch documents."
        case let .genericError(message):
            return message
        }
    }
}
