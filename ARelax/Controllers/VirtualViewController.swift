//
//  ViewController.swift
//  ARelax
//
//  Created by Sam Ding on 7/8/20.
//  Copyright © 2020 Kaishan Ding. All rights reserved.
//

import UIKit
import ARKit
import SceneKit
import SwiftDate
import SnapKit
import Lottie


class VirtualViewController: UIViewController {

    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var directionImgView: UIImageView!
    @IBOutlet weak var cancelVCBtn: UIButton!
    
    var stackView = UIStackView()
    private lazy var animationView: AnimationView = {
        var animationView = AnimationView()
        animationView = .init(name: "celebration")
        animationView.frame = CGRect(x: UIScreen.main.bounds.width / 2 - 150, y: UIScreen.main.bounds.height / 2 - 150, width: 300, height: 300)
        animationView.contentMode = .scaleAspectFill
        animationView.loopMode = .playOnce
        animationView.animationSpeed = 1
        view.addSubview(animationView)
        return animationView
    }()
    
    var contentNode : SCNNode?
    lazy var leftEyeNode = SCNNode()
    lazy var rightEyeNode = SCNNode()
    var animating = false
    var currentDirection = -1
    
    var currentIndex = 0
    var indexArr : [Int] = []
    var imgViewArr : [UIImageView] = []
    let emptyImages = [UIImage(systemName: "arrowtriangle.right"),  UIImage(systemName: "arrowtriangle.left"), UIImage(systemName: "arrowtriangle.up"), UIImage(systemName: "arrowtriangle.down"),]
    let images = [UIImage(systemName: "arrowtriangle.right.fill"),  UIImage(systemName: "arrowtriangle.left.fill"), UIImage(systemName: "arrowtriangle.up.fill"), UIImage(systemName: "arrowtriangle.down.fill"),]
    
    @IBAction func navigateBack(_ sender: Any) {
        self.sceneView.session.pause()
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupScene()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.startTracking()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.sceneView.session.pause()
    }
    
    private func setupView(){
        view.bringSubviewToFront(directionImgView)
        createCompletionView()
        let cancelWidth = cancelVCBtn.frame.width
        let cancelHeight = cancelVCBtn.frame.height
        let cancelBtnBackgroundView = UIView(frame: CGRect(x: cancelVCBtn.center.x - cancelWidth/2, y: cancelVCBtn.center.y - cancelHeight/2, width: cancelWidth, height: cancelHeight))
        cancelBtnBackgroundView.backgroundColor = .lightGray
        cancelBtnBackgroundView.alpha = 0.5
        cancelBtnBackgroundView.layer.cornerRadius = 32.5
        view.addSubview(cancelBtnBackgroundView)
        view.insertSubview(cancelBtnBackgroundView, belowSubview: cancelVCBtn)
    }
    
    func arNotSupportedAlert(){
        let icon = UIImage(systemName: "camera.viewfinder")
        let alert = EMAlertController(icon: icon, title: "Unable to access camera", message: "Please enable the permission of \n using camera in Settings")
        alert.addAction(EMAlertAction(title: "Done", style: .cancel) {
            self.perform(#selector(VirtualViewController.navigate), with: nil, afterDelay: 0.1)
        })
        return
    }
    
    @objc func resetTracking() {
        guard ARFaceTrackingConfiguration.isSupported else {
            arNotSupportedAlert()
            return
        }
        let configuration = ARFaceTrackingConfiguration()
        configuration.isLightEstimationEnabled = true
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
    
    func startTracking(){
        let configuration = ARFaceTrackingConfiguration()
        configuration.isLightEstimationEnabled = true
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
    
    private func setupScene(){
        currentDirection = self.indexArr[self.currentIndex]
        self.directionImgView.image = images[self.indexArr[self.currentIndex]]
        sceneView.delegate = self
        sceneView.preferredFramesPerSecond = .min
        guard ARFaceTrackingConfiguration.isSupported else {
            arNotSupportedAlert()
            return 
        }
        
    }
    
    @objc private func navigate(){
         self.navigationController?.popViewController(animated: true)
    }

    private func addEyeTransformNodes(){
        guard let contentNode = contentNode else { return }
        rightEyeNode.simdPivot = float4x4(diagonal: SIMD4<Float>(3, 3, 3, 1))
        leftEyeNode.simdPivot = float4x4(diagonal: SIMD4<Float>(3, 3, 3, 1))
        
        contentNode.addChildNode(rightEyeNode)
        contentNode.addChildNode(leftEyeNode)
    }
    
    private func createCompletionView(){
        stackView = UIStackView(frame: CGRect(x: self.view.frame.width / 2 - 160, y: 50, width: 320, height: 50))
        stackView.alignment = .center
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        self.view.addSubview(stackView)
        
        for _ in 0..<10 {
            let num = Int.random(in: 0..<4)
            let imgView = UIImageView(image: emptyImages[num])
            indexArr.append(num)
            imgView.tintColor = .systemOrange
            stackView.addArrangedSubview(imgView)
            imgView.snp.makeConstraints({ make in
                // Horizontal Triangles
                make.width.equalTo(32)
                make.height.equalTo(32)
            })
            imgViewArr.append(imgView)
        }
        
        
        
    }
}

// MARK: - AR Scene Delegate
extension VirtualViewController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        guard anchor is ARFaceAnchor else { return nil }
        
        guard let device = sceneView.device else {
            return nil
        }
        
        let faceGeometry = ARSCNFaceGeometry(device: device)!
        let material = faceGeometry.firstMaterial!
               
        material.diffuse.contents = UIColor.clear
        material.lightingModel = .physicallyBased
        contentNode = SCNNode(geometry: faceGeometry)
        
        self.addEyeTransformNodes()
        print("started")
        return contentNode
    
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let faceGeometry = node.geometry as? ARSCNFaceGeometry,
            let faceAnchor = anchor as? ARFaceAnchor
            else { return }
        
        contentNode = SCNNode(geometry: faceGeometry)
        
        rightEyeNode.simdTransform = faceAnchor.rightEyeTransform
        leftEyeNode.simdTransform = faceAnchor.leftEyeTransform
        
        if self.checkDirection() == -1 {
            print("You need to move your face")
        } else if self.checkDirection() == self.currentDirection && !animating{
            print("Success")
            self.animating = true
            DispatchQueue.main.async {
                self.displayAnimation()
            }
        } else {
            print("Failure")
        }
        faceGeometry.update(from: faceAnchor.geometry)
    }
    
    
    /// Finish Stretch 
    private func finishStretch() {
        DispatchQueue.main.async {
            self.animationView.play(completion: { _ in
                let icon : UIImage = "🎉".image()!
                let alert = EMAlertController(icon: icon, title: "Stretch Finished", message: "Take a break and look at the distance")
                alert.addAction(EMAlertAction(title: "Back", style: .cancel) {
                    self.perform(#selector(VirtualViewController.navigate), with: nil, afterDelay: 0.1)
                })
                self.present(alert, animated: true)
            })
        }
    }
    

    
    private func checkDirection() -> Int{
        if rightEyeNode.simdRotation.x > 0.6 && abs(leftEyeNode.simdRotation.y - 0) < 0.4 && leftEyeNode.simdOrientation.angle > 0.12 {
            return 2
        } else if rightEyeNode.simdRotation.x < -0.5 && abs(leftEyeNode.simdRotation.y - 0) < 0.5 && leftEyeNode.simdOrientation.angle > 0.11{
            return 3
        } else if abs(rightEyeNode.simdRotation.x - 0) < 0.4 && leftEyeNode.simdRotation.y > 0.6 && leftEyeNode.simdOrientation.angle > 0.3{
            return 1
        } else if abs(rightEyeNode.simdRotation.x - 0) < 0.4 && leftEyeNode.simdRotation.y < -0.6 && leftEyeNode.simdOrientation.angle > 0.3 {
            return 0
        } else {
            return -1
        }
    }
    
    @objc private func displayAnimation() {
        UIView.animate(withDuration: 1.5, animations: {
            UIImpactFeedbackGenerator.init(style: .medium).impactOccurred()
            self.animateAfterUserPoint(num: self.indexArr[self.currentIndex])
            self.directionImgView.alpha = 0
            self.imgViewArr[self.currentIndex].image = self.images[self.indexArr[self.currentIndex]]
        }, completion: { (finished) in
            self.currentIndex += 1
            print(self.currentIndex)
            if self.currentIndex == 10 {
                /// Stretch Finished
                self.sceneView.session.pause()
                self.finishStretch()
            } else {
                self.directionImgView.image = self.images[self.indexArr[self.currentIndex]]
                self.currentDirection = self.indexArr[self.currentIndex]
                self.directionImgView.transform = .identity
                self.directionImgView.alpha = 1
                self.animating = false
            }
        })
    }
    
    private func animateAfterUserPoint(num: Int){
        switch num{
            case 0: // Right
                self.directionImgView.transform = CGAffineTransform(translationX: 200, y: 0)
            case 1: // Left
                self.directionImgView.transform = CGAffineTransform(translationX: -200, y: 0)
            case 2: // Up
                self.directionImgView.transform = CGAffineTransform(translationX: 0, y: -300)
            case 3: // Down
                self.directionImgView.transform = CGAffineTransform(translationX: 0, y: 300)
            default:
                break
        }
    }
    
    // MARK: - Error handling
    func session(_ session: ARSession, didFailWithError error: Error) {
        guard error is ARError else { return }
        
        let errorWithInfo = error as NSError
        let messages = [
            errorWithInfo.localizedDescription,
            errorWithInfo.localizedFailureReason,
            errorWithInfo.localizedRecoverySuggestion
        ]
        let errorMessage = messages.compactMap({ $0 }).joined(separator: "\n")
        
        DispatchQueue.main.async {
            self.displayErrorMessage(title: "The AR session failed.", message: errorMessage)
        }
    }
    
    
    func displayErrorMessage(title: String, message: String) {
        // Present an alert informing about the error that has occurred.
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let restartAction = UIAlertAction(title: "Restart Session", style: .default) { _ in
            alertController.dismiss(animated: true, completion: nil)
            self.resetTracking()
        }
        alertController.addAction(restartAction)
        present(alertController, animated: true, completion: nil)
    }
}
