package edu.beihua.crm.service.impl;

import edu.beihua.crm.mapper.ContactsMapper;
import edu.beihua.crm.model.Contacts;
import edu.beihua.crm.service.ContactsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service("ContactsService")
public class ContactsServiceImpl implements ContactsService {
    @Autowired
    private ContactsMapper contactsMapper;

    @Override
    public List<Contacts> queryContactsByConditionForPage(Map<String, Object> map) {
        return contactsMapper.selectContactsByConditionForPage(map);
    }

    @Override
    public int queryCountOfContactsByCondition(Map<String, Object> map) {
        return contactsMapper.selectCountOfContactsByCondition(map);
    }

    @Override
    public List<Contacts> queryAllContactsBaseInfo() {
        return contactsMapper.selectAllContactsBaseInfo();
    }

    @Override
    public List<Contacts> queryContactByLikeName(String contactName) {
        return contactsMapper.selectContactByLikeName(contactName);
    }

    //创建新的练习人
    @Override
    public int createContacts(Contacts contacts) {
        return contactsMapper.insertContacts(contacts);
    }

    @Override
    public int deleteContactsByCustomerIds(String[] ids) {
        return contactsMapper.deleteContactsByCustomerIds(ids);
    }

    @Override
    public List<Contacts> queryContactsByCustomerIds(String[] ids) {
        return contactsMapper.selectContactsByCustomerIds(ids);
    }
}
