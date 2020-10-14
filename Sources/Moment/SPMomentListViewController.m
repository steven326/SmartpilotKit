//
//  SPMomentListViewController.m
//  SmartpilotKit
//
//  Created by 王泽平 on 2020/10/10.
//

#import "SPMomentListViewController.h"
#import "SPMomentMapViewController.h"
#import "SPBaseTableView.h"
#import "SPMomentRequest.h"
#import "YJChatInputBarControl.h"
#import "SDTimeLineCell.h"
#import "LCActionSheet.h"
#import "SPDialogUtil.h"
#import "SPDelegationFactory.h"
#import "SmartpilotKit.h"
#import "MJRefresh.h"
#import "Masonry.h"
#import "YYCategories.h"

@interface SPMomentListViewController ()
<
UITableViewDataSource,
UITableViewDelegate,
SDTimeLineCellDelegate,
YJChatInputBarControlDelegate
>
/// 滚动视图
@property (nonatomic, strong) SPBaseTableView *rootTableView;
/// 当前编辑的indexPath
@property (nonatomic, strong) NSIndexPath *currentEditingIndexthPath;
/// 数据源
@property (nonatomic, strong) NSMutableArray<MomentsListModel *> *datasArray;
/// 输入框
@property (nonatomic, strong) YJChatInputBarControl *inputBar;
/// 代理
@property (strong, nonatomic) SPDelegationProxy *dataSourceProxy;
@property (strong, nonatomic) SPDelegationProxy *delegateProxy;

@end

@implementation SPMomentListViewController

- (void)dealloc
{
    [NSNotificationCenter.defaultCenter removeObserverBlocks];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [SPMomentConfig shared];
        
        _dataSourceProxy = [SPDelegationFactory dataSourceProxy];
        _delegateProxy = [SPDelegationFactory delegateProxy];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.datasArray = @[].mutableCopy;
    
    [self.view addSubview:self.rootTableView];
    
    self.inputBar = [[YJChatInputBarControl alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 50)];
    self.inputBar.delegate = self;
    [self.inputBar setTextViewPlaceHolder:@"评论"];
    [self.view addSubview:self.inputBar];
    [self.view bringSubviewToFront:self.inputBar];
    
    [self reloadData];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [self.rootTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

/// 重新调接口刷新页面
- (void)reloadData
{
    [self _fetchMomentsListDataWithIfPullDown:true];
}

- (void)_fetchMomentsListDataWithIfPullDown:(BOOL)pullDown
{
    @weakify(self);
    self.rootTableView.currentPageNo = pullDown ? 1 : (self.rootTableView.currentPageNo += 1);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        SPMomentRequest *request = [[SPMomentRequest alloc] init];
        [request requestMomentsListWithQ:SPMomentConfig.shared.q pageNumber:self.rootTableView.currentPageNo pageSize:kPageSize complete:^(BOOL succeed, NSArray<MomentsListModel *> * _Nonnull models, NSError * _Nonnull error) {
            @strongify(self);
            if (succeed) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (pullDown) {
                        [self.datasArray removeAllObjects];
                        [self.datasArray addObjectsFromArray:models];
                        [self.rootTableView.mj_footer resetNoMoreData];
                        if (models.count < kPageSize) {
                            [self.rootTableView.mj_footer endRefreshingWithNoMoreData];
                        }
                        self.rootTableView.isNoData = models.count == 0;
                    }
                    else {
                        [self.datasArray addObjectsFromArray:models];
                        if (models.count < kPageSize) {
                            [self.rootTableView.mj_footer endRefreshingWithNoMoreData];
                        }
                        else {
                            [self.rootTableView.mj_footer endRefreshing];
                        }
                    }
                    [self.rootTableView reloadData];
                });
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.rootTableView.mj_header endRefreshing];
            });
        }];
    });
}

- (void)_doMomentsLikeWithMomentId:(NSString *)momentId
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        SPMomentRequest *request = [[SPMomentRequest alloc] init];
        [request requestMomentsLikeWithMomentId:momentId complete:^(BOOL succeed, NSArray<MomentsLikeUsersModel *> * _Nonnull models, NSError * _Nonnull error) {
            if (succeed) {
                NSLog(@"点赞成功");
            }
        }];
    });
}

- (void)_doMomentsDeleteWithMomentId:(NSString *)momentId
{
    @weakify(self);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        SPMomentRequest *request = [[SPMomentRequest alloc] init];
        [request requestDeleteMomentWithMomentId:momentId complete:^(BOOL succeed, NSError * _Nonnull error) {
            @strongify(self);
            if (succeed) {
                [self.datasArray enumerateObjectsUsingBlock:^(MomentsListModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    @strongify(self);
                    if ([obj.moment_id isEqualToString:momentId]) {
                        *stop = YES;
                        [self.datasArray removeObject:obj];
                    }
                }];
                [self.rootTableView reloadData];
            }
        }];
    });
}

- (void)_doCommentDeleteWithCommmentId:(NSString *)commmentId momentId:(NSString *)momnentId
{
    @weakify(self);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        SPMomentRequest *request = [[SPMomentRequest alloc] init];
        [request requestDeleteMomentsCommontWithMomentId:momnentId commentId:commmentId complete:^(BOOL succeed, NSError * _Nonnull error) {
            @strongify(self);
            if (succeed) {
                NSMutableArray<MomentsCommentsModel *> *temps = @[].mutableCopy;
                [self.datasArray enumerateObjectsUsingBlock:^(MomentsListModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [obj.comments enumerateObjectsUsingBlock:^(MomentsCommentsModel * _Nonnull subobj, NSUInteger subidx, BOOL * _Nonnull substop) {
                        if ([subobj.comment_id isEqualToString:commmentId]) {
                            *stop = YES;
                            [temps addObjectsFromArray:obj.comments];
                            [temps removeObject:subobj];
                            self.datasArray[idx].comments = temps;
                        }
                    }];
                }];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.rootTableView reloadData];
                });
            }
        }];
    });
}

- (void)_doMomentsCommentWithMomentId:(NSString *)momentId content:(NSString *)content
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        SPMomentRequest *request = [[SPMomentRequest alloc] init];
        [request requestMomentsCommontsWithMomentId:momentId content:content complete:^(BOOL succeed, NSArray<MomentsCommentsModel *> * _Nonnull models, NSError * _Nonnull error) {
            if (succeed) {
                self.datasArray[self.currentEditingIndexthPath.row].comments = models;
            }
        }];
    });
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datasArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SDTimeLineCell *cell = [tableView dequeueReusableCellWithIdentifier:SDTimeLineCell.cellId];
    cell.indexPath = indexPath;
    cell.delegate = self;
    cell.momentsListModel = self.datasArray[indexPath.row];
    [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id model = self.datasArray[indexPath.row];
    return [self.rootTableView cellHeightForIndexPath:indexPath model:model keyPath:@"momentsListModel" cellClass:SDTimeLineCell.class contentViewWidth:[UIScreen mainScreen].bounds.size.width];
}

#pragma mark - MenuControllerClick
- (void)moreClick:(UIMenuController *)menu
{
    [SPUtils showToastWithMessage:@"敬请期待^_^" view:self.view];
}

- (void)deleteCommentClick:(UIMenuController *)menu
{
    NSString *comment_id = menu.accessibilityLabel;
    NSString *moment_id = self.datasArray[self.currentEditingIndexthPath.row].moment_id;
    [self _doCommentDeleteWithCommmentId:comment_id momentId:moment_id];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    /// 收起键盘
    [self.inputBar keyboardResignFirstResponder];
    
    /// 隐藏MenuController
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    if (menuController.isMenuVisible) {
        [menuController setMenuVisible:NO animated:YES];
    }
}

#pragma mark - SDTimeLineCellDelegate

/// 评论
/// @param cell 当前Cell对象
- (void)didClickCommentButtonInCell:(SDTimeLineCell *)cell
{
    /// 是否可操作
    if (![self.dataSource operationIsValidatedWithType:SPMomentOperateTypeComment viewController:self]) {
        return;
    }
    
    /// 弹出输入框
    _currentEditingIndexthPath = [self.rootTableView indexPathForCell:cell];
    [self.inputBar setTextViewContent:self.datasArray[_currentEditingIndexthPath.row].draft];
    [self.inputBar keyboardBecomeFirstResponder];
}

/// 点赞
/// @param cell 当前Cell对象
- (void)didClickLikeButtonInCell:(SDTimeLineCell *)cell isLike:(BOOL)isLike
{
    /// 是否可操作
    if (![self.dataSource operationIsValidatedWithType:SPMomentOperateTypeLike viewController:self]) {
        return;
    }
    NSIndexPath *index = [self.rootTableView indexPathForCell:cell];
    if (!index) {
        return;
    }
    MomentsListModel *model = self.datasArray[index.row];
    model.is_like = isLike;
    
    NSMutableArray *temp = [NSMutableArray arrayWithArray:model.like_users];
    if (model.is_like) {
        MomentsLikeUsersModel *likeModel = [MomentsLikeUsersModel new];
        likeModel.use_name = SPMomentConfig.shared.realName;
        likeModel.user_id = SPMomentConfig.shared.userId;
        [temp addObject:likeModel];
    }
    else {
        MomentsLikeUsersModel *tempLikeModel = nil;
        for (MomentsLikeUsersModel *likeModel in model.like_users) {
            if ([likeModel.user_id isEqualToString:SPMomentConfig.shared.userId]) {
                tempLikeModel = likeModel;
                break;
            }
        }
        [temp removeObject:tempLikeModel];
    }
    model.like_users = [temp copy];
    [self _doMomentsLikeWithMomentId:model.moment_id];
    
    [UIView performWithoutAnimation:^{
        [self.rootTableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationNone];
    }];
}

/// 点击头像
/// @param cell 当前Cell对象
- (void)didClickPortraitInCell:(SDTimeLineCell *)cell
{
    /// 是否可操作
    if (![self.dataSource operationIsValidatedWithType:SPMomentOperateTypeTapUser viewController:self]) {
        return;
    }
    NSString *userId = self.datasArray[[self.rootTableView indexPathForCell:cell].row].user_id;
    if ([self.delegateProxy respondsToSelector:@selector(didClickUser:inViewController:)]) {
        [self.delegate didClickUser:userId inViewController:self];
    }
//    YJMomentUserIntroViewController *vc = [[YJMomentUserIntroViewController alloc] initWithUserId:targetId];
//    vc.hidesBottomBarWhenPushed = YES;
//    [YJUtils.topViewController.navigationController pushViewController:vc animated:true];
}

/// 长按文本
/// @param cell 当前Cell对象
- (void)didLongPressContentInCell:(SDTimeLineCell *)cell
{
    NSIndexPath *indexPath = [self.rootTableView indexPathForCell:cell];
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    /// menuController 复制的内容
    menuController.accessibilityValue = self.datasArray[indexPath.row].content;
    if (menuController.isMenuVisible) {
        [menuController setMenuVisible:NO animated:YES];
    }
    else {
        [cell becomeFirstResponder];
        UIMenuItem *item01 = [[UIMenuItem alloc] initWithTitle:@"更多" action:@selector(moreClick:)];
        menuController.menuItems = @[item01];
        CGSize contentSize = self.datasArray[indexPath.row].contentLabelFrame.size;
        CGRect showRect = CGRectMake(30, cell.frame.origin.y + 72, contentSize.width, contentSize.height);
        [menuController setTargetRect:showRect inView:cell.superview];
        [menuController setMenuVisible:YES animated:YES];
    }
}

/// 点击展开/收起回调
/// @param cell 当前Cell对象
- (void)didClickMoreButtonInCell:(UITableViewCell *)cell
{
    NSIndexPath *indexPath = [self.rootTableView indexPathForCell:cell];
    MomentsListModel *model = self.datasArray[indexPath.row];
    model.isOpening = !model.isOpening;
    [UIView performWithoutAnimation:^{
        [self.rootTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }];
}

/// 点击评论区域用户名回调
/// @param cell 当前Cell对象
- (void)didClickCommentUserInCell:(SDTimeLineCell *)cell userId:(NSString *)userId
{
    /// 是否可操作
    if (![self.dataSource operationIsValidatedWithType:SPMomentOperateTypeTapUser viewController:self]) {
        return;
    }
    if ([self.delegateProxy respondsToSelector:@selector(didClickUser:inViewController:)]) {
        [self.delegate didClickUser:userId inViewController:self];
    }
//    YJMomentUserIntroViewController *vc = [[YJMomentUserIntroViewController alloc] initWithUserId:userId];
//    vc.hidesBottomBarWhenPushed = YES;
//    [YJUtils.topViewController.navigationController pushViewController:vc animated:true];
}

/// 点击删除港航圈回调
/// @param cell 当前Cell对象
- (void)didClickDeleteButtonInCell:(UITableViewCell *)cell
{
    @weakify(self);
    MomentsListModel *model = self.datasArray[[self.rootTableView indexPathForCell:cell].row];
    NSAttributedString *attribute = [[NSAttributedString alloc] initWithString:@"确定删除吗？"];
    [SPDialogUtil showChoicesDialogWithContent:attribute imageName:nil view:nil type:SPChoicesDialogViewTypeTextOnly identifier:@"" queue:YES autoClose:YES confirmText:nil cancelText:nil confirmTextColor:nil cancelTextColor:nil isForceConfirm:NO isForceCancel:NO confirmBlock:^{
        @strongify(self);
        [self _doMomentsDeleteWithMomentId:model.moment_id];
    } cancelBlock:^{

    }];
}

/// 点击举报回调
/// @param cell 当前Cell对象
- (void)didClickReportButtonInCell:(UITableViewCell *)cell
{
    /// 是否可操作
    if (![self.dataSource operationIsValidatedWithType:SPMomentOperateTypeFeedback viewController:self]) {
        return;
    }
    MomentsListModel *model = self.datasArray[[self.rootTableView indexPathForCell:cell].row];
    if ([self.delegateProxy respondsToSelector:@selector(didClickFeedbackOfMoment:inViewController:)]) {
        [self.delegate didClickFeedbackOfMoment:model.moment_id inViewController:self];
    }
//    YJFeedbackViewController *vc = [[YJFeedbackViewController alloc] init];
//    vc.navigationTitle = @"投诉或建议";
//    vc.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:vc animated:true];
}

/// 点击地址回调
/// @param cell 当前Cell对象
- (void)didClickLocationInCell:(UITableViewCell *)cell
{
    NSIndexPath *indexPath = [self.rootTableView indexPathForCell:cell];
    MomentsListModel *model = self.datasArray[indexPath.row];
    SPMomentMapViewController *vc = [[SPMomentMapViewController alloc] init];
    vc.coordinate = CLLocationCoordinate2DMake(model.latitude, model.longitude);
    vc.locationTitle = model.address;
    vc.hidesBottomBarWhenPushed = YES;
    [SPUtils.topViewController.navigationController pushViewController:vc animated:true];
}

/// 长按评论内容回调
/// @param cell 当前Cell对象
/// @param index 评论内容的下标
/// @param rectInCell 相对于cell的frame
- (void)didLongPressCommentContentInCell:(UITableViewCell *)cell cmt_index:(NSInteger)index rectInCell:(CGRect)rectInCell
{
    NSIndexPath *indexPath = [self.rootTableView indexPathForCell:cell];
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    if (menuController.isMenuVisible) {
        [menuController setMenuVisible:NO animated:YES];
    }
    [cell becomeFirstResponder];
    /// menuController 复制的内容
    menuController.accessibilityValue = self.datasArray[indexPath.row].comments[index].comment;
    /// menuController 评论的id
    menuController.accessibilityLabel = self.datasArray[indexPath.row].comments[index].comment_id;
    /// 可以删除自己的评论
    if (SPMomentConfig.shared.userId.isNotBlank && [self.datasArray[indexPath.row].comments[index].user_id isEqualToString:SPMomentConfig.shared.userId]) {
        UIMenuItem *item01 = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(deleteCommentClick:)];
        menuController.menuItems = @[item01];
    }
    else {
        menuController.menuItems = @[];
    }
    CGRect showRect = CGRectMake(30, cell.frame.origin.y + rectInCell.origin.y, rectInCell.size.width, rectInCell.size.height);
    [menuController setTargetRect:showRect inView:cell.superview];
    [menuController setMenuVisible:YES animated:YES];
}

/// 点击评论回调
/// @param cell 当前Cell对象
/// @param index 评论内容的下标
- (void)didClickCommentInCell:(UITableViewCell *)cell cmt_index:(NSInteger)index
{
    @weakify(self);
    NSIndexPath *indexPath = [self.rootTableView indexPathForCell:cell];
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    if (menuController.isMenuVisible) {
        [menuController setMenuVisible:NO animated:YES];
    }
    if (SPMomentConfig.shared.userId.isNotBlank && [self.datasArray[indexPath.row].comments[index].user_id isEqualToString:SPMomentConfig.shared.userId]) {
        LCActionSheet *actionSheet = [LCActionSheet sheetWithTitle:nil cancelButtonTitle:@"取消" clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                @strongify(self);
                [self _doCommentDeleteWithCommmentId:self.datasArray[indexPath.row].comments[index].comment_id
                                            momentId:self.datasArray[indexPath.row].moment_id];
            }
        } otherButtonTitles:@"删除", nil];
        actionSheet.destructiveButtonIndexSet = [NSIndexSet indexSetWithIndex:1];
        [actionSheet show];
    }
}

- (void)adjustTableViewToFitKeyboard
{
//    if (self.rootTableView.contentOffset.y == 0 && self.pagerView) {
//        [self.pagerView.mainTableView setContentOffset:CGPointMake(0, 280) animated:NO];
//    }
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UITableViewCell *cell = [self.rootTableView cellForRowAtIndexPath:_currentEditingIndexthPath];
    CGRect rect = [cell.superview convertRect:cell.frame toView:window];
    CGFloat delta = CGRectGetMaxY(rect) - (kScreenHeight - self.inputBar.visibleInputKeyboardHeight);
//    CGFloat delta = CGRectGetMaxY(rect) - self.inputBar.origin.y;
    CGPoint offset = self.rootTableView.contentOffset;
    offset.y += delta;
    if (offset.y < 0) {
        offset.y = 0;
    }
    [self.rootTableView setContentOffset:offset animated:YES];
}

- (void)resetInputControl
{
    [self.inputBar removeFromSuperview];
    self.inputBar = nil;
    
    self.inputBar = [[YJChatInputBarControl alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 50)];
    self.inputBar.delegate = self;
    [self.inputBar setTextViewPlaceHolder:@"评论"];
    [self.view addSubview:self.inputBar];
    [self.view bringSubviewToFront:self.inputBar];
}

#pragma mark - YJChatInputBarControlDelegate

- (void)chatInputBarShouldChangeFrame:(CGRect)frame
{
    if (self.inputBar.visibleInputKeyboardHeight == frame.origin.y || frame.origin.y == kScreenHeight) {
        return;
    }
//    if (!LEEAlert.isQueueEmpty) {
//        self.inputBar.hidden = YES;
//        return;
//    }
    self.inputBar.hidden = NO;
    [self adjustTableViewToFitKeyboard];
}

- (void)chatInputBarDidClickSendButton:(NSString *)content
{
    MomentsListModel *model = self.datasArray[_currentEditingIndexthPath.row];
    model.draft = @"";
    NSMutableArray *temp = [NSMutableArray new];
    [temp addObjectsFromArray:model.comments];
    MomentsCommentsModel *commentItemModel = MomentsCommentsModel.new;
    commentItemModel.user_id = SPMomentConfig.shared.userId;
    commentItemModel.use_name = SPMomentConfig.shared.realName;
    commentItemModel.comment = content;
    [temp addObject:commentItemModel];
    model.comments = [temp copy];
    [UIView performWithoutAnimation:^{
        [self.rootTableView reloadRow:_currentEditingIndexthPath.row inSection:_currentEditingIndexthPath.section withRowAnimation:UITableViewRowAnimationNone];
    }];
    
    [self _doMomentsCommentWithMomentId:model.moment_id content:commentItemModel.comment];
}

- (void)chatInputBarTextViewDidChange:(UITextView *)textView
{
    MomentsListModel *model = self.datasArray[_currentEditingIndexthPath.row];
    model.draft = textView.text;
}

#pragma mark - Lazy
- (void)setDataSource:(id<SPMomentDataSource>)dataSource
{
    self.dataSourceProxy.delegation = dataSource;
}

- (id<SPMomentDataSource>)dataSource
{
    return self.dataSourceProxy.delegation;
}

- (void)setDelegate:(id<SPMomentDelegate>)delegate
{
    self.delegateProxy.delegation = delegate;
}

- (id<SPMomentDelegate>)delegate
{
    return self.delegateProxy.delegation;
}

- (SPBaseTableView *)rootTableView
{
    if (!_rootTableView) {
        _rootTableView = [[SPBaseTableView alloc] init];
        _rootTableView.dataSource = self;
        _rootTableView.delegate = self;
        _rootTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _rootTableView.estimatedRowHeight = 0;
        _rootTableView.estimatedSectionHeaderHeight = 0;
        _rootTableView.estimatedSectionFooterHeight = 0;
        _rootTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        if (@available(iOS 11.0, *)) {
            _rootTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
        [_rootTableView registerClass:SDTimeLineCell.class forCellReuseIdentifier:SDTimeLineCell.cellId];
        @weakify(self);
        _rootTableView.enableRefreshFooter = NO;
        [_rootTableView setFooterWithRefreshingBlock:^{
            @strongify(self);
            [self _fetchMomentsListDataWithIfPullDown:NO];
        }];
        if (SPMomentConfig.shared.enableRefreshHeader) {
            @strongify(self);
            _rootTableView.enableRefreshHeader = YES;
            [_rootTableView setHeaderWithRefreshingBlock:^{
                [self _fetchMomentsListDataWithIfPullDown:YES];
            }];
        }
    }
    return _rootTableView;
}
@end
