//
//  NetworkManager.swift
//  SenseiTalk
//
//  Created by Yuta Fujii on 2022/01/11.
//

import Foundation
import Alamofire
import SwiftyJSON

protocol DoneJsonProtocol{
    func doneJsonAnalytics(newsContentsArray:[NewsContentsModel])
    func errorString(errotMessage:String)
}

class NetworkManager{
    
    //シングルトン
    static let shared = NetworkManager()
    private let baseURL = "https://newsapi.org/v2/top-headlines?country=jp&apiKey="
    private let apiKey = "b13b44a1cca8430eb73c0c04c44c35e1"
    //https://newsapi.org/v2/top-headlines?country=jp&apiKey=b13b44a1cca8430eb73c0c04c44c35e1
    //キャッシュを宣言
    let cache = NSCache<NSString, UIImage>()
    var newsContentsArray = [NewsContentsModel]()
    var doneJsonProtocol:DoneJsonProtocol? = nil
    
    
    func analyticsStart(){
        
        var urlString = baseURL + apiKey
        
        let encordeUrlString:String = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        AF.request(encordeUrlString, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON {
            (response) in
            
            guard let data = response.data else {
                self.doneJsonProtocol?.errorString(errotMessage: FetchErrors.noResult.title)
                return
            }
            
            switch response.result{
            
            case .success:
                do {
                    let json:JSON = try JSON(data: response.data!)
                    
                    
                    let totalResults = json["totalResults"].int
                    
                    for i in 0...totalResults! - 1{
                       
                        if let title = json["articles"][i]["title"].string,let url = json["articles"][i]["url"].string,let urlToImage = json["articles"][i]["urlToImage"].string,let publishedAt = json["articles"][i]["publishedAt"].string{
                            
                            let newsContents = NewsContentsModel(title: title, url: url, urlToImage: urlToImage, publishedAt: publishedAt)
                            self.newsContentsArray.append(newsContents)
                        }
                    }
                    self.doneJsonProtocol?.doneJsonAnalytics(newsContentsArray: self.newsContentsArray)
                    
                }catch{
                    self.doneJsonProtocol?.errorString(errotMessage: FetchErrors.someError.title)
                }
                
            case .failure(_):
                self.doneJsonProtocol?.errorString(errotMessage: FetchErrors.someError.title)
                break
            }
         }
    }

    
    
}
