package edu.beihua.crm.web.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class MainController {
    @RequestMapping("/workbench/main/index.do")
    public String toMianIndex(){
        return "workbench/main/index";
    }
}
