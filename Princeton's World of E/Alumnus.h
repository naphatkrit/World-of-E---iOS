//
//  Alumnus.h
//  Princeton's World of E
//
//  Created by Naphat Sanguansin on 2/25/13.
//  Copyright (c) 2013 Naphat Sanguansin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Third_Lev_Object.h"


@interface Alumnus : Third_Lev_Object

@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * organization;
@property (nonatomic, retain) NSString * url;

@end
