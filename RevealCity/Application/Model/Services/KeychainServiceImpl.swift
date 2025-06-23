//
//  KeychainService.swift
//  RevealCity
//
//  Created by Максим Сулим on 23.06.2025.
//

import Foundation
import KeychainSwift

enum ObjectSavebleError: String, LocalizedError {
    case unableToEncode = "Unable to encode object into data"
    case noValue = "No data object"
    case unableToDecode = "Unable to decode"
    
    var errorDescription: String? {
        self.rawValue
    }
}

protocol ObjectSaveble {
    func setObject<Object: Encodable>(_ object: Object, forKey: String) throws
    func getObject<Object: Decodable>(forKey: String, castTo type: Object.Type) throws -> Object
}

protocol KeychainService: AnyObject, ObjectSaveble {
    func clearStorage()
}

final class KeychainServiceImpl {
    let keychain = KeychainSwift()
    
    private func setData(data: Data, forKey: String) {
        keychain.set(data, forKey: forKey)
    }
    
    private func getData(forKey: String) -> Data? {
        keychain.getData(forKey)
    }
}

extension KeychainServiceImpl: KeychainService {
    
    func setObject<Object: Encodable>(_ object: Object, forKey: String) throws  {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(object)
            setData(data: data, forKey: forKey)
        } catch {
            throw ObjectSavebleError.unableToEncode
        }
    }
    
    func getObject<Object: Decodable>(forKey: String, castTo type: Object.Type) throws -> Object {
        guard let data = getData(forKey: forKey) else { throw ObjectSavebleError.noValue }
        let decoder = JSONDecoder()
        do {
            let object = try decoder.decode(type, from: data)
            return object
        } catch {
            throw ObjectSavebleError.unableToDecode
        }
    }
    
    func clearStorage() {
        keychain.clear()
    }
}
