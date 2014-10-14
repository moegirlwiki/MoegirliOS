//
//  mcImageViewController.m
//  moegirlwiki
//
//  Created by Illvili on 14-10-14.
//  Copyright (c) 2014年 me.masterchan. All rights reserved.
//

#import "mcImageViewController.h"

@interface mcImageViewController ()

@property UIScrollView *scrollView;
@property UIImageView *imageView;
@property UIView *loadingView;

@property UITapGestureRecognizer *oneTap;
@property UITapGestureRecognizer *twoTap;

@property CGFloat initScale;

@end

@implementation mcImageViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        // 初始化ScrollView
        self.scrollView = [[UIScrollView alloc] init];
        self.scrollView.delegate = self;
        self.scrollView.frame = self.view.bounds;
        self.scrollView.backgroundColor = [UIColor blackColor];
        self.scrollView.bounces = YES;
        self.scrollView.maximumZoomScale = 2.0;
        self.scrollView.minimumZoomScale = 0.5;
        
        [self.view addSubview:self.scrollView];
        
        // 初始化手势 单点退出View 双点放大/缩小
        self.oneTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didOneTap:)];
        [self.oneTap setNumberOfTapsRequired:1];
        
        self.twoTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTwoTap:)];
        [self.twoTap setNumberOfTapsRequired:2];
        
        [self.oneTap requireGestureRecognizerToFail:self.twoTap];
        [self.scrollView addGestureRecognizer:self.oneTap];
        [self.scrollView addGestureRecognizer:self.twoTap];
        
        // loading提示
        CGSize screenSize = [UIScreen mainScreen].bounds.size;
        CGRect loadingViewFrame = CGRectMake(screenSize.width / 2 - 75, screenSize.height / 2 - 60, 150, 120);
        self.loadingView = [[UIView alloc] initWithFrame:loadingViewFrame];
        self.loadingView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
        self.loadingView.layer.cornerRadius = 3;
        [self.view addSubview:self.loadingView];
        
        UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [indicator setCenter:CGPointMake(75, 45)];
        [indicator startAnimating];
        [self.loadingView addSubview:indicator];
        
        UILabel *loadingtip = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, 150, 40)];
        loadingtip.text = @"载入中...";
        loadingtip.textAlignment = NSTextAlignmentCenter;
        loadingtip.backgroundColor = [UIColor clearColor];
        loadingtip.textColor = [UIColor blackColor];
        [self.loadingView addSubview:loadingtip];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    self.scrollView = nil;
    self.imageView = nil;
    self.loadingView = nil;
    self.oneTap = nil;
    self.twoTap = nil;
}

#pragma mark -

- (void)loadImageWithURL:(NSURL *)imageURL
{
    self.imageURL = imageURL;
    
    NSThread *imageLoader = [[NSThread alloc] initWithTarget:self selector:@selector(loadImage) object:nil];
    [imageLoader start];
}

- (void)loadImage
{
    if (nil == self.imageURL) {
        [self.loadingView setHidden:YES];
        
        return;
    }
    
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:self.imageURL]];
    
    if (image) {
        self.imageView = [[UIImageView alloc] initWithImage:image];
        
        CGSize imageSize = image.size;
        [self.scrollView setContentSize:imageSize];
        
        [self.scrollView addSubview:self.imageView];
        
        CGSize screenSize = [UIScreen mainScreen].bounds.size;
        CGFloat widthRatio = screenSize.width / image.size.width;
        CGFloat heightRatio = screenSize.height / image.size.height;
        CGFloat imageRatio = MIN(widthRatio, heightRatio);
        
        self.initScale = MIN(imageRatio, 1);
        NSLog(@"%f", self.initScale);
        
        [self.scrollView setZoomScale:self.initScale];
        [self.scrollView setMinimumZoomScale:self.initScale];
    } else {
        self.imageURL = nil;
    }
    
    [self.loadingView setHidden:YES];
}

#pragma mark - StatusBar settings

-(BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark - UIScrollViewDelegate

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

-(void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGSize boudsSize = self.scrollView.bounds.size;
    CGRect contentsFrame = self.imageView.frame;
    
    if (contentsFrame.size.width < boudsSize.width)
        contentsFrame.origin.x = (boudsSize.width - contentsFrame.size.width) / 2;
    else
        contentsFrame.origin.x = 0;
    
    if (contentsFrame.size.height < boudsSize.height)
        contentsFrame.origin.y = (boudsSize.height - contentsFrame.size.height) / 2;
    else
        contentsFrame.origin.y = 0;
    
    self.imageView.frame = contentsFrame;
}

#pragma mark - Gestures

- (void)didOneTap:(UITapGestureRecognizer *)tap
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didTwoTap:(UITapGestureRecognizer *)tap
{
    CGFloat currentScale = self.scrollView.zoomScale;
    
    if (currentScale == self.scrollView.maximumZoomScale) {
        [self.scrollView setZoomScale:self.scrollView.minimumZoomScale animated:YES];
        
        return;
    }
    
    CGFloat newScale = newScale = self.scrollView.maximumZoomScale;
    if (self.initScale < 1 && currentScale < 1) {
        newScale = 1;
    }
    
    CGPoint tapPoint = [tap locationInView:tap.view];
    CGPoint center = [self.imageView convertPoint:tapPoint fromView:self.scrollView];
    
    CGRect zoomRect;
    zoomRect.size.height = self.scrollView.frame.size.height / newScale;
    zoomRect.size.width = self.scrollView.frame.size.width / newScale;
    zoomRect.origin.x = center.x - (zoomRect.size.width / 2.0);
    zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0);
    
    [self.scrollView zoomToRect:zoomRect animated:YES];
}

@end
