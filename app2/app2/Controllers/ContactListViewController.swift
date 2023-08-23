

import UIKit

protocol ModalDataTransferDelegate : AnyObject {
    func updateData(_ friend : Friend)
}

class ContactListViewController: UIViewController {
    
    @IBOutlet weak var friendTableView: UITableView!
    var friendArray = [Friend]()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setTable()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let baseCamp = segue.destination as? UINavigationController,
           let nextVC = baseCamp.viewControllers.first as? FormViewController {
            nextVC.delegate = self
        }
    }
    
    func setTable() {
        let cell = UINib(nibName: "ContactTableViewCell", bundle: nil)
        friendTableView.register(cell, forCellReuseIdentifier: "CustomCell")
    }
    
    func loadPreviousData() {
        
    }
    
    func saveCurrentData() {
        
    }


}

extension ContactListViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! ContactTableViewCell
        let currentFriend = friendArray[indexPath.row]
        
        cell.nameLabel.text = currentFriend.name
        cell.phoneNumLabel.text = currentFriend.phoneNum
        cell.infoLabel.text = currentFriend.info
        
        return cell
    }
    
    
}

extension ContactListViewController : ModalDataTransferDelegate {
    func updateData(_ friend: Friend) {
        friendTableView.performBatchUpdates {
            friendArray.append(friend)
            friendTableView.insertRows(at: [IndexPath(row: friendArray.count-1, section: 0)], with: .automatic)
        }
    }
}

