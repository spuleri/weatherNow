//
//  WeatherHourlyForecastModel.m
//  weatherNow
//
//  Created by Sergio Puleri on 10/3/15.
//  Copyright © 2015 Sergio Puleri. All rights reserved.
//

#import "WeatherHourlyForecastModel.h"

@implementation WeatherHourlyForecastModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    // 1
    NSMutableDictionary *paths = [[super JSONKeyPathsByPropertyKey] mutableCopy];
    // 2
    paths[@"tempHigh"] = @"temp.max";
    paths[@"tempLow"] = @"temp.min";
    // 3
    return paths;
}

@end
