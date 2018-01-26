//
//  MenuItem.swift
//  DiningMenus
//
//  Created by Maxim Aleksa on 3/13/17.
//  Copyright © 2017 Maxim Aleksa. All rights reserved.
//

import Foundation


// MARK: - MenuItem class

/**
 This class represents a single menu item (e.g. Mac and Cheese).
 */
public class MenuItem: NSObject, NSCoding {

    // MARK: Nested Types

    /**
     This enumeration specifies possible traits of the menu item.
    */
    public enum Trait: String {

        // MARK: Enumeration Cases

        /// Marks a menu item as gluten-free.
        case glutenFree = "Gluten-Free"
        /// Marks a menu item as halal.
        case halal = "Halal"
        /// Marks a menu item as spicy.
        case spicy = "Spicy"
        /// Marks a menu item as MHealthy.
        case mHealthy = "MHealthy"
        /// Marks a menu item as vegan.
        case vegan = "Vegan"
        /// Marks a menu item as vegetarian.
        case vegetarian = "Vegetarian"
    }

    /**
     This struct represents a single nutrition fact.
    */
    public struct NutritionFact: CustomStringConvertible {

        // MARK: Instance Properties

        /// Unique identifier of the nutrition fact.
        public internal(set) var id: String = "?"

        /// Name of the nutrition fact.
        public var name: String {
            get {
                return NutritionFact.nutritionFactNames[id] ?? "?"
            }
        }

        /**
         Percent daily value.

         - note: Calories from Fat does not have a percent daily value,
         so `percentDV` is `nil` in that case.
        */
        public internal(set) var percentDV: Int?

        /// Actual amount (in mg, kcal, etc.).
        public internal(set) var amount: Int = 0

        /// Unit corresponding to `amount`.
        public internal(set) var unit: String = "?"

        /// String that combines `amount` and `unit`.
        public var value: String {
            get {
                return "\(amount)\(unit)"
            }
        }
        /// Order in which this nutrition fact should appear on a nutrition label.
        public var order: Int {
            get {
                return NutritionFact.nutritionFactOrder[id] ?? 100
            }
        }
        /// A string representation of the nutrition fact that contains its name,
        /// amount and percent daily value.
        public var description: String {
            var result = "\(name): \(value)"
            if percentDV != nil {
                result += " (\(percentDV!)%)"
            }
            return result
        }

        /// A dictionary that maps IDs of nutrition facts to their names.
        static let nutritionFactNames = [
            "kcal": "Calories",
            "kj": "Calories from Fat",
            "fat": "Total Fat",
            "fatrn": "Trans Fat",
            "sfa": "Saturated Fat",
            "chol": "Cholesterol",
            "na": "Sodium",
            "cho": "Carbohydrates",
            "tdfb": "Dietary Fiber",
            "sugar": "Sugar",
            "pro": "Protein",
            "vtaiu": "Vitamin A",
            "vitc": "Vitamin C",
            "nia": "Niacin",
            "b1": "Vitamin B1",
            "b2": "Vitamin B2",
            "b6": "Vitamin B6",
            "fol": "Folate",
            "b12": "Vitamin B12",
            "vite": "Vitamin E",
            "ca": "Calcium",
            "fe": "Iron",
            "mg": "Magnesium",
            "zn": "Zinc"
        ]

        /// A dictionary that maps IDs to their order in the nutionFactsArray.
        private static let nutritionFactOrder = [
            "kcal": 0,
            "kj": 1,
            "fat": 2,
            "fatrn": 3,
            "sfa": 4,
            "chol": 5,
            "na": 6,
            "cho": 7,
            "tdfb": 8,
            "sugar": 9,
            "pro": 10,
            "vtaiu": 11,
            "vitc": 12,
            "nia": 13,
            "b1": 14,
            "b2": 15,
            "b6": 16,
            "fol": 17,
            "b12": 18,
            "vite": 19,
            "ca": 20,
            "fe": 21,
            "mg": 22,
            "zn": 23
        ]
    }
    
    // MARK: Custom Properties
    // Day meal is served on
    public var day: String?
    
    // Dining Location for meal as a string
    public var diningLocationName: String?
    
    // Meal it is part of
    public var meal: String?
    


    // MARK: Instance Properties

    /// Name of the menu item (e.g., `"Mac and Cheese"`).
    public let name: String

    /**
     Optional string representing the URL of the image of this menu item, if available.

     - note: Most menu items do not have an image, but many menu items in the cafes do.
    */
    public let imageURL: String?

    /// Traits of the menu item.
    public let traits: [Trait]
    /**
     Optional string representing information about the menu item,
     such as its ingerients or its description.

     - note: Menu items in the dining halls generally do not have this information,
     while many items in the cafes do.
    */

    public let infoLabel: String?
    /**
     Array of strings that represent the allergens of this menu item.

     These are some possible allergens that a menu item can have:

     * eggs
     * fish
     * milk
     * oats
     * peanuts
     * pork
     * sesame seed
     * shellfish
     * soy
     * tree nuts
     * wheat/barley/rye
    */
    public let allergens: [String]

    /// Array of special markers, such as deep-fried.
    public let markers: [String]

    /**
     Optional string describing the serving size (e.g., `"1 slice"`).
     Some menu items do not provide information about the serving size,
     in which case `servingSize` will be `nil`.
    */
    public let servingSize: String?

    /**
     Optional integer describing the serving size in grams.
     Some menu items do not provide information about the serving size in grams,
     in which case `servingSizeInGrams` will be `nil`.
    */
    public let servingSizeInGrams: Int?

    /**
     Optional selling price of the menu item.
     `price` is `nil` if price information is not available for this menu item.

     - note: The price is usually only available for menu items sold
     in cafes and markets.
    */
    public let price: Double?

    /**
     Dictionary that maps from IDs of nutrition facts to actual nutrition
     facts for this menu item.
     Contains the same information as `nutritionInfoArray` array.

     - note: This dictionary may be empty for some menu items.
    */
    public let nutritionInfoDict: [String: NutritionFact]

    /**
     Array that lists nutrition facts for this menu item.
     Contains the same information as `nutritionInfoDict` dictionary.

     - note: This array may be empty for some menu items.
     */

    public var nutritionInfoArray: [NutritionFact] {
        get {
            let unsortedArray = nutritionInfoDict.map { $1 }
            return unsortedArray.sorted { return $0.order < $1.order }
        }
    }

    /// A string representation of the menu item object, same as `name`.
    public override var description: String {
        return self.name
    }


    // Initializers

    init?(json: JSON) {

        guard let name = json["name"].string, let servingSize = json["itemsize"]["serving_size"].string, let jsonNutrition = json["itemsize"]["nutrition"].dictionary else {
            return nil
        }

        self.name = name.trimmingCharacters(in: CharacterSet.whitespaces)

        var imageURL: String? = nil
        if let imageName = json["prd_image"].string?.components(separatedBy: ".jpg").first {
            imageURL = "http://dining.umich.edu/wp-content/uploads/mdining-cache/retail-thumbnails/\(imageName)-330x220.jpg"
        }
        self.imageURL = imageURL

        var traits = [Trait]()
        if let jsonTraits = json["trait"].dictionary {
            for (_, traitName) in jsonTraits {
                switch traitName {

                case "glutenfree":
                    traits.append(Trait.glutenFree)
                case "halal":
                    traits.append(Trait.halal)
                case "spicy":
                    traits.append(Trait.spicy)
                case "mhealthy":
                    traits.append(Trait.mHealthy)
                case "vegan":
                    traits.append(Trait.vegan)
                case "vegetarian":
                    traits.append(Trait.vegetarian)
                default:
                    break
                }
            }
        }
        self.traits = traits

        self.infoLabel = json["description"].string

        var allergens = [String]()
        if let jsonAllergens = json["itemsize"]["allergens"].dictionary {
            for (_, jsonAllergen) in jsonAllergens {
                if let allergen = jsonAllergen.string {
                    allergens.append(allergen)
                }
            }
        }
        self.allergens = allergens

        var markers = [String]()
        if let jsonMarkers = json["marker"].dictionary {
            for (_, jsonMarker) in jsonMarkers {
                if let marker = jsonMarker.string {
                    markers.append(marker)
                }
            }
        }
        self.markers = markers

        if servingSize != "TITLE" {
            self.servingSize = servingSize
        } else {
            self.servingSize = nil
        }
        if let gramsString = json["itemsize"]["portion_size"].string {
            self.servingSizeInGrams = Int(gramsString)
        } else {
            self.servingSizeInGrams = nil
        }

        if let priceString = json["itemsize"]["sell_price"].string {
            self.price = Double(priceString)
        } else {
            self.price = nil
        }

        var nutritionInfoDict = [String : NutritionFact]()
        for (nutritionKey, jsonValue) in jsonNutrition {
            var nutritionID = nutritionKey
            if nutritionKey.hasSuffix("_p") {
                nutritionID = nutritionKey.components(separatedBy: "_").first!
            }
            // check if expected
            if NutritionFact.nutritionFactNames[nutritionID] != nil {
                // check if not yet added
                if nutritionInfoDict[nutritionID] == nil {
                    nutritionInfoDict[nutritionID] = NutritionFact()
                    nutritionInfoDict[nutritionID]!.id = nutritionID
                }
                // add values
                if nutritionKey.hasSuffix("_p") {
                    // percentage
                    nutritionInfoDict[nutritionID]!.percentDV = Int(jsonValue.string!)!
                } else {
                    // actual amount
                    let stringAmount = jsonValue.string!
                    let unit = stringAmount.components(separatedBy: CharacterSet.decimalDigits).last!
                    let amount = Int(stringAmount.components(separatedBy: unit).first!)!
                    nutritionInfoDict[nutritionID]!.unit = MenuItem.unitOverrides[unit] ?? unit
                    nutritionInfoDict[nutritionID]!.amount = amount
                }
            }
        }
        self.nutritionInfoDict = nutritionInfoDict

        super.init()
    }

    /// A dictionary used to override units from the API.
    private static let unitOverrides = [
        "gm": "g",
        "": "kcal"
    ]


    // MARK: NSCoding

    private struct PropertyKey {
        static let name = "name"
        static let imageURL = "imageURL"
        static let traits = "traits"
        static let infoLabel = "infoLabel"
        static let allergens = "allergens"
        static let markers = "markers"
        static let servingSize = "servingSize"
        static let servingSizeInGrams = "servingSizeInGrams"
        static let price = "price"
        static let nutritionInfo = "nutritionInfo"
        static let nutritionFactID = "id"
        static let nutritionFactPDV = "pdv"
        static let nutritionFactAmount = "amount"
        static let nutritionFactUnit = "unit"
    }

    public func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(imageURL, forKey: PropertyKey.imageURL)
        aCoder.encode(traits.map { $0.rawValue }, forKey: PropertyKey.traits)
        aCoder.encode(infoLabel, forKey: PropertyKey.infoLabel)
        aCoder.encode(allergens, forKey: PropertyKey.allergens)
        aCoder.encode(markers, forKey: PropertyKey.markers)
        aCoder.encode(servingSize, forKey: PropertyKey.servingSize)
        aCoder.encode(servingSizeInGrams, forKey: PropertyKey.servingSizeInGrams)
        aCoder.encode(price, forKey: PropertyKey.price)
        var nutritionInfoToEncode = [Dictionary<String, Any>]()
        for (_, nutritionFact) in nutritionInfoDict {
            var nutritionFactDict = [String:Any]()
            nutritionFactDict[PropertyKey.nutritionFactID] = nutritionFact.id
            nutritionFactDict[PropertyKey.nutritionFactPDV] = nutritionFact.percentDV
            nutritionFactDict[PropertyKey.nutritionFactAmount] = nutritionFact.amount
            nutritionFactDict[PropertyKey.nutritionFactUnit] = nutritionFact.unit
            nutritionInfoToEncode.append(nutritionFactDict)
        }
        aCoder.encode(nutritionInfoToEncode, forKey: PropertyKey.nutritionInfo)
    }

    required public init?(coder aDecoder: NSCoder) {
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String,
            let traitStrings = aDecoder.decodeObject(forKey: PropertyKey.traits) as? [String],
            let allergens = aDecoder.decodeObject(forKey: PropertyKey.allergens) as? [String],
            // let nutritionInfoDict = aDecoder.decodeObject(forKey: PropertyKey.nutritionInfoDict) as? [String: NutritionFact],
            let markers = aDecoder.decodeObject(forKey: PropertyKey.markers) as? [String],
            let nutritionInfo = aDecoder.decodeObject(forKey: PropertyKey.nutritionInfo) as? [Dictionary<String, Any>] else {
                return nil
        }
        self.name = name
        self.imageURL = aDecoder.decodeObject(forKey: PropertyKey.imageURL) as? String
        self.traits = traitStrings.map { Trait.init(rawValue: $0) }.removeNils()
        self.infoLabel = aDecoder.decodeObject(forKey: PropertyKey.infoLabel) as? String
        self.allergens = allergens
        self.markers = markers
        self.servingSize = aDecoder.decodeObject(forKey: PropertyKey.servingSize) as? String
        self.servingSizeInGrams = aDecoder.decodeObject(forKey: PropertyKey.servingSizeInGrams) as? Int
        self.price = aDecoder.decodeObject(forKey: PropertyKey.price) as? Double
        var nutritionInfoDict = [String: NutritionFact]()
        for nutritionFactDict in nutritionInfo {
            var nutritionFact = NutritionFact()
            nutritionFact.id = nutritionFactDict[PropertyKey.nutritionFactID] as! String
            nutritionFact.percentDV = nutritionFactDict[PropertyKey.nutritionFactPDV] as? Int
            nutritionFact.amount = nutritionFactDict[PropertyKey.nutritionFactAmount] as! Int
            nutritionFact.unit = nutritionFactDict[PropertyKey.nutritionFactUnit] as! String
            nutritionInfoDict[nutritionFact.id] = nutritionFact
        }

        self.nutritionInfoDict = nutritionInfoDict

        super.init()
    }
}
