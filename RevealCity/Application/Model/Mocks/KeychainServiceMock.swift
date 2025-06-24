//
//  KeychainServiceMock.swift
//  RevealCity
//
//  Created by Максим Сулим on 23.06.2025.
//

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
