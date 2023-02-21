
import UIKit

class CustomUIViewViewController: UIViewController {
    let customV = CustomUIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        customV.superview == nil ? customV.showView(under: sender) : customV.hideView()
    }
}
