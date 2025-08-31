import Foundation

final class KeychainServiceMock: KeychainService {
    
    func setObject<Object: Encodable>(_ object: Object, forKey: String) throws  {
        
    }
    
    func getObject<Object: Decodable>(forKey: String, castTo type: Object.Type) throws -> Object {
        throw URLError(.badServerResponse)
    }
    
    func clearStorage() {
        
    }
}
