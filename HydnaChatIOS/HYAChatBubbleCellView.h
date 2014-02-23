//
//  HYAChatBubbleCellView.h
//  HydnaChatIOS
//
//  Created by Isak Wiström on 2/15/14.
//  Copyright (c) 2014 skaggivara. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HYAChatBubbleCellView : UITableViewCell

typedef enum {
    
    HYAChatBubbleStyleBubble,
    HYAChatBubbleStyleError,
    HYAChatBubbleStyleStatus,
    HYAChatBubbleStyleImage,
    HYAChatBubbleStyleTimecode
    
} HYAChatBubbleStyle;

typedef enum {
    
    HYAChatBubblePositionLeft,
    HYAChatBubblePositionRight
    
} HYAChatBubblePosition;

@property(nonatomic, assign) NSString *text;
@property(nonatomic, assign) int maxWidth;
@property(nonatomic) UILabel *textarea;
@property(nonatomic) UILabel *time;
@property(nonatomic) UIView *backg;
@property(nonatomic) UIImage *image;
@property(nonatomic) UIImageView *imageContainer;
@property(nonatomic) HYAChatBubbleStyle style;
@property(nonatomic) HYAChatBubblePosition position;

- (id)initWithTextAndMaxWidth:(NSString *)text
                     maxWidth:(int)maxWidth
                        style:(HYAChatBubbleStyle)style
                     position:(HYAChatBubblePosition)position
              reuseIdentifier:(NSString *)reuseIdentifier;

- (id)initWithImage:(UIImage *)image
           maxWidth:(int)maxWidth
           position:(HYAChatBubblePosition)position
    reuseIdentifier:(NSString *)reuseIdentifier;

- (void)updateText:(NSString *)text
             style:(HYAChatBubbleStyle)style
          position:(HYAChatBubblePosition)position;

- (void)updateImage:(UIImage *)image
           position:(HYAChatBubblePosition)position;

+ (CGRect)sizeWithText:(NSString *)text
              maxWidth:(int)maxWidth;

+ (CGRect)outerSizeWithText:(NSString *)text
                   maxWidth:(int)maxWidth
                      style:(HYAChatBubbleStyle)style;

+ (CGRect)outerSizeWithImage:(UIImage *)img;

+ (int)maxWidth:(int)width
          style:(HYAChatBubbleStyle)style;

@end
