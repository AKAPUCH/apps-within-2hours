//
//  FormViewController.swift
//  ExpenseCalculator
//
//  Created by 최우태 on 2023/07/11.
//

import UIKit

class FormViewController: UIViewController {
    
    weak var delegate : FormViewControllerDelegate?
    
    @IBOutlet weak var expenseSelection: UISegmentedControl!
    
    @IBOutlet weak var expenseAmountTextField: UITextField!
    @IBOutlet weak var expenseDetailTextField: UITextField!
    
    var expenseKind : String? {
        switch expenseSelection.selectedSegmentIndex {
        case 0 : return "숙박비"
        case 1 : return "교통비"
        case 2 : return "식비"
        case 3 : return "기타"
        default : fatalError()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavi()
    }
    
    func setNavi() {
        self.navigationItem.title = "비용 등록"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(cancelForm))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(saveForm))
    }
    
    
    
    @objc func cancelForm() {
        self.dismiss(animated: true)
    }
    
    @objc func saveForm() {
        let newExpense = Expense(kind: expenseKind,amount: Int(expenseAmountTextField.text!)!,desc: expenseDetailTextField.text)
        self.delegate?.dismissForm(newExpense)
        self.dismiss(animated: true)
    }
    


}
