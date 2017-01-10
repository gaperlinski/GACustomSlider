//
//  GACustomSliderTrackLayer.m
//  Pods
//
//  Created by Grzegorz Aperliński on 09.01.2017.
//
//

#import "GACustomSliderTrackLayer.h"

@implementation GACustomSliderTrackLayer
{
  // Thickness of the slider track;
  // could be potentially exposed to the user as a customizable property of the class
  float _thickness;
}

- (id)init
{
  self = [super init];
  if (self) {
    _thickness = 2.0;
  }
  return self;
}


- (void)drawInContext:(CGContextRef)ctx
{
  // Make track corners rounded and clip layer to corners
  float cornerRadius = self.bounds.size.height / 2;
  
  CGRect trackFrame = CGRectMake(self.bounds.origin.x,
                                  self.bounds.origin.y + (self.bounds.size.height / 2 - _thickness),
                                  self.bounds.size.width,
                                  _thickness);
  UIBezierPath *switchOutline = [UIBezierPath bezierPathWithRoundedRect:trackFrame
                                                           cornerRadius:cornerRadius];
  CGContextAddPath(ctx, switchOutline.CGPath);
  CGContextClip(ctx);
  
  // Fill track background
  CGContextSetFillColorWithColor(ctx, self.slider.trackColor.CGColor);
  CGContextAddPath(ctx, switchOutline.CGPath);
  CGContextFillPath(ctx);
  
  // Fill highlighted range
  CGContextSetFillColorWithColor(ctx, self.slider.trackHighlightColor.CGColor);
  float leftBound = [self.slider positionForValue:self.slider.leftValue];
  float rightBound = [self.slider positionForValue:self.slider.rightValue];
  CGContextFillRect(ctx, CGRectMake(leftBound, 0, rightBound - leftBound, self.bounds.size.height));
}

@end
