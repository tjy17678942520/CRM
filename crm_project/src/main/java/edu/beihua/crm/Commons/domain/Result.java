package edu.beihua.crm.Commons.domain;

public class Result {
    private String code;
    private String msg;

    private Object otherDate;

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getMsg() {
        return msg;
    }

    public void setMsg(String msg) {
        this.msg = msg;
    }

    public Object getOtherDate() {
        return otherDate;
    }

    public void setOtherDate(Object otherDate) {
        this.otherDate = otherDate;
    }
}
