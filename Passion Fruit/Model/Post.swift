//
//  Post.swift
//  Passion Fruit
//
//  Created by Jason Li on 2019-01-23.
//  Copyright © 2019 Jason Li. All rights reserved.
//

import Foundation


class Post: NSObject {
    var image_url: String?
    var video_url: String?
    var caption: String?
    var post_id: String?
    var uid: String?
    var timestamp: [AnyHashable: Any]?
}
