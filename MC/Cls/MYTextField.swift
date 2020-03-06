//
//  MYTextField
//

import UIKit

class MYTextField: UITextField {
    
    var myPlaceHolder = ""
    @IBOutlet var nextTextField: MYTextField?
    
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
        spellCheckingType = .no
        autocorrectionType = .no
        autocapitalizationType = (keyboardType == .default) ? .sentences : .none
        backgroundColor = .white
    }
}
