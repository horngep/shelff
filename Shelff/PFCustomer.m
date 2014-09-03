//
//  PFCustomer.m
//  Shelff
//
//  Created by I-Horng Huang on 02/09/2014.
//  Copyright (c) 2014 Ren. All rights reserved.
//

#import "PFCustomer.h"

static PFCustomer *currentCustomer;

@implementation PFCustomer

+(void)setCurrentCustomer:(PFCustomer*)customer
{
    currentCustomer = customer;
}


+(PFCustomer*)currentCustomer
{
    return currentCustomer;
}

+(NSString *)parseClassName
{
    return @"Customer";
}

+(void)registerSubclass
{

}

@end


