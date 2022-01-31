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
    private let apiKey = "b13b44a1cca8430eb73c0c04c44c35e1"
    //https://newsapi.org/v2/top-headlines?country=jp&apiKey=b13b44a1cca8430eb73c0c04c44c35e1
    //キャッシュを宣言
    let cache = NSCache<NSString, UIImage>()
    var newsContentsModel:NewsContentsModel?
    
    func analyticsStart(completed:@escaping(String?) -> Void){

        let urlString = baseURL + apiKey
        
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { data, request, error in
            
            guard let data = data else { return }
        
            do{
                
                self.newsContentsModel = try JSONDecoder().decode(NewsContentsModel.self, from: data)
                
                completed(nil)
            }catch let jsonError{
                print(jsonError)
            }
            
        }.resume()
        
    }
    
}
