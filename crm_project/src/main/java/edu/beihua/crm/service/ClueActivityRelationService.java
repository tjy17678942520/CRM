package edu.beihua.crm.service;

import edu.beihua.crm.model.ClueActivityRelation;

import java.util.List;

public interface ClueActivityRelationService {
    List<ClueActivityRelation> queryActivtiyRelationClue(String clueId);

    //删户市场活动 与线索clueId 关系
    int deleteRelationByClueId(String clueId);
}
