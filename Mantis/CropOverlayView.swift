//
//  CropOverlayView.swift
//  Mantis
//
//  Created by Echo on 10/19/18.
//  Copyright © 2018 Echo. All rights reserved.
//

import UIKit

class CropOverlayView: UIView {
    
    var didFrameChange: (CGRect) -> Void = { _ in }
    
    let cropOverLayerCornerWidth = CGFloat(20.0)
    var gridHidden = false
    
    private var gridLineNumberType: GridLineNumberType = .crop
    
    fileprivate var horizontalGridLines: [CALayer] = []
    fileprivate var verticalGridLines: [CALayer] = []
    fileprivate var borderLineLayer: CALayer = CALayer()
    fileprivate var cornerLayers: [CALayer] = []
    
    var displayHorizontalGridLine = true {
        didSet {
            horizontalGridLines.forEach { $0.removeFromSuperlayer() }
            
            if displayHorizontalGridLine {
                horizontalGridLines = Array(repeating: createNewLineLayer(), count: gridLineNumberType.rawValue)

            } else {
                horizontalGridLines = []
            }
            
            setNeedsDisplay()
        }
    }
    
    var displayVerticalGridLines = true {
        didSet {
            verticalGridLines.forEach { $0.removeFromSuperlayer() }
            
            if displayVerticalGridLines {
                verticalGridLines = Array(repeating: createNewLineLayer(), count:  gridLineNumberType.rawValue)
            } else {
                verticalGridLines = []
            }
            
            setNeedsDisplay()
        }
    }
    
    override var frame: CGRect {
        didSet {
            if cornerLayers.count > 0 {
                layoutLines()
            }
            
            if frame != oldValue {
                didFrameChange(frame)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = false
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    fileprivate func createNewLineView() -> UIView {
        let view = UIView(frame: CGRect.zero)
        view.backgroundColor = .white
        addSubview(view)
        return view
    }
    
    fileprivate func createNewLineLayer() -> CALayer {
        let layer = CALayer()
        layer.frame = CGRect.zero
        layer.backgroundColor = UIColor.white.cgColor
        self.layer.addSublayer(layer)
        return layer
    }
    
    fileprivate func setup() {
        gridHidden = false
        borderLineLayer = createNewLineLayer()
        cornerLayers = Array(repeating: createNewLineLayer(), count: 8)
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        if cornerLayers.count > 0 {
            layoutLines()
        }
    }
    
    fileprivate func layoutLines() {
        layoutOuterLines()
        layoutCornerLines()
    }
    
    fileprivate func layoutOuterLines() {
        let borderThickness = CGFloat(1.0)
        borderLineLayer.frame = CGRect(x: -borderThickness, y: -borderThickness, width: bounds.width + 2 * borderThickness, height: bounds.height + 2 * borderThickness)
        borderLineLayer.backgroundColor = UIColor.clear.cgColor
        borderLineLayer.borderWidth = borderThickness
        borderLineLayer.borderColor = UIColor.white.cgColor
    }
    
    fileprivate func layoutCornerLines() {
        let borderThickness = CGFloat(3.0)
        
        let topLeftHorizonalLayerFrame = CGRect(x: -borderThickness, y: -borderThickness, width: cropOverLayerCornerWidth, height: borderThickness)
        let topLeftVerticalLayerFrame = CGRect(x: -borderThickness, y: -borderThickness, width: borderThickness, height: cropOverLayerCornerWidth)
        let horizontalCornerHorizontalDistance = bounds.width + 2 * borderThickness - 2 * cropOverLayerCornerWidth
        let horizontalCornerVerticalDistance = bounds.height + borderThickness
        let veticalCornerHorizontalDistance = bounds.width + borderThickness
        let veticalCornerVetticalDistance = bounds.height + 2 * borderThickness - 2 * cropOverLayerCornerWidth
        
        for (i, line) in cornerLayers.enumerated() {
            let lineType: CornerLineType = CropOverlayView.CornerLineType(rawValue: i) ?? .topLeftVertical
            switch lineType {
            case .topLeftHorizontal:
                line.frame = topLeftHorizonalLayerFrame
            case .topLeftVertical:
                line.frame = topLeftVerticalLayerFrame
            case .topRightHorizontal:
                line.frame = topLeftHorizonalLayerFrame.offsetBy(dx: horizontalCornerHorizontalDistance, dy: horizontalCornerVerticalDistance)
            case .topRightVertical:
                line.frame = topLeftVerticalLayerFrame.offsetBy(dx: veticalCornerHorizontalDistance, dy: 0)
            case .bottomRightHorizontal:
                line.frame = topLeftHorizonalLayerFrame.offsetBy(dx: horizontalCornerHorizontalDistance, dy: veticalCornerVetticalDistance)
            case .bottomRightVertical:
                line.frame = topLeftVerticalLayerFrame.offsetBy(dx: veticalCornerHorizontalDistance, dy: 0)
            case .bottomLeftHorizontal:
                line.frame = topLeftHorizonalLayerFrame.offsetBy(dx: 0, dy: horizontalCornerVerticalDistance)
            case .bottomLeftVertical:
                line.frame = topLeftVerticalLayerFrame.offsetBy(dx: 0, dy: veticalCornerVetticalDistance)
            }
        }
    }
    
    func setGrid(hidden: Bool, animated: Bool = false) {
        gridHidden = hidden
        
        func setGridLinesShowStatus () {
            horizontalGridLines.forEach { $0.opacity = hidden ? 0 : 1 }
            verticalGridLines.forEach { $0.opacity = hidden ? 0 : 1}
        }
        
        if animated {
            let duration = hidden ? 0.35 : 0.2
            UIView.animate(withDuration: duration) {
                setGridLinesShowStatus()
            }
        } else {
            setGridLinesShowStatus()
        }
    }
}

extension CropOverlayView {
    fileprivate enum CornerLineType: Int {
        case topLeftVertical = 0
        case topLeftHorizontal
        case topRightVertical
        case topRightHorizontal
        case bottomRightVertical
        case bottomRightHorizontal
        case bottomLeftVertical
        case bottomLeftHorizontal
    }
    
    fileprivate enum GridLineNumberType: Int {
        case crop = 3
        case rotate = 9
    }
}
