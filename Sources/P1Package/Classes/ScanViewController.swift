import UIKit
import AVFoundation

open class ScanViewController: BaseViewController<ScanView> {
      
    private var viewModel: ScanViewModel
    private var partnerManager: PartnerManager
    var viewTitle: String

    /// Camera Setup Variables
    ///
    private var previewLayer: AVCaptureVideoPreviewLayer!
    private var captureSession: AVCaptureSession?
    private var backCamera: AVCaptureDevice!
    private var backInput: AVCaptureInput!
    private var captureConnection: AVCaptureConnection?
    private var photoSettings: AVCapturePhotoSettings!
    private var photoOutput = AVCapturePhotoOutput()
  
    //MARK: - init
    public init(viewModel: ScanViewModel, partnerManager: PartnerManager, viewTitle: String = "") {
        self.viewModel = viewModel
        self.partnerManager = partnerManager
        self.viewTitle = viewTitle
        super.init()
    }
  
  //MARK: - ViewController Lifecycle
  open override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
      
      viewModel.sideTitle = viewTitle
      checkPermissions()
      updateUIState()
  }
    
    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        if(self.captureSession?.isRunning == true) {
            self.captureSession?.stopRunning()
        }
    }
  
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        baseView.setupMaskLayer()
    }
  
    open override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 11.0, *) {
          setupBinds()
        }
    }

    open override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

//MARK: - Setup AV Foundation Camera Presets

extension ScanViewController {
  func checkPermissions() {
    
    let cameraAuthStatus =  AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
    
    switch cameraAuthStatus {
    case .authorized:
      self.prepareCamera()
    case .denied:
        showAlert(title: "Atenção", message: "Você precisa dar permissão para utilizar a câmera de seu device. Vá em suas configurações e habilite o uso.")
    case .notDetermined:
      AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { [weak self] (authorized) in
        guard let self = self else { return }
        if(authorized) {
            self.prepareCamera()
        } else {
            showAlert(title: "Atenção", message: "Você precisa dar permissão para utilizar a câmera de seu device. Vá em suas configurações e habilite o uso.")
        }
      })
    case .restricted:
        showAlert(title: "Atenção", message: "Você precisa dar permissão para utilizar a câmera de seu device. Vá em suas configurações e habilite o uso.")
    @unknown default:
      fatalError()
    }
  }
  
  func prepareCamera() {
    
      if(self.captureSession == nil) {
          self.captureSession = AVCaptureSession()
          self.captureSession?.beginConfiguration()
          
            if ((captureSession?.canSetSessionPreset(.photo)) != nil) {
            captureSession?.sessionPreset = AVCaptureSession.Preset.photo
          }
          
          let availableDevices = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera],
                                                                  mediaType: .video, position: .back).devices
          backCamera = availableDevices.first
          startCaptureSession()
      } else {
          DispatchQueue.global(qos: .default).async {
              [weak self] in
              
              self?.captureSession?.startRunning()
          }
      }
  }
  
  func startCaptureSession() {
    DispatchQueue.global(qos: .userInitiated).async { [weak self] in
      guard let self = self else { return }
      
      if #available(iOS 10.0, *) {
        self.captureSession?.automaticallyConfiguresCaptureDeviceForWideColor = true
      }
      
      self.setupInputs()
      
      DispatchQueue.main.async {
        self.setupPreviewLayer()
      }
      
      self.setupOutput()
      
      self.captureSession?.commitConfiguration()
      self.captureSession?.startRunning()
    }
  }
  
  func setupInputs() {
    if #available(iOS 10.0, *) {
      if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) {
        self.backCamera = device
      } else {
//        fatalError("Sorry! There's no back camera available at this moment.")
          showAlert(title: "Atenção", message: "Não foi possivêl abrir a câmera de seu device. Verifique a permissão e tente novamente.")
          return
      }
    }
    
    guard let bInput = try? AVCaptureDeviceInput(device: backCamera) else {
//      fatalError("could not create input device from back camera")
        showAlert(title: "Atenção", message: "Não foi possivêl abrir a câmera de seu device. Verifique a permissão e tente novamente.")
        return
    }
      
    backInput = bInput
      if !(captureSession?.canAddInput(backInput))! {
//      fatalError("could not add back camera input to capture session")
          
          showAlert(title: "Atenção", message: "Não foi possivêl abrir a câmera de seu device. Verifique a permissão e tente novamente.")
          return
    }
    
    captureSession?.addInput(backInput)
  }
  
  func setupOutput() {
      if ((captureSession?.canAddOutput(photoOutput)) != nil) {
      captureSession?.addOutput(photoOutput)
    }
    
    photoOutput.connections.first?.videoOrientation = .portrait
  }
  
  func setupPreviewLayer(){
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
        previewLayer.frame.size = CGSize(width: baseView.frame.width, height: baseView.frame.height)
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.connection?.videoOrientation = .portrait
        
        baseView.cameraContainer.layer.insertSublayer(previewLayer, below: baseView.background.cropReferenceView.layer)
        baseView.cameraContainer.addSubview(baseView.background)
      baseView.sendSubviewToBack(baseView.cameraContainer)
    }
}

//MARK: - Picture Actions Delegate

@available(iOS 11.0, *)
extension ScanViewController: AVCaptureVideoDataOutputSampleBufferDelegate, AVCapturePhotoCaptureDelegate {
  
    public func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        captureSession?.stopRunning()
        
        guard let cgImage = photo.cgImageRepresentation() else { return }
        var previewImage = UIImage(cgImage: cgImage)
        
        if(previewImage.size.width > previewImage.size.height) {
            previewImage = previewImage.rotate(degrees: 90)!
        }
        
        let cropRect = CGRect(
              x: baseView.background.cropReferenceView.frame.origin.x,
              y: baseView.background.cropReferenceView.frame.origin.y,
              width: baseView.background.cropReferenceView.frame.width,
              height: baseView.background.cropReferenceView.frame.height
        )
        
        guard var croppedImage = ImageHelper.cropImage(
            previewImage,
            toRect: cropRect,
            imageViewWidth: baseView.cameraContainer.frame.width,
            imageViewHeight: baseView.cameraContainer.frame.height
        ) else {
            return
        }
                
        croppedImage = croppedImage.imageResizedIfNedd()
          
        let photoPreviewContainer = baseView.photoPreviewContainer
        photoPreviewContainer.imageView.image = previewImage
        
        let type = viewTitle == viewModel.setPhotoSide(.frontView) ? "FRENTE" : "VERSO"
        
        self.viewModel.appendDocumentPicture(
            type: type,
            byte: self.convertImageToBase64String(img:croppedImage)
        )
        
        print("view \(self.view.frame)")
        print("view 2 \(self.baseView.cameraContainer.frame)")
        
        
        
        print("@! >>> Documento da \(viewTitle) adicionado.")
        print("@! >>> Numero de itens: \(partnerManager.documentsImages.count)")
        
        viewModel.takePictureState = .confirmation
        updateUIState()
  }
    
    private func convertImageToBase64String (img: UIImage) -> String {
        return img.compress(.medium)?.base64EncodedString() ?? ""
    }
  
    @objc
    func takePicure() {
        switch viewModel.takePictureState {
        case .takePicture:
          let photoSettings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
          
          if let photoPreviewType = photoSettings.availablePreviewPhotoPixelFormatTypes.first {
              photoSettings.previewPhotoFormat = [kCVPixelBufferPixelFormatTypeKey as String: photoPreviewType]
              photoOutput.capturePhoto(with: photoSettings, delegate: self)
          }
        case .confirmation:
          self.viewModel.navigateToNextView(self)
        }
    }
}

extension ScanViewController {
  
  func setupBinds() {
    /// Setup View Title
    /// * Return from viewModel as (.front)*
    ///
    navigationItem.hidesBackButton = true
    baseView.viewTitle.text = viewTitle
    
    baseView.didTapTakePicture = { [weak self] in
      guard let self = self else {
        return
      }
      
//      if self.viewTitle == self.viewModel.setPhotoSide(.backView) {
//        self.baseView.takePicBtn.isUserInteractionEnabled = false
//      }
      
      if #available(iOS 11.0, *) {
        self.takePicure()
      }
      
    }
    
    baseView.didTapBack = { [weak self] in
      guard let self = self else { return }
        
        switch viewModel.takePictureState {
        case .takePicture:
            DispatchQueue.global(qos: .userInitiated).async {
                self.captureSession?.stopRunning()
            }
          
          self.navigationController?.popViewController(animated: true)
        
        case .confirmation:
            viewModel.takePictureState = .takePicture
            updateUIState()
            DispatchQueue.global(qos: .background).async {
                self.captureSession?.startRunning()
            }
        }
    }
  }
    
    private func updateUIState() {
        switch viewModel.takePictureState {
        case .takePicture:
            baseView.confirmationLabel.isHidden = true
            baseView.takePicBtn.setTitle("Fotografar", for: .normal)
            baseView.returnBtn.setTitle("Voltar", for: .normal)
        case .confirmation:
            baseView.confirmationLabel.isHidden = false
            baseView.takePicBtn.setTitle("Sim", for: .normal)
            baseView.returnBtn.setTitle("Refazer", for: .normal)
        }
    }
}
