//
//  PWEWorkshopContentViewController.m
//  Princeton's World of E
//
//  Created by Naphat Sanguansin on 8/28/13.
//  Copyright (c) 2013 Naphat Sanguansin. All rights reserved.
//

#import "PWEWorkshopContentViewController.h"
#import "OpenInChromeController.h"
#import "Workshop.h"
#import "Workshop_Details.h"

@interface PWEWorkshopContentViewController ()
@property (nonatomic, strong) Workshop *entity;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UIButton *linkButton;
- (IBAction)goToLink:(id)sender;

@end

@implementation PWEWorkshopContentViewController

- (void)loadView
{
    [[NSBundle mainBundle] loadNibNamed:@"PWEWorkshopContentViewController" owner:self options:0];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    // set fonts
    CGFloat fontSize;
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        fontSize = kContentFontSizePhone;
    } else {
        fontSize = kContentFontSizePad;
    }
    [self.titleLabel setFont:[UIFont fontWithName:kFontName size:fontSize * 2]];
    [self.descriptionTextView setFont:[UIFont fontWithName:kFontNameBody size:fontSize]];
    [self.linkButton.titleLabel setFont:[UIFont fontWithName:kFontName size:fontSize]];
    [self.linkButton setTitleColor:kTintColor forState:UIControlStateNormal];
    [self.linkButton setTitleColor:kTintHighlightedColor forState:UIControlStateHighlighted];
    [self.linkButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [self.linkButton.titleLabel sizeToFit];
    [self.linkButton sizeToFit];
    
    // set text
    self.titleLabel.text = self.entity.name;
    self.descriptionTextView.text = self.entity.details.details;
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
        CGRect rect = [self.descriptionTextView.text boundingRectWithSize:boundingSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: self.descriptionTextView.font} context:nil];
        size = rect.size;
    } else {
        size = [self.descriptionTextView.text sizeWithFont:self.descriptionTextView.font constrainedToSize:CGSizeMake(width - self.descriptionTextView.frame.origin.x * 2 - 10, CGFLOAT_MAX)];
        size.height = size.height + 10;
    }
    CGFloat h = 20.0 + self.titleLabel.bounds.size.height + 8 + size.height + 8 + self.linkButton.bounds.size.height + 20.0;
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
-(void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == actionSheet.cancelButtonIndex) return;
    NSURL *url = [NSURL URLWithString:self.entity.details.url];
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
