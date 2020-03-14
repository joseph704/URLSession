//
//  ViewController.swift
//  URLSession
//
//  Created by 차요셉 on 09/03/2020.
//  Copyright © 2020 차요셉. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDataSource {
    @IBOutlet weak var tableView:UITableView!
    let cellIdentifier: String = "friendCell"
    var friends: [Friend] = []
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath)
        let friend: Friend = self.friends[indexPath.row]
        
        cell.textLabel?.text = friend.name.full
        cell.detailTextLabel?.text = friend.email
        cell.imageView?.image = nil
        
        DispatchQueue.global().async {
            guard let imageURL: URL = URL(string: friend.picture.thumbnail) else { return }
            guard let imageData: Data = try? Data(contentsOf: imageURL) else { return }
            
            DispatchQueue.main.sync {
                if let index: IndexPath = tableView.indexPath(for: cell) {
                    if index.row == indexPath.row {
                        cell.imageView?.image = UIImage(data: imageData)
                    }
                }
            }
        }
        
        
        return cell
    }
    
    @objc func didRecieveFriendsNotification(_ noti: Notification){
        guard let friends: [Friend] = noti.userInfo?["friends"] as? [Friend] else {return}
        
        self.friends = friends
        
        // requestFriends메소드에서 post부분이 백그라운드 스레드로 돌아가기 때문이다
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestFriends()
        NotificationCenter.default.addObserver(self, selector: #selector(self.didRecieveFriendsNotification(_:)), name: DidReceiveFriendsNotification, object: nil)
        // Do any additional setup after loading the view.
    }


}
