//
//  WeatherMainViewController.h
//  simple-weather
//
//  Created by Sergio Puleri on 10/1/15.
//  Copyright © 2015 Sergio Puleri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeatherDataRequester.h"
#import "WeatherManager.h"


@interface WeatherMainViewController : UIViewController <WeatherManagerDelegate>

@property (nonatomic, strong) WeatherDataRequester *dataGetter;
@property (nonatomic, strong) WeatherConditionsModel* currentConditions;

@property (strong, nonatomic) IBOutlet UILabel *currentTemp;
@property (strong, nonatomic) IBOutlet UILabel *currentIcon;
@property (strong, nonatomic) IBOutlet UILabel *currentWeatherText;
@property (strong, nonatomic) IBOutlet UILabel *currentLocation;
@property (strong, nonatomic) UIColor   *currentBackgroundColor;
@end
