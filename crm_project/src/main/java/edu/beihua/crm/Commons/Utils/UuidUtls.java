package edu.beihua.crm.Commons.Utils;

import java.util.UUID;

public class UuidUtls {
    public static String getUUID(){
        UUID uuid = UUID.randomUUID();
        return uuid.toString().replaceAll("-","");
    }
}
