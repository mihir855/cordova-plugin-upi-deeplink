#import <Cordova/CDV.h>
#import <WebKit/WebKit.h>

@interface UPILinkPlugin : CDVPlugin <WKNavigationDelegate>
@end

@implementation UPILinkPlugin

- (void)pluginInitialize {
    WKWebView* wkWebView = (WKWebView*)self.webView;
    wkWebView.navigationDelegate = self;
}

- (void)webView:(WKWebView*)webView
decidePolicyForNavigationAction:(WKNavigationAction*)navigationAction
decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {

    NSURL *url = navigationAction.request.URL;
    NSString *scheme = url.scheme.lowercaseString;

    if ([scheme isEqualToString:@"upi"] ||
        [scheme isEqualToString:@"phonepe"] ||
        [scheme isEqualToString:@"paytmmp"] ||
        [scheme isEqualToString:@"tez"] ||
        [scheme isEqualToString:@"gpay"] ||
        [scheme isEqualToString:@"bhim"] ||
        [scheme isEqualToString:@"amazonpay"] ||
        [scheme isEqualToString:@"mobikwik"] ||
        [scheme isEqualToString:@"freecharge"] ||
        [scheme isEqualToString:@"truecaller"] ||
        [scheme isEqualToString:@"whatsapp"]) {
        
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
        } else {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
                message:@"No UPI supported application found"
                preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
            [self.viewController presentViewController:alert animated:YES completion:nil];
        }

        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }

    decisionHandler(WKNavigationActionPolicyAllow);
}

@end
