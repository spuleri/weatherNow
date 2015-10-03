//
//  WeatherRESTManager.m
//  simple-weather
//
//  Created by Sergio Puleri on 10/1/15.
//  Copyright © 2015 Sergio Puleri. All rights reserved.
//

#import "WeatherDataRequester.h"

@implementation WeatherDataRequester

- (id)init {
    if (self = [super init]) {
        _manager = [[AFHTTPRequestOperationManager alloc] init];
    }
    return self;
}

- (void)getJSONFromURL:(NSURL *)url successBlock:(void(^)(BOOL success, NSDictionary *response))block {
    NSLog(@"Fetching: %@",url.absoluteString);
    

    
    [self.manager GET:url.absoluteString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        // verify response
        if (responseObject && [responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *responseDict = (NSDictionary *) responseObject;
            block(YES, responseDict);
        } else block(NO, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) { // invalid request.
        NSLog(@"Error loading JSON from %@ :(: %@", url.absoluteString ,error.localizedDescription);
        block(NO, nil);
    }];
    
}



@end
