//
//  Movie.m
//  Movie
//
//  Created by Dan Weaver on 10/28/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Resort.h"

@implementation Resort

@synthesize name;
@synthesize snowTwoDays;
@synthesize baseSnow;
@synthesize status;
@synthesize liftsOpen;
@synthesize totalLifts;

- (id)initWithName:(NSString *)newName
	   snowTwoDays:(NSNumber *)newSnowTwoDays
		  baseSnow:(NSNumber *)newBaseSnow
			status:(NSString *)newStatus
		 liftsOpen:(NSNumber *)newLiftsOpen
		totalLifts:(NSNumber *)newTotalLifts {
	self = [super init];
	if(nil != self) {
		self.name = newName;
		self.snowTwoDays = newSnowTwoDays;
		self.baseSnow = newBaseSnow;
		self.status = newStatus;
		self.liftsOpen = newLiftsOpen;
		self.totalLifts = newTotalLifts;
	}
	return self;
}

- (void) dealloc {
	self.name = nil;
	self.snowTwoDays = nil;
	self.baseSnow = nil;
	self.status = nil;
	self.liftsOpen = nil;
	self.totalLifts = nil;
	[super dealloc];
}

@end
