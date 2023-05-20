package edu.beihua.crm.service;

import edu.beihua.crm.model.Contacts;

import java.util.List;
import java.util.Map;

public interface ContactsService {
    //分页查询
    List<Contacts> queryContactsByConditionForPage(Map<String,Object> map);

    //分页查询条数
    int queryCountOfContactsByCondition(Map<String,Object> map);

    List<Contacts> queryAllContactsBaseInfo();

    List<Contacts> queryContactByLikeName(String contactName);

    int createContacts(Contacts contacts);

    int deleteContactsByCustomerIds(String[] ids);

    List<Contacts> queryContactsByCustomerIds(String[] ids);
}
