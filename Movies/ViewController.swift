//
//  ViewController.swift
//  Movies
//
//  Created by Venkata Vijay on 5/9/15.
//  Copyright (c) 2015 Venkata Vijay. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var networkErrorImg: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    var movies: NSArray = []
    var refreshControl:UIRefreshControl!
    var url:String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        SVProgressHUD.show()
        tableView.separatorColor = UIColor.whiteColor()
        
        let test = self.tabBarController?.viewControllers
        println(test)
        
        let dvds = test![0] as! ViewController
        dvds.url = "http://api.rottentomatoes.com/api/public/v1.0/lists/dvds/top_rentals.json?apikey=f2fk8pundhpxf77fscxvkupy"
        
        let movies = test![1] as! ViewController
        movies.url = "http://api.rottentomatoes.com/api/public/v1.0/lists/movies/in_theaters.json?apikey=f2fk8pundhpxf77fscxvkupy"
        
        var url = NSURL(string: self.url)!
        var request = NSURLRequest(URL: url)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            
            if(error != nil) {
                self.networkErrorImg.hidden = false
            }
            
            if (data != nil) {
                self.networkErrorImg.hidden = true
                var responseDictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as! NSDictionary
                self.movies = responseDictionary["movies"] as! NSArray
                self.tableView.reloadData()
            }
        }

        // Do any additional setup after loading the view, typically from a nib.
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        
        SVProgressHUD.dismiss()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("com.venkatavijay.TableViewCell", forIndexPath: indexPath) as! TableViewCell
        
        let movieDictionary = self.movies[indexPath.row] as! NSDictionary
        cell.movieTitle.text = movieDictionary["title"] as? String
        
        let posters = movieDictionary["posters"] as! NSDictionary
        let thumbnailURL = posters["thumbnail"] as! String
        
        cell.movieThumbnail.setImageWithURL(NSURL(string:thumbnailURL))
        cell.mpaaLabel.text = movieDictionary["mpaa_rating"] as? String
        cell.movieSynopsis.text = movieDictionary["synopsis"] as? String
        cell.movieSynopsis.numberOfLines = 3;
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func onRefresh(){
        var url = NSURL(string: self.url)!
        var request = NSURLRequest(URL: url)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            
            if(error != nil) {
                self.networkErrorImg.hidden = false
            }
            
            if (data != nil) {
                self.networkErrorImg.hidden = true
                var responseDictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as! NSDictionary
                self.movies = responseDictionary["movies"] as! NSArray
                self.tableView.reloadData()
            }
        }
        
        delay(2, closure: {
            self.refreshControl.endRefreshing()
        })
    }
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var vc = segue.destinationViewController as! MovieDetailsViewController
        var indexPath = tableView.indexPathForCell(sender as! UITableViewCell)
        
        let movieDictionary = self.movies[indexPath!.row] as! NSDictionary
        
        let posters = movieDictionary["posters"] as! NSDictionary
        let thumbnailURL = posters["thumbnail"] as! String
        let imageParts = split(thumbnailURL) {$0 == "/"}
        
        let image = NSURL(string: "http://content6.flixster.com/" + imageParts[5] + "/" + imageParts[6] + "/" + imageParts[7] + "/" + imageParts[8] + "/" + imageParts[9])
        
        let ratings = movieDictionary["ratings"] as! NSDictionary
        
        let critics_rating = "Critics:" + String((ratings["critics_score"] as! Int)) + " " + (ratings["critics_rating"] as! String)

        let audience_rating = "Audience:" + String((ratings["audience_score"] as! Int)) + " " + (ratings["audience_rating"] as! String)
        
        vc.imageURL = image
        vc.critics = critics_rating
        vc.audience = audience_rating
    }


}

