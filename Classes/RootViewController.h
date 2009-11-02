//
//  RootViewController.h
//  ResortTable
//
//  Created by Dan Weaver on 10/29/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "Resort.h"

@interface RootViewController : UITableViewController {
	NSMutableArray	*resortsArray;
	NSMutableData	*snowData;
	UITableViewCell *nibLoadedCell;
	UIActivityIndicatorView *activityIndicator;
	NSMutableString *snowDataString;
	NSMutableDictionary *currentSnowDataDict;
	NSString *currentElementName;
	NSMutableString *currentText;
	NSSet *interestingTags;
	UIImageView *headerImage;
}

@property (nonatomic, retain) IBOutlet UITableViewCell *nibLoadedCell;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, retain) IBOutlet UIImageView *headerImage;

@end
