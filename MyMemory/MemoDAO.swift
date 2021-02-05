//
//  MemoDAO.swift
//  MyMemory
//
//  Created by 심찬영 on 2021/02/05.
//

import UIKit
import CoreData

class MemoDAO {
    // 관리 객체 컨텍스트를 반환하는 멤버 변수
    lazy var context: NSManagedObjectContext = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }()
    
    func fetch() -> [MemoData] {
        var memolist = [MemoData]()
        
        // 요청 객체 생성
        let fetchRequest: NSFetchRequest<MemoMO> = MemoMO.fetchRequest()
        
        // 최신 글 순으로 정렬하도록 정렬 객체 생성
        let regdateDesc = NSSortDescriptor(key: "regdate", ascending: false)
        fetchRequest.sortDescriptors = [regdateDesc]
        
        do {
            let resultset = try self.context.fetch(fetchRequest)
            
            // 읽어온 결과 집합을 순회하면서 [MemoData] 타입으로 변환
            for record in resultset {
                // MemoData 객체를 생성
                let data = MemoData()
                
                // MemoMO 프로퍼티 값을 MemoData의 프로퍼티로 복사
                data.title = record.title
                data.contents = record.contents
                data.regdate = record.regdate! as Date
                data.objectID = record.objectID
                
                // 이미지가 있을 때에만 복사
                if let image = record.image as Data? {
                    data.image = UIImage(data: image)
                }
                
                // MemoData 객체를 memolist 배열에 추가
                memolist.append(data)
            }
        } catch let e as NSError {
            NSLog("An error has occurred : %s", e.localizedDescription)
        }
        return memolist
    }
    
    // 새 메모를 저장하는 메소드
    func insert(_ data: MemoData) {
        // 관리 객체 인스턴스 생성
        let object = NSEntityDescription.insertNewObject(forEntityName: "Memo", into: self.context) as! MemoMO
        
        // MemoData로부터 값을 복사
        object.title = data.title
        object.regdate = data.regdate!
        object.contents = data.contents
        
        if let image = data.image as UIImage? {
            object.image = image.pngData()!
        }
        
        // 영구 저장소에 변경 사항을 반영
        do {
            try self.context.save()
        } catch let e as NSError {
            NSLog("An error has occurred : %s", e.localizedDescription)
        }
    }
    
    // 메모 내용을 삭제하기 위한 메소드
    func delete(_ objectID: NSManagedObjectID) -> Bool {
        // 삭제할 객체를 찾아, 컨텍스트에서 삭제
        let object = self.context.object(with: objectID)
        self.context.delete(object)
        
        do {
            // 삭제된 내용을 영구저장소에 반영
            try self.context.save()
            return true
        } catch let e as NSError {
            NSLog("An error has occurred : %s", e.localizedDescription)
            return false
        }
    }
    
    
}


