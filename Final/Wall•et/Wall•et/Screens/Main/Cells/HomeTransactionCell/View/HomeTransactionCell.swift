//
//  HomeTransactionCell.swift
//  Wall•et
//
//  Created by Alexandra Biryukova on 4/23/21.
//

import UIKit

final class HomeTransactionCell: UICollectionViewCell {
    override var isHighlighted: Bool {
        didSet {
            iconImageView.tintColor = isHighlighted ? Assets.white.color : Assets.secondary.color
            iconImageView.backgroundColor = isHighlighted ? Assets.secondary.color : Assets.background.color
        }
    }
    
    @IBOutlet private var iconImageView: UIImageView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var subtitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    func configure(with cellModel: TransactionCellModel) {
        titleLabel.text = cellModel.title
        subtitleLabel.text = cellModel.amount
        iconImageView.image = cellModel.bigIcon ?? cellModel.smallIcon
        iconImageView.contentMode = cellModel.bigIcon != nil ? .scaleToFill : .center
    }

    private func setup() {
        iconImageView.layer.cornerRadius = 28
        updateColors()
    }

    private func updateColors() {
        titleLabel.textColor = Assets.black.color
        subtitleLabel.textColor = Assets.gray2.color
        iconImageView.tintColor = Assets.secondary.color
        iconImageView.backgroundColor = Assets.background.color
    }
}
