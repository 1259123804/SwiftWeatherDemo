//
//  ViewController.swift
//  XGTestProject_12_15
//
//  Created by 李小光 on 16/12/15.
//  Copyright © 2016年 李小光. All rights reserved.
//

import UIKit

class ViewController: UIViewController, XMLParserDelegate {

    @IBAction func getWeatherClick(_ sender: UIButton) {
        
        getWeather();
        
    }
    @IBOutlet var cityTF: UITextField!
    @IBOutlet var weatherLabel: UILabel!
    @IBOutlet var getWeatherBtn: UIButton!
    
    var cityDictionary = ["北京": 101010100, "杭州": 101210101, "上海": 101020100, "郑州": 101180101];
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    var myCity : City? = nil;
    var cityArray = [City]();
    var currentElement : String? = nil;
    
    func getWeather(){
        
        if let cityName = cityTF.text{
            
            if let code = cityDictionary[cityName]{
                
                requestForWeather(codeStr: code);
                
            }else{
                
                requestForCityInfo(cityName: cityName);
            }
            cityTF.text = "";
        }else{
            
            print("请输入要查询的城市");
        }
    }
    
    func requestForCityInfo(cityName: String){
        
        
        let str = "http://mobile.weather.com.cn/js/citylist.xml";
        
        let url = NSURL(string: str);
        let xml =  XMLParser.init(contentsOf: url as! URL);
        xml?.delegate = self;
        xml?.parse();
        
    }
    
    func parserDidStartDocument(_ parser: XMLParser) {
        
        print("parserDidStartDocument...");
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        currentElement = elementName;

        if currentElement == "d" {
            
            myCity = City(d1: "", d2: "", d3: "", d4: "");
            
            let keyArr = attributeDict.keys;
            
            for str in keyArr{
                
                switch str {
                case "d1":
                    
                    if let d1 = attributeDict[str]{
                        
                        myCity?.d1 = d1;
                    }
                    
                case "d2":
                    
                    if let d2 = attributeDict[str]{
                        
                        myCity?.d2 = d2;
                        
                    }
                    
                case "d3":
                    
                    if let d3 = attributeDict[str]{
                        
                        myCity?.d3 = d3;
                    }
                    
                case "d4":
                    
                    if let d4 = attributeDict[str]{
                        
                        myCity?.d4 = d4;
                    }
                    
                default:
                    
                    break;
                }
            }
            
            
        }
    }
    
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        if elementName == "d" {
            
            cityArray.append(myCity!);
        }
        currentElement = "";
    }
    
    
    func parserDidEndDocument(_ parser: XMLParser) {
        
        print("parserDidEndDocument...");
        
        for city in cityArray{
            
            if city.d2 == cityTF.text{
                
                myCity = city;
                requestForWeather(codeStr: Int((myCity?.d1)!)!);
            }
        }
    }
    
    func requestForWeather(codeStr: Int){
        
        //获取天气详情
        let str = "http://www.weather.com.cn/data/cityinfo/\(codeStr).html";
        
        let url = NSURL(string: str);
        
        let data = NSData(contentsOf: url as! URL);
        
        do{
            
            let json : AnyObject  = try JSONSerialization.jsonObject(with: data! as Data, options: JSONSerialization.ReadingOptions.allowFragments) as AnyObject;
            
            let weatherInfo = json["weatherinfo"] as AnyObject;
            var dict = [String: AnyObject] ();
            dict = weatherInfo as! [String : AnyObject];
            print(weatherInfo);
            let city = dict["city"]!;
            let maxTemp = dict["temp1"]!;
            let minTemp = dict["temp2"]!;
            let weather = dict["weather"]!;
            
            weatherLabel.text =  "城市:\(city)\n 最高温度:\(maxTemp)\n 最低温度:\(minTemp)\n 天气:\(weather)\n"
            
        }catch{
            
            print("error");
        }
    }
    
    class City{
        
        var d1, d2, d3, d4 : String;
        init(d1: String, d2: String, d3: String, d4: String) {
            
            self.d1 = d1;
            self.d2 = d2;
            self.d3 = d3;
            self.d4 = d4;
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


