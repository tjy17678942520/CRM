package edu.beihua.crm.service;

import edu.beihua.crm.model.ActivityRemark;

import java.util.List;

public interface ActivityRemarkService {
    //查询所有市场活动的评论备注信息
    List<ActivityRemark> queryActivityRemarkForDetailByActivityId(String actviityId);

    //添加备注记录
    int saveCreateActivityRemark(ActivityRemark remark);

    //删除活动市场备注记录
    int deleteActivityRemarkById(String id);

    //修改市场活动备注
    int saveEditActivityRemark(ActivityRemark remark);
}
