//
//  MainViewController.swift
//  ARelax
//
//  Created by Sam Ding on 7/9/20.
//  Copyright © 2020 Kaishan Ding. All rights reserved.
//

import UIKit
import Lottie
import Foundation


class MainViewController: UIViewController {

    @IBOutlet weak var clview: UICollectionView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let icon : UIImage = "❕".image()!
        let alert = EMAlertController(icon: icon, title: "Warnings/Disclaimer", message: "If your neck has extreme pain, please call your doctor and stop using this app")
        alert.addAction(EMAlertAction(title: "Done", style: .cancel))
        self.present(alert, animated: true)
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        super.viewWillAppear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        super.viewWillDisappear(animated)
    }
    

}


extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.view.frame.width / 2 - 32
        return CGSize(width: width, height: width * 1.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mainCell", for: indexPath) as! MainCollectionViewCell
        cell.configure(item: indexPath.item)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        perform(#selector(MainViewController.navigate), with: nil, afterDelay: 0.1)
        
    }
    
    @objc private func navigate(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "VirtualVC") as! VirtualViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    

    

    
    
    
    
}


