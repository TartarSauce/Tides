//
//  UBTidePredictionCell.h
//  Tides
//
//  Created by R Auradkar on 5/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UBTidePredictionCell : UITableViewCell

@property (assign, nonatomic) IBOutlet UILabel* time;
@property (assign, nonatomic) IBOutlet UILabel* type;
@property (assign, nonatomic) IBOutlet UILabel* value;

@end
