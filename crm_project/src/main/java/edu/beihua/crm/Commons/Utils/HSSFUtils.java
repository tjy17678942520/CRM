package edu.beihua.crm.Commons.Utils;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFDataFormatter;
import org.apache.poi.hssf.usermodel.HSSFDateUtil;

import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * excel 操作工具类
 */
public class HSSFUtils {
    public static String getCellValueForString(HSSFCell cell){
        int ty = cell.getCellType();
        if (ty == HSSFCell.CELL_TYPE_STRING){
            return cell.getStringCellValue();
        }else if (ty == HSSFCell.CELL_TYPE_NUMERIC){
            String value = "";
            if (HSSFDateUtil.isCellDateFormatted(cell)) {// 日期类型
                // 短日期转化为字符串
                Date date = cell.getDateCellValue();
                if (date != null) {
                    // 标准0点 1970/01/01 08:00:00
                    if (date.getTime() % 86400000 == 16 * 3600 * 1000 && cell.getCellStyle().getDataFormat() == 14) {
                        value = new SimpleDateFormat("yyyy-MM-dd").format(date);
                    } else {
                        value = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(date);
                    }
                }
            } else {// 数值
                //System.out.println("Value:"+cell.getNumericCellValue());
                String numberStr = new HSSFDataFormatter().formatCellValue(cell);
                // 货币格式，如：1,200.00
                if (numberStr.contains(",")) {
                    numberStr = numberStr.replace(",", "");
                }
                if (numberStr.contains("E")) {    // 科学计算法
                    numberStr = new DecimalFormat("0").format(cell.getNumericCellValue());    //4.89481368464913E14还原为长整数
                    value = Long.parseLong(numberStr)+"";
                } else {
                    if (numberStr.contains(".")) {    // 小数
                        value = Double.parseDouble(numberStr) + "";
                    } else {    // 转换为整数
                        value = Long.parseLong(numberStr)+ "";
                    }
                }
            }
            return value;
        }else if (ty == HSSFCell.CELL_TYPE_BOOLEAN){

            return cell.getBooleanCellValue()+"";
        } else if (ty == HSSFCell.CELL_TYPE_FORMULA) {
            return cell.getCellFormula();
        }else {
            return "";
        }
    }
}
