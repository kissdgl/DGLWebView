//
//  ViewController.m
//  DGLWebView
//
//  Created by 丁贵林 on 9/14/16.
//  Copyright © 2016 丁贵林. All rights reserved.
//

#import "ViewController.h"
#import <WebKit/WebKit.h>
#import "DGLImageController.h"

//http://www.jianshu.com/p/6ac7a913562c

@interface ViewController ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) WKWebView *webView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpWebView];
}

- (void)setUpWebView {
    
    self.webView = ({
        WKWebView *webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:webView];
        self.webView = webView;
        [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.jianshu.com/p/6ac7a913562c"]]];
        [self buildGestureRecognizer];
        webView;
    });
}

- (void)buildGestureRecognizer
{
    for (UIView *subView in self.webView.scrollView.subviews)
    {
        NSString *subviewClassName = NSStringFromClass([subView class]);
        
        if ([subviewClassName isEqualToString:@"WKContentView"])
        {
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
            tap.delegate = self;
            [subView addGestureRecognizer:tap];
            
            for (UIGestureRecognizer *gestureRecognizer in subView.gestureRecognizers) {
                if ([gestureRecognizer isMemberOfClass:[UILongPressGestureRecognizer class]]) {
//                    NSLog(@"%@",gestureRecognizer);
                    [gestureRecognizer removeTarget:nil action:nil];
                    [gestureRecognizer addTarget:self action:@selector(longPress:)];
                }
            
            }
        }
    }
}

- (void)longPress:(UILongPressGestureRecognizer *)recognizer {
    if (recognizer.state != UIGestureRecognizerStateBegan) {
        return;
    }
    CGPoint touchPoint = [recognizer locationInView:self.webView];
    NSString *js = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).src", touchPoint.x, touchPoint.y];
    
    [self.webView evaluateJavaScript:js completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        if (result != nil) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }]];
            [alert addAction:[UIAlertAction actionWithTitle:@"保存图片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSLog(@"====获取到图片地址：%@", result);
                
                [self SaveImageWithUrlStr:result];
                
                
            }]];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }];
    
}

- (void)tap:(UITapGestureRecognizer *)recognizer {

    CGPoint touchPoint = [recognizer locationInView:self.webView];
    NSString *js = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).src", touchPoint.x, touchPoint.y];
    [self.webView evaluateJavaScript:js completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        if (result != nil) {
            NSLog(@"++++++获取到图片地址：%@", result);
            DGLImageController *imageController = [[DGLImageController alloc] init];
            imageController.urlStr = result;
            [self.navigationController pushViewController:imageController animated:YES];
        }
    }];
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}


//save Image
- (void)SaveImageWithUrlStr:(NSString *)urlStr {
    __block UIImage *image = nil;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, queue, ^{
        NSURL *url = [NSURL URLWithString:urlStr];
        NSData *imageData = [NSData dataWithContentsOfURL:url];
        image = [UIImage imageWithData:imageData];
    });
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    });
    
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error) {
        NSLog(@"保存失败");
    }else{
        NSLog(@"保存成功");
    }
}


@end
