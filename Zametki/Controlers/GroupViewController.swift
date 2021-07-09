//
//  GroupViewController.swift
//  Zametki
//
//  Created by ADMIMN on 09.07.2021.
//

import UIKit

class GroupViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    var myGroup:Group? = nil
    var myZametki:[Zametka] = []
    @IBOutlet var tableview: UITableView!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = myGroup?.name
        
        myZametki = myGroup!.zametki!.allObjects as! [Zametka]
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        myZametki = myGroup!.zametki!.allObjects as! [Zametka]
        
        tableview.reloadData()
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myZametki.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ZametkaViewCell", for: indexPath)
        
        cell.textLabel?.text = myZametki[indexPath.row].name
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action = UIContextualAction(style: .destructive, title: "Удалить") { [self] actions, view, bool in
            
            context.delete(context.object(with: myZametki[indexPath.row].objectID))
            myZametki.remove(at: indexPath.row)
            
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        let action2 = UIContextualAction(style: .normal, title: "В избранные") { [self] action, view, bool in
            action.backgroundColor = .green
            
            let obejekt = myZametki[indexPath.row]
            obejekt.addToGroup(context.object(with: izbranniGroup!) as! Group)
                    
            tableview.reloadData()
            
        }
        
        let swipe = UISwipeActionsConfiguration(actions: [action2, action])
        return swipe
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "NewZametkaViewController") as! NewZametkaViewController
        vc.objektId = myZametki[indexPath.row].objectID
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    
    @IBAction func addNewZametka(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "NewZametkaViewController") as! NewZametkaViewController
        vc.groups = myGroup
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
