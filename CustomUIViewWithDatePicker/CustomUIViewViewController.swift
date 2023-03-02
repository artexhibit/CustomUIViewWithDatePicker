
import UIKit

class CustomUIViewViewController: UIViewController {
    @IBOutlet weak var dateLabel: UILabel!
    
    let customV = CustomUIView()
    let customM = CustomUIMenu()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customV.delegate = self
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        customV.superview == nil ? customV.showView(under: sender) : customV.hideView()
    }
    
    @IBAction func showViewButtonPressed(_ sender: UIButton) {
        customM.superview == nil ? customM.showView(under: sender, in: self.view, with: ["Forex (Биржа)", "ЦБ РФ"]) : customM.hideView()
    }
}

extension CustomUIViewViewController: UIDatePickerDelegate {
    func didReceiveTap(in location: CGPoint) {
        if !customV.bounds.contains(location) { customV.hideView() }
    }
    
    func didPickedDateFromPicker(date: String) {
        dateLabel.text = date
    }
}
