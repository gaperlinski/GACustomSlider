//
//  GACustomSlider.m
//  Pods
//
//  Created by Grzegorz Aperliński on 09.01.2017.
//
//

#import <QuartzCore/QuartzCore.h>
#import "GACustomSlider.h"
#import "GACustomSliderThumbLayer.h"
#import "GACustomSliderTrackLayer.h"

// Macro for easier-to-read method for keeping thumb value within permissible bounds
#define BOUND(VALUE, UPPER, LOWER)	MIN(MAX(VALUE, LOWER), UPPER)

// Macro for generating synthesized properties and setters
// to make UI responsive to property changes
#define GENERATE_SETTER(PROPERTY, TYPE, SETTER, UPDATER) \
- (void)SETTER:(TYPE)PROPERTY { \
  if (_##PROPERTY != PROPERTY) { \
    _##PROPERTY = PROPERTY; \
    [self UPDATER]; \
  } \
}

@implementation GACustomSlider {
  
  // Minimum and maximum value for sliders
  float _minValue;
  float _maxValue;
  
  // Component sublayers
  GACustomSliderTrackLayer *_trackLayer;
  GACustomSliderThumbLayer *_rightThumbLayer;
  GACustomSliderThumbLayer *_leftThumbLayer;
  
  // Width of slider thumb
  float _thumbWidth;
  
  // Calculated usable length of slider track excluding thumb width
  float _useableTrackLength;
  
  // Variables for tracking touch locations
  CGPoint _leftThumbTouchDownPoint;
  CGPoint _rightThumbTouchDownPoint;
  UITouch *_leftTouch;
  UITouch *_rightTouch;
}

#pragma mark - Initializers

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    [self initialize];
  }
  return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
  self = [super initWithCoder:aDecoder];
  if (self) {
    [self initialize];
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
  }
  return self;
}

- (void)initialize
{
  // Initialization code which sets default values
  _minValue = 0.0;
  _maxValue = 1.0;
  _leftValue = 0.2;
  _rightValue = 0.8;
  _minDistance = 0.2;
  _thumbWidth = 30.0;
  
  _trackHighlightColor = [UIColor colorWithRed:14.0/255.0
                                         green:122.0/255.0
                                          blue:254.0/255.0
                                         alpha:1.0];
  _trackColor = [UIColor grayColor];
  _thumbColor = [UIColor whiteColor];
  
  _trackLayer = [GACustomSliderTrackLayer layer];
  _trackLayer.slider = self;
  [self.layer addSublayer:_trackLayer];
  
  _leftThumbLayer = [GACustomSliderThumbLayer layer];
  _leftThumbLayer.slider = self;
  [self.layer addSublayer:_leftThumbLayer];
  
  _rightThumbLayer = [GACustomSliderThumbLayer layer];
  _rightThumbLayer.slider = self;
  [self.layer addSublayer:_rightThumbLayer];
  
  self.multipleTouchEnabled = YES;
  
  [self setLayerFrames];
}

#pragma mark - Synthesized properties and setters

// Generates custom setters that update the UI when changing  color programmatically
GENERATE_SETTER(trackColor, UIColor *, setTrackColour, redrawLayers)
GENERATE_SETTER(trackHighlightColor, UIColor
                *, setTrackHighlightColor, redrawLayers)
GENERATE_SETTER(thumbColor, UIColor *, setThumbColor, redrawLayers)


// Custom setter for changing the left value;
// Makes sure that invalid values are not accepted and thumb positions are updated accordingly
- (void)setLeftValue:(float)leftValue
{
  if (_leftValue != leftValue) {
    _leftValue = leftValue < _minValue ? _minValue : leftValue;
    _leftValue = BOUND(_leftValue, _rightValue - _minDistance, _minValue);
    [self setLayerFrames];
  }
}

// Custom setter for changing the right value;
// Makes sure that invalid values are not accepted and thumb positions are updated accordingly
- (void)setRightValue:(float)rightValue
{
  if (_rightValue != rightValue) {
    _rightValue = rightValue > _maxValue ? _maxValue : rightValue;
    _rightValue = BOUND(_rightValue, _maxValue, _leftValue + _minDistance);
    [self setLayerFrames];
  }
}

// Custom setter for changing the minimum distance;
// Makes sure that invalid values are not accepted and thumb positions are updated accordingly
-(void)setMinDistance:(float)minDistance
{
  if (_minDistance != minDistance) {
    _minDistance = minDistance < 0 ? 0 : minDistance;
    _minDistance = minDistance > _maxValue - _minValue ? _maxValue - _minValue : minDistance;
    _leftValue = BOUND(_leftValue, _rightValue - _minDistance, _minValue);
    _rightValue = BOUND(_rightValue, _maxValue, _leftValue + _minDistance);
    [self setLayerFrames];
  }
}

#pragma mark - Layout overrides

// Makes sure track and thumbs position is updated when using autolayout
-(void)layoutSubviews
{
  [super layoutSubviews];
  [self setLayerFrames];
}

#pragma mark - Touch events

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
  for (UITouch* touch in touches) {
    // Get location of touch
    CGPoint touchPoint = [touch locationInView:self];
    
    // Test whether touch is within thumb layers and store touch objects if true
    if (CGRectContainsPoint(_rightThumbLayer.frame, touchPoint)) {
      _rightTouch = touch;
      _rightThumbTouchDownPoint = touchPoint;
      [_rightThumbLayer setNeedsDisplay];
    } else if (CGRectContainsPoint(_leftThumbLayer.frame, touchPoint)) {
      _leftTouch = touch;
      _leftThumbTouchDownPoint = touchPoint;
      [_leftThumbLayer setNeedsDisplay];
    }
  }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
  for (UITouch* touch in touches) {
    
    // Get location of touch
    CGPoint touchPoint = [touch locationInView:self];
    
    // Determine distance of drag
    float valueDelta;
    
    if (touch == _rightTouch) {
      float delta = touchPoint.x - _rightThumbTouchDownPoint.x;
      valueDelta = (_maxValue - _minValue) * delta / _useableTrackLength;
      _rightThumbTouchDownPoint = touchPoint;
    } else if (touch == _leftTouch) {
      float delta = touchPoint.x - _leftThumbTouchDownPoint.x;
      valueDelta = (_maxValue - _minValue) * delta / _useableTrackLength;
      _leftThumbTouchDownPoint = touchPoint;
    }
    
    // Update values making sure they are within permisible bounds
    if (touch == _rightTouch) {
      _rightValue += valueDelta;
      _rightValue = BOUND(_rightValue, _maxValue, _leftValue + _minDistance);
    } else if (touch == _leftTouch) {
      _leftValue += valueDelta;
      _leftValue = BOUND(_leftValue, _rightValue - _minDistance, _minValue);
    }
    
    // Update the UI
    [CATransaction begin];
    [CATransaction setDisableActions:YES] ;
    
    [self setLayerFrames];
    
    [CATransaction commit];
    
    [self sendActionsForControlEvents:UIControlEventValueChanged];
  }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
  for (UITouch *touch in touches) {
    // Release touch objects if needed
    if (touch == _rightTouch) {
      _rightTouch = nil;
    } else if (touch == _leftTouch) {
      _leftTouch = nil;
    }
    
    // Update the UI
    [_rightThumbLayer setNeedsDisplay];
    [_leftThumbLayer setNeedsDisplay];
  }
}

#pragma mark - Helpers

// Updates the frames of component's layers
- (void) setLayerFrames
{
  _trackLayer.frame = CGRectInset(self.bounds, 0, self.bounds.size.height / 3.5);
  [_trackLayer setNeedsDisplay];
  
  _useableTrackLength = self.bounds.size.width - _thumbWidth;
  
  float leftThumbCentre = [self positionForValue:_leftValue];
  _leftThumbLayer.frame = CGRectMake(leftThumbCentre - _thumbWidth / 2,
                                      (self.bounds.size.height - _thumbWidth) / 2,
                                      _thumbWidth,
                                      _thumbWidth);
  
  float rightThumbCentre = [self positionForValue:_rightValue];
  _rightThumbLayer.frame = CGRectMake(rightThumbCentre - _thumbWidth / 2,
                                       (self.bounds.size.height - _thumbWidth) / 2,
                                       _thumbWidth,
                                       _thumbWidth);
  
  [_leftThumbLayer setNeedsDisplay];
  [_rightThumbLayer setNeedsDisplay];
}

// Notifies that a UI update is necessary
- (void) redrawLayers
{
  [_rightThumbLayer setNeedsDisplay];
  [_leftThumbLayer setNeedsDisplay];
  [_trackLayer setNeedsDisplay];
}

// Helper method to get the valid position for a given slider value
- (float) positionForValue:(float)value
{
  return _useableTrackLength * (value - _minValue) / (_maxValue - _minValue) + (_thumbWidth / 2);
}

@end
