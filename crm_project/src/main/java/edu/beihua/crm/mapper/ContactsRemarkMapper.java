package edu.beihua.crm.mapper;

import edu.beihua.crm.model.ClueRemark;
import edu.beihua.crm.model.ContactsRemark;

import java.util.List;

public interface ContactsRemarkMapper {
    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_contacts_remark
     *
     * @mbggenerated Mon May 15 22:23:23 CST 2023
     */
    int deleteByPrimaryKey(String id);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_contacts_remark
     *
     * @mbggenerated Mon May 15 22:23:23 CST 2023
     */
    int insert(ContactsRemark record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_contacts_remark
     *
     * @mbggenerated Mon May 15 22:23:23 CST 2023
     */
    int insertSelective(ContactsRemark record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_contacts_remark
     *
     * @mbggenerated Mon May 15 22:23:23 CST 2023
     */
    ContactsRemark selectByPrimaryKey(String id);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_contacts_remark
     *
     * @mbggenerated Mon May 15 22:23:23 CST 2023
     */
    int updateByPrimaryKeySelective(ContactsRemark record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_contacts_remark
     *
     * @mbggenerated Mon May 15 22:23:23 CST 2023
     */
    int updateByPrimaryKey(ContactsRemark record);

    //线索备注转入客户备注
    int insertFromClueRemark(List<ClueRemark> clueRemarks);

    int deleteByContactsIds(String[] ids);
}