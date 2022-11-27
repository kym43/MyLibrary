//
//  ViewController.swift
//  MyLibrary
//
//  Created by Ken Tai on 2022/11/21.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tbMenu: UITableView!
    @IBOutlet weak var lbVer: UILabel!
    //宣告Core Data 常數
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        lbVer.text = "app version : \(appVersion!)"
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let manager = HTTPManager.shared
        manager.getBookData { arrData in
            self.saveBookData(arr: arrData)
        }
        //saveBookData()
    }
    
    func saveBookData(arr : NSMutableArray) {
        self.deleteCoreData()
        for data in arr {
            let book = NSEntityDescription.insertNewObject(forEntityName: "BookInfo", into: self.context) as! BookInfo
            let dic = data as! NSDictionary
            book.uuid = dic["uuid"] as! Int64
            book.title = dic["title"] as? String
            book.coverUrl = dic["coverUrl"] as? String
            book.publishDate = dic["publishDate"] as? String
            book.publisher = dic["publisher"] as? String
            book.author = dic["author"] as? String
            book.isFavorite = false
            print (book)
            do {
                try self.context.save()
            } catch {
                fatalError("Failed to fetch data: \(error)")
            }
        }
    }
    
    func deleteCoreData() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "BookInfo")
            fetchRequest.returnsObjectsAsFaults = false
            do {
                let results = try self.context.fetch(fetchRequest)
                for object in results {
                    guard let objectData = object as? NSManagedObject else {continue}
                    self.context.delete(objectData)
                }
            } catch let error {
                print("Detele all data error : \(error) ")
            }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath) as UITableViewCell
              
        if (indexPath.row == 0) {
            cell.textLabel?.text = "online MyLibrary"
        }
        else if (indexPath.row == 1) {
            cell.textLabel?.text = "off-line MyLibrary"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "libraryVC") as? MyLibraryViewController
        if (indexPath.row == 0) {
            vc!.bWifi = true
        }
        else if (indexPath.row == 1) {
            vc!.bWifi = false
        }
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    

}

