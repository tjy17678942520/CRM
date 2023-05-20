package edu.beihua.crm.service.impl;

import edu.beihua.crm.Commons.Utils.DataUtls;
import edu.beihua.crm.Commons.Utils.UuidUtls;
import edu.beihua.crm.Commons.constant.ResultCode;
import edu.beihua.crm.mapper.*;
import edu.beihua.crm.model.*;
import edu.beihua.crm.service.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;
import java.util.Map;

@Service("ClueService")
public class ClueServiceImpl implements ClueService {
    @Autowired
    private ClueMapper clueMapper;

    @Autowired
    private CustomerMapper customerMapper;

    @Autowired
    private ContactsMapper contactsMapper;

    @Autowired
    private ClueActivityRelationMapper clueActivityRelationMapper;


    @Autowired
    private TransService transService;


    @Autowired
    private ClueRemarkMapper clueRemarkMapper;

    @Autowired
    private CustomerRemarkService customerRemarkService;

    @Autowired
    private ContactsRemarkService contactsRemarkService;

    @Autowired
    private ClueActivityRelationService clueActivityRelationService;

    @Autowired
    private ContactsActivityRelationService contactsActivityRelationService;


    @Autowired
    private TransRemark transRemark;

    @Autowired
    private ClueRemarkService clueRemarkService;

    @Autowired
    private ClueService clueService;




    //创建线索活动
    @Override
    public int savaCreateClude(Clue clue) {
        return clueMapper.insertClude(clue);
    }

    @Override
    public List<Clue> queryAllClueByByConditionForPage(Map<String, Object> map) {
        return clueMapper.selectAllClueByByConditionForPage(map);
    }

    @Override
    public int queryAllClueCountByByConditionForPage(Map<String, Object> map) {
        return clueMapper.selectCountOfClueByCondition(map);
    }

    //更新市场活动
    @Override
    public int editClueByCluesId(Clue clue) {
        return clueMapper.updateClue(clue);
    }

    //修改查询id
    @Override
    public Clue queryClueByid(String clue) {
        return clueMapper.selectByPrimaryKey(clue);
    }

    @Override
    public int deleteClueByIds(String[] ids) {
        return clueMapper.deleteByIds(ids);
    }

    //详细查询
    @Override
    public Clue queryDetailClueById(String clueId) {
        return clueMapper.selectClueDetailById(clueId);
    }

    //取消线索与市场活动关联关系
    @Override
    public int cancelClueRelationActivity(String clueId, String activityId) {
        return clueMapper.cancelClueRelationActivity(clueId,activityId);
    }

    //添加线索市场关联关系
    @Override
    public int addActivtiyAndClue(List<ClueActivityRelation> activityRelationList) {
        return clueActivityRelationMapper.insertActivtiyAndClue(activityRelationList);
    }

    //保存线索转换信息
    @Override
    public void saveConvert(Map<String,Object> map) {
        //查询线索信息
        String clueId = (String) map.get("clueId");
        Clue clue = clueMapper.selectClueDetailByIdForConvert(clueId);
        User user = (User) map.get(ResultCode.SYSTEMUSER);

        //把该线索中有关公司的信息转换到客户表中
        Customer customer = new Customer();
        customer.setId(UuidUtls.getUUID());
        customer.setAddress(clue.getAddress());
        customer.setContactSummary(clue.getContactSummary());
        customer.setWebsite(clue.getWebsite());
        customer.setPhone(clue.getPhone());
        customer.setNextContactTime(clue.getNextContactTime());
        customer.setCreateBy(user.getId());
        customer.setCreateTime(DataUtls.fomatDateTime(new Date()));
        customer.setDescription(clue.getDescription());
        customer.setName(clue.getCompany());
        customer.setOwner(clue.getOwner());
        //保存客户信息
        customerMapper.saveCustomer(customer);

        //把该线索中有关个人的信息转换到联系人表中
        Contacts contacts = new Contacts();

        contacts.setId(UuidUtls.getUUID());
        contacts.setAddress(clue.getAddress());
        contacts.setContactSummary(clue.getContactSummary());
        contacts.setDescription(clue.getDescription());
        contacts.setNextContactTime(clue.getNextContactTime());
        contacts.setCreateBy(clue.getCreateBy());
        contacts.setAppellation(clue.getAppellation());
        contacts.setEmail(clue.getEmail());
        contacts.setJob(clue.getJob());
        contacts.setFullname(clue.getFullname());
        contacts.setOwner(clue.getOwner());
        contacts.setSource(clue.getSource());
        contacts.setMphone(clue.getMphone());
        contacts.setCustomerId(customer.getId());
        contacts.setCreateTime(customer.getCreateTime());

        contactsMapper.saveContact(contacts);

        //根据线索id查询所有的与该线索相关的所有备注
        List<ClueRemark> clueRemarks = clueRemarkMapper.selectClueRemarkForDetailByClueIdToCustomRemark(clueId);

        if (!clueRemarks.isEmpty()){
            for (ClueRemark cR: clueRemarks
            ) {
                cR.setClueId(customer.getId());
            }
            customerRemarkService.resaveClueRemarkToCustomerRemark(clueRemarks);

            //把该线索下所有的备注转换到联系人备注表中一份 只有线索id为联系人id就可以
            for (ClueRemark cR: clueRemarks
            ) {
                cR.setClueId(contacts.getId());
            }
            contactsRemarkService.resaveClueRemarkToContactsRemark(clueRemarks);
        }

        //根据clueId查询该线索和市场活动的关联关系
        List<ClueActivityRelation> activityRelationList = clueActivityRelationService.queryActivtiyRelationClue(clueId);
        if (!activityRelationList.isEmpty()){
            for (ClueActivityRelation CAR:activityRelationList
            ) {
                CAR.setClueId(contacts.getId());
            }

            //把该线索和市场活动的关联关系 转换到 联系人和市场活动的关联关系表中
            contactsActivityRelationService.copyContactsActivityFromClueActivity(activityRelationList);
        }

        //如果需要创建交易，则往交易表中添加一条记录
        Boolean isCreateTran = (Boolean) map.get("isCreateTran");
        if (isCreateTran){

            Tran tran = new Tran();

            String tranname = (String) map.get("name");

            tran.setId(UuidUtls.getUUID());
            tran.setCreateBy(user.getId());
            tran.setCreateTime(DataUtls.fomatDateTime(new Date()));
            tran.setName(tranname);
            tran.setMoney(((String) map.get("money")));
            tran.setStage(((String) map.get("stage")));
            tran.setExpectedDate(((String) map.get("expectedDate")));
            tran.setActivityId(((String) map.get("activityId")));
            tran.setOwner(user.getId());
            tran.setCustomerId(customer.getId());
            tran.setContactsId(contacts.getId());

            transService.addTrans(tran);

           if (!clueRemarks.isEmpty()){
               //如果需要创建交易，则还需要把该线索下所有的备注转换到交易备注表中一份
               for (ClueRemark cR: clueRemarks
               ) {
                   cR.setClueId(tran.getId());
               }
               transRemark.copyRemarkFromClueRemark(clueRemarks);
           }
        }

        //删除该线索下所有的备注
        clueRemarkService.deleteOneClueRemark(clueId);

        //删除该线索和市场活动的关联关系
        clueActivityRelationService.deleteRelationByClueId(clueId);
        //删除该线索
        clueService.deleteClueByIds(new String[]{clueId});
    }


}
