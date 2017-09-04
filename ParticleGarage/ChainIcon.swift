//
//  SensorIcon.swift
//  PolarH7 Heart-Rater
//
//  Created by Jakkrits on 10/23/2558 BE.
//  Copyright © 2558 AppIllus. All rights reserved.
//

import UIKit

@IBDesignable
class ChainIcon: UIView {
    
    var layers : Dictionary<String, AnyObject> = [:]
    var completionBlocks : Dictionary<CAAnimation, (Bool) -> Void> = [:]
    var updateLayerValueForCompletedAnimation : Bool = false
    
    var fillColor : UIColor!
    var startFillColor : UIColor!
    
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
        self.fillColor      = ThemeColor.BlueColor
        self.startFillColor = ThemeColor.GrayColor
    }
    
    func setupLayers(){
        let chains = CALayer()
        self.layer.addSublayer(chains)
        layers["chains"] = chains
        let pathChain = CAShapeLayer()
        chains.addSublayer(pathChain)
        layers["pathChain"] = pathChain
        let pathChain2 = CAShapeLayer()
        chains.addSublayer(pathChain2)
        layers["pathChain2"] = pathChain2
        
        resetLayerPropertiesForLayerIdentifiers(nil)
        setupLayerFrames()
    }
    
    func resetLayerPropertiesForLayerIdentifiers(layerIds: [String]!){
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        if layerIds == nil || layerIds.contains("pathChain"){
            let pathChain = layers["pathChain"] as! CAShapeLayer
            pathChain.fillColor = UIColor(red:0.868, green: 0.851, blue:0.964, alpha:1).CGColor
            pathChain.lineWidth = 0
        }
        if layerIds == nil || layerIds.contains("pathChain2"){
            let pathChain2 = layers["pathChain2"] as! CAShapeLayer
            pathChain2.fillColor = self.startFillColor.CGColor
            pathChain2.lineWidth = 0
        }
        
        CATransaction.commit()
    }
    
    func setupLayerFrames(){
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        if let chains : CALayer = layers["chains"] as? CALayer{
            chains.frame = CGRectMake(0.14098 * chains.superlayer!.bounds.width, 0.14131 * chains.superlayer!.bounds.height, 0.71804 * chains.superlayer!.bounds.width, 0.71739 * chains.superlayer!.bounds.height)
        }
        
        if let pathChain : CAShapeLayer = layers["pathChain"] as? CAShapeLayer{
            pathChain.frame = CGRectMake(0.44981 * pathChain.superlayer!.bounds.width, 0, 0.55019 * pathChain.superlayer!.bounds.width, 0.67697 * pathChain.superlayer!.bounds.height)
            pathChain.path  = pathChainPathWithBounds((layers["pathChain"] as! CAShapeLayer).bounds).CGPath;
        }
        
        if let pathChain2 : CAShapeLayer = layers["pathChain2"] as? CAShapeLayer{
            pathChain2.frame = CGRectMake(0, 0.3245 * pathChain2.superlayer!.bounds.height, 0.55077 * pathChain2.superlayer!.bounds.width, 0.6755 * pathChain2.superlayer!.bounds.height)
            pathChain2.path  = pathChain2PathWithBounds((layers["pathChain2"] as! CAShapeLayer).bounds).CGPath;
        }
        
        CATransaction.commit()
    }
    
    //MARK: - Animation Setup
    
    func addConnectingAnimationAnimation(){
        addConnectingAnimationAnimationCompletionBlock(nil)
    }
    
    func addConnectingAnimationAnimationCompletionBlock(completionBlock: ((finished: Bool) -> Void)?){
        addConnectingAnimationAnimationReverse(false, completionBlock:completionBlock)
    }
    
    func addConnectingAnimationAnimationReverse(reverseAnimation: Bool, completionBlock: ((finished: Bool) -> Void)?){
        if completionBlock != nil{
            let completionAnim = CABasicAnimation(keyPath:"completionAnim")
            completionAnim.duration = 1
            completionAnim.delegate = self
            completionAnim.setValue("connectingAnimation", forKey:"animId")
            completionAnim.setValue(false, forKey:"needEndAnim")
            layer.addAnimation(completionAnim, forKey:"connectingAnimation")
            if let anim = layer.animationForKey("connectingAnimation"){
                completionBlocks[anim] = completionBlock
            }
        }
        
        let fillMode : String = reverseAnimation ? kCAFillModeBoth : kCAFillModeForwards
        
        let totalDuration : CFTimeInterval = 1
        
        let pathChain = layers["pathChain"] as! CAShapeLayer
        
        ////PathChain animation
        let pathChainPositionAnim            = CAKeyframeAnimation(keyPath:"position")
        pathChainPositionAnim.values         = [NSValue(CGPoint: CGPointMake(0.71476 * pathChain.superlayer!.bounds.width, 0.33273 * pathChain.superlayer!.bounds.height)), NSValue(CGPoint: CGPointMake(1.00137 * pathChain.superlayer!.bounds.width, 0.05394 * pathChain.superlayer!.bounds.height)), NSValue(CGPoint: CGPointMake(0.7249 * pathChain.superlayer!.bounds.width, 0.33849 * pathChain.superlayer!.bounds.height))]
        pathChainPositionAnim.keyTimes       = [0, 0.498, 1]
        pathChainPositionAnim.duration       = 1
        pathChainPositionAnim.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseOut)
        
        let pathChainFillColorAnim            = CAKeyframeAnimation(keyPath:"fillColor")
        pathChainFillColorAnim.values         = [UIColor(red:0.868, green: 0.851, blue:0.964, alpha:1).CGColor,
            self.fillColor.CGColor]
        pathChainFillColorAnim.keyTimes       = [0, 1]
        pathChainFillColorAnim.duration       = 0.594
        pathChainFillColorAnim.beginTime      = 0.406
        pathChainFillColorAnim.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
        
        var pathChainConnectingAnimationAnim : CAAnimationGroup = QCMethod.groupAnimations([pathChainPositionAnim, pathChainFillColorAnim], fillMode:fillMode)
        if (reverseAnimation){ pathChainConnectingAnimationAnim = QCMethod.reverseAnimation(pathChainConnectingAnimationAnim, totalDuration:totalDuration) as! CAAnimationGroup}
        pathChain.addAnimation(pathChainConnectingAnimationAnim, forKey:"pathChainConnectingAnimationAnim")
        
        let pathChain2 = layers["pathChain2"] as! CAShapeLayer
        
        ////PathChain2 animation
        let pathChain2PositionAnim            = CAKeyframeAnimation(keyPath:"position")
        pathChain2PositionAnim.values         = [NSValue(CGPoint: CGPointMake(0.27538 * pathChain2.superlayer!.bounds.width, 0.66225 * pathChain2.superlayer!.bounds.height)), NSValue(CGPoint: CGPointMake(0.08219 * pathChain2.superlayer!.bounds.width, 0.86243 * pathChain2.superlayer!.bounds.height)), NSValue(CGPoint: CGPointMake(0.27538 * pathChain2.superlayer!.bounds.width, 0.66225 * pathChain2.superlayer!.bounds.height))]
        pathChain2PositionAnim.keyTimes       = [0, 0.498, 1]
        pathChain2PositionAnim.duration       = 1
        pathChain2PositionAnim.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseIn)
        
        let pathChain2FillColorAnim            = CAKeyframeAnimation(keyPath:"fillColor")
        pathChain2FillColorAnim.values         = [UIColor(red:0.868, green: 0.851, blue:0.964, alpha:1).CGColor,
            self.fillColor.CGColor]
        pathChain2FillColorAnim.keyTimes       = [0, 1]
        pathChain2FillColorAnim.duration       = 0.594
        pathChain2FillColorAnim.beginTime      = 0.406
        pathChain2FillColorAnim.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
        
        var pathChain2ConnectingAnimationAnim : CAAnimationGroup = QCMethod.groupAnimations([pathChain2PositionAnim, pathChain2FillColorAnim], fillMode:fillMode)
        if (reverseAnimation){ pathChain2ConnectingAnimationAnim = QCMethod.reverseAnimation(pathChain2ConnectingAnimationAnim, totalDuration:totalDuration) as! CAAnimationGroup}
        pathChain2.addAnimation(pathChain2ConnectingAnimationAnim, forKey:"pathChain2ConnectingAnimationAnim")
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
        if identifier == "connectingAnimation"{
            QCMethod.updateValueFromPresentationLayerForAnimation((layers["pathChain"] as! CALayer).animationForKey("pathChainConnectingAnimationAnim"), theLayer:(layers["pathChain"] as! CALayer))
            QCMethod.updateValueFromPresentationLayerForAnimation((layers["pathChain2"] as! CALayer).animationForKey("pathChain2ConnectingAnimationAnim"), theLayer:(layers["pathChain2"] as! CALayer))
        }
    }
    
    func removeAnimationsForAnimationId(identifier: String){
        if identifier == "connectingAnimation"{
            (layers["pathChain"] as! CALayer).removeAnimationForKey("pathChainConnectingAnimationAnim")
            (layers["pathChain2"] as! CALayer).removeAnimationForKey("pathChain2ConnectingAnimationAnim")
        }
    }
    
    func removeAllAnimations(){
        for layer in layers.values{
            (layer as! CALayer).removeAllAnimations()
        }
    }
    
    //MARK: - Bezier Path
    
    func pathChainPathWithBounds(bound: CGRect) -> UIBezierPath{
        let pathChainPath = UIBezierPath()
        let minX = CGFloat(bound.minX), minY = bound.minY, w = bound.width, h = bound.height;
        
        pathChainPath.moveToPoint(CGPointMake(minX + 0.87618 * w, minY + 0.11985 * h))
        pathChainPath.addLineToPoint(CGPointMake(minX + 0.81429 * w, minY + 0.07531 * h))
        pathChainPath.addCurveToPoint(CGPointMake(minX + 0.57011 * w, minY), controlPoint1:CGPointMake(minX + 0.74692 * w, minY + 0.02675 * h), controlPoint2:CGPointMake(minX + 0.66021 * w, minY))
        pathChainPath.addCurveToPoint(CGPointMake(minX + 0.29441 * w, minY + 0.10073 * h), controlPoint1:CGPointMake(minX + 0.46466 * w, minY), controlPoint2:CGPointMake(minX + 0.36418 * w, minY + 0.03671 * h))
        pathChainPath.addLineToPoint(CGPointMake(minX + 0.11729 * w, minY + 0.26332 * h))
        pathChainPath.addCurveToPoint(CGPointMake(minX + 0.08512 * w, minY + 0.339 * h), controlPoint1:CGPointMake(minX + 0.09448 * w, minY + 0.28422 * h), controlPoint2:CGPointMake(minX + 0.08305 * w, minY + 0.31111 * h))
        pathChainPath.addCurveToPoint(CGPointMake(minX + 0.12816 * w, minY + 0.41095 * h), controlPoint1:CGPointMake(minX + 0.0872 * w, minY + 0.36686 * h), controlPoint2:CGPointMake(minX + 0.10247 * w, minY + 0.39242 * h))
        pathChainPath.addLineToPoint(CGPointMake(minX + 0.14474 * w, minY + 0.42293 * h))
        pathChainPath.addCurveToPoint(CGPointMake(minX + 0.23008 * w, minY + 0.44929 * h), controlPoint1:CGPointMake(minX + 0.16827 * w, minY + 0.43993 * h), controlPoint2:CGPointMake(minX + 0.1986 * w, minY + 0.44929 * h))
        pathChainPath.addLineToPoint(CGPointMake(minX + 0.23776 * w, minY + 0.44911 * h))
        pathChainPath.addCurveToPoint(CGPointMake(minX + 0.3263 * w, minY + 0.41409 * h), controlPoint1:CGPointMake(minX + 0.272 * w, minY + 0.44743 * h), controlPoint2:CGPointMake(minX + 0.30345 * w, minY + 0.43501 * h))
        pathChainPath.addLineToPoint(CGPointMake(minX + 0.50347 * w, minY + 0.25148 * h))
        pathChainPath.addCurveToPoint(CGPointMake(minX + 0.62901 * w, minY + 0.24532 * h), controlPoint1:CGPointMake(minX + 0.53463 * w, minY + 0.22286 * h), controlPoint2:CGPointMake(minX + 0.59377 * w, minY + 0.21998 * h))
        pathChainPath.addLineToPoint(CGPointMake(minX + 0.69087 * w, minY + 0.28996 * h))
        pathChainPath.addCurveToPoint(CGPointMake(minX + 0.7206 * w, minY + 0.33975 * h), controlPoint1:CGPointMake(minX + 0.70861 * w, minY + 0.30273 * h), controlPoint2:CGPointMake(minX + 0.71916 * w, minY + 0.32042 * h))
        pathChainPath.addCurveToPoint(CGPointMake(minX + 0.69841 * w, minY + 0.39205 * h), controlPoint1:CGPointMake(minX + 0.72204 * w, minY + 0.35908 * h), controlPoint2:CGPointMake(minX + 0.71416 * w, minY + 0.37764 * h))
        pathChainPath.addLineToPoint(CGPointMake(minX + 0.31095 * w, minY + 0.74759 * h))
        pathChainPath.addCurveToPoint(CGPointMake(minX + 0.2036 * w, minY + 0.76383 * h), controlPoint1:CGPointMake(minX + 0.28487 * w, minY + 0.77157 * h), controlPoint2:CGPointMake(minX + 0.23856 * w, minY + 0.77849 * h))
        pathChainPath.addCurveToPoint(CGPointMake(minX + 0.03774 * w, minY + 0.78892 * h), controlPoint1:CGPointMake(minX + 0.14913 * w, minY + 0.74098 * h), controlPoint2:CGPointMake(minX + 0.07813 * w, minY + 0.75189 * h))
        pathChainPath.addLineToPoint(CGPointMake(minX + 0.0347 * w, minY + 0.79174 * h))
        pathChainPath.addCurveToPoint(CGPointMake(minX + 0.00229 * w, minY + 0.88627 * h), controlPoint1:CGPointMake(minX + 0.0064 * w, minY + 0.81763 * h), controlPoint2:CGPointMake(minX + -0.00538 * w, minY + 0.85203 * h))
        pathChainPath.addCurveToPoint(CGPointMake(minX + 0.07385 * w, minY + 0.96557 * h), controlPoint1:CGPointMake(minX + 0.01004 * w, minY + 0.9203 * h), controlPoint2:CGPointMake(minX + 0.03609 * w, minY + 0.94949 * h))
        pathChainPath.addCurveToPoint(CGPointMake(minX + 0.2443 * w, minY + h), controlPoint1:CGPointMake(minX + 0.12611 * w, minY + 0.98779 * h), controlPoint2:CGPointMake(minX + 0.18505 * w, minY + h))
        pathChainPath.addLineToPoint(CGPointMake(minX + 0.24435 * w, minY + h))
        pathChainPath.addCurveToPoint(CGPointMake(minX + 0.52008 * w, minY + 0.89877 * h), controlPoint1:CGPointMake(minX + 0.34975 * w, minY + h), controlPoint2:CGPointMake(minX + 0.45028 * w, minY + 0.96281 * h))
        pathChainPath.addLineToPoint(CGPointMake(minX + 0.9075 * w, minY + 0.54303 * h))
        pathChainPath.addCurveToPoint(CGPointMake(minX + 0.87618 * w, minY + 0.11985 * h), controlPoint1:CGPointMake(minX + 1.04215 * w, minY + 0.41944 * h), controlPoint2:CGPointMake(minX + 1.02817 * w, minY + 0.2295 * h))
        pathChainPath.closePath()
        pathChainPath.moveToPoint(CGPointMake(minX + 0.87618 * w, minY + 0.11985 * h))
        
        return pathChainPath;
    }
    
    func pathChain2PathWithBounds(bound: CGRect) -> UIBezierPath{
        let pathChain2Path = UIBezierPath()
        let minX = CGFloat(bound.minX), minY = bound.minY, w = bound.width, h = bound.height;
        
        pathChain2Path.moveToPoint(CGPointMake(minX + 0.85423 * w, minY + 0.57727 * h))
        pathChain2Path.addCurveToPoint(CGPointMake(minX + 0.67294 * w, minY + 0.58622 * h), controlPoint1:CGPointMake(minX + 0.80321 * w, minY + 0.54041 * h), controlPoint2:CGPointMake(minX + 0.71828 * w, minY + 0.54455 * h))
        pathChain2Path.addLineToPoint(CGPointMake(minX + 0.49604 * w, minY + 0.74913 * h))
        pathChain2Path.addCurveToPoint(CGPointMake(minX + 0.37071 * w, minY + 0.75536 * h), controlPoint1:CGPointMake(minX + 0.4649 * w, minY + 0.7778 * h), controlPoint2:CGPointMake(minX + 0.40587 * w, minY + 0.78077 * h))
        pathChain2Path.addLineToPoint(CGPointMake(minX + 0.30884 * w, minY + 0.71057 * h))
        pathChain2Path.addCurveToPoint(CGPointMake(minX + 0.27915 * w, minY + 0.66067 * h), controlPoint1:CGPointMake(minX + 0.29112 * w, minY + 0.69775 * h), controlPoint2:CGPointMake(minX + 0.28059 * w, minY + 0.68003 * h))
        pathChain2Path.addCurveToPoint(CGPointMake(minX + 0.3013 * w, minY + 0.60829 * h), controlPoint1:CGPointMake(minX + 0.27771 * w, minY + 0.64133 * h), controlPoint2:CGPointMake(minX + 0.28558 * w, minY + 0.62274 * h))
        pathChain2Path.addLineToPoint(CGPointMake(minX + 0.68831 * w, minY + 0.252 * h))
        pathChain2Path.addCurveToPoint(CGPointMake(minX + 0.79393 * w, minY + 0.23505 * h), controlPoint1:CGPointMake(minX + 0.71398 * w, minY + 0.22835 * h), controlPoint2:CGPointMake(minX + 0.7594 * w, minY + 0.2212 * h))
        pathChain2Path.addCurveToPoint(CGPointMake(minX + 0.9658 * w, minY + 0.20637 * h), controlPoint1:CGPointMake(minX + 0.85036 * w, minY + 0.25773 * h), controlPoint2:CGPointMake(minX + 0.92217 * w, minY + 0.24668 * h))
        pathChain2Path.addCurveToPoint(CGPointMake(minX + 0.99785 * w, minY + 0.11358 * h), controlPoint1:CGPointMake(minX + 0.99354 * w, minY + 0.18086 * h), controlPoint2:CGPointMake(minX + 1.0052 * w, minY + 0.14699 * h))
        pathChain2Path.addCurveToPoint(CGPointMake(minX + 0.92836 * w, minY + 0.03541 * h), controlPoint1:CGPointMake(minX + 0.99055 * w, minY + 0.07998 * h), controlPoint2:CGPointMake(minX + 0.9652 * w, minY + 0.05148 * h))
        pathChain2Path.addCurveToPoint(CGPointMake(minX + 0.75493 * w, minY), controlPoint1:CGPointMake(minX + 0.87536 * w, minY + 0.01224 * h), controlPoint2:CGPointMake(minX + 0.81537 * w, minY))
        pathChain2Path.addCurveToPoint(CGPointMake(minX + 0.47952 * w, minY + 0.10097 * h), controlPoint1:CGPointMake(minX + 0.64959 * w, minY), controlPoint2:CGPointMake(minX + 0.54921 * w, minY + 0.03681 * h))
        pathChain2Path.addLineToPoint(CGPointMake(minX + 0.09246 * w, minY + 0.4572 * h))
        pathChain2Path.addCurveToPoint(CGPointMake(minX + 0.12367 * w, minY + 0.88102 * h), controlPoint1:CGPointMake(minX + -0.04214 * w, minY + 0.58107 * h), controlPoint2:CGPointMake(minX + -0.02812 * w, minY + 0.77118 * h))
        pathChain2Path.addLineToPoint(CGPointMake(minX + 0.18549 * w, minY + 0.92513 * h))
        pathChain2Path.addCurveToPoint(CGPointMake(minX + 0.42938 * w, minY + h), controlPoint1:CGPointMake(minX + 0.25275 * w, minY + 0.9738 * h), controlPoint2:CGPointMake(minX + 0.33937 * w, minY + h))
        pathChain2Path.addCurveToPoint(CGPointMake(minX + 0.42942 * w, minY + h), controlPoint1:CGPointMake(minX + 0.42942 * w, minY + h), controlPoint2:CGPointMake(minX + 0.42938 * w, minY + h))
        pathChain2Path.addCurveToPoint(CGPointMake(minX + 0.70491 * w, minY + 0.89962 * h), controlPoint1:CGPointMake(minX + 0.53476 * w, minY + h), controlPoint2:CGPointMake(minX + 0.63518 * w, minY + 0.96379 * h))
        pathChain2Path.addLineToPoint(CGPointMake(minX + 0.88178 * w, minY + 0.73703 * h))
        pathChain2Path.addCurveToPoint(CGPointMake(minX + 0.91394 * w, minY + 0.66143 * h), controlPoint1:CGPointMake(minX + 0.9046 * w, minY + 0.71605 * h), controlPoint2:CGPointMake(minX + 0.91602 * w, minY + 0.68924 * h))
        pathChain2Path.addCurveToPoint(CGPointMake(minX + 0.87088 * w, minY + 0.58923 * h), controlPoint1:CGPointMake(minX + 0.91195 * w, minY + 0.63381 * h), controlPoint2:CGPointMake(minX + 0.89626 * w, minY + 0.60754 * h))
        pathChain2Path.addLineToPoint(CGPointMake(minX + 0.85423 * w, minY + 0.57727 * h))
        pathChain2Path.closePath()
        pathChain2Path.moveToPoint(CGPointMake(minX + 0.85423 * w, minY + 0.57727 * h))
        
        return pathChain2Path;
    }
    
    
}

