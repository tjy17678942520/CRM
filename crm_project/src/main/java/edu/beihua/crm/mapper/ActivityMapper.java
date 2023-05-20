package edu.beihua.crm.mapper;

import edu.beihua.crm.model.Activity;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Map;

public interface ActivityMapper {




    int insertSelective(Activity record);


    int updateByPrimaryKeySelective(Activity record);


    int updateByPrimaryKey(Activity record);

    /**
     * 插入一条市场活动记录
     * @param record
     * @return
     */
    int insertActivity(Activity record);

    /**
     * 查询市场活动所需要的数据
     * @param map
     * @return
     */
    List<Activity> selectActivityByConditionForPage(Map<String,Object> map);

    /**
     * 查询总条数
     * @param map
     * @return
     */
    int selectCountOfActivityByCondition(Map<String,Object> map);

    /**
     * 根据ids删除市场活动记录
     * @param ids
     * @return
     */
    int deletdeActivityByIds(String[] ids);

    int deleteByPrimaryKey(String id);

    /**
     * 更具id查询 市场活动信息
     * @param id
     * @return
     */
    Activity selectByPrimaryKey(String id);

    /**
     * 查询所有的市场活动信息
     * @return
     */
    List<Activity> selectAllActivity();

    /**
     * 选择批量导出功能
     */
    List<Activity> selectActivityByIds(String[] ids);


    //导入市场活动
    int insertActivityByList(List<Activity> activities);

    //查询市场活动明细
    Activity selectActivityForDetailById(String id);

    //查询与线索相关联的市场活动
    List<Activity> selectAllActivityRelationClueId(String clueId);

    //根据线索id和名字查询市场活动（即未关联的市场活动）
    List<Activity> selectActivityForDetaiByNameClueId(Map<String,String> map);


    //初次点击关联市场活动 查询所有未关联的市场活动
    List<Activity> selectAllActivityForDetaiByClueId(String clueId);

    List<Activity> selectAllActivitiesOnClueConvert();

    List<Activity> selectAtivtysByLikeName(String activityName);

}
