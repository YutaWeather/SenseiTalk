//
//  STNewsManager.swift
//  SenseiTalk
//
//  Created by Yuta Fujii on 2022/01/31.
//

import Foundation
import Alamofire


class STNewsManager{
    
    private let baseURL = "https://newsapi.org/v2/top-headlines?country=jp&apiKey="
    var setUpUrl = "https://newsapi.org/v2/top-headlines?pageSize=20&country=jp&apiKey="

    //キャッシュを宣言
    let cache = NSCache<NSString, UIImage>()
    var newsContentsModel:NewsContentsModel?
    var categoryNewsContentsModel:NewsContentsModel?
    
    func analyticsStart(categoryURL:String,completed:@escaping(String?) -> Void){

        let urlString = baseURL + apiKey
        if categoryURL.isEmpty != true{
            
            setUpUrl = setUpUrl + apiKey + categoryURL
            guard let url = URL(string: setUpUrl) else { return }
            URLSession.shared.dataTask(with: url) { data, request, error in
                
                guard let data = data else { return }
            
                do{
                    self.newsContentsModel = try JSONDecoder().decode(NewsContentsModel.self, from: data)
                    
                    completed(nil)
                }catch let jsonError{
                    print(jsonError)
                }
                
            }.resume()
            
        }else{
            setUpUrl = urlString
            guard let url = URL(string: setUpUrl) else { return }
            URLSession.shared.dataTask(with: url) { data, request, error in
                
                guard let data = data else { return }
            
                do{
                    self.categoryNewsContentsModel = try JSONDecoder().decode(NewsContentsModel.self, from: data)
                    
                    completed(nil)
                }catch let jsonError{
                    print(jsonError)
                }
                
            }.resume()
        }
        

        
    }
    
}
