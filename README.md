# HydnaChatIOS (example application)

This is an example chat application that demonstrates how to use the hydna Objective-C bindings (https://www.hydna.com).

* Supports text and image messages
* hydna is language agnostic and to demonstrate this there is also a html client included **chat.html** to send and receive messages with.

## Getting Started

Clone the app and install the required pod:

    git clone https://github.com/hydna/hydna-chat-ios.git HydnaChatIOS
    cd HydnaChatIOS
    pod install
    open HydnaChatIOS.xcworkspace

Use **HydnaChatIOS.xcworkspace** to open the project instead of **HydnaChatIOS.xcproject**

## Setup

In **Constants.h** you can change to your own hydna domain for **kHydnaDomain**.

You can get your hydna domain for free at https://www.hydna.com/account/create/

## Requirements

This application requires Xcode 5 and iOS 7.0 or later and [CocoaPods](http://cocoapods.org/) installed. The hydna library works with earlier SDK's.

## License

This software is licensed under the MIT License.

The MIT License (MIT)

Copyright (c) 2013 Livefyre

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
of the Software, and to permit persons to whom the Software is furnished to do
so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
