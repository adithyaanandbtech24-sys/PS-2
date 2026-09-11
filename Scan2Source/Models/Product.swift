import Foundation

struct Product: Codable, Identifiable, Hashable {
    let id: UUID
    var name: String
    var category: PackagingCategory
    var imageName: String
    var description: String
    var material: String
    var capacity: String
    var shape: String
    var closure: String
    var colours: [String]
    var customizationOptions: [CustomizationOption]
    var priceMin: Double
    var priceMax: Double
    var moq: Int
    var supplierId: UUID
    
    /// User-friendly display name (hides technical terms)
    var friendlyName: String {
        "\(capacity) \(closure.lowercased()) \(category.displayName.lowercased())"
    }
    
    init(id: UUID = UUID(), name: String, category: PackagingCategory, imageName: String = "photo",
         description: String, material: String, capacity: String, shape: String, closure: String,
         colours: [String], customizationOptions: [CustomizationOption] = [],
         priceMin: Double, priceMax: Double, moq: Int, supplierId: UUID) {
        self.id = id
        self.name = name
        self.category = category
        self.imageName = imageName
        self.description = description
        self.material = material
        self.capacity = capacity
        self.shape = shape
        self.closure = closure
        self.colours = colours
        self.customizationOptions = customizationOptions
        self.priceMin = priceMin
        self.priceMax = priceMax
        self.moq = moq
        self.supplierId = supplierId
    }
}

enum PackagingCategory: String, Codable, CaseIterable, Hashable {
    case cosmeticBottle = "cosmetic_bottle"
    case pumpBottle = "pump_bottle"
    case sprayBottle = "spray_bottle"
    case jar = "jar"
    case pouch = "pouch"
    case tube = "tube"
    case box = "box"
    case dropper = "dropper"
    case container = "container"
    
    var displayName: String {
        switch self {
        case .cosmeticBottle: return "Cosmetic Bottle"
        case .pumpBottle: return "Pump Bottle"
        case .sprayBottle: return "Spray Bottle"
        case .jar: return "Jar"
        case .pouch: return "Pouch"
        case .tube: return "Tube"
        case .box: return "Box"
        case .dropper: return "Dropper Bottle"
        case .container: return "Container"
        }
    }
    
    var iconName: String {
        switch self {
        case .cosmeticBottle, .pumpBottle, .sprayBottle, .dropper:
            return "waterbottle.fill"
        case .jar, .container:
            return "cylinder.fill"
        case .pouch:
            return "bag.fill"
        case .tube:
            return "capsule.fill"
        case .box:
            return "shippingbox.fill"
        }
    }
    
    var gradientColors: (String, String) {
        switch self {
        case .cosmeticBottle: return ("#10B981", "#059669")
        case .pumpBottle: return ("#0D9488", "#0F766E")
        case .sprayBottle: return ("#6366F1", "#4F46E5")
        case .jar: return ("#F59E0B", "#D97706")
        case .pouch: return ("#EC4899", "#DB2777")
        case .tube: return ("#8B5CF6", "#7C3AED")
        case .box: return ("#EF4444", "#DC2626")
        case .dropper: return ("#14B8A6", "#0D9488")
        case .container: return ("#3B82F6", "#2563EB")
        }
    }
}

enum CustomizationOption: String, Codable, CaseIterable, Hashable {
    case logoPrinting = "logo_printing"
    case customColour = "custom_colour"
    case customShape = "custom_shape"
    case labelPrinting = "label_printing"
    case embossing = "embossing"
    case matteFinish = "matte_finish"
    case glossFinish = "gloss_finish"
    case foilStamping = "foil_stamping"
    case screenPrinting = "screen_printing"
    case uvPrinting = "uv_printing"
    
    var displayName: String {
        switch self {
        case .logoPrinting: return "Logo Printing"
        case .customColour: return "Custom Colour"
        case .customShape: return "Custom Shape"
        case .labelPrinting: return "Label Printing"
        case .embossing: return "Embossing"
        case .matteFinish: return "Matte Finish"
        case .glossFinish: return "Gloss Finish"
        case .foilStamping: return "Foil Stamping"
        case .screenPrinting: return "Screen Printing"
        case .uvPrinting: return "UV Printing"
        }
    }
    
    var iconName: String {
        switch self {
        case .logoPrinting: return "paintbrush.fill"
        case .customColour: return "paintpalette.fill"
        case .customShape: return "cube.fill"
        case .labelPrinting: return "tag.fill"
        case .embossing: return "square.3.layers.3d.down.right"
        case .matteFinish: return "circle.lefthalf.filled"
        case .glossFinish: return "sparkles"
        case .foilStamping: return "star.fill"
        case .screenPrinting: return "printer.fill"
        case .uvPrinting: return "sun.max.fill"
        }
    }
}
