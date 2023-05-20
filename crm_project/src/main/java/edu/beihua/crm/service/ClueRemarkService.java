package edu.beihua.crm.service;

import edu.beihua.crm.model.Clue;
import edu.beihua.crm.model.ClueRemark;

import java.util.List;

public interface ClueRemarkService {
    List<ClueRemark> queryClueRemarkForDetailByClueId(String clueId);

    //添加
    int addClueRemark(ClueRemark clueRemark);

    //删除
    int deleltClueRemark(String id);

    //更新
    int editClueById(ClueRemark clueRemark);

    List<ClueRemark> queryClueRemarkForDetailByClueIdToCustomRemark(String clueid);

    int deleteOneClueRemark(String clueId);
}
