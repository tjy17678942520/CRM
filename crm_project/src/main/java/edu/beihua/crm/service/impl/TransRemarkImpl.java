package edu.beihua.crm.service.impl;

import edu.beihua.crm.mapper.TranRemarkMapper;
import edu.beihua.crm.model.ClueRemark;
import edu.beihua.crm.service.TransRemark;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service("TransRemark")
public class TransRemarkImpl implements TransRemark {
    @Autowired
    private TranRemarkMapper tranRemarkMapper;


    @Override
    public int copyRemarkFromClueRemark(List<ClueRemark> clueRemarks) {
        return tranRemarkMapper.insertRemarkFromClueRemark(clueRemarks);
    }
}
