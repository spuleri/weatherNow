//
//  WeatherRESTManager.h
//  simple-weather
//
//  Created by Sergio Puleri on 10/1/15.
//  Copyright © 2015 Sergio Puleri. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import "WeatherConditionsModel.h"
@import CoreLocation;


@interface WeatherDataRequester : NSObject

- (void)getJSONFromURL:(NSURL *)url successBlock:(void(^)(BOOL success, NSDictionary *response))block;
@property (nonatomic, strong) AFHTTPRequestOperationManager *manager;

@end
