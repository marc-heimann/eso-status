//
//  main.m
//  ESOStatus
//
//  Created by Marc Heimann on 01.05.14.
//  Copyright (c) 2014 Byte Software. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "byteAppDelegate.h"

int main(int argc, char * argv[])
{
    @autoreleasepool {
        
        for (NSString* family in [UIFont familyNames])
        {
            NSLog(@"%@", family);
            
            for (NSString* name in [UIFont fontNamesForFamilyName: family])
            {
                NSLog(@"  %@", name);
            }
        }
        
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([byteAppDelegate class]));
    }
}
