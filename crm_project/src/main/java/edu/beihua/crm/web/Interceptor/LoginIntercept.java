package edu.beihua.crm.web.Interceptor;

import edu.beihua.crm.Commons.constant.ResultCode;
import edu.beihua.crm.model.User;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@Component
public class LoginIntercept implements HandlerInterceptor {


    @Override
    public boolean preHandle(HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse, Object o) throws Exception {
        //获取session对象 判断该用户是否登录过
        HttpSession session = httpServletRequest.getSession();
        User user = (User) session.getAttribute(ResultCode.SYSTEMUSER);
        if (user == null) {
            httpServletResponse.sendRedirect("/"+ResultCode.SYSTEMNAME);
            return false;
        }

        return true;
    }

    @Override
    public void postHandle(HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse, Object o, ModelAndView modelAndView) throws Exception {

    }

    @Override
    public void afterCompletion(HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse, Object o, Exception e) throws Exception {

    }
}
