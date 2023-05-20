package edu.beihua.crm.service;

import edu.beihua.crm.model.Clue;
import edu.beihua.crm.model.ClueActivityRelation;
import edu.beihua.crm.model.ClueRemark;

import java.util.List;
import java.util.Map;

public interface ClueService {
    int savaCreateClude(Clue clue);

    //条件查询线索
    List<Clue> queryAllClueByByConditionForPage(Map<String,Object> map);

    //查询条数
    int queryAllClueCountByByConditionForPage(Map<String,Object> map);

    //修改市场活动
    int editClueByCluesId(Clue clue);

    //更具id查询线索信息
    Clue queryClueByid(String clue);

    //删除线索信息
    int deleteClueByIds(String[] ids);

    //根据id查询线索 详细
    Clue queryDetailClueById(String clueId);


    //取消关联关系
    int cancelClueRelationActivity(String clueId,String activityId);

    //添加关联关系
    int addActivtiyAndClue(List<ClueActivityRelation> activityRelationList);

    void saveConvert(Map<String,Object> map);
}
