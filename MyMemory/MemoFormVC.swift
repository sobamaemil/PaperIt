//
//  MemoFormVC.swift
//  MyMemory
//
//  Created by 심찬영 on 2021/01/18.
//

import UIKit

class MemoFormVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {
    @IBOutlet weak var contents: UITextView! // textview 객체
    @IBOutlet weak var preview: UIImageView! // iamgeview 객체
    
    var subject: String! // 메모 내용의 첫 줄을 추출하여 제목으로 사용할 것
    lazy var dao = MemoDAO() // 코어 데이터
    
    // 저장 버튼을 클릭했을 때 호출되는 메소드
    @IBAction func save(_ sender: Any) {
        // 경고창에 사용될 콘텐츠 뷰 컨트롤러 구성
        let alertV = UIViewController()
        let iconImage = UIImage(named: "warning-icon-60")
        alertV.view = UIImageView(image: iconImage)
        alertV.preferredContentSize = iconImage?.size ?? CGSize.zero
        
        // 내용을 입력하지 않았을 경우, 경고 메시지 출력
        guard self.contents.text?.isEmpty == false else {
            let alert = UIAlertController(title: nil, message: "내용을 입력해주세요", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            // 콘텐츠 뷰 영역에 alertV를 등록
            alert.setValue(alertV, forKey: "contentViewController")
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        // MemoData 객체를 생성하고, 데이터를 넣음
        let data = MemoData()
        
        data.title = self.subject // 제목
        data.contents = self.contents.text // 내용
        data.image = self.preview.image // 이미지
        data.regdate = Date() // 작성 시각
        
//        // 앱 델리게이트 객체를 읽어온 다음, memolist 배열에 MemoData 객체를 추가
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        appDelegate.memolist.append(data)
        
        // 코어 데이터에 메모 데이터를 추가
        self.dao.insert(data)
        
        // 작성 화면을 종료하고 이전 화면으로 복귀
        self.navigationController?.popViewController(animated: true)
        
    }
    
    // 카메라 버튼을 클릭했을 때 호출되는 메소드
    @IBAction func pick(_ sender: Any) {
        // 이미지 피커 인스턴스 생성
        let picker: UIImagePickerController = UIImagePickerController()

        // 이미지 피커 컨트롤러 인스턴스의 델리게이트 속성을 현재의 뷰 컨트롤러 인스턴스로 설정
        picker.delegate = self
        
        let alert = UIAlertController(title: nil, message: "이미지를 가져올 곳을 선택해주세요.", preferredStyle: UIAlertController.Style.actionSheet)
        let camera = UIAlertAction(title: "카메라", style: UIAlertAction.Style.default) { (_) in
            guard UIImagePickerController.isSourceTypeAvailable(.camera) == true else {
                NSLog("CAMERA NOT AVAILABLE")
                return
            }
            picker.sourceType = UIImagePickerController.SourceType.camera
            // 이미지 피커를 화면에 표시
            self.present(picker, animated: false, completion: nil)
        }
        let savedPhotoAlbum = UIAlertAction(title: "저장앨범", style: UIAlertAction.Style.default, handler: { (_) in
            picker.sourceType = .savedPhotosAlbum
            // 이미지 피커를 화면에 표시
            self.present(picker, animated: false, completion: nil)
        })
        let library = UIAlertAction(title: "사진 라이브러리", style: .default) { (_) in
            picker.sourceType = .photoLibrary
            // 이미지 피커를 화면에 표시
            self.present(picker, animated: false, completion: nil)
        }

        alert.addAction(camera)
        alert.addAction(savedPhotoAlbum)
        alert.addAction(library)

        // 이미지 피커 컨트롤러의 이미지 편집을 허용
        picker.allowsEditing = true
        
        self.present(alert, animated: true, completion: nil)
    }
    
    // 사용자가 이미지를 선택하면 자동으로 이 메소드가 호출
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // 선택된 이미지를 미리보기에 출력한다.
        self.preview.image = info[.editedImage] as? UIImage
        // 이미지 피커 컨트롤러를 닫는다.
        picker.dismiss(animated: false, completion: nil)
    }
    
    // 사용자가 텍스트 뷰에 뭔가를 입력하면 자동으로 이 메소드가 호출
    func textViewDidChange(_ textView: UITextView) {
        // 내용의 최대 15자리까지 읽어 subject 변수에 저장
        let contents = textView.text as NSString
        let length = ((contents.length > 15) ? 15 : contents.length)
        self.subject = contents.substring(with: NSRange(location: 0, length: length))
        
        // 네비게이션 타이틀에 표시한다.
        self.navigationItem.title = self.subject
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.contents.delegate = self
        
        // 배경 이미지 설정
        let bgImage = UIImage(named: "memo-background")!
        self.view.backgroundColor = UIColor(patternImage: bgImage)
        
        // 텍스트 뷰의 기본 속성
        self.contents.layer.borderWidth = 0
        self.contents.layer.borderColor = UIColor.clear.cgColor
        self.contents.backgroundColor = UIColor.clear
        
        // 줄 간격 설정 - 배경 이미지의 줄 간격에 맞춤
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 8
        self.contents.attributedText = NSAttributedString(string: " ", attributes: [.paragraphStyle: style])
        self.contents.text = ""
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let bar = self.navigationController?.navigationBar
        
        let ts = TimeInterval(0.3)
        UIView.animate(withDuration: ts, animations: {
            bar?.alpha = ( bar?.alpha == 0 ? 1 : 0)
        })
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
