package edu.beihua.crm.service.impl;

import edu.beihua.crm.mapper.CustomerMapper;
import edu.beihua.crm.model.Customer;
import edu.beihua.crm.service.CustomerService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service("CustomerService")
public class CustomerServiceImpl implements CustomerService {

    @Autowired
    private CustomerMapper customerMapper;

    @Override
    public int queryAllCustomerCountByCondition(Map<String, Object> map) {
        return customerMapper.selectAllCustomerCountByCondition(map);
    }

    @Override
    public List<Customer> queryCustomerByConditionForPage(Map<String, Object> map) {
        return customerMapper.selectCustomerByConditionForPage(map);
    }

    @Override
    public int createCustomerCustomer(Customer customer) {
        return customerMapper.saveCustomer(customer);
    }

    @Override
    public int modifyCustomer(Customer customer) {
        return customerMapper.updateByPrimaryKey(customer);
    }

    @Override
    public int deleteCustomerByIds(String[] ids) {
        return customerMapper.deleteByIds(ids);
    }
}
