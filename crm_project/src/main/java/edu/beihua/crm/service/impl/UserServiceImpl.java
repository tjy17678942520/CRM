package edu.beihua.crm.service.impl;

import edu.beihua.crm.mapper.UserMapper;
import edu.beihua.crm.model.User;
import edu.beihua.crm.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service("userService")
public class UserServiceImpl implements UserService {
    //自动注入按照类型注入ByType，
    @Autowired
    private UserMapper userMapper;

    /**
     * 根据账号密码查询用户
     * @param map
     * @return
     */
    @Override
    public User queryUserByNameAndPwd(Map<String, Object> map) {
        return userMapper.selectUserByNameAndPwd(map);
    }

    /**
     * 查询所有用户
     * @return
     */
    @Override
    public List<User> queryAllUsers() {
        List<User> usersList = userMapper.selelctAllUsers();
        return usersList;
    }
}
