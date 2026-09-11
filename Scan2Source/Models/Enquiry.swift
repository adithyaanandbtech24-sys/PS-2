import Foundation

struct Enquiry: Codable, Identifiable {
    let id: UUID
    var userId: UUID
    var supplierId: UUID
    var productId: UUID
    var requirementId: UUID
    var message: String
    var status: EnquiryStatus
    var createdAt: Date
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: createdAt)
    }
    
    init(id: UUID = UUID(), userId: UUID, supplierId: UUID, productId: UUID,
         requirementId: UUID, message: String, status: EnquiryStatus = .sent,
         createdAt: Date = Date()) {
        self.id = id
        self.userId = userId
        self.supplierId = supplierId
        self.productId = productId
        self.requirementId = requirementId
        self.message = message
        self.status = status
        self.createdAt = createdAt
    }
    
    /// Generate a pre-filled RFQ message from a requirement
    static func generateMessage(product: Product, requirement: Requirement) -> String {
        var lines: [String] = []
        lines.append("Hi,")
        lines.append("")
        lines.append("I am interested in your \(requirement.detectedProduct.estimatedCapacity) \(requirement.detectedProduct.category.lowercased()).")
        lines.append("")
        lines.append("Quantity: \(requirement.quantity)")
        lines.append("Colour: \(requirement.colour)")
        if !requirement.customizations.isEmpty {
            lines.append("Customization: \(requirement.customizations.map { $0.displayName }.joined(separator: ", "))")
        }
        lines.append("Budget: ₹\(Int(requirement.budgetMin))–₹\(Int(requirement.budgetMax)) per piece")
        lines.append("")
        lines.append("Please share your quotation, sample availability and lead time.")
        lines.append("")
        lines.append("Thank you.")
        return lines.joined(separator: "\n")
    }
}

enum EnquiryStatus: String, Codable, CaseIterable {
    case sent = "sent"
    case viewed = "viewed"
    case replied = "replied"
    case quotationReceived = "quotation_received"
    case accepted = "accepted"
    case closed = "closed"
    
    var displayName: String {
        switch self {
        case .sent: return "Sent"
        case .viewed: return "Viewed"
        case .replied: return "Replied"
        case .quotationReceived: return "Quotation Received"
        case .accepted: return "Accepted"
        case .closed: return "Closed"
        }
    }
    
    var iconName: String {
        switch self {
        case .sent: return "paperplane.fill"
        case .viewed: return "eye.fill"
        case .replied: return "arrowshape.turn.up.left.fill"
        case .quotationReceived: return "doc.text.fill"
        case .accepted: return "checkmark.circle.fill"
        case .closed: return "xmark.circle.fill"
        }
    }
    
    var statusColor: String {
        switch self {
        case .sent: return "#F59E0B"
        case .viewed: return "#3B82F6"
        case .replied: return "#10B981"
        case .quotationReceived: return "#8B5CF6"
        case .accepted: return "#059669"
        case .closed: return "#6B7280"
        }
    }
    
    /// Which tab this status appears under in My Enquiries
    var tab: EnquiryTab {
        switch self {
        case .sent, .viewed: return .active
        case .replied, .quotationReceived: return .replied
        case .accepted, .closed: return .closed
        }
    }
}

enum EnquiryTab: String, CaseIterable {
    case active = "Active"
    case replied = "Replied"
    case closed = "Closed"
}
