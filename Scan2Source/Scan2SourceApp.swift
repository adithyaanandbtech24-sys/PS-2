import SwiftUI

@main
struct Scan2SourceApp: App {
    @State private var router = AppRouter()
    @State private var dataManager = DataManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(router)
                .environment(dataManager)
        }
    }
}
