import Foundation
import SwiftUI

@Observable
class DataManager {
    var products: [Product] = []
    var suppliers: [Supplier] = []
    var currentUser: User?
    var currentRequirement: Requirement?
    var currentAnalysis: ProductAnalysis?
    var currentMatches: [MatchResult] = []
    var enquiries: [Enquiry] = []
    var quotations: [Quotation] = []
    var savedProducts: [UUID] = []
    var selectedImage: UIImage?
    var selectedCategory: PackagingCategory?
    var browseCategoryFilter: PackagingCategory?
    
    init() {
        self.products = DemoData.products
        self.suppliers = DemoData.suppliers
        
        // Pre-seed 2 demo enquiries
        if let firstProduct = products.first, let firstSupplier = getSupplier(id: firstProduct.supplierId) {
            let req1 = Requirement(detectedProduct: ProductAnalysis.example, category: firstProduct.category, quantity: 500, colour: "White", budgetMin: 10, budgetMax: 20)
            let enq1 = Enquiry(userId: UUID(), supplierId: firstSupplier.id, productId: firstProduct.id, requirementId: req1.id, message: "Hello, please provide a quotation for 500 units.", status: .sent)
            enquiries.append(enq1)
            
            let req2 = Requirement(detectedProduct: ProductAnalysis.example, category: firstProduct.category, quantity: 1000, colour: "Clear", budgetMin: 15, budgetMax: 25)
            let enq2 = Enquiry(userId: UUID(), supplierId: firstSupplier.id, productId: firstProduct.id, requirementId: req2.id, message: "We need 1000 units with custom logo printing.", status: .quotationReceived)
            enquiries.append(enq2)
            
            addDemoQuotation(for: enq2.id)
        }
    }
    
    func getSupplier(id: UUID) -> Supplier? {
        suppliers.first { $0.id == id }
    }
    
    func getProduct(id: UUID) -> Product? {
        products.first { $0.id == id }
    }
    
    func createEnquiry(userId: UUID, supplierId: UUID, productId: UUID, requirementId: UUID, message: String) {
        let enquiry = Enquiry(userId: userId, supplierId: supplierId, productId: productId, requirementId: requirementId, message: message, status: .sent)
        enquiries.append(enquiry)
        
        // Simulate supplier response after 2s
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            if let index = self.enquiries.firstIndex(where: { $0.id == enquiry.id }) {
                self.enquiries[index].status = .quotationReceived
                self.addDemoQuotation(for: enquiry.id)
            }
        }
    }
    
    func addDemoQuotation(for enquiryId: UUID) {
        guard let enquiry = enquiries.first(where: { $0.id == enquiryId }),
              let product = getProduct(id: enquiry.productId) else { return }
        
        let quotation = Quotation(
            enquiryId: enquiryId,
            supplierId: enquiry.supplierId,
            price: product.priceMin + 2.0,
            moq: product.moq,
            leadTime: "10-14 days",
            notes: "Sample available upon request. Freight charges extra."
        )
        quotations.append(quotation)
    }
    
    func getEnquiries(for tab: EnquiryTab) -> [Enquiry] {
        enquiries.filter { $0.status.tab == tab }
    }
    
    func toggleSavedProduct(_ id: UUID) {
        if let index = savedProducts.firstIndex(of: id) {
            savedProducts.remove(at: index)
        } else {
            savedProducts.append(id)
        }
    }
    
    func searchProducts(query: String) -> [Product] {
        if query.isEmpty { return products }
        return products.filter {
            $0.name.localizedCaseInsensitiveContains(query) ||
            $0.category.displayName.localizedCaseInsensitiveContains(query) ||
            $0.material.localizedCaseInsensitiveContains(query)
        }
    }
    
    func getProductsByCategory(_ category: PackagingCategory) -> [Product] {
        products.filter { $0.category == category }
    }
    
    func getQuotation(for enquiryId: UUID) -> Quotation? {
        quotations.first { $0.enquiryId == enquiryId }
    }
    
    func getEnquiry(id enquiryId: UUID) -> Enquiry? {
        enquiries.first { $0.id == enquiryId }
    }
    
    func addEnquiry(_ enquiry: Enquiry) {
        enquiries.append(enquiry)
        // Simulate supplier response
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            if let index = self.enquiries.firstIndex(where: { $0.id == enquiry.id }) {
                self.enquiries[index].status = .quotationReceived
                self.addDemoQuotation(for: enquiry.id)
            }
        }
    }
    
    /// Run matching engine and load matches for a category (used for Browse Categories flow)
    func loadMatchesForCategory(_ category: PackagingCategory) {
        let categoryProducts = getProductsByCategory(category)
        currentMatches = categoryProducts.compactMap { product -> MatchResult? in
            guard let supplier = getSupplier(id: product.supplierId) else { return nil }
            let match = Match(
                requirementId: UUID(),
                productId: product.id,
                visualScore: Double.random(in: 0.7...1.0),
                requirementScore: Double.random(in: 0.6...1.0),
                moqScore: Double.random(in: 0.5...1.0),
                customizationScore: Double.random(in: 0.4...1.0),
                budgetScore: Double.random(in: 0.6...1.0)
            )
            return MatchResult(match: match, product: product, supplier: supplier)
        }.sorted { $0.match.finalScore > $1.match.finalScore }
    }
    
    /// Run matching engine from a full requirement
    func loadMatchesForRequirement(_ requirement: Requirement) {
        currentRequirement = requirement
        let engine = MatchingEngine()
        let raw = engine.findMatches(requirement: requirement, products: products, suppliers: suppliers)
        currentMatches = raw.map { MatchResult(match: $0.match, product: $0.product, supplier: $0.supplier) }
    }
}

/// A simple value type wrapping match + product + supplier together
struct MatchResult: Identifiable {
    let id = UUID()
    let match: Match
    let product: Product
    let supplier: Supplier
}
