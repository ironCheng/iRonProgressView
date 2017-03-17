# iRonProgressView
可实时获取当前进度的进度条 

the progressView which can catch the real-time progress

Usage
    iRonProgressView *iRonView = [[iRonProgressView alloc] initWithFrame:CGRectMake(100, 100, 100, 30)];
    iRonView.backgroundColor = [UIColor grayColor];
    iRonView.countInstance = 1;
    
    [self.view addSubview:iRonView];
    
    [iRonView setProgress:1 curretProgress:^(CGFloat progress) {
        NSLog(@"progress=%f",progress);
    } finished:^(BOOL finished) {
        NSLog(@"finish~~~");
    }];
