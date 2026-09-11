import Foundation

struct Quotation: Codable, Identifiable {
    let id: UUID
    var enquiryId: UUID
    var supplierId: UUID
    var price: Double
    var moq: Int
    var leadTime: String
    var notes: String
    var status: QuotationStatus
    var sampleAvailable: Bool
    var samplePrice: Double?
    var validUntil: Date
    var createdAt: Date
    
    var formattedPrice: String {
        "₹\(String(format: "%.0f", price))"
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: createdAt)
    }
    
    var formattedValidUntil: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: validUntil)
    }
    
    init(id: UUID = UUID(), enquiryId: UUID, supplierId: UUID, price: Double,
         moq: Int, leadTime: String, notes: String = "", status: QuotationStatus = .received,
         sampleAvailable: Bool = true, samplePrice: Double? = nil,
         validUntil: Date = Calendar.current.date(byAdding: .day, value: 15, to: Date())!,
         createdAt: Date = Date()) {
        self.id = id
        self.enquiryId = enquiryId
        self.supplierId = supplierId
        self.price = price
        self.moq = moq
        self.leadTime = leadTime
        self.notes = notes
        self.status = status
        self.sampleAvailable = sampleAvailable
        self.samplePrice = samplePrice
        self.validUntil = validUntil
        self.createdAt = createdAt
    }
}

enum QuotationStatus: String, Codable {
    case received = "received"
    case underReview = "under_review"
    case accepted = "accepted"
    case rejected = "rejected"
    case expired = "expired"
    
    var displayName: String {
        switch self {
        case .received: return "Received"
        case .underReview: return "Under Review"
        case .accepted: return "Accepted"
        case .rejected: return "Rejected"
        case .expired: return "Expired"
        }
    }
}
