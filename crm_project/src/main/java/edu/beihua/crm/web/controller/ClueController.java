package edu.beihua.crm.web.controller;

import edu.beihua.crm.Commons.Utils.DataUtls;
import edu.beihua.crm.Commons.Utils.UuidUtls;
import edu.beihua.crm.Commons.constant.ResultCode;
import edu.beihua.crm.Commons.domain.Result;
import edu.beihua.crm.mapper.DicValueMapper;
import edu.beihua.crm.model.*;
import edu.beihua.crm.service.ActivityService;
import edu.beihua.crm.service.ClueRemarkService;
import edu.beihua.crm.service.ClueService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.*;

@Controller
public class ClueController {

    @Autowired
    private ClueRemarkService clueRemarkService;

    @Autowired
    private ClueService clueService;

    @Autowired
    private ActivityService activityService;

    @Autowired
    private DicValueMapper dicValueMapper;

    //创建线索
    @RequestMapping("/workbench/clue/createClue.do")
    @ResponseBody
    public Object createClue(Clue clue, HttpServletRequest request){

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute(ResultCode.SYSTEMUSER);
        Result res = new Result();

        clue.setId(UuidUtls.getUUID());
        clue.setCreateTime(DataUtls.fomatDateTime(new Date()));
        clue.setCreateBy(user.getId());

        try{
            int i = clueService.savaCreateClude(clue);
            if (i > 0){
                res.setCode(ResultCode.RESULT_CODE_SUCCESS);
            }else {
                res.setCode(ResultCode.RESULT_CODE_FAIL);
                res.setMsg("系统忙请稍后重试！");
            }
        }catch (Exception e){
            e.printStackTrace();
            res.setCode(ResultCode.RESULT_CODE_FAIL);
            res.setMsg("系统忙请稍后重试！");
        }
        return res;
    }

    //查询线索
    @RequestMapping("/workbench/clue/queryAllClueByByConditionForPage.do")
    @ResponseBody
    public Object queryAllClueByByConditionForPage(String fullname,String company, String phone,
                                                   String source, String owner,String mphone,String state,Integer pageNo,Integer pageSize){


        System.out.println(fullname);
        System.out.println(owner);

        Map<String,Object> map = new HashMap<>();
        map.put("fullname",fullname);
        map.put("company",company);
        map.put("phone",phone);
        map.put("mphone",mphone);
        map.put("source",source);
        map.put("owner",owner);
        map.put("state",state);
        //每页显示的条数等于 页号-1 * 每页显示条数
        map.put("beginNo",((pageNo-1)*pageSize));
        map.put("pageSize",pageSize);

        List<Clue> clueList = clueService.queryAllClueByByConditionForPage(map);
        int i = clueService.queryAllClueCountByByConditionForPage(map);

        Map<String,Object> res = new HashMap<>();
        res.put("clueList",clueList);
        res.put("clueCount",i);

        return res;

    }

    //修改先索
    @RequestMapping("/workbench/clue/editClue.do")
    @ResponseBody
    public Object editClue(Clue clue,HttpServletRequest request){
        Result res = new Result();

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute(ResultCode.SYSTEMUSER);

        //设置修改人 修改时间
        clue.setEditBy(user.getId());
        clue.setEditTime(DataUtls.fomatDateTime(new Date()));

        try {
            int i = clueService.editClueByCluesId(clue);
            if (i > 0){
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


    //修改前根据 id查看线索
    @RequestMapping("/workbench/clue/queryClueById.do")
    @ResponseBody
    public Object queryClueById(String id){
        Clue clue = clueService.queryClueByid(id);
        return clue;
    }

    //删除线索信息
    @RequestMapping("workbench/deleteClueByIds.do")
    @ResponseBody
    public Object deleteClueByIds(String[] ids){
        Result res = new Result();
        try {
            int i = clueService.deleteClueByIds(ids);
            if (i > 0){
                res.setCode(ResultCode.RESULT_CODE_SUCCESS);
            }else {
                res.setCode(ResultCode.RESULT_CODE_FAIL);
                res.setMsg("系统忙请稍后重试！");
            }
        }catch (Exception e){
            res.setCode(ResultCode.RESULT_CODE_FAIL);
            res.setMsg("系统忙请稍后重试！");
            e.printStackTrace();
        }

        return res;
    }

    //详细界面 根据id查看线索明细
    @RequestMapping("/workbench/clue/detailClue.do")
    public String detailClue(String clueId,HttpServletRequest request){
        //查找当前线索明细
        Clue clue = clueService.queryDetailClueById(clueId);
        //查询当前线索的所有评论
        List<ClueRemark> clueRemarks = clueRemarkService.queryClueRemarkForDetailByClueId(clueId);
        //查看与该线索相关的所有活动
        List<Activity> activityList = activityService.queryActivityRelationClueByclueId(clueId);

        request.setAttribute("clue",clue);
        request.setAttribute("clueRemarks",clueRemarks);
        request.setAttribute("activityList",activityList);

        return "workbench/clue/detail";
    }

    //点击关联市场活动进行一次数据请求  查询所有未与该线索关联的市场活动
    //查看所有未与该线索关联的全部市场活动
    @RequestMapping("/workbench/clue/ClickCreateRelationClueAndActivity.do")
    @ResponseBody
    public Object cancelClueRelationActivity(String clueId) {
        List<Activity> activityList1 = activityService.queryAllActivityForDetaiByClueId(clueId);
        return activityList1;
    }

    //取消市场活动与线索的关系
    @RequestMapping("/workbench/clue/cancelClueRelationActivity.do")
    @ResponseBody
    public Object cancelClueRelationActivity(String clueId,String activityId){
        Result res = new Result();
        try {
            int i = clueService.cancelClueRelationActivity(clueId, activityId);
            if (i > 0){
                res.setCode(ResultCode.RESULT_CODE_SUCCESS);
            }else {
                res.setCode(ResultCode.RESULT_CODE_FAIL);
                res.setMsg("系统忙请稍后重试！");
            }
        }catch (Exception e){
            e.printStackTrace();
            res.setCode(ResultCode.RESULT_CODE_FAIL);
            res.setMsg("系统忙请稍后重试！");
        }

        return res;
    }

    //查询所有未与clueId关联的市场活动
    @RequestMapping(value = "/workbench/clue/ClueRelatedAllMarkets.do",method = RequestMethod.POST)
    @ResponseBody
    public Object ClueRelatedAllMarkets(String clueId,String activityName){
        Map<String,String> map = new HashMap<>();
        map.put("clueId",clueId);
        map.put("activityName",activityName);
        List<Activity> activityList = activityService.queryActivityForDetaiByNameClueId(map);
        return activityList;
    }

    //批量添加市场活动与线索关系
    @RequestMapping(value = "/workbench/clue/addClueRelationActivity.do",method = RequestMethod.POST)
    @ResponseBody
    public Object addClueRelationActivity(String[] activityIds,String clueId){

        List<ClueActivityRelation> activityRelationList = new ArrayList<>();

        ClueActivityRelation CAR = null;
        for (String ai:activityIds
             ) {
            CAR = new ClueActivityRelation();
            CAR.setId(UuidUtls.getUUID());
            CAR.setClueId(clueId);
            CAR.setActivityId(ai);
            activityRelationList.add(CAR);
        }

        Result result = new Result();
        try {
            //添加关系
            int i = clueService.addActivtiyAndClue(activityRelationList);
            if (i > 0) {
                result.setCode(ResultCode.RESULT_CODE_SUCCESS);
                //查看与该线索相关的所有活动
                List<Activity> activityList = activityService.queryActivityRelationClueByclueId(clueId);
                result.setOtherDate(activityList);
            }else {
                result.setMsg("系统忙请稍后重试！");
                result.setCode(ResultCode.RESULT_CODE_FAIL);
            }
        }catch (Exception e){
            e.printStackTrace();
            result.setMsg("系统忙请稍后重试！");
            result.setCode(ResultCode.RESULT_CODE_FAIL);
        }
       return result;
    }

    @RequestMapping("/workbench/clue/toConvert.do")
    public String toConvert(String id,HttpServletRequest request){

        Clue clue = clueService.queryDetailClueById(id);

        List<DicValue> stage = dicValueMapper.selectDicValueByTypeCode("stage");

        request.setAttribute("clue",clue);
        request.setAttribute("stage",stage);

        return "workbench/clue/convert";
    }

    @RequestMapping("/workbench/clue/saveConvertClue.do")
    public @ResponseBody Object saveConvertClue(String name,String clueId,String money,String stage,String expectedDate,
                                                String activityId,boolean isCreateTran,HttpSession session){
       //封装参数
        Map<String,Object> map = new HashMap<>();
        map.put("clueId",clueId);
        map.put("name",name);
        map.put("money",money);
        map.put("stage",stage);
        map.put("expectedDate",expectedDate);
        map.put("activityId",activityId);
        map.put("isCreateTran",isCreateTran);
        map.put(ResultCode.SYSTEMUSER,session.getAttribute(ResultCode.SYSTEMUSER));

        Result result = new Result();
        try {
            clueService.saveConvert(map);
            result.setCode(ResultCode.RESULT_CODE_SUCCESS);
        }catch (Exception e){
            e.printStackTrace();
            result.setCode(ResultCode.RESULT_CODE_FAIL);
            result.setMsg("系统忙请稍后重试！");
        }

        return result;
    }
}
