import Foundation

struct User: Codable, Identifiable {
    let id: UUID
    var name: String
    var email: String
    var password: String
    var createdAt: Date
    
    init(id: UUID = UUID(), name: String, email: String, password: String, createdAt: Date = Date()) {
        self.id = id
        self.name = name
        self.email = email
        self.password = password
        self.createdAt = createdAt
    }
}
