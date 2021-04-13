//
//  ViewController.swift
//  Chapter2
//
//  Created by Alexandra Biryukova on 3/11/21.
//

import UIKit
import AVKit
import Vision
import CoreML

final class ViewController: UIViewController {
    @IBOutlet private var predictionLabel: UILabel!
    @IBOutlet private var confidenceLabel: UILabel!
    @IBOutlet private var imageView: UIImageView!
    
    @IBOutlet private var pauseButton: UIButton!
    @IBOutlet private var playButton: UIButton!
    @IBOutlet private var statisticButton: UIButton!
    
    @IBOutlet private var scrollView: UIScrollView!
    @IBOutlet private var errorScrollView: UIScrollView!
    
    var session: AVCaptureSession = AVCaptureSession()
    var isActiveSession: Bool = false {
        didSet {
            isActiveSession ? setupSession() : session.stopRunning()
            pauseButton.isEnabled = isActiveSession
            playButton.isEnabled = !isActiveSession
        }
    }
    var successMatches = 0 {
        didSet { appendImageToScrollView(isFailure: false) }
    }
    
    var failureMatches = 0 {
        didSet { appendImageToScrollView(isFailure: true) }
    }
    
    @IBAction
    private func actionButtonDidTap(_ sender: UIButton) {
        switch sender {
        case pauseButton:
            isActiveSession = false
        case playButton:
            isActiveSession = true
        case statisticButton:
            isActiveSession = false
            present(UIActivityViewController(activityItems: ["Статистика модели\nКол-во распознаваний: \(successMatches)\nКол-во ошибок: \(failureMatches)"], applicationActivities: nil), animated: true)
        default:
            break
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        [pauseButton, playButton, statisticButton].forEach {
            $0?.tintColor = .black
            $0?.backgroundColor = .white
            $0?.layer.cornerRadius = 32
        }
        isActiveSession = true
    }
}

// MARK: - AVCaptureVideoDataOutputSampleBufferDelegate

extension ViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    func setupSession() {
        guard let device = AVCaptureDevice.default(for: .video),
              let input = try? AVCaptureDeviceInput(device: device) else { return }
        session = AVCaptureSession()
        session.sessionPreset = .hd4K3840x2160
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.frame = view.frame
        previewLayer.videoGravity = .resizeAspectFill
        imageView.layer.addSublayer(previewLayer)
        
        let output = AVCaptureVideoDataOutput()
        output.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        
        session.addOutput(output)
        session.addInput(input)
        session.startRunning()
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer),
              let model = try? VNCoreMLModel(for: DogsClassifier_1(configuration: MLModelConfiguration()).model) else { return }
        let request = VNCoreMLRequest(model: model) { (data, error) in
            guard let results = data.results as? [VNClassificationObservation],
                  let firstObject = results.first else { return }
            DispatchQueue.main.async {
                if firstObject.confidence == 1 {
                    self.presentAlertViewController(title: firstObject.identifier.capitalized)
                }
                self.predictionLabel.text = firstObject.confidence * 100 >= 20 ? firstObject.identifier.capitalized : "--"
                self.confidenceLabel.text = firstObject.confidence * 100 >= 20 ?  String(firstObject.confidence * 100) + "%" : "--"
            }
        }
        try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
    }
}

private extension ViewController {
    func appendImageToScrollView(isFailure: Bool) {
        let imageView = UIImageView()
        imageView.image = UIImage(named: isFailure ? "Failure" : "Success")
        imageView.tintColor = isFailure ? .red : .green
        imageView.backgroundColor = .white
        imageView.layer.cornerRadius = 24
        let matches = isFailure ? failureMatches : successMatches
        let y = 48 * matches + (16 * max(0, matches - 1))
        imageView.frame = .init(x: 0, y: CGFloat(y), width: 48, height: 48)
        if isFailure {
            errorScrollView.addSubview(imageView)
            errorScrollView.contentSize = .init(width: 48,height: 64 * CGFloat(failureMatches))
        } else {
            scrollView.addSubview(imageView)
            scrollView.contentSize = .init(width: 48, height: 64 * CGFloat(successMatches))
        }
    }
    
    func presentAlertViewController(title: String) {
        DispatchQueue.main.async {
            self.isActiveSession = false
            let alertController = UIAlertController(title: "Model is sure that it is \(title)", message: "Is it right?", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "YES", style: .default, handler: { _ in
                self.successMatches += 1
            }))
            alertController.addAction(UIAlertAction(title: "NO", style: .cancel, handler: { _ in
                self.failureMatches += 1
            }))
            self.present(alertController, animated: true)
        }
    }
}
