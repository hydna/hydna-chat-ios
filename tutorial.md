# Tutorial: Basic chat application for IOS

In this tutorial we will create a basic chat application for IOS.

If you get stuck, please don't hesitate to contact support@hydna.com.

## Prerequisites

To follow this tutorial and create your own **HydnaChatTutorial** project you need **xcode 5** and **CocoaPods** installed.

## Getting started

This step is optional if you already have a domain.

Before we get our hands dirty you should:

* Sign up for a free account
* Create a free domain

We've used our domain, **tutorials.hydna.net**, in the code below. That won't work for you. Make sure to replace that with the name of the domain you create.

Your domain should not have any behaviors attached to the channel (if you don't know what this means, we're probably good).

## Create the xcode project

Call the app **HydnaChatTutorial** and save it wherever you like.

## Create Podfile and install Hydna

If you haven't installed CocoaPods yet, we suggest you do so now.

Now with CocoaPods installed open your Terminal and go to the directory where you created your app and write:
    
    echo > "pod 'Hydna'" Podfile
    pod install
    open HydnaChatTutorial.xcworkspace

From now on, always open your xcode project with the **HydnaChatTutorial.xcworkspace** file not the **HydnaChatTutorial.xcodeproj** file.

We now have the Hydna library installed and we are ready to proceed.

## Create ChatViewController

This will be a single view application with a ChatViewController displaying a list of chat messages

## Create UITableView and implement delegate methods

## Create input and send btn

## Connect to Hydna

## Conclusion

## Going further

This app is simplified for the purpose of this tutorial. You can find a more polished version of this chat app at xxx. It's supports sending images as well as messages and a more polished interface.

That's it. We hope you've enjoyed this tutorial! Please send an email to support@hydna.com if you've discovered any errors, found a section particularly unclear, or if something went wrong.
