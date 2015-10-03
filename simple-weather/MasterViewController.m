//
//  MasterViewController.m
//  weatherNow
//
//  Created by Sergio Puleri on 10/2/15.
//  Copyright © 2015 Sergio Puleri. All rights reserved.
//

#import "MasterViewController.h"
#import "WeatherMainViewController.h"
#import "HourlyForecastViewController.h"


@interface MasterViewController ()

@end

@implementation MasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIStoryboard *storyBoard = self.storyboard;
    
    // setting up first view which is current conditions
    WeatherMainViewController *current = [storyBoard instantiateViewControllerWithIdentifier:@"CurrentWeather"];
    current.view.frame = self.scrollView.bounds;
    [self addChildViewController:current];
    [self.scrollView addSubview:current.view];
    [current didMoveToParentViewController:self];
    
    // Setting up 2nd view which is the hourly view
    HourlyForecastViewController *hourly = [storyBoard instantiateViewControllerWithIdentifier:@"HourlyWeather"];
    CGRect frame1 = self.scrollView.bounds;
    frame1.origin.x = self.view.frame.size.width;
    hourly.view.frame = frame1;    
    [self addChildViewController:hourly];
    [self.scrollView addSubview:hourly.view];
    [hourly didMoveToParentViewController:self];
    
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width * 2, self.view.frame.size.height);

    
    
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
