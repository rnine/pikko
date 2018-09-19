import UIKit
import PlaygroundSupport

class ColorTestView: UIView {
    
    var samplingRate: CGFloat = 25.0
    
    var visualisationColorView = UIView(frame: CGRect(x: 320, y: 320, width: 50, height: 50))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createSaturationLayer()
        createBrightnessLayer()
        self.addSubview(visualisationColorView)
        visualisationColorView.backgroundColor = .blue
        visualisationColorView.layer.borderWidth = 10
        visualisationColorView.layer.borderColor = UIColor.white.cgColor
    }
    
    func createSaturationLayer() {
        
        let fullGradient = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        
        let valueLayer = CAGradientLayer()
        var tempArray = [CGColor]()
        
        for i in 0..<Int(samplingRate) {
            let saturationValue = CGFloat(CGFloat(i) / samplingRate)
            let color = UIColor(hue: CGFloat(0)/255.0, saturation: saturationValue, brightness: 1.0, alpha: 1.0)
            tempArray.append(color.cgColor)
        }
        
        valueLayer.colors = tempArray
        valueLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        valueLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        valueLayer.frame = fullGradient.bounds
        
        fullGradient.layer.addSublayer(valueLayer)
        
        self.addSubview(fullGradient)
    }
    
    func createBrightnessLayer() {
        let sampledGradient = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        let smallValueLayer = CAGradientLayer()
        var smallTempArray = [CGColor]()
        
        for i in 0..<Int(samplingRate) {
            let saturationValue = CGFloat(CGFloat(i) / samplingRate)
            let color = UIColor(hue: 0, saturation: 0, brightness: 0, alpha: saturationValue)
            smallTempArray.append(color.cgColor)
        }
        
        smallValueLayer.colors = smallTempArray
        smallValueLayer.frame = sampledGradient.bounds

        sampledGradient.layer.addSublayer(smallValueLayer)
        
        self.addSubview(sampledGradient)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        
        let location = touch.location(in: self)
        
        let color = getPixelColorAtPoint(point: location, sourceView: self)
        
        visualisationColorView.backgroundColor = color
        visualisationColorView.center = location
    }
    
    func getPixelColorAtPoint(point:CGPoint, sourceView: UIView) -> UIColor? {
        
        let pixel = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: 4)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let context = CGContext(data: pixel, width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 4, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)
        var color: UIColor? = nil
        
        if let context = context {
            context.translateBy(x: -point.x, y: -point.y)
            sourceView.layer.render(in: context)
            
            color = UIColor(red: CGFloat(pixel[0])/255.0,
                            green: CGFloat(pixel[1])/255.0,
                            blue: CGFloat(pixel[2])/255.0,
                            alpha: CGFloat(pixel[3])/255.0)
            
            pixel.deallocate(capacity: 4)
            
            return color
        }
        return nil
    }
}


let view = ColorTestView(frame: CGRect(x: 0, y: 0, width: 400, height: 400))
view.backgroundColor = .white


PlaygroundPage.current.liveView = view



