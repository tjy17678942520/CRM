package edu.beihua.crm.service.impl;

import edu.beihua.crm.mapper.ContactsRemarkMapper;
import edu.beihua.crm.model.ClueRemark;
import edu.beihua.crm.service.ContactsRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service("ContactsRemarkService")
public class ContactsRemarkServiceImpl implements ContactsRemarkService {

    @Autowired
    private ContactsRemarkMapper contactsRemarkMapper;


    //从线索备注表拷贝到联系人备注表
    @Override
    public int resaveClueRemarkToContactsRemark(List<ClueRemark> clueRemarks) {
        return contactsRemarkMapper.insertFromClueRemark(clueRemarks);
    }

    @Override
    public int deleteClueRemarkByContactsIds(String[] ids) {
        return contactsRemarkMapper.deleteByContactsIds(ids);
    }
}
