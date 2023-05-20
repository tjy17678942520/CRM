package edu.beihua.crm.service;

import edu.beihua.crm.model.ClueRemark;

import java.util.List;

public interface CustomerRemarkService {
    int resaveClueRemarkToCustomerRemark(List<ClueRemark> clueRemarks);

    int deleteCustomerRemarkByIds(String[] ids);
}
