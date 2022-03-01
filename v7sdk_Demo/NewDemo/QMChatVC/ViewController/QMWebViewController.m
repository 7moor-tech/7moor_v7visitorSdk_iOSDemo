//
//  QMWebViewController.m
//  NewDemo
//
//  Created by ZCZ on 2021/6/7.
//

#import "QMWebViewController.h"
#import <WebKit/WebKit.h>
@interface QMWebViewController () <WKNavigationDelegate, WKUIDelegate>
@property (nonatomic, strong) WKWebView *webView;
@end

@implementation QMWebViewController

- (void)dealloc {
    [self.webView removeObserver:self forKeyPath:@"title"];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addSubview:self.webView];
    NSURLRequest *request = [NSURLRequest requestWithURL:_url];
    [self.webView loadRequest:request];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];

}

- (NSURL *)url {
    return _url ? : [NSURL new];
}

- (WKWebView *)webView {
    if (!_webView) {
        WKWebViewConfiguration *config = [WKWebViewConfiguration new];
        config.preferences.javaScriptCanOpenWindowsAutomatically = YES;
        _webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:config];
        _webView.navigationDelegate = self;
        _webView.UIDelegate = self;
        [_webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];

    }
    return _webView;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"title"]) {
        NSString *title = change[NSKeyValueChangeNewKey] ? : @"";
        self.navigationItem.title = title;
    }
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    if (navigationAction.targetFrame == nil) {
        [webView loadRequest:navigationAction.request];
    }
    
    NSString *urlStr = webView.URL.absoluteString;
    
    if ([urlStr hasPrefix:@"tel://"] || [urlStr hasPrefix:@"itms-appss:"]) {
        [UIApplication.sharedApplication openURL:webView.URL];
        [self.navigationController popViewControllerAnimated:YES];
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
