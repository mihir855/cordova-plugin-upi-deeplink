#import <Cordova/CDVPlugin.h>
#import <UIKit/UIKit.h>
#import "UPILinkPlugin.h"

@implementation UPILinkPlugin

// JS will call: cordova.exec(successCb, errorCb, "UPILinkPlugin", "open", [url]);
- (void)open:(CDVInvokedUrlCommand*)command {
    NSLog(@"[UPILinkPlugin] open() called");

    if (command.arguments.count == 0) {
        NSLog(@"[UPILinkPlugin] ERROR: No URL received");
        CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
                                                    messageAsString:@"No URL provided"];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
        return;
    }

    NSString *urlStr = [command.arguments objectAtIndex:0];
    NSLog(@"[UPILinkPlugin] Received URL: %@", urlStr);

    NSURL *url = [NSURL URLWithString:urlStr];
    if (!url) {
        NSLog(@"[UPILinkPlugin] ERROR: Invalid URL string");
        CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
                                                    messageAsString:@"Invalid URL"];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
        return;
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        UIApplication *application = [UIApplication sharedApplication];
        BOOL canOpen = [application canOpenURL:url];
        NSLog(@"[UPILinkPlugin] canOpenURL? %@", canOpen ? @"YES" : @"NO");

        if (canOpen) {
            if (@available(iOS 10.0, *)) {
                [application openURL:url options:@{} completionHandler:^(BOOL success) {
                    NSLog(@"[UPILinkPlugin] openURL success? %@", success ? @"YES" : @"NO");
                    if (success) {
                        CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                                                    messageAsString:@"Opened UPI app"];
                        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
                    } else {
                        CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
                                                                    messageAsString:@"Failed to open UPI app"];
                        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
                    }
                }];
            } else {
                BOOL success = [application openURL:url];
                NSLog(@"[UPILinkPlugin] openURL (legacy) success? %@", success ? @"YES" : @"NO");
                if (success) {
                    CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                                                messageAsString:@"Opened UPI app"];
                    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
                } else {
                    CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
                                                                messageAsString:@"Failed to open UPI app"];
                    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
                }
            }
        } else {
            NSLog(@"[UPILinkPlugin] No app can handle scheme: %@", url.scheme);
            CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
                                                        messageAsString:@"No UPI app installed"];
            [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
        }
    });
}

@end


