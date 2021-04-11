//
//  ViewController.swift
//  NiceBackground
//
//  Created by TheEvilRoot on 9.04.21.
//

import Cocoa

class ViewController: NSViewController, DragAndDropImageViewDelegate {
    
    @IBOutlet weak var niceView: NiceView!
    @IBOutlet weak var backgroundPicker: NSColorWell!
    @IBOutlet weak var centerImagePicker: DragAndDropImageView!
    
    @IBOutlet weak var paddingLabel: NSTextField!
    @IBOutlet weak var paddingSlider: NSSlider!

    @IBOutlet weak var strokeSlider: NSSlider!
    @IBOutlet weak var strokeLabel: NSTextField!
    
    @IBOutlet weak var strokePicker: NSColorWell!
    
    @IBOutlet weak var resolutionWidth: NSTextField!
    @IBOutlet weak var resolutionHeight: NSTextField!
    @IBOutlet weak var currentResolution: NSTextField!
    
    var backgroundColor: NSColor = NSColor.black {
        didSet {
            niceView.backgroundColor = backgroundColor.cgColor
        }
    }
    
    var strokeColor: NSColor = NSColor.black {
        didSet {
            niceView.strokeColor = strokeColor.cgColor
        }
    }
    
    var centerImage: NSImage? = nil {
        didSet {
            let cgImage = centerImage?.cgImage(forProposedRect: nil, context: nil, hints: nil)
            niceView.centerImage = NiceView.Image(cgImage)
            centerImagePicker.image = centerImage
        }
    }
    
    var allowedPadding: Int32 = 50 {
        didSet {
            niceView.allowedPadding = CGFloat(allowedPadding) / 100.0
            paddingLabel.stringValue = "\(100 - allowedPadding)%"
        }
    }
    
    var strokeWidth: Int32 = 5 {
        didSet {
            niceView.strokeWidth = CGFloat(strokeWidth)
            strokeLabel.stringValue = "\(strokeWidth)px"
        }
    }
    
    var resolution: CGSize = CGSize(width: 0, height: 0) {
        didSet {
            niceView.aspectRatio = resolution.width / resolution.height
            syncResolution()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        centerImagePicker.delegate = self
        syncPickers()
        setupResulutionRatioControl()
        subscribeActions()
    }
    
    override func viewWillDisappear() {
        super.viewWillDisappear()
        disposeSubscriptions()
    }
    
    @IBAction func strokePicker(_ sender: NSColorWell) {
        strokeColor = sender.color
    }
    
    @IBAction func strokeSlider(_ sender: NSSlider) {
        strokeWidth = sender.intValue
    }
    
    @IBAction func paddingSlider(_ sender: NSSlider) {
        allowedPadding = sender.intValue
    }
    
    @IBAction func backgroundPicker(_ sender: NSColorWell) {
        backgroundColor = sender.color
    }
    
    @IBAction func updateResolution(_ sender: NSButton) {
        let widthString = resolutionWidth.stringValue
        let heightString = resolutionHeight.stringValue
        
        if !updateResolution(width: widthString, height: heightString) {
            syncResolution()
        }
        
        setupResulutionRatioControl()
    }
    
    func imageDragged(image: NSImage) {
        centerImage = image
    }
    
    func imageDragged(on url: NSURL) {
        if let path = url.path {
            centerImage = NSImage(contentsOfFile: path)
        }
    }
    
    @objc func exportAction() {
        saveNSImage(niceView.export(size: resolution))
    }
    
    @objc func copyAction() {
        let pasteBoard = NSPasteboard.general
        pasteBoard.clearContents()
        pasteBoard.writeObjects([niceView.export(size: resolution)])
    }
    
    @objc func pasteAction() {
        let pasteBoard = NSPasteboard.general
        guard let objects = pasteBoard.readObjects(forClasses: [NSURL.self, NSImage.self], options: nil) else { return }
        if objects.count == 0 { return }
        
        if let first = objects[0] as? NSURL {
            imageDragged(on: first)
        } else if let first = objects[0] as? NSImage {
            imageDragged(image: first)
        }
    }
 
    @objc func openImageAction() {
        guard let window = view.window else { print ("openImageAction/window is nil"); return }
        let panel = NSOpenPanel()
        panel.allowedFileTypes = ["png", "jpeg", "jpg", "bmp"]
        panel.message = NSLocalizedString("Open image to place in the center", comment: "")
        panel.title = NSLocalizedString("Open image", comment: "")
        panel.prompt = NSLocalizedString("Open", comment: "")
        panel.beginSheetModal(for: window, completionHandler: { response in
            if response == NSApplication.ModalResponse.OK {
                guard let url = panel.url else { print("No url seleced!"); return }
                self.imageDragged(on: NSURL(fileURLWithPath: url.path))
            }
        })
    }
    
    @objc func updateScreenResolution() {
        setCurrentResolution(getCurrentResolution(window: view.window))
    }
    
    private func saveNSImage(_ image: NSImage) {
        guard let window = view.window else { print ("saveNSImage/window is nil"); return }
        let panel = NSSavePanel()
        panel.allowedFileTypes = ["png"]
        panel.message = NSLocalizedString("Export the background image", comment: "")
        panel.title = NSLocalizedString("Export image", comment: "")
        panel.prompt = NSLocalizedString("Export", comment: "")
        panel.beginSheetModal(for: window, completionHandler: { response in
            if response == NSApplication.ModalResponse.OK {
                guard let url = panel.url else {
                    showMessageAlert(self.view.window, NSLocalizedString("No URL provided to save the file. Try to save agains", comment: ""))
                    return
                }
                self.writeExportedImage(image: image, on: url)
            }
        })
    }
    
    private func writeExportedImage(image: NSImage, on url: URL) {
        do {
            let imageRep = NSBitmapImageRep(data: image.tiffRepresentation!)
            let pngData = imageRep?.representation(using: .png, properties: [:])
            try pngData?.write(to: url)
        } catch let e {
            showMessageAlert(view.window, "\(NSLocalizedString("Failed to save file on", comment: "")) \(url.standardized.path)", error: e)
        }
    }
    
    @objc private func setupResulutionRatioControl() {
        if resolution.width == 0 || resolution.height == 0 {
            let current = getCurrentResolution(window: view.window)
            resolution = current
            setCurrentResolution(current)
        }
    }
    
    private func updateResolution(width widthString: String, height heightString: String) -> Bool {
        guard let width = Int(widthString) else { print("\(widthString) \(NSLocalizedString("is not a number!", comment: ""))"); return false }
        guard let height = Int(heightString) else { print("\(heightString) \(NSLocalizedString("is not a number!", comment: ""))"); return false }
        
        resolution = CGSize(width: width, height: height)
        return true
    }
    
    private func setCurrentResolution(_ current: CGSize) {
        currentResolution.stringValue = "\(Int(current.width))x\(Int(current.height))"
    }
    
    private func syncPickers() {
        backgroundColor = backgroundPicker.color
        centerImage = centerImagePicker.image
        allowedPadding = paddingSlider.intValue
        strokeWidth = strokeSlider.intValue
        strokeColor = strokePicker.color
        syncResolution()
    }
    
    private func syncResolution() {
        resolutionWidth.stringValue = "\(Int(resolution.width))"
        resolutionHeight.stringValue = "\(Int(resolution.height))"
    }
    
    private func subscribeActions() {
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.exportAction), name: .export, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.openImageAction), name: .openImage, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.updateScreenResolution), name: NSWindow.didChangeScreenNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.copyAction), name: .copy, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.pasteAction), name: .paste, object: nil)
    }
    
    private func disposeSubscriptions() {
        NotificationCenter.default.removeObserver(self)
    }
}

