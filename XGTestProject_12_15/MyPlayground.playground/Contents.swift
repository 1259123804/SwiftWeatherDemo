//: Playground - noun: a place where people can play

import UIKit
import Foundation

var url = NSURL.init(string: "http://www.weather.com.cn/data/sk/101010100.html");
var data = NSData.init(contentsOf: url as! URL);
var str = NSString(data: data as! Data, encoding: String.Encoding.utf8.rawValue);

do {
    
    var json : Any = try JSONSerialization.jsonObject(with: data as! Data, options: JSONSerialization.ReadingOptions.allowFragments);

    var weatherInfo = (json as AnyObject).object(forKey: "weatherinfo");
    
    var city = (weatherInfo as AnyObject)["weatherinfo"];
    
    
}catch{
    
    print("error");
}

