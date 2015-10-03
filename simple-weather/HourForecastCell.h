//
//  HourForecastCell.h
//  weatherNow
//
//  Created by Sergio Puleri on 10/3/15.
//  Copyright © 2015 Sergio Puleri. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HourForecastCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *time;
@property (strong, nonatomic) IBOutlet UILabel *icon;
@property (strong, nonatomic) IBOutlet UILabel *temperature;

@end
