package edu.beihua.crm.Commons.constant;


public class ResultCode {
    public static final String RESULT_CODE_SUCCESS = "1";
    public static final String RESULT_CODE_FAIL = "0";

    //当前账户的状态1表示没有锁定 0锁定
    public static final String USER_LockState ="0";
    public static final String USER_LockState_NONE ="1";

    //当前登录用户
    public static  final  String SYSTEMUSER = "sessionUser";

    //系统名称
    public static final String SYSTEMNAME = "crm";

    //市场活动备注记录
    public static final String ACTIVITY_REMARK_NO_EDIT = "0";
    public static final String ACTIVITY_REMARK_YES_EDIT = "1";
}
