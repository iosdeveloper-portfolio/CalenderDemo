import CalendarKit

struct StyleGenerator {
    static func defaultStyle() -> CalendarStyle {
        return CalendarStyle()
    }
    
    static func darkStyle() -> CalendarStyle {
        let orange = UIColor.orange
        let dark = UIColor(white: 0.1, alpha: 1)
        let light = UIColor.lightGray
        let white = UIColor.white
        
        let selector = DaySelectorStyle()
        selector.activeTextColor = white
        selector.inactiveTextColor = white
        selector.selectedBackgroundColor = light
        selector.todayActiveBackgroundColor = orange
        selector.todayInactiveTextColor = orange
        
        let daySymbols = DaySymbolsStyle()
        daySymbols.weekDayColor = white
        daySymbols.weekendColor = light
        
        let swipeLabel = SwipeLabelStyle()
        swipeLabel.textColor = white
        
        let header = DayHeaderStyle()
        header.daySelector = selector
        header.daySymbols = daySymbols
        header.swipeLabel = swipeLabel
        header.backgroundColor = dark
        
        let timeline = TimelineStyle()
        timeline.timeIndicator.color = orange
        timeline.lineColor = light
        timeline.timeColor = light
        timeline.backgroundColor = dark
        
        let style = CalendarStyle()
        style.header = header
        style.timeline = timeline
        
        return style
    }
    
    static func Customstyle() -> CalendarStyle {
        let blue = UIColor.blue
        let dark = UIColor.white
        let light = UIColor.lightGray
        let white = UIColor.white
        
        let selector = DaySelectorStyle()
        selector.activeTextColor = white
        selector.inactiveTextColor = UIColor.black
        selector.selectedBackgroundColor = blue
        selector.todayActiveBackgroundColor = UIColor.red
        selector.todayInactiveTextColor = blue
        
        let daySymbols = DaySymbolsStyle()
        daySymbols.weekDayColor = UIColor.black
        daySymbols.weekendColor = light
        
        let swipeLabel = SwipeLabelStyle()
        swipeLabel.textColor = UIColor.black
        
        let header = DayHeaderStyle()
        header.daySelector = selector
        header.daySymbols = daySymbols
        header.swipeLabel = swipeLabel
        header.backgroundColor = dark
        
        let timeline = TimelineStyle()
        timeline.timeIndicator.color = blue
        timeline.lineColor = light
        timeline.timeColor = light
        timeline.backgroundColor = dark
        
        let style = CalendarStyle()
        style.header = header
        style.timeline = timeline
        
        return style
    }
    
}
