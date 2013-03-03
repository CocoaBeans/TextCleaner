//
//  TCCleaner.h
//  TextCleaner
//
//  Created by Kevin Ross on 3/2/13.
//  Copyright (c) 2013 Kevin Ross. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TCCleaner : NSObject
@property (assign) IBOutlet NSTextField *textField;
@property (assign) IBOutlet NSButton *pasteboardCheckbox;


- (IBAction)cleanText:(id)sender;
- (IBAction)clearText:(id)sender;

@end
