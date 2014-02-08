//
//  Competition.m
//  Princeton's World of E
//
//  Created by Naphat Sanguansin on 2/25/13.
//  Copyright (c) 2013 Naphat Sanguansin. All rights reserved.
//

#import "Competition.h"
#import "Competition_Details.h"


@implementation Competition

@dynamic date;
@dynamic onCampus;
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
