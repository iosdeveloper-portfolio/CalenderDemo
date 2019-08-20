import UIKit

protocol DatePickerControllerDelegate: AnyObject {
  func datePicker(controller: DatePickerController, didSelect date: Date?)
}

class DatePickerController: UIViewController {
    
    weak var delegate: DatePickerControllerDelegate?
    
    var date: Date {
        get {
            return datePicker.date
        }
        set(value) {
            datePicker.setDate(value, animated: false)
        }
    }
    
    lazy var datePicker: UIDatePicker = {
        let v = UIDatePicker()
        v.datePickerMode = .date
        return v
    }()
    
    override func loadView() {
        view = datePicker
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        navigationController?.navigationBar.barTintColor = UIColor.white
        
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done,
                                                            target: self,
                                                            action: #selector(DatePickerController.doneButtonDidTap))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                           target: self,
                                                           action: #selector(DatePickerController.cancelButtonDidTap))
        navigationItem.leftBarButtonItem?.tintColor = UIColor.black
        navigationItem.rightBarButtonItem?.tintColor = UIColor.black
    }
    
    @objc func doneButtonDidTap() {
        print(datePicker.date)
        delegate?.datePicker(controller: self, didSelect: date)
    }
    
    @objc func cancelButtonDidTap() {
        delegate?.datePicker(controller: self, didSelect: nil)
        self.dismiss(animated: true, completion: nil)
    }
}
