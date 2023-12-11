//
//  SignInHeaderView.swift
//  Thoughts
//
//  Created by Sherozbek on 22/11/23.
//

import UIKit

class SignInHeaderView: UIView {

    private let imageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "logo"))
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .systemPink
        return imageView
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.text = "Explore millions of articles!"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        addSubview(imageView)
        addSubview(label)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.center = CGPoint(x: bounds.width / 2, y: bounds.height / 2 - 20)
        let logoSize: CGFloat = 100
        imageView.frame.size = CGSize(width: logoSize, height: logoSize)
//        label.sizeToFit()
//        label.center = CGPoint(x: bounds.width / 2, y: imageView.frame.maxY + 20 + label.bounds.height / 2)
        let labelWidth = bounds.width - 40
        let labelSize = label.sizeThatFits(CGSize(width: labelWidth, height: CGFloat.greatestFiniteMagnitude))
        label.frame = CGRect(x: (bounds.width - labelSize.width) / 2,
                                     y: imageView.frame.maxY + 20,
                                     width: labelSize.width,
                                     height: labelSize.height)
    }
}
