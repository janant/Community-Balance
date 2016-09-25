//
//  YouTubeViewer.swift
//  Community Balance
//
//  Created by Anant Jain on 12/29/14.
//  Copyright (c) 2014 Anant Jain. All rights reserved.
//

import UIKit

class YouTubeViewer {
    class func HTMLStringWithVideoURLString(_ string: String) -> String {
        var htmlString = "<iframe width=\"960\" height=\"720\" src=\"http://www.youtube.com/embed/"
        var identifier = string
        
        identifier.removeSubrange(string.range(of: identifier.hasPrefix("https") ? "https://www.youtube.com/watch?v=" : "http://www.youtube.com/watch?v=", options: String.CompareOptions.literal, range: nil, locale: nil)!)
        
        htmlString += "\(identifier)\" frameborder=\"0\" allowfullscreen></iframe>"
        
        return htmlString
    }
}
