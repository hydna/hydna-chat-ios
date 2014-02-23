//
//  HYAMessage.m
//  HydnaChatIOS
//
//  Created by Isak Wiström on 2/18/14.
//  Copyright (c) 2014 skaggivara. All rights reserved.
//

#import "HYAMessage.h"

@implementation HYAMessage

@synthesize text = _text;
@synthesize type = _type;
@synthesize image = _image;

- (id)initWithText:(NSString *)text
              user:(NSString *)user
             style:(HYAChatBubbleStyle)style
          position:(HYAChatBubblePosition)position
{
     self = [super init];
     if (self) {

         self.text = text;
         self.user = user;
         self.type = HYAMessageTypeMessage;
         self.image = nil;
         self.position = position;
         self.style = style;
     }
     return self;
}

- (id)initWithImage:(UIImage *)image
               user:(NSString *)user
           position:(HYAChatBubblePosition)position
{
    self = [super init];
    if (self) {
        self.text = @"";
        self.user = user;
        self.type = HYAMessageTypeImage;
        self.image = image;
        self.position = position;
        self.style = HYAChatBubbleStyleImage;
    }
    return self;
}

+ (HYAMessage *)withText:(NSString *)text
                    user:(NSString *)user
                   style:(HYAChatBubbleStyle)style
                position:(HYAChatBubblePosition)position
{
    return [[HYAMessage alloc] initWithText:text user:user style:style position:position];
}

+ (HYAMessage *)withImage:(UIImage *)image
                     user:(NSString *)user
                position:(HYAChatBubblePosition)position
{
    return [[HYAMessage alloc] initWithImage:image user:user position:position];
}

- (NSString *)toJSON
{
    NSError *error;
    
    NSArray *keys = [[NSArray alloc] initWithObjects:@"usr", @"type", @"data", nil];
    
    NSString *payload = @"";
    
    if (self.type == HYAMessageTypeMessage) {
        
        payload = self.text;
        
    } else if(self.type == HYAMessageTypeImage) {
        
        @try {
            payload = [UIImageJPEGRepresentation(self.image, 0.75) base64EncodedStringWithOptions:NSDataBase64Encoding76CharacterLineLength];
            
        }
        @catch (NSException *exception) {
            NSLog(@"Could not encode img: %@", exception.reason);
        }
    }
    
    NSArray *details = [[NSArray alloc] initWithObjects:self.user, [NSNumber numberWithInt:self.type], payload, nil];
    
    if ([keys count] != [details count]) {
        return nil;
    }
    
    NSDictionary *msg = [[NSDictionary alloc] initWithObjects:details forKeys:keys];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:msg
                                                       options:0 // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    
    if (error) {
        return nil;
    }
    
    if (!jsonData) {
        return nil;
    }
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

+ (HYAMessage *)fromJSON:(NSString *)json
{
    NSError *parse_error;
    
    NSDictionary *data = [NSJSONSerialization JSONObjectWithData: [json dataUsingEncoding:NSUTF8StringEncoding]
                                                         options: NSJSONReadingMutableContainers
                                                           error: &parse_error];
    if (parse_error) {
        return nil;
    }
    
    HYAMessage *msg;
    
    if ([data objectForKey:@"type"] && [data objectForKey:@"usr"] && [data objectForKey:@"data"]) {
    
        int type = [[data objectForKey:@"type"]intValue];
    
        NSString *user = [data objectForKey:@"usr"];
    
        NSString *message = [data objectForKey:@"data"];
    
        if (type == HYAMessageTypeMessage) {
            
            msg = [HYAMessage withText:message user:user style:HYAChatBubbleStyleBubble position:HYAChatBubblePositionRight];
            
        } else if(type == HYAMessageTypeImage) {
            
            @try {
                
                NSData *data = [[NSData alloc]initWithBase64EncodedString:message options:NSDataBase64DecodingIgnoreUnknownCharacters];
                UIImage *img = [UIImage imageWithData:data];
            
                msg = [HYAMessage withImage:img user:user position:HYAChatBubblePositionRight];
            }
            @catch (NSException *e) {
                NSLog(@"error parsing image data: %@", e.reason);
            }
        }
    }
    
    return msg;
}


@end