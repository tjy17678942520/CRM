package edu.beihua.crm.service;

import edu.beihua.crm.model.ClueRemark;

import java.util.List;

public interface TransRemark {
    int copyRemarkFromClueRemark(List<ClueRemark> clueRemarks);
}
