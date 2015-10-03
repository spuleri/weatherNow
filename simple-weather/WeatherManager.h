//
//  WeatherManager.h
//  simple-weather
//
//  Created by Sergio Puleri on 10/1/15.
//  Copyright © 2015 Sergio Puleri. All rights reserved.
//
// A singleton class that gets the device's location and gets the current weather!

@import Foundation;
@import CoreLocation;
#import "WeatherConditionsModel.h"

@protocol WeatherManagerDelegate

- (void)locationManagerDidUpdateLocation:(CLLocation *)location;

@end

@interface WeatherManager : NSObject <CLLocationManagerDelegate>

+ (instancetype)sharedInstance;

@property (nonatomic, strong, readonly) CLLocation *currentLocation;
@property (nonatomic, strong, readonly) WeatherConditionsModel *currentCondition;
@property (nonatomic, strong, readonly) NSArray *hourlyForecast;
@property (nonatomic, strong, readonly) NSArray *dailyForecast;

- (void)getCurrentLocation;

- (void) addWeatherManagerDelegate:(id<WeatherManagerDelegate>) delegate;
- (void) removeWeatherManagerDelegate:(id<WeatherManagerDelegate>) delegate;

@end
