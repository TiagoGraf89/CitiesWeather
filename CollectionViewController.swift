//
//  CollectionViewController.swift
//  MultipleTargets
//
//  Created by TIAGO AUGUSTO GRAF on 05/11/16.
//  Copyright © 2016 TIAGO AUGUSTO GRAF. All rights reserved.
//

import UIKit

class CollectionViewController: UICollectionViewController {

    fileprivate let reuseIdentifier = "weatherCell"
    fileprivate var items = [WeatherItem]()
    fileprivate let api = WeatherAPI()
    
    func itemForIndexPath(indexPath: IndexPath) -> WeatherItem? {
        return items[(indexPath as NSIndexPath).section]
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.items.removeAll()
        
        if textField.text == "" {
            return false;
        }
        
        // 1
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        textField.addSubview(activityIndicator)
        activityIndicator.frame = textField.bounds
        activityIndicator.startAnimating()
        
        

        let city = textField.text!

        // Get Weather JSON Object
        
        api.loadData(city){ result, error in
            activityIndicator.removeFromSuperview()
            self.items.insert(result!, at: 0)
            self.collectionView?.reloadData()
        }
        
        
        textField.text = nil
        textField.resignFirstResponder()
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? MapsViewController {
            
            if segue.identifier == "map" {
                destination.item = itemForIndexPath(indexPath: (self.collectionView!.indexPathsForSelectedItems![0]))
            }
        }
    }

    //1
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //2
    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    //3
    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //1
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
                                                      for: indexPath) as? WeatherCell
        {
            if let item = itemForIndexPath(indexPath: indexPath)
            {
                cell.textName.text = item.name
                cell.textDesc.text = item.desc
            }
            return cell
            
        }

        return UICollectionViewCell()
    }
}
