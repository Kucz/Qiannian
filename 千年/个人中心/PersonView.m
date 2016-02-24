//
//  PersonView.m
//  千年
//
//  Created by God on 16/1/14.
//  Copyright © 2016年 God. All rights reserved.
//

#import "PersonView.h"
#import "SearchTableViewCell.h"
#import "WantedBuyTableViewCell.h"
#import "SearcherModel.h"
#import "WantedByModel.h"
#import "GoodDetailViewController.h"
@implementation PersonView


-(instancetype)init
{
    if(self = [super init])
    {
        _mytab = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, winWidth, winHeight-64-100-44)];
        _mytab.dataSource = self;
        _mytab.delegate = self;
        _mytab.tableFooterView = [UIView new];
        [self addSubview:_mytab];
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.selected==1)
    {
        return self.searchModel.count;
    }else if(self.selected==2){
        return self.searchModel.count;
    }else if(self.selected==3){
        return self.wantedModel.count;
    }else{
        return 0;
    }
}

-(void)setSearchModel:(NSMutableArray *)searchModel
{
    if(searchModel==nil)
    {
        NSLog(@"空");
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, winWidth, winHeight)];
        [imageView setImage:[UIImage imageNamed:@"AllNone"]];
        [self.mytab setBackgroundView:imageView];
        return;
    }
    [self.mytab setBackgroundView:nil];
    _searchModel = searchModel;
    [self.mytab reloadData];
}

-(void)setWantedModel:(NSMutableArray *)wantedModel
{
    if(wantedModel==nil)
    {
        NSLog(@"空0");
//        [self.mytab setBackgroundColor:[UIColor redColor]];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, winWidth, winHeight)];
        [imageView setImage:[UIImage imageNamed:@"AllNone"]];
        [self.mytab setBackgroundView:imageView];
        return;
    }
    [self.mytab setBackgroundView:nil];
    _wantedModel = wantedModel;
    [self.mytab reloadData];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.selected == 1)
    {
        SearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"searchCell"];
        if(cell == nil)
        {
            cell = [[NSBundle mainBundle] loadNibNamed:@"SearchTableViewCell" owner:nil options:nil].lastObject;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
//        #B2E2F2Color.rgb(178, 226, 242)
        [cell setBackgroundColor:[UIColor colorWithRed:178/255.0 green:226/255.0 blue:242/255.0 alpha:0.99]];
        cell.model = self.searchModel[indexPath.row];
        cell.layer.borderWidth = 0.5;
        cell.layer.borderColor = [UIColor colorWithRed:51/255.0 green:175/255.0 blue:252/255.0 alpha:1.0].CGColor;
        return cell;
    }else if(self.selected == 2){
        SearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"searchCell"];
        if(cell == nil)
        {
            cell = [[NSBundle mainBundle] loadNibNamed:@"SearchTableViewCell" owner:nil options:nil].lastObject;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        [cell setBackgroundColor:[UIColor colorWithRed:178/255.0 green:226/255.0 blue:242/255.0 alpha:0.99]];
        UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, winWidth, 130)];
        [imageview setImage:[UIImage imageNamed:@"buyed_See"]];
        imageview.alpha = 0.5;
        [cell addSubview:imageview];
        
        
        cell.layer.borderColor = [UIColor colorWithRed:51/255.0 green:175/255.0 blue:252/255.0 alpha:1.0].CGColor;
        cell.layer.borderWidth = 0.5;
        cell.model = self.searchModel[indexPath.row];
        return cell;
    }else if(self.selected == 3){
        WantedBuyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"wantedCell"];
        if(cell == nil)
        {
            cell = [[NSBundle mainBundle] loadNibNamed:@"WantedBuyTableViewCell" owner:nil options:nil].lastObject;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        [cell setBackgroundColor:[UIColor colorWithRed:178/255.0 green:226/255.0 blue:242/255.0 alpha:0.99]];
                cell.layer.borderColor = [UIColor colorWithRed:51/255.0 green:175/255.0 blue:252/255.0 alpha:1.0].CGColor;
        cell.layer.borderWidth = 1;
        cell.model = self.wantedModel[indexPath.row];
        return cell;
    }else{
        UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"nil"];
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc] init];
        }
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.selected==1)
    {
        return 130;
    }else if(self.selected==2){
        
       
        
        return 130;
    }else if (self.selected==3)
    {
        WantedByModel *model = self.wantedModel[indexPath.row];
        return model.height;
    }else{
        return 0;
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.selected==1)
    {
        if([self.Diddelegate respondsToSelector:@selector(didSelectedWithSelectedNumber:SearchModel:)])
        {
            [self.Diddelegate didSelectedWithSelectedNumber:self.selected SearchModel:self.searchModel[indexPath.row]];
        }
    }else if(self.selected==2)
    {
        
    }else if(self.selected==3)
    {
        if([self.Diddelegate respondsToSelector:@selector(didSelectedWithSelectedNumber:WantedModel:)])
        {
            [self.Diddelegate didSelectedWithSelectedNumber:self.selected WantedModel:self.wantedModel[indexPath.row]];
        }
    }
}



@end
