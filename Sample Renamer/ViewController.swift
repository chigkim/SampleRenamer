//
//  ViewController.swift
//  Samples Renamer
//
//  Created by Chi Kim on 4/12/18.
//  Copyright © 2018 Chi Kim. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
	
	let extensions = ["aif", "aiff", "wav", "caf", "sd2"]
	@IBOutlet weak var cButton: NSButton!
	@IBOutlet weak var csButton: NSButton!
	@IBOutlet weak var dButton: NSButton!
	@IBOutlet weak var dsButton: NSButton!
	@IBOutlet weak var eButton: NSButton!
	@IBOutlet weak var fButton: NSButton!
	@IBOutlet weak var fsButton: NSButton!
	@IBOutlet weak var gButton: NSButton!
	@IBOutlet weak var gsButton: NSButton!
	@IBOutlet weak var aButton: NSButton!
	@IBOutlet weak var asButton: NSButton!
	@IBOutlet weak var bButton: NSButton!
	@IBOutlet weak var renameButton: NSButton!
	@IBOutlet weak var selectFolderButton: NSButton!
	@IBOutlet weak var startSlider: NSSlider!
	@IBOutlet weak var endSlider: NSSlider!
	@IBOutlet weak var startLabel: NSTextField!
	@IBOutlet weak var endLabel: NSTextField!
	@IBOutlet weak var noteStackView: NSStackView!
	
	@IBAction func startSliderChanged(sender:NSSlider) {
		let start = startSlider.integerValue
		let end = endSlider.integerValue
		if (start > end) {
			endSlider.integerValue = start
			endSliderChanged(sender:endSlider)
		}
		startLabel.stringValue = String(startSlider.integerValue)
		startSlider.setAccessibilityValueDescription(String(startSlider.integerValue))
		startSlider.cell?.stringValue = String(startSlider.integerValue)
		startSlider.updateCell(startSlider.cell!)
		startLabel.setAccessibilityElement(false)
	}
	
	@IBAction func endSliderChanged(sender:NSSlider) {
		let start = startSlider.integerValue
		let end = endSlider.integerValue
		if (end < start) {
			startSlider.integerValue = end
			startSliderChanged(sender:startSlider)
		}
		endLabel.stringValue = String(endSlider.integerValue)
		endSlider.cell?.stringValue = String(endSlider.integerValue)
		endSlider.updateCell(endSlider.cell!)
		endSlider.setAccessibilityValueDescription(String(endSlider.integerValue))
	}
	
	@IBAction func selectFolder(sender:NSButton) {
		let dialog = NSOpenPanel()
		dialog.title                   = "Choose a ffolder"
		dialog.canChooseDirectories    = true
		dialog.canChooseFiles = false
		dialog.allowsMultipleSelection = false
		if (dialog.runModal() == NSApplication.ModalResponse.OK) {
			if let result = dialog.url {
				let path = result.path
				print(path)
				selectFolderButton.title = "Select Folder…⌘o: \(path)"
				renameButton.isEnabled = true
			} else {
				renameButton.isEnabled = false
			}
		} else {
			// User clicked on "Cancel"
		}
	}
	
	@IBAction func process(sender:Any) {
		var path = selectFolderButton.title
		path = String(path[path.index(path.startIndex, offsetBy:18)...])
		let folder = URL(fileURLWithPath: path)
		print("Rename \(path)")
		let fileManager = FileManager.default
		do {
			let contents = try fileManager.contentsOfDirectory(atPath: folder.path)
			var files = contents.map { return folder.appendingPathComponent($0) }
			files.sort {
				$0.path<$1.path
			}
			let start = startSlider.integerValue
			let end = endSlider.integerValue
			var notes = [String]()
			if (cButton.state == .on) {
				notes.append("C")
			}
			if (csButton.state == .on) {
				notes.append("C#")
			}
			if (dButton.state == .on) {
				notes.append("D")
			}
			if (dsButton.state == .on) {
				notes.append("D#")
			}
			if (eButton.state == .on) {
				notes.append("E")
			}
			if (fButton.state == .on) {
				notes.append("F")
			}
			if (fsButton.state == .on) {
				notes.append("F#")
			}
			if (gButton.state == .on) {
				notes.append("G")
			}
			if (gsButton.state == .on) {
				notes.append("G#")
			}
			if (aButton.state == .on) {
				notes.append("A")
			}
			if (asButton.state == .on) {
				notes.append("A#")
			}
			if (bButton.state == .on) {
				notes.append("B")
			}
			
			var fileIndex = 0
			var index = 1
			octaveLoop: for octave in start...end {
				for note in notes {
					var file = files[fileIndex]
					var ext = file.pathExtension.lowercased()
					while (!extensions.contains(ext)) {
						fileIndex += 1
						if (fileIndex >= files.count) {
							break octaveLoop
						}
						file = files[fileIndex]
						ext = file.pathExtension.lowercased()
					}
					var indexStr = String(index)
					while (indexStr.count < 3) {
						indexStr = "0\(indexStr)"
					}
					let newName = "\(indexStr)-\(note)\(octave).\(ext)"
					let dest = file.deletingLastPathComponent().appendingPathComponent(newName)
					print("\(file.path) -> \(dest.path)")
					do {
						try fileManager.moveItem(atPath: file.path, toPath: dest.path)
						index += 1
					} catch {
						debugPrint(error)
					}
					fileIndex += 1
					if (fileIndex >= files.count) {
						break octaveLoop
					}
				}
			}
			speak(message:"Done!")
		} catch {
			
		}
	}
	
	func speak(message:String) {
		let announcement = [NSAccessibilityNotificationUserInfoKey.announcement:message, NSAccessibilityNotificationUserInfoKey.priority:"High"]
		NSAccessibilityPostNotificationWithUserInfo(NSApplication.shared.mainWindow?.firstResponder?.accessibilityFocusedUIElement, NSAccessibilityNotificationName.announcementRequested, announcement)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		renameButton.isEnabled = false
		startSliderChanged(sender:startSlider)
		startLabel.cell?.setAccessibilityElement(false)
		endSliderChanged(sender:endSlider)
endLabel.cell?.setAccessibilityElement(false)
selectFolderButton.keyEquivalent = "o"
		selectFolderButton.keyEquivalentModifierMask = .command
		// Do any additional setup after loading the view.
	}
	
	override var representedObject: Any? {
		didSet {
			// Update the view, if already loaded.
		}
	}
	
	
}

