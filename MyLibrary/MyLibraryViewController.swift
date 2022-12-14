//
//  MyLibraryViewController.swift
//  MyLibrary
//
//  Created by Ken Tai on 2022/11/24.
//

import UIKit
import CoreData
import SDWebImage

class MyLibraryViewController : UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionViewBook: UICollectionView!
    //宣告Core Data 常數
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var bWifi : Bool = true
    var arrBook = NSMutableArray()
    var arrFav = NSArray() as! Array<Int>
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (bWifi) {
            let manager = HTTPManager.shared
            manager.getBookData { arrData in
                self.arrBook = NSMutableArray(array:arrData)
            }
            collectionViewBook.reloadData()
        }
        else {
            self.arrBook = NSMutableArray(array:self.getCoreData())
            DispatchQueue.main.async {
                self.collectionViewBook.reloadData()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        arrFav = Array(repeating: 0, count: self.arrBook.count)
    }
    
    func getCoreData() -> Array<BookInfo>{
        var arrData:[BookInfo] = []
        let request = NSFetchRequest<BookInfo>(entityName: "BookInfo")
        do {
            let results = try self.context.fetch(request)
            for result in results {
                arrData.append(result)
            }
        } catch {
            fatalError("Failed to fetch data: \(error)")
        }
        return arrData
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrBook.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "bookCell", for: indexPath) as! MyCollectionViewCell
        // not off-line
        if (self.bWifi) {
            let dic = self.arrBook[indexPath.row] as! NSDictionary
            cell.imgBook.sd_setImage(with: URL(string: dic["coverUrl"] as! String), placeholderImage: UIImage(named: "placeholder.png"))
            cell.lbTitle.text = dic["title"] as? String
        }
        // off-line
        else {
            let book = self.arrBook[indexPath.row] as! BookInfo
            cell.imgBook.sd_setImage(with: URL(string: book.coverUrl!), placeholderImage: UIImage(named: "placeholder.png"))
            cell.lbTitle.text = book.title
        }
        cell.btnFavorite.tag = indexPath.row
        cell.btnFavorite.addTarget(self, action: #selector(btnFavoriteClicked), for: .touchUpInside)
        
        return cell
    }
    
    @objc func btnFavoriteClicked(sender: UIButton!) {
        let btn: UIButton = sender
        let index = btn.tag
        if (arrFav[index] == 0) {
            btn.setImage(UIImage(named: "favorite_enable"), for: .normal)
            arrFav[index] = 1
        }
        else {
            btn.setImage(UIImage(named: "favorite_disable"), for: .normal)
            arrFav[btn.tag] = 0
        }
    }
    
    
}
