//
//  ExportTableViewCell.swift
//  windmill
//
//  Created by Markos Charatzas on 29/05/2016.
//  Copyright © 2016 Windmill. All rights reserved.
//

import UIKit
import QuartzCore

protocol ExportTableViewCellDelegate: class {
    func tableViewCell(_ cell: ExportTableViewCell, installButtonTapped: InstallButton, forExport export: Export)
}

class ExportTableViewCell: UITableViewCell, UITextViewDelegate, NSLayoutManagerDelegate, InstallButtonTouchRecognizer {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var commitLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var installButton: InstallButton! {
        didSet {
            self.installButton.delegate = self
            self.installButton.touchRecognizer = self
        }
    }
    @IBOutlet weak var iconImageVIew: UIImageView!
    
    weak var delegate: ExportTableViewCellDelegate?
    
    var export: Export? {
        didSet {
            titleLabel?.text = export?.title
            if let version = export?.version {
                versionLabel?.text = "\(version)"
            }
            if let shortSha = export?.metadata.commit.shortSha {
                commitLabel?.text = "(\(shortSha))"
            }

            dateLabel?.text = export?.modifiedAt?.timestampString ?? export?.createdAt.timestampString
            installButton?.attributedText = export?.urlAsAttributedString()
            installButton?.textAlignment = .center
            if let isAvailable = export?.isAvailable() {
                installButton?.isSelectable = isAvailable
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        wml_addSubview(view: wml_load(view: ExportTableViewCell.self), layout: { view in
            wml_layout(view)
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        wml_addSubview(view: wml_load(view: ExportTableViewCell.self), layout: { view in
            wml_layout(view)
        })
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {        
        let point = self.installButton.convert(point, from: self)
        return self.installButton.hitTest(point, with: event)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.iconImageVIew.layer.cornerRadius = 10.0
        self.iconImageVIew.layer.masksToBounds = true
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        textView.selectedTextRange = nil //so no selection carrots appear
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>?, with event: UIEvent?) {
        self.installButton.highlighted = false
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.installButton.highlighted = false
    }
    
    func didTouchUpInside(_ button: InstallButton) {
        if let export = export {
            self.delegate?.tableViewCell(self, installButtonTapped: button, forExport: export)
        }
    }
}
