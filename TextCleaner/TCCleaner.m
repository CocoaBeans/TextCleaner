//
//  TCCleaner.m
//  TextCleaner
//
//  Created by Kevin Ross on 3/2/13.
//  Copyright (c) 2013 Kevin Ross. All rights reserved.
//

#import "TCCleaner.h"

@implementation TCCleaner


- (BOOL)convertRTFAtURL:(NSURL *)inputURL
            toDirectory:(NSURL *)outputDir
{
    // Convert the file
    BOOL didConvert = NO;
    
    BOOL isRTFD = [[[inputURL pathExtension] lowercaseString] isEqualToString:@"rtfd"];
    NSData *rtfData = [NSData dataWithContentsOfURL:inputURL];
    NSDictionary *docAttributes = nil;
    NSAttributedString *rtfString = nil;
    if (isRTFD)
    {
        rtfString = [[NSAttributedString alloc] initWithRTFD:rtfData
                                          documentAttributes:&docAttributes];
    }
    else
    {
        rtfString =     [[NSAttributedString alloc] initWithRTF:rtfData
                                             documentAttributes:&docAttributes];
    }
    
    NSString *plainTxt = [rtfString string];
    
    NSString *fileName = [[[[inputURL path] lastPathComponent] stringByDeletingPathExtension] stringByAppendingPathExtension:@"txt"];
    NSURL *outputFileURL = [outputDir URLByAppendingPathComponent:fileName];
    NSError *error = nil;
    didConvert = [plainTxt writeToURL:outputFileURL
                     atomically:YES
                       encoding:NSUTF8StringEncoding
                          error:&error];

    if (didConvert == NO && error)
        NSLog(@"%@", [error localizedDescription]);
    
    return didConvert;
}


- (IBAction)convertRTFtoTXTAction:(id)sender
{
    NSOpenPanel *inputPanel = [NSOpenPanel openPanel];
    [inputPanel setTitle:@"Choose the RTF files to convert"];
    [inputPanel setAllowsMultipleSelection:YES];
    [inputPanel setAllowedFileTypes:[NSArray arrayWithObjects:@"rtf", @"rtfd", nil]];
    [inputPanel setAllowsOtherFileTypes:NO];
    
    [inputPanel beginWithCompletionHandler:^(NSInteger result)
    {
        if (result == NSOKButton)
        {
            NSOpenPanel *outputPanel = [NSOpenPanel openPanel];
            [outputPanel setAllowsMultipleSelection:NO];
            [outputPanel setCanChooseFiles:NO];
            [outputPanel setCanChooseDirectories:YES];
            [outputPanel setCanCreateDirectories:YES];
            [outputPanel setTitle:@"Choose an output directory"];
            [outputPanel beginWithCompletionHandler:^(NSInteger result)
            {
                NSURL *outputDirURL = [outputPanel URL];
                for (NSURL *url in [inputPanel URLs])
                {
                    // TODO:Recursively decend into urls that are directories and convert the files...
                    
                    // Convert the RTF files to plain text
                    [self convertRTFAtURL:url toDirectory:outputDirURL];
                }
            }];
        }

    }];


}

- (NSString *)cleanString:(NSString *)string
{
    
    NSMutableString *txt = [string mutableCopy];
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
	
    return txt;
}

- (IBAction)cleanText:(id)sender
{
	NSMutableString *txt = [self.textField.stringValue mutableCopy];
	
    NSString *cleanedTxt;
    cleanedTxt = [self cleanString:txt];
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
