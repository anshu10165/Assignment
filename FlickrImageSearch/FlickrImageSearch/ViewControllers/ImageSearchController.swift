import UIKit

class ImageSearchController: UIViewController {
    
    private var viewModel: ImageSearchViewModelProtocol
    private let cellReusableIdentifier = "cellIdentifier"
    private let mainQueue: Dispatching
    private let imageDownloader: ImageDownloadable
    private var searchedText: String?
    
    private let searchTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = 4.0
        textField.backgroundColor = .clear
        textField.textColor = UIColor.blue
        textField.placeholder = "Enter Text.."
        textField.clearButtonMode = .always
        textField.autocorrectionType = .no
        textField.becomeFirstResponder()
        textField.font = UIFont.systemFont(ofSize: 17)
        return textField
    }()
    
    private let searchButton: UIButton = {
        let searchButton = UIButton()
        searchButton.layer.cornerRadius = 4.0
        searchButton.setTitleColor(.white, for: .normal)
        searchButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        searchButton.backgroundColor = .blue
        searchButton.setTitle("Search", for: .normal)
        searchButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        searchButton.isEnabled = false
        searchButton.alpha = 0.5
        return searchButton
    }()
    
    private let mainStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 16.0
        return stack
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let loadingSpinner = UIActivityIndicatorView(style: .gray)
        loadingSpinner.translatesAutoresizingMaskIntoConstraints = false
        return loadingSpinner
    }()
    
    private let imageCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = UIColor.white
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
        assignDelegates()
        setUpNavigationBar()
        setUpViews()
        setUpConstraints()
        addSearchFieldTarget()
    }
    
    init(viewModel: ImageSearchViewModelProtocol = ImageSearchViewModel(),
         imageDownloader: ImageDownloadable = ImageDownloader(),
         mainQueue: Dispatching = DispatchQueue.main) {
        self.viewModel = viewModel
        self.imageDownloader = imageDownloader
        self.mainQueue = mainQueue
        super.init(nibName: nil, bundle: nil)
        self.viewModel.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.viewModel = ImageSearchViewModel()
        self.imageDownloader = ImageDownloader()
        self.mainQueue = DispatchQueue.main
        super.init(coder: aDecoder)
    }
    
    @objc func validateTextFields() {
        if searchTextField.text != "" {
            searchButtonEnabled(isEnabled: true, alpha: 1.0)
        } else {
            searchButtonEnabled(isEnabled: false, alpha: 0.5)
        }
    }
    
    private func searchButtonEnabled(isEnabled: Bool, alpha: CGFloat) {
        searchButton.isEnabled = isEnabled
        searchButton.alpha = alpha
    }
    
    private func setUpNavigationBar() {
        self.navigationItem.title = "Image Search"
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.blue,
                                   NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17.0)]
        navigationController?.navigationBar.titleTextAttributes = titleTextAttributes
    }
    
    private func registerCell() {
        imageCollection.register(ImageCell.self,
                                 forCellWithReuseIdentifier: cellReusableIdentifier)
    }
    
    private func assignDelegates() {
        imageCollection.delegate = self
        imageCollection.dataSource = self
        searchTextField.delegate = self
    }
    
    private func addSearchFieldTarget() {
        searchTextField.addTarget(self, action: #selector(self.validateTextFields),
                                  for: UIControl.Event.editingChanged)
    }
    
    private func setUpViews() {
        mainStackView.addArrangedSubview(searchTextField)
        mainStackView.addArrangedSubview(searchButton)
        mainStackView.addArrangedSubview(imageCollection)
        view.addSubview(mainStackView)
    }
    
    private func setUpConstraints() {
        mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                           constant: 8.0).isActive = true
        mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                               constant: 8.0).isActive = true
        mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                constant: -8.0).isActive = true
        mainStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                                              constant: -8.0).isActive = true
    }
    
    private func activateLoadingSpinner() {
        self.searchTextField.addSubview(activityIndicator)
        activityIndicator.centerYAnchor.constraint(equalTo: searchTextField.centerYAnchor).isActive = true
        activityIndicator.trailingAnchor.constraint(equalTo: searchTextField.trailingAnchor,
                                                    constant: -24).isActive = true
        activityIndicator.startAnimating()
    }
    
    @objc func buttonTapped() {
        fetchImagesFromFlickr(text: searchTextField.text)
    }
    
    private func fetchImagesFromFlickr(text: String?) {
        if searchedText != text {
            searchedText = text
            fetchImages()
        }
    }
    
    private func fetchImages() {
        enableBorderColorForTextField()
        activateLoadingSpinner()
        viewModel.searchImagesForText(searchText: searchTextField.text)
        searchTextField.resignFirstResponder()
    }
    
    private func enableBorderColorForTextField() {
        searchTextField.layer.borderColor = UIColor.clear.cgColor
    }
    
    private func highlightTextField() {
        searchTextField.layer.borderColor = UIColor.red.cgColor
        searchTextField.layer.borderWidth = 1.0
        activityIndicator.stopAnimating()
    }
}

extension ImageSearchController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ((collectionView.frame.width / 3) - 8), height: (collectionView.frame.width / 2.5))
    }
}

extension ImageSearchController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.imageCellViewModels
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReusableIdentifier, for: indexPath) as? ImageCell {
            cell.tag = indexPath.item
            let cellViewModel = viewModel.getImageCellViewModelForIndex(index: indexPath.item)
            if (cell.tag == indexPath.item) {
                cell.configurCell(forViewModel: cellViewModel, imageDownloader: imageDownloader)
            }
            return cell
        } else {
            return UICollectionViewCell()
        }
        
    }
}

extension ImageSearchController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text != searchedText {
            if textField.text == "" {
                highlightTextField()
            } else {
                searchedText = textField.text
                fetchImages()
            }
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        enableBorderColorForTextField()
        return true
    }
}

extension ImageSearchController: UpdateCollectionViewDelegate {
    
    func reloadImages(shouldScrollToTop: Bool) {
        mainQueue.async {
            self.activityIndicator.stopAnimating()
            if shouldScrollToTop {
                UIView.animate(withDuration: 0, animations: {
                    self.imageCollection.setContentOffset(.zero, animated: false)
                })
            }
            self.imageCollection.reloadData()
        }
    }
    
    func updateTitleWith(message: String) {
        mainQueue.async {
            self.navigationItem.title = message
        }
    }
}

extension ImageSearchController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        viewModel.userDidDragAtPosition(offsetY: scrollView.contentOffset.y,
                                        contentHeight: scrollView.contentSize.height,
                                        frameHeight: scrollView.frame.height)

    }
}
