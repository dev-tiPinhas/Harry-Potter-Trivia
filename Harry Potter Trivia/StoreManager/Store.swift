//
//  Store.swift
//  Harry Potter Trivia
//
//  Created by Tiago Pinheiro on 13/11/2023.
//

import Foundation
import StoreKit

enum BookStatus: Codable {
    case active
    case inactive
    case locked
}

@MainActor
class Store: ObservableObject {
    @Published var books: [BookStatus] = [.active, .active, .inactive, .locked, .locked, .locked, .locked]
    @Published var products: [Product] = []
    @Published var purchasedIDs = Set<String>()
    
    private var productIDs = ["hp4", "hp5", "hp6", "hp7"]
    private var updates: Task<Void, Never>? = nil
    private let savePath = FileManager.documentsDirectory?.appending(path: "SavedBookStatus")
    
    init() {
        updates = watchForUpdates()
    }
    
    // MARK: Public
    
    func loadProducts() async {
        do {
            products = try await Product.products(for: productIDs)
            // The products were not sorted by id
            products.sort { $0.id < $1.id }
        } catch {
            print("Couldn't fetch the products: \(error)")
        }
    }
    
    func purchase(_ product: Product) async {
        do {
            let result = try await product.purchase()
            
            switch result {
            // Purchase successful, but now we have to verify the receipt
            case .success(let verificationResult):
                switch verificationResult {
                case .unverified(let signedType, let verificationError):
                    print("Error on \(signedType): \(verificationError)")
                case .verified(let signedType):
                    purchasedIDs.insert(signedType.productID)
                }
            
            // User cancelled or parent disapproved child's purchase request
            case .userCancelled:
                break
            // Waiting for approval
            case .pending:
                break
            @unknown default:
                break
            }
        } catch {
            print("Couldn't purchase the product: \(error)")
        }
    }
    
    func saveStatus() {
        do {
            guard let savePath else { return }
            
            let data = try JSONEncoder().encode(books)
            try data.write(to: savePath)
        } catch {
            print("Unable to save Data: \(error)")
        }
    }
    
    func loadStatus() {
        do {
            guard let savePath else { return }
            
            let data = try Data(contentsOf: savePath)
            books = try JSONDecoder().decode([BookStatus].self, from: data)
        } catch {
            print("Couldn't load books status: \(error)")
        }
    }
    
    // MARK: Private
    
    private func checkPurchased() async {
        for product in products {
            guard let state = await product.currentEntitlement else { return }
            
            switch state {
            case .unverified(let signedType, let verificationError):
                print("Error on \(signedType): \(verificationError)")
            case .verified(let signedType):
                // Verify if the user did not revoke the purchase
                if signedType.revocationDate == nil {
                    purchasedIDs.insert(signedType.productID)
                } else {
                    purchasedIDs.remove(signedType.productID)
                }
            }
        }
    }
    
    // Update products in case the IAP is made through app Store
    private func watchForUpdates() -> Task<Void, Never> {
        Task(priority: .background) {
            for await _ in Transaction.updates {
                await checkPurchased()
            }
        }
    }
}
