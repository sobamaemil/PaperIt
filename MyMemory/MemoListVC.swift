//
//  MemoListVCTableViewController.swift
//  MyMemory
//
//  Created by 심찬영 on 2021/01/18.
//

import UIKit

class MemoListVC: UITableViewController, UISearchBarDelegate {
    lazy var dao = MemoDAO()
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        // 검색 바의 키보드에서 리턴 키가 항상 활성화되어 있도록 처리
        searchBar.enablesReturnKeyAutomatically = false
        
        // SWRevealViewController 라이브러리의 revealViewController 객체를 읽어옴
        if let revealVC = self.revealViewController() {
            // 바 버튼 아이템 객체를 정의
            let btn = UIBarButtonItem()
            btn.image = UIImage(named: "sidemenu") // 이미지는 sidemenu.png
            btn.target = revealVC // 버튼 클릭 시 호출할 메소드가 정의된 객체를 지정
            btn.action = #selector(revealVC.revealToggle(_:)) // 버튼 클릭 시 revealToggle(_:) 호출
            
            // 정의된 바 버튼을 내비게이션 바의 왼쪽 아이템으로 등록
            self.navigationItem.leftBarButtonItem = btn
            
            // 제스처 객체를 뷰에 추가
            self.view.addGestureRecognizer(revealVC.panGestureRecognizer())
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let keyword = searchBar.text // 검색 바에 입력된 키워드를 가져옴
        
        // 키워드를 적용하여 데이터를 검색하고, 테이블 뷰를 갱신
        self.appDelegate.memolist = self.dao.fetch(keyword: keyword)
        self.tableView.reloadData()
    }
    
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        let keyword = searchBar.text // 검색 바에 입력된 키워드를 가져옴
//
//        // 키워드를 적용하여 데이터를 검색하고, 테이블 뷰를 갱신
//        self.appDelegate.memolist = self.dao.fetch(keyword: keyword)
//        self.tableView.reloadData()
//    }
    
    // MARK: - Table view data source

    // 테이블 뷰의 셀 개수를 결정하는 메소드
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let count = self.appDelegate.memolist.count
        return count
    }

    //
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Configure the cell...
        // memolist 배열 데이터에서 주어진 행에 맞는 데이터를 꺼냄
        let row = self.appDelegate.memolist[indexPath.row]
        
        // 이미지 속성이 비어 있을 경우 "memoCell", 아니면 memoCellWithImage"
        let cellId = row.image == nil ? "memoCell" : "memoCellWithImage"
        
        // 재사용 큐로부터 프로토타입 셀의 인스턴스를 전달받음
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as? MemoCell else {
            return UITableViewCell()
        }
        
        // memoCell의 내용을 구성
        cell.subject?.text = row.title
        cell.contents?.text = row.contents
        cell.img?.image = row.image
        
        // Date 타입의 날짜를 yyyy-MM-dd HH:mm:ss 포맷으로 변경
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        cell.regdate?.text = formatter.string(from: row.regdate!)
        
        // cell 객체 리턴
        return cell
    }
    
    // 디바이스 스크린에 뷰 컨트롤러가 나타날 때마다 호출되는 메소드
    override func viewWillAppear(_ animated: Bool) {
        let ud = UserDefaults.standard
        if ud.bool(forKey: UserInfoKey.tutorial) == false {
            let vc = self.instanceTutorialVC(name: "MasterVC")
            vc?.modalPresentationStyle = .fullScreen
            self.present(vc!, animated: false)
            return
        }
        
        // 코어 데이터에 저장된 데이터를 가져옴
        self.appDelegate.memolist = self.dao.fetch()
        
        // 테이블 데이터를 다시 읽어들임, 따라서 행을 구성하는 로직이 다시 실행
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // memolist 배열에서 선택된 행에 맞는 데이터를 꺼냄
        let row = self.appDelegate.memolist[indexPath.row]
        
        
        // 상세 화면의 인스턴스를 생성
        guard let vc = self.storyboard?.instantiateViewController(identifier: "MemoRead") as? MemoReadVC else {
            return
        }
        
        // 값을 전달한 후 상세 화면으로 이동
        vc.param = row
        
        self.navigationController?.pushViewController(vc, animated: true)
        
//        self.performSegue(withIdentifier: "read_sg", sender: self)

    }

    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let data = self.appDelegate.memolist[indexPath.row]
        
        // 코어 데이터에서 삭제한 다음, 배열 내 데이터 및 테이블 뷰 행을 차례로 삭제
        if dao.delete(data.objectID!) {
            self.appDelegate.memolist.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
