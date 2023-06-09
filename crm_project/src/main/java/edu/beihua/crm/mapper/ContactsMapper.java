package edu.beihua.crm.mapper;

import edu.beihua.crm.model.Activity;
import edu.beihua.crm.model.Contacts;

import java.util.List;
import java.util.Map;

public interface ContactsMapper {
    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_contacts
     *
     * @mbggenerated Mon May 15 15:37:04 CST 2023
     */
    int deleteByPrimaryKey(String id);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_contacts
     *
     * @mbggenerated Mon May 15 15:37:04 CST 2023
     */
    int insert(Contacts record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_contacts
     *
     * @mbggenerated Mon May 15 15:37:04 CST 2023
     */
    int insertSelective(Contacts record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_contacts
     *
     * @mbggenerated Mon May 15 15:37:04 CST 2023
     */
    Contacts selectByPrimaryKey(String id);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_contacts
     *
     * @mbggenerated Mon May 15 15:37:04 CST 2023
     */
    int updateByPrimaryKeySelective(Contacts record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_contacts
     *
     * @mbggenerated Mon May 15 15:37:04 CST 2023
     */
    int updateByPrimaryKey(Contacts record);


    int saveContact(Contacts contacts);

    //分页查询所有联系人信息
    int selectCountOfContactsByCondition(Map<String,Object> map);

    //查询条数
    List<Contacts> selectContactsByConditionForPage(Map<String,Object> map);

    //查询联系人基本信息
    List<Contacts> selectAllContactsBaseInfo();

    //安联系人名字模糊查询
    List<Contacts> selectContactByLikeName(String contactName);

    int insertContacts(Contacts contacts);

    int deleteContactsByCustomerIds(String[] ids);

    List<Contacts> selectContactsByCustomerIds(String[] ids);


}