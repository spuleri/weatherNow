//
//  WeatherConditionsModel.m
//  simple-weather
//
//  Created by Sergio Puleri on 10/1/15.
//  Copyright © 2015 Sergio Puleri. All rights reserved.
//

#import "WeatherConditionsModel.h"

@implementation WeatherConditionsModel


+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"date": @"dt",
             @"locationName": @"name",
             @"humidity": @"main.humidity",
             @"temperature": @"main.temp",
             @"tempHigh": @"main.temp_max",
             @"tempLow": @"main.temp_min",
             @"sunrise": @"sys.sunrise",
             @"sunset": @"sys.sunset",
             @"conditionDescription": @"weather",
             @"condition": @"weather",
             @"icon": @"weather",
             @"windBearing": @"wind.deg",
             @"windSpeed": @"wind.speed"
             };
}

+ (NSValueTransformer *)conditionDescriptionJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^(NSArray *values, BOOL *success, NSError **error) {
        NSDictionary *weatherObj = [values firstObject];
        return weatherObj[@"description"];
    } reverseBlock:^(NSString *str, BOOL *success, NSError **error) {
        return @[str];
    }];
}

+ (NSValueTransformer *)conditionJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^(NSArray *values, BOOL *success, NSError **error) {
        NSDictionary *weatherObj = [values firstObject];
        return weatherObj[@"main"];
    } reverseBlock:^(NSString *str, BOOL *success, NSError **error) {
        return @[str];
    }];}

+ (NSValueTransformer *)iconJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^(NSArray *values, BOOL *success, NSError **error) {
        NSDictionary *weatherObj = [values firstObject];
        return weatherObj[@"icon"];
    } reverseBlock:^(NSString *str, BOOL *success, NSError **error) {
        return @[str];
    }];
}

+ (NSValueTransformer *)dateJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^(NSString *str, BOOL *success, NSError **error) {
        return [NSDate dateWithTimeIntervalSince1970:str.floatValue];
    } reverseBlock:^(NSDate *date, BOOL *success, NSError **error) {
        return [NSString stringWithFormat:@"%f",[date timeIntervalSince1970]];
    }];
}

+ (NSValueTransformer *)sunriseJSONTransformer {
    return [self dateJSONTransformer];
}

+ (NSValueTransformer *)sunsetJSONTransformer {
    return [self dateJSONTransformer];
}

#define MPS_TO_MPH 2.23694f
// OpenWeatherAPI returns speeds in m/s. need to convert to mph.
+ (NSValueTransformer *)windSpeedJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^(NSNumber *num, BOOL *success, NSError **error) {
        return @(num.floatValue*MPS_TO_MPH);
    } reverseBlock:^(NSNumber *speed, BOOL *success, NSError **error) {
        return @(speed.floatValue/MPS_TO_MPH);
    }];
}

+ (const NSDictionary *)iconDictionary {

    static NSDictionary const *_iconDict = nil;
    
    if (_iconDict == nil) {
        _iconDict = @{
                      @"01d" : @"1",
                      @"02d" : @"A",
                      @"03d" : @"3",
                      @"04d" : @"C",
                      @"09d" : @"G",
                      @"10d" : @"F",
                      @"11d" : @"S",
                      @"13d" : @"I",
                      @"50d" : @"C",
                      @"01n" : @"6",
                      @"02n" : @"a",
                      @"03n" : @"3",
                      @"04n" : @"b",
                      @"09n" : @"g",
                      @"10n" : @"f",
                      @"11n" : @"s",
                      @"13n" : @"i",
                      @"50n" : @"c",
                      };
    }
    return _iconDict;
}

- (NSString *)iconName {
    return [WeatherConditionsModel iconDictionary ][self.icon];
}

@end
