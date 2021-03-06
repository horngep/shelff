//
//  PFCustomer.h
//  Shelff
//
//  Created by I-Horng Huang on 02/09/2014.
//  Copyright (c) 2014 Ren. All rights reserved.
//

#import <Parse/Parse.h>

@interface PFCustomer : PFObject <PFSubclassing>

+(void)setCurrentCustomer:(PFCustomer*)customer;
+(PFCustomer*)currentCustomer;
+(NSString *)parseClassName;

@end
