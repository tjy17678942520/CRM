package edu.beihua.crm.service;

import edu.beihua.crm.model.Activity;

import java.util.List;
import java.util.Map;

public interface ActivityService {
    /**
     * 插入市场活动信息
     * @param activity
     * @return
     */
    int insertActivity(Activity activity);

    /**
     * 查询市场活动信息
     * @param map
     * @return
     */
    List<Activity> queryActivityByConditionForPage(Map<String,Object> map);

    int queryCountOfActivityByCondition(Map<String,Object> map);

    /**
     * 多选删除
     * @param ids
     * @return
     */
    int deleteAcyivityByIds(String[] ids);

    Activity queryActivityById(String id);

    /**
     * 更新市场活动信息
     * @param activity
     * @return
     */
    int updateActivityByActivity(Activity activity);

    /**
     * 查询所有市场活动
     * @return
     */
    List<Activity> selectAllActivity();

    //根据id查询市场活动
    List<Activity> selectActivityByIds(String[] ids);

    int saveCreateActivityByList(List<Activity> activityList);

    //查询市场活动的详细信息
    Activity queryActivityForDetail(String id);

    //根据线索id查询所有相关活动
    List<Activity> queryActivityRelationClueByclueId(String clueId);

    //查询未与线索id相关连的市场活动
    List<Activity> queryActivityForDetaiByNameClueId(Map<String,String> map);

    //初次点击关联市场活动 查询所有未关联的市场活动
    List<Activity> queryAllActivityForDetaiByClueId(String clueId);

    List<Activity> queryAllActivitys();

    //通过市场活动名称模糊查询市场
    List<Activity> queryAtivtysByLikeName(String activityName);
}
