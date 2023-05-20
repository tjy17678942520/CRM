package edu.beihua.crm.service.impl;

import edu.beihua.crm.mapper.ClueRemarkMapper;
import edu.beihua.crm.model.Clue;
import edu.beihua.crm.model.ClueRemark;
import edu.beihua.crm.service.ClueRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service("ClueRemarkService")
public class ClueRemarkServiceImpl implements ClueRemarkService {
    @Autowired
    private ClueRemarkMapper clueRemarkMapper;


    @Override
    public List<ClueRemark> queryClueRemarkForDetailByClueId(String clueId) {
        return clueRemarkMapper.selectClueRemarkForDetailByClueId(clueId);
    }

    @Override
    public int addClueRemark(ClueRemark clueRemark) {
        return clueRemarkMapper.insertClueRemark(clueRemark);
    }

    @Override
    public int deleltClueRemark(String id) {
        return clueRemarkMapper.deleltClueRemark(id);
    }

    @Override
    public int editClueById(ClueRemark clueRemark) {
        return clueRemarkMapper.updateClueById(clueRemark);
    }

    //更具线索id查询线索下的所有备注信息转存到客户备注中
    @Override
    public List<ClueRemark> queryClueRemarkForDetailByClueIdToCustomRemark(String clueid) {
        return clueRemarkMapper.selectClueRemarkForDetailByClueIdToCustomRemark(clueid);
    }

    //删除市场活动信息
    @Override
    public int deleteOneClueRemark(String clueId) {
        return clueRemarkMapper.deleteByClueId(clueId);
    }


}
