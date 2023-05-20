package edu.beihua.crm.web.controller;

import edu.beihua.crm.Commons.Utils.DataUtls;
import edu.beihua.crm.Commons.Utils.UuidUtls;
import edu.beihua.crm.Commons.constant.ResultCode;
import edu.beihua.crm.Commons.domain.Result;
import edu.beihua.crm.model.Contacts;
import edu.beihua.crm.model.Customer;
import edu.beihua.crm.model.User;
import edu.beihua.crm.service.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
public class CustomerController {
    @Autowired
    private UserService userService;


    @Autowired
    private CustomerService customerService;

    @Autowired
    private CustomerRemarkService customerRemarkService;

    @Autowired
    private ContactsService contactsService;

    @Autowired
    private ContactsRemarkService contactsRemarkService;

    @Autowired ContactsActivityRelationService contactsActivityRelationService;





    @RequestMapping("/workbench/customer/toIndex.do")
    public String toIndex(HttpServletRequest request){
        List<User> users = userService.queryAllUsers();
        request.setAttribute("users",users);
        return "workbench/customer/index";
    }

    @RequestMapping("workbench/customer/createCustomer.do")
    @ResponseBody
    public Object createCustomer(String owner, String customerName,
                                 String websize, String phone,
                                 String contactSummary, String describe,
                                 String nextContactTime, String address,
                                 HttpSession session) {
        Customer customer = new Customer();

        customer.setId(UuidUtls.getUUID());
        customer.setOwner(owner);
        customer.setName(customerName);
        customer.setWebsite(websize);
        customer.setPhone(phone);
        customer.setContactSummary(contactSummary);
        customer.setDescription(describe);
        customer.setNextContactTime(nextContactTime);
        customer.setAddress(address);


        customer.setCreateBy(((User) session.getAttribute(ResultCode.SYSTEMUSER)).getId());
        customer.setCreateTime(DataUtls.fomatDateTime(new Date()));

        Result result = new Result();


        try{
           int i   = customerService.createCustomerCustomer(customer);
           if (i > 0){
               result.setCode(ResultCode.RESULT_CODE_SUCCESS);
           }else {
               result.setCode(ResultCode.RESULT_CODE_FAIL);
           }
        }catch (Exception e){
            e.printStackTrace();
            result.setCode(ResultCode.RESULT_CODE_FAIL);
        }
        return result;
    }



    @RequestMapping("/workbench/customer/initData.do")
    @ResponseBody
    public Object initData(String owner,String websize,String customerName,String phone,Integer pageSize,Integer beginNo){
        Map<String,Object> map = new HashMap<>();
        map.put("owner",owner);
        map.put("website",websize);
        map.put("customerName",customerName);
        map.put("phone",phone);
        map.put("pageSize",pageSize);
        map.put("beginNo",(beginNo-1) * pageSize);

        int i = customerService.queryAllCustomerCountByCondition(map);
        List<Customer> customerList = customerService.queryCustomerByConditionForPage(map);
        Map<String,Object> res = new HashMap<>();
        res.put("count",i);
        res.put("customerList",customerList);

        return res;
    }

    //修改
    @RequestMapping("/workbench/customer/modifyCustomer.do")
    @ResponseBody
    public Object modifyCustomer(Customer customer,HttpSession session){

        User user = (User) session.getAttribute(ResultCode.SYSTEMUSER);

        customer.setEditBy(user.getId());
        customer.setEditTime(DataUtls.fomatTime(new Date()));

        Result res = new Result();
        try {
            customerService.modifyCustomer(customer);
            res.setCode(ResultCode.RESULT_CODE_SUCCESS);
        }catch (Exception e){
            e.printStackTrace();
            res.setCode(ResultCode.RESULT_CODE_FAIL);
            res.setMsg("系统忙请稍后重试");
        }

        return res;
    }

    //删除
    @RequestMapping("/workbench/customer/deleteCustomer.do")
    @ResponseBody
    public Object deleteCustomer(String[] ids){
        Result result = new Result();
        try {
            //删除客户
            customerService.deleteCustomerByIds(ids);
            //删除客户下的所有备注(根据客户id去删除)
            customerRemarkService.deleteCustomerRemarkByIds(ids);

            //查询联系人的id(用于删除备注)
            List<Contacts> contacts = contactsService.queryContactsByCustomerIds(ids);
            //删除联系人备注
            String[] cids = new String[contacts.size()];
            for (int i = 0; i < contacts.size(); i++) {
                cids[i] = contacts.get(0).getId();
            }
            contactsRemarkService.deleteClueRemarkByContactsIds(cids);
            //删除市场联系人与市场活动的关系(通过联系人去删除)
            contactsActivityRelationService.deleteContactsActivityRelationByContactsIds(ids);
            //删除联系人（更具客户id去删除）
            contactsService.deleteContactsByCustomerIds(ids);
            //删除联系人下的备注
            contactsRemarkService.deleteClueRemarkByContactsIds(cids);
        }catch (Exception e){
            e.printStackTrace();
            result.setCode(ResultCode.RESULT_CODE_FAIL);
            result.setMsg("系统忙！请稍后重试！");
        }
        return result;
    }
}
