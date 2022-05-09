import SnapKit
import UIKit

protocol StoriesViewDelegate: AnyObject {
    func storiesView(_ view: StoriesView, didScroll scrollView: UIScrollView)
    func storiesViewRefreshControlDidRefresh(_ view: StoriesView)
}

extension StoriesView {
    struct Appearance {
        let backgroundColor = UIColor.black
        let stackViewSpacing: CGFloat = 20
    }
}

final class StoriesView: UIView, StoriesViewProtocol {
    weak var delegate: StoriesViewDelegate?
    
    private lazy var scrollView = UIScrollView()
    private lazy var contentView = UIView()
   
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 98, height: 98)
        layout.minimumInteritemSpacing = 16
        layout.minimumLineSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )

        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(StoryCollectionViewCell.self)

        return collectionView
    }()

    let appearance: Appearance

    init(
        frame: CGRect = .zero,
        appearance: Appearance = Appearance()
    ) {
        self.appearance = appearance
        super.init(frame: frame)
        self.setupView()
        self.addSubviews()
        self.makeConstraints()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Protocol Conforming

    func updateCollectionViewData(delegate: UICollectionViewDelegate, dataSource: UICollectionViewDataSource) {
        self.collectionView.delegate = delegate
        self.collectionView.dataSource = dataSource
        self.collectionView.reloadData()
        self.collectionView.collectionViewLayout.invalidateLayout()
    }

    func showLoading() {
//        self.collectionView.skeleton.viewBuilder = { SimpleCourseListCellSkeletonView() }
//        self.collectionView.skeleton.show()
    }

    func hideLoading() {
        //self.collectionView.skeleton.hide()
    }

    func invalidateCollectionViewLayout() {
        self.collectionView.collectionViewLayout.invalidateLayout()
        self.invalidateIntrinsicContentSize()
    }
}

extension StoriesView: ProgrammaticallyInitializableViewProtocol {
    func setupView() {
        backgroundColor = appearance.backgroundColor
        collectionView.backgroundColor = .clear
        contentView.backgroundColor = .clear
    }

    func addSubviews() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(collectionView)
    }

    func makeConstraints() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.snp.makeConstraints { make in
            make.top.bottom.trailing.equalToSuperview()
            make.leading.trailing.equalTo(self.safeAreaLayoutGuide)
        }
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalTo(scrollView)
            make.width.equalTo(scrollView.snp.width)
            make.height.equalTo(scrollView.snp.height).priority(.low)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(contentView)
            make.height.equalTo(133)
        }
    }
}
