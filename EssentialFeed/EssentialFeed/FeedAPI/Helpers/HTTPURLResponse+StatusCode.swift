//
//  HTTPURLResponse+StatusCode.swift
//  EssentialFeed
//
//  Created by Intan Nurjanah on 10/11/22.
//

import Foundation

extension HTTPURLResponse {
    private static var OK_200: Int { return 200 }
    
    var isOK: Bool {
        return statusCode == HTTPURLResponse.OK_200
    }
}
