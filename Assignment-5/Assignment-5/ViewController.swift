//
//  ViewController.swift
//  Assignment-5
//
//  Created by Alexandra Biryukova on 4/11/21.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    var heroes = [String: Hero]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARImageTrackingConfiguration()
        
        guard let trackingImages = ARReferenceImage.referenceImages(inGroupNamed: "Heroes", bundle: nil) else {
            fatalError("Coudn't load tracking images")
        }
        
        configuration.trackingImages = trackingImages

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        guard let imageAnchor = anchor as? ARImageAnchor,
              let name = imageAnchor.referenceImage.name,
              let hero = heroes[name] else { return nil }
        
        let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
        plane.firstMaterial?.diffuse.contents = UIColor.clear
        
        let planeNode = SCNNode(geometry: plane)
        planeNode.eulerAngles.x = -.pi / 2
        
        let node = SCNNode()
        node.addChildNode(planeNode)
        
        let spacing: Float = 0.005
        let titleNode = textNode(hero.alias + "\n(\(hero.name))", font: .boldSystemFont(ofSize: 8))
        titleNode.pivotOnTopLeft()
        titleNode.position.x += Float(plane.width / 2) + spacing
        titleNode.position.y += Float(plane.height / 2)
        planeNode.addChildNode(titleNode)
        let bioNode = textNode(["Dates: \(hero.dates)", "Country: \(hero.country)", hero.bio, hero.source].joined(separator: "\n\n"),
                               font: .boldSystemFont(ofSize: 4),
                               maxWidth: 100)
        bioNode.pivotOnTopLeft()
        bioNode.position.x += Float(plane.width / 2) + spacing
        bioNode.position.y = titleNode.position.y - titleNode.height - spacing
        planeNode.addChildNode(bioNode)
        
        let flag = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.width / 8 * 5)
        flag.firstMaterial?.diffuse.contents = UIImage(named: hero.country)

        let flagNode = SCNNode(geometry: flag)
        flagNode.pivotOnTopCenter()
        flagNode.position.y -= Float(plane.height / 2) + spacing
        planeNode.addChildNode(flagNode)
        
        return node
    }
    
    func loadData() {
        guard let url = Bundle.main.url(forResource: "heroes", withExtension: "json") else {
            fatalError("Unable to find JSON in bundle")
        }
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Unable to load JSON")
        }
        let decoder = JSONDecoder()
        guard let loadedHeroes = try? decoder.decode([String: Hero].self, from: data) else {
            fatalError("Unable to parser JSON")
        }
        heroes = loadedHeroes
    }
    
    func textNode(_ text: String, font: UIFont, maxWidth: Int? = nil) -> SCNNode {
        let text = SCNText(string: text, extrusionDepth: 0)
        text.flatness = 0.1
        text.font = font
        if let maxWidth = maxWidth {
            text.containerFrame = .init(origin: .zero, size: .init(width: maxWidth, height: 500))
            text.isWrapped = true
        }
        let textNode = SCNNode(geometry: text)
        textNode.scale = .init(0.002, 0.002, 0.002)
        
        return textNode
    }
}

extension SCNNode {
    var width: Float {
        (boundingBox.max.x - boundingBox.min.x) * scale.x
    }
    
    var height: Float {
        (boundingBox.max.y - boundingBox.min.y) * scale.y
    }
    
    func pivotOnTopLeft() {
        let (min, max) = boundingBox
        pivot = SCNMatrix4MakeTranslation(min.x, (max.y - min.y) + min.y, 0)
    }
    
    func pivotOnTopCenter() {
        let (min, max) = boundingBox
        pivot = SCNMatrix4MakeTranslation((max.x - min.x) / 2 + min.x, (max.y - min.y) + min.y, 0)
    }
}
