package edu.beihua.crm.service.impl;

import edu.beihua.crm.mapper.ClueActivityRelationMapper;
import edu.beihua.crm.mapper.ContactsActivityRelationMapper;
import edu.beihua.crm.model.ClueActivityRelation;
import edu.beihua.crm.service.ContactsActivityRelationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service("ContactsActivityRelationService")
public class ContactsActivityRelationServiceImpl implements ContactsActivityRelationService {

    @Autowired
    private ContactsActivityRelationMapper contactsActivityRelationMapper;

    //拷贝线索与市场活动的关系到 联系人与市场活动关系表中
    @Override
    public int copyContactsActivityFromClueActivity(List<ClueActivityRelation> activityRelationList) {
        return contactsActivityRelationMapper.insertContactsActivityFromClueActivity(activityRelationList);
    }

    @Override
    public int deleteContactsActivityRelationByContactsIds(String[] ids) {
        return contactsActivityRelationMapper.deleteByContactsIds(ids);
    }


}
