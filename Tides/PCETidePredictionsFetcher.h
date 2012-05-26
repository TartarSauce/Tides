//
//  PCETidePredictionsFetcher.h
//  HW6
//
//  Created by Paul Goracke on 5/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PCEFetcher.h"

@class PCETideStation;

/*
 Fetches tide predictions for a specified station and parses them into the same MOC as the station.
 This happens asynchronously.
 */

@interface PCETidePredictionsFetcher : PCEFetcher

+ (void) fetchPredictionsForTideStation:(PCETideStation*)station;

@end
