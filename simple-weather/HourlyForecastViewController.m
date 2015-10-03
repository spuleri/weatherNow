//
//  HourlyForecastViewController.m
//  weatherNow
//
//  Created by Sergio Puleri on 10/2/15.
//  Copyright © 2015 Sergio Puleri. All rights reserved.
//

#import "HourlyForecastViewController.h"
#import "WeatherHourlyForecastModel.h"
#import "HourForecastCell.h"

@interface HourlyForecastViewController ()

@property (nonatomic, strong) NSDateFormatter *hourFormatter;

@end

@implementation HourlyForecastViewController

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        _hourFormatter = [[NSDateFormatter alloc] init];
        _hourFormatter.dateFormat = @"h a";
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    //@@@@ YAAAAAAAS , NOW THE ONLY ISSUE IS SOME BROKEN ASS CONSTRAINTS
    
    //self.tableView = [[UITableView alloc] init];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorColor = [UIColor colorWithWhite:1 alpha:0.2];
    //self.tableView.pagingEnabled = YES;
    //[self.view addSubview:self.tableView];
    // for somereason, without this, it takes the a default height and is all wonky
    //self.tableView.rowHeight = 100;
    
    self.dataGetter =  [[WeatherDataRequester alloc] init];
    self.hourlyForecast = [NSMutableArray array];
    
    // Adding self as delegate to WeatherManager protocol
    [[WeatherManager sharedInstance] addWeatherManagerDelegate:self];
    


}

- (void) locationManagerDidUpdateLocation:(CLLocation *)location {
    // location has been updated, now get hourly forecast
    [self getHourlyForecastForLocation:location.coordinate];
}

- (void)getHourlyForecastForLocation:(CLLocationCoordinate2D)coordinate {
    NSString *urlString = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/forecast?lat=%f&lon=%f&units=imperial&cnt=12",coordinate.latitude, coordinate.longitude];
    NSURL *url = [NSURL URLWithString:urlString];
    
    //Block for AFNetworking request
    void (^getHourlyJSONData)(BOOL success, NSDictionary *response) = ^void(BOOL success, NSDictionary *response) {
        
        NSArray* hourlyJSON = response[@"list"];
        
        for (NSDictionary *hour in hourlyJSON) {
            NSError *error;
            WeatherHourlyForecastModel *hourly = [MTLJSONAdapter modelOfClass:WeatherHourlyForecastModel.class fromJSONDictionary:hour error:&error];
            if (error) {
                NSLog(@"Couldn't convert to WeatherHourlyForecastModel: %@", error);
            }
            
            [self.hourlyForecast addObject:hourly];
            
        }
        
        //NSLog(@"%@", self.hourlyForecast);
        
        // now need to load tableview!!!!
        [self initHourlyView];
        [self.tableView reloadData];
        

        
    };
    
    // Call function to get JSON from a url, and pass in appropiate block for hourly forecast
    [self.dataGetter getJSONFromURL:url successBlock:getHourlyJSONData];
    
    

}

- (void)initHourlyView {
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"hourCell";
    HourForecastCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    WeatherConditionsModel *hour = self.hourlyForecast[indexPath.row];
    
    // Configure cell style
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    
    
    cell.icon.text = [hour iconName];
    NSString *timeString = [self.hourFormatter stringFromDate:hour.date];
    NSLog(@"%@", timeString);
    cell.time.text = timeString;
    cell.temperature.text = [NSString stringWithFormat:@"%ld", hour.temperature.integerValue];
    
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Hourly forecast from openweather map are 2-3 hrs apart.
    // only want like ~6 so we have a span of 12-18 hours.
    // TODO: maybe want 7-8 and disabl scroll?
    NSInteger hourCount =  self.hourlyForecast.count;
    NSLog(@"There are this many %lu hours ",  (unsigned long)hourCount);
    return MIN(hourCount, 8);
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
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
