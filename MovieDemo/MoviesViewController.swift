//
//  MoviesViewController.swift
//  MovieDemo
//
//  Created by hsherchan on 9/12/17.
//  Copyright © 2017 Hearsay. All rights reserved.
//

import UIKit
import AFNetworking

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate {

    var movies:[Movie] = []
    var endpoint:String = ""
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var networkErrorView: UIView!
    
    @IBOutlet weak var layoutBarBtn: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.networkErrorView.isHidden = true
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.loadNowPlaying(refreshControl: nil)
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        self.tableView.insertSubview(refreshControl, at:0)
        self.collectionView.insertSubview(refreshControl, at:0)
        
        let logo = UIImage(named: "flixnet.png")
        let imageView = UIImageView(image:logo)
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(70), height: CGFloat(50))
        self.navigationItem.titleView = imageView
        // Do any additional setup after loading the view.
        
        self.view.addSubview(self.collectionView)
        self.view.addSubview(self.tableView)
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieViewCell
        let movie = self.movies[indexPath.row]
        let movieUrl = MovieService.getImageUrl(path: movie.posterPath!)
        cell.titleLabel!.text = movie.title!.uppercased()
        cell.descriptionLabel!.text = movie.overview!
        cell.descriptionLabel!.sizeToFit()
        cell.posterImageView.setImageWith(movieUrl)
        
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionCell", for: indexPath) as! MovieCollectionViewCell
        let movie = self.movies[indexPath.row]
        let movieUrl = MovieService.getImageUrl(path: movie.posterPath!)
        cell.posterImageView.setImageWith(movieUrl)
        
        return cell
        
    }
    
    
    func loadNowPlaying(refreshControl: UIRefreshControl?) {
        MovieService.fetch(addLoading: self.view, endPoint: self.endpoint, successCallBack: { (data) in
            let results = data["results"] as! [NSDictionary]
            self.movies = results.map { (movie) -> Movie in
                return Movie(fromDict: movie)
            }
            self.tableView.reloadData()
            self.collectionView.reloadData()
            self.networkErrorView.isHidden = true
            
            if let refresh = refreshControl as UIRefreshControl? {
                refresh.endRefreshing()
            }
        }) { (error) in
            self.networkErrorView.isHidden = false
            print (error?.localizedDescription ?? "")
            if let refresh = refreshControl as UIRefreshControl? {
                refresh.endRefreshing()
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        let vc = segue.destination as! MovieDetailsViewController
        var movie:Movie!
        if segue.identifier == "tableCell" {
            let cell = sender as! MovieViewCell
            let indexPath = tableView.indexPath(for: cell)
            movie = movies[indexPath!.row]
        } else if segue.identifier == "collectionCell" {
            let cell = sender as! MovieCollectionViewCell
            let indexPath = collectionView.indexPath(for: cell)
            movie = movies[indexPath!.row]
        }
        
        
        vc.movie = movie
    }
    
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        loadNowPlaying(refreshControl: refreshControl)
    }
    

    @IBAction func changeLayout(_ sender: Any) {
        let listViewIndex = self.view.subviews.index(of: self.tableView)!
        let collectionViewIndex = self.view.subviews.index(of: self.collectionView)!
        
        if (listViewIndex < collectionViewIndex ) {
            self.layoutBarBtn.image = UIImage(named:"grid.png")
            
        } else {
            self.layoutBarBtn.image = UIImage(named:"list.png")
        }
        self.view.exchangeSubview(at: listViewIndex, withSubviewAt: collectionViewIndex)
        
        
    }

    

}
