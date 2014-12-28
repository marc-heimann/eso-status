//
//  WebRequestor.m
//  MobileAuth
//
//  Created by Marc Heimann on 18.05.11.
//  Copyright 2011 byte-software. All rights reserved.
//

#import "WebRequestor.h"
#include "JSON.h"

@implementation WebRequestor

-(id) httpsRequest: (NSString *)url withCommand: (id) command {
	
	SBJSON *parser = [[SBJSON alloc] init];
	   
	NSString *post =[[NSString alloc] initWithFormat:@"%@",url];
	
	NSLog(@"URL: %@", post);
	
	NSURL *innUrl = [NSURL URLWithString:post];
	
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
	[request setURL:innUrl];
	[request setHTTPMethod:@"POST"];
	[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
	
	
	//[NSURLRequest setAllowsAnyHTTPSCertificate:YES forHost:[innUrl host]];
	
	NSError *error;
	NSURLResponse *response;
	NSData *urlData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
	
	NSString *data=[[NSString alloc]initWithData:urlData encoding:NSUTF8StringEncoding];
	
	NSLog(@"%@",data);
	
//	NSDictionary *dict = [parser objectWithString:data];
//	return dict;

    return [parser objectWithString:data];
}

-(NSString *) httpsRequestForConfig: (NSString *)url withUUID: (NSString *) uuid {
	
	NSString *post =[[NSString alloc] initWithFormat:@"%@%@",url,uuid];
	
	NSLog(@"URL: %@", post);
	
	NSURL *innUrl = [NSURL URLWithString:post];
	
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
	[request setURL:innUrl];
	[request setHTTPMethod:@"POST"];
	[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
	
	NSError *error;
	NSURLResponse *response;
	NSData *urlData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
	
	return [[NSString alloc]initWithData:urlData encoding:NSUTF8StringEncoding];	
	
}

@end
