//
//  Constants.h
//  HydnaChatIOS
//
//  Created by Isak Wiström on 2/17/14.
//  Copyright (c) 2014 skaggivara. All rights reserved.
//

#ifndef HydnaChatIOS_Constants_h
#define HydnaChatIOS_Constants_h

#define IS_IPHONE5 (([[UIScreen mainScreen] bounds].size.height-568)?NO:YES)
#define IS_OS_5_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0)
#define IS_OS_6_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
#define IS_OS_7_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)

// Change the following to your own domain
#define kHydnaDomain @"ioschatexample.hydna.net"

#define kFont @"HelveticaNeue"
#define kFontSize 15
#define kCornerRadius 15
#define kPaddingTop 6.0
#define kPaddingLeft 12.0
#define kPaddingRight 12.0
#define kPaddingBottom 7.0
#define kMargin 8.0
#define kInset 80.0
#define kCameraIcon @"camera-icon.png"
#define kInputLimit 140
#define kMaxImageSize 224

#endif
