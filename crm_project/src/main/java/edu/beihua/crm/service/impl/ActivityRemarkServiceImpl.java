package edu.beihua.crm.service.impl;

import edu.beihua.crm.mapper.ActivityRemarkMapper;
import edu.beihua.crm.model.ActivityRemark;
import edu.beihua.crm.service.ActivityRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ActivityRemarkServiceImpl implements ActivityRemarkService {

    @Autowired
    ActivityRemarkMapper activityRemarkMapper;

    //查询市场活动
    @Override
    public List<ActivityRemark> queryActivityRemarkForDetailByActivityId(String actviityId) {
        return activityRemarkMapper.selectActivityRemarkForDetailByActivityId(actviityId);
    }

    //添加备注
    @Override
    public int saveCreateActivityRemark(ActivityRemark remark){
        return activityRemarkMapper.insertActivityRemark(remark);
    }

    @Override
    public int deleteActivityRemarkById(String id) {
        return activityRemarkMapper.deleltActivityRemark(id);
    }

    @Override
    public int saveEditActivityRemark(ActivityRemark remark) {
        return activityRemarkMapper.updateActivityRemark(remark);
    }

}
