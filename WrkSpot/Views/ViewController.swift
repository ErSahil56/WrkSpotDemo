//
//  ViewController.swift
//  WrkSpot
//
//  Created by Sahil Garg on 18/05/24.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var headerContainerView: UIView!
    @IBOutlet weak var timeStampLabel: UILabel!
    @IBOutlet weak var searchTextFieldView: UITextField!
    @IBOutlet weak var countryListTableView: UITableView!
    
    var viewModel : ViewModel? = nil
    var spinnerView: SpinnerViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpInitalUI()
        callToViewModelForUIUpdate()
    }
    
    /// Set Up initial UI of View
    func setUpInitalUI() {
        // register cell
        countryListTableView.register(UINib(nibName: "ListTableViewCell", bundle: nil), forCellReuseIdentifier: "ListTableViewCell")
        // containerView border ui setup
        containerView.layer.borderColor = ConfigColor.listTextColor?.cgColor
        containerView.layer.borderWidth = 1.0
        // header view border ui setup
        headerContainerView.layer.borderColor = ConfigColor.headerBorderColor?.cgColor
        headerContainerView.layer.borderWidth = 1.0
        // Search text view config
        searchTextFieldView.leftViewMode = UITextField.ViewMode.always
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        let image = UIImage(named: "SearchIcon")
        imageView.image = image
        imageView.tintColor = .black
        searchTextFieldView.leftView = imageView
        // Search text view border ui setup
        searchTextFieldView.layer.borderColor = UIColor.gray.cgColor
        searchTextFieldView.layer.borderWidth = 1.0
        searchTextFieldView.layer.cornerRadius = 2.0
    }
    
    /// Call ViewModel For UI Update
    func callToViewModelForUIUpdate() {
        self.viewModel = ViewModel(service: APIService())
        createSpinnerView()
        self.viewModel?.bindViewModelToDataLabel = { [weak self] value in
            
            guard let self = self else { return }
            self.timeStampLabel.text = value
        }
        self.viewModel?.bindViewModelToTableView = { [weak self] in
            
            guard let self = self else { return }
            // remove the spinner
            if let spinner = self.spinnerView {
                spinner.willMove(toParent: nil)
                spinner.view.removeFromSuperview()
                spinner.removeFromParent()
                self.countryListTableView.reloadData()
            }
            
        }
    }
    
    @IBAction func showPopulationFilterView(sender: AnyObject) {
        
        let alert = UIAlertController(title: "Population ", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "< 1 M", style: .default , handler:{ (UIAlertAction)in
            self.viewModel?.filterCountriesBasedOnPopulation(.OneM)
        }))
        
        alert.addAction(UIAlertAction(title: "< 5 M", style: .default , handler:{ (UIAlertAction)in
            self.viewModel?.filterCountriesBasedOnPopulation(.FiveM)
        }))

        alert.addAction(UIAlertAction(title: "< 10 M", style: .default , handler:{ (UIAlertAction)in
            self.viewModel?.filterCountriesBasedOnPopulation(.tenM)
        }))
        
        alert.addAction(UIAlertAction(title: "Clear", style: .destructive, handler:{ (UIAlertAction)in
            self.viewModel?.clearCountriesSearch(type: .filter)
        }))
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler:{ (UIAlertAction)in
            print("User click Dismiss button")
        }))
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    
    /// Create Spinner during data loading
    func createSpinnerView() {
        spinnerView = SpinnerViewController()
        if let spinner = spinnerView {
            // add the spinner view controller
            addChild(spinner)
            spinner.view.frame = view.frame
            view.addSubview(spinner.view)
            spinner.didMove(toParent: self)
        }
        
    }
    
}

// MARK: UITableViewDataSource, UITableViewDelegate
extension ViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.tempCountriesData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ListTableViewCell") as? ListTableViewCell else { return UITableViewCell() }
        cell.cellModel = viewModel?.tempCountriesData?[indexPath.row]
        return cell
    }
    
}

// MARK: UITextFieldDelegate
extension ViewController : UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        viewModel?.searchCountriesByName(textField.text)
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        viewModel?.clearCountriesSearch(type: .search)
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
