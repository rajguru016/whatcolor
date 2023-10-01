//
//  ViewController.swift
//  WhatColor
//
//  Created by Gururaj Desai on 9/24/23.
//

import UIKit
import QuartzCore

//
class ViewController: UIViewController {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.backgroundColor = .secondarySystemBackground
        
        button.backgroundColor = .systemBlue;
        button.setTitle("Take Picture", for: .normal)
        button.setTitleColor(.white, for: .normal)
    }
    
    @IBAction func didTapButton() {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = self
        present(picker, animated: true)
        
        
                
        //var color = colorOfPoint(point: CGPoint(x:40, y:80))
        //print("color-----> ", color)
    }
    
    
}
    
extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        
        imageView.image = image //loads image on ImageView viewer on screen
        
        // to identify the color in the image
        //let color = colorOfPoint(point: CGPoint(x:40, y:80))
        //print("color-----> ", color)
        //
    }
    
    
    
    //pixel idenitfy
    func colorOfPoint(point: CGPoint) -> UIColor {
        let colorSpace: CGColorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        
        var pixelData: [UInt8] = [0, 0, 0, 0]
        
        let context = CGContext(data: &pixelData, width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 4, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)
        
        context!.translateBy(x: -point.x, y: -point.y)
        
        //self.layer.render(in: context!)
        
        let red: CGFloat = CGFloat(pixelData[0]) / CGFloat(255.0)
        let green: CGFloat = CGFloat(pixelData[1]) / CGFloat(255.0)
        let blue: CGFloat = CGFloat(pixelData[2]) / CGFloat(255.0)
        let alpha: CGFloat = CGFloat(pixelData[3]) / CGFloat(255.0)
        
        let color: UIColor = UIColor(red: red, green: green, blue: blue, alpha: alpha)
        
        return color
    }
    
    
    }

extension UIImage {
    var averageColor: UIColor? {
        guard let inputImage = CIImage(image: self) else { return nil }
        let extentVector = CIVector(x: inputImage.extent.origin.x, y: inputImage.extent.origin.y, z: inputImage.extent.size.width, w: inputImage.extent.size.height)

        guard let filter = CIFilter(name: "CIAreaAverage", parameters: [kCIInputImageKey: inputImage, kCIInputExtentKey: extentVector]) else { return nil }
        guard let outputImage = filter.outputImage else { return nil }

        var bitmap = [UInt8](repeating: 0, count: 4)
        let context = CIContext(options: [.workingColorSpace: kCFNull])
        context.render(outputImage, toBitmap: &bitmap, rowBytes: 4, bounds: CGRect(x: 0, y: 0, width: 1, height: 1), format: .RGBA8, colorSpace: nil)

        print("Color >>>>>> ",UIColor(red: CGFloat(bitmap[0]) / 255, green: CGFloat(bitmap[1]) / 255, blue: CGFloat(bitmap[2]) / 255, alpha: CGFloat(bitmap[3]) / 255))
        return UIColor(red: CGFloat(bitmap[0]) / 255, green: CGFloat(bitmap[1]) / 255, blue: CGFloat(bitmap[2]) / 255, alpha: CGFloat(bitmap[3]) / 255)
    }

}

