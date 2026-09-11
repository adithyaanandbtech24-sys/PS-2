import Foundation

struct DemoData {
    static let supplierIds: [UUID] = (0..<20).map { _ in UUID() }
    
    static let suppliers: [Supplier] = {
        let cities = ["Delhi", "Mumbai", "Ahmedabad", "Noida", "Bengaluru", "Hyderabad", "Pune", "Surat"]
        let prefixes = ["PackWell", "Eco", "Smart", "Green", "Prime", "Apex", "Global", "Indian", "National", "Elite"]
        let suffixes = ["Industries", "Packaging", "Solutions", "Polymers", "Glass Works", "Plastics", "Synthetics", "Box Makers"]
        
        var result: [Supplier] = []
        for i in 0..<20 {
            let city = cities[i % cities.count]
            let prefix = prefixes[i % prefixes.count]
            let suffix = suffixes[i % suffixes.count]
            let name = "\(prefix) \(suffix)"
            let rating = Double.random(in: 3.5...4.9)
            
            let s = Supplier(
                id: supplierIds[i],
                companyName: name,
                location: city,
                rating: rating,
                reviewCount: Int.random(in: 10...500),
                isVerified: Bool.random(),
                isGSTVerified: Bool.random(),
                isUdyamVerified: Bool.random(),
                responseTime: "\(Int.random(in: 1...24)) hours",
                leadTime: "\(Int.random(in: 3...15)) days",
                contactEmail: "contact@\(prefix.lowercased())\(suffix.lowercased().replacingOccurrences(of: " ", with: "")).in",
                contactPhone: "+91 98\(Int.random(in: 10000000...99999999))",
                about: "Leading packaging manufacturer in \(city).",
                yearEstablished: Int.random(in: 1990...2022),
                totalProducts: Int.random(in: 20...1000)
            )
            result.append(s)
        }
        return result
    }()
    
    static let products: [Product] = {
        let categories: [PackagingCategory] = [.cosmeticBottle, .pumpBottle, .sprayBottle, .jar, .pouch, .tube, .box, .dropper, .container]
        let materials = ["PET", "HDPE", "PP", "Glass", "rPET", "ABL", "PBL", "Kraft"]
        let closures = ["Pump", "Spray", "Flip-top", "Screw cap", "Dropper", "Press-on", "Cork"]
        let shapes = ["Cylindrical", "Square", "Oval", "Round", "Rectangular"]
        let colours = ["White", "Clear", "Black", "Amber", "Blue", "Green", "Red", "Custom"]
        
        var result: [Product] = []
        for i in 0..<50 {
            let cat = categories[i % categories.count]
            let mat = materials[i % materials.count]
            let clo = closures[i % closures.count]
            let shp = shapes[i % shapes.count]
            let col = colours[i % colours.count]
            let cap = "\(Int.random(in: 10...1000))\(["ml", "g", "L"].randomElement()!)"
            let priceMin = Double.random(in: 5...40)
            let priceMax = priceMin + Double.random(in: 10...60)
            
            let p = Product(
                name: "Premium \(mat) \(cap) \(cat.displayName)",
                category: cat,
                imageName: cat.iconName,
                description: "High quality \(mat) packaging solution.",
                material: mat,
                capacity: cap,
                shape: shp,
                closure: clo,
                colours: [col, "Custom"],
                customizationOptions: [.logoPrinting, .customColour],
                priceMin: priceMin,
                priceMax: priceMax,
                moq: Int.random(in: 1...50) * 100,
                supplierId: supplierIds[i % 20]
            )
            result.append(p)
        }
        return result
    }()
}
