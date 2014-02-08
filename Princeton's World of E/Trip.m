//
//  Trip.m
//  Princeton's World of E
//
//  Created by Naphat Sanguansin on 2/28/13.
//  Copyright (c) 2013 Naphat Sanguansin. All rights reserved.
//

#import "Trip.h"
#import "Trip_Details.h"


@implementation Trip

@dynamic date;
@dynamic organizer;
@dynamic details;

- (NSDate *)sectionInfo{
    if (!self.date) {
        return nil;
    }
    NSDateComponents *component = [[NSCalendar currentCalendar] components:(NSMonthCalendarUnit|NSYearCalendarUnit) fromDate:self.date];
    [component setCalendar:[NSCalendar currentCalendar]];
    return [component date];
}

@end
