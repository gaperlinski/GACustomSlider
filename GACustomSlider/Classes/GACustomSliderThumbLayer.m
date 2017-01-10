//
//  GACustomSliderThumbLayer.m
//  Pods
//
//  Created by Grzegorz Aperliński on 09.01.2017.
//
//

#import "GACustomSliderThumbLayer.h"

@implementation GACustomSliderThumbLayer
{
  // Roundness of the slider thum;
  // could be potentially exposed to the user as a customizable property of the class
  float _roundness;
}

- (id)init
{
  self = [super init];
  if (self) {
    _roundness = 1.0;
  }
  return self;
}

- (void)drawInContext:(CGContextRef)ctx
{
  CGRect thumbFrame = CGRectInset(self.bounds, 2.0, 2.0);
  
  UIBezierPath *thumbPath = [UIBezierPath bezierPathWithRoundedRect:thumbFrame
                                                        cornerRadius:thumbFrame.size.height * _roundness / 2.0];
  
  // Fill Thumb with color and drop shadow around it
  CGContextSetShadowWithColor(ctx, CGSizeMake(0.0, 1.0), 3.0, [UIColor grayColor].CGColor);
  CGContextSetFillColorWithColor(ctx, self.slider.thumbColor.CGColor);
  CGContextAddPath(ctx, thumbPath.CGPath);
  CGContextFillPath(ctx);
  
  // Draw a light outline outside of the slider Thumb
  CGContextSetStrokeColorWithColor(ctx, [UIColor grayColor].CGColor);
  CGContextSetLineWidth(ctx, 0.2);
  CGContextAddPath(ctx, thumbPath.CGPath);
  CGContextStrokePath(ctx);
}

@end
