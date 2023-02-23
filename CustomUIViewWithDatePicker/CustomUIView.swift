
import UIKit

protocol UIDatePickerDelegate {
    func didPickedDateFromPicker(date: String)
}

class CustomUIView: UIView {
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var cornerView: UIView!
    
    var delegate: UIDatePickerDelegate?
    var date: String?
    var today: String?
    
    private var formatter: DateFormatter {
        get {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd.MM.yyyy"
            return formatter
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    @IBAction func doneButtonPressed(_ sender: UIButton) {
        delegate?.didPickedDateFromPicker(date: date ?? "")
        hideView()
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        hideView()
    }
    
    @IBAction func datePickerPressed(_ sender: UIDatePicker) {
        date = formatter.string(from: sender.date)
        today = formatter.string(from: Date())
        configureDoneButton()
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
        configureView(under: button)
        datePicker.date = Date()
        configureDoneButton()
        configureViewDesign()
        
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.55, initialSpringVelocity: 2, options: .curveEaseOut) {
            self.alpha = 1.0
            self.transform = .identity
        }
    }
    
    func hideView() {
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.55, initialSpringVelocity: 2, options: .curveEaseOut) {
            self.alpha = 0.0
            self.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        } completion: { [weak self] _ in
            guard let self = self else { return }
            self.removeFromSuperview()
        }
        date = formatter.string(from: Date())
    }
    
    private func configureView(under button: UIButton) {
        guard let window = findWindow() else { return }
        
        self.translatesAutoresizingMaskIntoConstraints = false
        window.addSubview(self)

        self.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: 0).isActive = true
        self.topAnchor.constraint(equalTo: button.bottomAnchor, constant: 10.0).isActive = true
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            self.widthAnchor.constraint(equalToConstant: 400.0).isActive = true
            self.heightAnchor.constraint(equalToConstant: 400.0).isActive = true
        } else {
            if UIScreen.main.bounds.size.height == 568.0 {
                self.heightAnchor.constraint(equalTo: window.safeAreaLayoutGuide.heightAnchor, multiplier: 0.6).isActive = true
                self.widthAnchor.constraint(equalTo: window.safeAreaLayoutGuide.widthAnchor, multiplier: 0.8).isActive = true
            } else {
                self.heightAnchor.constraint(equalTo: window.safeAreaLayoutGuide.heightAnchor, multiplier: 0.43).isActive = true
                self.widthAnchor.constraint(equalTo: window.safeAreaLayoutGuide.widthAnchor, multiplier: 0.75).isActive = true
            }
        }
        configureDatePicker()
        
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
    
    private func configureDatePicker() {
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.topAnchor.constraint(equalTo: doneButton.bottomAnchor).isActive = true
        datePicker.bottomAnchor.constraint(equalTo: cornerView.bottomAnchor).isActive = true
        datePicker.leadingAnchor.constraint(equalTo: cornerView.leadingAnchor).isActive = true
        datePicker.trailingAnchor.constraint(equalTo: cornerView.trailingAnchor).isActive = true
    }
    
    private func configureDoneButton() {
        if date != today {
            doneButton.isHidden = false
            doneButton.isUserInteractionEnabled = true
        } else {
            doneButton.isHidden = true
            doneButton.isUserInteractionEnabled = false
        }
    }
    
    private func configureViewDesign() {
        self.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowOpacity = 0.2
        self.layer.shadowOffset = CGSize(width: 0.0, height: 6.0)
        self.layer.shadowRadius = 6.0
        self.layer.masksToBounds = false
        
        cornerView.layer.masksToBounds = true
        cornerView.clipsToBounds = true
        cornerView.layer.cornerRadius = 20
    }
}
