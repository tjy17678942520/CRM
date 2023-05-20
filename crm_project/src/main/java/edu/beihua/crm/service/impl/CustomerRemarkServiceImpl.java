package edu.beihua.crm.service.impl;

import edu.beihua.crm.mapper.CustomerRemarkMapper;
import edu.beihua.crm.model.ClueRemark;
import edu.beihua.crm.service.CustomerRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service("CustomerRemarkService")
public class CustomerRemarkServiceImpl implements CustomerRemarkService {
    @Autowired
    CustomerRemarkMapper customerRemarkMapper;

    //转存线索备注到客户备注
    @Override
    public int resaveClueRemarkToCustomerRemark(List<ClueRemark> clueRemarks) {
        return customerRemarkMapper.insertFromClueRemark(clueRemarks);
    }

    @Override
    public int deleteCustomerRemarkByIds(String[] ids) {
        return customerRemarkMapper.deleteContactsByIds(ids);
    }
}
