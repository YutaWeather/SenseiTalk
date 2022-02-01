//
//  STNewsManager.swift
//  SenseiTalk
//
//  Created by Yuta Fujii on 2022/01/31.
//

import Foundation
import Alamofire


class STNewsManager{
    
    /*
     https://newsapi.org/v2/everything?q=apple&from=2022-01-30&to=2022-01-30&sortBy=popularity&apiKey=b13b44a1cca8430eb73c0c04c44c35e1
     */
    
//    private let categoryArray = ["&category=business","&category=entertainment"]
    //
    private let baseURL = "https://newsapi.org/v2/top-headlines?country=jp&apiKey="
    private let apiKey = "b13b44a1cca8430eb73c0c04c44c35e1"
    
//    private let categoryArray = ["&category=business","&category=entertainment"]
    var setUpUrl = "https://newsapi.org/v2/top-headlines?pageSize=20&country=jp&apiKey="
  //https://newsapi.org/v2/top-headlines?country=jp&pageSize=5&category=sports&apiKey=b13b44a1cca8430eb73c0c04c44c35e1

    //キャッシュを宣言
    let cache = NSCache<NSString, UIImage>()
    var newsContentsModel:NewsContentsModel?
    var categoryNewsContentsModel:NewsContentsModel?
    
    func analyticsStart(categoryURL:String,completed:@escaping(String?) -> Void){

        let urlString = baseURL + apiKey
//        var setUpUrl = String()
        
      
        if categoryURL.isEmpty != true{
            
            setUpUrl = setUpUrl + apiKey + categoryURL
            print(setUpUrl)
            guard let url = URL(string: setUpUrl) else { return }
            URLSession.shared.dataTask(with: url) { data, request, error in
                
                guard let data = data else { return }
            
                do{
                    print(self.newsContentsModel.debugDescription)
                    self.newsContentsModel = try JSONDecoder().decode(NewsContentsModel.self, from: data)
                    
                    completed(nil)
                }catch let jsonError{
                    print(jsonError)
                }
                
            }.resume()
            
        }else{
            setUpUrl = urlString
            print(setUpUrl)
            guard let url = URL(string: setUpUrl) else { return }
            URLSession.shared.dataTask(with: url) { data, request, error in
                
                guard let data = data else { return }
            
                do{
                    print(self.categoryNewsContentsModel.debugDescription)
                    self.categoryNewsContentsModel = try JSONDecoder().decode(NewsContentsModel.self, from: data)
                    
                    completed(nil)
                }catch let jsonError{
                    print(jsonError)
                }
                
            }.resume()
        }
        

        
    }
    
}
