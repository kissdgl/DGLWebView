//
//  DGLImageController.m
//  DGLWebView
//
//  Created by 丁贵林 on 9/16/16.
//  Copyright © 2016 丁贵林. All rights reserved.
//

#import "DGLImageController.h"

@interface DGLImageController ()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation DGLImageController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
//    self.navigationController.navigationBar.hidden = YES;
    
    [self setUp];
    [self showImageWithUrlStr:self.urlStr];
}

- (void)setUp {
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.userInteractionEnabled = YES;
    [self.view addSubview:imageView];
    self.imageView = imageView;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self.imageView addGestureRecognizer:tap];
}

- (void)tap:(UITapGestureRecognizer *)tap {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showImageWithUrlStr:(NSString *)urlStr {
    
    __block UIImage *image = nil;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, queue, ^{
        NSURL *url = [NSURL URLWithString:urlStr];
        NSData *imageData = [NSData dataWithContentsOfURL:url];
        image = [UIImage imageWithData:imageData];
    });
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        CGSize imageSize = [self getImageSizeWithImage:image];
        self.imageView.frame = CGRectMake(0, 0, imageSize.width, imageSize.height);
        self.imageView.center = CGPointMake(self.view.bounds.size.width * 0.5, self.view.bounds.size.height * 0.5);
        self.imageView.image = image;
    });
}

- (CGSize)getImageSizeWithImage:(UIImage *)image {
    if (image.size.width >= image.size.height) {
        CGFloat width = [UIScreen mainScreen].bounds.size.width - 4;
        CGFloat height = image.size.height * width / image.size.width;
        return CGSizeMake(width, height);
    } else {
        CGFloat height = [UIScreen mainScreen].bounds.size.height;
        CGFloat width = image.size.width * height / image.size.height;
        return CGSizeMake(width, height);
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

@end
