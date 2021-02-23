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
