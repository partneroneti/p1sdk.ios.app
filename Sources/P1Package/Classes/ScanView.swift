import UIKit

open class ScanView: BaseView {
  
  var didTapTakePicture: (() -> Void)?
  var didTapBack: (() -> Void)?
  
  let photoPreviewContainer: CapturedImageView = {
    let view = CapturedImageView()
    return view
  }()
  
  let background: CroppingView = {
    let view = CroppingView()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  let cameraContainer: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  let viewTitle: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 26, weight: .regular)
    label.textColor = .white
    label.textAlignment = .center
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
    let confirmationLabel: UILabel = {
        let label = UILabel()
        label.text = "A foto ficou boa?"
        label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.isHidden = true
        return label
    }()
    
  lazy var takePicBtn: UIButton = {
    let button = UIButton()
    button.backgroundColor = .systemRed
    button.setTitle("Fotografar", for: .normal)
    button.setTitleColor(.white, for: .normal)
    button.layer.cornerRadius = 25
    button.addTarget(self, action: #selector(takePictureAction), for: .touchUpInside)
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()
  
  lazy var returnBtn: UIButton = {
    let button = UIButton()
    button.setTitle("Voltar", for: .normal)
    button.setTitleColor(.white, for: .normal)
    button.addTarget(self, action: #selector(backAction), for: .touchUpInside)
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()
  
  // MARK: - Initialize
  
    open override func initialize() {
        backgroundColor = .black
          
        addSubview(viewTitle)
        addSubview(takePicBtn)
        addSubview(returnBtn)
        addSubview(cameraContainer)
        addSubview(confirmationLabel)
        cameraContainer.addSubview(background)
    }
  
  open override func installConstraints() {
    if #available(iOS 11.0, *) {
      NSLayoutConstraint.activate([
        cameraContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
        cameraContainer.trailingAnchor.constraint(equalTo: trailingAnchor),
        cameraContainer.topAnchor.constraint(equalTo: topAnchor),
        cameraContainer.bottomAnchor.constraint(equalTo: bottomAnchor),
                
        background.leadingAnchor.constraint(equalTo: cameraContainer.leadingAnchor),
        background.trailingAnchor.constraint(equalTo: cameraContainer.trailingAnchor),
        background.topAnchor.constraint(equalTo: cameraContainer.topAnchor),
        background.bottomAnchor.constraint(equalTo: cameraContainer.bottomAnchor),
                
        viewTitle.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
        viewTitle.widthAnchor.constraint(equalTo: widthAnchor),
        
        confirmationLabel.bottomAnchor.constraint(equalTo: takePicBtn.topAnchor, constant: -40),
        confirmationLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
        
        takePicBtn.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25),
        takePicBtn.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25),
        takePicBtn.heightAnchor.constraint(equalToConstant: 50),
        takePicBtn.bottomAnchor.constraint(equalTo: returnBtn.topAnchor, constant: -20),
        
        returnBtn.heightAnchor.constraint(equalToConstant: 30),
        returnBtn.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -50),
        returnBtn.widthAnchor.constraint(equalTo: widthAnchor),
                
        background.content.topAnchor.constraint(equalTo: viewTitle.bottomAnchor),
        background.content.bottomAnchor.constraint(equalTo: takePicBtn.topAnchor),
        
      ])
    }
  }
  
  func setupMaskLayer() {
    let maskLayer = CAShapeLayer()
    maskLayer.frame = background.bounds
    maskLayer.lineWidth = 5
    maskLayer.cornerRadius = 15
    
    let path = UIBezierPath(roundedRect: background.bounds,
                            byRoundingCorners: [.topLeft, .topRight, .bottomLeft, .bottomRight],
                            cornerRadii: CGSize(width: 0, height: 0))
      maskLayer.fillRule = CAShapeLayerFillRule.evenOdd
    
    background.cropReferenceView.addDashedBorder(radius: 10, pattern: [4,4], color: UIColor.white.cgColor)
    background.cropReferenceView.layer.borderWidth = 10
    background.cropReferenceView.layer.cornerRadius = 10
    
    path.append(UIBezierPath(rect: background.cropReferenceView.frame))
    maskLayer.path = path.cgPath
    
    background.layer.mask = maskLayer
  }
}

private extension ScanView {
  @objc
  func takePictureAction() {
    self.didTapTakePicture?()
  }
  
  @objc
  func backAction() {
    self.didTapBack?()
  }
}
