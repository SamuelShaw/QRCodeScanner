//
//  ViewController.swift
//  QRCodeScanner
//
//  Created by Samuel Shaw on 12/28/15.
//  Copyright © 2015 The Iron Yard. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate
{
    
    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var qrCodeFrameView: UIView?
    
    @IBOutlet weak var label: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func scanMeButtonPressed(sender: AnyObject)
    {
        let captureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        
        var error: NSError?
        var input: AnyObject!
        
        do {
            
            input = try AVCaptureDeviceInput(device: captureDevice)
        } catch let error1 as NSError {
            error = error1
            input = nil
        }
        
        if (error != nil)
        {
            print("\(error?.localizedDescription)")
            return
        }
        
        captureSession = AVCaptureSession()
        captureSession?.addInput(input as! AVCaptureInput)
        
        let captureMetaDataOutput = AVCaptureMetadataOutput()
        captureSession?.addOutput(captureMetaDataOutput)
        
        captureMetaDataOutput.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        captureMetaDataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
        
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        videoPreviewLayer?.frame = view.layer.bounds
        view.layer.addSublayer(videoPreviewLayer!)
        
        captureSession?.startRunning()
        
        view.bringSubviewToFront(label)
        
        // bring the green code box into view
        qrCodeFrameView = UIView()
        qrCodeFrameView?.layer.borderColor = UIColor.greenColor().CGColor
        qrCodeFrameView?.layer.borderWidth = 2
        view.addSubview(qrCodeFrameView!)
        view.bringSubviewToFront(qrCodeFrameView!)
    }
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        if metadataObjects == nil || metadataObjects.count == 0
        {
            qrCodeFrameView?.frame = CGRectZero
            label.text = "No QR code detected"
            return
        }
        
        let metaDateObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if metaDateObj.type == AVMetadataObjectTypeQRCode
        {
            let barcodeObject = videoPreviewLayer?.transformedMetadataObjectForMetadataObject(metaDateObj as AVMetadataMachineReadableCodeObject) as! AVMetadataMachineReadableCodeObject
            qrCodeFrameView?.frame = barcodeObject.bounds
            
            if metaDateObj.stringValue != nil
            {
                label.text = metaDateObj.stringValue
            }
        }
    }

}

