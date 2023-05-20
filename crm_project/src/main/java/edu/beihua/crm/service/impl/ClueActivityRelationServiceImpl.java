package edu.beihua.crm.service.impl;

import edu.beihua.crm.mapper.ClueActivityRelationMapper;
import edu.beihua.crm.model.ClueActivityRelation;
import edu.beihua.crm.service.ClueActivityRelationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service("ClueActivityRelationService")
public class ClueActivityRelationServiceImpl implements ClueActivityRelationService {

    @Autowired
    private ClueActivityRelationMapper clueActivityRelationMapper;

    //根据线索id查询所有有关的市场活动
    @Override
    public List<ClueActivityRelation> queryActivtiyRelationClue(String clueId) {
        return clueActivityRelationMapper.selectActivtiyRelationClue(clueId);
    }

    //删除与clueId相关的关联关系
    @Override
    public int deleteRelationByClueId(String clueId) {
        return clueActivityRelationMapper.deleteByClueId(clueId);
    }
}
