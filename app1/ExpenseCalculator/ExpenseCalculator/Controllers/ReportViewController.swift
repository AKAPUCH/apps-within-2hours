

import UIKit

protocol FormViewControllerDelegate : AnyObject {
    func dismissForm(_ dataModel: Expense)
}

class ReportViewController: UIViewController {
    
    var expenseArray = [Expense]() {
        didSet {
            calculateExpense()
        }
    }
    let numberFormatter = {
        let n = NumberFormatter()
        n.numberStyle = .decimal
        return n
    }()
    
    // 파일 경로 설정
    let filePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("expense.json").path
    
    @IBOutlet weak var totalExpenseLabel: UILabel!
    @IBOutlet weak var stayExpenseLabel: UILabel!
    @IBOutlet weak var transportationExpenseLabel: UILabel!
    @IBOutlet weak var foodExpenseLabel: UILabel!
    @IBOutlet weak var etcExpenseLabel: UILabel!
    
    @IBOutlet weak var expenseTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLabel()

        // 객체 불러오기
        if let loadedExpenseArray: [Expense] = loadCustomObjectFromFile([Expense].self, fromPath: filePath) {
            expenseArray = loadedExpenseArray
        }
    }
    
    func getExpense(_ target : [String?:Int], _ kind : String?) -> Int {
        return target[kind,default: 0]
    }
    
    func makeText(_ kind: String, _ amount : Int) -> String {
        return kind + " : " + numberFormatter.string(from: NSNumber(value: amount))! + "원"
    }
    
    
    func setLabel() {
        [totalExpenseLabel,stayExpenseLabel,transportationExpenseLabel,foodExpenseLabel,etcExpenseLabel].forEach{
            $0.layer.cornerRadius = 3
            $0.layer.borderWidth = 1
        }
        calculateExpense()
    }
    
    func saveCustomObjectToFile(_ object: Codable, toPath path: String) {
        do {
            let data = try JSONEncoder().encode(object)
            FileManager.default.createFile(atPath: path, contents: data, attributes: nil)
            try data.write(to: URL(fileURLWithPath: path))
        } catch {
            print("Error saving custom object: \(error)")
        }
    }

    func loadCustomObjectFromFile<T: Codable>(_ type: T.Type, fromPath path: String) -> T? {
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path))
            let object = try JSONDecoder().decode(type, from: data)
            return object
        } catch {
            print("Error loading custom object: \(error)")
            return nil
        }
    }
    
    func calculateExpense() {
        let dict = Dictionary(uniqueKeysWithValues: expenseArray.map{($0.kind,$0.amount)})
        
        numberFormatter.numberStyle = .decimal
        
        stayExpenseLabel.text = makeText("숙박비", getExpense(dict, "숙박비"))
        transportationExpenseLabel.text = makeText("교통비", getExpense(dict, "교통비"))
        foodExpenseLabel.text = makeText("식비", getExpense(dict, "식비"))
        etcExpenseLabel.text = makeText("기타", getExpense(dict, "기타"))
        totalExpenseLabel.text = makeText("누적 금액", dict.values.reduce(0,+))
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "navi" {
            if let target = segue.destination as? UINavigationController,let nextVC = target.topViewController as? FormViewController {
                nextVC.delegate = self
            }
        }
    }
    
    @IBAction func transferExpenseToMessage(_ sender: Any) {
        let message =
        """
        \(totalExpenseLabel.text!)
        \(stayExpenseLabel.text!)
        \(transportationExpenseLabel.text!)
        \(foodExpenseLabel.text!)
        \(etcExpenseLabel.text!)
        """
        var sms: String = "sms:01077592473&body=" + message
        sms = sms.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        UIApplication.shared.open(URL.init(string:sms)!,options: [:])
        
    }
}

extension ReportViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return expenseArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "expenseCell", for: indexPath) as! ExpenseTableViewCell
        cell.expenseKindLabel.text = expenseArray[indexPath.row].kind
        cell.expenseAmountLabel.text = numberFormatter.string(from: NSNumber(value: expenseArray[indexPath.row].amount))!
        cell.expenseDescLabel.text = expenseArray[indexPath.row].desc
        
        return cell
    }
    
    
}

extension ReportViewController : FormViewControllerDelegate {
    func dismissForm(_ dataModel: Expense) {
        expenseTable.performBatchUpdates({
            expenseArray.append(dataModel)
            expenseTable.insertRows(at: [[0,expenseArray.count-1]], with: .automatic)
        })
        
        // 객체 저장
        saveCustomObjectToFile(expenseArray, toPath: filePath)
    }
    
    
}




