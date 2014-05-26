//
//  HYAChatViewController.m
//  HydnaChatIOS
//
//  Created by Isak Wiström on 2/15/14.
//  Copyright (c) 2014 skaggivara. All rights reserved.
//

#import "HYAChatViewController.h"
#import "HYAChatBubbleCellView.h"
#import "HYAMessage.h"
#import "HYChannel.h"

@interface HYAChatViewController ()

@end

@implementation HYAChatViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.chatList = [[NSMutableArray alloc] init];
        
        self.me = [[NSUserDefaults standardUserDefaults] objectForKey:@"me"];
        
        self.keyboardFrame = CGRectMake(0, 0, 0, 0);
        
        if (!self.me) {
        
            self.me = [self UUID];
            
            [[NSUserDefaults standardUserDefaults] setObject:self.me forKey:@"me"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
    return self;
}

- (NSString *)UUID;
{
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, theUUID);
    CFRelease(theUUID);
    return (__bridge NSString *)string;
}


- (void)connect
{
    
    if (!self.channel) {

        self.channel = [[HYChannel alloc] init];
        [self.channel setDelegate:self];
        
        @try {
            [self.channel connect:kHydnaDomain mode:READWRITEEMIT token:nil];
        }
        @catch (NSException *exception) {
            [self addTextToChatList:[NSString stringWithFormat:@"Error: %@", exception.reason] user:self.me style:HYAChatBubbleStyleError];
        }
    }
}

- (void)disconnect
{
    if (self.channel) {
        
        [self.channel setDelegate:nil];
        [self.channel close];
    
        self.channel = nil;
    }
}

- (void)showReconnect
{
    if (!self.reconnect_btn) {
        self.reconnect_btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.reconnect_btn setFrame:CGRectMake(40, (self.view.frame.size.height * .5) - 26, self.view.frame.size.width - 80, 52)];
        self.reconnect_btn.layer.cornerRadius = 5.0;
        [self.reconnect_btn setTitle:@"Touch to connect" forState:UIControlStateNormal];
        [self.reconnect_btn setBackgroundColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0]];
        [self.reconnect_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.reconnect_btn addTarget:self action:@selector(handleReconnect) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:self.reconnect_btn];
    }
    
    [self.reconnect_btn setEnabled:YES];
    self.reconnect_btn.alpha = 0.0;
    self.reconnect_btn.transform = CGAffineTransformMakeScale(0.5, 0.5);
    
    [UIView animateWithDuration:0.2 animations:^{
        self.reconnect_btn.alpha = 1.0;
        self.reconnect_btn.transform = CGAffineTransformMakeScale(1.0, 1.0);
    }];
}

- (void)hideReconnect
{
    if (self.reconnect_btn) {
        
        [UIView animateWithDuration:0.2 animations:^{
            self.reconnect_btn.alpha = 0.0;
            self.reconnect_btn.transform = CGAffineTransformMakeScale(0.5, 0.5);
        }];
        
        [self.reconnect_btn setEnabled:NO];
    }
}

- (void)handleReconnect
{
    
    [self hideReconnect];
    
    if (self.channel) {
        
        [self.channel setDelegate:nil];
        self.channel = nil;
    }
    
    [self connect];
    
    [self.loader startAnimating];
}

- (void)channelOpen:(HYChannel *)sender
            message:(NSString *)message
{
    [self.loader stopAnimating];
    
    [self addTextToChatList:[NSString stringWithFormat:@"Connected to hydna domain '%@' Let's chat!", kHydnaDomain] user:self.me style:HYAChatBubbleStyleStatus];
 
    [self hideReconnect];
    
    [self.chatInput enable];

}

- (void)channelMessage:(HYChannel *)sender
                  data:(HYChannelData *)data
{
    
    NSData *payload = [data content];

    if ([data isUtf8Content]) {
        NSString *message = [[ NSString alloc ] initWithData:payload encoding:NSUTF8StringEncoding];

        HYAMessage * msg = [HYAMessage fromJSON:message];
            
        if (msg) {
            if (msg.type == HYAMessageTypeMessage) {
                [self addTextToChatList:msg.text user:msg.user style:HYAChatBubbleStyleBubble];
            } else if (msg.type == HYAMessageTypeImage) {
                [self addImageToChatList:msg.image user:msg.user];
            }
        }
    }
}

- (void)channelSignal:(HYChannel *)sender
                 data:(HYChannelSignal *)data
{
    
    NSData *payload = [data content];
    
    if ([data isUtf8Content]) {
        NSString *message = [[ NSString alloc ] initWithData:payload encoding:NSUTF8StringEncoding];
        NSLog(@"signal received: %@", message);
    }
}

- (void)channelClose:(HYChannel *)sender
               error:(HYChannelError *)error
{
    if (error.wasDenied) {
        [self addTextToChatList:[NSString stringWithFormat:@"Connection to hydna was denied: %@", error.reason] user:self.me style:HYAChatBubbleStyleStatus];
    } else if (error.wasClean) {
        [self addTextToChatList:@"Connection closed by user!" user:self.me style:HYAChatBubbleStyleStatus];
    } else {
        [self addTextToChatList:[NSString stringWithFormat:@"Error: %@", error.reason] user:self.me style:HYAChatBubbleStyleError];
    }
    
    [self showReconnect];
    [self.chatInput disable];
}

- (void)addTextToChatList:(NSString *)text
                     user:(NSString *)user
                    style:(HYAChatBubbleStyle)style
{
    
    HYAChatBubblePosition position = HYAChatBubblePositionRight;
    
    if ([user isEqualToString:self.me]) {
        position = HYAChatBubblePositionLeft;
    }
    
    HYAMessage *message = [HYAMessage withText:text user:user style:style position:position];
    
    [self.chatList addObject:message];
    [self.chatTable reloadData];
    
    [self scrollToBottom];
}

- (void)addImageToChatList:(UIImage *)image
                      user:(NSString *)user
{
    
    HYAChatBubblePosition position = HYAChatBubblePositionRight;
    
    if ([user isEqualToString:self.me]) {
        position = HYAChatBubblePositionLeft;
    }
    
    HYAMessage *message = [HYAMessage withImage:image user:user position:position];
    
    [self.chatList addObject:message];
    [self.chatTable reloadData];
    
    [self scrollToBottom];
    
}

- (void)scrollToBottom
{
    if (self.chatList.count > 0) {
        NSIndexPath *ipath = [NSIndexPath indexPathForRow: self.chatList.count-1 inSection: 0];
        [self.chatTable scrollToRowAtIndexPath: ipath atScrollPosition: UITableViewScrollPositionTop animated: YES];
    }
}

- (void)loadView
{
    
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    [self setTitle:@"Hydna Chat"];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.chatTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 44)];
    self.chatTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.chatTable setDelegate:self];
    [self.chatTable setDataSource:self];
    [self.view addSubview:self.chatTable];
    
    self.chatInput = [[HYAChatInputView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 44, self.view.bounds.size.width, 44)];
    [self.chatInput setDelegate:self];
    [self.chatInput disable];
    [self.view addSubview:self.chatInput];
    
    self.loader = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.loader.center = CGPointMake(self.view.frame.size.width * .5, self.view.frame.size.height * .5);
    self.loader.hidesWhenStopped = YES;
    [self.loader startAnimating];
    
    [self.view addSubview:self.loader];
    
}

// Called before the user changes the selection. Return a new indexPath, or nil, to change the proposed selection.
- (NSIndexPath *)tableView:(UITableView *)tableView
  willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.selectionStyle == UITableViewCellSelectionStyleNone) {
        return nil;
    }
    return indexPath;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [self.chatList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"HYAChatBubbleCell";
    
    HYAChatBubbleCellView *cell = (HYAChatBubbleCellView *)[self.chatTable dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    HYAMessage *item = [self.chatList objectAtIndex:indexPath.row];
    HYAChatBubbleStyle style = item.style;
    
    NSString *message = @"";
    UIImage *image;
    
    if (style != HYAChatBubbleStyleImage) {
        message = item.text;
    } else {
        image = item.image;
    }
    
    if (cell == nil) {
        
        if (style == HYAChatBubbleStyleImage) {
            cell = [[HYAChatBubbleCellView alloc] initWithImage:image
                                                       maxWidth:[HYAChatBubbleCellView maxWidth:self.view.frame.size.width style:item.style]
                                                       position:item.position
                                                reuseIdentifier:CellIdentifier];
        } else {
            cell = [[HYAChatBubbleCellView alloc] initWithTextAndMaxWidth:message
                                                                 maxWidth:[HYAChatBubbleCellView
                                                                    maxWidth:self.view.frame.size.width style:item.style]
                                                                    style:style
                                                                 position:item.position
                                                          reuseIdentifier:CellIdentifier];
        }
        
        if (style != HYAChatBubbleStyleStatus && style != HYAChatBubbleStyleError) {
            cell.transform = CGAffineTransformMakeScale(.1, .1);
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.alpha = 0;
        
        [UIView animateWithDuration:0.3 animations:^{
            cell.alpha = 1.0; cell.transform = CGAffineTransformMakeScale(1.0, 1.0);
        }];
        
    } else {
        
        if (style == HYAChatBubbleStyleImage) {
            [cell updateImage:image position:item.position];
        } else {
            [cell updateText:message style:style position:item.position];
        }
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.chatList count] > indexPath.row) {
        
        HYAMessage *item = [self.chatList objectAtIndex:indexPath.row];
        
        if (item.style == HYAChatBubbleStyleImage) {
            UIImage *img = item.image;
            return [HYAChatBubbleCellView outerSizeWithImage:img].size.height;
        }
        
        return [HYAChatBubbleCellView outerSizeWithText:item.text maxWidth:[HYAChatBubbleCellView maxWidth:self.view.frame.size.width style:item.style] style:item.style].size.height;
    }
    
    return 0.0;
}

- (void)sizeChanged:(HYAChatInputView *)sender
{
    BOOL animated = YES;
    
    [UIView animateWithDuration:(animated ? .1f : 0) animations:^
     {
         self.chatInput.frame = CGRectMake(0, self.view.bounds.size.height - (self.keyboardFrame.size.height + [self.chatInput outerHeight]), self.view.bounds.size.width, [self.chatInput outerHeight]);
         
     } completion:nil];
    
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    
    NSDictionary *userInfo = [notification userInfo];
	CGRect keyboardFrame = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    UIViewAnimationCurve animationCurve = [userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    self.keyboardFrame = keyboardFrame;
    
    [UIView animateWithDuration:duration delay:0.0 options:(animationCurve << 16) animations:^{
        
        self.chatInput.frame = CGRectMake(0, self.view.bounds.size.height - (self.keyboardFrame.size.height + [self.chatInput outerHeight]), self.view.bounds.size.width, [self.chatInput outerHeight]);
        
        self.chatTable.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - ([self.chatInput outerHeight] + self.keyboardFrame.size.height));
        
    } completion:nil];
    
    [self scrollToBottom];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    
    NSDictionary *userInfo = [notification userInfo];
    
    UIViewAnimationCurve animationCurve = [userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    self.keyboardFrame = CGRectMake(0, 0, 0, 0);
    
    [UIView animateWithDuration:duration delay:0.0 options:(animationCurve << 16) animations:^{
        // Set the new properties to be animated here
        self.chatInput.frame = CGRectMake(0, self.view.bounds.size.height - (self.keyboardFrame.size.height + [self.chatInput outerHeight]), self.view.bounds.size.width, [self.chatInput outerHeight]);
        
        self.chatTable.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 44);
        
    } completion:nil];
    
}

- (void)cameraTouched:(HYAChatInputView *)sender
{
    
    UIActionSheet *imageOptions = [[UIActionSheet alloc] initWithTitle:@"Send image from" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera", @"Image library", nil];
    
    [imageOptions showInView:self.view];
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    UIImagePickerControllerSourceType pickType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    BOOL pickImage = YES;
    
    switch (buttonIndex){
        case 0:
            pickType = UIImagePickerControllerSourceTypeCamera;
        break;
            
        case 1:
            pickType = UIImagePickerControllerSourceTypePhotoLibrary;
        break;
            
        case 2:
            pickImage = NO;
        break;
        
        default:
        break;
    }
    
    if (pickImage) {
        
        self.image_picker = [[UIImagePickerController alloc] init];
        [self.image_picker setDelegate:self];
    
        if (![UIImagePickerController isSourceTypeAvailable:pickType]) {
            pickType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
    
        if (pickType == UIImagePickerControllerSourceTypeCamera) {
            self.image_picker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
            self.image_picker.showsCameraControls = NO;
        }
    
        [self.image_picker setSourceType:pickType];
    
        [self presentViewController:self.image_picker animated:YES completion:nil];
    }
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    UIImage *img = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    if (img) {
        
        int maxsize = kMaxImageSize;
        
        int image_w = img.size.width;
        int image_h = img.size.height;
        
        float scale = 1.0;
        
        if (image_w > maxsize || image_h > maxsize) {
            
            if (image_w >= image_h) {
                scale = (float)maxsize / image_w;
            } else {
                scale = (float)maxsize / image_h;
            }
        }
        
        UIImage *compressed = [self compressForSending:img scale:scale];
        
        if ([self.channel isConnected]) {
        
            HYAMessage *msg = [HYAMessage withImage:compressed user:self.me position:HYAChatBubblePositionLeft];
            
            if (msg) {
                
                NSString *payload = [msg toJSON];
                
                if ([payload lengthOfBytesUsingEncoding:NSUTF8StringEncoding] < PAYLOAD_MAX_LIMIT) {
                    [self.channel writeString:payload];
                } else {
                    NSLog(@"Package to large to send at: %i bytes", (int)[payload lengthOfBytesUsingEncoding:NSUTF8StringEncoding]);
                }
            }
        }
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)textEntered:(HYAChatInputView *)sender text:(NSString *)text
{
    if ([self.channel isConnected] && [text length] > 0) {
        
        HYAMessage *msg = [HYAMessage withText:text user:self.me style:HYAChatBubbleStyleBubble position:HYAChatBubblePositionRight];
        
        NSString *json = [msg toJSON];
        
        if (json) {
            @try {
                [self.channel writeString:[msg toJSON]];
            }
            @catch (NSException *exception) {
                NSLog(@"Error:%@", exception.reason);
            }
        }
    }
}

- (UIImage *)compressForSending:(UIImage *)original
                          scale:(CGFloat)scale
{
    // Calculate new size given scale factor.
    CGSize originalSize = original.size;
    CGSize newSize = CGSizeMake(originalSize.width * scale, originalSize.height * scale);
    
    // Scale the original image to match the new size.
    UIGraphicsBeginImageContext(newSize);
    [original drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage* compressedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return compressedImage;
}

- (void)didTapOnTableView:(UIGestureRecognizer *)recognizer
{
   [self.chatInput resign];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self connect];
}

- (void)handleConnect
{
    if (self.channel) {
        if (![self.channel isConnected]) {
            
            [self.channel setDelegate:nil];
            
            self.channel = [[HYChannel alloc] init];
            [self.channel setDelegate:self];
            
            @try {
                [self.channel connect:kHydnaDomain mode:READWRITE token:nil];
            }
            @catch (NSException *exception) {
                NSLog(@"Error:%@", exception.reason);
            }
        }
    }
}

- (void)handleDisconnect
{
    if ([self.channel isConnected]) {
        [self.channel close];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapOnTableView:)];
    [self.chatTable addGestureRecognizer:tap];
    
    if (kEnableDisconnect > 0){
        UIBarButtonItem *disconnect_btn = [[UIBarButtonItem alloc]
                                           initWithTitle:@"Disconnect"
                                           style:UIBarButtonItemStyleBordered
                                           target:self
                                           action:@selector(handleDisconnect)];
        
        [self.navigationItem setRightBarButtonItem:disconnect_btn animated:NO];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
