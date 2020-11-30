import UIKit

class TopBarController: UIViewController {

    private var numberOfCurrentContentView = 0
    let viewControllers: [UIViewController]
//    var topBarButtons = [TopBarButton]()
    let topBar = TopBar()
    
    convenience init(_ viewControllers: UIViewController...) {
        self.init(viewControllers: viewControllers)
    }

    init(viewControllers: [UIViewController]) {
        self.viewControllers = viewControllers
        super.init(nibName: nil, bundle: nil)
        commonInit()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit(){
        var tag = 0
        for contentCotroller in viewControllers where contentCotroller is ContentController {
            let topBarButton = TopBarButton()
            topBarButton.setTopBarButton(item: contentCotroller.topBarItem ?? nil, tag: tag)
            tag += 1
            topBarButton.addTarget(self, action: #selector(touch(_:)), for: .touchUpInside)
            topBar.addTopBarButton(topBarButton: topBarButton)
        }
        topBar.topBarButtons[numberOfCurrentContentView].isSelected = true
    }
    
    @objc func touch(_ button: TopBarButton){
        for button in topBar.topBarButtons where button.isSelected == true {
            button.isSelected = false
            button.setNeedsLayout()
        }
        button.isSelected = true
        setContentView(tag: button.tag)
        button.setNeedsLayout()
    }
    
    
    
    private func setContentView(tag:Int) {
        viewControllers[numberOfCurrentContentView].willMove(toParent: nil)
        viewControllers[numberOfCurrentContentView].view.removeFromSuperview()
        viewControllers[numberOfCurrentContentView].removeFromParent()
        
        numberOfCurrentContentView = tag
        
        addChild(viewControllers[numberOfCurrentContentView])
        view.insertSubview(viewControllers[numberOfCurrentContentView].view!, at: 0)
        view.setNeedsLayout()
        viewControllers[numberOfCurrentContentView].didMove(toParent: self)
    }
    
    override func loadView() {
        view = UIView()

//MARK: зачем нужно добавлять сразу все дочерние VC ???
//        for viewController in viewControllers {
//            addChild(viewController)
//        }
        
        addChild(viewControllers[numberOfCurrentContentView])
        view.addSubview(viewControllers[numberOfCurrentContentView].view!)
        viewControllers[numberOfCurrentContentView].didMove(toParent: self)
        
        view.addSubview(topBar)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        viewControllers[numberOfCurrentContentView].view.frame = view.bounds
        
//        topBar.frame = CGRect(origin: CGPoint(x: 50, y: 50), size: CGSize(width: view.bounds.maxX-100, height: 50))

        topBar.frame.size = CGSize(width: 50 * viewControllers.count, height: 50)
        topBar.center = CGPoint(x: view.bounds.midX, y: 30 + view.safeAreaInsets.top)
    }
    
}
