//
//  UBTideDetailViewController.h
//  Tides
//
//  Created by R Auradkar on 5/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CoreData/CoreData.h>

@class PCETideStation;

extern NSString* const PCETidePredictionsViewControllerKeyTideStation;

@interface UBTideDetailViewController : UITableViewController <NSFetchedResultsControllerDelegate>

//@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

//@property (strong, nonatomic) id detailItem;

@property (strong, nonatomic) PCETideStation *tideStation;

@end
