package edu.beihua.crm.service;

import edu.beihua.crm.model.ClueRemark;

import java.util.List;

public interface ContactsRemarkService {
    //从线索备注表拷贝到联系人备注表
    int resaveClueRemarkToContactsRemark(List<ClueRemark> clueRemarks);

    int deleteClueRemarkByContactsIds(String[] ids);
}
