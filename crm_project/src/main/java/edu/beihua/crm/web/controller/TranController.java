package edu.beihua.crm.web.controller;

import edu.beihua.crm.Commons.domain.Result;
import edu.beihua.crm.model.Activity;
import edu.beihua.crm.model.DicValue;
import edu.beihua.crm.model.User;
import edu.beihua.crm.service.ActivityService;
import edu.beihua.crm.service.DicValueService;
import edu.beihua.crm.service.TransService;
import edu.beihua.crm.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.util.List;

@Controller
public class TranController {

    @Autowired
    private TransService transService;

    @Autowired
    private DicValueService dicValueService;

    @Autowired
    private UserService userService;

    @Autowired
    private ActivityService activityService;


    @RequestMapping("/workbench/transaction/toIndex.do")
    public String index(HttpServletRequest request){
        List<User> users = userService.queryAllUsers();
        List<DicValue> transactionType = dicValueService.queryDicValueByTypeCode("transactionType");
        List<DicValue> source = dicValueService.queryDicValueByTypeCode("source");
        List<DicValue> stage = dicValueService.queryDicValueByTypeCode("stage");
        request.setAttribute("users",users);
        request.setAttribute("transactionType",transactionType);
        request.setAttribute("stage",stage);
        request.setAttribute("source",source);
        return "workbench/transaction/index";
    }


    @RequestMapping("/workbench/transaction/save.do")
    public String saveTrans(HttpServletRequest request){

        List<User> users = userService.queryAllUsers();
        List<DicValue> stage = dicValueService.queryDicValueByTypeCode("stage");
        List<DicValue> transactionType = dicValueService.queryDicValueByTypeCode("transactionType");
        List<DicValue> source = dicValueService.queryDicValueByTypeCode("source");

        request.setAttribute("users",users);
        request.setAttribute("stage",stage);
        request.setAttribute("transactionType",transactionType);
        request.setAttribute("source",source);


        return "workbench/transaction/save";
    }

    @RequestMapping("/workbench/transaction/edit.do")
    public String eidtTrans(HttpServletRequest request){

        List<User> users = userService.queryAllUsers();
        List<DicValue> stage = dicValueService.queryDicValueByTypeCode("stage");
        List<DicValue> transactionType = dicValueService.queryDicValueByTypeCode("transactionType");
        List<DicValue> source = dicValueService.queryDicValueByTypeCode("source");

        request.setAttribute("users",users);
        request.setAttribute("stage",stage);
        request.setAttribute("transactionType",transactionType);
        request.setAttribute("source",source);


        return "workbench/transaction/edit";
    }

    @RequestMapping("/workbench/transaction/queryAllActivity.do")
    @ResponseBody
    public Object queryAllActivity(){

        List<Activity> activityList = activityService.queryAllActivitys();


        return activityList;
    }
}
