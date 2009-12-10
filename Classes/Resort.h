//
//  Movie.h
//  Movie
//
//  Created by Dan Weaver on 10/28/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Resort : NSObject {
	NSString *name;
	NSNumber *snowTwoDays;
	NSNumber *snowOneDay;
	NSNumber *baseSnow;
	NSString *status;
	NSNumber *liftsOpen;
	NSNumber *totalLifts;
	NSString *callAheadNumber;
}

- (id)initWithName:(NSString *)newName
	   snowTwoDays:(NSNumber *)newSnowTwoDays
		snowOneDay:(NSNumber *)newSnowOneDay
		  baseSnow:(NSNumber *)newBaseSnow
			status:(NSString *)newStatus
		 liftsOpen:(NSNumber *)newLiftsOpen
		totalLifts:(NSNumber *)newTotalLifts
   callAheadNumber:(NSString *)newCallAheadNumber;

@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSNumber *snowTwoDays;
@property(nonatomic, copy) NSNumber *snowOneDay;
@property(nonatomic, copy) NSNumber *baseSnow;
@property(nonatomic, copy) NSString *status;
@property(nonatomic, copy) NSNumber *liftsOpen;
@property(nonatomic, copy) NSNumber *totalLifts;
@property(nonatomic, copy) NSString *callAheadNumber;

@end
