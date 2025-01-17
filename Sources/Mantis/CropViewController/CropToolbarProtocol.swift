//
//  CropToolbarProtocol.swift
//  Mantis
//
//  Created by Echo on 4/25/20.
//

import UIKit

public protocol CropToolbarDelegate: AnyObject {
    func didSelectCancel()
    func didSelectCrop()
    func didSelectCounterClockwiseRotate()
    func didSelectClockwiseRotate()
    func didSelectReset()
    func didSelectSetRatio()
    func didSelectRatio(ratio: Double)
    func didSelectAlterCropper90Degree()
}

public protocol CropToolbarIconProvider: AnyObject {
    func getClockwiseRotationIcon() -> UIImage?
    func getCounterClockwiseRotationIcon() -> UIImage?
    func getResetIcon() -> UIImage?
    func getSetRatioIcon() -> UIImage?
    func getAlterCropper90DegreeIcon() -> UIImage?
}

public extension CropToolbarIconProvider {
    func getClockwiseRotationIcon() -> UIImage? { return nil }
    func getCounterClockwiseRotationIcon() -> UIImage? { return nil }
    func getResetIcon() -> UIImage? { return nil }
    func getSetRatioIcon() -> UIImage? { return nil }
    func getAlterCropper90DegreeIcon() -> UIImage? { return nil }
}

public protocol CropToolbarProtocol: UIView {    
    var heightForVerticalOrientationConstraint: NSLayoutConstraint? { get set }
    var widthForHorizonOrientationConstraint: NSLayoutConstraint? { get set }
    var cropToolbarDelegate: CropToolbarDelegate? { get set }
    
    var iconProvider: CropToolbarIconProvider? { get set }

    func createToolbarUI(config: CropToolbarConfig)
    func handleFixedRatioSetted(ratio: Double)
    func handleFixedRatioUnSetted()
    
    // MARK: - The following functions have default implementations
    func getRatioListPresentSourceView() -> UIView?
    
    func initConstraints(heightForVerticalOrientation: CGFloat,
                        widthForHorizonOrientation: CGFloat)
    
    func respondToOrientationChange()
    func adjustLayoutConstraintsWhenOrientationChange()
    func adjustUIWhenOrientationChange()
        
    func handleCropViewDidBecomeResettable()
    func handleCropViewDidBecomeUnResettable()
}

public extension CropToolbarProtocol {
    func getRatioListPresentSourceView() -> UIView? {
        return nil
    }
    
    func initConstraints(heightForVerticalOrientation: CGFloat, widthForHorizonOrientation: CGFloat) {
        heightForVerticalOrientationConstraint = heightAnchor.constraint(equalToConstant: heightForVerticalOrientation)
        widthForHorizonOrientationConstraint = widthAnchor.constraint(equalToConstant: widthForHorizonOrientation)
    }
    
    func respondToOrientationChange() {
        adjustLayoutConstraintsWhenOrientationChange()
        adjustUIWhenOrientationChange()
    }
    
    func adjustLayoutConstraintsWhenOrientationChange() {
        if Orientation.isPortrait {
            heightForVerticalOrientationConstraint?.isActive = true
            widthForHorizonOrientationConstraint?.isActive = false
        } else {
            heightForVerticalOrientationConstraint?.isActive = false
            widthForHorizonOrientationConstraint?.isActive = true
        }
    }
    
    func adjustUIWhenOrientationChange() {
        
    }
        
    func handleCropViewDidBecomeResettable() {
        
    }
    
    func handleCropViewDidBecomeUnResettable() {
        
    }
}
