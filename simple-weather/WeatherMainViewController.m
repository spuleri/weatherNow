//
//  WeatherMainViewController.m
//  simple-weather
//
//  Created by Sergio Puleri on 10/1/15.
//  Copyright © 2015 Sergio Puleri. All rights reserved.
//

#import "WeatherMainViewController.h"


@interface WeatherMainViewController ()


@end
// Color palates used: http://colorhunt.co/popular#f35f5fcc435ff1ea6536a3eb
// http://colorhunt.co/popular#fffac0ffd79a73b9d79de6e8


@implementation WeatherMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.dataGetter =  [[WeatherDataRequester alloc] init];
    self.currentConditions = nil;
    
    // Default bg color
    self.currentBackgroundColor = [WeatherMainViewController colorDictionary][@"coolOrange"];
    self.view.backgroundColor = self.currentBackgroundColor;
    
    
    // Adding self as delegate to WeatherManager protocol
    [[WeatherManager sharedInstance] addWeatherManagerDelegate:self];
    
    // Telling WeatherManager to start getting current location
    [[WeatherManager sharedInstance] getCurrentLocation];
    
}

+ (const NSDictionary *)colorDictionary {
    // Init colors dict
    static NSDictionary const *_colors = nil;
    if (_colors == nil){
        _colors = @{
                    @"coolBeige": [UIColor colorWithRed:1.00 green:0.98 blue:0.75 alpha:1.0],
                    @"coolOrange": [UIColor colorWithRed:1.00 green:0.84 blue:0.60 alpha:1.0],
                    @"coolDarkBlue": [UIColor colorWithRed:0.45 green:0.73 blue:0.84 alpha:1.0],
                    @"coolLightBlue": [UIColor colorWithRed:0.62 green:0.90 blue:0.91 alpha:1.0],
                    @"coolLightRed": [UIColor colorWithRed:0.95 green:0.37 blue:0.37 alpha:1.0],
                    @"coolDarkRed": [UIColor colorWithRed:0.80 green:0.26 blue:0.37 alpha:1.0],
                    @"coolLightYellow": [UIColor colorWithRed:0.95 green:0.92 blue:0.40 alpha:1.0],
                    @"coolBlue": [UIColor colorWithRed:0.21 green:0.64 blue:0.92 alpha:1.0],
                    @"coldBlue": [UIColor colorWithRed:0.67 green:0.81 blue:0.81 alpha:1.0],
                    @"colderBlue": [UIColor colorWithRed:0.77 green:0.86 blue:0.88 alpha:1.0],
                    @"coldestBlue": [UIColor colorWithRed:0.85 green:0.96 blue:0.96 alpha:1.0],
                    @"purple": [UIColor colorWithRed:0.84 green:0.77 blue:0.94 alpha:1.0]
                    };
    }
    return _colors;
    
}

- (void) locationManagerDidUpdateLocation:(CLLocation *)location {
    // location has been updated, now get current conditions
    [self getCurrentConditionsForLocation:location.coordinate];
}

- (void)getCurrentConditionsForLocation:(CLLocationCoordinate2D)coordinate {
    
    NSString *urlString = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/weather?lat=%f&lon=%f&units=imperial",coordinate.latitude, coordinate.longitude];
    NSURL *url = [NSURL URLWithString:urlString];
    
    
    //Block for AFNetworking request
    void (^getCurrentConditionsJSONData)(BOOL success, NSDictionary *response) = ^void(BOOL success, NSDictionary *response) {
        
        NSError *error;
        self.currentConditions = [MTLJSONAdapter modelOfClass:WeatherConditionsModel.class fromJSONDictionary:response error:nil];
        [self initCurrentWeatherView];
        
        if (error) {
            NSLog(@"Couldn't convert weaher JSON to WeatherConditionsModel: %@", error);
        }
        
    };
    
    // Call function to get JSON from a url, and pass in appropiate block for current onditions
    [self.dataGetter getJSONFromURL:url successBlock:getCurrentConditionsJSONData];
    
}

-(void)initCurrentWeatherView {
    
    if (self.currentConditions) {
        NSLog(@"%@", self.currentConditions);
        // set stuff on view
        self.currentLocation.text = self.currentConditions.locationName;
        [self setIcon];
        [self setBackgroundColor];
        [self setTemperature];
        [self setConditionText];
        
    } else {
        //TODO: bad stuffs
    }
    
}

-(void)setBackgroundColor {
    NSNumber *temp = self.currentConditions.temperature;
    
    if(temp.floatValue > 95.0) {
        self.currentBackgroundColor = [WeatherMainViewController colorDictionary][@"coolDarkRed"];
    }
    else if (temp.floatValue > 90 && temp.floatValue < 95) {
        self.currentBackgroundColor = [WeatherMainViewController colorDictionary][@"coolLightRed"];
        
    }
    else if (temp.floatValue > 85 && temp.floatValue < 90) {
        self.currentBackgroundColor = [WeatherMainViewController colorDictionary][@"coolOrange"];
        
    }
    else if (temp.floatValue > 80 && temp.floatValue < 85) {
        self.currentBackgroundColor = [WeatherMainViewController colorDictionary][@"coolLightYellow"];
        
    }
    else if (temp.floatValue > 70 && temp.floatValue < 80) {
        self.currentBackgroundColor = [WeatherMainViewController colorDictionary][@"coolBeige"];
        
    }
    else if (temp.floatValue > 60 && temp.floatValue < 70) {
        self.currentBackgroundColor = [WeatherMainViewController colorDictionary][@"coolDarkBlue"];
        
    }
    else if (temp.floatValue > 50 && temp.floatValue < 60) {
     self.currentBackgroundColor = [WeatherMainViewController colorDictionary][@"coolBlue"];
    }
    else if (temp.floatValue > 40 && temp.floatValue < 50) {
        self.currentBackgroundColor = [WeatherMainViewController colorDictionary][@"coolLightBlue"];
    }
    else if (temp.floatValue > 30 && temp.floatValue < 40) {
        self.currentBackgroundColor = [WeatherMainViewController colorDictionary][@"coldBlue"];
    }
    else if (temp.floatValue > 20 && temp.floatValue < 30) {
        self.currentBackgroundColor = [WeatherMainViewController colorDictionary][@"colderBlue"];
    }
    else if (temp.floatValue < 20) {
        self.currentBackgroundColor = [WeatherMainViewController colorDictionary][@"coldestBlue"];
    }
    else {
        self.currentBackgroundColor = [WeatherMainViewController colorDictionary][@"purple"];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"BGColorChanged" object:nil];

    self.view.backgroundColor = self.currentBackgroundColor;

}

-(void)setIcon {
    self.currentIcon.text = [self.currentConditions iconName];
}
-(void)setTemperature {
    self.currentTemp.text = [NSString stringWithFormat:@"%ld", self.currentConditions.temperature.integerValue];
}
-(void)setConditionText{
    NSNumber *temp = self.currentConditions.temperature;
    NSString *conditionDescription = self.currentConditions.conditionDescription;
    NSMutableString *conditionText = [NSMutableString new];
    
    // Add temperature text
    if(temp.floatValue > 95.0) {
        [conditionText appendString:@"it's really hot out, prepare to melt."];
    }
    else if (temp.floatValue > 75 && temp.floatValue < 95) {
        [conditionText appendString:@"it's pretty hot out."];
        
    }
    else if (temp.floatValue > 60 && temp.floatValue < 75) {
        [conditionText appendString:@"it's nice and cool out."];
        
    }
    else if (temp.floatValue > 50 && temp.floatValue < 60) {
        [conditionText appendString:@"it's getting chilly.."];
        
    }
    else if (temp.floatValue > 40 && temp.floatValue < 50) {
        [conditionText appendString:@"it's cold, i'd wear a snuggly sweater."];
        
    }
    else if (temp.floatValue > 30 && temp.floatValue < 40) {
        [conditionText appendString:@"it's cold, i'd wear a jacket."];
        
    }
    else if (temp.floatValue > 20 && temp.floatValue < 30) {
        [conditionText appendString:@"it's pretty damn cold, wear a heavy jacket."];
    }
    else if (temp.floatValue > 10 && temp.floatValue < 20) {
       [conditionText appendString:@"it's freakin freezing, shit."];
    }
    else if (temp.floatValue > 0 && temp.floatValue < 10) {
        [conditionText appendString:@"prepare to become an icicle... wear 7 jackets plz."];
    }
    else if (temp.floatValue < 0) {
        [conditionText appendString:@"its in the negatives. this dev is from florida... i hope you survive."];
    }
    [conditionText appendString:@"\n"];
    // Add practical advice
    if ([conditionDescription containsString:@"rain"]) {
        [conditionText appendString:@"also, you probably wanna bring an umbrella."];
    }
    else if ([conditionDescription containsString:@"snow"]) {
        [conditionText appendString:@"and its snowing. bring a snow umbrella."];
    }
    else if ([conditionDescription containsString:@"thunderstorm"]) {
        [conditionText appendString:@"and eep! a thunderstorm. bring an umbrella and watchout!1!."];
    }
    else if ([conditionDescription containsString:@"drizzle"]) {
        [conditionText appendString:@"and it's drizzlin. bring an umbrella. or not if you're brave."];
    }
    else if ([conditionDescription containsString:@"reeze"]) {
        [conditionText appendString:@"and it's breeeeeezy yo."];
    }

    self.currentWeatherText.text = conditionText;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
