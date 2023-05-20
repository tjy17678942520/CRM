package edu.beihua.crm.web.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class IndexController {

    @RequestMapping("/")
    public String Index(){
        //没有配置视图解析器 写完整资源 目录 由于有了视图解析器的前缀和后缀可以省略该部分
        return "index";
    }
}
