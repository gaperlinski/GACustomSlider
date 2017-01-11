//
//  GACustomSlider.h
//  Pods
//
//  Created by Grzegorz Aperliński on 09.01.2017.
//
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE

NS_ASSUME_NONNULL_BEGIN

@interface GACustomSlider : UIControl

/// The value expressed by the left thumb.
@property (nonatomic) IBInspectable float leftValue;

/// The value expressed by the right thumb.
@property (nonatomic) IBInspectable float rightValue;

/// The minimum permissible distance between the left and right thumb.
@property (nonatomic) IBInspectable float minDistance;

/// The color of the slider track.
@property (nonatomic, nonnull) IBInspectable UIColor *trackColor;

/// The color of the highlighted portion of the track between the left and right thumb.
@property (nonatomic, nonnull) IBInspectable UIColor *trackHighlightColor;
/// The color of the left and right thumb.
@property (nonatomic, nonnull) IBInspectable UIColor *thumbColor;

/*!
 @brief Returns the position on the slider for given value.
 
 @param value The value between minValue and maxValue to obtain the position for.
 
 @return float The proportionate position on the slider for the value.
 */
- (float) positionForValue:(float)value;

@end

NS_ASSUME_NONNULL_END
