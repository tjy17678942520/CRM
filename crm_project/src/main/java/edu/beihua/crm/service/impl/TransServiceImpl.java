package edu.beihua.crm.service.impl;

import edu.beihua.crm.mapper.TranMapper;
import edu.beihua.crm.model.Tran;
import edu.beihua.crm.service.TransService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service("TransService")
public class TransServiceImpl implements TransService {

    @Autowired
    public TranMapper tranMapper;

    //创建交易
    @Override
    public int addTrans(Tran tran) {
        return tranMapper.insert(tran);
    }
}
