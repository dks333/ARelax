//
//  Options.swift
//  ARelax
//
//  Created by Sam Ding on 7/10/20.
//  Copyright © 2020 Kaishan Ding. All rights reserved.
//

import Foundation
import UIKit

struct Options {
    var title = String()
    var subtitle = String()
    var image = UIImage()
    
    static let options = [Options(title: "Stretch", subtitle: "Stretch your neck at a slow pace", image: UIImage(systemName: "arrowtriangle.right.fill")!),
                          Options(title: "Game", subtitle: "Have not been implemented", image: UIImage(systemName: "gamecontroller.fill")!),
                          Options(title: "Game 2", subtitle: "This is Game 2", image: UIImage(systemName: "gamecontroller.fill")!),
                          Options(title: "Setting", subtitle: "This is Settings", image: UIImage(systemName: "gear")!),]

    
}
