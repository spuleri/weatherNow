//
//  WeatherManager.m
//  simple-weather
//
//  Created by Sergio Puleri on 10/1/15.
//  Copyright © 2015 Sergio Puleri. All rights reserved.
//

#import "WeatherManager.h"
#import "WeatherDataRequester.h"

// Private interface, properties are read/write here
@interface WeatherManager ()

@property (nonatomic, strong, readwrite) WeatherConditionsModel *currentCondition;
@property (nonatomic, strong, readwrite) CLLocation *currentLocation;
@property (nonatomic, strong, readwrite) NSArray *hourlyForecast;

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (strong, nonatomic) NSMutableArray *observers;
@property (nonatomic, assign) BOOL isFirstUpdate;
@property (nonatomic, strong) WeatherDataRequester *dataGetter;

@end

@implementation WeatherManager

// Return shared singleton instance of manager
+ (instancetype)sharedInstance {
    static dispatch_once_t pred = 0;
    __strong static WeatherManager * _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

- (id)init {
    if (self = [super init]) {

        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        
        _locationManager.desiredAccuracy=kCLLocationAccuracyBest;
        _locationManager.distanceFilter=kCLDistanceFilterNone;
        [_locationManager requestWhenInUseAuthorization];
        [_locationManager startMonitoringSignificantLocationChanges];
        
        _dataGetter = [[WeatherDataRequester alloc] init];
        
        _observers = [[NSMutableArray alloc] init];

        

    }
    return self;
}

- (void)getCurrentLocation {
    self.isFirstUpdate = YES;
    [self.locationManager startUpdatingLocation];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    // ignore first update since it is always cached
    if (self.isFirstUpdate) {
        self.isFirstUpdate = NO;
        return;
    }
    
    NSLog(@"got new location");
    
    CLLocation *location = [locations lastObject];
    
    if (location.horizontalAccuracy > 0) {
        self.currentLocation = location;
        [self.locationManager stopUpdatingLocation];
        
        // alert observers of location
        for(id<WeatherManagerDelegate> observer in self.observers) {
            if (observer) {
                [observer locationManagerDidUpdateLocation:[locations lastObject]];
            }
        }

    }
}

//- (void)updateCurrentConditions {
//    // returns a weatherconditionmodel of current weather
//    //(not yet actually)
//    WeatherConditionsModel *current = [self.dataGetter getCurrentConditionsForLocation:self.currentLocation.coordinate]
//}

- (void) addWeatherManagerDelegate:(id<WeatherManagerDelegate>)delegate {
    if (![self.observers containsObject:delegate]) {
        [self.observers addObject:delegate];
    }
    //[self.manager startUpdatingLocation];
}

- (void) removeWeatherManagerDelegate:(id<WeatherManagerDelegate>)delegate {
    if ([self.observers containsObject:delegate]) {
        [self.observers removeObject:delegate];
    }
}


@end
