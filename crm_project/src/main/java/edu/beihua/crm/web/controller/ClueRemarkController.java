package edu.beihua.crm.web.controller;

import edu.beihua.crm.Commons.Utils.DataUtls;
import edu.beihua.crm.Commons.Utils.UuidUtls;
import edu.beihua.crm.Commons.constant.ResultCode;
import edu.beihua.crm.Commons.domain.Result;
import edu.beihua.crm.model.ActivityRemark;
import edu.beihua.crm.model.ClueRemark;
import edu.beihua.crm.model.User;
import edu.beihua.crm.service.ClueRemarkService;
import edu.beihua.crm.service.ClueService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.Date;

@Controller
public class ClueRemarkController {
    @Autowired
    private ClueRemarkService clueRemarkService;

    @RequestMapping("workbench/clue/savaClueRemark.do")
    @ResponseBody
    public Object savaClueRemark(ClueRemark clueRemark, HttpServletRequest request){
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute(ResultCode.SYSTEMUSER);
        clueRemark.setId(UuidUtls.getUUID());
        clueRemark.setCreateBy(user.getId());
        clueRemark.setCreateTime(DataUtls.fomatDateTime(new Date()));
        clueRemark.setEditFlag(ResultCode.ACTIVITY_REMARK_NO_EDIT);


        Result result = new Result();
        try {
            int i = clueRemarkService.addClueRemark(clueRemark);
            if (i > 0){
                result.setCode(ResultCode.RESULT_CODE_SUCCESS);
                result.setOtherDate(clueRemark);
            }else {
                result.setMsg("系统忙请稍后重试……");
                result.setCode(ResultCode.RESULT_CODE_FAIL);
            }
        }catch (Exception e){
            e.printStackTrace();
            result.setMsg("系统忙请稍后重试……");
            result.setCode(ResultCode.RESULT_CODE_FAIL);
        }

        return result;
    }

    @RequestMapping("workbench/clue/deleteClueRemark.do")
    public @ResponseBody Object  deleteActivityRemark(String id){
        Result result = new Result();
        try {
            int i = clueRemarkService.deleltClueRemark(id);
            if (i > 0){
                result.setCode(ResultCode.RESULT_CODE_SUCCESS);
            }else {
                result.setCode(ResultCode.RESULT_CODE_FAIL);
                result.setMsg("系统忙！请稍后重试！");
            }
        }catch (Exception e){
            e.printStackTrace();
            result.setCode(ResultCode.RESULT_CODE_FAIL);
            result.setMsg("系统忙！请稍后重试！");
        }
        return result;
    }


    @RequestMapping("workbench/clue/editClueRemark.do")
    public @ResponseBody Object  editActivityRemark(ClueRemark remark, HttpSession session){

        User user = (User) session.getAttribute(ResultCode.SYSTEMUSER);
        remark.setEditBy(user.getId());
        remark.setEditTime(DataUtls.fomatDateTime(new Date()));
        remark.setEditFlag(ResultCode.ACTIVITY_REMARK_YES_EDIT);

        Result result = new Result();
        try {
            int i = clueRemarkService.editClueById(remark);
            if (i > 0){
                result.setCode(ResultCode.RESULT_CODE_SUCCESS);
                remark.setEditBy(user.getName());
                result.setOtherDate(remark);
            }else {
                result.setCode(ResultCode.RESULT_CODE_FAIL);
                result.setMsg("系统忙！请稍后重试！");
            }
        }catch (Exception e){
            e.printStackTrace();
            result.setCode(ResultCode.RESULT_CODE_FAIL);
            result.setMsg("系统忙！请稍后重试！");
        }
        return result;
    }
}
