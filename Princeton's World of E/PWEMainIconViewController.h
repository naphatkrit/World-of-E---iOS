//
//  PWEMainIconViewController.h
//  Princeton's World of E
//
//  Created by Naphat Sanguansin on 6/25/13.
//  Copyright (c) 2013 Naphat Sanguansin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PWEMainIcon.h"

@interface PWEMainIconViewController : UIViewController<PWEStandardHexagonDelegate>
@property (weak, nonatomic) IBOutlet PWEMainIcon *mainIcon;
@property (nonatomic, assign) PWEHexagonType initialFoldedType;

-(IBAction)unwindToMain:(UIStoryboardSegue *)sender;
-(void)saveInitialConstraints;

@end
