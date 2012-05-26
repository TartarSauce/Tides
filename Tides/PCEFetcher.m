//
//  PCEFetcher.m
//  HW6
//
//  Created by Paul Goracke on 5/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PCEFetcher.h"

@interface PCEFetcher ()

@property (strong,nonatomic) NSURLConnection* currentConnection;
@property (strong,nonatomic) NSMutableData* receivedData;
@property (strong,nonatomic) NSOperationQueue* parseQueue;

@end

@implementation PCEFetcher

@synthesize currentConnection = _currentConnection;
@synthesize receivedData = _receivedData;
@synthesize parseQueue = _parseQueue;

- (void) dealloc {
	[_currentConnection cancel];
	[_currentConnection release], _currentConnection = nil;
	[_receivedData release], _receivedData = nil;
	
	[super dealloc];
}

- (id) init {
	self = [super init];
	if ( self != nil ) {
		_receivedData = [[NSMutableData alloc] init];
		_parseQueue = [[NSOperationQueue alloc] init];
	}
	return self;
}

- (void) resetCurrentConnection {
	if ( self.currentConnection != nil ) {
		[self.currentConnection cancel];
		[self.receivedData setLength:0];
	}
}

- (NSURLConnection*) fetchURLRequest:(NSURLRequest*)request {
	self.currentConnection = [NSURLConnection connectionWithRequest:request delegate:self];
	return self.currentConnection;
}

#pragma mark - NSURLConnectionDelegate

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[self.receivedData appendData:data];
}

- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	[self.receivedData setLength:0];
}

@end
