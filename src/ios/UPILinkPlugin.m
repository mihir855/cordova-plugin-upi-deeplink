#import <Cordova/CDVPlugin.h>
#import <WebKit/WebKit.h>

@interface UPILinkPlugin : CDVPlugin <WKNavigationDelegate>
@end

@implementation UPILinkPlugin

- (void)pluginInitialize {
    if ([self.webView isKindOfClass:[WKWebView class]]) {
        WKWebView *wkWebView = (WKWebView*)self.webView;
        wkWebView.navigationDelegate = self;
    }
}

- (void)webView:(WKWebView*)webView
decidePolicyForNavigationAction:(WKNavigationAction*)navigationAction
decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {

    NSURL *url = navigationAction.request.URL;
    NSString *scheme = url.scheme.lowercaseString;

    if ([scheme hasPrefix:@"upi"] ||
        [scheme hasPrefix:@"phonepe"] ||
        [scheme hasPrefix:@"paytmmp"] ||
        [scheme hasPrefix:@"gpay"] ||
        [scheme hasPrefix:@"tez"] ||
        [scheme hasPrefix:@"bhim"] ||
        [scheme hasPrefix:@"amazonpay"] ||
        [scheme hasPrefix:@"mobikwik"] ||
        [scheme hasPrefix:@"freecharge"] ||
        [scheme hasPrefix:@"truecaller"] ||
        [scheme hasPrefix:@"whatsapp"]) {

        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            if (@available(iOS 10.0, *)) {
                [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
            } else {
                [[UIApplication sharedApplication] openURL:url];
            }
        } else {
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error"
                message:@"No UPI supported application found"
                preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK"
                style:UIAlertActionStyleDefault
                handler:nil];
            [alert addAction:ok];
            [self.viewController presentViewController:alert animated:YES completion:nil];
        }

        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }

    decisionHandler(WKNavigationActionPolicyAllow);
}

@end
