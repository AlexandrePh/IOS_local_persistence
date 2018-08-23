//
//  LocalStorageTests.swift
//  GaioAppTests
//
//  Created by Alexandre Machado on 21/08/18.
//  Copyright © 2018 Gaio. All rights reserved.
//

import XCTest

@testable import GaioApp



class LocalStorageTests: XCTestCase{
   
    override func setUp() {
        let filePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("testFile.json")
        
        deleteFile(at: filePath)
        
    }
    
    private func deleteFile(at path: String){
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: path){
            do{
                try fileManager.removeItem(atPath: path)
            }
            catch{
                print("file not found")
                
            }
        }
    }
    
    //MARK: - Test save
    func saveSucceed() {
        let file = "testfile"
        let testSubject = LocalStorage.instance
        let med = Medication(name: "test", composition: "test", amount: 1, amountType: .bottle)
        XCTAssertNoThrow(try testSubject.save(data: med, in: file))//
    }
    
    
    //MARK: - Test load
    func loadFileDoesNotExist(){
        let testClass = LocalStorage.instance
        var testMedication = Medication(name: "test", composition: "test", amount: 1, amountType: .bottle)
        
        XCTAssertThrowsError(try testClass.load(into: &testMedication, in: "fakeFile"), "") { (error) in
            XCTAssert(error is StorageError)
            XCTAssert(error as! StorageError == StorageError.failedToReadFile)
            
        }
        
    }
    func loadWithObjectOfWrongType(){
        struct CodableData: Codable{
            var test:Int
        }
        let file = "testfile"
        let testSubject = LocalStorage.instance
        var codableData = CodableData(test: 1)
        let med = Medication(name: "test", composition: "test", amount: 1, amountType: .bottle)
        
        do{
            try testSubject.save(data: med, in: file)
        }catch{
            XCTFail("saveAndLoad: couldnt save")
        }
        XCTAssertThrowsError(try testSubject.load(into: &codableData, in: file), "") { (error) in
            XCTAssertTrue(error as! StorageError == StorageError.failedToDecode)
        }
    }
    
    func loadSucceed(){
        let med = Medication(name: "test", composition: "test", amount: 1, amountType: .bottle)
        var newMed =  Medication(name: "test", composition: "test", amount: 1, amountType: .bottle)

        let testSubject = LocalStorage.instance
        let file = "testfile"
        
        do{
            try testSubject.save(data: med, in: file)
        }catch{
            XCTFail("saveAndLoad: couldnt save")
        }
        
        do {
            try testSubject.load(into: &newMed, in: file)
        } catch {
            XCTFail("saveAndLoad: couldnt load")
        }
        
        XCTAssertEqual(med.name, newMed.name)
        
        
    }

    
}
