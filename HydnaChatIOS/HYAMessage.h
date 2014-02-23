//
//  HYAMessage.h
//  HydnaChatIOS
//
//  Created by Isak Wiström on 2/18/14.
//  Copyright (c) 2014 skaggivara. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HYAChatBubbleCellView.h"

@interface HYAMessage : NSObject

typedef enum {
    
    HYAMessageTypeMessage,
    HYAMessageTypeImage
    
} HYAMessageType;

@property(nonatomic) NSString *text;
@property(nonatomic) NSString *user;
@property(nonatomic) int type;
@property(nonatomic) UIImage *image;
@property(nonatomic) HYAChatBubbleStyle style;
@property(nonatomic) HYAChatBubblePosition position;

- (id)initWithText:(NSString *)text
              user:(NSString *)user
             style:(HYAChatBubbleStyle)style
          position:(HYAChatBubblePosition)position;

- (id)initWithImage:(UIImage *)image
               user:(NSString *)user
           position:(HYAChatBubblePosition)position;

- (NSString *)toJSON;

+ (HYAMessage *)withText:(NSString *)text
                    user:(NSString *)user
                   style:(HYAChatBubbleStyle)style
                position:(HYAChatBubblePosition)position;

+ (HYAMessage *)withImage:(UIImage *)image
                     user:(NSString *)user
                 position:(HYAChatBubblePosition)position;

+ (HYAMessage *)fromJSON:(NSString *)json;

@end
