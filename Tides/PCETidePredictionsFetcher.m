//
//  PCETidePredictionsFetcher.m
//  HW6
//
//  Created by Paul Goracke on 5/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PCETidePredictionsFetcher.h"

#import "PCETideStation.h"
#import "PCEParsePredictionsOperation.h"

@interface PCETidePredictionsFetcher ()

@property (nonatomic,retain) NSManagedObjectContext* managedObjectContext;
@property (nonatomic,retain) PCETideStation* tideStation;

@end

@implementation PCETidePredictionsFetcher

@synthesize managedObjectContext = _managedObjectContext;
@synthesize tideStation = _tideStation;

static PCETidePredictionsFetcher* gSharedFetcher = nil;

+ (id) sharedInstance {
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		gSharedFetcher = [[self alloc] init];
	});
	
	return gSharedFetcher;
}

- (void) dealloc {
	[_managedObjectContext release], _managedObjectContext = nil;
	[_tideStation release], _tideStation = nil;
	
	[super dealloc];
}


- (void) fetchPredictionsForTideStation:(PCETideStation*)station 
{
	[self resetCurrentConnection];
	
	self.tideStation = station;
	self.managedObjectContext = station.managedObjectContext;
	
	NSString* urlString = [NSString stringWithFormat:
								  @"http://tides.mobilegeographics.com/xmldoc/%1$@",
								  station.stationIdentifier];
	NSURL* url = [NSURL URLWithString:urlString];
	NSURLRequest* request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
	[self fetchURLRequest:request];
}

#pragma mark - NSURLConnectionDelegate

- (void) connectionDidFinishLoading:(NSURLConnection *)connection {
	// Logging for debugging
	//	NSString* string = [[NSString alloc] initWithData:self.receivedData encoding:NSUTF8StringEncoding];
	//	NSLog(@"received: %@", string);
	
	PCEParsePredictionsOperation* op = [[PCEParsePredictionsOperation alloc] initWithData:self.receivedData context:self.managedObjectContext];
	[op setTideStation:self.tideStation];
	[self.parseQueue addOperation:op];
	[op release];
	
	[self resetCurrentConnection];
}

#pragma mark - Class Methods

+ (void) fetchPredictionsForTideStation:(PCETideStation*)station
{
	PCETidePredictionsFetcher* sharedFetcher = [self sharedInstance];
	[sharedFetcher fetchPredictionsForTideStation:station];
}

@end
