//
//  RootViewController.m
//  ResortTable
//
//  Created by Dan Weaver on 10/29/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "RootViewController.h"


@implementation RootViewController

@synthesize nibLoadedCell;
@synthesize activityIndicator;

- (void)startParsingSnowData {
	NSXMLParser *snowDataParser = [[NSXMLParser alloc] initWithData:snowData];
	snowDataParser.delegate = self;
	[snowDataParser parse];
	[snowDataParser release];
	[activityIndicator stopAnimating];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[snowData appendData:data];
	[activityIndicator startAnimating];
}

- (void)connectionDidFinishLoading: (NSURLConnection*)connection {
	[self startParsingSnowData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	resortsArray = [[NSMutableArray alloc] init];
	Resort *aResort = [[Resort alloc] init];
	aResort.name = @"Vail";
	aResort.snowTwoDays = [NSNumber numberWithInt: 12];
	aResort.baseSnow = [NSNumber numberWithInt: 24];
	aResort.status = @"Open";
	aResort.liftsOpen = [NSNumber numberWithInt: 14];
	aResort.totalLifts = [NSNumber numberWithInt: 29];
	[resortsArray addObject: aResort];
	[aResort release];
	
	[snowData release];
	snowData = [[NSMutableData alloc] init];
	NSURL *url = [NSURL URLWithString: @"http://www.postnewstools.com/widgets/snow_report.xml"];
	NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
	NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	[connection release];
	[request release];
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

