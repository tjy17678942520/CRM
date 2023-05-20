package edu.beihua.crm.Commons;

import org.apache.poi.hssf.usermodel.*;
import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.ss.usermodel.HorizontalAlignment;

import java.io.*;

public class Apache_POI {
    public static void main(String[] args) {
        //创建HSSFWorkbook对象，对应一个excel文件
        HSSFWorkbook wb = new HSSFWorkbook();
        //创建sheet页面
        HSSFSheet sheet = wb.createSheet("学生列表");
        //创建行 使用sheet创建HSSFRow对象，对应sheet中的一行
        HSSFRow row = sheet.createRow(0);//行号：从0 开始，依次增加
        //使用行对象 创建HSSFCell列对象，对应行row中的列
        HSSFCell cell = row.createCell(0);//列的编号：从0开始，依次增加
        cell.setCellValue("学号");

        cell = row.createCell(1);
        cell.setCellValue("姓名");

        cell = row.createCell(2);
        cell.setCellValue("年龄");

        cell = row.createCell(3);
        cell.setCellValue("班级");

        HSSFCellStyle cellStyle = wb.createCellStyle();
                      cellStyle.setAlignment(HorizontalAlignment.CENTER);
                      cellStyle.setTopBorderColor(HSSFColor.RED.index);

        for (int i = 1; i < 11 ; i++) {
            row = sheet.createRow(i);

             cell = row.createCell(0);
             cell.setCellStyle(cellStyle);
             cell.setCellValue(101+i);

            cell = row.createCell(1);
            cell.setCellValue("TomCAT LINA"+i);

            cell = row.createCell(2);
            cell.setCellValue(20+i);

            cell = row.createCell(3);
            cell.setCellValue("A"+i);

        }

        //调用工具函数生成excel文件
        FileOutputStream of = null;
        try {
            //目录必须实现存在 否者会出错
           of =  new FileOutputStream("E:\\实习技术复习\\CRM\\crm_project\\src\\test\\java\\student.xls");
           wb.write(of);
        } catch (FileNotFoundException e) {
            throw new RuntimeException(e);
        } catch (IOException e) {
            throw new RuntimeException(e);
        }

    }
}
