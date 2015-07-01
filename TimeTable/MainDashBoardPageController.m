//
//  MainDashBoardPageController.m
//  TimeTable
//
//  Created by Vinod Rathod on 25/06/15.
//  Copyright (c) 2015 Vinod Rathod. All rights reserved.
//

#import "MainDashBoardPageController.h"
#import "UserDashboardViewController.h"

@interface MainDashBoardPageController ()

@end

@implementation MainDashBoardPageController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.title = @"Dashboard";
    self.view.backgroundColor = [UIColor gk_cloudsColor];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Ok"] style:UIBarButtonItemStylePlain target:self action:@selector(donePressed:)];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Settings"] style:UIBarButtonItemStylePlain target:self action:@selector(settingsPage:)];
    
    
    
    
    
    self.pageViewController = [[UIPageViewController alloc]initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    self.pageViewController.dataSource = self;
    [[self.pageViewController view] setFrame:self.view.bounds];
    
    [[UIPageControl appearance]setPageIndicatorTintColor:[UIColor whiteColor]];
    [[UIPageControl appearance] setCurrentPageIndicatorTintColor:[UIColor gk_greenSeaColor]];
    
    
    UserDashboardViewController *initialVC = [self viewControllerAtIndex:0];
    
    NSArray *viewControllers = [NSArray arrayWithObject:initialVC];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
}

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSInteger index = [(UserDashboardViewController *)viewController index];
    
    index++;
    if (index == 2) {
        return nil;
    }
    
    return [self viewControllerAtIndex:index];
}

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSInteger index = [(UserDashboardViewController *)viewController index];
    
    if (index == 0) {
        return nil;
    }
    
    index--;
    
    return [self viewControllerAtIndex:index];
    
}

-(UserDashboardViewController *)viewControllerAtIndex:(NSUInteger)index {
    UserDashboardViewController *childVC = [[UserDashboardViewController alloc]initWithNibName:@"UserDashboardViewController" bundle:nil];
    [childVC.graphView reset];
    childVC.index = index;
    
    return childVC;
}

-(NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    return 2;
}

-(NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    return 0;
}


- (void)donePressed:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)settingsPage:(id)sender {
    NSLog(@"Settings");
}

@end
