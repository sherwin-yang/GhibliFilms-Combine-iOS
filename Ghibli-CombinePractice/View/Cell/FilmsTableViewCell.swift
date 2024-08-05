//
//  FilmsTableViewCell.swift
//  Ghibli-CombinePractice
//
//  Created by Sherwin Yang on 7/20/24.
//

import UIKit

final class FilmsTableViewCell: UITableViewCell {
    
    static let identifier = "FilmsTableViewCell"
    
    var film: Film? {
        didSet {
            guard let film else { return }
            titleLabel.text = film.title + " - " + film.originalTitle
            yearReleasedAndDurationLabel.text = film.releaseDate + " " + film.runningTime
            descriptionLabel.text = film.description
        }
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    private let yearReleasedAndDurationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .systemGray2
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .systemGray
        return label
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureView()
    }
    
    private func configureView() {
        selectionStyle = .none
        addTitleLabel()
        addYearReleasedAndDurationLabel()
        addDescriptionLabel()
    }
    
    private func addTitleLabel() {
        contentView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
    
    private func addYearReleasedAndDurationLabel() {
        contentView.addSubview(yearReleasedAndDurationLabel)
        NSLayoutConstraint.activate([
            yearReleasedAndDurationLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            yearReleasedAndDurationLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            yearReleasedAndDurationLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
        ])
    }
    
    private func addDescriptionLabel() {
        contentView.addSubview(descriptionLabel)
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: yearReleasedAndDurationLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
        ])
    }

}
