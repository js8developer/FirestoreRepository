# FirestoreService 🔥 (Swift 📦)

Welcome to FirestoreService, a Swift package that provides easy integration with Firestore databases. This package offers CRUD (Create, Read, Update, Delete) operations and document retrieval methods for Firestore collections. It's designed to simplify Firestore interactions in your Swift projects 🤓.

## Features

- Create, Read, Update, and Delete Firestore documents
- Fetch documents with optional pagination support
- Swift 5.5 concurrency support
- Error handling with descriptive error messages

## Installation

You can easily integrate FirestoreService into your project using Swift Package Manager.

1. In Xcode, open your project.
2. Go to "File" > "Swift Packages" > "Add Package Dependency..."
3. Enter the URL of this firestoreService: `https://github.com/js8developer/FirestoreService`
4. Select the package from the search results.
5. Choose the version or branch you want to use.
6. Add the package to your desired target.

## Usage

### Creating a Firestore Document

```swift
import FirestoreService

let firestoreService = FirestoreServiceImpl<YourModel>()

do {
    let model = YourModel(/* initialize your model */)
    let documentID = try await firestoreService.createDocument(model, in: "your-collection")
    print("Document created with ID:", documentID)
} catch {
    print("Error creating document:", error.localizedDescription)
}
```

### Reading a Firestore Document

```swift
import FirestoreService

let firestoreService = FirestoreServiceImpl<YourModel>()

do {
    if let model = try await firestoreService.readDocument(documentID: "your-document-id", from: "your-collection") {
        print("Read document:", model)
    } else {
        print("Document not found.")
    }
} catch {
    print("Error reading document:", error.localizedDescription)
}
```

### Updating a Firestore Document

```swift
import FirestoreService

let firestoreService = FirestoreServiceImpl<YourModel>()

do {
    let updatedModel = YourModel(/* updated values */)
    try await firestoreService.updateDocument(updatedModel, documentID: "your-document-id", in: "your-collection")
    print("Document updated successfully.")
} catch {
    print("Error updating document:", error.localizedDescription)
}
```

### Deleting a Firestore Document

```swift
import FirestoreService

let firestoreService = FirestoreServiceImpl<YourModel>()

do {
    try await firestoreService.deleteDocument(documentID: "your-document-id", from: "your-collection")
    print("Document deleted successfully.")
} catch {
    print("Error deleting document:", error.localizedDescription)
}
```

### Fetching Firestore Documents with Pagination

```swift
import FirestoreService

let firestoreService = FirestoreServiceImpl<YourModel>()

do {
    let limit: Int = 10
    let lastDocument: DocumentSnapshot? = /* provide the last document for pagination */
    let documents = try await firestoreService.fetchDocuments(from: "your-collection", limit: limit, lastDocument: lastDocument)
    print("Fetched documents:", documents)
} catch {
    print("Error fetching documents:", error.localizedDescription)
}
```

### Contribution
Contributions are welcome! If you find a bug or have an enhancement in mind, feel free to create an issue or submit a pull request.

### License
This package is licensed under the MIT License.
