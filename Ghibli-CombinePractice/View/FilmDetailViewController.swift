//
//  FilmDetailViewController.swift
//  Ghibli-CombinePractice
//
//  Created by Sherwin Yang on 7/28/24.
//

import UIKit

final class FilmDetailViewController: UIViewController {
    
    private var imageView = UIImageView()
    private let viewModel = FilmDetailViewModel.make()
    
    init(film: Film) {
        super.init(nibName: nil, bundle: nil)
        
        viewModel.film = film
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
    }
    
    private func configureView() {
        view.backgroundColor = .white
        let navigationBar = addAndReturnNavigationBarView(title: viewModel.film?.title)
        addAndSetupImageView(topAnchor: navigationBar.bottomAnchor)
    }
    
    private func addAndReturnNavigationBarView(title: String?) -> UIView {
        let barView = UIView()
        barView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(barView)
        
        let closeButton = UIButton()
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.setImage(UIImage(systemName: "xmark.circle.fill")?.withRenderingMode(.alwaysTemplate), for: .normal)
        closeButton.addTarget(self, action: #selector(dismissSelf), for: .touchUpInside)
        closeButton.tintColor = .white
        barView.addSubview(closeButton)
        
        let titleView = UILabel()
        titleView.translatesAutoresizingMaskIntoConstraints = false
        titleView.text = title
        titleView.textColor = .white
        titleView.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        barView.addSubview(titleView)
        
        NSLayoutConstraint.activate([
            barView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            barView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            barView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            closeButton.topAnchor.constraint(equalTo: barView.topAnchor),
            closeButton.trailingAnchor.constraint(equalTo: barView.trailingAnchor),
            
            titleView.centerXAnchor.constraint(equalTo: barView.centerXAnchor),
            titleView.topAnchor.constraint(equalTo: closeButton.bottomAnchor),
            
            barView.bottomAnchor.constraint(equalTo: titleView.bottomAnchor)
        ])
        
        return barView
    }
    
    @objc private func dismissSelf() { dismiss(animated: true) }
    
    private func addAndSetupImageView(topAnchor: NSLayoutAnchor<NSLayoutYAxisAnchor>) {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        
        view.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        
        Task { [weak self] in
            let image = await ImageDownloader.download(url: self?.viewModel.film?.image)
            self?.imageView.image = image
            self?.view.backgroundColor = image?.averageColor
        }
    }
}
