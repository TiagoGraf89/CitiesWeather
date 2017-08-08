//
//  WeatherAPI.swift
//  MultipleTargets
//
//  Created by TIAGO AUGUSTO GRAF on 12/11/16.
//  Copyright © 2016 TIAGO AUGUSTO GRAF. All rights reserved.
//

import UIKit

class WeatherAPI: NSObject {

    func getURL(_ city: NSString) -> NSURL? {
        let requestURL = NSURL(string: "http://api.openweathermap.org/data/2.5/weather?APPID=c483528d377fb6113f8499fb7a412dd5&q="+city.addingPercentEncoding(withAllowedCharacters: CharacterSet.alphanumerics)!)

        return requestURL
    }
    
    func loadData(_ city:String, _ completion: @escaping (_ item: WeatherItem?, _ error: NSError?) -> Void) {
        guard let loadURL = getURL(city as NSString) else {
            DispatchQueue.main.async {
                completion(nil, nil)
            }
            return
        }
        
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(url: loadURL as URL)
        let session = URLSession.shared
        session.dataTask(with: urlRequest as URLRequest, completionHandler: { (data, response, error) in
            if let error = error {
                DispatchQueue.main.async {
                    completion(nil, error as NSError?)
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, nil)
                }
                return
            }
            
            let i = WeatherItem(data: data)
            DispatchQueue.main.async {
                completion(i, nil)
            }
        }).resume()
     }
    
}

class WeatherItem: NSObject {
    var name : String = ""
    var desc : String = ""
    var lat : Double = 0
    var lon : Double = 0
    
    init(data: Data) {
        super.init()
        
        do{
            let dict: NSDictionary = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary

            let city = dict.value(forKey: "name") as! String
            let coord = dict.value(forKey: "coord") as! NSDictionary
            self.lat = coord.value(forKey: "lat") as! Double
            self.lon = coord.value(forKey: "lon") as! Double
            self.name = city
            let weather = dict.value(forKey: "weather") as! NSArray
            let subweather = weather[0] as! NSDictionary
            let d = subweather.value(forKey: "description") as! String
            self.desc = d

            
        }catch {
            print("Error with Json: \(error)")
        }

    }
}
