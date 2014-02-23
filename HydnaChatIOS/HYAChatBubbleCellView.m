//
//  HYAChatBubbleCellView.m
//  HydnaChatIOS
//
//  Created by Isak Wiström on 2/15/14.
//  Copyright (c) 2014 skaggivara. All rights reserved.
//

#import "HYAChatBubbleCellView.h"

@implementation HYAChatBubbleCellView

// add type and left or right
- (id)initWithTextAndMaxWidth:(NSString *)text
                     maxWidth:(int)maxWidth
                        style:(HYAChatBubbleStyle)style
                     position:(HYAChatBubblePosition)position
              reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.text = text;
        self.maxWidth = maxWidth;
        self.style = style;
        self.position = position;
        self.image = nil;
        
        [self build];
    }
    return self;
}

- (id)initWithImage:(UIImage *)image
           maxWidth:(int)maxWidth
           position:(HYAChatBubblePosition)position
    reuseIdentifier:(NSString *)reuseIdentifier
{
    
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.text = @"";
        self.maxWidth = maxWidth;
        self.style = HYAChatBubbleStyleImage;
        self.position = position;
        self.image = image;
        
        [self build];
    }
    
    return self;

}

- (void)updateText:(NSString *)text
             style:(HYAChatBubbleStyle)style
          position:(HYAChatBubblePosition)position
{
    self.text = text;
    self.style = style;
    self.position = position;
    [self build];
}

- (void)updateImage:(UIImage *)image
           position:(HYAChatBubblePosition)position
{
    self.image = image;
    self.style = HYAChatBubbleStyleImage;
    self.position = position;
    [self build];
}

- (void)build
{
    
    CGRect rect;
    int currentMaxWidth = self.maxWidth;
    
    if (self.style == HYAChatBubbleStyleError || self.style == HYAChatBubbleStyleStatus || self.style == HYAChatBubbleStyleTimecode) {
        currentMaxWidth = self.frame.size.width - (kMargin * 2);
    }
    
    // available only on ios7.0 sdk.
    rect = [HYAChatBubbleCellView sizeWithText:self.text maxWidth:currentMaxWidth];
    
    CGRect size = CGRectMake(kMargin + kPaddingLeft, kMargin + kPaddingTop, rect.size.width, rect.size.height + 2);
    
    if (self.style == HYAChatBubbleStyleError || self.style == HYAChatBubbleStyleStatus || self.style == HYAChatBubbleStyleTimecode) {
        size = CGRectMake(kMargin, kMargin, self.frame.size.width - (kMargin * 2), rect.size.height + 2);
    }
    
    UIColor *textColor = [UIColor blackColor];
    UIColor *backgColor = [UIColor colorWithRed:223/255.0 green:222/255.0 blue:229/255.0 alpha:.5];
    UIColor *borderColor = [UIColor lightGrayColor];
    borderColor = [borderColor colorWithAlphaComponent:0.0];
    
    switch(self.style){
        case HYAChatBubbleStyleBubble:
            if (self.position == HYAChatBubblePositionLeft) {
                borderColor = [borderColor colorWithAlphaComponent:0.4];
            } else if(self.position == HYAChatBubblePositionRight) {
                backgColor = [UIColor colorWithRed:0.0 green:127/255.0 blue:1.0 alpha:1.0];
                textColor = [UIColor whiteColor];
            }
            break;
        case HYAChatBubbleStyleError:
            textColor = [UIColor redColor];
            backgColor = [UIColor whiteColor];
            break;
        case HYAChatBubbleStyleStatus:
        case HYAChatBubbleStyleTimecode:
            textColor = [UIColor blackColor];
            backgColor = [UIColor whiteColor];
            break;
        case HYAChatBubbleStyleImage:
            break;
    }
    
    if (!self.textarea) {
        self.textarea = [[UILabel alloc] initWithFrame:size];
    } else {
        self.textarea.frame = size;
    }
    
    self.textarea.font = [UIFont fontWithName:kFont size:kFontSize];
    self.textarea.text = self.text;
    self.textarea.lineBreakMode = NSLineBreakByWordWrapping;
    self.textarea.lineBreakMode = NSLineBreakByTruncatingTail;
    self.textarea.numberOfLines = 0;
    self.textarea.textColor = textColor;
    
    if (self.style == HYAChatBubbleStyleError || self.style == HYAChatBubbleStyleStatus || self.style == HYAChatBubbleStyleTimecode) {
        self.textarea.textAlignment = NSTextAlignmentCenter;
    } else {
        self.textarea.textAlignment = NSTextAlignmentLeft;
    }
    
    [self.textarea setNeedsDisplay];
    
    CGRect backgsize = CGRectMake(kMargin, kMargin, ceil(self.textarea.frame.size.width + (kPaddingLeft + kPaddingRight)), ceil(self.textarea.frame.size.height + (kPaddingTop + kPaddingBottom)));
    
    if (!self.backg) {
        self.backg = [[UIView alloc] initWithFrame:backgsize];
    } else {
        self.backg.frame = backgsize;
    }
    
    self.backg.layer.backgroundColor = [backgColor CGColor];
    self.backg.layer.cornerRadius = kCornerRadius;
    self.backg.layer.borderColor = [borderColor CGColor];
    self.backg.layer.borderWidth = 1;

    if (!self.imageContainer) {
        
        self.imageContainer = [[UIImageView alloc] initWithFrame:CGRectMake(kMargin, kMargin, 1, 1)];
        self.imageContainer.layer.cornerRadius = kCornerRadius;
        self.imageContainer.layer.masksToBounds = YES;
        
        if (self.image) {
            [self.imageContainer setImage:self.image];
            self.imageContainer.frame = CGRectMake(kMargin, kMargin, self.image.size.width, self.image.size.height);
            [self.imageContainer setNeedsDisplay];
        }

    } else {
        [self.imageContainer setImage:self.image];
        self.imageContainer.frame = CGRectMake(kMargin, kMargin, self.image.size.width, self.image.size.height);
        [self.imageContainer setNeedsDisplay];
    }
    
    [self.imageContainer setNeedsDisplay];
    
    if (![self.subviews containsObject:self.textarea]) {
        [self addSubview:self.backg];
        [self addSubview:self.textarea];
        [self addSubview:self.imageContainer];
    }
    
    if (self.style == HYAChatBubbleStyleImage) {
        self.backg.hidden = YES;
        self.textarea.hidden = YES;
        self.imageContainer.hidden = NO;
    } else {
        self.backg.hidden = NO;
        self.textarea.hidden = NO;
        self.imageContainer.hidden = YES;
    }
    
    if (self.style == HYAChatBubbleStyleBubble || self.style == HYAChatBubbleStyleImage) {
        if (self.position == HYAChatBubblePositionLeft) {
            
            self.textarea.frame = CGRectMake(kMargin + kPaddingLeft, self.textarea.frame.origin.y, self.textarea.frame.size.width, self.textarea.frame.size.height);
            self.backg.frame = CGRectMake(kMargin, kMargin, self.backg.frame.size.width, self.backg.frame.size.height);
            self.imageContainer.frame = CGRectMake(kMargin, kMargin, self.imageContainer.frame.size.width, self.self.imageContainer.frame.size.height);
            
        } else {
            
            self.textarea.frame = CGRectMake(self.frame.size.width - (self.textarea.frame.size.width + kMargin + kPaddingRight), self.textarea.frame.origin.y, self.textarea.frame.size.width, self.textarea.frame.size.height);
            
            self.backg.frame = CGRectMake(self.frame.size.width - (self.backg.frame.size.width + kMargin), self.backg.frame.origin.y, self.backg.frame.size.width, self.backg.frame.size.height);
            
            self.imageContainer.frame = CGRectMake(self.frame.size.width - (self.imageContainer.frame.size.width + kMargin), self.imageContainer.frame.origin.y, self.imageContainer.frame.size.width, self.imageContainer.frame.size.height);
        }
    }
    
    [self setNeedsDisplay];
}

+ (int)maxWidth:(int)width
          style:(HYAChatBubbleStyle)style
{
    if (style == HYAChatBubbleStyleError || style == HYAChatBubbleStyleStatus || style == HYAChatBubbleStyleTimecode) {
        return ceil(width - (kMargin * 2));
    }
    return ceil(width - ((kPaddingLeft + kPaddingRight) + (kMargin * 2) + kInset));
}

+ (CGRect)outerSizeWithText:(NSString *)text
                   maxWidth:(int)maxWidth
                      style:(HYAChatBubbleStyle)style
{
    // available only on ios7.0 sdk.
    CGRect rect = [HYAChatBubbleCellView sizeWithText:text maxWidth:maxWidth];
    
    if (style == HYAChatBubbleStyleError || style == HYAChatBubbleStyleStatus || style == HYAChatBubbleStyleTimecode) {
        rect.size.height = ceil(rect.size.height + (kMargin * 2));
    } else {
        rect.size.height = ceil(rect.size.height + ((kMargin * 2) + (kPaddingTop + kPaddingBottom)));
    }
    
    return rect;
}

+ (CGRect)outerSizeWithImage:(UIImage *)img
{
    CGRect rect = CGRectMake(0, 0, img.size.width, img.size.height);
    rect.size.height = ceil(rect.size.height + (kMargin * 2));
    return rect;
}

+ (CGRect)sizeWithText:(NSString *)text
              maxWidth:(int)maxWidth
{
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont fontWithName:kFont size:kFontSize]};
    // NSString class method: boundingRectWithSize:options:attributes:context is
    // available only on ios7.0 sdk.
    CGRect rect = [text boundingRectWithSize:CGSizeMake(maxWidth, MAXFLOAT)
                                          options:NSStringDrawingUsesLineFragmentOrigin
                                       attributes:attributes
                                          context:nil];
    
    return rect;

}

@end