//
//  Person.h
//  SimpleApp
//
//  Created by Sqor Admin on 4/20/15.
//  Copyright (c) 2015 Sqor. All rights reserved.
//


#ifndef SimpleApp_Person_h
#define SimpleApp_Person_h

#import <Foundation/Foundation.h>

@interface Person : NSObject

@property (nonatomic, strong) NSString * firstName;
@property (nonatomic, strong) NSString * lastName;


-(id) initWithFirstName: (NSString *) firstName withLastName: (NSString *) lastName;

-(NSString *) description;

@end


#endif


