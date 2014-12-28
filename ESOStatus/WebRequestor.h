//
//  WebRequestor.h
//  MobileAuth
//
//  Created by Marc Heimann on 18.05.11.
//  Copyright 2011 byte-software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WebRequestor : NSObject {

}

-(NSDictionary *) httpsRequest: (NSString *)url withCommand: (id) command;

-(NSString *) httpsRequestForConfig: (NSString *)url withUUID: (NSString *) uuid;

@end
