import Foundation

struct Supplier: Codable, Identifiable, Hashable {
    let id: UUID
    var companyName: String
    var location: String
    var rating: Double
    var reviewCount: Int
    var isVerified: Bool
    var isGSTVerified: Bool
    var isUdyamVerified: Bool
    var responseTime: String
    var leadTime: String
    var contactEmail: String
    var contactPhone: String
    var about: String
    var yearEstablished: Int
    var totalProducts: Int
    
    var verificationBadges: [VerificationBadge] {
        var badges: [VerificationBadge] = []
        if isVerified { badges.append(.verified) }
        if isGSTVerified { badges.append(.gstVerified) }
        if isUdyamVerified { badges.append(.udyamVerified) }
        return badges
    }
    
    var ratingStars: String {
        let fullStars = Int(rating)
        let hasHalf = rating - Double(fullStars) >= 0.5
        var stars = String(repeating: "★", count: fullStars)
        if hasHalf { stars += "½" }
        return stars
    }
    
    init(id: UUID = UUID(), companyName: String, location: String, rating: Double = 4.0,
         reviewCount: Int = 0, isVerified: Bool = false, isGSTVerified: Bool = false,
         isUdyamVerified: Bool = false, responseTime: String = "24 hours",
         leadTime: String = "7-10 days", contactEmail: String = "", contactPhone: String = "",
         about: String = "", yearEstablished: Int = 2015, totalProducts: Int = 10) {
        self.id = id
        self.companyName = companyName
        self.location = location
        self.rating = rating
        self.reviewCount = reviewCount
        self.isVerified = isVerified
        self.isGSTVerified = isGSTVerified
        self.isUdyamVerified = isUdyamVerified
        self.responseTime = responseTime
        self.leadTime = leadTime
        self.contactEmail = contactEmail
        self.contactPhone = contactPhone
        self.about = about
        self.yearEstablished = yearEstablished
        self.totalProducts = totalProducts
    }
}

enum VerificationBadge: String, Codable, Hashable {
    case verified = "verified"
    case gstVerified = "gst_verified"
    case udyamVerified = "udyam_verified"
    
    var displayName: String {
        switch self {
        case .verified: return "Verified Supplier"
        case .gstVerified: return "GST Verified"
        case .udyamVerified: return "Udyam Verified"
        }
    }
    
    var iconName: String {
        switch self {
        case .verified: return "checkmark.seal.fill"
        case .gstVerified: return "building.columns.fill"
        case .udyamVerified: return "shield.checkered"
        }
    }
    
    var color: String {
        switch self {
        case .verified: return "#10B981"
        case .gstVerified: return "#3B82F6"
        case .udyamVerified: return "#8B5CF6"
        }
    }
}

struct Review: Codable, Identifiable {
    let id: UUID
    var userName: String
    var rating: Double
    var comment: String
    var date: Date
    
    init(id: UUID = UUID(), userName: String, rating: Double, comment: String, date: Date = Date()) {
        self.id = id
        self.userName = userName
        self.rating = rating
        self.comment = comment
        self.date = date
    }
}
