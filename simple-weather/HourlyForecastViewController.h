//
//  HourlyForecastViewController.h
//  weatherNow
//
//  Created by Sergio Puleri on 10/2/15.
//  Copyright © 2015 Sergio Puleri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeatherDataRequester.h"
#import "WeatherManager.h"

@interface HourlyForecastViewController : UIViewController <WeatherManagerDelegate, UITableViewDataSource, UITableViewDelegate, UITextViewDelegate>

@property (nonatomic, strong) WeatherDataRequester *dataGetter;
@property (nonatomic, strong) NSMutableArray* hourlyForecast;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
