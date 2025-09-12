//
//  Objects.swift
//  OneTV
//
//  Created by Botan Amedi on 06/03/2025.
//


import Foundation
import Alamofire
import SwiftyJSON
import AlertToast
import RealmSwift
import Drops



class openCartApi{
    static var  token = UserDefaults.standard.string(forKey: "token") ?? ""
    static var  Lang = UserDefaults.standard.string(forKey: "langs") ?? ""
    let IMAGEURL = "https://iq-flowers.com/api/"
    let URL = "https://iq-flowers.com/api/";
    let APP_TITLE = "ONE TV"
}
let API = openCartApi();

let APP_TITLE = "One TV"




func showDrop(title: String, message: String) {
    let drop = Drop(
        title: title,
        subtitle: message,
        icon: UIImage(named: "attention"),
        action: .init {
            print("Drop tapped")
            Drops.hideCurrent()
        },
        position: .top,
        duration: 3.0,
        accessibility: "Alert: Title, Subtitle"
    )
    Drops.show(drop)
}




class SlidesObjectAPI {
    static var window: UIWindow?
    static func GetSlideImage(completion :@escaping (_ SlideImage : SliderResponse)->()){
        let stringUrl = URL(string: "https://one-tv.net/api/sliders");

        AF.request(stringUrl!, method: .get).responseData { response in
            switch response.result
            {
            case .success:
                let jsonData = JSON(response.data ?? "")
                //print(jsonData)
                let status = jsonData["status"].stringValue
                let message = jsonData["message"]
                let data = jsonData["data"]
                let remark = jsonData["remark"].stringValue
                let sliders = data["sliders"].arrayValue
                let landscapePath = data["landscape_path"].stringValue
                let messageSuccess = message["success"].arrayValue
                let success = messageSuccess.map { $0.stringValue }
                let messageObj = Message(success: success)
                var dataObj = DataClass(sliders: [], landscapePath: landscapePath)
                var sliderArray = [Slider]()
                for slider in sliders {
                    let id = slider["id"].intValue
                    let itemId = slider["item_id"].intValue
                    let image = slider["image"].stringValue
                    let image_png = slider["image_png"].stringValue
                    let captionShow = slider["caption_show"].intValue
                    let status = slider["status"].intValue
                    let createdAt = slider["created_at"].stringValue
                    let updatedAt = slider["updated_at"].stringValue
                    let item = slider["item"]
                       let itemObj = Item(
                            id: item["id"].intValue,
                            categoryId: item["categoryId"].intValue,
                            subCategoryId: item["subCategoryId"].intValue,
                            slug: item["slug"].stringValue,
                            title: item["title"].stringValue,
                            previewText: item["previewText"].stringValue,
                            description: item["description"].stringValue,
                            team: Team(director: item["team"]["director"].stringValue,
                                       producer: item["team"]["producer"].stringValue,
                                       casts: item["team"]["casts"].stringValue,
                                       genres: item["team"]["genres"].stringValue,
                                       language: item["team"]["language"].stringValue),
                            image: ImagePaths(landscape: item["image"]["landscape"].stringValue,
                                              portrait: item["image"]["portrait"].stringValue),
                            itemType: item["itemType"].intValue,
                            status: item["status"].intValue,
                            single: item["single"].intValue,
                            trending: item["trending"].intValue,
                            featured: item["featured"].intValue,
                            version: item["version"].intValue,
                            tags: item["tags"].stringValue,
                            ratings: item["ratings"].stringValue,
                            view: item["view"].intValue,
                            isTrailer: item["isTrailer"].intValue,
                            rentPrice: item["rentPrice"].stringValue,
                            rentalPeriod: item["rentalPeriod"].intValue,
                            excludePlan: item["excludePlan"].intValue,
                            createdAt: item["createdAt"].stringValue,
                            updatedAt: item["updatedAt"].stringValue,
                            category: Category(id: item["category"]["id"].intValue,
                                               name: item["category"]["name"].stringValue,
                                               status: item["category"]["status"].intValue,
                                               createdAt: item["category"]["createdAt"].stringValue,
                                               updatedAt: item["category"]["updatedAt"].stringValue),
                            subCategory: SubCategory(id: item["subCategory"]["id"].intValue,
                                                     name: item["subCategory"]["name"].stringValue,
                                                     categoryId: item["subCategory"]["categoryId"].intValue,
                                                     status: item["subCategory"]["status"].intValue,
                                                     createdAt: item["subCategory"]["createdAt"].stringValue,
                                                     updatedAt: item["subCategory"]["updatedAt"].stringValue), isPaid: item["is_paid"].intValue,
                       awards: item["awards"].stringValue,
                            revenue: item["revenue"].stringValue,
                            budget: item["budget"].stringValue
                       )
                        
                    let sliderObj = Slider(id:id , itemId:itemId , image:image , captionShow :captionShow , status :status , createdAt :createdAt , updatedAt :updatedAt , item:itemObj, image_png: image_png)
                        
                        sliderArray.append(sliderObj)
                    
                    
                }
                dataObj = DataClass(sliders: sliderArray, landscapePath: landscapePath)
                let sliderResponse = SliderResponse(remark: remark, status: status, message: messageObj, data: dataObj)
                completion(sliderResponse)
                
            case .failure(let error):
                print(error);
            }
        }
    }
    
}


class SliderResponse {
    let remark: String
    let status: String
    let message: Message
    let data: DataClass
    
    init(remark: String, status: String, message: Message, data: DataClass) {
        self.remark = remark
        self.status = status
        self.message = message
        self.data = data
    }
}

class Message {
    let success: [String]
    
    init(success: [String]) {
        self.success = success
    }
}

class DataClass {
    let sliders: [Slider]
    let landscapePath: String
    
    init(sliders: [Slider], landscapePath: String) {
        self.sliders = sliders
        self.landscapePath = landscapePath
    }
}

class Slider {
    let id: Int
    let itemId: Int
    let image: String
    let image_png : String
    let captionShow: Int
    let status: Int
    let createdAt: String
    let updatedAt: String
    let item: Item
    var lable = ""
    
    init(id: Int, itemId: Int, image: String, captionShow: Int, status: Int,
         createdAt: String, updatedAt: String, item: Item, image_png: String) {
        self.id = id
        self.itemId = itemId
        self.image = image
        self.captionShow = captionShow
        self.status = status
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.item = item
        self.image_png = image_png
    }
}

class Item {
    let id: Int
    let categoryId: Int
    let subCategoryId: Int
    let slug: String
    let title: String
    let previewText: String
    let description: String
    let team: Team
    let image: ImagePaths
    let itemType: Int
    let status: Int
    let single: Int
    let trending: Int
    let featured: Int
    let version: Int
    let tags: String
    let ratings: String
    let view: Int
    let isTrailer: Int
    let rentPrice: String
    let rentalPeriod: Int
    let excludePlan: Int
    let createdAt: String
    let updatedAt: String
    let category: Category
    let subCategory: SubCategory
    let isPaid: Int
    
    let awards: String
    let revenue: String
    let budget: String
    
    init(id: Int, categoryId: Int, subCategoryId: Int, slug: String, title: String,
         previewText: String, description: String, team: Team, image: ImagePaths,
         itemType: Int, status: Int, single: Int, trending: Int, featured: Int,
         version: Int, tags: String, ratings: String, view: Int, isTrailer: Int,
         rentPrice: String, rentalPeriod: Int, excludePlan: Int, createdAt: String,
         updatedAt: String, category: Category, subCategory: SubCategory, isPaid: Int, awards: String, revenue: String, budget: String) {
        
        self.id = id
        self.categoryId = categoryId
        self.subCategoryId = subCategoryId
        self.slug = slug
        self.title = title
        self.previewText = previewText
        self.description = description
        self.team = team
        self.image = image
        self.itemType = itemType
        self.status = status
        self.single = single
        self.trending = trending
        self.featured = featured
        self.version = version
        self.tags = tags
        self.ratings = ratings
        self.view = view
        self.isTrailer = isTrailer
        self.rentPrice = rentPrice
        self.rentalPeriod = rentalPeriod
        self.excludePlan = excludePlan
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.category = category
        self.subCategory = subCategory
        self.isPaid = isPaid
        
        self.awards = awards
        self.revenue = revenue
        self.budget = budget
        
    }
}

class Team {
    let director: String
    let producer: String
    let casts: String
    let genres: String
    let language: String
    
    init(director: String, producer: String, casts: String, genres: String, language: String) {
        self.director = director
        self.producer = producer
        self.casts = casts
        self.genres = genres
        self.language = language
    }
}

class ImagePaths {
    let landscape: String
    let portrait: String
    
    init(landscape: String, portrait: String) {
        self.landscape = landscape
        self.portrait = portrait
    }
}

class Category {
    let id: Int
    let name: String
    let status: Int
    let createdAt: String
    let updatedAt: String
    
    init(id: Int, name: String, status: Int, createdAt: String, updatedAt: String) {
        self.id = id
        self.name = name
        self.status = status
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

class SubCategory {
    let id: Int
    let name: String
    let categoryId: Int
    let status: Int
    let createdAt: String
    let updatedAt: String
    
    init(id: Int, name: String, categoryId: Int, status: Int, createdAt: String, updatedAt: String) {
        self.id = id
        self.name = name
        self.categoryId = categoryId
        self.status = status
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}


// mark:- HomeTV
class LiveTVResponse {
    let remark: String
    let status: String
    let message: Message
    let data: DataClassHomeTV
    
    init(remark: String, status: String, message: Message, data: DataClassHomeTV) {
        self.remark = remark
        self.status = status
        self.message = message
        self.data = data
    }
}

class DataClassHomeTV {
    let televisions: [TelevisionData]
    let imagePath: String
    
    init(televisions: [TelevisionData], imagePath: String) {
        self.televisions = televisions
        self.imagePath = imagePath
    }
}

class TelevisionData {
    let currentPage: Int
    let data: [TelevisionCategory]
    let firstPageUrl: String
    let from: Int
    let lastPage: Int
    let lastPageUrl: String
    let links: [Link]
    let nextPageUrl: String?
    let path: String
    let perPage: Int
    let prevPageUrl: String?
    let to: Int
    let total: Int
    
    init(currentPage: Int, data: [TelevisionCategory], firstPageUrl: String, from: Int,
         lastPage: Int, lastPageUrl: String, links: [Link], nextPageUrl: String?,
         path: String, perPage: Int, prevPageUrl: String?, to: Int, total: Int) {
        self.currentPage = currentPage
        self.data = data
        self.firstPageUrl = firstPageUrl
        self.from = from
        self.lastPage = lastPage
        self.lastPageUrl = lastPageUrl
        self.links = links
        self.nextPageUrl = nextPageUrl
        self.path = path
        self.perPage = perPage
        self.prevPageUrl = prevPageUrl
        self.to = to
        self.total = total
    }
}

class Link {
    let url: String?
    let label: String
    let active: Bool
    
    init(url: String?, label: String, active: Bool) {
        self.url = url
        self.label = label
        self.active = active
    }
}

class TelevisionCategory {
    let id: Int
    let name: String
    let price: String
    let status: Int
    let createdAt: String
    let updatedAt: String
    let channels: [Channel]
    
    init(id: Int, name: String, price: String, status: Int, createdAt: String,
         updatedAt: String, channels: [Channel]) {
        self.id = id
        self.name = name
        self.price = price
        self.status = status
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.channels = channels
    }
}

class Channel {
    let id: Int
    let channelCategoryId: Int
    let title: String
    let description: String
    let image: String
    let url: String
    let status: Int
    let createdAt: String
    let updatedAt: String
    let isPaid: Int
    
    init(id: Int, channelCategoryId: Int, title: String, description: String,
         image: String, url: String, status: Int, createdAt: String, updatedAt: String, isPaid: Int) {
        self.id = id
        self.channelCategoryId = channelCategoryId
        self.title = title
        self.description = description
        self.image = image
        self.url = url
        self.status = status
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.isPaid = isPaid
    }
}



class GetHomeTVAPI {
    static var window: UIWindow?
    static func GetHomeTV(completion :@escaping (_ tvs : [LiveTVResponse],_ chanels: [TelevisionCategory])->()){
        let stringUrl = URL(string: "https://one-tv.net/api/live-television/show_all?page=1");

        AF.request(stringUrl!, method: .get).responseData { response in
            switch response.result
            {
            case .success:
                let jsonData = JSON(response.data ?? "")
                //print(jsonData)
                let status = jsonData["status"].stringValue
                let message = jsonData["message"]
                let data = jsonData["data"]
                let remark = jsonData["remark"].stringValue
                let televisions = data["televisions"]
                let televisionsChannels = televisions["data"].arrayValue
                let imagePath = data["image_path"].stringValue
                let messageSuccess = message["success"].arrayValue
                let success = messageSuccess.map { $0.stringValue }
                let messageObj = Message(success: success)
                var dataObj = DataClassHomeTV(televisions: [], imagePath: imagePath)
                var televisionArray = [TelevisionData]()
                var televisionObj = [TelevisionCategory]()
                
                let currentPage = televisions["current_page"].intValue
                let firstPageUrl = televisions["first_page_url"].stringValue
                let from = televisions["from"].intValue
                let lastPage = televisions["last_page"].intValue
                let lastPageUrl = televisions["last_page_url"].stringValue
                let nextPageUrl = televisions["next_page_url"].stringValue
                let path = televisions["path"].stringValue
                let perPage = televisions["per_page"].intValue
                let to = televisions["to"].intValue
                let total = televisions["total"].intValue
                
                for television in televisionsChannels {
                    var channelArray = [Channel]() //

                    let channels = television["channels"].arrayValue

                    for channel in channels {
                        let id = channel["id"].intValue
                        let channelCategoryId = channel["channel_category_id"].intValue
                        let title = channel["title"].stringValue
                        let description = channel["description"].stringValue
                        let image = channel["image"].stringValue
                        let url = channel["url"].stringValue
                        let status = channel["status"].intValue
                        let createdAt = channel["created_at"].stringValue
                        let updatedAt = channel["updated_at"].stringValue
                        let isPaid = channel["is_paid"].intValue

                        let channelObj = Channel(id: id, channelCategoryId: channelCategoryId, title: title, description: description, image: image, url: url, status: status, createdAt: createdAt, updatedAt: updatedAt, isPaid: isPaid)
                        channelArray.append(channelObj)
                    }

                    let id = television["id"].intValue
                    let name = television["name"].stringValue
                    let price = television["price"].stringValue
                    let status = television["status"].intValue
                    let createdAt = television["created_at"].stringValue
                    let updatedAt = television["updated_at"].stringValue

                    let tvCategory = TelevisionCategory(id: id, name: name, price: price, status: status, createdAt: createdAt, updatedAt: updatedAt, channels: channelArray)
                    televisionObj.append(tvCategory)
                }
                
                
                televisionArray.append(TelevisionData(currentPage: currentPage, data: televisionObj, firstPageUrl: firstPageUrl, from: from, lastPage: lastPage, lastPageUrl: lastPageUrl, links: [], nextPageUrl: nextPageUrl, path: path, perPage: perPage, prevPageUrl: "", to: to, total: total))
                dataObj = DataClassHomeTV(televisions: televisionArray, imagePath: imagePath)
                let liveTVResponse = LiveTVResponse(remark: remark, status: status, message: messageObj, data: dataObj)
                completion([liveTVResponse], televisionObj)
                
            case .failure(let error):
                print(error);
            }
        }
    }
    
    
    
    static func GetAllChannels(completion :@escaping (_ tvs : [LiveTVResponse],_ chanels: [Channel])->()){
        let stringUrl = URL(string: "https://one-tv.net/api/live-television/show_all");

        AF.request(stringUrl!, method: .get).responseData { response in
            switch response.result
            {
            case .success:
                let jsonData = JSON(response.data ?? "")
                print(jsonData)
                let status = jsonData["status"].stringValue
               
                let data = jsonData["data"]
                let remark = jsonData["remark"].stringValue
                let televisions = data["televisions"]
                let televisionsChannels = televisions["data"].arrayValue
                let imagePath = data["image_path"].stringValue
                let message = jsonData["message"]
                let messageSuccess = message["success"].arrayValue
                let success = messageSuccess.map { $0.stringValue }
                let messageObj = Message(success: success)
                var dataObj = DataClassHomeTV(televisions: [], imagePath: imagePath)
                var televisionArray = [TelevisionData]()
                var televisionObj = [TelevisionCategory]()
                let channelArray = [Channel]()
                
                let currentPage = televisions["current_page"].intValue
                let firstPageUrl = televisions["first_page_url"].stringValue
                let from = televisions["from"].intValue
                let lastPage = televisions["last_page"].intValue
                let lastPageUrl = televisions["last_page_url"].stringValue
                let nextPageUrl = televisions["next_page_url"].stringValue
                let path = televisions["path"].stringValue
                let perPage = televisions["per_page"].intValue
                let to = televisions["to"].intValue
                let total = televisions["total"].intValue
                
                for television in televisionsChannels {
                    var channelArray = [Channel]()

                    let channels = television["channels"].arrayValue

                    for channel in channels {
                        let id = channel["id"].intValue
                        let channelCategoryId = channel["channel_category_id"].intValue
                        let title = channel["title"].stringValue
                        let description = channel["description"].stringValue
                        let image = channel["image"].stringValue
                        let url = channel["url"].stringValue
                        let status = channel["status"].intValue
                        let createdAt = channel["created_at"].stringValue
                        let updatedAt = channel["updated_at"].stringValue
                        let isPaid = channel["is_paid"].intValue
                        let channelObj = Channel(id: id, channelCategoryId: channelCategoryId, title: title, description: description, image: image, url: url, status: status, createdAt: createdAt, updatedAt: updatedAt, isPaid: isPaid)
                        channelArray.append(channelObj)
                    }

                    let id = television["id"].intValue
                    let name = television["name"].stringValue
                    let price = television["price"].stringValue
                    let status = television["status"].intValue
                    let createdAt = television["created_at"].stringValue
                    let updatedAt = television["updated_at"].stringValue

                    let tvCategory = TelevisionCategory(id: id, name: name, price: price, status: status, createdAt: createdAt, updatedAt: updatedAt, channels: channelArray)
                    televisionObj.append(tvCategory)
                }
                
                
                televisionArray.append(TelevisionData(currentPage: currentPage, data: televisionObj, firstPageUrl: firstPageUrl, from: from, lastPage: lastPage, lastPageUrl: lastPageUrl, links: [], nextPageUrl: nextPageUrl, path: path, perPage: perPage, prevPageUrl: "", to: to, total: total))
                dataObj = DataClassHomeTV(televisions: televisionArray, imagePath: imagePath)
                let liveTVResponse = LiveTVResponse(remark: remark, status: status, message: messageObj, data: dataObj)
                completion([liveTVResponse], channelArray)
                
            case .failure(let error):
                print(error);
            }
        }
    }
    
    static func SearchAllChannels(text : String,completion :@escaping (_ tvs : [LiveTVResponse],_ chanels: [Channel])->()){
        let stringUrl = URL(string: "https://one-tv.net/api/live-television/show_all?title=\(text)");
        AF.request(stringUrl!, method: .get).responseData { response in
            switch response.result
            {
            case .success:
                let jsonData = JSON(response.data ?? "")
                print(jsonData)
                let status = jsonData["status"].stringValue
               
                let data = jsonData["data"]
                let remark = jsonData["remark"].stringValue
                let televisions = data["televisions"]
                let televisionsChannels = televisions["data"].arrayValue
                let imagePath = data["image_path"].stringValue
                let message = jsonData["message"]
                let messageSuccess = message["success"].arrayValue
                let success = messageSuccess.map { $0.stringValue }
                let messageObj = Message(success: success)
                var dataObj = DataClassHomeTV(televisions: [], imagePath: imagePath)
                var televisionArray = [TelevisionData]()
                var televisionObj = [TelevisionCategory]()
                let channelArray = [Channel]()
                
                let currentPage = televisions["current_page"].intValue
                let firstPageUrl = televisions["first_page_url"].stringValue
                let from = televisions["from"].intValue
                let lastPage = televisions["last_page"].intValue
                let lastPageUrl = televisions["last_page_url"].stringValue
                let nextPageUrl = televisions["next_page_url"].stringValue
                let path = televisions["path"].stringValue
                let perPage = televisions["per_page"].intValue
                let to = televisions["to"].intValue
                let total = televisions["total"].intValue
                
                for television in televisionsChannels {
                    var channelArray = [Channel]()

                    let channels = television["channels"].arrayValue

                    for channel in channels {
                        let id = channel["id"].intValue
                        let channelCategoryId = channel["channel_category_id"].intValue
                        let title = channel["title"].stringValue
                        let description = channel["description"].stringValue
                        let image = channel["image"].stringValue
                        let url = channel["url"].stringValue
                        let status = channel["status"].intValue
                        let createdAt = channel["created_at"].stringValue
                        let updatedAt = channel["updated_at"].stringValue
                        let isPaid = channel["is_paid"].intValue
                        let channelObj = Channel(id: id, channelCategoryId: channelCategoryId, title: title, description: description, image: image, url: url, status: status, createdAt: createdAt, updatedAt: updatedAt, isPaid: isPaid)
                        channelArray.append(channelObj)
                    }

                    let id = television["id"].intValue
                    let name = television["name"].stringValue
                    let price = television["price"].stringValue
                    let status = television["status"].intValue
                    let createdAt = television["created_at"].stringValue
                    let updatedAt = television["updated_at"].stringValue

                    let tvCategory = TelevisionCategory(id: id, name: name, price: price, status: status, createdAt: createdAt, updatedAt: updatedAt, channels: channelArray)
                    televisionObj.append(tvCategory)
                }
                
                
                televisionArray.append(TelevisionData(currentPage: currentPage, data: televisionObj, firstPageUrl: firstPageUrl, from: from, lastPage: lastPage, lastPageUrl: lastPageUrl, links: [], nextPageUrl: nextPageUrl, path: path, perPage: perPage, prevPageUrl: "", to: to, total: total))
                dataObj = DataClassHomeTV(televisions: televisionArray, imagePath: imagePath)
                let liveTVResponse = LiveTVResponse(remark: remark, status: status, message: messageObj, data: dataObj)
                completion([liveTVResponse], channelArray)
                
            case .failure(let error):
                print(error);
            }
        }
    }
    
}



//"episodes": [
//    {
//        "id": 1,
//        "item_id": 3,
//        "title": "Episode 1",
//        "image": "2025/04/05/67f13bd4b6b591743862740.jpg",
//        "status": 1,
//        "version": 0,
//        "created_at": "2025-04-05T14:19:00.000000Z",
//        "updated_at": "2025-04-05T14:19:00.000000Z"
//    }
//],


class RiklamObject{
    var id = 0
    var url = ""
    var image = ""
    
    init(id: Int, url: String, image: String) {
        self.id = id
        self.url = url
        self.image = image
    }
}


class Episode {
    let id: Int
    let itemId: Int
    let title: String
    let image: String
    let status: Int
    let version: Int
    let createdAt: String
    let updatedAt: String
    
    init(id: Int, itemId: Int, title: String, image: String, status: Int, version: Int, createdAt: String, updatedAt: String) {
        self.id = id
        self.itemId = itemId
        self.title = title
        self.image = image
        self.status = status
        self.version = version
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}


class HomeAPI {
    static var window: UIWindow?
    
    static func GetHomeFree(completion :@escaping (_ items : [Item],_ next_page_url: String)->()){
        let stringUrl = URL(string: "https://one-tv.net/api/section/free-zone?page=1");

        AF.request(stringUrl!, method: .get).responseData { response in
            switch response.result
            {
            case .success:
                let jsonData = JSON(response.data ?? "")
                print(jsonData)
                let data = jsonData["data"]["free_zone"]
                let free_zone = data["data"].arrayValue
                let next_page_url = data["next_page_url"].stringValue
                
                var FreeZone = [Item]()
                for free in free_zone {
                    let id = free["id"].intValue
                    let categoryId = free["category_id"].intValue
                    let subCategoryId = free["sub_category_id"].intValue
                    let slug = free["slug"].stringValue
                    let title = free["title"].stringValue
                    let previewText = free["preview_text"].stringValue
                    let description = free["description"].stringValue
                    let itemType = free["item_type"].intValue
                    let status = free["status"].intValue
                    let single = free["single"].intValue
                    let trending = free["trending"].intValue
                    let featured = free["featured"].intValue
                    let version = free["version"].intValue
                    let tags = free["tags"].stringValue
                    let ratings = free["ratings"].stringValue
                    let view = free["view"].intValue
                    let isTrailer = free["is_trailer"].intValue
                    let rentPrice = free["rent_price"].stringValue
                    let rentalPeriod = free["rental_period"].intValue
                    let excludePlan = free["exclude_plan"].intValue
                    let createdAt = free["created_at"].stringValue
                    let updatedAt = free["updated_at"].stringValue
                    let ispaid = free["is_paid"].intValue
                    let awards = free["awards"].stringValue
                    let revenue = free["revenue"].stringValue
                    let budget = free["budget"].stringValue
                    let images = ImagePaths(landscape: free["image"]["landscape"].stringValue, portrait: free["image"]["portrait"].stringValue)
                    let team = Team(director: free["team"]["director"].stringValue, producer: free["team"]["producer"].stringValue, casts: free["team"]["casts"].stringValue, genres: free["team"]["genres"].stringValue, language: free["team"]["language"].stringValue)
                    let category = Category(id: free["category"]["id"].intValue, name: free["category"]["name"].stringValue, status: free["category"]["status"].intValue, createdAt: free["category"]["created_at"].stringValue, updatedAt: free["category"]["updated_at"].stringValue)
                    let subCategory = SubCategory(id: free["sub_category"]["id"].intValue, name: free["sub_category"]["name"].stringValue, categoryId: free["sub_category"]["category_id"].intValue, status: free["sub_category"]["status"].intValue, createdAt: free["sub_category"]["created_at"].stringValue, updatedAt: free["sub_category"]["updated_at"].stringValue)

                    let freeZone = Item(id: id, categoryId: categoryId, subCategoryId: subCategoryId, slug: slug, title: title, previewText: previewText, description: description, team: team, image: images, itemType: itemType, status: status, single: single, trending: trending, featured: featured, version: version, tags: tags, ratings: ratings, view: view, isTrailer: isTrailer, rentPrice: rentPrice, rentalPeriod: rentalPeriod, excludePlan: excludePlan, createdAt: createdAt, updatedAt: updatedAt, category: category, subCategory: subCategory, isPaid: ispaid, awards: awards, revenue: revenue, budget: budget)
                    FreeZone.append(freeZone)
                }
                
                completion(FreeZone, next_page_url)
                
            case .failure(let error):
                print(error);
            }
        }
    }
    
    
    
    static func GetHomeFreeNext(url: String,completion :@escaping (_ items : [Item],_ next_page_url: String)->()){
        let stringUrl = URL(string: url);

        AF.request(stringUrl!, method: .get).responseData { response in
            switch response.result
            {
            case .success:
                let jsonData = JSON(response.data ?? "")
                print(jsonData)
                let data = jsonData["data"]["free_zone"]
                let free_zone = data["data"].arrayValue
                let next_page_url = data["next_page_url"].stringValue
                
                var FreeZone = [Item]()
                for free in free_zone {
                    let id = free["id"].intValue
                    let categoryId = free["category_id"].intValue
                    let subCategoryId = free["sub_category_id"].intValue
                    let slug = free["slug"].stringValue
                    let title = free["title"].stringValue
                    let previewText = free["preview_text"].stringValue
                    let description = free["description"].stringValue
                    let itemType = free["item_type"].intValue
                    let status = free["status"].intValue
                    let single = free["single"].intValue
                    let trending = free["trending"].intValue
                    let featured = free["featured"].intValue
                    let version = free["version"].intValue
                    let tags = free["tags"].stringValue
                    let ratings = free["ratings"].stringValue
                    let view = free["view"].intValue
                    let isTrailer = free["is_trailer"].intValue
                    let rentPrice = free["rent_price"].stringValue
                    let rentalPeriod = free["rental_period"].intValue
                    let excludePlan = free["exclude_plan"].intValue
                    let createdAt = free["created_at"].stringValue
                    let updatedAt = free["updated_at"].stringValue
                    let ispaid = free["is_paid"].intValue
                    let awards = free["awards"].stringValue
                    let revenue = free["revenue"].stringValue
                    let budget = free["budget"].stringValue
                    let images = ImagePaths(landscape: free["image"]["landscape"].stringValue, portrait: free["image"]["portrait"].stringValue)
                    let team = Team(director: free["team"]["director"].stringValue, producer: free["team"]["producer"].stringValue, casts: free["team"]["casts"].stringValue, genres: free["team"]["genres"].stringValue, language: free["team"]["language"].stringValue)
                    let category = Category(id: free["category"]["id"].intValue, name: free["category"]["name"].stringValue, status: free["category"]["status"].intValue, createdAt: free["category"]["created_at"].stringValue, updatedAt: free["category"]["updated_at"].stringValue)
                    let subCategory = SubCategory(id: free["sub_category"]["id"].intValue, name: free["sub_category"]["name"].stringValue, categoryId: free["sub_category"]["category_id"].intValue, status: free["sub_category"]["status"].intValue, createdAt: free["sub_category"]["created_at"].stringValue, updatedAt: free["sub_category"]["updated_at"].stringValue)

                    let freeZone = Item(id: id, categoryId: categoryId, subCategoryId: subCategoryId, slug: slug, title: title, previewText: previewText, description: description, team: team, image: images, itemType: itemType, status: status, single: single, trending: trending, featured: featured, version: version, tags: tags, ratings: ratings, view: view, isTrailer: isTrailer, rentPrice: rentPrice, rentalPeriod: rentalPeriod, excludePlan: excludePlan, createdAt: createdAt, updatedAt: updatedAt, category: category, subCategory: subCategory, isPaid: ispaid, awards: awards, revenue: revenue, budget: budget)
                    FreeZone.append(freeZone)
                }
                
                completion(FreeZone, next_page_url)
                
            case .failure(let error):
                print(error);
            }
        }
    }
    
    static func GetFiltterMovies(url: URL, completion :@escaping (_ items : [Item])->()){
        AF.request(url, method: .get).responseData { response in
            switch response.result
            {
            case .success:
                let jsonData = JSON(response.data ?? "")
                print(jsonData)
                let data = jsonData["data"]["movies"]
                let free_zone = data["data"].arrayValue
                
                var FreeZone = [Item]()
                for free in free_zone {
                    let id = free["id"].intValue
                    let categoryId = free["category_id"].intValue
                    let subCategoryId = free["sub_category_id"].intValue
                    let slug = free["slug"].stringValue
                    let title = free["title"].stringValue
                    let previewText = free["preview_text"].stringValue
                    let description = free["description"].stringValue
                    let itemType = free["item_type"].intValue
                    let status = free["status"].intValue
                    let single = free["single"].intValue
                    let trending = free["trending"].intValue
                    let featured = free["featured"].intValue
                    let version = free["version"].intValue
                    let tags = free["tags"].stringValue
                    let ratings = free["ratings"].stringValue
                    let view = free["view"].intValue
                    let isTrailer = free["is_trailer"].intValue
                    let rentPrice = free["rent_price"].stringValue
                    let rentalPeriod = free["rental_period"].intValue
                    let excludePlan = free["exclude_plan"].intValue
                    let createdAt = free["created_at"].stringValue
                    let updatedAt = free["updated_at"].stringValue
                    let ispaid = free["is_paid"].intValue
                    let awards = free["awards"].stringValue
                    let revenue = free["revenue"].stringValue
                    let budget = free["budget"].stringValue
                    let images = ImagePaths(landscape: free["image"]["landscape"].stringValue, portrait: free["image"]["portrait"].stringValue)
                    let team = Team(director: free["team"]["director"].stringValue, producer: free["team"]["producer"].stringValue, casts: free["team"]["casts"].stringValue, genres: free["team"]["genres"].stringValue, language: free["team"]["language"].stringValue)
                    let category = Category(id: free["category"]["id"].intValue, name: free["category"]["name"].stringValue, status: free["category"]["status"].intValue, createdAt: free["category"]["created_at"].stringValue, updatedAt: free["category"]["updated_at"].stringValue)
                    let subCategory = SubCategory(id: free["sub_category"]["id"].intValue, name: free["sub_category"]["name"].stringValue, categoryId: free["sub_category"]["category_id"].intValue, status: free["sub_category"]["status"].intValue, createdAt: free["sub_category"]["created_at"].stringValue, updatedAt: free["sub_category"]["updated_at"].stringValue)

                    let freeZone = Item(id: id, categoryId: categoryId, subCategoryId: subCategoryId, slug: slug, title: title, previewText: previewText, description: description, team: team, image: images, itemType: itemType, status: status, single: single, trending: trending, featured: featured, version: version, tags: tags, ratings: ratings, view: view, isTrailer: isTrailer, rentPrice: rentPrice, rentalPeriod: rentalPeriod, excludePlan: excludePlan, createdAt: createdAt, updatedAt: updatedAt, category: category, subCategory: subCategory, isPaid: ispaid, awards: awards, revenue: revenue, budget: budget)
                    FreeZone.append(freeZone)
                }
                
                completion(FreeZone)
                
            case .failure(let error):
                print(error);
            }
        }
    }
    
    
    static func GetFiltterSearies(url: URL, completion :@escaping (_ items : [Item])->()){
        AF.request(url, method: .get).responseData { response in
            switch response.result
            {
            case .success:
                let jsonData = JSON(response.data ?? "")
                print(jsonData)
                let data = jsonData["data"]["episodes"]
                let free_zone = data["data"].arrayValue
                
                var FreeZone = [Item]()
                for free in free_zone {
                    let id = free["id"].intValue
                    let categoryId = free["category_id"].intValue
                    let subCategoryId = free["sub_category_id"].intValue
                    let slug = free["slug"].stringValue
                    let title = free["title"].stringValue
                    let previewText = free["preview_text"].stringValue
                    let description = free["description"].stringValue
                    let itemType = free["item_type"].intValue
                    let status = free["status"].intValue
                    let single = free["single"].intValue
                    let trending = free["trending"].intValue
                    let featured = free["featured"].intValue
                    let version = free["version"].intValue
                    let tags = free["tags"].stringValue
                    let ratings = free["ratings"].stringValue
                    let view = free["view"].intValue
                    let isTrailer = free["is_trailer"].intValue
                    let rentPrice = free["rent_price"].stringValue
                    let rentalPeriod = free["rental_period"].intValue
                    let excludePlan = free["exclude_plan"].intValue
                    let createdAt = free["created_at"].stringValue
                    let updatedAt = free["updated_at"].stringValue
                    let ispaid = free["is_paid"].intValue
                    let awards = free["awards"].stringValue
                    let revenue = free["revenue"].stringValue
                    let budget = free["budget"].stringValue
                    let images = ImagePaths(landscape: free["image"]["landscape"].stringValue, portrait: free["image"]["portrait"].stringValue)
                    let team = Team(director: free["team"]["director"].stringValue, producer: free["team"]["producer"].stringValue, casts: free["team"]["casts"].stringValue, genres: free["team"]["genres"].stringValue, language: free["team"]["language"].stringValue)
                    let category = Category(id: free["category"]["id"].intValue, name: free["category"]["name"].stringValue, status: free["category"]["status"].intValue, createdAt: free["category"]["created_at"].stringValue, updatedAt: free["category"]["updated_at"].stringValue)
                    let subCategory = SubCategory(id: free["sub_category"]["id"].intValue, name: free["sub_category"]["name"].stringValue, categoryId: free["sub_category"]["category_id"].intValue, status: free["sub_category"]["status"].intValue, createdAt: free["sub_category"]["created_at"].stringValue, updatedAt: free["sub_category"]["updated_at"].stringValue)

                    let freeZone = Item(id: id, categoryId: categoryId, subCategoryId: subCategoryId, slug: slug, title: title, previewText: previewText, description: description, team: team, image: images, itemType: itemType, status: status, single: single, trending: trending, featured: featured, version: version, tags: tags, ratings: ratings, view: view, isTrailer: isTrailer, rentPrice: rentPrice, rentalPeriod: rentalPeriod, excludePlan: excludePlan, createdAt: createdAt, updatedAt: updatedAt, category: category, subCategory: subCategory, isPaid: ispaid, awards: awards, revenue: revenue, budget: budget)
                    FreeZone.append(freeZone)
                }
                
                completion(FreeZone)
                
            case .failure(let error):
                print(error);
            }
        }
    }
    
    static func GetMovies(completion :@escaping (_ items : [Item],_ next_page_url: String)->()){
        let stringUrl = URL(string: "https://one-tv.net/api/movies");

        AF.request(stringUrl!, method: .get).responseData { response in
            switch response.result
            {
            case .success:
                let jsonData = JSON(response.data ?? "")
                print(jsonData)
                let data = jsonData["data"]["movies"]
                let free_zone = data["data"].arrayValue
                let next_page_url = data["next_page_url"].stringValue
                
                var FreeZone = [Item]()
                for free in free_zone {
                    let id = free["id"].intValue
                    let categoryId = free["category_id"].intValue
                    let subCategoryId = free["sub_category_id"].intValue
                    let slug = free["slug"].stringValue
                    let title = free["title"].stringValue
                    let previewText = free["preview_text"].stringValue
                    let description = free["description"].stringValue
                    let itemType = free["item_type"].intValue
                    let status = free["status"].intValue
                    let single = free["single"].intValue
                    let trending = free["trending"].intValue
                    let featured = free["featured"].intValue
                    let version = free["version"].intValue
                    let tags = free["tags"].stringValue
                    let ratings = free["ratings"].stringValue
                    let view = free["view"].intValue
                    let isTrailer = free["is_trailer"].intValue
                    let rentPrice = free["rent_price"].stringValue
                    let rentalPeriod = free["rental_period"].intValue
                    let excludePlan = free["exclude_plan"].intValue
                    let createdAt = free["created_at"].stringValue
                    let updatedAt = free["updated_at"].stringValue
                    let ispaid = free["is_paid"].intValue
                    let awards = free["awards"].stringValue
                    let revenue = free["revenue"].stringValue
                    let budget = free["budget"].stringValue
                    let images = ImagePaths(landscape: free["image"]["landscape"].stringValue, portrait: free["image"]["portrait"].stringValue)
                    let team = Team(director: free["team"]["director"].stringValue, producer: free["team"]["producer"].stringValue, casts: free["team"]["casts"].stringValue, genres: free["team"]["genres"].stringValue, language: free["team"]["language"].stringValue)
                    let category = Category(id: free["category"]["id"].intValue, name: free["category"]["name"].stringValue, status: free["category"]["status"].intValue, createdAt: free["category"]["created_at"].stringValue, updatedAt: free["category"]["updated_at"].stringValue)
                    let subCategory = SubCategory(id: free["sub_category"]["id"].intValue, name: free["sub_category"]["name"].stringValue, categoryId: free["sub_category"]["category_id"].intValue, status: free["sub_category"]["status"].intValue, createdAt: free["sub_category"]["created_at"].stringValue, updatedAt: free["sub_category"]["updated_at"].stringValue)

                    let freeZone = Item(id: id, categoryId: categoryId, subCategoryId: subCategoryId, slug: slug, title: title, previewText: previewText, description: description, team: team, image: images, itemType: itemType, status: status, single: single, trending: trending, featured: featured, version: version, tags: tags, ratings: ratings, view: view, isTrailer: isTrailer, rentPrice: rentPrice, rentalPeriod: rentalPeriod, excludePlan: excludePlan, createdAt: createdAt, updatedAt: updatedAt, category: category, subCategory: subCategory, isPaid: ispaid, awards: awards, revenue: revenue, budget: budget)
                    FreeZone.append(freeZone)
                }
                
                completion(FreeZone, next_page_url)
                
            case .failure(let error):
                print(error);
            }
        }
    }
    
    
    static func GetMoviesNext(_ url: String, completion :@escaping (_ items : [Item],_ next_page_url: String)->()){
        let stringUrl = URL(string: url);

        AF.request(stringUrl!, method: .get).responseData { response in
            switch response.result
            {
            case .success:
                let jsonData = JSON(response.data ?? "")
                print(jsonData)
                let data = jsonData["data"]["movies"]
                let free_zone = data["data"].arrayValue
                let next_page_url = data["next_page_url"].stringValue
                var FreeZone = [Item]()
                for free in free_zone {
                    let id = free["id"].intValue
                    let categoryId = free["category_id"].intValue
                    let subCategoryId = free["sub_category_id"].intValue
                    let slug = free["slug"].stringValue
                    let title = free["title"].stringValue
                    let previewText = free["preview_text"].stringValue
                    let description = free["description"].stringValue
                    let itemType = free["item_type"].intValue
                    let status = free["status"].intValue
                    let single = free["single"].intValue
                    let trending = free["trending"].intValue
                    let featured = free["featured"].intValue
                    let version = free["version"].intValue
                    let tags = free["tags"].stringValue
                    let ratings = free["ratings"].stringValue
                    let view = free["view"].intValue
                    let isTrailer = free["is_trailer"].intValue
                    let rentPrice = free["rent_price"].stringValue
                    let rentalPeriod = free["rental_period"].intValue
                    let excludePlan = free["exclude_plan"].intValue
                    let createdAt = free["created_at"].stringValue
                    let updatedAt = free["updated_at"].stringValue
                    let ispaid = free["is_paid"].intValue
                    let awards = free["awards"].stringValue
                    let revenue = free["revenue"].stringValue
                    let budget = free["budget"].stringValue
                    let images = ImagePaths(landscape: free["image"]["landscape"].stringValue, portrait: free["image"]["portrait"].stringValue)
                    let team = Team(director: free["team"]["director"].stringValue, producer: free["team"]["producer"].stringValue, casts: free["team"]["casts"].stringValue, genres: free["team"]["genres"].stringValue, language: free["team"]["language"].stringValue)
                    let category = Category(id: free["category"]["id"].intValue, name: free["category"]["name"].stringValue, status: free["category"]["status"].intValue, createdAt: free["category"]["created_at"].stringValue, updatedAt: free["category"]["updated_at"].stringValue)
                    let subCategory = SubCategory(id: free["sub_category"]["id"].intValue, name: free["sub_category"]["name"].stringValue, categoryId: free["sub_category"]["category_id"].intValue, status: free["sub_category"]["status"].intValue, createdAt: free["sub_category"]["created_at"].stringValue, updatedAt: free["sub_category"]["updated_at"].stringValue)

                    let freeZone = Item(id: id, categoryId: categoryId, subCategoryId: subCategoryId, slug: slug, title: title, previewText: previewText, description: description, team: team, image: images, itemType: itemType, status: status, single: single, trending: trending, featured: featured, version: version, tags: tags, ratings: ratings, view: view, isTrailer: isTrailer, rentPrice: rentPrice, rentalPeriod: rentalPeriod, excludePlan: excludePlan, createdAt: createdAt, updatedAt: updatedAt, category: category, subCategory: subCategory, isPaid: ispaid, awards: awards, revenue: revenue, budget: budget)
                    FreeZone.append(freeZone)
                }
                
                completion(FreeZone, next_page_url)
                
            case .failure(let error):
                print(error);
            }
        }
    }
    
    
    
    static func SearchSeries(text:String,completion :@escaping (_ items : [Item])->()){
        let stringUrl = URL(string: "https://one-tv.net/api/episodes-filter?keyword=\(text)");

        AF.request(stringUrl!, method: .get).responseData { response in
            switch response.result
            {
            case .success:
                let jsonData = JSON(response.data ?? "")
                print(jsonData)
                let data = jsonData["data"]["episodes"]
                let free_zone = data["data"].arrayValue
                
                var FreeZone = [Item]()
                for free in free_zone {
                    let id = free["id"].intValue
                    let categoryId = free["category_id"].intValue
                    let subCategoryId = free["sub_category_id"].intValue
                    let slug = free["slug"].stringValue
                    let title = free["title"].stringValue
                    let previewText = free["preview_text"].stringValue
                    let description = free["description"].stringValue
                    let itemType = free["item_type"].intValue
                    let status = free["status"].intValue
                    let single = free["single"].intValue
                    let trending = free["trending"].intValue
                    let featured = free["featured"].intValue
                    let version = free["version"].intValue
                    let tags = free["tags"].stringValue
                    let ratings = free["ratings"].stringValue
                    let view = free["view"].intValue
                    let isTrailer = free["is_trailer"].intValue
                    let rentPrice = free["rent_price"].stringValue
                    let rentalPeriod = free["rental_period"].intValue
                    let excludePlan = free["exclude_plan"].intValue
                    let createdAt = free["created_at"].stringValue
                    let updatedAt = free["updated_at"].stringValue
                    let ispaid = free["is_paid"].intValue
                    let awards = free["awards"].stringValue
                    let revenue = free["revenue"].stringValue
                    let budget = free["budget"].stringValue
                    let images = ImagePaths(landscape: free["image"]["landscape"].stringValue, portrait: free["image"]["portrait"].stringValue)
                    let team = Team(director: free["team"]["director"].stringValue, producer: free["team"]["producer"].stringValue, casts: free["team"]["casts"].stringValue, genres: free["team"]["genres"].stringValue, language: free["team"]["language"].stringValue)
                    let category = Category(id: free["category"]["id"].intValue, name: free["category"]["name"].stringValue, status: free["category"]["status"].intValue, createdAt: free["category"]["created_at"].stringValue, updatedAt: free["category"]["updated_at"].stringValue)
                    let subCategory = SubCategory(id: free["sub_category"]["id"].intValue, name: free["sub_category"]["name"].stringValue, categoryId: free["sub_category"]["category_id"].intValue, status: free["sub_category"]["status"].intValue, createdAt: free["sub_category"]["created_at"].stringValue, updatedAt: free["sub_category"]["updated_at"].stringValue)

                    let freeZone = Item(id: id, categoryId: categoryId, subCategoryId: subCategoryId, slug: slug, title: title, previewText: previewText, description: description, team: team, image: images, itemType: itemType, status: status, single: single, trending: trending, featured: featured, version: version, tags: tags, ratings: ratings, view: view, isTrailer: isTrailer, rentPrice: rentPrice, rentalPeriod: rentalPeriod, excludePlan: excludePlan, createdAt: createdAt, updatedAt: updatedAt, category: category, subCategory: subCategory, isPaid: ispaid, awards: awards, revenue: revenue, budget: budget)
                    FreeZone.append(freeZone)
                }
                
                completion(FreeZone)
                
            case .failure(let error):
                print(error);
            }
        }
    }
    
    static func SearchMovies(text:String,completion :@escaping (_ items : [Item])->()){
        let stringUrl = URL(string: "https://one-tv.net/api/movies-filter?keyword=\(text)");

        AF.request(stringUrl!, method: .get).responseData { response in
            switch response.result
            {
            case .success:
                let jsonData = JSON(response.data ?? "")
                print(jsonData)
                let data = jsonData["data"]["movies"]
                let free_zone = data["data"].arrayValue
                
                var FreeZone = [Item]()
                for free in free_zone {
                    let id = free["id"].intValue
                    let categoryId = free["category_id"].intValue
                    let subCategoryId = free["sub_category_id"].intValue
                    let slug = free["slug"].stringValue
                    let title = free["title"].stringValue
                    let previewText = free["preview_text"].stringValue
                    let description = free["description"].stringValue
                    let itemType = free["item_type"].intValue
                    let status = free["status"].intValue
                    let single = free["single"].intValue
                    let trending = free["trending"].intValue
                    let featured = free["featured"].intValue
                    let version = free["version"].intValue
                    let tags = free["tags"].stringValue
                    let ratings = free["ratings"].stringValue
                    let view = free["view"].intValue
                    let isTrailer = free["is_trailer"].intValue
                    let rentPrice = free["rent_price"].stringValue
                    let rentalPeriod = free["rental_period"].intValue
                    let excludePlan = free["exclude_plan"].intValue
                    let createdAt = free["created_at"].stringValue
                    let updatedAt = free["updated_at"].stringValue
                    let ispaid = free["is_paid"].intValue
                    let awards = free["awards"].stringValue
                    let revenue = free["revenue"].stringValue
                    let budget = free["budget"].stringValue
                    let images = ImagePaths(landscape: free["image"]["landscape"].stringValue, portrait: free["image"]["portrait"].stringValue)
                    let team = Team(director: free["team"]["director"].stringValue, producer: free["team"]["producer"].stringValue, casts: free["team"]["casts"].stringValue, genres: free["team"]["genres"].stringValue, language: free["team"]["language"].stringValue)
                    let category = Category(id: free["category"]["id"].intValue, name: free["category"]["name"].stringValue, status: free["category"]["status"].intValue, createdAt: free["category"]["created_at"].stringValue, updatedAt: free["category"]["updated_at"].stringValue)
                    let subCategory = SubCategory(id: free["sub_category"]["id"].intValue, name: free["sub_category"]["name"].stringValue, categoryId: free["sub_category"]["category_id"].intValue, status: free["sub_category"]["status"].intValue, createdAt: free["sub_category"]["created_at"].stringValue, updatedAt: free["sub_category"]["updated_at"].stringValue)

                    let freeZone = Item(id: id, categoryId: categoryId, subCategoryId: subCategoryId, slug: slug, title: title, previewText: previewText, description: description, team: team, image: images, itemType: itemType, status: status, single: single, trending: trending, featured: featured, version: version, tags: tags, ratings: ratings, view: view, isTrailer: isTrailer, rentPrice: rentPrice, rentalPeriod: rentalPeriod, excludePlan: excludePlan, createdAt: createdAt, updatedAt: updatedAt, category: category, subCategory: subCategory, isPaid: ispaid, awards: awards, revenue: revenue, budget: budget)
                    FreeZone.append(freeZone)
                }
                
                completion(FreeZone)
                
            case .failure(let error):
                print(error);
            }
        }
    }
    
    
    
    
    
    static func GetSeries(completion :@escaping (_ items : [Item],_ next_page_url: String)->()){
        let stringUrl = URL(string: "https://one-tv.net/api/episodes");

        AF.request(stringUrl!, method: .get).responseData { response in
            switch response.result
            {
            case .success:
                let jsonData = JSON(response.data ?? "")
                print(jsonData)
                let data = jsonData["data"]["episodes"]
                let free_zone = data["data"].arrayValue
                let next_page_url = data["next_page_url"].stringValue
                var FreeZone = [Item]()
                for free in free_zone {
                    let id = free["id"].intValue
                    let categoryId = free["category_id"].intValue
                    let subCategoryId = free["sub_category_id"].intValue
                    let slug = free["slug"].stringValue
                    let title = free["title"].stringValue
                    let previewText = free["preview_text"].stringValue
                    let description = free["description"].stringValue
                    let itemType = free["item_type"].intValue
                    let status = free["status"].intValue
                    let single = free["single"].intValue
                    let trending = free["trending"].intValue
                    let featured = free["featured"].intValue
                    let version = free["version"].intValue
                    let tags = free["tags"].stringValue
                    let ratings = free["ratings"].stringValue
                    let view = free["view"].intValue
                    let isTrailer = free["is_trailer"].intValue
                    let rentPrice = free["rent_price"].stringValue
                    let rentalPeriod = free["rental_period"].intValue
                    let excludePlan = free["exclude_plan"].intValue
                    let createdAt = free["created_at"].stringValue
                    let updatedAt = free["updated_at"].stringValue
                    let ispaid = free["is_paid"].intValue
                    let awards = free["awards"].stringValue
                    let revenue = free["revenue"].stringValue
                    let budget = free["budget"].stringValue
                    let images = ImagePaths(landscape: free["image"]["landscape"].stringValue, portrait: free["image"]["portrait"].stringValue)
                    let team = Team(director: free["team"]["director"].stringValue, producer: free["team"]["producer"].stringValue, casts: free["team"]["casts"].stringValue, genres: free["team"]["genres"].stringValue, language: free["team"]["language"].stringValue)
                    let category = Category(id: free["category"]["id"].intValue, name: free["category"]["name"].stringValue, status: free["category"]["status"].intValue, createdAt: free["category"]["created_at"].stringValue, updatedAt: free["category"]["updated_at"].stringValue)
                    let subCategory = SubCategory(id: free["sub_category"]["id"].intValue, name: free["sub_category"]["name"].stringValue, categoryId: free["sub_category"]["category_id"].intValue, status: free["sub_category"]["status"].intValue, createdAt: free["sub_category"]["created_at"].stringValue, updatedAt: free["sub_category"]["updated_at"].stringValue)

                    let freeZone = Item(id: id, categoryId: categoryId, subCategoryId: subCategoryId, slug: slug, title: title, previewText: previewText, description: description, team: team, image: images, itemType: itemType, status: status, single: single, trending: trending, featured: featured, version: version, tags: tags, ratings: ratings, view: view, isTrailer: isTrailer, rentPrice: rentPrice, rentalPeriod: rentalPeriod, excludePlan: excludePlan, createdAt: createdAt, updatedAt: updatedAt, category: category, subCategory: subCategory, isPaid: ispaid, awards: awards, revenue: revenue, budget: budget)
                    FreeZone.append(freeZone)
                }
                
                completion(FreeZone, next_page_url)
                
            case .failure(let error):
                print(error);
            }
        }
    }
    
    
    
    static func GetSeriesNext(_ url: String, completion :@escaping (_ items : [Item],_ next_page_url: String)->()){
        let stringUrl = URL(string: url);

        AF.request(stringUrl!, method: .get).responseData { response in
            switch response.result
            {
            case .success:
                let jsonData = JSON(response.data ?? "")
                print(jsonData)
                let data = jsonData["data"]["episodes"]
                let free_zone = data["data"].arrayValue
                let next_page_url = data["next_page_url"].stringValue
                var FreeZone = [Item]()
                for free in free_zone {
                    let id = free["id"].intValue
                    let categoryId = free["category_id"].intValue
                    let subCategoryId = free["sub_category_id"].intValue
                    let slug = free["slug"].stringValue
                    let title = free["title"].stringValue
                    let previewText = free["preview_text"].stringValue
                    let description = free["description"].stringValue
                    let itemType = free["item_type"].intValue
                    let status = free["status"].intValue
                    let single = free["single"].intValue
                    let trending = free["trending"].intValue
                    let featured = free["featured"].intValue
                    let version = free["version"].intValue
                    let tags = free["tags"].stringValue
                    let ratings = free["ratings"].stringValue
                    let view = free["view"].intValue
                    let isTrailer = free["is_trailer"].intValue
                    let rentPrice = free["rent_price"].stringValue
                    let rentalPeriod = free["rental_period"].intValue
                    let excludePlan = free["exclude_plan"].intValue
                    let createdAt = free["created_at"].stringValue
                    let updatedAt = free["updated_at"].stringValue
                    let ispaid = free["is_paid"].intValue
                    let awards = free["awards"].stringValue
                    let revenue = free["revenue"].stringValue
                    let budget = free["budget"].stringValue
                    let images = ImagePaths(landscape: free["image"]["landscape"].stringValue, portrait: free["image"]["portrait"].stringValue)
                    let team = Team(director: free["team"]["director"].stringValue, producer: free["team"]["producer"].stringValue, casts: free["team"]["casts"].stringValue, genres: free["team"]["genres"].stringValue, language: free["team"]["language"].stringValue)
                    let category = Category(id: free["category"]["id"].intValue, name: free["category"]["name"].stringValue, status: free["category"]["status"].intValue, createdAt: free["category"]["created_at"].stringValue, updatedAt: free["category"]["updated_at"].stringValue)
                    let subCategory = SubCategory(id: free["sub_category"]["id"].intValue, name: free["sub_category"]["name"].stringValue, categoryId: free["sub_category"]["category_id"].intValue, status: free["sub_category"]["status"].intValue, createdAt: free["sub_category"]["created_at"].stringValue, updatedAt: free["sub_category"]["updated_at"].stringValue)

                    let freeZone = Item(id: id, categoryId: categoryId, subCategoryId: subCategoryId, slug: slug, title: title, previewText: previewText, description: description, team: team, image: images, itemType: itemType, status: status, single: single, trending: trending, featured: featured, version: version, tags: tags, ratings: ratings, view: view, isTrailer: isTrailer, rentPrice: rentPrice, rentalPeriod: rentalPeriod, excludePlan: excludePlan, createdAt: createdAt, updatedAt: updatedAt, category: category, subCategory: subCategory, isPaid: ispaid, awards: awards, revenue: revenue, budget: budget)
                    FreeZone.append(freeZone)
                }
                
                completion(FreeZone, next_page_url)
                
            case .failure(let error):
                print(error);
            }
        }
    }
    
    
    static func GetWishlist(completion :@escaping (_ items : [Item])->()){
        let stringUrl = URL(string: "https://one-tv.net/api/wishlists");
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(openCartApi.token)"
        ]
        
        AF.request(stringUrl!, method: .get, headers: headers).responseData { response in
            switch response.result
            {
            case .success:
                let jsonData = JSON(response.data ?? "")
                print(jsonData)
                let wishlist = jsonData["data"]["wishlists"].arrayValue
                var WishList = [Item]()
                for free in wishlist {
                    let item = free["item"]
                    let id = item["id"].intValue
                    let categoryId = item["category_id"].intValue
                    let subCategoryId = item["sub_category_id"].intValue
                    let slug = item["slug"].stringValue
                    let title = item["title"].stringValue
                    let previewText = item["preview_text"].stringValue
                    let description = item["description"].stringValue
                    let itemType = item["item_type"].intValue
                    let status = item["status"].intValue
                    let single = item["single"].intValue
                    let trending = item["trending"].intValue
                    let featured = item["featured"].intValue
                    let version = item["version"].intValue
                    let tags = item["tags"].stringValue
                    let ratings = item["ratings"].stringValue
                    let view = item["view"].intValue
                    let isTrailer = item["is_trailer"].intValue
                    let rentPrice = item["rent_price"].stringValue
                    let rentalPeriod = item["rental_period"].intValue
                    let excludePlan = item["exclude_plan"].intValue
                    let createdAt = item["created_at"].stringValue
                    let updatedAt = item["updated_at"].stringValue
                    let ispaid = free["is_paid"].intValue
                    let awards = free["awards"].stringValue
                    let revenue = free["revenue"].stringValue
                    let budget = free["budget"].stringValue
                    let images = ImagePaths(landscape: item["image"]["landscape"].stringValue, portrait: item["image"]["portrait"].stringValue)
                    let team = Team(director: item["team"]["director"].stringValue, producer: item["team"]["producer"].stringValue, casts: item["team"]["casts"].stringValue, genres: free["team"]["genres"].stringValue, language: free["team"]["language"].stringValue)
                    let category = Category(id: item["category"]["id"].intValue, name: item["category"]["name"].stringValue, status: item["category"]["status"].intValue, createdAt: free["category"]["created_at"].stringValue, updatedAt: free["category"]["updated_at"].stringValue)
                    let subCategory = SubCategory(id: item["sub_category"]["id"].intValue, name: item["sub_category"]["name"].stringValue, categoryId: item["sub_category"]["category_id"].intValue, status: item["sub_category"]["status"].intValue, createdAt: item["sub_category"]["created_at"].stringValue, updatedAt: item["sub_category"]["updated_at"].stringValue)
                    print(id)
                    let wishs = Item(id: id, categoryId: categoryId, subCategoryId: subCategoryId, slug: slug, title: title, previewText: previewText, description: description, team: team, image: images, itemType: itemType, status: status, single: single, trending: trending, featured: featured, version: version, tags: tags, ratings: ratings, view: view, isTrailer: isTrailer, rentPrice: rentPrice, rentalPeriod: rentalPeriod, excludePlan: excludePlan, createdAt: createdAt, updatedAt: updatedAt, category: category, subCategory: subCategory, isPaid: ispaid, awards: awards, revenue: revenue, budget: budget)
                    print(wishs.title)
                    WishList.append(wishs)
                }
                
                completion(WishList)
                
            case .failure(let error):
                print(error);
            }
        }
    }
    
    
    
    
    
    static func GetFreeItemById(i_id: Int, completion :@escaping (_ items : Item,_ remark: String,_ episodes: [Episode],_ related: [Item])->()){
        let stringUrl = URL(string: "https://one-tv.net/api/watch-video");

                let param: [String: Any] = [
                    "item_id": i_id,
                ]
        
        AF.request(stringUrl!, method: .get, parameters: param).responseData { response in
            switch response.result
            {
            case .success:
                let jsonData = JSON(response.data ?? "")
                print(jsonData)
                let data = jsonData["data"]["item"]
                let remark = jsonData["remark"].stringValue
                
                    let id = data["id"].intValue
                    let categoryId = data["category_id"].intValue
                    let subCategoryId = data["sub_category_id"].intValue
                    let slug = data["slug"].stringValue
                    let title = data["title"].stringValue
                    let previewText = data["preview_text"].stringValue
                    let description = data["description"].stringValue
                    let itemType = data["item_type"].intValue
                    let status = data["status"].intValue
                    let single = data["single"].intValue
                    let trending = data["trending"].intValue
                    let featured = data["featured"].intValue
                    let version = data["version"].intValue
                    let tags = data["tags"].stringValue
                    let ratings = data["ratings"].stringValue
                    let view = data["view"].intValue
                    let isTrailer = data["is_trailer"].intValue
                    let rentPrice = data["rent_price"].stringValue
                    let rentalPeriod = data["rental_period"].intValue
                    let excludePlan = data["exclude_plan"].intValue
                    let createdAt = data["created_at"].stringValue
                    let updatedAt = data["updated_at"].stringValue
                    let ispaid = data["is_paid"].intValue
                let awards = data["awards"].stringValue
                let revenue = data["revenue"].stringValue
                let budget = data["budget"].stringValue
                    let images = ImagePaths(landscape: data["image"]["landscape"].stringValue, portrait: data["image"]["portrait"].stringValue)
                    let team = Team(director: data["team"]["director"].stringValue, producer: data["team"]["producer"].stringValue, casts: data["team"]["casts"].stringValue, genres: data["team"]["genres"].stringValue, language: data["team"]["language"].stringValue)
                    let category = Category(id: data["category"]["id"].intValue, name: data["category"]["name"].stringValue, status: data["category"]["status"].intValue, createdAt: data["category"]["created_at"].stringValue, updatedAt: data["category"]["updated_at"].stringValue)
                    let subCategory = SubCategory(id: data["sub_category"]["id"].intValue, name: data["sub_category"]["name"].stringValue, categoryId: data["sub_category"]["category_id"].intValue, status: data["sub_category"]["status"].intValue, createdAt: data["sub_category"]["created_at"].stringValue, updatedAt: data["sub_category"]["updated_at"].stringValue)

                    let item = Item(id: id, categoryId: categoryId, subCategoryId: subCategoryId, slug: slug, title: title, previewText: previewText, description: description, team: team, image: images, itemType: itemType, status: status, single: single, trending: trending, featured: featured, version: version, tags: tags, ratings: ratings, view: view, isTrailer: isTrailer, rentPrice: rentPrice, rentalPeriod: rentalPeriod, excludePlan: excludePlan, createdAt: createdAt, updatedAt: updatedAt, category: category, subCategory: subCategory, isPaid: ispaid, awards: awards, revenue: revenue, budget: budget)

                
                let episodes = jsonData["data"]["episodes"].arrayValue
                var episodeArray = [Episode]()
                for episode in episodes {
                    let id = episode["id"].intValue
                    let itemId = episode["item_id"].intValue
                    let title = episode["title"].stringValue
                    let image = episode["image"].stringValue
                    let status = episode["status"].intValue
                    let version = episode["version"].intValue
                    let createdAt = episode["created_at"].stringValue
                    let updatedAt = episode["updated_at"].stringValue
                    
                    let episodeObj = Episode(id: id, itemId: itemId, title: title, image: image, status: status, version: version, createdAt: createdAt, updatedAt: updatedAt)
                    episodeArray.append(episodeObj)
                }
                
                

                let related_items = jsonData["data"]["related_items"].arrayValue
                var relatedItemsArray = [Item]()
                
                for item in related_items {
                    let id = item["id"].intValue
                    let categoryId = item["category_id"].intValue
                    let subCategoryId = item["sub_category_id"].intValue
                    let slug = item["slug"].stringValue
                    let title = item["title"].stringValue
                    let previewText = item["preview_text"].stringValue
                    let description = item["description"].stringValue
                    let itemType = item["item_type"].intValue
                    let status = item["status"].intValue
                    let single = item["single"].intValue
                    let trending = item["trending"].intValue
                    let featured = item["featured"].intValue
                    let version = item["version"].intValue
                    let tags = item["tags"].stringValue
                    let ratings = item["ratings"].stringValue
                    let view = item["view"].intValue
                    let isTrailer = item["is_trailer"].intValue
                    let rentPrice = item["rent_price"].stringValue
                    let rentalPeriod = item["rental_period"].intValue
                    let excludePlan = item["exclude_plan"].intValue
                    let createdAt = item["created_at"].stringValue
                    let updatedAt = item["updated_at"].stringValue
                    let ispaid = item["is_paid"].intValue
                    let awards = item["awards"].stringValue
                    let revenue = item["revenue"].stringValue
                    let budget = item["budget"].stringValue
                    let images = ImagePaths(landscape: item["image"]["landscape"].stringValue, portrait: item["image"]["portrait"].stringValue)
                    let team = Team(director: item["team"]["director"].stringValue, producer: item["team"]["producer"].stringValue, casts: item["team"]["casts"].stringValue, genres: item["team"]["genres"].stringValue, language: item["team"]["language"].stringValue)
                    let category = Category(id: item["category"]["id"].intValue, name: item["category"]["name"].stringValue, status: item["category"]["status"].intValue, createdAt: item["category"]["created_at"].stringValue, updatedAt: item["category"]["updated_at"].stringValue)
                    let subCategory = SubCategory(id: item["sub_category"]["id"].intValue, name: item["sub_category"]["name"].stringValue, categoryId: item["sub_category"]["category_id"].intValue, status: item["sub_category"]["status"].intValue, createdAt: item["sub_category"]["created_at"].stringValue, updatedAt: item["sub_category"]["updated_at"].stringValue)

                    let Item = Item(id: id, categoryId: categoryId, subCategoryId: subCategoryId, slug: slug, title: title, previewText: previewText, description: description, team: team, image: images, itemType: itemType, status: status, single: single, trending: trending, featured: featured, version: version, tags: tags, ratings: ratings, view: view, isTrailer: isTrailer, rentPrice: rentPrice, rentalPeriod: rentalPeriod, excludePlan: excludePlan, createdAt: createdAt, updatedAt: updatedAt, category: category, subCategory: subCategory, isPaid: ispaid, awards: awards, revenue: revenue, budget: budget)
                    relatedItemsArray.append(Item)
                }
                
                
                completion(item, remark, episodeArray, relatedItemsArray)
                
            case .failure(let error):
                print(error);
            }
        }
    }
    
    
    static func GetPaidItemById(i_id: Int, episode_id: Int, completion :@escaping (_ items : Item,_ remark: String,_ episodes: [Episode],_ related: [Item],_ Astatus: String)->()){
        let stringUrl = URL(string: "https://one-tv.net/api/watch");
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(openCartApi.token)"
        ]
        
        let param: [String: Any] = [
            "item_id": i_id,
            "episode_id": episode_id
        ]
        
        AF.request(stringUrl!, method: .get, parameters: param, headers: headers).responseData { response in
            switch response.result
            {
            case .success:
                let jsonData = JSON(response.data ?? "")
                print(jsonData)
                let data = jsonData["data"]["item"]
                let remark = jsonData["remark"].stringValue
                let Astatus = jsonData["status"].stringValue
                
                    let id = data["id"].intValue
                    let categoryId = data["category_id"].intValue
                    let subCategoryId = data["sub_category_id"].intValue
                    let slug = data["slug"].stringValue
                    let title = data["title"].stringValue
                    let previewText = data["preview_text"].stringValue
                    let description = data["description"].stringValue
                    let itemType = data["item_type"].intValue
                    let status = data["status"].intValue
                    let single = data["single"].intValue
                    let trending = data["trending"].intValue
                    let featured = data["featured"].intValue
                    let version = data["version"].intValue
                    let tags = data["tags"].stringValue
                    let ratings = data["ratings"].stringValue
                    let view = data["view"].intValue
                    let isTrailer = data["is_trailer"].intValue
                    let rentPrice = data["rent_price"].stringValue
                    let rentalPeriod = data["rental_period"].intValue
                    let excludePlan = data["exclude_plan"].intValue
                    let createdAt = data["created_at"].stringValue
                    let updatedAt = data["updated_at"].stringValue
                    let ispaid = data["is_paid"].intValue
                let awards = data["awards"].stringValue
                let revenue = data["revenue"].stringValue
                let budget = data["budget"].stringValue
                    let images = ImagePaths(landscape: data["image"]["landscape"].stringValue, portrait: data["image"]["portrait"].stringValue)
                    let team = Team(director: data["team"]["director"].stringValue, producer: data["team"]["producer"].stringValue, casts: data["team"]["casts"].stringValue, genres: data["team"]["genres"].stringValue, language: data["team"]["language"].stringValue)
                    let category = Category(id: data["category"]["id"].intValue, name: data["category"]["name"].stringValue, status: data["category"]["status"].intValue, createdAt: data["category"]["created_at"].stringValue, updatedAt: data["category"]["updated_at"].stringValue)
                    let subCategory = SubCategory(id: data["sub_category"]["id"].intValue, name: data["sub_category"]["name"].stringValue, categoryId: data["sub_category"]["category_id"].intValue, status: data["sub_category"]["status"].intValue, createdAt: data["sub_category"]["created_at"].stringValue, updatedAt: data["sub_category"]["updated_at"].stringValue)

                    let item = Item(id: id, categoryId: categoryId, subCategoryId: subCategoryId, slug: slug, title: title, previewText: previewText, description: description, team: team, image: images, itemType: itemType, status: status, single: single, trending: trending, featured: featured, version: version, tags: tags, ratings: ratings, view: view, isTrailer: isTrailer, rentPrice: rentPrice, rentalPeriod: rentalPeriod, excludePlan: excludePlan, createdAt: createdAt, updatedAt: updatedAt, category: category, subCategory: subCategory, isPaid: ispaid, awards: awards, revenue: revenue, budget: budget)

                
                let episodes = jsonData["data"]["episodes"].arrayValue
                var episodeArray = [Episode]()
                for episode in episodes {
                    let id = episode["id"].intValue
                    let itemId = episode["item_id"].intValue
                    let title = episode["title"].stringValue
                    let image = episode["image"].stringValue
                    let status = episode["status"].intValue
                    let version = episode["version"].intValue
                    let createdAt = episode["created_at"].stringValue
                    let updatedAt = episode["updated_at"].stringValue
                    
                    let episodeObj = Episode(id: id, itemId: itemId, title: title, image: image, status: status, version: version, createdAt: createdAt, updatedAt: updatedAt)
                    episodeArray.append(episodeObj)
                }
                

                let related_items = jsonData["data"]["related_items"].arrayValue
                var relatedItemsArray = [Item]()
                
                for item in related_items {
                    let id = item["id"].intValue
                    let categoryId = item["category_id"].intValue
                    let subCategoryId = item["sub_category_id"].intValue
                    let slug = item["slug"].stringValue
                    let title = item["title"].stringValue
                    let previewText = item["preview_text"].stringValue
                    let description = item["description"].stringValue
                    let itemType = item["item_type"].intValue
                    let status = item["status"].intValue
                    let single = item["single"].intValue
                    let trending = item["trending"].intValue
                    let featured = item["featured"].intValue
                    let version = item["version"].intValue
                    let tags = item["tags"].stringValue
                    let ratings = item["ratings"].stringValue
                    let view = item["view"].intValue
                    let isTrailer = item["is_trailer"].intValue
                    let rentPrice = item["rent_price"].stringValue
                    let rentalPeriod = item["rental_period"].intValue
                    let excludePlan = item["exclude_plan"].intValue
                    let createdAt = item["created_at"].stringValue
                    let updatedAt = item["updated_at"].stringValue
                    let ispaid = item["is_paid"].intValue
                    let awards = item["awards"].stringValue
                    let revenue = item["revenue"].stringValue
                    let budget = item["budget"].stringValue
                    let images = ImagePaths(landscape: item["image"]["landscape"].stringValue, portrait: item["image"]["portrait"].stringValue)
                    let team = Team(director: item["team"]["director"].stringValue, producer: item["team"]["producer"].stringValue, casts: item["team"]["casts"].stringValue, genres: item["team"]["genres"].stringValue, language: item["team"]["language"].stringValue)
                    let category = Category(id: item["category"]["id"].intValue, name: item["category"]["name"].stringValue, status: item["category"]["status"].intValue, createdAt: item["category"]["created_at"].stringValue, updatedAt: item["category"]["updated_at"].stringValue)
                    let subCategory = SubCategory(id: item["sub_category"]["id"].intValue, name: item["sub_category"]["name"].stringValue, categoryId: item["sub_category"]["category_id"].intValue, status: item["sub_category"]["status"].intValue, createdAt: item["sub_category"]["created_at"].stringValue, updatedAt: item["sub_category"]["updated_at"].stringValue)

                    let Item = Item(id: id, categoryId: categoryId, subCategoryId: subCategoryId, slug: slug, title: title, previewText: previewText, description: description, team: team, image: images, itemType: itemType, status: status, single: single, trending: trending, featured: featured, version: version, tags: tags, ratings: ratings, view: view, isTrailer: isTrailer, rentPrice: rentPrice, rentalPeriod: rentalPeriod, excludePlan: excludePlan, createdAt: createdAt, updatedAt: updatedAt, category: category, subCategory: subCategory, isPaid: ispaid, awards: awards, revenue: revenue, budget: budget)
                    relatedItemsArray.append(Item)
                }
                
                
                completion(item, remark, episodeArray, relatedItemsArray, Astatus)
                
            case .failure(let error):
                print(error);
            }
        }
        
    }
    
    
    static func PlayVideo(item_id: Int, episode_id: Int, completion :@escaping (_ video : [VideoSizeObject],_ remark: String,_ status: String)->()){
        let stringUrl = URL(string: "https://one-tv.net/api/play-video");
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(openCartApi.token)"
        ]
        
        print("item_id: \(item_id), episode_id: \(episode_id)")
        
        let param: [String: Any] = [
            "item_id": item_id,
            "episode_id": episode_id
        ]
        
        AF.request(stringUrl!, method: .get, parameters: param, headers: headers).responseData { response in
            switch response.result
            {
            case .success:
                let jsonData = JSON(response.data ?? "")
                print(jsonData)
                let Video = jsonData["data"]["video"].arrayValue
                let remark = jsonData["remark"].stringValue
                let status = jsonData["status"].stringValue
                var AllVideo = [VideoSizeObject]()
                for video in Video{
                    let vid = VideoSizeObject(url: video["content"].stringValue, size: video["size"].intValue)
                    AllVideo.append(vid)
                }
                
                completion(AllVideo, remark, status)
               
                
            case .failure(let error):
                print(error);
            }
        }
    }
    
    
    static func GetHome(completion :@escaping (_ free_zone: [Item],_ most_viewed: [Item],_ RecentlyAdded: [Item],_ Featured: [RiklamObject],_ most_reviewd: [Item])->()){
        let stringUrl = URL(string: "https://one-tv.net/api/dashboard");
        
        AF.request(stringUrl!, method: .get).responseData { response in
            print(response)
            switch response.result
            {
            case .success:
                let jsonData = JSON(response.data ?? "")
                print(jsonData)
                let data = jsonData["data"]["data"]
                let free_zone = data["free_zone"].arrayValue
                let most_viewed = data["most_viewed"].arrayValue
                let recently_added = data["recently_added"].arrayValue
                let latest_series = data["latest_series"].arrayValue
                let featured = data["advertise"].arrayValue
                let most_reviewed = data["most_reviewed"].arrayValue
                
                var FreeZone = [Item]()
                var MostViewd = [Item]()
                var MostReviewd = [Item]()
                var RecentlyAdded = [Item]()
                var LatestSeries = [Item]()
                var Featured = [RiklamObject]()
                for free in free_zone {
                    let id = free["id"].intValue
                    let categoryId = free["category_id"].intValue
                    let subCategoryId = free["sub_category_id"].intValue
                    let slug = free["slug"].stringValue
                    let title = free["title"].stringValue
                    let previewText = free["preview_text"].stringValue
                    let description = free["description"].stringValue
                    let itemType = free["item_type"].intValue
                    let status = free["status"].intValue
                    let single = free["single"].intValue
                    let trending = free["trending"].intValue
                    let featured = free["featured"].intValue
                    let version = free["version"].intValue
                    let tags = free["tags"].stringValue
                    let ratings = free["ratings"].stringValue
                    let view = free["view"].intValue
                    let isTrailer = free["is_trailer"].intValue
                    let rentPrice = free["rent_price"].stringValue
                    let rentalPeriod = free["rental_period"].intValue
                    let excludePlan = free["exclude_plan"].intValue
                    let createdAt = free["created_at"].stringValue
                    let updatedAt = free["updated_at"].stringValue
                    let ispaid = free["is_paid"].intValue
                    let awards = free["awards"].stringValue
                    let revenue = free["revenue"].stringValue
                    let budget = free["budget"].stringValue
                    let images = ImagePaths(landscape: free["image"]["landscape"].stringValue, portrait: free["image"]["portrait"].stringValue)
                    let team = Team(director: free["team"]["director"].stringValue, producer: free["team"]["producer"].stringValue, casts: free["team"]["casts"].stringValue, genres: free["team"]["genres"].stringValue, language: free["team"]["language"].stringValue)
                    let category = Category(id: free["category"]["id"].intValue, name: free["category"]["name"].stringValue, status: free["category"]["status"].intValue, createdAt: free["category"]["created_at"].stringValue, updatedAt: free["category"]["updated_at"].stringValue)
                    let subCategory = SubCategory(id: free["sub_category"]["id"].intValue, name: free["sub_category"]["name"].stringValue, categoryId: free["sub_category"]["category_id"].intValue, status: free["sub_category"]["status"].intValue, createdAt: free["sub_category"]["created_at"].stringValue, updatedAt: free["sub_category"]["updated_at"].stringValue)

                    let freeZone = Item(id: id, categoryId: categoryId, subCategoryId: subCategoryId, slug: slug, title: title, previewText: previewText, description: description, team: team, image: images, itemType: itemType, status: status, single: single, trending: trending, featured: featured, version: version, tags: tags, ratings: ratings, view: view, isTrailer: isTrailer, rentPrice: rentPrice, rentalPeriod: rentalPeriod, excludePlan: excludePlan, createdAt: createdAt, updatedAt: updatedAt, category: category, subCategory: subCategory, isPaid: ispaid, awards: awards, revenue: revenue, budget: budget)
                    FreeZone.append(freeZone)
                }
                
                for most in most_viewed {
                    let id = most["id"].intValue
                    let categoryId = most["category_id"].intValue
                    let subCategoryId = most["sub_category_id"].intValue
                    let slug = most["slug"].stringValue
                    let title = most["title"].stringValue
                    let previewText = most["preview_text"].stringValue
                    let description = most["description"].stringValue
                    let itemType = most["item_type"].intValue
                    let status = most["status"].intValue
                    let single = most["single"].intValue
                    let trending = most["trending"].intValue
                    let featured = most["featured"].intValue
                    let version = most["version"].intValue
                    let tags = most["tags"].stringValue
                    let ratings = most["ratings"].stringValue
                    let view = most["view"].intValue
                    let isTrailer = most["is_trailer"].intValue
                    let rentPrice = most["rent_price"].stringValue
                    let rentalPeriod = most["rental_period"].intValue
                    let excludePlan = most["exclude_plan"].intValue
                    let createdAt = most["created_at"].stringValue
                    let updatedAt = most["updated_at"].stringValue
                    let ispaid = most["is_paid"].intValue
                    let awards = most["awards"].stringValue
                    let revenue = most["revenue"].stringValue
                    let budget = most["budget"].stringValue
                    let images = ImagePaths(landscape: most["image"]["landscape"].stringValue, portrait: most["image"]["portrait"].stringValue)
                    let team = Team(director: most["team"]["director"].stringValue, producer: most["team"]["producer"].stringValue, casts: most["team"]["casts"].stringValue, genres: most["team"]["genres"].stringValue, language: most["team"]["language"].stringValue)
                    let category = Category(id: most["category"]["id"].intValue, name: most["category"]["name"].stringValue, status: most["category"]["status"].intValue, createdAt: most["category"]["created_at"].stringValue, updatedAt: most["category"]["updated_at"].stringValue)
                    let subCategory = SubCategory(id: most["sub_category"]["id"].intValue, name: most["sub_category"]["name"].stringValue, categoryId: most["sub_category"]["category_id"].intValue, status: most["sub_category"]["status"].intValue, createdAt: most["sub_category"]["created_at"].stringValue, updatedAt: most["sub_category"]["updated_at"].stringValue)

                    let mostReviewd = Item(id: id, categoryId: categoryId, subCategoryId: subCategoryId, slug: slug, title: title, previewText: previewText, description: description, team: team, image: images, itemType: itemType, status: status, single: single, trending: trending, featured: featured, version: version, tags: tags, ratings: ratings, view: view, isTrailer: isTrailer, rentPrice: rentPrice, rentalPeriod: rentalPeriod, excludePlan: excludePlan, createdAt: createdAt, updatedAt: updatedAt, category: category, subCategory: subCategory, isPaid: ispaid, awards: awards, revenue: revenue, budget: budget)
                    MostViewd.append(mostReviewd)
                }
                
                
                for new in recently_added {
                    let id = new["id"].intValue
                    let categoryId = new["category_id"].intValue
                    let subCategoryId = new["sub_category_id"].intValue
                    let slug = new["slug"].stringValue
                    let title = new["title"].stringValue
                    let previewText = new["preview_text"].stringValue
                    let description = new["description"].stringValue
                    let itemType = new["item_type"].intValue
                    let status = new["status"].intValue
                    let single = new["single"].intValue
                    let trending = new["trending"].intValue
                    let featured = new["featured"].intValue
                    let version = new["version"].intValue
                    let tags = new["tags"].stringValue
                    let ratings = new["ratings"].stringValue
                    let view = new["view"].intValue
                    let isTrailer = new["is_trailer"].intValue
                    let rentPrice = new["rent_price"].stringValue
                    let rentalPeriod = new["rental_period"].intValue
                    let excludePlan = new["exclude_plan"].intValue
                    let createdAt = new["created_at"].stringValue
                    let updatedAt = new["updated_at"].stringValue
                    let ispaid = new["is_paid"].intValue
                    let awards = new["awards"].stringValue
                    let revenue = new["revenue"].stringValue
                    let budget = new["budget"].stringValue
                    let images = ImagePaths(landscape: new["image"]["landscape"].stringValue, portrait: new["image"]["portrait"].stringValue)
                    let team = Team(director: new["team"]["director"].stringValue, producer: new["team"]["producer"].stringValue, casts: new["team"]["casts"].stringValue, genres: new["team"]["genres"].stringValue, language: new["team"]["language"].stringValue)
                    let category = Category(id: new["category"]["id"].intValue, name: new["category"]["name"].stringValue, status: new["category"]["status"].intValue, createdAt: new["category"]["created_at"].stringValue, updatedAt: new["category"]["updated_at"].stringValue)
                    let subCategory = SubCategory(id: new["sub_category"]["id"].intValue, name: new["sub_category"]["name"].stringValue, categoryId: new["sub_category"]["category_id"].intValue, status: new["sub_category"]["status"].intValue, createdAt: new["sub_category"]["created_at"].stringValue, updatedAt: new["sub_category"]["updated_at"].stringValue)

                    let recentlyAdded = Item(id: id, categoryId: categoryId, subCategoryId: subCategoryId, slug: slug, title: title, previewText: previewText, description: description, team: team, image: images, itemType: itemType, status: status, single: single, trending: trending, featured: featured, version: version, tags: tags, ratings: ratings, view: view, isTrailer: isTrailer, rentPrice: rentPrice, rentalPeriod: rentalPeriod, excludePlan: excludePlan, createdAt: createdAt, updatedAt: updatedAt, category: category, subCategory: subCategory, isPaid: ispaid, awards: awards, revenue: revenue, budget: budget)
                    RecentlyAdded.append(recentlyAdded)
                }
                
                for new in latest_series {
                    let id = new["id"].intValue
                    let categoryId = new["category_id"].intValue
                    let subCategoryId = new["sub_category_id"].intValue
                    let slug = new["slug"].stringValue
                    let title = new["title"].stringValue
                    let previewText = new["preview_text"].stringValue
                    let description = new["description"].stringValue
                    let itemType = new["item_type"].intValue
                    let status = new["status"].intValue
                    let single = new["single"].intValue
                    let trending = new["trending"].intValue
                    let featured = new["featured"].intValue
                    let version = new["version"].intValue
                    let tags = new["tags"].stringValue
                    let ratings = new["ratings"].stringValue
                    let view = new["view"].intValue
                    let isTrailer = new["is_trailer"].intValue
                    let rentPrice = new["rent_price"].stringValue
                    let rentalPeriod = new["rental_period"].intValue
                    let excludePlan = new["exclude_plan"].intValue
                    let createdAt = new["created_at"].stringValue
                    let updatedAt = new["updated_at"].stringValue
                    let ispaid = new["is_paid"].intValue
                    let awards = new["awards"].stringValue
                    let revenue = new["revenue"].stringValue
                    let budget = new["budget"].stringValue
                    let images = ImagePaths(landscape: new["image"]["landscape"].stringValue, portrait: new["image"]["portrait"].stringValue)
                    let team = Team(director: new["team"]["director"].stringValue, producer: new["team"]["producer"].stringValue, casts: new["team"]["casts"].stringValue, genres: new["team"]["genres"].stringValue, language: new["team"]["language"].stringValue)
                    let category = Category(id: new["category"]["id"].intValue, name: new["category"]["name"].stringValue, status: new["category"]["status"].intValue, createdAt: new["category"]["created_at"].stringValue, updatedAt: new["category"]["updated_at"].stringValue)
                    let subCategory = SubCategory(id: new["sub_category"]["id"].intValue, name: new["sub_category"]["name"].stringValue, categoryId: new["sub_category"]["category_id"].intValue, status: new["sub_category"]["status"].intValue, createdAt: new["sub_category"]["created_at"].stringValue, updatedAt: new["sub_category"]["updated_at"].stringValue)

                    let recentlyAdded = Item(id: id, categoryId: categoryId, subCategoryId: subCategoryId, slug: slug, title: title, previewText: previewText, description: description, team: team, image: images, itemType: itemType, status: status, single: single, trending: trending, featured: featured, version: version, tags: tags, ratings: ratings, view: view, isTrailer: isTrailer, rentPrice: rentPrice, rentalPeriod: rentalPeriod, excludePlan: excludePlan, createdAt: createdAt, updatedAt: updatedAt, category: category, subCategory: subCategory, isPaid: ispaid, awards: awards, revenue: revenue, budget: budget)
                    LatestSeries.append(recentlyAdded)
                }
                
                RecentlyAdded.append(contentsOf: LatestSeries)
                
                for fetured in featured {
                    let id = fetured["id"].intValue
                    let url = fetured["url"].stringValue
                    let image = fetured["image"].stringValue

                    let feature = RiklamObject(id: id, url: url, image: image)
                    Featured.append(feature)
                }
                
                for reviewd in most_reviewed {
                    let id = reviewd["id"].intValue
                    let categoryId = reviewd["category_id"].intValue
                    let subCategoryId = reviewd["sub_category_id"].intValue
                    let slug = reviewd["slug"].stringValue
                    let title = reviewd["title"].stringValue
                    let previewText = reviewd["preview_text"].stringValue
                    let description = reviewd["description"].stringValue
                    let itemType = reviewd["item_type"].intValue
                    let status = reviewd["status"].intValue
                    let single = reviewd["single"].intValue
                    let trending = reviewd["trending"].intValue
                    let featured = reviewd["featured"].intValue
                    let version = reviewd["version"].intValue
                    let tags = reviewd["tags"].stringValue
                    let ratings = reviewd["ratings"].stringValue
                    let view = reviewd["view"].intValue
                    let isTrailer = reviewd["is_trailer"].intValue
                    let rentPrice = reviewd["rent_price"].stringValue
                    let rentalPeriod = reviewd["rental_period"].intValue
                    let excludePlan = reviewd["exclude_plan"].intValue
                    let createdAt = reviewd["created_at"].stringValue
                    let updatedAt = reviewd["updated_at"].stringValue
                    let ispaid = reviewd["is_paid"].intValue
                    let awards = reviewd["awards"].stringValue
                    let revenue = reviewd["revenue"].stringValue
                    let budget = reviewd["budget"].stringValue
                    let images = ImagePaths(landscape: reviewd["image"]["landscape"].stringValue, portrait: reviewd["image"]["portrait"].stringValue)
                    let team = Team(director: reviewd["team"]["director"].stringValue, producer: reviewd["team"]["producer"].stringValue, casts: reviewd["team"]["casts"].stringValue, genres: reviewd["team"]["genres"].stringValue, language: reviewd["team"]["language"].stringValue)
                    let category = Category(id: reviewd["category"]["id"].intValue, name: reviewd["category"]["name"].stringValue, status: reviewd["category"]["status"].intValue, createdAt: reviewd["category"]["created_at"].stringValue, updatedAt: reviewd["category"]["updated_at"].stringValue)
                    let subCategory = SubCategory(id: reviewd["sub_category"]["id"].intValue, name: reviewd["sub_category"]["name"].stringValue, categoryId: reviewd["sub_category"]["category_id"].intValue, status: reviewd["sub_category"]["status"].intValue, createdAt: reviewd["sub_category"]["created_at"].stringValue, updatedAt: reviewd["sub_category"]["updated_at"].stringValue)

                    let reviewd = Item(id: id, categoryId: categoryId, subCategoryId: subCategoryId, slug: slug, title: title, previewText: previewText, description: description, team: team, image: images, itemType: itemType, status: status, single: single, trending: trending, featured: featured, version: version, tags: tags, ratings: ratings, view: view, isTrailer: isTrailer, rentPrice: rentPrice, rentalPeriod: rentalPeriod, excludePlan: excludePlan, createdAt: createdAt, updatedAt: updatedAt, category: category, subCategory: subCategory, isPaid: ispaid, awards: awards, revenue: revenue, budget: budget)
                    MostReviewd.append(reviewd)
                }
                
                completion(FreeZone, MostViewd, RecentlyAdded, Featured, MostReviewd)
            case .failure(let error):
                print(error);
                
            }
        }
    }
}



class LoginAPi{
    
    
    static func GetNotification(completion : @escaping (_ nots : [NotificationsObject])->()){
        var request = URLRequest(url: URL(string: "https://one-tv.net/api/push-notifications")!,timeoutInterval: Double.infinity)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Bearer \(openCartApi.token)", forHTTPHeaderField: "Authorization")

        request.httpMethod = "GET"
        
        var Notifications : [NotificationsObject] = []
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
            print(String(describing: error))
            return
          }
         // print(String(data: data, encoding: .utf8)!)
            let jsonData = JSON(data)
            let noteData = jsonData["data"]["notifications"]
            let notifications = noteData["data"].arrayValue
            
            for notification in notifications {
                let note = NotificationsObject(description: notification["message"].stringValue, date: notification["created_at"].stringValue, title: notification["subject"].stringValue, image: notification["image"].stringValue)
                Notifications.append(note)
            }
            print(jsonData)
            DispatchQueue.main.async {
                completion(Notifications)
            }
            
            
        }

        task.resume()
    }
    
    
    
    static func Login(mobile : String, code: String ,deviceId: String, completion : @escaping (_ lol : String,_ user: userInfo)->()){
        let stringUrl = URL(string: "https://one-tv.net/api/login?mobile=\(mobile)&code=\(code)&device_id=\(deviceId)")
        let headers : HTTPHeaders = ["Accept-Language" : openCartApi.Lang]
        let param: [String: Any] = [
            "mobile":mobile,
            "code" : code,
            "device_id" : deviceId,
        ]
        
        var status = ""
        AF.request(stringUrl!, method: .post, parameters: param, headers: headers).responseData { response in
            switch response.result
            {
            case .success:
                let jsonData = JSON(response.data ?? "")
                let token = jsonData["data"]["access_token"].string ?? ""
                let user = jsonData["data"]["user"]
                let message = jsonData["message"]
                let messageError = message["error"].arrayValue
                print(jsonData)
                
                let UserInfo = userInfo(id: user["id"].intValue, planId: user["plan_id"].intValue, firstname: user["firstname"].stringValue, lastname: user["lastname"].stringValue, username: user["username"].stringValue, email: user["email"].stringValue, dialCode: user["dial_code"].stringValue, countryCode: user["country_code"].stringValue, mobile: user["mobile"].stringValue, countryName: user["country_name"].stringValue, city: user["city"].stringValue, state: user["state"].stringValue, zip: user["zip"].stringValue, address: user["address"].stringValue, image: user["image"].stringValue, status: user["status"].intValue, exp: user["exp"].stringValue, ev: user["ev"].intValue, sv: user["sv"].intValue, profileComplete: user["profile_complete"].intValue, verCodeSendAt: user["ver_code_send_at"].stringValue, tsc: user["tsc"].stringValue, banReason: user["ban_reason"].stringValue, provider: user["provider"].stringValue, providerId: user["provider_id"].stringValue, loginBy: user["login_by"].stringValue, createdAt: user["created_at"].stringValue, updatedAt: user["updated_at"].stringValue, accessToken: jsonData["data"]["access_token"].string ?? "", tokenType: jsonData["data"]["token_type"].string ?? "")
                
                
                    status = jsonData["status"].string ?? ""
                    if status != "success"{
                        showDrop(title: "", message: messageError.first?.string ?? "")
                        completion("",UserInfo)
                    }else{
                        UserDefaults.standard.setValue(token, forKey: "token")
                        UserDefaults.standard.setValue(user["id"].string ?? "", forKey: "user_id")
                        openCartApi.token = UserDefaults.standard.string(forKey: "token") ?? ""
                        completion(status,UserInfo)
                    }
            case .failure(let error):
                print(error);
            }
        }
    }
    
    
    
    
    static func getUserInfo(completion :@escaping (_ info: userInfo)->()){
        
        var request = URLRequest(url: URL(string: "https://one-tv.net/api/user-info")!,timeoutInterval: Double.infinity)
        request.addValue("Bearer \(openCartApi.token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        print("Bearer \(openCartApi.token)")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
            print(String(describing: error))
            return
          }
          print(String(data: data, encoding: .utf8)!)
            let jsonData = JSON(data)
            let Plan = jsonData["data"]["user"]
            print(jsonData)
            
            let user = userInfo(id: Plan["id"].intValue, planId: Plan["plan_id"].intValue, firstname: Plan["firstname"].stringValue, lastname: Plan["lastname"].stringValue, username: Plan["username"].stringValue, email: Plan["email"].stringValue, dialCode: Plan["dial_code"].stringValue, countryCode: Plan["country_code"].stringValue, mobile: Plan["mobile"].stringValue, countryName: Plan["country_name"].stringValue, city: Plan["city"].stringValue, state: Plan["state"].stringValue, zip: Plan["zip"].stringValue, address: Plan["address"].stringValue, image: Plan["image"].stringValue, status: Plan["status"].intValue, exp: Plan["exp"].stringValue, ev: Plan["ev"].intValue, sv: Plan["sv"].intValue, profileComplete: Plan["profile_complete"].intValue, verCodeSendAt: Plan["ver_code_send_at"].stringValue, tsc: Plan["tsc"].stringValue, banReason: Plan["ban_reason"].stringValue, provider: Plan["provider"].stringValue, providerId: Plan["provider_id"].stringValue, loginBy: Plan["login_by"].stringValue, createdAt: Plan["created_at"].stringValue, updatedAt: Plan["updated_at"].stringValue, accessToken: jsonData["data"]["access_token"].string ?? "", tokenType: jsonData["data"]["token_type"].string ?? "")

            
            DispatchQueue.main.async {
                completion(user)
            }
        }

        task.resume()

        
    }
    
    
    
    static func SendOTP(phone: String, completion :@escaping (_ status: Bool,_ transaction_id : String)->()){
        var request = URLRequest(url: URL(string: "https://one-tv.net/api/send-otp?phone=\(phone)")!,timeoutInterval: Double.infinity)
        request.httpMethod = "POST"

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
            print(String(describing: error))
            return
          }
          print(String(data: data, encoding: .utf8)!)
            let jsonData = JSON(data)
            let success = jsonData["success"].boolValue
            let transaction_id = jsonData["transaction_id"].stringValue
            print(success)
            
            DispatchQueue.main.async {
                completion(success, transaction_id)
            }
        }

        task.resume()
        
    }
    
    
    static func VerifyOTP(phone: String, transaction_id: String, OTP: String, completion :@escaping (_ status: Bool)->()){
        var request = URLRequest(url: URL(string: "https://one-tv.net/api/verify-otp?phone=\(phone)&code=\(OTP)&transaction_id=\(transaction_id)")!,timeoutInterval: Double.infinity)
        request.httpMethod = "POST"

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
            print(String(describing: error))
            return
          }
          print(String(data: data, encoding: .utf8)!)
            let jsonData = JSON(data)
            let success = jsonData["success"].boolValue
            let message = jsonData["message"].stringValue
            
            if success != true{
                showDrop(title: "", message: message)
            }
            
            DispatchQueue.main.async {
                completion(success)
            }
        }

        task.resume()
        
    }
    
    
    
    
    
    static func Registration(fullname : String, activationcode: String ,mobile: String, deviceId: String, completion : @escaping (_ lol : String,_ user: userInfo)->()){
        let stringUrl = URL(string: "https://one-tv.net/api/register?mobile=\(mobile)&fullname=\(fullname)&activationcode=\(activationcode)&agree=true&device_id=\(deviceId)")
        let headers : HTTPHeaders = ["Accept-Language" : openCartApi.Lang]

        var status = ""
        AF.request(stringUrl!, method: .post, headers: headers).responseData { response in
            switch response.result
            {
            case .success:
                let jsonData = JSON(response.data ?? "")
                let token = jsonData["data"]["access_token"].string ?? ""
                let user = jsonData["data"]["user"]
                let UserInfo = userInfo(id: user["id"].intValue, planId: user["plan_id"].intValue, firstname: user["firstname"].stringValue, lastname: user["lastname"].stringValue, username: user["username"].stringValue, email: user["email"].stringValue, dialCode: user["dial_code"].stringValue, countryCode: user["country_code"].stringValue, mobile: user["mobile"].stringValue, countryName: user["country_name"].stringValue, city: user["city"].stringValue, state: user["state"].stringValue, zip: user["zip"].stringValue, address: user["address"].stringValue, image: user["image"].stringValue, status: user["status"].intValue, exp: user["exp"].stringValue, ev: user["ev"].intValue, sv: user["sv"].intValue, profileComplete: user["profile_complete"].intValue, verCodeSendAt: user["ver_code_send_at"].stringValue, tsc: user["tsc"].stringValue, banReason: user["ban_reason"].stringValue, provider: user["provider"].stringValue, providerId: user["provider_id"].stringValue, loginBy: user["login_by"].stringValue, createdAt: user["created_at"].stringValue, updatedAt: user["updated_at"].stringValue, accessToken: jsonData["data"]["access_token"].string ?? "", tokenType: jsonData["data"]["token_type"].string ?? "")
                print(jsonData)
                let message = jsonData["message"].stringValue
                    status = jsonData["status"].string ?? ""
                    if status != "success"{
                        showDrop(title: "", message: message)
                        completion("",userInfo(id: 0, planId: 0, firstname: "", lastname: "", username: "", email: "", dialCode: "", countryCode: "", mobile: "", countryName: "", city: "", state: "", zip: "", address: "", image: "", status: 0, exp: "", ev: 0, sv: 0, profileComplete: 0, verCodeSendAt: "", tsc: "", banReason: "", provider: "", providerId: "", loginBy: "", createdAt: "", updatedAt: "", accessToken: "", tokenType: ""))
                    }else{
                        UserDefaults.standard.setValue(token, forKey: "token")
                        UserDefaults.standard.setValue(user["id"].string ?? "", forKey: "user_id")
                        openCartApi.token = UserDefaults.standard.string(forKey: "token") ?? ""
                        completion(status, UserInfo)
                    }
            case .failure(let error):
                print(error);
            }
        }
    }
    
    
    
    
    static func LogOut( completion : @escaping (_ lol : String)->()){
        var request = URLRequest(url: URL(string: "https://one-tv.net/api/logout")!,timeoutInterval: Double.infinity)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Bearer \(openCartApi.token)", forHTTPHeaderField: "Authorization")

        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
            print(String(describing: error))
            return
          }
          print(String(data: data, encoding: .utf8)!)
           
            DispatchQueue.main.async {
                completion("success")
            }
        }

        task.resume()
    }
    
    
    static func DeleteAccount( completion : @escaping (_ lol : String)->()){
        let stringUrl = URL(string: "https://one-tv.net/api/delete-account?Accept=application/json&Authorization=Bearer \(openCartApi.token)");

        var status = ""
        AF.request(stringUrl!, method: .get).responseData { response in
            switch response.result
            {
            case .success:
                let jsonData = JSON(response.data ?? "")
                print(jsonData)
                let message = jsonData["message"]
                let messageError = message["error"].arrayValue
                    status = jsonData["status"].string ?? ""
                    if status != "success"{
                        showDrop(title: "", message: messageError.first?.string ?? "")
                        DispatchQueue.main.async {
                            completion("")
                        }
                    }else{
                        DispatchQueue.main.async {
                            completion(status)
                        }
                    }
            case .failure(let error):
                print(error);
            }
        }
    }
    

    static func GetAboutPage(completion: @escaping ([AboutData]) -> Void) {
        let stringUrl = URL(string: "https://one-tv.net/api/about")!
        let headers: HTTPHeaders = ["Accept-Language": openCartApi.Lang]
        
        AF.request(stringUrl, method: .get, headers: headers).responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let json = try JSON(data: data)
                    var aboutData: [AboutData] = []
                    
                    for about in json["data"]["about_pages"].arrayValue {
                        let id = about["id"].intValue
                        let dataValues = about["data_values"]
                        let title = dataValues["title"].stringValue
                        let description = dataValues["description"].stringValue
                        
                        aboutData.append(AboutData(id: id, title: title, description: description))
                    }
                    
                    DispatchQueue.main.async {
                        completion(aboutData)
                    }
                } catch {
                    print("JSON parsing error: \(error)")
                    DispatchQueue.main.async {
                        completion([])
                    }
                }
                
            case .failure(let error):
                print("Network error: \(error)")
                DispatchQueue.main.async {
                    completion([])
                }
            }
        }
    }
    
    
    static func GetPrivacyPage(completion: @escaping ([AboutData]) -> Void) {
        let stringUrl = URL(string: "https://one-tv.net/api/policies")!
        let headers: HTTPHeaders = ["Accept-Language": openCartApi.Lang]
        
        AF.request(stringUrl, method: .get, headers: headers).responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let json = try JSON(data: data)
                    var aboutData: [AboutData] = []
                    
                    for about in json["data"]["policies"].arrayValue {
                        let id = about["id"].intValue
                        let dataValues = about["data_values"]
                        let title = dataValues["title"].stringValue
                        let description = dataValues["description"].stringValue
                        
                        aboutData.append(AboutData(id: id, title: title, description: description))
                    }
                    
                    DispatchQueue.main.async {
                        completion(aboutData)
                    }
                } catch {
                    print("JSON parsing error: \(error)")
                    DispatchQueue.main.async {
                        completion([])
                    }
                }
                
            case .failure(let error):
                print("Network error: \(error)")
                DispatchQueue.main.async {
                    completion([])
                }
            }
        }
    }
    
}


class AboutData {
    let id: Int
    let title: String
    let description: String
    init(id: Int, title: String, description: String) {
        self.id = id
        self.title = title
        self.description = description
    }
}






class userInfo{
    let id: Int
    let planId: Int
    let firstname: String
    let lastname: String
    let username: String
    let email: String
    let dialCode: String
    let countryCode: String
    let mobile: String
    let countryName: String
    let city: String
    let state: String
    let zip: String
    let address: String
    let image: String
    let status: Int
    let exp: String
    let ev: Int
    let sv: Int
    let profileComplete: Int
    let verCodeSendAt: String
    let tsc: String
    let banReason: String
    let provider: String
    let providerId: String
    let loginBy: String
    let createdAt: String
    let updatedAt: String
    let accessToken: String
    let tokenType: String
    
    init(id: Int, planId: Int, firstname: String, lastname: String, username: String, email: String, dialCode: String, countryCode: String, mobile: String, countryName: String, city: String, state: String, zip: String, address: String, image: String, status: Int, exp: String, ev: Int, sv: Int, profileComplete: Int, verCodeSendAt: String, tsc: String, banReason: String, provider: String, providerId: String, loginBy: String, createdAt: String, updatedAt: String, accessToken: String , tokenType :String) {
        self.id = id
        self.planId = planId
        self.firstname = firstname
        self.lastname = lastname
        self.username = username
        self.email = email
        self.dialCode = dialCode
        self.countryCode = countryCode
        self.mobile = mobile
        self.countryName = countryName
        self.city = city
        self.state = state
        self.zip = zip
        self.address = address
        self.image = image
        self.status = status
        self.exp = exp
        self.ev = ev
        self.sv = sv
        self.profileComplete = profileComplete
        self.verCodeSendAt = verCodeSendAt
        self.tsc = tsc
        self.banReason = banReason
        self.provider = provider
        self.providerId = providerId
        self.loginBy = loginBy
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.accessToken = accessToken
        self.tokenType = tokenType
    }
}



class CategoriesObject{
    let id: Int
    let name: String
    let status: Int
    let createdAt: String
    let updatedAt: String
    init(id: Int, name: String, status: Int, createdAt: String, updatedAt: String) {
        self.id = id
        self.name = name
        self.status = status
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}





class CategoriesAPi{
    
    static func getCateegories(completion :@escaping (_ categories: [CategoriesObject])->()){
        let stringUrl = URL(string: "https://one-tv.net/api/subcategories");
        
        AF.request(stringUrl!, method: .get).responseData { response in
            switch response.result
            {
            case .success:
                let jsonData = JSON(response.data ?? "")
                let data = jsonData["data"]["subcategories"]
                let categories = data["data"].arrayValue
                var Categories = [CategoriesObject]()
                print(jsonData)
                for category in categories {
                    let id = category["id"].intValue
                    let name = category["name"].stringValue
                    let status = category["status"].intValue
                    let createdAt = category["created_at"].stringValue
                    let updatedAt = category["updated_at"].stringValue
                    
                    let categoriesObject = CategoriesObject(id: id, name: name, status: status, createdAt: createdAt, updatedAt: updatedAt)
                    Categories.append(categoriesObject)
                }
                completion(Categories)
            case .failure(let error):
                print(error);
            }
        }
    }
    
}
                    




class PlansObject{
    let id: Int
    let name: String
    let phone: String
    let title: String
    let pricing: String
    let appCode: String
    let duration: Int
    let deviceLimit: Int
    let status: Int
    let icon: String
    let showAds: Int
    let createdAt: String
    let updatedAt: String
    
    init(id: Int, name: String, phone: String, title: String, pricing: String, appCode: String, duration: Int, deviceLimit: Int, status: Int, icon: String, showAds: Int, createdAt: String, updatedAt: String) {
        self.id = id
        self.name = name
        self.phone = phone
        self.title = title
        self.pricing = pricing
        self.appCode = appCode
        self.duration = duration
        self.deviceLimit = deviceLimit
        self.status = status
        self.icon = icon
        self.showAds = showAds
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}



class PlansAPi{
    
    static func getPlans(completion :@escaping (_ plans: [PlansObject])->()){
        
        var request = URLRequest(url: URL(string: "https://one-tv.net/api/plans")!,timeoutInterval: Double.infinity)
        request.addValue("Bearer \(openCartApi.token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        print("Bearer \(openCartApi.token)")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
            print(String(describing: error))
            return
          }
          print(String(data: data, encoding: .utf8)!)
            let jsonData = JSON(data)
            let Plan = jsonData["data"]["plans"].arrayValue
            var Plans = [PlansObject]()
            print(jsonData)
            for plan in Plan {
                let id = plan["id"].intValue
                let name = plan["name"].stringValue
                let phone = plan["phone"].stringValue
                let title = plan["title"].stringValue
                let pricing = plan["pricing"].stringValue
                let appCode = plan["app_code"].stringValue
                let duration = plan["duration"].intValue
                let deviceLimit = plan["device_limit"].intValue
                let status = plan["status"].intValue
                let icon = plan["icon"].stringValue
                let showAds = plan["show_ads"].intValue
                let createdAt = plan["created_at"].stringValue
                let updatedAt = plan["updated_at"].stringValue
                
                let plansObject = PlansObject(id: id, name: name, phone: phone, title: title, pricing: pricing, appCode: appCode, duration: duration, deviceLimit: deviceLimit, status: status, icon: icon, showAds: showAds, createdAt: createdAt, updatedAt: updatedAt)
                Plans.append(plansObject)
            }
            completion(Plans)
        }

        task.resume()

        
    }
    
}
   

class VideoSizeObject{
    let url : String
    let size : Int
    
    init(url : String, size : Int){
        self.url = url
        self.size = size
    }

}


class UpdateOneSignalIdAPI{
    static func Update(UUID : String){
        var request = URLRequest(url: URL(string: "https://one-tv.net/api/add-device-token?token=\(UUID)")!,timeoutInterval: Double.infinity)
        request.addValue("Bearer \(openCartApi.token)", forHTTPHeaderField: "Authorization")

        request.httpMethod = "POST"

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
            print(String(describing: error))
            return
          }
          print(String(data: data, encoding: .utf8)!)
        }

        task.resume()
    }
}






class SocialObject{
    let id: Int
    let title: String
    let icon: String
    let url: String
    init(id: Int, title: String, icon: String, url: String) {
        self.id = id
        self.title = title
        self.icon = icon
        self.url = url
    }
}

class SocialAPi{
    
    static func getSocial(completion :@escaping (_ social: [SocialObject])->()){
        
        let stringUrl = URL(string: "https://one-tv.net/api/social");
        
        AF.request(stringUrl!, method: .get).responseData { response in
            switch response.result
            {
            case .success:
                let jsonData = JSON(response.data ?? "")
                let data = jsonData["data"]["social"]
                let social = data.arrayValue
                var Socials = [SocialObject]()
                print(jsonData)
                for soc in social {
                    let id = soc["id"].intValue
                    let title = soc["data_values"]["title"].stringValue
                    let icon = soc["data_values"]["social_icon"].stringValue
                    let url = soc["data_values"]["url"].stringValue
                    
                    let socialObject = SocialObject(id: id, title: title, icon: icon, url: url)
                    Socials.append(socialObject)
                }
                completion(Socials)
            case .failure(let error):
                print(error);
            }
        }
    }
    
}





