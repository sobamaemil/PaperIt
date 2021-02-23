//
//  DataSync.swift
//  MyMemory
//
//  Created by 심찬영 on 2021/02/23.
//

import UIKit
import CoreData
import Alamofire

class DataSync {
    // 코어 데이터의 컨텍스트 객체
    lazy var context: NSManagedObjectContext = {
        let appDalegate = UIApplication.shared.delegate as! AppDelegate
        return appDalegate.persistentContainer.viewContext
    }()
}

// MARK: - DataSync 유틸 메소드
extension DataSync {
    // String - Date
    func stringToDate(_ value: String) -> Date {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return df.date(from: value)!
    }
    
    // Date - String
    func dateToString(_ value: Date) -> String {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH-mm-ss"
        return df.string(from: value)
    }
}
