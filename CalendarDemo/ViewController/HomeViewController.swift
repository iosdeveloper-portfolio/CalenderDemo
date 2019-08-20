import UIKit
import CalendarKit
import DateToolsSwift

enum SelectedStyle {
    case Dark
    case Light
}

class HomeViewController: DayViewController, DatePickerControllerDelegate {
    
    var colors = [Constant.hexStringToUIColor(hex: "FDEFD6"),Constant.hexStringToUIColor(hex: "D4F3F0"),Constant.hexStringToUIColor(hex: "C9E9FF")]
    
    var currentStyle = SelectedStyle.Light
    let datepicker = UIDatePicker()
    let dateformatterGet = DateFormatter()
    let now = Date()
    var compareDate = Date()
    var dateEvents = Date()
    let dateFormatterOnlydate = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatterOnlydate.dateFormat = "dd-MM-yyyy"
        
        let attributes = [NSAttributedString.Key.font: UIFont(name: "Avenir Next Regular", size: 14)]
        UINavigationBar.appearance().titleTextAttributes = attributes as [NSAttributedString.Key : Any]
        let finalDate = Date.toStringWithDate(now)
        compareDate = Constant.Fromdate(date: finalDate())
        
        let buttonTapLeft = UIButton.init(type: .custom)
        buttonTapLeft.setImage(UIImage.init(named: "ic-addpdf"), for: .normal)
        buttonTapLeft.addTarget(self, action:#selector(addTapped), for:.touchUpInside)
        buttonTapLeft.frame = CGRect.init(x: 0, y: 0, width: 30, height: 30)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: buttonTapLeft)
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        
        let buttonLeft = UIButton.init(type: .custom)
        buttonLeft.setImage(UIImage.init(named: "ic-calendar"), for: .normal)
        buttonLeft.addTarget(self, action:#selector(HomeViewController.presentDatePicker), for:.touchUpInside)
        buttonLeft.frame = CGRect.init(x: 0, y: 0, width: 30, height: 30)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: buttonLeft)
        
        navigationItem.leftBarButtonItem?.tintColor = #colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 1)
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        dayView.autoScrollToFirstEvent = true
        changeStyle()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadData()
    }
    
    @objc func addTapped() {
        if dateEvents >= compareDate {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "AddAppoinementViewController") as! AddAppoinementViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func changeStyle() {
        var title: String!
        var style: CalendarStyle!
        title = "Light"
        style = StyleGenerator.Customstyle()
        updateStyle(style)
        navigationItem.rightBarButtonItem!.title = title
        navigationController?.navigationBar.barTintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:style.header.swipeLabel.textColor]
        reloadData()
    }
    
    @objc func presentDatePicker() {
        let picker = DatePickerController()
        picker.date = dayView.state!.selectedDate
        picker.delegate = self
        let navC = UINavigationController(rootViewController: picker)
        navigationController?.present(navC, animated: true, completion: nil)
    }
    
    func datePicker(controller: DatePickerController, didSelect date: Date?) {
        if let date = date {
            dayView.state?.move(to: date)
            controller.dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: EventDataSource
    
    override func eventsForDate(_ date: Date) -> [EventDescriptor] {
        dateformatterGet.dateFormat = "dd-MM-yyyy"
        var date = date.add(TimeChunk.dateComponents(hours: Int(arc4random_uniform(10) + 5)))
        let finalDate = dateFormatterOnlydate.string(from: date)
        dateEvents = dateFormatterOnlydate.date(from: finalDate)!
        ChangescreenTitle(date: date)
        var events = [Event]()
        var index: Int = 0
        for item in AppointManager.shared.appointments {
            let event = Event()
            var info = item.description ?? ""
            let strDate = item.dateString ?? ""
            dateformatterGet.dateFormat = "dd-MM-yyyy h:mm a"
            let getDate = dateformatterGet.date(from: strDate)
            
            let duration = 60
            let datePeriod = TimePeriod(beginning: getDate!,
                                        chunk: TimeChunk.dateComponents(minutes: duration))
            
            event.startDate = datePeriod.beginning!
            event.endDate = datePeriod.end!
            
            let timezone = TimeZone.ReferenceType.default
            
            info.append(" \(datePeriod.beginning!.format(with: "h:mm a", timeZone: timezone)) - \(datePeriod.end!.format(with: "h:mm a", timeZone: timezone))")
            event.text = info
            event.color = colors[Int(arc4random_uniform(UInt32(colors.count)))]
            if currentStyle == .Dark {
                event.textColor = textColorForEventInDarkTheme(baseColor: event.color)
                event.backgroundColor = event.color.withAlphaComponent(0.6)
            }
            
            events.append(event)
            
            let nextOffset = 40
            date = date.add(TimeChunk.dateComponents(minutes: nextOffset))
            event.userInfo = item as Any
            
            index += 1
        }
        return events
    }
    
    func ChangescreenTitle(date:Date)  {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL"
        let nameOfMonth = dateFormatter.string(from: date)
        title = nameOfMonth
    }
    
    private func textColorForEventInDarkTheme(baseColor: UIColor) -> UIColor {
        var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        baseColor.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        return UIColor(hue: h, saturation: s * 0.3, brightness: b, alpha: a)
    }
    
    // MARK: DayViewDelegate
    override func dayViewDidSelectEventView(_ eventView: EventView) {
        guard let descriptor = eventView.descriptor as? Event else {
            return
        }
        print(descriptor.userInfo as Any)
        print("Event has been selected: \(descriptor) \(String(describing: descriptor.userInfo))")
        let alertController = UIAlertController(title: nil, message: "Options", preferredStyle: .actionSheet)
        let yourAttributes = [NSAttributedString.Key.font:UIFont(name: "Avenir Next Regular", size: 14)]
        
        let editAppointment = NSMutableAttributedString(string: "Edit Appointment", attributes: yourAttributes as [NSAttributedString.Key : Any])
        let deleteAppoinment = NSMutableAttributedString(string: "Delete Appointment", attributes: yourAttributes as [NSAttributedString.Key : Any])
        
        
        let EditAction = UIAlertAction(title: editAppointment.string, style: .default, handler: { (alert: UIAlertAction!) -> Void in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "AddAppoinementViewController") as! AddAppoinementViewController
            vc.dataGet = descriptor.userInfo as? AppoinmentModel
            self.navigationController?.pushViewController(vc, animated: true)
        })
        
        alertController.view.tintColor = UIColor.black
        
        let DeleteAction = UIAlertAction(title: deleteAppoinment.string, style: .default, handler: { (alert: UIAlertAction!) -> Void in
            if let index = AppointManager.shared.appointments.firstIndex(where: { $0.dateString == (descriptor.userInfo as? AppoinmentModel)?.dateString }) {
                if AppointManager.shared.appointments.count > index {
                    AppointManager.shared.appointments.remove(at: index)
                }
            }
            self.reloadData()
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: { (alert: UIAlertAction!) -> Void in
            self.dismiss(animated: true, completion: nil)
        })
        
        alertController.addAction(EditAction)
        alertController.addAction(DeleteAction)
        alertController.addAction(cancelAction)
        
        if let popoverController = alertController.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        alertController.modalPresentationStyle = .fullScreen
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func dayViewDidLongPressEventView(_ eventView: EventView) {
        guard let descriptor = eventView.descriptor as? Event else {
            return
        }
        print("Event has been longPressed: \(descriptor) \(String(describing: descriptor.userInfo))")
    }
    
    override func dayView(dayView: DayView, willMoveTo date: Date) {
        print("DayView = \(dayView) will move to: \(date)")
    }
    
    override func dayView(dayView: DayView, didMoveTo date: Date) {
        print("DayView = \(dayView) did move to: \(date)")
    }
}
