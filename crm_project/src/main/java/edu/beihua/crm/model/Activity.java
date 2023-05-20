package edu.beihua.crm.model;

public class Activity {
    /**
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column tbl_activity.id
     *
     * @mbggenerated Sun Feb 19 21:19:04 CST 2023
     */
    private String id;

    /**
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column tbl_activity.owner
     *
     * @mbggenerated Sun Feb 19 21:19:04 CST 2023
     */
    private String owner;

    /**
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column tbl_activity.name
     *
     * @mbggenerated Sun Feb 19 21:19:04 CST 2023
     */
    private String name;

    /**
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column tbl_activity.start_date
     *
     * @mbggenerated Sun Feb 19 21:19:04 CST 2023
     */
    private String startDate;

    /**
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column tbl_activity.end_date
     *
     * @mbggenerated Sun Feb 19 21:19:04 CST 2023
     */
    private String endDate;

    /**
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column tbl_activity.cost
     *
     * @mbggenerated Sun Feb 19 21:19:04 CST 2023
     */
    private String cost;

    /**
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column tbl_activity.description
     *
     * @mbggenerated Sun Feb 19 21:19:04 CST 2023
     */
    private String description;


    private String createTime;


    private String createBy;

    private String editTime;

    private String editBy;

    public Activity() {
    }

    public Activity(String id, String owner, String name, String startDate, String endDate, String cost, String description, String createTime, String createBy, String editTime, String editBy) {
        this.id = id;
        this.owner = owner;
        this.name = name;
        this.startDate = startDate;
        this.endDate = endDate;
        this.cost = cost;
        this.description = description;
        this.createTime = createTime;
        this.createBy = createBy;
        this.editTime = editTime;
        this.editBy = editBy;
    }

    @Override
    public String toString() {
        return "Activity{" +
                "id='" + id + '\'' +
                ", owner='" + owner + '\'' +
                ", name='" + name + '\'' +
                ", startDate='" + startDate + '\'' +
                ", endDate='" + endDate + '\'' +
                ", cost='" + cost + '\'' +
                ", description='" + description + '\'' +
                ", createTime='" + createTime + '\'' +
                ", createBy='" + createBy + '\'' +
                ", editTime='" + editTime + '\'' +
                ", editBy='" + editBy + '\'' +
                '}';
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id == null ? null : id.trim();
    }

    public String getOwner() {
        return owner;
    }

    public void setOwner(String owner) {
        this.owner = owner == null ? null : owner.trim();
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name == null ? null : name.trim();
    }

    public String getStartDate() {
        return startDate;
    }

    public void setStartDate(String startDate) {
        this.startDate = startDate == null ? null : startDate.trim();
    }


    public String getEndDate() {
        return endDate;
    }


    public void setEndDate(String endDate) {
        this.endDate = endDate == null ? null : endDate.trim();
    }


    public String getCost() {
        return cost;
    }


    public void setCost(String cost) {
        this.cost = cost == null ? null : cost.trim();
    }


    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description == null ? null : description.trim();
    }

    public String getCreateTime() {
        return createTime;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method sets the value of the database column tbl_activity.create_time
     *
     * @param createTime the value for tbl_activity.create_time
     *
     * @mbggenerated Sun Feb 19 21:19:04 CST 2023
     */
    public void setCreateTime(String createTime) {
        this.createTime = createTime == null ? null : createTime.trim();
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method returns the value of the database column tbl_activity.create_by
     *
     * @return the value of tbl_activity.create_by
     *
     * @mbggenerated Sun Feb 19 21:19:04 CST 2023
     */
    public String getCreateBy() {
        return createBy;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method sets the value of the database column tbl_activity.create_by
     *
     * @param createBy the value for tbl_activity.create_by
     *
     * @mbggenerated Sun Feb 19 21:19:04 CST 2023
     */
    public void setCreateBy(String createBy) {
        this.createBy = createBy == null ? null : createBy.trim();
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method returns the value of the database column tbl_activity.edit_time
     *
     * @return the value of tbl_activity.edit_time
     *
     * @mbggenerated Sun Feb 19 21:19:04 CST 2023
     */
    public String getEditTime() {
        return editTime;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method sets the value of the database column tbl_activity.edit_time
     *
     * @param editTime the value for tbl_activity.edit_time
     *
     * @mbggenerated Sun Feb 19 21:19:04 CST 2023
     */
    public void setEditTime(String editTime) {
        this.editTime = editTime == null ? null : editTime.trim();
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method returns the value of the database column tbl_activity.edit_by
     *
     * @return the value of tbl_activity.edit_by
     *
     * @mbggenerated Sun Feb 19 21:19:04 CST 2023
     */
    public String getEditBy() {
        return editBy;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method sets the value of the database column tbl_activity.edit_by
     *
     * @param editBy the value for tbl_activity.edit_by
     *
     * @mbggenerated Sun Feb 19 21:19:04 CST 2023
     */
    public void setEditBy(String editBy) {
        this.editBy = editBy == null ? null : editBy.trim();
    }
}