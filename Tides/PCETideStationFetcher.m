//
//  PCETideStationFetcher.m
//  HW6
//
//  Created by Paul Goracke on 5/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PCETideStationFetcher.h"

#import "PCEParseStationsOperation.h"

@interface PCETideStationFetcher () <NSURLConnectionDataDelegate>

@property (strong,nonatomic) NSManagedObjectContext* managedObjectContext;

+ (void) fetchTideStationsForLatitude:(float)latitude 
									 longitude:(float)longitude 
									 inContext:(NSManagedObjectContext*)context;
@end

@implementation PCETideStationFetcher

@synthesize managedObjectContext = _managedObjectContext;

static PCETideStationFetcher* gSharedFetcher = nil;

+ (id) sharedInstance {
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		gSharedFetcher = [[self alloc] init];
	});
	
	return gSharedFetcher;
}

- (void) dealloc {
	[_managedObjectContext release], _managedObjectContext = nil;
	
	[super dealloc];
}

- (void) fetchTideStationsForLatitude:(float)latitude 
									 longitude:(float)longitude 
									 inContext:(NSManagedObjectContext*)context 
{
	[self resetCurrentConnection];
	
	self.managedObjectContext = context;
	
	float radius = 500; // hardcoded constant for now
	
	NSString* urlString = [NSString stringWithFormat:
								  @"http://www.sailwx.info/tides/tidestaXML.phtml?lat=%1$.3f&lon=%2$.3f&radius=%3$.2f",
								  latitude, 
								  longitude, 
								  radius];
	NSURL* url = [NSURL URLWithString:urlString];
	NSURLRequest* request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
	[self fetchURLRequest:request];
}

#pragma mark - NSURLConnectionDelegate

- (void) connectionDidFinishLoading:(NSURLConnection *)connection {
	// Logging for debugging
//	NSString* string = [[NSString alloc] initWithData:self.receivedData encoding:NSUTF8StringEncoding];
//	NSLog(@"received: %@", string);
	
	PCEParseStationsOperation* op = [[PCEParseStationsOperation alloc] initWithData:self.receivedData context:self.managedObjectContext];
	[self.parseQueue addOperation:op];
	[op release];
	
	[self resetCurrentConnection];
}

#pragma mark - Class Methods

+ (void) fetchTideStationsInContext:(NSManagedObjectContext *)context {
	// hardcoded lat/long for scaffolding
	[self fetchTideStationsForLatitude:47.688
									 longitude:-122.403
									 inContext:context];
}

+ (void) fetchTideStationsForLatitude:(float)latitude 
									 longitude:(float)longitude 
									 inContext:(NSManagedObjectContext*)context 
{
	PCETideStationFetcher* sharedFetcher = [self sharedInstance];
	[sharedFetcher fetchTideStationsForLatitude:latitude longitude:longitude inContext:context];
}

@end
