//
//  TCAppDelegate.m
//  TextCleaner
//
//  Created by Kevin Ross on 2/2/13.
//  Copyright (c) 2013 Kevin Ross. All rights reserved.
//

#import "TCAppDelegate.h"

@implementation TCAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	// Insert code here to initialize your application
}

- (IBAction)cleanText:(id)sender
{
	NSMutableString *txt = [self.textField.stringValue mutableCopy];
	
	// Load the TxtConversions table
	NSString *file = [[NSBundle mainBundle] pathForResource:@"TxtConversions"
													 ofType:@"plist"];
	NSDictionary *txtTable = (NSDictionary *)[[NSString stringWithContentsOfFile:file
													encoding:NSUTF8StringEncoding
													   error:NULL] propertyList];
	
	for (NSString *key in [txtTable allKeys])
	{
		NSString *replacement = [txtTable valueForKey:key];

		NSRange rangeOfCharacters = [txt rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:key]];
		while (rangeOfCharacters.location != NSNotFound)
		{
			[txt replaceCharactersInRange:rangeOfCharacters withString:replacement];
			rangeOfCharacters = [txt rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:key]];
		}

	}
	
	NSString *cleanedTxt = [NSString stringWithString:txt];
	self.textField.stringValue = cleanedTxt;
	
	if (self.pasteboardCheckbox.state == NSOnState)
	{
		NSPasteboard *pb = [NSPasteboard generalPasteboard];
		[pb clearContents];
		BOOL didWriteToPB = [pb writeObjects:[NSArray arrayWithObject:cleanedTxt]];
		if (didWriteToPB == NO) {
			NSLog(@"Did not write to PB!");
		}
	}
}

- (IBAction)clearText:(id)sender
{
	self.textField.stringValue = [NSString string];
}
@end
