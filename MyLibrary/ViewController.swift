//
//  ViewController.swift
//  BookStore
//
//  Created by Ken Tai on 2022/11/21.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tbMenu: UITableView!
    @IBOutlet weak var lbVer: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        lbVer.text = "app version : \(appVersion!)"
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let manager = HTTPManager.shared
        manager.getBookData()
        saveBookData()
    }
    
    func saveBookData() {
        
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
            cell.textLabel?.text = "online BookStore"
        }
        else if (indexPath.row == 1) {
            cell.textLabel?.text = "off-line BookStore"
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

