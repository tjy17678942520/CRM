package edu.beihua.crm.service.impl;

import edu.beihua.crm.mapper.ActivityMapper;
import edu.beihua.crm.model.Activity;
import edu.beihua.crm.service.ActivityService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service("activityervice")
public class ActivityServiceImpl implements ActivityService {

    @Autowired
    private ActivityMapper activityMapper;

    @Override
    public int insertActivity(Activity activity) {
        return activityMapper.insertActivity(activity);
    }

    @Override
    public List<Activity> queryActivityByConditionForPage(Map<String, Object> map) {
        return activityMapper.selectActivityByConditionForPage(map);
    }

    @Override
    public int queryCountOfActivityByCondition(Map<String, Object> map) {
        return activityMapper.selectCountOfActivityByCondition(map);
    }

    @Override
    public int deleteAcyivityByIds(String[] ids) {
        return activityMapper.deletdeActivityByIds(ids);
    }

    /**
     * 预更新查询
     * @param id
     * @return
     */
    @Override
    public Activity queryActivityById(String id) {
        return activityMapper.selectByPrimaryKey(id);
    }


    /**
     * 更新市场活动信息
     * @param activity
     * @return
     */
    @Override
    public int updateActivityByActivity(Activity activity) {
        return activityMapper.updateByPrimaryKey(activity);
    }

    /**
     * 查询所有的市场活动
     * @return
     */
    @Override
    public List<Activity> selectAllActivity() {
        return  activityMapper.selectAllActivity();
    }

    @Override
    public List<Activity> selectActivityByIds(String[] ids) {
        return activityMapper.selectActivityByIds(ids);
    }

    //导入市场活动
    @Override
    public int saveCreateActivityByList(List<Activity> activityList) {
        return activityMapper.insertActivityByList(activityList);
    }

    //查询市场活动详细信息
    @Override
    public Activity queryActivityForDetail(String id) {
        return activityMapper.selectActivityForDetailById(id);
    }

    //根据线索id查询所有的有关活动
    @Override
    public List<Activity> queryActivityRelationClueByclueId(String clueId) {
        return activityMapper.selectAllActivityRelationClueId(clueId);
    }

    @Override
    public List<Activity> queryActivityForDetaiByNameClueId(Map<String, String> map) {
        return activityMapper.selectActivityForDetaiByNameClueId(map);
    }

    //查询所有未与clueId相关联的所有活动
    @Override
    public List<Activity> queryAllActivityForDetaiByClueId(String clueId) {
        return activityMapper.selectAllActivityForDetaiByClueId(clueId);
    }

    @Override
    public List<Activity> queryAllActivitys() {
        return activityMapper.selectAllActivity();
    }

    @Override
    public List<Activity> queryAtivtysByLikeName(String activityName) {
        return activityMapper.selectAtivtysByLikeName(activityName);
    }
}
