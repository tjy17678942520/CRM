import com.alibaba.druid.support.json.JSONUtils;
import edu.beihua.crm.Commons.Utils.UuidUtls;
import edu.beihua.crm.model.Clue;
import edu.beihua.crm.service.ClueService;
import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.Arrays;
import java.util.UUID;

public class Main {


    @Test
    public void testq(){
        System.out.println(UUID.randomUUID());
        System.out.println(UuidUtls.getUUID());
    }
}
