import UIKit
import RxSwift


/**
 The view controller responsible for listing all the campaigns. The corresponding view is the `CampaignListingView` and
 is configured in the storyboard (Main.storyboard).
 */
class CampaignListingViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    @IBOutlet
    private(set) weak var typedView: CampaignListingView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        assert(typedView != nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        downloadData()
    }
    
    @IBAction private func didTapRetryButton() {
        
        typedView.showLoadingScreen()
        downloadData()
    }
    
    /// Load the campaign list and display it as soon as it is available.
    private func downloadData() {
        ServiceLocator.instance.networkingService
            .createObservableResponse(request: CampaignListingRequest())
            .observeOn(MainScheduler.instance)
            .subscribe { [weak self] event in
                switch event {
                case .next(let campaigns):
                    self?.typedView.display(campaigns: campaigns)
                case .error:
                    self?.typedView.showDisplayErrorScreen()
                case .completed:
                    break
                }
            }
            .addDisposableTo(disposeBag)
    }
}
