package edu.beihua.crm.web.controller;



import edu.beihua.crm.Commons.Utils.DataUtls;
import edu.beihua.crm.Commons.Utils.HSSFUtils;
import edu.beihua.crm.Commons.Utils.UuidUtls;
import edu.beihua.crm.Commons.constant.ResultCode;
import edu.beihua.crm.Commons.domain.Result;
import edu.beihua.crm.model.Activity;
import edu.beihua.crm.model.ActivityRemark;
import edu.beihua.crm.model.User;
import edu.beihua.crm.service.ActivityRemarkService;
import edu.beihua.crm.service.ActivityService;
import edu.beihua.crm.service.UserService;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import javax.annotation.Resource;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.http.HttpRequest;
import java.util.*;

@Controller
public class ActivityController {

    @Resource(name = "userService")
    private UserService userService;

    @Autowired
    private ActivityService activityService;


    @Autowired
    private ActivityRemarkService activityRemarkService;







    /**
     * 请求转发发到 市场活动主页面
     * @return
     */
    @RequestMapping("/workbench/activity/index.do")
    public String toActiveIndex(HttpServletRequest request){
        List<User> users = userService.queryAllUsers();
        request.setAttribute("userlist",users);

        return "workbench/activity/index";

    }


    /**
     * 保存创建的市场活动
     */
    @RequestMapping("/workbench/activity/savaCreateActivity.do")
    public @ResponseBody Object savaCreateActivity(Activity activity, HttpSession session){
        activity.setId(UuidUtls.getUUID());
        activity.setCreateTime(DataUtls.fomatDateTime(new Date()));
        //补充参数
        User sysUser  = (User)session.getAttribute(ResultCode.SYSTEMUSER);
        activity.setCreateBy(sysUser.getId());

        Result result = new Result();
        try {
            int res = activityService.insertActivity(activity);
            if (res>0) {
                result.setCode(ResultCode.RESULT_CODE_SUCCESS);
            }else {
                result.setCode(ResultCode.RESULT_CODE_FAIL);
                result.setMsg("系统忙....请稍后重试！");
            }
        }catch (Exception e){
            e.printStackTrace();
            result.setCode(ResultCode.RESULT_CODE_FAIL);
            result.setMsg("系统忙....请稍后重试！");
        }

        return  result;

    }

    /**
     * 条件查询
     * @param name
     * @param owner
     * @param startDate
     * @param endDate
     * @param pageNo
     * @param pageSize
     * @return
     */
    @RequestMapping("/workbench/activity/queryAtivtyByConditionForPage.do")
    public @ResponseBody Object queryAtivtyByConditionForPage(String name,String owner,String startDate,String endDate,int pageNo,int pageSize){
        Map<String, Object> map = new HashMap<>();
        map.put("name",name);
        map.put("owner",owner);
        map.put("startDate",startDate);
        map.put("endDate",endDate);
        map.put("beginNo",((pageNo-1)*pageSize));
        map.put("pageSize",pageSize);

        List<Activity> activities = activityService.queryActivityByConditionForPage(map);


        int i = activityService.queryCountOfActivityByCondition(map);

        HashMap<String, Object> res = new HashMap<>();
        res.put("activities",activities);
        res.put("count",i);

        return res;

    }

    //查询全部市场活动
    @RequestMapping("/workbench/activity/queryAtivtys.do")
    @ResponseBody
    public Object queryAtivtys(){
        List<Activity> activityList = activityService.queryAllActivitys();
        return activityList;
    }

    //通过活动名称模糊查询市场活动
    @RequestMapping("/workbench/activity/queryAtivtysByLikeName.do")
    @ResponseBody
    public Object queryAtivtysByLikeName(String activityName){
        List<Activity> activityList = activityService.queryAtivtysByLikeName(activityName);
        return activityList;
    }

    /**
     * 多选删除市场活动信息
     * @param ids
     * @return
     */
    @RequestMapping("/workbench/deleteActivityByIds.do")
    @ResponseBody
    public Object deleteActivityByIds(String[] ids) {
        Result result = new Result();
        try {

            int i = activityService.deleteAcyivityByIds(ids);

            if (i != 0) {
                result.setCode(ResultCode.RESULT_CODE_SUCCESS);
            } else {
                result.setCode(ResultCode.RESULT_CODE_FAIL);
                result.setMsg("系统繁忙。请稍后重试！");
            }
        } catch (Exception e) {
            e.printStackTrace();
            result.setCode(ResultCode.RESULT_CODE_FAIL);
            result.setMsg("系统繁忙。请稍后重试！");
        }
        return result;
    }

    /**
     * 预更新查询
     * @param id
     * @return
     */
    @RequestMapping("/workbench/queryActivityById.do")
    public @ResponseBody Object queryActivityById(String id){
        Activity activity = activityService.queryActivityById(id);
        return activity;
    }

    /**
     * 更新市场活动
     * @param activity
     * @param session
     * @return
     */
    @RequestMapping("/workbench/updataActivity.do")
    @ResponseBody
    public Object updataActivity(Activity activity,HttpSession session){
        //设置修改时间
        activity.setEditTime(DataUtls.fomatDateTime(new Date()));
        //绑定当前修改人
        User user = (User) session.getAttribute(ResultCode.SYSTEMUSER);
        activity.setEditBy(user.getId());
        //更新成功后 重新查询该信息返回
        Result result = new Result();
       try {
           int i = activityService.updateActivityByActivity(activity);
           if (i > 0){
               result.setCode(ResultCode.RESULT_CODE_SUCCESS);
               result.setOtherDate(activityService.queryActivityById(activity.getId()));
           }else {
               result.setCode(ResultCode.RESULT_CODE_FAIL);
               result.setMsg("系统出错,请稍后重试！");
           }
       }catch (Exception e){
           e.printStackTrace();
           result.setCode(ResultCode.RESULT_CODE_FAIL);
           result.setMsg("系统出错,请稍后重试！");
       }
        return result;
    }

    /**
     * 导出所有市场活动
     * @param response
     */
    @RequestMapping("/workbench/fileDownLoad.do")
    public void  fileDownLoad(HttpServletResponse response,HttpServletRequest request){
        //设置响应的类型
        response.setContentType("application/octet-stream;charset=UTF-8");
        //设置响应的文件名和后缀 禁止浏览器直接打开 而是打开下载窗口
        response.addHeader("Content-Disposition","attachment;filename="+ UuidUtls.getUUID() +".xls");
       try {
           //查询拿到市场活动数据
           List<Activity> activities = activityService.selectAllActivity();
           exportFileActivity(activities,response,request,false);
       }catch (Exception e){
           e.printStackTrace();
       }
    }

    //批量导出
    //设置导出格式，并添加导出内容。将XSSFWorkbook对象保存到session中，并返回结果给jsp
    @RequestMapping("/workbench/ConditionalBatchExport.do")
    public  @ResponseBody Object ConditionalBatchExport(String[] ids,HttpServletResponse response,HttpServletRequest request){
        //查询拿到市场活动数据
        List<Activity> activities = activityService.selectActivityByIds(ids);
        Result result = new Result();
        if (activities!= null && activities.size() > 0){
            exportFileActivity(activities,response,request,true);
            result.setCode(ResultCode.RESULT_CODE_SUCCESS);
        }else {
            result.setCode(ResultCode.RESULT_CODE_FAIL);
            result.setMsg("系统出错！下载失败！");
        }
        return result;
    }

    //下载文件，并删除session中的XSSFWorkbook对象
    @RequestMapping("downloadExcel_d")
    public void downloadExcel_d(HttpServletRequest request,HttpServletResponse response) {
        //设置响应的类型
        response.setContentType("application/octet-stream;charset=UTF-8");
        //设置响应的文件名和后缀 禁止浏览器直接打开 而是打开下载窗口
        response.addHeader("Content-Disposition","attachment;filename="+ UuidUtls.getUUID() +".xls");

        try {
            HSSFWorkbook wb = (HSSFWorkbook) request.getSession().getAttribute("XSSFWorkbook");
            //删除Session中的文件
            request.getSession().removeAttribute("XSSFWorkbook");
            wb.write(response.getOutputStream());
            response.getOutputStream().flush();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    //下载市场导入模板
    @RequestMapping("/workbench/downLoadExcelTemplate.do")
    public void downLoadExcelTemplate(HttpServletResponse response){
        //设置响应的类型
        response.setContentType("application/octet-stream;charset=UTF-8");
        //设置响应的文件名和后缀 禁止浏览器直接打开 而是打开下载窗口
        response.addHeader("Content-Disposition","attachment;filename="+ UuidUtls.getUUID() +".xls");

        //建立表格 创建一个HSSFWorkbook对应一个excel文件
        HSSFWorkbook wb = new HSSFWorkbook();
        //创建Sheel页面
        HSSFSheet sheet = wb.createSheet("市场活动数据模板");
        //创建标题行
        HSSFRow row = sheet.createRow(0);
        String[] strTitlle = new String[]{"序号","活动名称","开始日期","结束日期","成本费用","活动描述"};
        for (int i = 0; i < strTitlle.length; i++) {
            row.createCell(i).setCellValue(strTitlle[i]);
        }
        //写入模板数据
        row = sheet.createRow(1);
        int j = 0;
        row.createCell(j++).setCellValue(1);
        row.createCell(j++).setCellValue("xxxx");
        row.createCell(j++).setCellValue("2023-05-02");
        row.createCell(j++).setCellValue("2023-05-05");
        row.createCell(j++).setCellValue(5900);
        row.createCell(j).setCellValue("xxxxxxx");

        try {
            ServletOutputStream outputStream = response.getOutputStream();
            wb.write(outputStream);
            outputStream.flush();
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }

    /**
     * 导入市场数据
     * @param file
     * @param session
     * @return
     */
    @RequestMapping("/workbench/importActivities.do")
    @ResponseBody
    public Object importActivities(MultipartFile file,HttpSession session){

        InputStream ins = null;
        HSSFWorkbook wb = null;
        List<Activity> activityList = new ArrayList<>();
        Result result = new Result();
        try {
           ins = file.getInputStream();
           //直接从流中读取excel文件
           wb = new HSSFWorkbook(ins);
           HSSFSheet sheet = wb.getSheetAt(0);
            User sysuser = (User) session.getAttribute(ResultCode.SYSTEMUSER);
            HSSFRow row = null;
            HSSFCell cell = null;
            for (int i = 1; i <= sheet.getLastRowNum(); i++) {
                //获取一条记录
                row = sheet.getRow(i);
                Activity activity = new Activity();
                activity.setId(UuidUtls.getUUID());
                activity.setOwner(sysuser.getId());
                activity.setCreateTime(DataUtls.fomatDateTime(new Date()));
                activity.setCreateBy(sysuser.getId());
                for (int j = 1; j < row.getLastCellNum(); j++) {
                    cell = row.getCell(j);
                    String value = HSSFUtils.getCellValueForString(cell);
                    switch (j){
                        case 1:
                            activity.setName(value);
                            break;
                        case 2:
                            activity.setStartDate(value);
                            break;
                        case 3:
                            activity.setEndDate(value);
                            break;
                        case 4:
                            activity.setCost(value);
                            break;
                        case 5:
                            activity.setDescription(value);
                        default:
                            break;
                    }
                }
                //将记录放入数组
                activityList.add(activity);
            }
            try{
                int i = activityService.saveCreateActivityByList(activityList);
                if (i >= 0){
                    result.setCode(ResultCode.RESULT_CODE_SUCCESS);
                    //成功返回成功的记录条数
                    result.setOtherDate(i);
                    result.setMsg("已成功导入"+i+"条市场活动记录！");
                }
            }catch (Exception e){
                result.setCode(ResultCode.RESULT_CODE_FAIL);
                result.setMsg("系统繁忙！请稍后重试！");
                e.printStackTrace();
            }


        } catch (IOException e) {
            throw new RuntimeException(e);
        }
        return result;
    }

    //查询市场活动详细信息
    @RequestMapping("/workbench/activity/detailActivity.do")
    public String detailActivity(String id, HttpServletRequest request){
        //查询市场活动信息
        Activity activity = activityService.queryActivityForDetail(id);
        //查询市场活动详细评论(备注信息)
        List<ActivityRemark> activityRemarks = activityRemarkService.queryActivityRemarkForDetailByActivityId(id);

        request.setAttribute("activity",activity);
        request.setAttribute("activityRemarks",activityRemarks);
        return "workbench/activity/detail";
    }

    /**
     * 导出市场活动表
     * @param activities
     * @param response
     */
    private void exportFileActivity(List<Activity> activities,HttpServletResponse response,HttpServletRequest request,boolean isBachExport) {
        HSSFWorkbook wb = null;
        if (activities != null && activities.size() > 0){
            //建立表格 创建一个HSSFWorkbook对应一个excel文件
            wb = new HSSFWorkbook();
            //创建Sheel页面
            HSSFSheet sheet = wb.createSheet("市场活动数据");
            //创建标题行
            HSSFRow row = sheet.createRow(0);
            String[] strTitlle = new String[]{"序号","负责人","活动名称","开始日期","结束日期","成本费用","活动描述","创建者","创建日期","修改日期","修改人"};
            for (int i = 0; i < strTitlle.length; i++) {
                row.createCell(i).setCellValue(strTitlle[i]);
            }

            //写入数据
            Activity activity = null;
            for (int i = 0; i < activities.size(); i++) {
                row = sheet.createRow(i+1);
                activity = activities.get(i);
                int j = 0;
                row.createCell(j++).setCellValue(i+1);
                row.createCell(j++).setCellValue(activity.getOwner());
                row.createCell(j++).setCellValue(activity.getName());
                row.createCell(j++).setCellValue(activity.getStartDate());
                row.createCell(j++).setCellValue(activity.getEndDate());
                row.createCell(j++).setCellValue(activity.getCost());
                row.createCell(j++).setCellValue(activity.getDescription());
                row.createCell(j++).setCellValue(activity.getCreateBy());
                row.createCell(j++).setCellValue(activity.getCreateTime());
                row.createCell(j++).setCellValue(activity.getEditTime());
                row.createCell(j).setCellValue(activity.getEditBy());

            }
        }

        //ajax批量导出 不需要写入responce输出流
        if (isBachExport){
            HttpSession session = request.getSession();
            session.setAttribute("XSSFWorkbook",wb);
        }else {
            //从响应对象中获取输出流
            OutputStream os = null;
            try {
                os = response.getOutputStream();
                wb.write(os);
                os.flush();
                wb.close();
            } catch (IOException e) {
                throw new RuntimeException(e);
            }
        }

    }

}
