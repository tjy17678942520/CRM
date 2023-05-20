package edu.beihua.crm.service;

import edu.beihua.crm.model.ClueActivityRelation;

import java.util.List;

public interface ContactsActivityRelationService {
    int copyContactsActivityFromClueActivity(List<ClueActivityRelation> activityRelationList);

    int deleteContactsActivityRelationByContactsIds(String[] ids);
}
