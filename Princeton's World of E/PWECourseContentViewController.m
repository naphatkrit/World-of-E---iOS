//
//  PWECourseContentViewController.m
//  Princeton's World of E
//
//  Created by Naphat Sanguansin on 3/31/13.
//  Copyright (c) 2013 Naphat Sanguansin. All rights reserved.
//

#import "PWECourseContentViewController.h"
#import "PWEAppDelegate.h"
#import "PWEViewController.h"
#import "OpenInChromeController.h"
#import "PWERestorationPointIndex.h"

@interface PWECourseContentViewController ()

@property (weak, nonatomic) IBOutlet UIButton *linkButton;
@property (weak, nonatomic) IBOutlet UITextView *detailsTextView;
@property (nonatomic, weak) Course *entity;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *facultyButton;

- (IBAction)goToLink:(id)sender;

- (IBAction)goToFaculty:(id)sender;

@end

@implementation PWECourseContentViewController

- (void)loadView
{
    [[NSBundle mainBundle] loadNibNamed:@"PWECourseContentViewController" owner:self options:0];
}
- (void)viewDidLoad
{
    // fotmat view
    [self.view setTranslatesAutoresizingMaskIntoConstraints:NO];
    CGFloat fontSize;
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        fontSize = kContentFontSizePhone;
    } else {
        fontSize = kContentFontSizePad;
    }
    [self.titleLabel setFont:[UIFont fontWithName:kFontName size:fontSize*2.0]];
    [self.detailsTextView setFont:[UIFont fontWithName:kFontNameBody size:fontSize]];
    //    [self.detailsTextView setContentInset:UIEdgeInsetsMake(0, -8, 0, -8)];
    [self.linkButton.titleLabel setFont:[UIFont fontWithName:kFontName size:fontSize]];
    [self.linkButton setTitleColor:kTintColor forState:UIControlStateNormal];
    [self.linkButton setTitleColor:kTintHighlightedColor forState:UIControlStateHighlighted];
    [self.linkButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [self.linkButton.titleLabel sizeToFit];
    [self.linkButton sizeToFit];
    
    [self.facultyButton.titleLabel setFont:[UIFont fontWithName:kFontName size:fontSize]];
    [self.facultyButton setTitleColor:kTintColor forState:UIControlStateNormal];
    [self.facultyButton setTitleColor:kTintHighlightedColor forState:UIControlStateHighlighted];
    [self.facultyButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [self.facultyButton.titleLabel sizeToFit];
    [self.facultyButton sizeToFit];
    
    // update view
    [self.titleLabel setText:self.entity.name];
    [self.detailsTextView setText:self.entity.details.details];
    [self adjustHeightForOrientation:self.interfaceOrientation];
}
- (void)adjustHeightForOrientation:(UIInterfaceOrientation)orientation
{
    
    CGFloat width;
    CGFloat height;
    BOOL shouldSwitch;
    if (UIInterfaceOrientationIsPortrait(orientation)) {
        if (UIInterfaceOrientationIsPortrait(self.parentViewController.interfaceOrientation)) {
            shouldSwitch = NO;
        } else {
            shouldSwitch = YES;
        }
    } else {
        if (UIInterfaceOrientationIsPortrait(self.parentViewController.interfaceOrientation)) {
            shouldSwitch = YES;
        } else {
            shouldSwitch = NO;
        }
    }
    if (shouldSwitch) {
        width = self.view.bounds.size.height;
        height = self.view.bounds.size.width;
        
    } else {
        width = self.view.bounds.size.width;
        height = self.view.bounds.size.height;
    }
    CGSize size;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        CGSize boundingSize = CGSizeMake(width - 80.0, CGFLOAT_MAX);
        CGRect rect = [self.detailsTextView.text boundingRectWithSize:boundingSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: self.detailsTextView.font} context:nil];
        size = rect.size;
    } else {
        size = [self.detailsTextView.text sizeWithFont:self.detailsTextView.font constrainedToSize:CGSizeMake(width - self.detailsTextView.frame.origin.x * 2 - 10, CGFLOAT_MAX)];
        size.height = size.height + 10;
    }
    
    CGFloat h = 20.0 + self.titleLabel.bounds.size.height + 8.0 + size.height + 8 + 44 + 20;
    [self.view setBounds:CGRectMake(0, 0, width, h + 20.0)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)goToLink:(id)sender {
    OpenInChromeController *open = [[OpenInChromeController alloc] init];
    UIActionSheet *actionSheet;
    if ([open isChromeInstalled]) {
        actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Open in Safari",@"Open in Chrome", nil];
    } else {
        actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Open in Safari", nil];
    }
     
    [actionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    if (IS_IPAD()) {
        [actionSheet showFromRect:[(UIView *)sender frame] inView:self.view animated:YES];
    } else {
        [actionSheet showInView:self.parentViewController.parentViewController.parentViewController.view];
    }
}

- (IBAction)goToFaculty:(id)sender {
//    PWEViewController *viewController = [(PWEAppDelegate *)[[UIApplication sharedApplication] delegate] viewController];
    PWERestorationPointIndex *index = [PWERestorationPointIndex new];
    index.hexagonType = PWEHexagonTypeNone;
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationNewPage object:self userInfo:@{kPageIndexKey: index}];
}

-(void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == actionSheet.cancelButtonIndex) return;
    NSURL *url = [NSURL URLWithString:self.entity.details.url];
    NSLog(@"%@", self.entity.details.url);
    switch (buttonIndex) {
        case 0:
            [[UIApplication sharedApplication] openURL:url];
            break;
        case 1:
        {
            OpenInChromeController *open = [[OpenInChromeController alloc] init];
            [open openInChrome:url withCallbackURL:[NSURL URLWithString:@"princetonworldofe://"] createNewTab:YES];
            break;
        }
            
    }
}
@end
