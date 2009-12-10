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
@synthesize snowOneDay;
@synthesize baseSnow;
@synthesize status;
@synthesize liftsOpen;
@synthesize totalLifts;
@synthesize callAheadNumber;

- (id)initWithName:(NSString *)newName
	   snowTwoDays:(NSNumber *)newSnowTwoDays
		snowOneDay:(NSNumber *)newSnowOneDay
		  baseSnow:(NSNumber *)newBaseSnow
			status:(NSString *)newStatus
		 liftsOpen:(NSNumber *)newLiftsOpen
		totalLifts:(NSNumber *)newTotalLifts
   callAheadNumber:(NSString *)newCallAheadNumber {
	self = [super init];
	if(nil != self) {
		self.name = newName;
		self.snowTwoDays = newSnowTwoDays;
		self.snowOneDay = newSnowOneDay;
		self.baseSnow = newBaseSnow;
		self.status = newStatus;
		self.liftsOpen = newLiftsOpen;
		self.totalLifts = newTotalLifts;
		self.callAheadNumber = newCallAheadNumber;
	}
	return self;
}

- (void) dealloc {
	self.name = nil;
	self.snowTwoDays = nil;
	self.snowOneDay = nil;
	self.baseSnow = nil;
	self.status = nil;
	self.liftsOpen = nil;
	self.totalLifts = nil;
	self.callAheadNumber = nil; 
	[super dealloc];
}

@end
