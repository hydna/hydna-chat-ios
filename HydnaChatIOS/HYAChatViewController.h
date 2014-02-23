//
//  HYAChatViewController.h
//  HydnaChatIOS
//
//  Created by Isak Wiström on 2/15/14.
//  Copyright (c) 2014 skaggivara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYChannel.h"
#import "HYAMessage.h"
#import "HYAChatInputView.h"

@interface HYAChatViewController : UIViewController <HYChannelDelegate, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, HYAChatInputDelegate>

@property(nonatomic, strong) HYChannel *channel;
@property(nonatomic, strong) UITableView *chatTable;
@property(nonatomic, strong) NSMutableArray *chatList;
@property(nonatomic, strong) HYAChatInputView *chatInput;
@property(nonatomic, strong) UIImagePickerController *imagePicker;
@property(nonatomic, strong) UIActivityIndicatorView *loader;
@property(nonatomic, strong) NSString *me;
@property(nonatomic) CGRect keyboardFrame;

- (UIImage *)compressForSending:(UIImage *)original
                          scale:(CGFloat)scale;

-(void)addImageToChatList:(UIImage *)image
                     user:(NSString *)user;

-(void)addTextToChatList:(NSString *)text
                    user:(NSString *)user
                   style:(HYAChatBubbleStyle)style;

- (NSString *)UUID;

@end
