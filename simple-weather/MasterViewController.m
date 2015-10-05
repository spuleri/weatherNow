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
#import "WeatherManager.h"


@interface MasterViewController ()

@property (nonatomic, strong) WeatherMainViewController *current;
@property (nonatomic, strong) HourlyForecastViewController *hourly;

@end

@implementation MasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIStoryboard *storyBoard = self.storyboard;
    
    // setting up first view which is current conditions
     self.current = [storyBoard instantiateViewControllerWithIdentifier:@"CurrentWeather"];
    self.current.view.frame = self.scrollView.bounds;
    [self addChildViewController:self.current];
    [self.scrollView addSubview:self.current.view];
    [self.current didMoveToParentViewController:self];
    

    
    // Setting up 2nd view which is the hourly view
     self.hourly = [storyBoard instantiateViewControllerWithIdentifier:@"HourlyWeather"];
    CGRect frame1 = self.scrollView.bounds;
    frame1.origin.x = self.view.frame.size.width;
    self.hourly.view.frame = frame1;
    [self addChildViewController:self.hourly];
    [self.scrollView addSubview:self.hourly.view];
    [self.hourly didMoveToParentViewController:self];
    
    // Add self to register to listen to notification once the Weather Conditions View has finished loading
    // in order to apply the same background color
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applyBGColor:) name:@"BGColorChanged" object:nil];
    
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width * 2, self.view.frame.size.height);
    
    // Add in pull to refresh control
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    //set text for the refresh view indicating that we are refreshing
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to refresh" ];
    [refreshControl addTarget:self action:@selector(refreshView:) forControlEvents:UIControlEventValueChanged];
    //assuming self.scrollView is connected to a UIScrollView control
    //add the refresh controll to the subview
    //[self.scrollView addSubview:refreshControl];
    [self.scrollView insertSubview:refreshControl atIndex:0];
    
    self.scrollView.directionalLockEnabled = YES;
    self.scrollView.alwaysBounceVertical = YES;
    self.scrollView.alwaysBounceHorizontal = NO;
    self.scrollView.bounces = YES;
    
    
    
}
-(void) applyBGColor:(NSNotification*) notification {
    // Get the background color from the current VC since it anaylzes the temp and sets it
    // TODO since this happens async-ly, this isnt the most up to date color :(
    UIColor *BGColor = self.current.currentBackgroundColor;
    
    self.hourly.view.backgroundColor = BGColor;
    
}



-(void)refreshView: (UIRefreshControl *) refresh{
    
    double delayInSeconds = 1.25;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    //execute the code after .5 seconds
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        // To 'refresh', tell WeatherManager to start getting current location
       // which will then alert the 2 observers (views) whom will then update their view.
        [[WeatherManager sharedInstance] getCurrentLocation];
        
        //once all the data has been fetched
        //calling the endRefreshing Method of UIRefreshControl
        [refresh endRefreshing];
        
    });
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
