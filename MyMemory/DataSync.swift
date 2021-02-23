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
    
    // 서버에 백업된 데이터 내려받기
    func downloadBackupData() {
        // 최초 한 번만 다운로드 받도록 체크
        let ud = UserDefaults.standard
        guard ud.value(forKey: "firstLogin") == nil else {
            return
        }
        
        // API 호출용 인증 헤더
        let tk = TokenUtils()
        let header = tk.getAuthorizationHeader()
        
        // API 호출
        let url = "http://swiftapi.rubypaper.co.kr:2029/memo/search"
        let get = AF.request(url, method: .post, encoding: JSONEncoding.default, headers: header)
        
        // 응답 처리
        get.responseJSON { res in
            
        }
    }
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
