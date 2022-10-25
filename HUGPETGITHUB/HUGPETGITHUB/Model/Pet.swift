
import Foundation

enum PetTypes:  String, Identifiable, CaseIterable , Codable {
    
    public var id: String {
        return self.rawValue.capitalized
    }
    
    case Dog
    case Cat
    case Rabbit
    case Bird
}
//hi aha
