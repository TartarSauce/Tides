//
//  PCEFetcher.h
//  HW6
//
//  Created by Paul Goracke on 5/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

/*
 Provide base class functionality for fetching and parsing an XML feed.
 */

#import <Foundation/Foundation.h>

@interface PCEFetcher : NSObject

@property (strong,nonatomic,readonly) NSMutableData* receivedData;
@property (strong,nonatomic,readonly) NSOperationQueue* parseQueue;

- (void) resetCurrentConnection;

- (NSURLConnection*) fetchURLRequest:(NSURLRequest*)request;

@end
