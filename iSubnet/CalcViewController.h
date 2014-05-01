//
//  CalcViewController.h
//  iSubnet
//
//  Created by 7foots on 22.05.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CalcViewController : UIViewController
{
    IBOutlet UIWebView *webView;
    NSString *temp;
}

@property (nonatomic, retain) IBOutlet UIWebView *webView;

- (void)load:(NSString *)str;

@end
