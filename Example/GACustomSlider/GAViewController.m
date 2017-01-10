//
//  GAViewController.m
//  GACustomSlider
//
//  Created by gaperlinski on 01/09/2017.
//  Copyright (c) 2017 gaperlinski. All rights reserved.
//

#import "GAViewController.h"

@interface GAViewController ()

@end

@implementation GAViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  NSUInteger margin = 20;
  
  // You can add the slider programmatically by using the initWithFrame: method.
  CGRect sliderFrame = CGRectMake(margin, margin * 5, self.view.frame.size.width - margin * 2, 30);
  self.customSlider = [[GACustomSlider alloc] initWithFrame:sliderFrame];
  [self.view addSubview:self.customSlider];

  // You respond to slider value changes simply subscribe to the UIControlEventValueChanged event.
  [self.customSlider addTarget:self
                    action:@selector(slideValueChanged:)
          forControlEvents:UIControlEventValueChanged];
  
  // You can manually set the initial left and right values as well as the minimum distance between the two values.
  [self.customSlider setLeftValue:0];
  [self.customSlider setRightValue:0.5];
  [self.customSlider setMinDistance:0.3];
  
  // You can also change some appearance properties.
  [self.customSlider setThumbColor: [UIColor greenColor]];
  [self.customSlider setTrackHighlightColor: [UIColor orangeColor]];
  [self.customSlider setTrackColor: [UIColor purpleColor]];
  
  // The slider is also compatible with the Interface Builder and Auto Layout;
  // All the properties above can be set in IB.
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}


- (void)slideValueChanged:(id)control
{
//  NSLog(@"Slider value changed: (%.2f,%.2f)",
//        _customSlider.leftValue, _customSlider.rightValue);
}

@end
