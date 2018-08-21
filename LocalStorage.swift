//
//  LocalPersistence.swift
//  GaioApp
//
//  Created by Alexandre Machado on 20/08/18.
//  Copyright © 2018 Gaio. All rights reserved.
//

import Foundation
enum StorageError: Error {
    case inputNotCodable
    case cantReadFile
    case notAbleToDecode
}

class LocalStorage {
    static let instance = LocalStorage()
    private let documentDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
    
    private init(){}
    
    private func getURLInDocumentDir(for file: String) -> URL {
        return URL(fileURLWithPath: self.documentDir.appendingPathComponent(file + ".json"))
    }
    func save<T:Codable>(data: T,in file: String) throws{

        let url = getURLInDocumentDir(for: file)

        do{
            try JSONEncoder().encode(data).write(to: url)
        } catch {
            throw StorageError.inputNotCodable
        }
    }
    func load<T:Codable>(into object: inout T, in file: String) throws{
        let url = getURLInDocumentDir(for: file)
        var readedData:Data!
        do {
            readedData = try Data(contentsOf: url)
        } catch  {
            throw StorageError.cantReadFile
        }
        do {
            object = try JSONDecoder().decode(T.self, from: readedData)
        } catch {
            throw StorageError.notAbleToDecode
        }
        
        
    }
    
}
