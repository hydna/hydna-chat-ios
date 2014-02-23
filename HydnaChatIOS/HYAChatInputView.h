//
//  HYAChatInputView.h
//  HydnaChatIOS
//
//  Created by Isak Wiström on 2/15/14.
//  Copyright (c) 2014 skaggivara. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HYAChatInputView;

@protocol HYAChatInputDelegate <NSObject>
@optional
- (void)focusField:(HYAChatInputView *)sender;
- (void)blurField:(HYAChatInputView *)sender;
- (void)textEntered:(HYAChatInputView *)sender
               text:(NSString *)text;
- (void)sizeChanged:(HYAChatInputView *)sender;
- (void)cameraTouched:(HYAChatInputView *)sender;
@end

@interface HYAChatInputView : UIView <UITextViewDelegate>

@property(nonatomic,strong) UITextView *input;
@property(nonatomic,strong) UIButton *submit;
@property(nonatomic,strong) UIButton *img;
@property(nonatomic,strong) UILabel *placeholder;
@property(nonatomic,strong) UIView *inputbackg;
@property(nonatomic,strong) UIView *backg;
@property(nonatomic) float onelineheight;
@property(nonatomic) float imgstarty;
@property(nonatomic) float submitstarty;
@property(nonatomic) CGRect inputsize;

@property(nonatomic, weak) NSObject <HYAChatInputDelegate> *delegate;

- (void)resign;
- (void)clear;
- (int)outerHeight;
- (void)disable;
- (void)enable;

@end
