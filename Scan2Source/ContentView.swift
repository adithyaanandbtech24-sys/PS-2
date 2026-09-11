import SwiftUI

struct ContentView: View {
    @Environment(AppRouter.self) private var router
    @Environment(DataManager.self) private var dataManager
    
    var body: some View {
        Group {
            if router.showWelcome {
                WelcomeView()
            } else {
                NavigationStack(path: Bindable(router).path) {
                    MainTabView()
                        .navigationDestination(for: AppRoute.self) { route in
                            switch route {
                            case .home:
                                HomeView()
                            case .scanProduct:
                                ScanProductView()
                            case .aiAnalysis:
                                AIAnalysisView()
                            case .productResult:
                                ProductResultView()
                            case .requirementsForm:
                                RequirementsFormView()
                            case .requirementSummary:
                                RequirementSummaryView()
                            case .findingMatches:
                                FindingMatchesView()
                            case .supplierResults:
                                SupplierResultsView()
                            case .supplierDetail(let supplierId, let productId):
                                SupplierDetailView(supplierId: supplierId, productId: productId)
                            case .sendEnquiry(let supplierId, let productId):
                                SendEnquiryView(supplierId: supplierId, productId: productId)
                            case .enquirySent(let enquiryId):
                                EnquirySentView(enquiryId: enquiryId)
                            case .myEnquiries:
                                MyEnquiriesView()
                            case .quotationDetail(let enquiryId):
                                QuotationView(enquiryId: enquiryId)
                            case .profile:
                                ProfileView()
                            case .browseCategories:
                                BrowseCategoriesView()
                            case .signIn:
                                SignInView()
                            case .arMaterialScanner:
                                ARMaterialScannerView()
                            case .carbonFootprint(let productId):
                                CarbonFootprintView(productId: productId)
                            }
                        }
                }
            }
        }
    }
}

struct MainTabView: View {
    @Environment(AppRouter.self) private var router
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                .tag(0)
            
            BrowseCategoriesView()
                .tabItem {
                    Image(systemName: "square.grid.2x2.fill")
                    Text("Browse")
                }
                .tag(1)
            
            MyEnquiriesView()
                .tabItem {
                    Image(systemName: "envelope.fill")
                    Text("Enquiries")
                }
                .tag(2)
            
            ProfileView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
                .tag(3)
        }
        .tint(AppTheme.Colors.primary)
    }
}
