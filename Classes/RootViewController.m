//
//  RootViewController.m
//  ResortTable
//
//  Created by Dan Weaver on 10/29/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "RootViewController.h"

#define INTERESTING_TAG_NAMES @"Name", @"BaseDepth", @"Open", @"NewSnow48", @"NumLiftsTotal", @"NumLiftsOpen", nil


@implementation RootViewController

@synthesize nibLoadedCell;
@synthesize activityIndicator;
@synthesize headerImage;

- (void)viewDidLoad {
    [super viewDidLoad];
	interestingTags = [[NSSet alloc] initWithObjects: INTERESTING_TAG_NAMES];
	[resortsArray release];
	resortsArray = [[NSMutableArray alloc] init];
	
	//Start hard-coded data
		Resort *aResort = [[Resort alloc] init];
		aResort.name = @"Arapahoe Basin Ski Area";
		aResort.snowTwoDays = [NSNumber numberWithInt: 0];
		aResort.baseSnow = [NSNumber numberWithInt: 18];
		aResort.status = @"Open";
		aResort.liftsOpen = [NSNumber numberWithInt: 1];
		aResort.totalLifts = [NSNumber numberWithInt: 7];
		[resortsArray addObject: aResort];
		[aResort release];
	
		Resort *b = [[Resort alloc] init];
		b.name = @"Aspen Highlands";
		b.snowTwoDays = [NSNumber numberWithInt: 0];
		b.baseSnow = [NSNumber numberWithInt: 0];
		b.status = @"Projected opening: 12/12/09";
		b.liftsOpen = [NSNumber numberWithInt: 0];
		b.totalLifts = [NSNumber numberWithInt: 5];
		[resortsArray addObject: b];
		[b release];
	
		Resort *c = [[Resort alloc] init];
		c.name = @"Aspen Mountain";
		c.snowTwoDays = [NSNumber numberWithInt: 0];
		c.baseSnow = [NSNumber numberWithInt: 0];
		c.status = @"Projected opening: 11/26/09";
		c.liftsOpen = [NSNumber numberWithInt: 0];
		c.totalLifts = [NSNumber numberWithInt: 8];
		[resortsArray addObject: c];
		[c release];
	
		Resort *d = [[Resort alloc] init];
		d.name = @"Beaver Creek";
		d.snowTwoDays = [NSNumber numberWithInt: 0];
		d.baseSnow = [NSNumber numberWithInt: 0];
		d.status = @"Projected opening: 11/25/09";
		d.liftsOpen = [NSNumber numberWithInt: 0];
		d.totalLifts = [NSNumber numberWithInt: 25];
		[resortsArray addObject: d];
		[d release];
	
		Resort *e = [[Resort alloc] init];
		e.name = @"Breckenridge";
		e.snowTwoDays = [NSNumber numberWithInt: 0];
		e.baseSnow = [NSNumber numberWithInt: 0];
		e.status = @"Projected opening: 11/12/09";
		e.liftsOpen = [NSNumber numberWithInt: 0];
		e.totalLifts = [NSNumber numberWithInt: 30];
		[resortsArray addObject: e];
		[e release];
	
		Resort *f = [[Resort alloc] init];
		f.name = @"Buttermilk";
		f.snowTwoDays = [NSNumber numberWithInt: 0];
		f.baseSnow = [NSNumber numberWithInt: 0];
		f.status = @"Projected opening: 12/12/09";
		f.liftsOpen = [NSNumber numberWithInt: 0];
		f.totalLifts = [NSNumber numberWithInt: 7];
		[resortsArray addObject: f];
		[f release];
	
		Resort *g = [[Resort alloc] init];
		g.name = @"Copper Mountain Resort";
		g.snowTwoDays = [NSNumber numberWithInt: 0];
		g.baseSnow = [NSNumber numberWithInt: 0];
		g.status = @"Projected opening: 11/25/09";
		g.liftsOpen = [NSNumber numberWithInt: 0];
		g.totalLifts = [NSNumber numberWithInt: 22];
		[resortsArray addObject: g];
		[g release];
	//end hard coded data
	
	[snowData release];
	snowData = [[NSMutableData alloc] init];
	NSURL *url = [NSURL URLWithString: @"http://localhost:3000/widgets/snow_report.xml"];
	NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
	NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	[connection release];
	[request release];
	
	
	// create subview of main to load image
//	CGRect appRect = [[UIScreen mainScreen] applicationFrame];
//	appRect.origin = CGPointMake(0.0f,0.0f);
//	UIView *MainView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320.0f , 100.0f)];
//	UITextView *textContents = [[UITextView alloc] initWithFrame:CGRectMake(60,30,160.0f,100.0f)];
//	[textContents setText:@"Navigation Bar\n This is a sample"];
//	[textContents setBackgroundColor: [UIColor blueColor]];
//	//[textContents setDelegate:self];
//	//self.view = textContents;
//	headerImage =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"snow_report_header.png"]] ;
//	CGRect imgFrame = headerImage.frame;
//	imgFrame.origin = CGPointMake(40,30);
//	headerImage.frame = imgFrame;
//	[MainView addSubview:textContents];
//	[textContents addSubview:headerImage];
//	[headerImage release];
//	[textContents release];
//	self.navigationItem.titleView = MainView;
//	[MainView release];
	// end subview
}

- (void)startParsingSnowData {
	NSXMLParser *snowDataParser = [[NSXMLParser alloc] initWithData:snowData];
	snowDataParser.delegate = self;
	[snowDataParser parse];
	[snowDataParser release];
	[activityIndicator stopAnimating];
}

- (void)parserDidStartDocument:(NSXMLParser *)parser {
	[snowDataString release];
	snowDataString = [[NSMutableString alloc] init];
	currentElementName = nil;
	currentText = nil;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
		namespaceURI:(NSString *)namespaceURI
		qualifiedName:(NSString *)qualifiedName
		attributes:(NSDictionary *)attributesDict {
	if ([elementName isEqualToString:@"SkiArea"]) {
		[currentSnowDataDict release];
		currentSnowDataDict = [[NSMutableDictionary alloc]
							   initWithCapacity:[interestingTags count]];
	} else if ([interestingTags containsObject:elementName]) {
		currentElementName = elementName;
		currentText = [[NSMutableString alloc] init];
	}
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	[currentText appendString:string];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
		namespaceURI:(NSString *)namespaceURI
		qualifiedName:(NSString *)qName {
	if ([elementName isEqualToString:currentElementName]) {
		[currentSnowDataDict setValue:currentText forKey:currentElementName];
	} else if ([elementName isEqualToString:@"SkiArea"]) {
		Resort *aResort = [[Resort alloc] init];
		aResort.name = [currentSnowDataDict valueForKey:@"Name"];
		aResort.snowTwoDays = [currentSnowDataDict valueForKey:@"NewSnow48"];
		aResort.baseSnow = [currentSnowDataDict valueForKey:@"BaseDepth"];
		aResort.status = [currentSnowDataDict valueForKey:@"Open"];
		aResort.liftsOpen = [currentSnowDataDict valueForKey:@"NumLiftsOpen"];
		aResort.totalLifts = [currentSnowDataDict valueForKey:@"NumLiftsTotal"];
		[resortsArray addObject: aResort];
		[aResort release];
		//(@"Name: %@", [currentSnowDataDict valueForKey:@"Name"]);
	}
	[currentText release];
	currentText = nil;
}	

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[snowData appendData:data];
	[activityIndicator startAnimating];
}

- (void)connectionDidFinishLoading: (NSURLConnection*)connection {
	[self startParsingSnowData];
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
	//NSLog(@"yo: %@", [resortsArray count]);
}

/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}
*/

/*
 // Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations.
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
 */

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release anything that can be recreated in viewDidLoad or on demand.
	// e.g. self.myOutlet = nil;
}


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [resortsArray count];
	//return 100;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        //cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
		[[NSBundle mainBundle] loadNibNamed:@"ResortTableCell" owner:self options:NULL];
		cell = nibLoadedCell;
    }
    
	// Configure the cell.
	Resort *aResort = [resortsArray objectAtIndex:indexPath.row];
	UILabel *nameLabel = (UILabel*) [cell viewWithTag:1];
	nameLabel.text = aResort.name;
	//nameLabel.text = snowDataString;
	UILabel *statusLabel = (UILabel*) [cell viewWithTag:2];
	statusLabel.text = aResort.status;
	UILabel *liftsLabel = (UILabel*) [cell viewWithTag:3];
	liftsLabel.text = [NSString stringWithFormat:@"Lifts open: %@ of %@", aResort.liftsOpen, aResort.totalLifts];
	UILabel *snowTwoDaysLabel = (UILabel*) [cell viewWithTag:4];
	snowTwoDaysLabel.text = [NSString stringWithFormat:@"48hr: %@\"", aResort.snowTwoDays];
	UILabel *baseSnowLabel = (UILabel*) [cell viewWithTag:5];
	baseSnowLabel.text = [NSString stringWithFormat:@"Base: %@\"", aResort.baseSnow];
	
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 100;
}





/*
// Override to support row selection in the table view.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    // Navigation logic may go here -- for example, create and push another view controller.
	// AnotherViewController *anotherViewController = [[AnotherViewController alloc] initWithNibName:@"AnotherView" bundle:nil];
	// [self.navigationController pushViewController:anotherViewController animated:YES];
	// [anotherViewController release];
}
*/


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


- (void)dealloc {
    [super dealloc];
}


@end

