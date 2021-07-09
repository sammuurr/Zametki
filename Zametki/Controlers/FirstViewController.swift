//
//  FirstViewController.swift
//  Zametki
//
//  Created by ADMIMN on 09.07.2021.
//

import UIKit
import CoreData

var allZametkiGroup: NSManagedObjectID? = nil
var izbranniGroup: NSManagedObjectID? = nil

class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    

    @IBOutlet var tableView: UITableView!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var data:[Group] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Group")
        data = (try? context.fetch(fetch)) as? [Group] ?? []
        
        oneStartApp()
    }
    override func viewDidAppear(_ animated: Bool) {
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Group")
        data = (try? context.fetch(fetch)) as? [Group] ?? []
        
        tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupTableViewCell", for: indexPath)
        
        cell.textLabel?.text = data[indexPath.row].name
        cell.detailTextLabel?.text = "(\(data[indexPath.row].zametki!.count))"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = (storyboard?.instantiateViewController(withIdentifier: "GroupViewController")) as! GroupViewController
        vc.myGroup = data[indexPath.row]
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action = UIContextualAction(style: .destructive, title: "Удалить") { [self] actions, view, bool in
            
            context.delete(context.object(with: data[indexPath.row].objectID))
            data.remove(at: indexPath.row)
            
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
        let swipe = UISwipeActionsConfiguration(actions: [action])
        if indexPath.row > 1{
            return swipe
        }
        return nil
    }

    @IBAction func newGroupMethod(_ sender: UIBarButtonItem) {

        let alert = UIAlertController(title: "Cоздание новной группы", message: "Введите название группы", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Введите название:"
        }
        alert.addAction(UIAlertAction(title: "Отмена", style: .destructive))
        alert.addAction(UIAlertAction(title: "Создать", style: .default, handler: { [self] action in
            
            if alert.textFields![0].hasText{
                let newGroup = Group(context: context)
                
                newGroup.id = UUID()
                newGroup.name = alert.textFields![0].text!
                
                try? context.save()
                
                data.append(newGroup)
                tableView.reloadData()
            }else{
                present(alert, animated: true)
            }
            
        }))
        present(alert, animated: true)
        
        
    }
    @IBAction func newZametkaMethod(_ sender: Any) {
        
    }
    
    func oneStartApp(){
        let userDefoalts = UserDefaults()
        
        if !userDefoalts.bool(forKey: "start"){
            userDefoalts.setValue(true, forKey: "start")
            
            let newGroup = Group(context: context)
            
            newGroup.id = UUID()
            newGroup.name = "Все заметки"
            
            let newGroup2 = Group(context: context)
            
            newGroup2.id = UUID()
            newGroup2.name = "Избранные"
            
            
            try? context.save()
            
            allZametkiGroup = newGroup.objectID
            userDefoalts.set(newGroup.id?.uuidString, forKey: "izb")
            userDefoalts.set(newGroup2.id?.uuidString, forKey: "fff")
            data.insert(newGroup2, at: 0)
            data.insert(newGroup, at: 0)
            tableView.reloadData()
        }else{
            let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Group")
            fetch.predicate = NSPredicate(format: "id == %@", argumentArray: [userDefoalts.string(forKey: "izb")!])
            
            let fetch2 = NSFetchRequest<NSFetchRequestResult>(entityName: "Group")
            fetch2.predicate = NSPredicate(format: "id == %@", argumentArray: [userDefoalts.string(forKey: "fff")!])
            
            let requests = try? context.fetch(fetch) as? [Group]
            let requests2 = try? context.fetch(fetch2) as? [Group]
            
            allZametkiGroup = requests![0].objectID
            izbranniGroup = requests2![0].objectID
            
        }
    }
    
}
