//
//  FirestoreRepositoryImpl.swift
//  
//
//  Created by Jason Schneider on 8/24/23.
//

import FirebaseFirestore

/**
 An implementation of the FirestoreRepository protocol providing CRUD operations using Firestore database.
 */
@available(iOS 13.0.0, *)
public class FirestoreRepositoryImpl<T: Codable>: FirestoreRepository {
    private let db = Firestore.firestore()

    /**
      Initializes a new instance of FirestoreRepositoryImpl.
      */
    public init() {
        // Add initialization code here (if needed)
    }

    /**
     Creates a new Firestore document from the provided model in the specified collection.

     - Parameters:
       - model: The model to be stored as a Firestore document.
       - collection: The name of the Firestore collection to store the document in.

     - Returns: The ID of the created document.
     - Throws: A `FirestoreError` in case of an error during document creation.
     */
    public func createDocument(
        _ model: T,
        documentID: String? = nil,
        in collection: String
    ) async throws -> String {
        let documentData: [String: Any] = try FirestoreRepositoryImpl.encodeModel(model)
        let documentRef: DocumentReference
        do {
            if let docId = documentID {
                documentRef = db.collection(collection).document(docId)
            } else {
                documentRef = db.collection(collection).document()
            }
            try await documentRef.setData(documentData)
            return documentRef.documentID
        } catch {
            throw FirestoreError
                .genericError("Document creation failed: \(error.localizedDescription)")
        }
    }

    /**
      Reads a Firestore document by its document ID from the specified collection.

      - Parameters:
        - documentID: The ID of the document to read.
        - collection: The name of the Firestore collection containing the document.

      - Returns: The decoded model representing the document, or nil if not found.
      - Throws: A `FirestoreError` in case of an error during document retrieval.
      */
    public func readDocument(documentID: String, from collection: String) async throws -> T? {
        do {
            let documentSnapshot = try await db.collection(collection).document(documentID)
                .getDocument()
            if let documentData = documentSnapshot.data() {
                return try FirestoreRepositoryImpl.decodeModel(from: documentData)
            }
            throw FirestoreError.documentNotFound
        } catch {
            throw FirestoreError
                .genericError("Document reading failed: \(error.localizedDescription)")
        }
    }

    /**
     Updates a Firestore document with the provided model in the specified collection.

     - Parameters:
       - model: The updated model to be stored in the document.
       - documentID: The ID of the document to update.
       - collection: The name of the Firestore collection containing the document.

     - Throws: A `FirestoreError` in case of an error during document update.
     */
    public func updateDocument(
        _ model: T,
        documentID: String,
        in collection: String
    ) async throws {
        let data = try FirestoreRepositoryImpl.encodeModel(model)

        do {
            try await db.collection(collection).document(documentID)
                .setData(data, merge: true)
        } catch {
            throw FirestoreError
                .genericError("Document update failed: \(error.localizedDescription)")
        }
    }

    /**
     Deletes a Firestore document by its document ID from the specified collection.

     - Parameters:
       - documentID: The ID of the document to delete.
       - collection: The name of the Firestore collection containing the document.

     - Throws: A `FirestoreError` in case of an error during document deletion.
     */
    public func deleteDocument(documentID: String, from collection: String) async throws {
        do {
            try await db.collection(collection).document(documentID).delete()
        } catch {
            throw FirestoreError
                .genericError("Document deletion failed: \(error.localizedDescription)")
        }
    }

    /**
     Fetches a batch of Firestore documents from the specified collection with optional pagination.

     - Parameters:
       - collection: The name of the Firestore collection to fetch documents from.
       - limit: The maximum number of documents to fetch (optional).
       - lastDocument: The last fetched document for pagination (optional).

     - Returns: An array of decoded models representing the fetched documents.
     - Throws: A `FirestoreError` in case of an error during document fetching.
     */
    public func fetchDocuments(
        from collection: String,
        limit: Int?,
        lastDocument: DocumentSnapshot?
    ) async throws -> [T] {
        var query = db.collection(collection).limit(to: limit ?? 10)

        if let lastDocument = lastDocument {
            query = query.start(afterDocument: lastDocument)
        }

        do {
            let querySnapshot = try await query.getDocuments()
            return querySnapshot.documents.compactMap { document in
                let data = document.data()
                return try? FirestoreRepositoryImpl.decodeModel(from: data)
            }
        } catch {
            throw FirestoreError
                .genericError("Document fetching failed: \(error.localizedDescription)")
        }
    }

    /**
     Encodes a model object into Firestore data format.

     - Parameters:
       - model: The model to be encoded.

     - Returns: A dictionary containing the encoded Firestore data.
     - Throws: A `FirestoreError.encodingError` if encoding fails.
     */
    private static func encodeModel(_ model: T) throws -> [String: Any] {
        let data = try JSONEncoder().encode(model)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            throw FirestoreError.encodingError
        }
        return dictionary
    }

    /**
     Decodes Firestore data into a model object.

     - Parameters:
       - data: The Firestore data to be decoded.

     - Returns: The decoded model object.
     - Throws: A `FirestoreError.decodingError` if decoding fails.
     */
    private static func decodeModel(from data: [String: Any]) throws -> T {
        let jsonData = try JSONSerialization.data(withJSONObject: data, options: [])
        return try JSONDecoder().decode(T.self, from: jsonData)
    }
}
