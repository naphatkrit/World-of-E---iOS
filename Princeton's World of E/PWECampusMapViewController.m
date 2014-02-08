//
//  PWECampusMapViewController.m
//  Princeton's World of E
//
//  Created by Naphat Sanguansin on 8/23/13.
//  Copyright (c) 2013 Naphat Sanguansin. All rights reserved.
//

#import "PWECampusMapViewController.h"
//#import <GoogleMaps/GoogleMaps.h>

@interface PWECampusMapViewController ()

//@property (nonatomic, weak) IBOutlet GMSMapView *mapView;

@end

@implementation PWECampusMapViewController

-(id)initWithEntity:(Third_Lev_Object *)entity
{
    self = [super initWithEntity:entity];
    if (self) {
        self.noScrollInset = YES;
    }
    return self;
}
- (void)loadView
{
    [[NSBundle mainBundle] loadNibNamed:@"PWECampusMapViewController" owner:self options:0];
//    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:1.285
//                                                            longitude:103.848
//                                                                 zoom:12];
////    self.mapView = [GMSMapView mapWithFrame:CGRectMake(0, 0, 100, 100) camera:camera];
//    [self.mapView setCamera:camera];
////    [self.mapView setTranslatesAutoresizingMaskIntoConstraints:NO];
////    [self.view addSubview:self.mapView];
////    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.mapView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0]];
////    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.mapView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
////    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.mapView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0]];
////    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.mapView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
//    
//    self.mapView.mapType = kGMSTypeNormal;
}
- (void)adjustHeightForOrientation:(UIInterfaceOrientation)orientation
{
    CGFloat width, height;
    cDims(self.parentViewController.parentViewController, width, height);
    [self.view setBounds:CGRectMake(0, 0, width, height - 20 - 10 - 10)];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self adjustHeightForOrientation:self.interfaceOrientation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
