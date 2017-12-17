//
//  BYWebViewController.m
//  BuDeJie
//
//  Created by huangbiyong on 2017/12/9.
//  Copyright © 2017年 com.chase. All rights reserved.
//

#import "BYWebViewController.h"
#import <WebKit/WebKit.h>


@interface BYWebViewController ()
@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *backItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *goItem;

@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

@property (nonatomic, weak) WKWebView *webView;

@end

@implementation BYWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    WKWebView *webView = [[WKWebView alloc]init];
    [self.contentView addSubview:webView];
    
    _webView = webView;
    
    // 展示网页
    NSURLRequest *request = [NSURLRequest requestWithURL:_url];
    [webView loadRequest:request];

    [webView addObserver:self forKeyPath:@"canGoBack" options:NSKeyValueObservingOptionNew context:nil];
    [webView addObserver:self forKeyPath:@"canGoForward" options:NSKeyValueObservingOptionNew context:nil];
    [webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];

    // 进度条
    [webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    _webView.frame = self.contentView.bounds;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    self.backItem.enabled = self.webView.canGoBack;
    self.goItem.enabled = self.webView.canGoForward;
    self.title = self.webView.title;
    self.progressView.progress = self.webView.estimatedProgress;
    self.progressView.hidden = self.webView.estimatedProgress >= 1;
    
}

- (void)dealloc {
    [_webView removeObserver:self forKeyPath:@"canGoBack"];
    [_webView removeObserver:self forKeyPath:@"canGoForward"];
    [_webView removeObserver:self forKeyPath:@"title"];
    [_webView removeObserver:self forKeyPath:@"estimatedProgress"];
}


- (IBAction)backClick:(id)sender {
    [self.webView goBack];
}
- (IBAction)goClick:(id)sender {
    [self.webView goForward];
}
- (IBAction)reloadClick:(id)sender {
    [self.webView reload];
}





@end
