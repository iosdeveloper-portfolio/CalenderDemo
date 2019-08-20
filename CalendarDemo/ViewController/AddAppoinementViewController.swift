import UIKit

class AddAppoinementViewController: UIViewController {
    
    @IBOutlet weak var dateTextfield: UITextField!
    
    @IBOutlet weak var appoinmentLabel: UILabel!
    @IBOutlet weak var eventTextfield: UITextField!
    
    @IBOutlet weak var buttonDelete: UIButton!
    let datePicker = UIDatePicker()
    var getIndex : Int = 0
    var dataGet : AppoinmentModel?
    var flagEditTimeornot : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonDelete.isHidden = true
        checkEditorAdd()
        presentDatePicker()
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func checkEditorAdd() {
        if let data = dataGet {
            buttonDelete.isHidden = false
            appoinmentLabel.text = "Edit Appointment"
            self.dateTextfield.text = data.dateString ?? ""
            self.eventTextfield.text = data.description ?? ""
            if let index = AppointManager.shared.appointments.firstIndex(where: { $0.dateString == data.dateString }) {
                if AppointManager.shared.appointments.count > index {
                    getIndex = index
                }
            }
        }
    }
    
    func presentDatePicker() {
        self.datePicker.datePickerMode = UIDatePicker.Mode.dateAndTime
        let todaysDate = Date()
        self.datePicker.minimumDate = todaysDate
        let toolbarDate = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 50))
        let buttonDate = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(btnDoneDate))
        UIBarButtonItem.appearance().tintColor = UIColor.black
        let spacerDate = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        
        toolbarDate.items = [spacerDate, buttonDate]
        dateTextfield.inputAccessoryView = toolbarDate
        dateTextfield.inputView = datePicker
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    @objc func btnDoneDate()  {
        dateTextfield.resignFirstResponder()
    }
    
    @objc func updatedatepicker(sender: UIDatePicker)  {
        dateTextfield.text = Date.toStringdatewithTime(datePicker.date)()
    }
    
    @IBAction func deleteButton(_ sender: Any) {
        if AppointManager.shared.appointments.count > getIndex {
            AppointManager.shared.appointments.remove(at: getIndex)
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func submitButton(_ sender: Any) {
        if isValidData() == false {
            return
        }
        else {
            isValidDatatext()
        }
    }
    
    func isValidDatatext(){
        let getdate = Constant.FromdateWithtime(date: dateTextfield.text!)
        if self.appoinmentLabel.text == "Add Appointment" {
            if AppointManager.shared.appointments.count != 0{
                for item in AppointManager.shared.appointments {
                    let strDate = item.dateString ?? ""
                    
                    let startDate = Constant.FromdateWithtime(date: strDate)
                    
                    let cal = Calendar.current
                    let components = cal.dateComponents([.hour, .minute, .second, .nanosecond], from: getdate, to: startDate)
                    let diff = components.hour!
                    if diff == 0 {
                        Constant.showAlert(title:"", message: "Appointment is already booked on this time please choose another date and time.", viewController: self)
                        dateTextfield.becomeFirstResponder()
                        return
                    }
                }
                self.view.endEditing(true)
                
                let testData = AppoinmentModel.init(date: dateTextfield.text!, description: eventTextfield.text!)
                AppointManager.shared.append(testData)
                self.navigationController?.popViewController(animated: true)
            }
            else {
                let testData = AppoinmentModel.init(date: dateTextfield.text!, description: eventTextfield.text!)
                AppointManager.shared.append(testData)
                self.navigationController?.popViewController(animated: true)
            }
        }
        else {
            if flagEditTimeornot == true {
                var index: Int = 0
                for item in AppointManager.shared.appointments {
                    let strDate = item.dateString ?? ""
                    
                    let startDate = Constant.FromdateWithtime(date: strDate)
                    
                    let cal = Calendar.current
                    let components = cal.dateComponents([.hour, .minute, .second, .nanosecond], from: getdate, to: startDate)
                    let diff = components.hour!
                    if getIndex != index {
                        if diff == 0{
                            Constant.showAlert(title:"", message: "Appointment is already booked on this time please choose another date and time.", viewController: self)
                            dateTextfield.becomeFirstResponder()
                            return
                        }
                    }
                    index += 1
                }
                
                let testData = AppoinmentModel.init(date: dateTextfield.text!, description: eventTextfield.text!)
                if AppointManager.shared.appointments.count > getIndex {
                    AppointManager.shared.appointments[getIndex] = testData
                }
                self.navigationController?.popViewController(animated: true)
            } else {
                let testData = AppoinmentModel.init(date: dateTextfield.text!, description: eventTextfield.text!)
                if AppointManager.shared.appointments.count > getIndex {
                    AppointManager.shared.appointments[getIndex] = testData
                }
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func isValidData() -> Bool {
        if !(dateTextfield?.text!.isStringWithoutSpace())! {
            dateTextfield.becomeFirstResponder()
            Constant.showAlert(title:"", message: "Please choose date", viewController: self)
            return false
        }
        else if !(eventTextfield?.text!.isStringWithoutSpace())! {
            eventTextfield.becomeFirstResponder()
            Constant.showAlert(title:"", message: "Please enter event name", viewController: self)
            return false
        }
        else {
            return true
        }
    }
}

extension AddAppoinementViewController :UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == dateTextfield{
            flagEditTimeornot = true
            datePicker.datePickerMode = .dateAndTime
            dateTextfield.inputView = datePicker
            dateTextfield.text = Date.toStringdatewithTime(datePicker.date)()
            self.datePicker.addTarget(self, action: #selector(updatedatepicker), for: UIControl.Event.valueChanged)
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

