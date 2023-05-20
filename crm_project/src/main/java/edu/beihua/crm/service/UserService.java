package edu.beihua.crm.service;

import edu.beihua.crm.model.User;

import java.util.List;
import java.util.Map;

public interface UserService {
    User queryUserByNameAndPwd(Map<String,Object> map);

    List<User> queryAllUsers();
}
