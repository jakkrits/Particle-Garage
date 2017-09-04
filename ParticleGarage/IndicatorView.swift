//
//  IndicatorView.Swift
//  SupermomQuiz
//
//  Created by Jakkrits on 10/6/2558 BE.
//  Copyright © 2558 AppIllus. All rights reserved.
//
import UIKit

class IndicatorView: UIView {
	
	var updateLayerValueForCompletedAnimation : Bool = true
	var completionBlocks : Dictionary<CAAnimation, (Bool) -> Void> = [:]
	var layers : Dictionary<String, AnyObject> = [:]
	var indicatorFillColor = ThemeColor.GreenColor
	
	//MARK: - Life Cycle
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupProperties()
		setupLayers()
	}
	
	required init?(coder aDecoder: NSCoder)
	{
		super.init(coder: aDecoder)
		setupProperties()
		setupLayers()
	}
	
	override var frame: CGRect{
		didSet{
			setupLayerFrames()
		}
	}
	
	override var bounds: CGRect{
		didSet{
			setupLayerFrames()
		}
	}
	
	func setupProperties(){
		
	}
	
	func setupLayers(){
		let horIndicator = CAReplicatorLayer()
		self.layer.addSublayer(horIndicator)
		horIndicator.instanceCount     = 4
		horIndicator.instanceDelay     = 0.15
		horIndicator.instanceColor     = UIColor.whiteColor().CGColor
		horIndicator.instanceTransform = CATransform3DMakeTranslation(34, 0, 0)
		layers["horIndicator"] = horIndicator
		let oval = CAShapeLayer()
		horIndicator.addSublayer(oval)
		oval.fillColor = self.indicatorFillColor.CGColor
		oval.lineWidth = 0
		layers["oval"] = oval
		setupLayerFrames()
	}
	
	func setupLayerFrames(){
		CATransaction.begin()
		CATransaction.setDisableActions(true)
		
		if let horIndicator : CAReplicatorLayer = layers["horIndicator"] as? CAReplicatorLayer{
			horIndicator.frame = CGRectMake(0.10689 * horIndicator.superlayer!.bounds.width, 0.28078 * horIndicator.superlayer!.bounds.height, 0.73471 * horIndicator.superlayer!.bounds.width, 0.42445 * horIndicator.superlayer!.bounds.height)
		}
		
		if let oval : CAShapeLayer = layers["oval"] as? CAShapeLayer{
			oval.frame = CGRectMake(0.03965 * oval.superlayer!.bounds.width, 0.12884 * oval.superlayer!.bounds.height, 0.23138 * oval.superlayer!.bounds.width, 0.80103 * oval.superlayer!.bounds.height)
			oval.path  = ovalPathWithBounds((layers["oval"] as! CAShapeLayer).bounds).CGPath;
		}
		
		CATransaction.commit()
	}
	
	//MARK: - Animation Setup
	
	func addFlashingAnimationAnimation(){
		let fillMode : String = kCAFillModeForwards
		
		////An infinity animation
		
		let oval = layers["oval"] as! CAShapeLayer
		
		////Oval animation
		let ovalTransformAnim            = CAKeyframeAnimation(keyPath:"transform")
		ovalTransformAnim.values         = [NSValue(CATransform3D: CATransform3DMakeScale(0, 0, 1)), 
			 NSValue(CATransform3D: CATransform3DIdentity)]
		ovalTransformAnim.keyTimes       = [0, 1]
		ovalTransformAnim.duration       = 0.8
		ovalTransformAnim.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
		ovalTransformAnim.repeatCount    = Float.infinity
		ovalTransformAnim.autoreverses   = true
		
		let ovalFlashingAnimationAnim : CAAnimationGroup = QCMethod.groupAnimations([ovalTransformAnim], fillMode:fillMode)
		oval.addAnimation(ovalFlashingAnimationAnim, forKey:"ovalFlashingAnimationAnim")
	}
	
	//MARK: - Animation Cleanup
	
	override func animationDidStop(anim: CAAnimation, finished flag: Bool){
		if let completionBlock = completionBlocks[anim]{
			completionBlocks.removeValueForKey(anim)
			if (flag && updateLayerValueForCompletedAnimation) || anim.valueForKey("needEndAnim") as! Bool{
				updateLayerValuesForAnimationId(anim.valueForKey("animId") as! String)
				removeAnimationsForAnimationId(anim.valueForKey("animId") as! String)
			}
			completionBlock(flag)
		}
	}
	
	func updateLayerValuesForAnimationId(identifier: String){
		if identifier == "flashingAnimation"{
			QCMethod.updateValueFromPresentationLayerForAnimation((layers["oval"] as! CALayer).animationForKey("ovalFlashingAnimationAnim"), theLayer:(layers["oval"] as! CALayer))
		}
	}
	
	func removeAnimationsForAnimationId(identifier: String){
		if identifier == "flashingAnimation"{
			(layers["oval"] as! CALayer).removeAnimationForKey("ovalFlashingAnimationAnim")
		}
	}
	
	func removeAllAnimations(){
		for layer in layers.values{
			(layer as! CALayer).removeAllAnimations()
		}
	}
	
	//MARK: - Bezier Path
	
	func ovalPathWithBounds(bound: CGRect) -> UIBezierPath{
		let ovalPath = UIBezierPath(ovalInRect:bound)
		return ovalPath;
	}

}
