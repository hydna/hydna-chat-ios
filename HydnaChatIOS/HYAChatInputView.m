//
//  HYAChatInputView.m
//  HydnaChatIOS
//
//  Created by Isak Wiström on 2/15/14.
//  Copyright (c) 2014 skaggivara. All rights reserved.
//

#import "HYAChatInputView.h"

#define PADDING 10.0
#define MARGIN 5.0
#define SUBMIT_SIZE 44.0
#define IMG_ICON_W 25.0
#define IMG_ICON_H 19.0
#define BAR_HEIGHT 44
#define FONT_SIZE 15

@implementation HYAChatInputView

@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self build];
    }
    return self;
}

-(void)build
{
    self.backg = [[UIView alloc] initWithFrame:CGRectMake(-1, 0, self.frame.size.width + 2, self.frame.size.height + 1)];
    self.backg.backgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1.0];
    self.backg.layer.borderColor = [[UIColor colorWithRed:214/255.0 green:214/255.0 blue:214/255.0 alpha:1.0] CGColor];
    self.backg.layer.borderWidth = 1;
    [self.backg setNeedsDisplay];
    
    UIImage *imgButtonImage = [UIImage imageNamed:kCameraIcon];
    
    self.img = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.img setTitle:@"" forState:UIControlStateNormal];
    [self.img setBackgroundImage:imgButtonImage forState:UIControlStateNormal];
    self.submit.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    self.submit.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self.img setFrame:CGRectMake(PADDING, PADDING + 2, IMG_ICON_W, IMG_ICON_H)];
    [self.img addTarget:self action:@selector(handleImg) forControlEvents:UIControlEventTouchUpInside];
    
    self.imgstarty = self.img.frame.origin.y;
    
    self.inputbackg = [[UIView alloc] initWithFrame:CGRectMake(PADDING + IMG_ICON_W + PADDING, PADDING, self.bounds.size.width - ((PADDING * 2) + MARGIN + SUBMIT_SIZE + IMG_ICON_W + PADDING), self.bounds.size.height - (PADDING * 2))];
    self.inputbackg.layer.borderColor = self.backg.layer.borderColor;
    self.inputbackg.layer.borderWidth = 1;
    self.inputbackg.layer.cornerRadius = 5;
    self.inputbackg.backgroundColor = [UIColor whiteColor];
    [self.inputbackg setNeedsDisplay];
    
    UIEdgeInsets insets = { .left = 3, .right = 0, .top = -5, .bottom = -4 };
    
    self.input = [[UITextView alloc] initWithFrame:self.inputbackg.frame];
    self.input.contentInset = insets;
    self.input.showsVerticalScrollIndicator = NO;
    self.input.showsHorizontalScrollIndicator = NO;
	self.input.font = [UIFont systemFontOfSize:FONT_SIZE];
    self.input.backgroundColor = [UIColor clearColor];;
    [self.input setDelegate:self];
    
    self.placeholder = [[UILabel alloc] initWithFrame:CGRectMake(self.inputbackg.frame.origin.x + 5, self.inputbackg.frame.origin.y, self.inputbackg.frame.size.width - 4, self.inputbackg.frame.size.height)];
    self.placeholder.text = @"Chat message";
    self.placeholder.font = [UIFont systemFontOfSize:15.0f];
    self.placeholder.textColor = [UIColor colorWithCGColor:self.backg.layer.borderColor];
    
    self.submit = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.submit.titleLabel.font = [UIFont boldSystemFontOfSize:FONT_SIZE];
    self.submit.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    self.submit.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self.submit setTitle:@"Send" forState:UIControlStateNormal];
    [self.submit setFrame:CGRectMake(self.bounds.size.width -(SUBMIT_SIZE + PADDING + MARGIN), 0, SUBMIT_SIZE + PADDING + MARGIN, self.bounds.size.height)];
    [self.submit addTarget:self action:@selector(handleSubmit) forControlEvents:UIControlEventTouchUpInside];
    
    self.submitstarty = self.submit.frame.origin.y;
    
    [self addSubview:self.backg];
    [self addSubview:self.inputbackg];
    [self addSubview:self.placeholder];
    [self addSubview:self.img];
    [self addSubview:self.input];
    [self addSubview:self.submit];
    
    self.inputsize = self.input.frame;
    
    self.onelineheight = [self measureHeightOfUITextView:self.input];
    
    [self adjustTextInputHeightForText:self.input.text animated:NO];
    
}

- (void)disable
{
    [self.submit setEnabled:NO];
    [self.img setEnabled:NO];
    self.input.editable = NO;
}

- (void)enable
{
    [self.submit setEnabled:YES];
    [self.img setEnabled:YES];
    self.input.editable = YES;
}

- (void)adjustTextInputHeightForText:(NSString*)text animated:(BOOL)animated
{

    CGRect textframe = CGRectMake(self.input.frame.origin.x, self.input.frame.origin.y, self.input.frame.size.width, [self measureHeightOfUITextView:self.input]);
    
    if (textframe.size.height <= self.onelineheight) {
        textframe = CGRectMake(self.input.frame.origin.x, self.input.frame.origin.y, self.input.frame.size.width, self.inputsize.size.height);
    }
    
    float heightDiff = 0;
    
    if (textframe.size.height > self.inputsize.size.height) {
        heightDiff = textframe.size.height - self.inputsize.size.height;
        [UIView animateWithDuration:(animated ? .1f : 0) animations:^
         {
             self.input.frame = CGRectMake(self.input.frame.origin.x, self.inputsize.origin.y, self.input.frame.size.width, textframe.size.height);
             self.inputbackg.frame = self.input.frame;
        
             self.backg.frame = CGRectMake(-1, 0, self.backg.frame.size.width, (BAR_HEIGHT + heightDiff) + 1);
             
             self.img.frame = CGRectMake(self.img.frame.origin.x, self.imgstarty + heightDiff, self.img.frame.size.width, self.img.frame.size.height);
             
             self.submit.frame = CGRectMake(self.submit.frame.origin.x, self.submitstarty + heightDiff, self.submit.frame.size.width, self.submit.frame.size.height);
             
         } completion:nil];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(sizeChanged:)]) {
            [self.delegate sizeChanged:self];
        }

    } else if (textframe.size.height <= self.inputsize.size.height) {
        
        self.input.frame = self.inputsize;
        self.inputbackg.frame = self.input.frame;
        
        self.backg.frame = CGRectMake(-1, 0, self.backg.frame.size.width, BAR_HEIGHT);
        
        self.img.frame = CGRectMake(self.img.frame.origin.x, self.imgstarty, self.img.frame.size.width, self.img.frame.size.height);
        
        self.submit.frame = CGRectMake(self.submit.frame.origin.x, self.submitstarty, self.submit.frame.size.width, self.submit.frame.size.height);
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(sizeChanged:)]) {
            [self.delegate sizeChanged:self];
        }
    }
}

- (CGFloat)measureHeightOfUITextView:(UITextView *)textView
{
    if ([textView respondsToSelector:@selector(snapshotViewAfterScreenUpdates:)])
    {
        // This is the code for iOS 7. contentSize no longer returns the correct value, so
        // we have to calculate it.
        //
        // This is partly borrowed from HPGrowingTextView, but I've replaced the
        // magic fudge factors with the calculated values (having worked out where
        // they came from)
        
        CGRect frame = textView.bounds;
        
        // Take account of the padding added around the text.
        
        UIEdgeInsets textContainerInsets = textView.textContainerInset;
        UIEdgeInsets contentInsets = textView.contentInset;
        
        CGFloat leftRightPadding = textContainerInsets.left + textContainerInsets.right + textView.textContainer.lineFragmentPadding * 2 + contentInsets.left + contentInsets.right;
        CGFloat topBottomPadding = textContainerInsets.top + textContainerInsets.bottom + contentInsets.top + contentInsets.bottom;
        
        frame.size.width -= leftRightPadding;
        frame.size.height -= topBottomPadding;
        
        NSString *textToMeasure = textView.text;
        if ([textToMeasure hasSuffix:@"\n"]) {
            textToMeasure = [NSString stringWithFormat:@"%@-", textView.text];
        }
        
        // NSString class method: boundingRectWithSize:options:attributes:context is
        // available only on ios7.0 sdk.
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineBreakMode:NSLineBreakByWordWrapping];
        
        NSDictionary *attributes = @{ NSFontAttributeName: textView.font, NSParagraphStyleAttributeName : paragraphStyle };
        
        CGRect size = [textToMeasure boundingRectWithSize:CGSizeMake(CGRectGetWidth(frame), MAXFLOAT)
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                               attributes:attributes
                                                  context:nil];
        
        CGFloat measuredHeight = ceilf(CGRectGetHeight(size) + topBottomPadding);
        return measuredHeight;
        
    } else {
        return textView.contentSize.height;
    }
}

-(void)handleSubmit
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(textEntered:text:)]) {
        [self.delegate textEntered:self text:self.input.text];
    }
    
    [self clear];
}

- (void)handleImg
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(cameraTouched:)]) {
        [self.delegate cameraTouched:self];
    }
}

- (void)resign
{
    [self.input resignFirstResponder];
}

- (int)outerHeight
{
    return self.backg.frame.size.height;
}

- (void)textViewDidChange:(UITextView *)textView
{
    if ([self.input.text length] == 0) {
        self.placeholder.hidden = NO;
    } else {
        self.placeholder.hidden = YES;
    }
    
    [self adjustTextInputHeightForText:self.input.text animated:YES];
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(focusField:)]) {
        [self.delegate focusField:self];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([self.input.text length] == 0) {
        self.placeholder.hidden = NO;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(blurField:)]) {
        [self.delegate blurField:self];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if( ([self.input.text length] + text.length) < kInputLimit){
        return YES;
    }
    return NO;
}

-(void)clear
{
    self.input.text = @"";
    self.placeholder.hidden = NO;
    [self adjustTextInputHeightForText:self.input.text animated:YES];
}

@end
