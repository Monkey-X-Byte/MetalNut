//
//  RenderView.swift
//  MetalNut
//
//  Created by Geonseok Lee on 2019/12/05.
//  Copyright © 2019 Geonseok Lee. All rights reserved.
//

import MetalKit

public class RenderView: MTKView, ImageConsumer {
    
    private var currentTexture: Texture?
    private var renderPipelineState:MTLRenderPipelineState!
    
    public override init(frame frameRect: CGRect, device: MTLDevice?) {
        super.init(frame: frameRect, device: MetalDevice.sharedDevice)
        
        commonInit()
    }
    
    public required init(coder: NSCoder) {
        super.init(coder: coder)
        
        commonInit()
    }
    
    private func commonInit() {
        framebufferOnly = false
        autoResizeDrawable = true
        self.device = MetalDevice.sharedDevice
        self.renderPipelineState = MetalDevice.generateRenderPipelineState(vertexFunctionName:"oneInputVertex", fragmentFunctionName:"passthroughFragment", operationName:"RenderView")
        enableSetNeedsDisplay = false
        isPaused = true
    }
    
    public func newTextureAvailable(_ texture: Texture, from source: ImageSource) {
        self.drawableSize = CGSize(width: texture.metalTexture.width, height: texture.metalTexture.height)
        currentTexture = texture
        self.draw()
    }
    
    
    public override func draw(_ rect:CGRect) {
        if let currentDrawable = self.currentDrawable, let imageTexture = currentTexture {
            let commandBuffer = MetalDevice.sharedCommandQueue.makeCommandBuffer()
            let outputTexture = Texture(mtlTexture: currentDrawable.texture, type: imageTexture.type)
            commandBuffer?.renderQuad(pipelineState: renderPipelineState, inputTexture: imageTexture, outputTexture: outputTexture)
            commandBuffer?.present(currentDrawable)
            commandBuffer?.commit()
        }
    }
    
    public func add(source: ImageSource) {}
    
    public func remove(source: ImageSource) {}
    
    
}
