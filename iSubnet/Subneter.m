//
//  Subneter.m
//  iSubnet
//
//  Created by 7foots on 20.05.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Subneter.h"

@implementation Subneter

- (id)init
{
    self = [super init];
    if (self)
    {
        Host = 0xC0A80201;
        MaskBits = 24;
        NumberSystem = 10;
        [self load];
        [self calculate];
    }
    return self;
}

- (void)calculate
{
	Mask = 0xFFFFFFFF << (32 - MaskBits);
	Wildcard = ~ Mask;
	Network = Host & Mask;
	Broadcast = Host | Wildcard;
	Hosts = pow(2, 32 - MaskBits) - 2;
	Hosts = Hosts < 0 ? 0 : Hosts;
}

- (bool)setIp:(NSString *)str
{
	BOOL IsError = NO;
	int i, j, IP[4] = {0, 0, 0, 0};	
	const char *ipChar = nil;
	ipChar = [str UTF8String];
	
	for (i = 0, j = 0; i < str.length; i++)
    {
		if (ipChar[i] == '.')
        {
			j++;
			continue;
		}
		
		if (j > 3 || ipChar[i] < '0' || ipChar[i] > '9')
        {
			IsError = YES;
			break;
		}
		
		IP[j] = IP[j] * 10 + (int)(ipChar[i]) - 0x30;
	}
	
	if (j != 3 || IP[0] > 255 || IP[1] > 255 || IP[2] > 255 || IP[3] > 255)
    {
		IsError = YES;
	}
	
	if (IsError)
    {
		return false;
	}
	
    Host = IP[0] * 16777216 + IP[1] * 65536 + IP[2] * 256 + IP[3];
	[self calculate];
    return true;
}

- (void)setMaskBits:(int)newMaskBits
{
    MaskBits = newMaskBits;
    [self calculate];
}

- (void)setSystem:(int)newSystem
{
    NumberSystem = newSystem;
}

- (NSString *)bits:(NSInteger)value forSize:(int)size {
    const int shift = 8*size - 1;
    const unsigned mask = 1 << shift;
    NSMutableString *result = [NSMutableString string];
    for (int i = 1; i <= shift + 1; i++ ) {
        [result appendString:(value & mask ? @"1" : @"0")];
        value <<= 1;
        if (i % 8 == 0 && (i + 1 <= shift + 1)) {
            [result appendString:@" "];
        }
    }
    return result;
}

- (NSString *)octs:(unsigned int)value {
	NSString *str = [[NSString alloc] initWithString:@""];
	int vals[10], i = 1;
	
	while (value > 7) {
		vals[i++] = value % 8;
		value = value / 8;
	}
	vals[i++] = value;
	
	
	for (i--; i != 0; i--) {
		str = [str stringByAppendingFormat:@"%d", vals[i]];
	}
	return str;
}

- (NSString *)IpToHex:(unsigned int)value {
	return [[NSString alloc] initWithFormat:@"%.2X.%.2X.%.2X.%.2X",
			value >> 24, (value << 8) >> 24, (value << 16) >> 24, (value << 24) >> 24];
}

- (NSString *)IpToDec:(unsigned int)value {
	return [[NSString alloc] initWithFormat:@"%d.%d.%d.%d",
			value >> 24, (value << 8) >> 24, (value << 16) >> 24, (value << 24) >> 24];
}

- (NSString *)IpToOct:(unsigned int)value {
	NSString *str = [[NSString alloc] initWithString:@""];
	str = [str stringByAppendingString:[self octs:(value >> 24)]];
	str = [str stringByAppendingString:@"."];
	str = [str stringByAppendingString:[self octs:((value << 8) >> 24)]];
	str = [str stringByAppendingString:@"."];
	str = [str stringByAppendingString:[self octs:((value << 16) >> 24)]];
	str = [str stringByAppendingString:@"."];
	str = [str stringByAppendingString:[self octs:((value << 24) >> 24)]];
	return str;
}

- (NSString *)IpToBin:(unsigned int)value {
	NSString *str = [[NSString alloc] initWithString:@""];
	str = [str stringByAppendingString:[self bits:(value >> 24) forSize:1]];
	str = [str stringByAppendingString:@"."];
	str = [str stringByAppendingString:[self bits:((value << 8) >> 24) forSize:1]];
	str = [str stringByAppendingString:@"."];
	str = [str stringByAppendingString:[self bits:((value << 16) >> 24) forSize:1]];
	str = [str stringByAppendingString:@"."];
	str = [str stringByAppendingString:[self bits:((value << 24) >> 24) forSize:1]];
	return str;
}

- (NSString *)IpToStr:(unsigned int)value forSystem:(unsigned int)system {
	switch (system) {
		case 2: return [self IpToBin:value];
		case 8: return [self IpToOct:value];
		case 10: return [self IpToDec:value];
		case 16: return [self IpToHex:value];
		default: return @"";
	}
}

- (NSString *)getIp
{
    return [self IpToStr:Host forSystem:10];
}

- (unsigned int)getNumberSystem
{
    return NumberSystem;
}

- (unsigned int)getMaskBitsInt
{
    return MaskBits;
}

- (NSString *)getMaskBits
{
    return [[NSString alloc] initWithFormat:@"/ %d", MaskBits];
}

- (NSString *)getMask
{
    return [self IpToStr:Mask forSystem:NumberSystem];
}

- (NSString *)getWildcard
{
    return [self IpToStr:Wildcard forSystem:NumberSystem];
}

- (NSString *)getNetwork
{
    return [self IpToStr:Network forSystem:NumberSystem];
}

- (NSString *)getBroadcast
{
    return [self IpToStr:Broadcast forSystem:NumberSystem];
}

- (NSString *)getHosts
{
    return [[NSString alloc] initWithFormat:@"%.0f", Hosts];
}

- (NSString *)getHtml
{
   /*return [[[NSString alloc] initWithString:@"<html><head>"
             "<style>h3 {margin-bottom:0;} .sum {border-top:1px solid black;}"
             "html {padding: 0; margin:0;}"
             "body {background: url(images/paper.png); margin: 0px; padding:10px;"
             "border-width: 10px;"
             "-webkit-border-image: url(images/border.png) 10 repeat;"
             "border-image: url(images/border.png) 10 repeat;"
             "}"
             "</style></head><body></body></html>"] autorelease];*/
             
             
	return [[[NSString alloc] initWithFormat:@"<html><head>"
					 "<style>h3 {margin-bottom:0;} .sum {border-top:1px solid black;}"
             "html {padding: 0; margin:0;}"
             "body {background: url(images/paper.png); margin: 0px; padding:10px;"
             "border-width: 10px;"
             "-webkit-border-image: url(images/border.png) 10 repeat;"
             "border-image: url(images/border.png) 10 repeat;"
             "}"
                     "</style></head><body>"
					 "<h3>IP - %@ / %d</h3>"
					 "<span>%@</span><br/>"
					 "<h3>Mask</h3>"
					 "<span>%@</span><br/>"
					 "<h3>Wildcard</h3>"
					 "<span>%@</span><br/>"
					 "<h3>Network = Host AND Mask</h3>"
					 "<span>%@</span><br/>"
					 "<span>%@</span><br/>"
					 "<span class=""sum"">%@</span><br/>"
					 "<h3>Broadcast = Host OR Wildcard</h3>"
					 "<span>%@</span><br/>"
					 "<span>%@</span><br/>"
					 "<span class=""sum"">%@</span><br/>"
					 "<h3>Hosts count = 2<sup>(32 - n)</sup> - 2</h3>"
					 "<span>Hosts = 2<sup>(32 - %d)</sup> - 2"
					 " = 2<sup>%d</sup> - 2"
					 " = %.0f - 2"
					 " = %.0f</span><br/>"
					 "</body></html>",
					 [self IpToStr:Host forSystem:10], MaskBits,
					 [self IpToStr:Host forSystem:2],
					 
					 [self IpToStr:Mask forSystem:2],
					 
					 [self IpToStr:Wildcard forSystem:2],
					 
					 [self IpToStr:Host forSystem:2],
					 [self IpToStr:Mask forSystem:2],
					 [self IpToStr:Network forSystem:2],
					 
					 [self IpToStr:Host forSystem:2],
					 [self IpToStr:Wildcard forSystem:2],
					 [self IpToStr:Broadcast forSystem:2],
					 
					 MaskBits, (32 - MaskBits), (Hosts + 2), Hosts] autorelease];
}

- (void)load
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber *retrievedValue;
    
    retrievedValue = [defaults objectForKey:@"settings-Host"];
    if (retrievedValue != nil) Host = [retrievedValue intValue];
    
    retrievedValue = [defaults objectForKey:@"settings-MaskBits"];
    if (retrievedValue != nil) MaskBits = [retrievedValue intValue];
    
    retrievedValue = [defaults objectForKey:@"settings-NumberSystem"];
    if (retrievedValue != nil) NumberSystem = [retrievedValue intValue];
}

- (void)save
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithInt:Host] forKey:@"settings-Host"];
    [defaults setObject:[NSNumber numberWithInt:MaskBits] forKey:@"settings-MaskBits"];
    [defaults setObject:[NSNumber numberWithInt:NumberSystem] forKey:@"settings-NumberSystem"];
    [defaults synchronize];
}

@end
