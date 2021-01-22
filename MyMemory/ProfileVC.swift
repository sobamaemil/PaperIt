//
//  ProfileVC.swift
//  MyMemory
//
//  Created by 심찬영 on 2021/01/22.
//

import UIKit
class ProfileVc: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let profileImage = UIImageView() // 프로필 사진 이미지
    let tv = UITableView() // 프로필 목록
    
    override func viewDidLoad() {
        self.navigationItem.title = "프로필"
        
        // 뒤로 가기 버튼 처리
        let backBtn = UIBarButtonItem(title: "닫기", style: .plain, target: self, action: #selector(close(_:)))
        self.navigationItem.leftBarButtonItem = backBtn
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        // 여기에 셀 구현 내용
        
        return cell
    }
    
    @objc func close(_ sender: UIButton) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
}
