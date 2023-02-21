
import UIKit

class CustomUIView: UIView {
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var doneButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    
    @IBAction func doneButtonPressed(_ sender: UIButton) {
        hideView()
    }
    
    private func configure() {
        if let views = Bundle.main.loadNibNamed("CustomUIView", owner: self) {
            guard let view = views.first as? UIView else { return }
            view.translatesAutoresizingMaskIntoConstraints = false
            addSubview(view)
            
            NSLayoutConstraint.activate([
                view.topAnchor.constraint(equalTo: topAnchor, constant: 0.0),
                view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0.0),
                view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0.0),
                view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0.0),
            ])
        }
    }
    
    func findWindow() -> UIWindow? {
        let scenes = UIApplication.shared.connectedScenes
        guard let windowScene = scenes.first as? UIWindowScene,
              let window = windowScene.windows.first
        else {
            return nil
        }
        return window
    }
    
    func showView(under button: UIButton) {
        configurePopup(under: button)
        
        self.backgroundColor = .clear
        self.layer.cornerRadius = 20
        self.clipsToBounds = true
        
        UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseInOut) {
            self.alpha = 1.0
        }
    }
    
    func hideView() {
        UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseInOut) {
            self.alpha = 0.0
        } completion: { [weak self] _ in
            guard let self = self else { return }
            self.removeFromSuperview()
        }
    }
    
    private func configurePopup(under button: UIButton) {
        guard let window = findWindow() else { return }
        
        self.translatesAutoresizingMaskIntoConstraints = false
        window.addSubview(self)
        
        self.centerXAnchor.constraint(equalTo: window.centerXAnchor).isActive = true
        self.topAnchor.constraint(equalTo: button.bottomAnchor, constant: 10.0).isActive = true
        self.widthAnchor.constraint(equalTo: window.safeAreaLayoutGuide.widthAnchor, multiplier: 0.95).isActive = true
        self.heightAnchor.constraint(equalTo: window.safeAreaLayoutGuide.heightAnchor, multiplier: 0.5).isActive = true
        
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.topAnchor.constraint(equalTo: doneButton.bottomAnchor).isActive = true
        datePicker.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        datePicker.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        datePicker.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
}
