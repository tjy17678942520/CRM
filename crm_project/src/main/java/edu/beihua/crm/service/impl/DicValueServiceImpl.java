package edu.beihua.crm.service.impl;


import edu.beihua.crm.mapper.DicValueMapper;
import edu.beihua.crm.model.DicValue;
import edu.beihua.crm.service.DicValueService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service("DicValueService")
public class DicValueServiceImpl implements DicValueService {

    @Autowired
    private DicValueMapper dicValueMapper;

    //查询市场线索子字典值
    @Override
    public List<DicValue> queryDicValueByTypeCode(String typeCode) {
        return dicValueMapper.selectDicValueByTypeCode(typeCode);
    }
}
