//
//  ViewController.swift
//  DemoAPICall
//
//  Created by iMac on 26/04/24.
//

import UIKit

class ViewController: UIViewController {
    
    var pageCounter = 1
    var posts = [Post]()
    var isLoading = false
    
    @IBOutlet weak var postsTableView: UITableView!
    @IBOutlet weak var loadingTime: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.getDataFromServer()
    }


}
extension ViewController {
    
    func setupUI() {
        self.postsTableView.delegate = self
        self.postsTableView.dataSource = self
        self.postsTableView.register(UINib(nibName: "PostDetailsTableViewCell", bundle: nil), forCellReuseIdentifier: "PostDetailsTableViewCell")
    }
    
    func getDataFromServer() {
        URLSessionManager.shared.fetchPosts(page: pageCounter) { posts,isLoading, error in
            if let error = error {
                print("Error fetching posts: \(error)")
                return
            }
            if let posts = posts {
                self.isLoading = isLoading
                print("Fetched \(posts.count) posts:")
                self.posts.append(contentsOf: posts)
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) {
                    self.postsTableView.reloadData()
                }
                
            }
        }
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PostDetailsTableViewCell") as? PostDetailsTableViewCell {
            cell.lblId.text = "ID: " + "\(posts[indexPath.row].id)"
            cell.lblTitle.text = "TITLE: " + posts[indexPath.row].title
            cell.lblUserID.text = "USERID: " + "\(posts[indexPath.row].userId)"
            cell.lblDescription.text = "DESCRIPTION: " + posts[indexPath.row].body
            // Check if additional details are already computed
            
            if indexPath.row == posts.count - 1 && !isLoading {
                // Trigger pagination if not already loading
                pageCounter += 1
                self.getDataFromServer()
                if let additionalDetails = posts[indexPath.row].additionalDetails {
                    // Use cached details if available
                    cell.detailTextLabel?.text = additionalDetails
                } else {
                    // Compute additional details asynchronously
                    DispatchQueue.global().async {
                        let startTime = Date()
                        // Simulate heavy computation by adding a delay
                        Thread.sleep(forTimeInterval: 1)
                        let endTime = Date()
                        let timeDifference = endTime.timeIntervalSince(startTime)
                        
                        // Update UI on the main thread
                        DispatchQueue.main.async {
                            // Update the post object with computed details
    //                        self.posts[indexPath.row].additionalDetails = "Computed in \(timeDifference) seconds"
                            self.loadingTime.text = "Computed in \(timeDifference) seconds"
                            // Update the cell with computed details
//                            tableView.reloadRows(at: [indexPath], with: .automatic)
                        }
                        print("Heavy computation for cell at index \(indexPath.row) took \(timeDifference) seconds")
                    }
                }
                
            }
            return cell
        } else {
            return UITableViewCell()
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ShowDetailsViewController") as? ShowDetailsViewController
        vc?.post = posts[indexPath.row]
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
}
