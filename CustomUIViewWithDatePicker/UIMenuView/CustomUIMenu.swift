
import UIKit

protocol CustomUIMenuDelegate {
    func didReceiveTapForUIMenu(in location: CGPoint)
}

class CustomUIMenu: UIView {
    
    @IBOutlet weak var cornerView: UIView!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    private var itemsToShow = [String]()
    private var heightConstraint: NSLayoutConstraint?
    private var viewWidth: CGFloat {
        return UIScreen.main.bounds.size.height == 568.0 ? 180 : 250
    }
    private var tapGestureRecogniser: UITapGestureRecognizer?
    var delegate: CustomUIMenuDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        heightConstraint?.constant = tableView.contentSize.height
    }
    
    private func configureTapGestureRecogniser() {
        guard let superview = superview else { return }
        tapGestureRecogniser = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        if let tapGR = tapGestureRecogniser {
            tapGR.cancelsTouchesInView = false
            superview.addGestureRecognizer(tapGR)
        }
    }
    
    @objc private func handleTap(_ tap: UITapGestureRecognizer) {
        let location = tap.location(in: self)
        delegate?.didReceiveTapForUIMenu(in: location)
    }
    
    private func configure() {
        if let views = Bundle.main.loadNibNamed("CustomUIMenu", owner: self) {
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
        let nib = UINib(nibName: "UIMenuTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "UIMenuTableViewCell")
    }
    
    private func configureView(under button: UIButton, in view: UIView) {
        self.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(self)
        
        self.leadingAnchor.constraint(equalTo: button.leadingAnchor, constant: 0).isActive = true
        self.topAnchor.constraint(equalTo: button.bottomAnchor, constant: 10.0).isActive = true
        self.widthAnchor.constraint(equalToConstant: viewWidth).isActive = true
        heightConstraint = self.heightAnchor.constraint(equalToConstant: 0)
        heightConstraint?.isActive = true
        
        self.setNeedsLayout()
        self.layoutIfNeeded()
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
    
    func showView(under button: UIButton, in view: UIView, with items: [String]) {
        self.itemsToShow = items
        configureView(under: button, in: view)
        configureViewDesign()
        configureTapGestureRecogniser()
        
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
            self.heightConstraint?.isActive = false
            self.tapGestureRecogniser?.view?.removeGestureRecognizer(self.tapGestureRecogniser!)
            self.removeFromSuperview()
        }
    }
}

extension CustomUIMenu: UITableViewDelegate, UITableViewDataSource {
    //MARK: - TableView DataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return itemsToShow.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UIMenuTableViewCell", for: indexPath) as! UIMenuTableViewCell
        cell.itemLabel.text = itemsToShow[indexPath.row]
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.hideView()
    
        guard let cell = tableView.cellForRow(at: indexPath) as? UIMenuTableViewCell else { return }
        
        if cell.iconImage.isHidden {
            for row in 0..<tableView.numberOfRows(inSection: 0) {
                guard let cell = tableView.cellForRow(at: IndexPath(row: row, section: 0)) as? UIMenuTableViewCell else { return }
                cell.iconImage.isHidden = true
            }
        }
        cell.iconImage.isHidden = false
    }
}
