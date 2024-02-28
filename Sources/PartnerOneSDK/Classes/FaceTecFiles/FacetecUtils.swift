//
//  FacialScanManager.swift
//  PartnerOneSDK
//
//  Created by Adriano Mazucato on 19/01/23.
//
//

import FaceTecSDK

//class FacialScanManager {
//    
//    class func startLiveness(sessionToken: String, parentViewController: UIViewController) {
//        
//        Config.initializeFaceTecSDKFromAutogeneratedConfig(completion: { [weak self] initializationSuccessful in
//          guard let self = self else {
//            return
//          }
//            
//            if initializationSuccessful {
//                print("@! >>> Facetec inicializado com sucesso")
//                
//                let livenessProcessor = LivenessCheckProcessor(
//                  sessionToken: sessionToken,
//                  fromViewController: parentViewController
//                )
//                
//                livenessProcessor.success = true
////                livenessProcessor.faceScanResultCallback = resultCallback
//                
//            } else {
//                print("@! >>> Erro ao inicializar Facetec:")
//            }
//        })
//    }
//    
//}

class FacetecUtils {
    // -------------------------------------
    // Convenience method to initialize the FaceTec SDK.
    // NOTE: This function is auto-populated by the FaceTec SDK Configuration Wizard based on the Keys issued to your Apps.
      static func initializeFaceTecSDKFromAutogeneratedConfig(with productionKeyText: String, deviceKeyIdentifier: String, faceScanEncryptionKey: String, completion: @escaping (Bool)->()) {
          
          print("@! >>> FaceTec_DeviceKeyIdentifier: ", deviceKeyIdentifier)
          print("@! >>> FaceTec_PublicFaceScanEncryptionKey: ", faceScanEncryptionKey)
          print("@! >>> FaceTec_ProductionKeyText: ", productionKeyText)
          
          Config.loadFont(withName: "SFProDisplay-Regular")
          
          print("Teste \(Bundle.module.url(forResource: "FaceTec", withExtension: "strings"))")
          
          let bundleModule = Bundle.module
          let settingsURL = Bundle.module.url(forResource: "settings", withExtension: "plist")
          
          FaceTec.sdk.configureLocalization(withTable: nil, bundle: bundleModule)
          FaceTec.sdk.initializeInProductionMode(
              productionKeyText: productionKeyText,
              deviceKeyIdentifier: deviceKeyIdentifier,
              faceScanEncryptionKey: faceScanEncryptionKey,
              completion: { initializationSuccessful in
                  completion(initializationSuccessful)
          })
    }
}
