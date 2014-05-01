//
//  RootViewController.m
//  iSubnet
//
//  Created by 7foots on 21.05.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RootViewController.h"
#import "CalcViewController.h"

@implementation RootViewController

- (void)save
{
    [subneter save];
}

- (void)dataToWebView
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        NSString *path = [[NSBundle mainBundle] bundlePath];
        NSURL *baseURL = [NSURL fileURLWithPath:path];
        [webView loadHTMLString:[subneter getHtml] baseURL:baseURL];
    }
}

- (void)updateAll
{
    [resultsTable reloadData];
    labelBits.text = [subneter getMaskBits];
    [self dataToWebView];
}

- (IBAction)textFieldChanged:(id)sender
{
	if (![subneter setIp:textFieldIp.text])
    {
		UIAlertView *errAlert = [[UIAlertView alloc] initWithTitle:@"Incorrect IP!" message:@"Please enter a valid IP address!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
		[errAlert show];
		[errAlert release];
	}
	else
    {
		[self updateAll];
	}
}

- (IBAction)sliderChanged:(id)sender
{
    [subneter setMaskBits:(unsigned int)(sliderBits.value + 0.5f)];
    [self updateAll];
}

- (IBAction) segmentChanged:(id)sender
{
    unsigned int NumberSystem = 10;
    
	switch (segmentNumberSystem.selectedSegmentIndex)
	{
		case 0: NumberSystem = 16; break;
		case 1: NumberSystem = 10; break;
		case 2: NumberSystem = 8; break;
		case 3: NumberSystem = 2; break;
	}
	
    [subneter setSystem:NumberSystem];
    [self updateAll];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	return YES;
}

- (IBAction)showCalculations:(id)sender 
{
    CalcViewController *calc = [[CalcViewController alloc] initWithNibName:@"CalcViewController" bundle:nil];
    
    [calc load:[subneter getHtml]];
    
	[[self navigationController] pushViewController:calc animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    subneter = [[Subneter alloc] init];
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"/images/background.png"]];
    
    
    arrayResults = [[NSArray alloc]initWithObjects:@"Mask:", @"Wildcard:", @"Network:", @"Broadcast:", @"Hosts:", nil];
	int Shift = 0;
     
    CGRect labelIpRect = CGRectMake(10, 20 - Shift, 22, 31);//-72
    CGRect textFieldIpRect = CGRectMake(34, 20 - Shift, 236, 31);//-72
    CGRect labelBitsRect = CGRectMake(278, 20 - Shift, 32, 31);//-72
    CGRect sliderBitsRect = CGRectMake(10, 59 - Shift, 300, 22);//-33
    CGRect segmentRect = CGRectMake(10, 353 - Shift, 300, 43);
    
	labelIP = [[UILabel alloc] initWithFrame:labelIpRect];
	labelIP.text = @"IP";
	labelIP.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
	labelIP.backgroundColor = [UIColor clearColor];
	
	textFieldIp = [[UITextField alloc] initWithFrame:textFieldIpRect];
	textFieldIp.text = [subneter getIp];
	textFieldIp.borderStyle = UITextBorderStyleRoundedRect;
	textFieldIp.clearButtonMode = UITextFieldViewModeAlways;
	textFieldIp.adjustsFontSizeToFitWidth = YES;
	textFieldIp.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	textFieldIp.keyboardType = UIKeyboardTypeNumbersAndPunctuation; 
	textFieldIp.delegate = self;
	
	labelBits = [[UILabel alloc] initWithFrame:labelBitsRect];
	labelBits.text = [subneter getMaskBits];
	labelBits.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
	labelBits.textAlignment = UITextAlignmentRight;
	labelBits.backgroundColor = [UIColor clearColor];
	
	sliderBits = [[UISlider alloc] initWithFrame:sliderBitsRect];
	sliderBits.maximumValue = 32;
	sliderBits.minimumValue = 0;
	sliderBits.continuous = YES;
	sliderBits.value = [subneter getMaskBitsInt];
    
    
    resultsTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 89, 320, 240) style:UITableViewStyleGrouped];
    resultsTable.backgroundColor = [UIColor clearColor];
    resultsTable.backgroundView = nil;
    resultsTable.opaque = NO;
    resultsTable.scrollEnabled = NO;
    //resultsTable.delegate = self;
    resultsTable.dataSource = self;
	
    
	segmentNumberSystem = [[UISegmentedControl alloc] initWithItems:
                           [NSArray arrayWithObjects:
                            @"Hex", @"Dec", @"Oct", @"Bin", nil]];
	segmentNumberSystem.frame = segmentRect;
	
	switch ([subneter getNumberSystem])
    {
		case 2: segmentNumberSystem.selectedSegmentIndex = 3; break;
		case 8: segmentNumberSystem.selectedSegmentIndex = 2; break;
		case 10: segmentNumberSystem.selectedSegmentIndex = 1; break;
		case 16: segmentNumberSystem.selectedSegmentIndex = 0; break;	
	}
    
	[textFieldIp addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingDidEnd];
	[sliderBits addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventValueChanged];
	[segmentNumberSystem addTarget:self action:@selector(segmentChanged:) forControlEvents:UIControlEventValueChanged];
	[self.view addSubview:labelIP];
	[self.view addSubview:textFieldIp];
	[self.view addSubview:labelBits];
	[self.view addSubview:sliderBits];
	[self.view addSubview:segmentNumberSystem];
    [self.view addSubview:resultsTable];
        
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        webView = [[UIWebView alloc] initWithFrame:CGRectMake(320, 0, 100, 100)];
        webView.dataDetectorTypes = UIDataDetectorTypeNone;
        webView.backgroundColor = [UIColor clearColor];
        webView.opaque = NO;
        webView.userInteractionEnabled = YES;
        
        if ([[webView subviews] count] > 0)
        {
            for (UIView* shadowView in [[[webView subviews] objectAtIndex:0] subviews])
            {
                [shadowView setHidden:YES];
            }
            
            // unhide the last view so it is visible again because it has the content
            [[[[[webView subviews] objectAtIndex:0] subviews] lastObject] setHidden:NO];
        }
        
        [self orientationSizer:self.interfaceOrientation];
        [self.view addSubview:webView];
    }
    else
    {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Calculations"
                                                                                 style:UIBarButtonItemStylePlain
                                                                                target:self
                                                                                action:@selector(showCalculations:)];
    }
    
    [self updateAll];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [arrayResults count];
}

- (UITableViewCell *) getCellContentView:(NSString *)cellIdentifier
{
    
	CGRect labelRect = CGRectMake(10, 10, 90, 25);
	CGRect labelRect1 = CGRectMake(95, 10, 195, 25);
	CGRect labelRectBin = CGRectMake(10, 2, 90, 25);
	CGRect labelRectBin1 = CGRectMake(10, 18, 280, 25);
	
	UILabel *labelTemp;
	
	UITableViewCell *cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:cellIdentifier] autorelease];
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
	if (cellIdentifier == @"CellBin")
    {
		labelTemp = [[UILabel alloc] initWithFrame:labelRectBin];
	}
    else
    {
		labelTemp = [[UILabel alloc] initWithFrame:labelRect];
	}
    
	labelTemp.tag = 1;
	labelTemp.backgroundColor = [UIColor clearColor];
	[cell.contentView addSubview:labelTemp];
	[labelTemp release];
	
	if (cellIdentifier == @"CellBin")
    {
		labelTemp = [[UILabel alloc] initWithFrame:labelRectBin1];
	}
    else
    {
		labelTemp = [[UILabel alloc] initWithFrame:labelRect1];
	}
    
	labelTemp.tag = 2;
	labelTemp.backgroundColor = [UIColor clearColor];
	labelTemp.textAlignment = UITextAlignmentRight;
	[labelTemp setFont:[UIFont fontWithName:@"Courier New" size:17]];
	labelTemp.adjustsFontSizeToFitWidth = YES;
	labelTemp.minimumFontSize = 8;
	[cell.contentView addSubview:labelTemp];
	[labelTemp release];
	
	return cell;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *CellIdentifier = @"Cell";    
	
	if ([subneter getNumberSystem] == 2 && indexPath.row != 4)
    {
		CellIdentifier = @"CellBin";
	}
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];	
	
    if (cell == nil)
    {
        cell = [self getCellContentView:CellIdentifier];
    }
	
	UILabel *labelTemp1 = (UILabel *)[cell viewWithTag:1];
	UILabel *labelTemp2 = (UILabel *)[cell viewWithTag:2];
	labelTemp1.text = [arrayResults objectAtIndex:indexPath.row];
	labelTemp2.text = [[NSString alloc] initWithFormat:@"%d", indexPath.row];
	
	switch (indexPath.row)
	{
		case 0: labelTemp2.text = [subneter getMask]; break;
		case 1: labelTemp2.text = [subneter getWildcard]; break;
		case 2: labelTemp2.text = [subneter getNetwork]; break;			
		case 3: labelTemp2.text = [subneter getBroadcast]; break;
		case 4: labelTemp2.text = [subneter getHosts]; break;
	}
    
	[CellIdentifier release];
    return cell;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)orientationSizer:(UIInterfaceOrientation)interfaceOrientation
{
    if (UIInterfaceOrientationIsPortrait(interfaceOrientation))
    {
        webView.frame = CGRectMake(320, 0, 768 - 320, 1024 - 20 - 44);
    }
    else if (UIInterfaceOrientationIsLandscape(interfaceOrientation))
    {
        webView.frame = CGRectMake(320, 0, 1024 - 320, 768 - 20 - 44);
    }
    [self dataToWebView];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        [self orientationSizer:interfaceOrientation];
        return YES;
    }
    
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}



@end
