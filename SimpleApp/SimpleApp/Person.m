//
//  Person.m
//  SimpleApp
//
//  Created by Sqor Admin on 4/20/15.
//  Copyright (c) 2015 Sqor. All rights reserved.
//

#import "Person.h"


@implementation Person


-(id) initWithFirstName:(NSString *)firstName withLastName:(NSString *)lastName
{

    self = [super init];
    self.firstName = firstName;
    self.lastName = lastName;


    return self;

}

-(NSString *) description
{
    return [NSString stringWithFormat: @"%@ %@ ", self.firstName, self.lastName];

}

@end