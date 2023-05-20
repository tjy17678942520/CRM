package edu.beihua.crm.web.controller;

import edu.beihua.crm.Commons.Utils.DataUtls;
import edu.beihua.crm.Commons.Utils.UuidUtls;
import edu.beihua.crm.Commons.constant.ResultCode;
import edu.beihua.crm.Commons.domain.Result;
import edu.beihua.crm.model.Contacts;
import edu.beihua.crm.model.DicValue;
import edu.beihua.crm.model.User;
import edu.beihua.crm.service.ContactsService;
import edu.beihua.crm.service.DicValueService;
import edu.beihua.crm.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
public class ContactsController {

    @Autowired
    private ContactsService contactsService;

    @Autowired
    private UserService userService;

    @Autowired
    private DicValueService dicValueService;

    @RequestMapping("/workbench/contacts/index.do")
    public String toIndex(HttpServletRequest request){



        List<User> users = userService.queryAllUsers();
        request.setAttribute("users",users);

        List<DicValue> sourceList = dicValueService.queryDicValueByTypeCode("source");
        request.setAttribute("sourceList",sourceList);

        List<DicValue> appellation = dicValueService.queryDicValueByTypeCode("appellation");
        request.setAttribute("appellation",appellation);

        return "workbench/contacts/index";
    }

    @RequestMapping("/workbench/contacts/initData.do")
    @ResponseBody
    public Object initDataForPage(String owner,String fullname,String customerName,
                                  String source,String birthday,int beginNo,int pageSize){
        Map<String, Object> map = new HashMap<>();
        map.put("owner", owner);
        map.put("fullname", fullname);
        map.put("customerName", customerName);
        map.put("source", source);
        map.put("birthday", birthday);
        map.put("beginNo", (beginNo - 1) * pageSize);
        map.put("pageSize", pageSize);
        //查询联系人
        List<Contacts> contacts = contactsService.queryContactsByConditionForPage(map);
        int count = contactsService.queryCountOfContactsByCondition(map);

        Map<String, Object> resMap = new HashMap<>();
        resMap.put("contacts",contacts);
        resMap.put("count",count);

        return resMap;
    }

    //交易中查询 联系人基本信息
    @RequestMapping("workbench/contacts/queryAllContats.do")
    @ResponseBody
    public Object queryAllContats(){

        List<Contacts> contacts = contactsService.queryAllContactsBaseInfo();

        return contacts;
    }

    //交易中查询 联系人基本信息
    @RequestMapping("workbench/contacts/queryContatsByName.do")
    @ResponseBody
    public Object queryContatsByName(String ContactsName){
        //List<Contacts> contacts = contactsService.queryAllContactsBaseInfo();
        List<Contacts> contacts = contactsService.queryContactByLikeName(ContactsName);
        return contacts;
    }


    @RequestMapping("workbench/contacts/createContats.do")
    @ResponseBody
    public Object queryContatsByName(Contacts contacts, HttpSession session){

        Result res = new Result();
        try{
            contacts.setId(UuidUtls.getUUID());
            contacts.setCreateBy(((User) session.getAttribute(ResultCode.SYSTEMUSER)).getId());
            contacts.setCreateTime(DataUtls.fomatDateTime(new Date()));
            int contacts1 = contactsService.createContacts(contacts);
            if (contacts1>0){
                res.setCode(ResultCode.RESULT_CODE_SUCCESS);
            }else {
                res.setMsg("系统忙请稍后重试！");
                res.setCode(ResultCode.RESULT_CODE_FAIL);
            }
        }catch (Exception e){
            e.printStackTrace();
            res.setMsg("系统忙请稍后重试！");
            res.setCode(ResultCode.RESULT_CODE_FAIL);
        }
        return res;
    }

}
