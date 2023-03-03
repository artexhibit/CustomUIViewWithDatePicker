
import UIKit

class CustomUIViewViewController: UIViewController {
    @IBOutlet weak var dateLabel: UILabel!
    
    let customV = CustomUIView()
    let customM = CustomUIMenu()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customV.delegate = self
        customM.delegate = self
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        if customV.superview == nil { customV.showView(under: sender) }
    }
    
    @IBAction func showViewButtonPressed(_ sender: UIButton) {
        if customM.superview == nil { customM.showView(under: sender, in: self.view, with: ["Forex (Биржа)", "ЦБ РФ"]) }
    }
}

extension CustomUIViewViewController: UIDatePickerDelegate, CustomUIMenuDelegate {
    func didReceiveTapForUIMenu(in location: CGPoint) {
        if !customM.bounds.contains(location) { customM.hideView() }
    }
    
    func didReceiveTap(in location: CGPoint) {
        if !customV.bounds.contains(location) { customV.hideView() }
    }
    
    func didPickedDateFromPicker(date: String) {
        dateLabel.text = date
    }
}
