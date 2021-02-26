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
            // 응답 결과가 잘못되었거나 list 항목이 없을 경우에는 잘못된 응답이므로 그대로 종료
            guard let jsonObject = try! res.result.get() as? NSDictionary else { return }
            guard let list = jsonObject["list"] as? NSArray else { return }
            
            // list 항목을 순회하면서 각각의 데이터를 코어 데이터에 저장
            for item in list {
                guard let record = item as? NSDictionary else {
                    return
                }
                
                // MemoMO 타입의 관리 객체 인스턴스를 생성하고, 각 속성에 값을 대입
                let object = NSEntityDescription.insertNewObject(forEntityName: "Memo", into: self.context) as! MemoMO
                object.title = (record["title"] as! String)
                object.contents = (record["contents"] as! String)
                object.regdate = self.stringToDate(record["create_date"] as! String)
                object.sync = true
                
                // 이미지가 있을 경우에만 대입
                if let imagePath = record["image_path"] as? String {
                    let url = URL(string: imagePath)!
                    object.image = try! Data(contentsOf: url)
                }
            } // for item in list { ...
            
            // 영구 저장소에 커밋
            do {
                try self.context.save()
            } catch let e as NSError {
                self.context.rollback()
                NSLog("An error has occurred : %s", e.localizedDescription)
            }
            
            // 다운로드가 끝났으므로 이후로는 실행되지 않도록 처리
            ud.setValue(true, forKey: "firstLogin")
        }
    }
    
    // Memo 엔터티에 저장된 모든 데이터 중에서 동기화되지 않은 것을 찾아 업로드
    func uploadData(_ indicatorView: UIActivityIndicatorView? = nil) {
        // 요청 객체 생성
        let fetchRequest: NSFetchRequest<MemoMO> = MemoMO.fetchRequest()
        
        // 최신 글 순으로 정렬
        let regdateDesc = NSSortDescriptor(key: "regdate", ascending: false)
        fetchRequest.sortDescriptors = [regdateDesc]
        
        // 업로드가 되지 않은 데이터만 추출
        fetchRequest.predicate = NSPredicate(format: "sync == false")
        
        do {
            let resultset = try self.context.fetch(fetchRequest)
            
            // 읽어온 결과 집합을 순회하면서 [MemoData] 타입으로 변환
            for record in resultset {
                print("upload data == \(record.title!)")
                
                // 서버에 업로드
                self.uploadDatum(record)
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    // 인자값으로 입력된 개별 MemoMO 객체를 서버에 업로드
    func uploadDatum(_ item: MemoMO, complete: (()->Void)? = nil) {
        
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
