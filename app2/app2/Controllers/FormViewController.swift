

import UIKit

class FormViewController: UIViewController {
    
    @IBOutlet weak var sychronizeSwitch: UISwitch!
    @IBOutlet weak var infoTextField: UITextField!
    @IBOutlet weak var phoneNumTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    
    var delegate : ModalDataTransferDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
    func validateForm() -> Int {
        guard let friendName = nameTextField.text, let friendPhoneNum = phoneNumTextField.text else {return -1}
        
        if friendName.isEmpty {return 1}
        else if friendPhoneNum.isEmpty {return 2}
        
        return 0
    }
    
    
    @IBAction func saveForm(_ sender: Any) {
        var message : String?
        let newFriend = Friend(name: nameTextField.text!, phoneNum: phoneNumTextField.text!, info: infoTextField.text)
        switch validateForm() {
        case 0 : message = "신규 연락처 등록 성공!"
        case 1 : message = "이름을 입력해주세요"
        case 2 : message = "전화번호를 입력해주세요"
        default : break
        }
        guard let alertMessage = message else {return}
        let alertView = UIAlertController(title: nil, message: alertMessage, preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: "확인", style: .default){_ in
            self.delegate?.updateData(newFriend)
            self.dismiss(animated: true)
        })
        self.present(alertView,animated: true)
    }
    
    @IBAction func cancelForm(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
}
