import UIKit

class ImageCell: UICollectionViewCell {
    
    private var cellViewModel: ImageCellViewModelDisplayable?
    private let operationQueue = OperationQueue()
    private let mainQueue: Dispatching = DispatchQueue.main
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 16.0
        imageView.layer.borderColor = UIColor.darkGray.cgColor
        imageView.layer.borderWidth = 0.1
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setUpView()
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpView() {
        self.contentView.addSubview(imageView)
    }
    
    private func setUpConstraints() {
        imageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    func configurCell(forViewModel: ImageCellViewModelDisplayable?,
                      imageDownloader: ImageDownloadable) {
        self.cellViewModel = forViewModel
        guard let viewModel = self.cellViewModel else { return }
        
        imageView.image = UIImage(named: "gallerySmallPlaceholder")
        if let url = URL(string: viewModel.imageURLString) {
            operationQueue.addOperation {
                imageDownloader.downloadImageforURL(url: url) { image in
                    self.mainQueue.async {
                        self.imageView.image = image
                    }
                }
            }
        }
    }
}
