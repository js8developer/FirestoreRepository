//
//  FirestoreService.swift
//
//
//  Created by Jason Schneider on 8/24/23.
//

import FirebaseFirestore

/**
 A protocol defining Firestore CRUD operations and document retrieval methods.
 */
@available(iOS 13.0.0, *)
public protocol FirestoreService {
    associatedtype T: Codable
    /**
     Creates a new Firestore document from the provided model in the specified collection.

     - Parameters:
       - model: The model to be stored as a Firestore document.
       - collection: The name of the Firestore collection to store the document in.

     - Returns: The ID of the created document.
     - Throws: A `FirestoreError` in case of an error during document creation.
     */
    func createDocument(_ model: T, documentID: String?, in collection: String) async throws
        -> String

    /**
     Reads a Firestore document by its document ID from the specified collection.

     - Parameters:
       - documentID: The ID of the document to read.
       - collection: The name of the Firestore collection containing the document.

     - Returns: The decoded model representing the document, or nil if not found.
     - Throws: A `FirestoreError` in case of an error during document retrieval.
     */
    func readDocument(documentID: String, from collection: String) async throws -> T?

    /**
     Updates a Firestore document with the provided model in the specified collection.

     - Parameters:
       - model: The updated model to be stored in the document.
       - documentID: The ID of the document to update.
       - collection: The name of the Firestore collection containing the document.

     - Throws: A `FirestoreError` in case of an error during document update.
     */
    func updateDocument(_ model: T, documentID: String, in collection: String) async throws

    /**
     Deletes a Firestore document by its document ID from the specified collection.

     - Parameters:
       - documentID: The ID of the document to delete.
       - collection: The name of the Firestore collection containing the document.

     - Throws: A `FirestoreError` in case of an error during document deletion.
     */
    func deleteDocument(documentID: String, from collection: String) async throws

    /**
     Fetches a batch of Firestore documents from the specified collection with optional pagination.

     - Parameters:
       - collection: The name of the Firestore collection to fetch documents from.
       - limit: The maximum number of documents to fetch (optional).
       - lastDocument: The last fetched document for pagination (optional).

     - Returns: An array of decoded models representing the fetched documents.
     - Throws: A `FirestoreError` in case of an error during document fetching.
     */
    func fetchDocuments(
        from collection: String,
        limit: Int?,
        lastDocument: DocumentSnapshot?
    ) async throws -> [T]
}
