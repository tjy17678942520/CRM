package edu.beihua.crm.service;


import edu.beihua.crm.model.DicValue;

import java.util.List;

public interface DicValueService {
   List<DicValue> queryDicValueByTypeCode(String typeCode);
}
