package edu.beihua.crm.web.controller;

import edu.beihua.crm.model.DicValue;
import edu.beihua.crm.model.User;
import edu.beihua.crm.service.DicValueService;
import edu.beihua.crm.service.UserService;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.util.List;

@Controller
public class DicValueController {
    @Autowired
    private UserService userService;


    @Resource( name = "DicValueService")
    DicValueService dicValueService;


    @RequestMapping("/workbench/clue/index.do")
    public String index(HttpServletRequest request){
        //查询所有用户
        List<User> userList = userService.queryAllUsers();
        //查询称呼
        List<DicValue> appellation = dicValueService.queryDicValueByTypeCode("appellation");
        //查询线索laiyuan
        List<DicValue> source = dicValueService.queryDicValueByTypeCode("source");
        //查询线索状态
        List<DicValue> clueState = dicValueService.queryDicValueByTypeCode("clueState");

        request.setAttribute("userList",userList);
        request.setAttribute("appellation",appellation);
        request.setAttribute("source",source);
        request.setAttribute("clueState",clueState);

        return "workbench/clue/index";
    }
}
