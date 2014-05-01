//
//  Subneter.h
//  iSubnet
//
//  Created by 7foots on 20.05.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface Subneter : NSObject
{
	unsigned int Host;
	unsigned int MaskBits;
	unsigned int Wildcard;
	unsigned int Mask;
	unsigned int Network;
	unsigned int Broadcast;
	float Hosts;
	unsigned int NumberSystem;
}

- (id)init;
- (void)calculate;
- (bool)setIp:(NSString *)str;
- (void)setMaskBits:(int)newMaskBits;
- (void)setSystem:(int)newSystem;
- (NSString *)getIp;
- (unsigned int)getMaskBitsInt;
- (unsigned int)getNumberSystem;
- (NSString *)getMaskBits;
- (NSString *)getMask;
- (NSString *)getWildcard;
- (NSString *)getNetwork;
- (NSString *)getBroadcast;
- (NSString *)getHosts;
- (NSString *)getHtml;

- (void)load;
- (void)save;

@end
