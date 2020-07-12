//
//  MainCollectionViewCell.swift
//  ARelax
//
//  Created by Sam Ding on 7/10/20.
//  Copyright © 2020 Kaishan Ding. All rights reserved.
//

import UIKit

struct MainBgGradient {
    static var color1 = (UIColor(named: "Color1-B")!, UIColor(named: "Color1-A")!)
    static var color2 = (UIColor(named: "Color2-B")!, UIColor(named: "Color2-A")!)
    static var color3 = (UIColor(named: "Color3-A")!, UIColor(named: "Color3-B")!)
    static var color4 = (UIColor(named: "Color4-A")!, UIColor(named: "Color4-B")!)
    
    static var colors = [color1, color2, color3, color4]
}

class MainCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var bgIconView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var subtitleLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override var isHighlighted: Bool {
        didSet {
            UIImpactFeedbackGenerator.init(style: .light).impactOccurred()
            self.animateWithSpring()

        }
    }
  
    
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath(roundedRect: self.contentView.bounds, byRoundingCorners: [.allCorners], cornerRadii: CGSize(width: 15, height: 15))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.contentView.layer.mask = mask
        
        self.addShadowEffect(radius: 8, offset: CGSize(width: 4, height: 4))
        super.draw(rect)
    }
    
    func configure(item: Int){
        contentView.addGradiant(name: "cell\(item)", color1: MainBgGradient.colors[item].0, color2: MainBgGradient.colors[item].1)
        let option = Options.options[item]
        iconView.image = option.image
        titleLbl.text = option.title
        subtitleLbl.text = option.subtitle
        bgIconView.image = option.image
    }
    
}
