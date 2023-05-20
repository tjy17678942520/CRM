package edu.beihua.crm.web.controller;

import edu.beihua.crm.Commons.Utils.DataUtls;
import edu.beihua.crm.Commons.constant.ResultCode;
import edu.beihua.crm.Commons.domain.Result;
import edu.beihua.crm.model.User;
import edu.beihua.crm.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

@Controller
public class UserController {

    @Autowired
    private UserService userService;

    @RequestMapping("/settings/qx/user/toLogin.do")
    public String toLogin(){
        return "settings/qx/user/login";
    }

    @RequestMapping("/settings/qx/user/login.do")
    public @ResponseBody Object login(String loginAct, String loginPwd, boolean isRemPwd, HttpServletRequest request, HttpSession session, HttpServletResponse response){
        //封装参数
        Map<String,Object> map = new HashMap<String, Object>();

        map.put("loginAct",loginAct);
        map.put("loginPwd",loginPwd);

        //查询用户信息
        User user = userService.queryUserByNameAndPwd(map);
        //根据用户信息生成响应内容
        Result res = new Result();
        if (user == null) {
            //账号或密码错误
            res.setCode(ResultCode.RESULT_CODE_FAIL);
            res.setMsg("账号或密码错误！");
        }else {
            //判断账户是否过期
            String newDate = DataUtls.fomatDateTime(new Date());
            if(user.getExpireTime().compareTo(newDate)<0){
                //账户已过期
                res.setCode(ResultCode.RESULT_CODE_FAIL);
                res.setMsg("账户已过期，请联系管理员！");
            }else {
                //判断用户状态是否被锁定
                if (user.getLockState().equals(ResultCode.USER_LockState)){
                    //账号已被锁定，请联系管理员
                    res.setCode(ResultCode.RESULT_CODE_FAIL);
                    res.setMsg("账号已被锁定，请联系管理员！");
                }else {
                    //判断ip是否被允许
                    //获取客户端ip
                    String clientIp = request.getRemoteAddr();
                    if(!user.getAllowIps().contains(clientIp)){
                        //ip受限制，请检查网络环境
                        res.setCode(ResultCode.RESULT_CODE_FAIL);
                        res.setMsg("ip受限制，请检查网络环境");
                    }else{
                        //登录成功
                        res.setCode(ResultCode.RESULT_CODE_SUCCESS);
                        //将用户放入session对象方便作为系统验证拦截 功能的实现
                        session.setAttribute(ResultCode.SYSTEMUSER,user);

                        //判断是否记住密码
                        if (isRemPwd){

                            //生成Cookie对象e
                            Cookie c1 = new Cookie("loginAct", user.getLoginAct());
                            Cookie c2 = new Cookie("loginPwd", user.getLoginPwd());
                            c1.setMaxAge(10*24*60*60);
                            c2.setMaxAge(10*24*60*60);
                            response.addCookie(c1);
                            response.addCookie(c2);
                        }else {
                            //生成Cookie对象
                            Cookie c1 = new Cookie("loginAct", user.getLoginAct());
                            Cookie c2 = new Cookie("loginPwd", user.getLoginPwd());
                            //不记住密码通知浏览器将cookie对象销毁
                            c1.setMaxAge(0);
                            c2.setMaxAge(0);
                            response.addCookie(c1);
                            response.addCookie(c2);
                        }
                    }
                }
            }
        }

        return res;
    }

    /**
     * 退出功能：消除账号信息 消除会话对象
     * @param session
     * @param response
     * @return
     */
    @RequestMapping("/settings/qx/user/loginOut.do")
    public String loginOut(HttpSession session,HttpServletResponse response){
        //清空cookie
        Cookie c1 = new Cookie("loginAct", "1");
        Cookie c2 = new Cookie("loginPwd", "1");
        c1.setMaxAge(0);
        c2.setMaxAge(0);
        response.addCookie(c1);
        response.addCookie(c2);
        //销毁seesion
        session.invalidate();
        //借助springmvc来重定向，借助框架翻译成response.sendRedirection("/项目名字“）
        return "redirect:/";
    }




}
