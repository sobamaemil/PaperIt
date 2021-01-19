//
//  MemoReadVCViewController.swift
//  MyMemory
//
//  Created by 심찬영 on 2021/01/18.
//

import UIKit

class MemoReadVC: UIViewController {
    
    // 콘텐츠 데이터를 저장하는 변수
    var param: MemoData?
    
    @IBOutlet weak var subject: UILabel!
    @IBOutlet weak var contents: UILabel!
    @IBOutlet weak var img: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // 제목과 내용, 이미지 출력
        self.subject.text = param?.title
        self.contents.text = param?.contents
        self.img.image = param?.image
        
        // 날짜 포맷 변환
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일 HH:mm분에 작성됨"
        let dateString = formatter.string(from: (param?.regdate)!)
        
        // 내비게이션 타이틀에 날짜를 표시
        self.navigationItem.title = dateString
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
