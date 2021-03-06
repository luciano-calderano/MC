//
//  MYButton.swift
//

import UIKit

class MYLabel: UILabel {
    var title: String {
        get {
            return text!
        }
        set {
            text = newValue
        }
    }
    required internal init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    override internal func awakeFromNib() {
        super.awakeFromNib()
        initialize()
    }
    
    fileprivate func initialize () {
        minimumScaleFactor = 0.75
        adjustsFontSizeToFitWidth = true
        font = UIFont.boldSystemFont(ofSize: font.pointSize)
        if let text = text {
            title = text
        }
    }
}
