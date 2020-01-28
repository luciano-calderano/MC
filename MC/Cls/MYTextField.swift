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
        placeholder = placeholder?.toLang()
        spellCheckingType = .no
        autocorrectionType = .no
        autocapitalizationType = (self.keyboardType == .default) ? .sentences : .none
        backgroundColor = .white
    }
}
