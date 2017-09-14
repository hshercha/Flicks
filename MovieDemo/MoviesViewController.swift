//
//  MoviesViewController.swift
//  MovieDemo
//
//  Created by hsherchan on 9/12/17.
//  Copyright © 2017 Hearsay. All rights reserved.
//

import UIKit
import AFNetworking

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var movies:[Movie] = []
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.loadNowPlaying()

        // Do any additional setup after loading the view.
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
        cell.titleLabel!.text = movie.title
        cell.descriptionLabel!.text = movie.overview!
        cell.posterImageView.setImageWith(movieUrl)
        return cell
    }
    
    func loadNowPlaying() {
        MovieService.fetchNowPlaying(successCallBack: { (data) in
            let results = data["results"] as! [NSDictionary]
            print (results)
            self.movies = results.map { (movie) -> Movie in
                return Movie(fromDict: movie)
            }
            self.tableView.reloadData()
            
        }) { (error) in
            print (error?.localizedDescription ?? "")
        }
        
    }

}
