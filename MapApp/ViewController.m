//
//  ViewController.m
//  MapApp
//
//  Created by Aditya Narayan on 11/16/15.
//  Copyright © 2015 turntotech.io. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()


@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *mapTypeSegmentControl;
@property (nonatomic,strong) CLLocationManager *locationManager;

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.mapView.delegate = self;
  CLLocationCoordinate2D locationOfTTT = CLLocationCoordinate2DMake(40.741448, -73.989969);
  MKCoordinateSpan mapSpan = MKCoordinateSpanMake(0.025, 0.025);
  MKCoordinateRegion region = MKCoordinateRegionMake(locationOfTTT,mapSpan);
  [self.mapView setRegion:region];

  MKCoordinateRegion adjustedRegion = [_mapView regionThatFits:MKCoordinateRegionMakeWithDistance(locationOfTTT, 200, 200)];
  [_mapView setRegion:adjustedRegion animated:YES];
  //[self.mapView setRegion:region];

  MKPointAnnotation *turnToTech = [[MKPointAnnotation alloc] init];
  turnToTech.coordinate = locationOfTTT;
  turnToTech.title = @"TurnToTech";
  turnToTech.subtitle = @"IS AWESOME";
  [_mapView addAnnotation:turnToTech];
  
  NSDictionary *restaurants = @{@"Indikich":@"25 W 23rd St, New York, NY 10010", @"Eataly" :@"200 5th Ave, New York, NY 10010", @"Sagaponack":@"4 W 22nd St, New York, NY 10010"};
  for (NSString *key in restaurants){
    NSLog(@"%@ - %@",key,[restaurants valueForKey:key]);
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    CLGeocodeCompletionHandler completionHandler = ^(NSArray *placemarks, NSError *error) {
      NSLog(@"callback received");
      if(error != nil){
        NSLog(@"%@",error);
      } else {
        CLPlacemark *placemark = placemarks[0];
        MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
        annotation.coordinate = placemark.location.coordinate;
        annotation.title = key;
        [_mapView addAnnotation:annotation];
      }
    };
    [geocoder geocodeAddressString:[restaurants valueForKey:key] completionHandler:completionHandler];
  }
  
}


- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
  
  
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (IBAction)setMapType:(id)sender {
  
  switch (((UISegmentedControl *)sender).selectedSegmentIndex) {
    case 0:
      self.mapView.mapType = MKMapTypeStandard;
      break;
    case 1:
      self.mapView.mapType = MKMapTypeHybrid;
      break;
    case 2:
      self.mapView.mapType = MKMapTypeSatellite;
      break;
    default:
      break;
  }
}

@end
