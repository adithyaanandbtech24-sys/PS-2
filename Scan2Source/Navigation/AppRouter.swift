import SwiftUI

// MARK: - App Route Definitions

enum AppRoute: Hashable {
    case home
    case scanProduct
    case aiAnalysis
    case productResult
    case requirementsForm
    case requirementSummary
    case findingMatches
    case supplierResults
    case supplierDetail(supplierId: UUID, productId: UUID)
    case sendEnquiry(supplierId: UUID, productId: UUID)
    case enquirySent(enquiryId: UUID)
    case myEnquiries
    case quotationDetail(enquiryId: UUID)
    case profile
    case browseCategories
    case signIn
}

// MARK: - App Router (Observable Navigation State)

@Observable
class AppRouter {
    var path = NavigationPath()
    var showWelcome: Bool = true
    
    func navigate(to route: AppRoute) {
        path.append(route)
    }
    
    func goBack() {
        if !path.isEmpty {
            path.removeLast()
        }
    }
    
    func goToRoot() {
        path = NavigationPath()
    }
    
    func goHome() {
        path = NavigationPath()
        showWelcome = false
    }
}
