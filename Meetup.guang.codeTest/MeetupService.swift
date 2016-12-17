//
//  MeetupService.swift
//  Meetup.guang.codeTest
//
//  Created by Guang on 11/27/16.
//  Copyright © 2016 Guang. All rights reserved.
//

import Foundation
import UIKit

struct Event{
    let name: String
    let yes_rsvp_count: Int
    let groupName: String
    let time: NSNumber
    let city: String
    let who: String
    var fav = false
}

extension Event {
    init?(dictionary: NSDictionary){
        guard let name = dictionary["name"] as? String,
            yes_rsvp_count = dictionary["yes_rsvp_count"] as? Int,
            groupName = dictionary["group"]!["name"] as? String,
            time = dictionary["time"] as? NSNumber,
            city = dictionary["venue"]!["city"] as? String,
            who = dictionary["group"]!["who"] as? String else { return nil}
        self.name = name
        self.yes_rsvp_count = yes_rsvp_count
        self.groupName = groupName
        self.time = time
        self.city = city
        self.who = who
    }
}

//MARK: referenced from the objc.io talk #Networking.
struct Resource<A> {
    let url: NSURL
    let parse: (NSData) -> A?
}
extension Resource {
    init(url: NSURL, parseJson: AnyObject -> A?) {
        self.url = url
        self.parse = { data in
            let json = try? NSJSONSerialization.JSONObjectWithData(data, options: [])
            return json.flatMap(parseJson)
        }
    }
}

final class MeetupService{
    func load<A>(resource: Resource<A>, completion: (A?) -> ()){
        NSURLSession.sharedSession().dataTaskWithURL(resource.url) { data, _, _ in
            guard let data = data else {
                completion(nil)
                return
            }
            completion(resource.parse(data))
        }.resume()
    }
}
