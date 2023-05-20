package edu.beihua.crm.service;

import edu.beihua.crm.model.Customer;

import java.util.List;
import java.util.Map;

public interface CustomerService {

    int queryAllCustomerCountByCondition(Map<String,Object> map);

    List<Customer> queryCustomerByConditionForPage(Map<String,Object> map);

    int createCustomerCustomer(Customer customer);

    //更新
    int modifyCustomer(Customer customer);

    //删除
    int deleteCustomerByIds(String[] ids);
}
