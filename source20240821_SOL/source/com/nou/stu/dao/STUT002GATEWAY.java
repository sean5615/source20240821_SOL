package com.nou.stu.dao;

import java.lang.reflect.Method;
import java.sql.Connection;
import java.util.Hashtable;
import java.util.Vector;

import com.acer.apps.Page;
import com.acer.db.DBManager;
import com.acer.db.query.DBResult;
import com.acer.util.Utility;
import com.nou.pop.signup.tool.Transformer;
import com.nou.sol.signup.po.SignupInfo;

/*
 * (STUT002) Gateway/*
 *-------------------------------------------------------------------------------*
 * Author    : 國長      2007/05/04
 * Modification Log :
 * Vers     Date           By             Notes
 *--------- -------------- -------------- ----------------------------------------
 * V0.0.1   2007/05/04     國長           建立程式
 *                                        新增 getStut002ForUse(Hashtable ht)
 * V0.0.2   2007/06/08     ALANPENG       新增 getStuName(String stno)
 * V0.0.3   2007/06/29     芳如           新增 getStuBaseData(Hashtable ht)
 * V0.0.4   2007/07/03     芳如           修改 getStuBaseData(Hashtable ht)
 * V0.0.5   2007/07/10     poto           新增 doExportstut005(Hashtable ht)
 * V0.0.6   2007/08/31     poto           新增 getStuData(Hashtable ht,Vector vt) 架構調整
 *                                        新增 getStuData2(Hashtable ht,Vector vt) 架構調整
 *                                        新增 getStuData3(Hashtable ht,Vector vt) 架構調整
 *                                        新增 getStut003Query(Hashtable ht) 架構調整
 * V0.0.7	2007/09/05		tonny		  新增 stu303r_1(Hashtable ht) 架構調整
 * 										  新增 stu304r_1(Hashtable ht) 架構調整
 * V0.0.8	2007/09/07		tonny		  新增 stu303r_1(Hashtable ht) 架構調整
 * V0.0.9   2007/09/07      poto          新增 getStut007QueryEditSTNO(Hashtable ht) 架構調整
 * V0.0.10  2007/09/10     芳如           新增 getStu309rPrint(Hashtable ht)
 * V0.0.11  2007/09/12     芳如           修改 getStu309rPrint(Hashtable ht)
 * V0.0.12   2007/08/31     poto          新增 getStut003QueryEdit(String idno,String name) 架構調整
 * V0.0.13  2007/09/20      poto          新增 getStuData1(Hashtable ht,Vector vt) 架構調整
 * V0.0.14  2007/11/26      shony         新增getStut002SignupInfo(String idno)
 * V0.0.15  2007/12/04      shony         新增getStut002Stut003Query(String stno)
 * V0.0.16  2007/12/04      sorge         新增getStu013mQuery(Vector vt, Hashtable ht)
 * V0.0.17  2008/04/09      lin           修改 getStuData3(Hashtable ht,Vector vt), 增加查詢出 ENROLL_STATUS, DBMAJOR_MK, FTSTUD_ENROLL_AYEARSMS
 *--------------------------------------------------------------------------------
 */
public class STUT002GATEWAY {

    /** 資料排序方式 */
    private String orderBy = "";
    private DBManager dbmanager = null;
    private Connection conn = null;
    /* 頁數 */
    private int pageNo = 0;
    /** 每頁筆數 */
    private int pageSize = 0;

    /** 記錄是否分頁 */
    private boolean pageQuery = false;

    /** 用來存放 SQL 語法的物件 */
    private StringBuffer sql = new StringBuffer();

    /** <pre>
     *  設定資料排序方式.
     *  Ex: "AYEAR, SMS DESC"
     *      先以 AYEAR 排序再以 SMS 倒序序排序
     *  </pre>
     */
    public void setOrderBy(String orderBy) {
        if(orderBy == null) {
            orderBy = "";
        }
        this.orderBy = orderBy;
    }

    /** 取得總筆數 */
    public int getTotalRowCount() {
        return Page.getTotalRowCount();
    }

    /** 不允許建立空的物件 */
    private STUT002GATEWAY() {}

    /** 建構子，查詢全部資料用 */
    public STUT002GATEWAY(DBManager dbmanager, Connection conn) {
        this.dbmanager = dbmanager;
        this.conn = conn;
    }

    /** 建構子，查詢分頁資料用 */
    public STUT002GATEWAY(DBManager dbmanager, Connection conn, int pageNo, int pageSize) {
        this.dbmanager = dbmanager;
        this.conn = conn;
        this.pageNo = pageNo;
        this.pageSize = pageSize;
        pageQuery = true;
    }

    /**
     * 
     * @param ht 條件值
     * @return 回傳 Vector 物件，內容為 Hashtable 的集合，<br>
     *         每一個 Hashtable 其 KEY 為欄位名稱，KEY 的值為欄位的值<br>
     *         若該欄位有中文名稱，則其 KEY 請加上 _NAME, EX: SMS 其中文欄位請設為 SMS_NAME
     * @throws Exception
     */
    public Vector getStut002ForUse(Hashtable ht) throws Exception {
        if(ht == null) {
            ht = new Hashtable();
        }
        Vector result = new Vector();
        if(sql.length() > 0) {
            sql.delete(0, sql.length());
        }
        sql.append(
            "SELECT S02.IDNO, S02.BIRTHDATE, S02.NAME, S02.ENG_NAME, S02.ALIAS, S02.SEX, S02.SELF_IDENTITY_SEX, S02.NATIONCODE, S02.BIRTHPLACE, S02.PASSPORT_NO, S02.VOCATION, S02.EDUBKGRD_GRADE, S02.AREACODE_OFFICE, S02.TEL_OFFICE, S02.TEL_OFFICE_EXT, S02.AREACODE_HOME, S02.TEL_HOME, S02.FAX_AREACODE, S02.FAX_TEL, S02.MOBILE, S02.MARRIAGE, S02.DMSTADDR, S02.DMSTADDR_ZIP, S02.CRRSADDR_ZIP, S02.CRRSADDR, S02.EMAIL, S02.SPECIAL_MK, S02.EMRGNCY_TEL, S02.EMRGNCY_RELATION, S02.EMRGNCY_NAME, S02.UPD_MK, S02.UPD_RMK, S02.UPD_DATE, S02.UPD_TIME, S02.UPD_USER_ID, S02.ROWSTAMP, S02.NEWNATION, S02.RE_IDENTIFY_YYMM, S02.IS_DATE_MK, S02.RMK " +
            "FROM STUT002 S02 " +
            "WHERE 1 = 1 "
        );
        if(!Utility.nullToSpace(ht.get("IDNO")).equals("")) {
            sql.append("AND S02.IDNO = '" + Utility.nullToSpace(ht.get("IDNO")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("BIRTHDATE")).equals("")) {
            sql.append("AND S02.BIRTHDATE = '" + Utility.nullToSpace(ht.get("BIRTHDATE")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("NAME")).equals("")) {
            sql.append("AND S02.NAME = '" + Utility.nullToSpace(ht.get("NAME")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("ENG_NAME")).equals("")) {
            sql.append("AND S02.ENG_NAME = '" + Utility.nullToSpace(ht.get("ENG_NAME")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("ALIAS")).equals("")) {
            sql.append("AND S02.ALIAS = '" + Utility.nullToSpace(ht.get("ALIAS")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("SEX")).equals("")) {
            sql.append("AND S02.SEX = '" + Utility.nullToSpace(ht.get("SEX")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("SELF_IDENTITY_SEX")).equals("")) {
            sql.append("AND S02.SELF_IDENTITY_SEX = '" + Utility.nullToSpace(ht.get("SELF_IDENTITY_SEX")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("NATIONCODE")).equals("")) {
            sql.append("AND S02.NATIONCODE = '" + Utility.nullToSpace(ht.get("NATIONCODE")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("BIRTHPLACE")).equals("")) {
            sql.append("AND S02.BIRTHPLACE = '" + Utility.nullToSpace(ht.get("BIRTHPLACE")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("PASSPORT_NO")).equals("")) {
            sql.append("AND S02.PASSPORT_NO = '" + Utility.nullToSpace(ht.get("PASSPORT_NO")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("VOCATION")).equals("")) {
            sql.append("AND S02.VOCATION = '" + Utility.nullToSpace(ht.get("VOCATION")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("EDUBKGRD_GRADE")).equals("")) {
            sql.append("AND S02.EDUBKGRD_GRADE = '" + Utility.nullToSpace(ht.get("EDUBKGRD_GRADE")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("AREACODE_OFFICE")).equals("")) {
            sql.append("AND S02.AREACODE_OFFICE = '" + Utility.nullToSpace(ht.get("AREACODE_OFFICE")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("TEL_OFFICE")).equals("")) {
            sql.append("AND S02.TEL_OFFICE = '" + Utility.nullToSpace(ht.get("TEL_OFFICE")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("TEL_OFFICE_EXT")).equals("")) {
            sql.append("AND S02.TEL_OFFICE_EXT = '" + Utility.nullToSpace(ht.get("TEL_OFFICE_EXT")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("AREACODE_HOME")).equals("")) {
            sql.append("AND S02.AREACODE_HOME = '" + Utility.nullToSpace(ht.get("AREACODE_HOME")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("TEL_HOME")).equals("")) {
            sql.append("AND S02.TEL_HOME = '" + Utility.nullToSpace(ht.get("TEL_HOME")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("FAX_AREACODE")).equals("")) {
            sql.append("AND S02.FAX_AREACODE = '" + Utility.nullToSpace(ht.get("FAX_AREACODE")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("FAX_TEL")).equals("")) {
            sql.append("AND S02.FAX_TEL = '" + Utility.nullToSpace(ht.get("FAX_TEL")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("MOBILE")).equals("")) {
            sql.append("AND S02.MOBILE = '" + Utility.nullToSpace(ht.get("MOBILE")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("MARRIAGE")).equals("")) {
            sql.append("AND S02.MARRIAGE = '" + Utility.nullToSpace(ht.get("MARRIAGE")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("DMSTADDR")).equals("")) {
            sql.append("AND S02.DMSTADDR = '" + Utility.nullToSpace(ht.get("DMSTADDR")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("DMSTADDR_ZIP")).equals("")) {
            sql.append("AND S02.DMSTADDR_ZIP = '" + Utility.nullToSpace(ht.get("DMSTADDR_ZIP")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("CRRSADDR_ZIP")).equals("")) {
            sql.append("AND S02.CRRSADDR_ZIP = '" + Utility.nullToSpace(ht.get("CRRSADDR_ZIP")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("CRRSADDR")).equals("")) {
            sql.append("AND S02.CRRSADDR = '" + Utility.nullToSpace(ht.get("CRRSADDR")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("EMAIL")).equals("")) {
            sql.append("AND S02.EMAIL = '" + Utility.nullToSpace(ht.get("EMAIL")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("SPECIAL_MK")).equals("")) {
            sql.append("AND S02.SPECIAL_MK = '" + Utility.nullToSpace(ht.get("SPECIAL_MK")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("EMRGNCY_TEL")).equals("")) {
            sql.append("AND S02.EMRGNCY_TEL = '" + Utility.nullToSpace(ht.get("EMRGNCY_TEL")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("EMRGNCY_RELATION")).equals("")) {
            sql.append("AND S02.EMRGNCY_RELATION = '" + Utility.nullToSpace(ht.get("EMRGNCY_RELATION")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("EMRGNCY_NAME")).equals("")) {
            sql.append("AND S02.EMRGNCY_NAME = '" + Utility.nullToSpace(ht.get("EMRGNCY_NAME")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("UPD_MK")).equals("")) {
            sql.append("AND S02.UPD_MK = '" + Utility.nullToSpace(ht.get("UPD_MK")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("UPD_RMK")).equals("")) {
            sql.append("AND S02.UPD_RMK = '" + Utility.nullToSpace(ht.get("UPD_RMK")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("UPD_DATE")).equals("")) {
            sql.append("AND S02.UPD_DATE = '" + Utility.nullToSpace(ht.get("UPD_DATE")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("UPD_TIME")).equals("")) {
            sql.append("AND S02.UPD_TIME = '" + Utility.nullToSpace(ht.get("UPD_TIME")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("UPD_USER_ID")).equals("")) {
            sql.append("AND S02.UPD_USER_ID = '" + Utility.nullToSpace(ht.get("UPD_USER_ID")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("ROWSTAMP")).equals("")) {
            sql.append("AND S02.ROWSTAMP = '" + Utility.nullToSpace(ht.get("ROWSTAMP")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("NEWNATION")).equals("")) {
            sql.append("AND S02.NEWNATION = '" + Utility.nullToSpace(ht.get("NEWNATION")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("RE_IDENTIFY_YYMM")).equals("")) {
            sql.append("AND S02.RE_IDENTIFY_YYMM = '" + Utility.nullToSpace(ht.get("RE_IDENTIFY_YYMM")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("IS_DATE_MK")).equals("")) {
            sql.append("AND S02.IS_DATE_MK = '" + Utility.nullToSpace(ht.get("IS_DATE_MK")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("RMK")).equals("")) {
            sql.append("AND S02.RMK = '" + Utility.nullToSpace(ht.get("RMK")) + "' ");
        }

        if(!orderBy.equals("")) {
            String[] orderByArray = orderBy.split(",");
            for(int i = 0; i < orderByArray.length; i++) {
                orderByArray[i] = "S02." + orderByArray[i].trim();

                if(i == 0) {
                    orderBy += "ORDER BY ";
                } else {
                    orderBy += ", ";
                }
                orderBy += orderByArray[i].trim();
            }
            sql.append(orderBy.toUpperCase());
            orderBy = "";
        }

        DBResult rs = null;
        try {
            if(pageQuery) {
                // 依分頁取出資料
                rs = Page.getPageResultSet(dbmanager, conn, sql.toString(), pageNo, pageSize);
            } else {
                // 取出所有資料
                rs = dbmanager.getSimpleResultSet(conn);
                rs.open();
                rs.executeQuery(sql.toString());
            }
            Hashtable rowHt = null;
            while (rs.next()) {
                rowHt = new Hashtable();
                /** 將欄位抄一份過去 */
                for (int i = 1; i <= rs.getColumnCount(); i++)
                    rowHt.put(rs.getColumnName(i), rs.getString(i));

                result.add(rowHt);
            }
        } catch (Exception e) {
            throw e;
        } finally {
            if(rs != null) {
                rs.close();
            }
        }
        return result;
    }



    /**
     * 取得學生基本資料及學籍資料
     * @param ht 條件值
     * @return 回傳 Vector 物件，內容為 Hashtable 的集合，<br>
     *         每一個 Hashtable 其 KEY 為欄位名稱，KEY 的值為欄位的值<br>
     *         若該欄位有中文名稱，則其 KEY 請加上 _NAME, EX: SMS 其中文欄位請設為 SMS_NAME
     * @throws Exception
     */
    public Vector getStuData(Hashtable ht) throws Exception {
        if(ht == null) {
            ht = new Hashtable();
        }
        Vector result = new Vector();
        if(sql.length() > 0) {
            sql.delete(0, sql.length());
        }
        java.text.SimpleDateFormat dateTimeFormat = new java.text.SimpleDateFormat("yyyyMMdd");
    	java.util.Calendar cal = java.util.Calendar.getInstance();
    	String today = dateTimeFormat.format(cal.getTime());
        com.acer.log.MyLogger logger = new com.acer.log.MyLogger("STUT002M");
        com.acer.db.DBManager dbManager1 = new com.acer.db.DBManager(logger);
    	com.nou.sys.SYSGETSMSDATA sys = new com.nou.sys.SYSGETSMSDATA(dbManager1);
    	sys.setSYS_DATE(today);
    	// 1.當期 2.前期 3.後期 4.前學年 5.後學年
    	sys.setSMS_TYPE("1");
    	//result=1表成功,-1表示失敗
    	int a = sys.execute();
    	//設定參數,移至下頁時可用之參數,因此利用sys取得學年學期來作為參數,sms:學期,ayear:學年
    	String AYEAR = "";
    	String SMS = "";
    	if(a == 1) {
           AYEAR= sys.getAYEAR();
           SMS = sys.getSMS();
    	}

        sql.append(
            "SELECT S01.CODE_NAME AS ENROLL_NAME ,S02.IDNO, S02.BIRTHDATE, S02.NAME, S02.ENG_NAME, S02.ALIAS, S02.SEX, S02.SELF_IDENTITY_SEX, S02.NATIONCODE, S02.NEWNATION, S02.BIRTHPLACE, S02.PASSPORT_NO, S02.VOCATION, S02.EDUBKGRD_GRADE, S02.AREACODE_OFFICE, S02.TEL_OFFICE, S02.TEL_OFFICE_EXT, S02.AREACODE_HOME, S02.TEL_HOME, S02.FAX_AREACODE, S02.FAX_TEL, S02.MOBILE, S02.MARRIAGE, S02.DMSTADDR, S02.DMSTADDR_ZIP, S02.CRRSADDR_ZIP, S02.CRRSADDR, S02.EMAIL, S02.SPECIAL_MK, S02.EMRGNCY_TEL, S02.EMRGNCY_RELATION, S02.EMRGNCY_NAME, S03.INFORMAL_STUTYPE, " +
            "S03.STNO, S03.ASYS,S03.CENTER_CODE,S2.CENTER_ABBRNAME AS CENTER_NAME,S03.STTYPE, S03.ENROLL_AYEARSMS, S03.FTSTUD_ENROLL_AYEARSMS, S03.SUSPEND_AYEARSMS, S03.DROPOUT_AYEARSMS, S03.STOP_PRVLG_SAYEARSMS, S03.STOP_PRVLG_EAYEARSMS, S03.PRE_MAJOR_FACULTY, S03.J_FACULTY_CODE, S03.REG_EDUBKGRD_GRAD_YEAR, S03.EDUBKGRD, S03.NOU_EMAIL, S03.TUTOR_CLASS_MK, S03.DBMAJOR_MK, S03.OTHER_REG_MK, S03.ENROLL_STATUS, S03.ST_PICTURE_SEQ_NO, S03.ACCUM_REPL_CRD, S03.ACCUM_REDUCE_CRD, S03.ACCUM_PASS_CRD, S03.REDUCE_TYPE, S03.RMK,S03.EDUBKGRD_AYEAR, " +
            "S02.RESIDENCE_DATE " +
            "FROM STUT003 S03 "+
            "JOIN STUT002 S02 ON S02.IDNO = S03.IDNO AND S02.BIRTHDATE = S03.BIRTHDATE "+
            "LEFT JOIN STUT004 S04 ON S03.STNO = S04.STNO AND S04.AYEAR = '"+AYEAR+"' AND S04.SMS = '"+SMS+"' "+
            "LEFT JOIN SYST002 S2  ON S2.CENTER_CODE = NVL(S04.CENTER_CODE,S03.CENTER_CODE) " +
            "LEFT JOIN SYST001 S01 ON S01.KIND = 'ENROLL_STATUS' AND S01.CODE = NVL(S04.ENROLL_STATUS,S03.ENROLL_STATUS) " +
            //"WHERE S03.STNO = '" + Utility.checkNull(ht.get("STNO"), " ") + "' "
            "WHERE 1=1 "
        );
        
        if( Utility.nullToSpace(ht.get("STNO")).equals("") && Utility.nullToSpace(ht.get("IDNO")).equals("") && Utility.nullToSpace(ht.get("NAME")).equals("")){
        	sql.append(" and 1=2 ");
        }
        
        if(!Utility.nullToSpace(ht.get("STNO")).equals("")) {
            sql.append("AND S03.STNO = '" + Utility.nullToSpace(ht.get("STNO")) + "' ");
        }        
        
        if(!Utility.nullToSpace(ht.get("IDNO")).equals("")) {
            sql.append("AND S02.IDNO = '" + Utility.nullToSpace(ht.get("IDNO")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("BIRTHDATE")).equals("")) {
            sql.append("AND S02.BIRTHDATE = '" + Utility.nullToSpace(ht.get("BIRTHDATE")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("NAME")).equals("")) {
            sql.append("AND S02.NAME LIKE '" + Utility.nullToSpace(ht.get("NAME")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("ENG_NAME")).equals("")) {
            sql.append("AND S02.ENG_NAME = '" + Utility.nullToSpace(ht.get("ENG_NAME")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("ALIAS")).equals("")) {
            sql.append("AND S02.ALIAS = '" + Utility.nullToSpace(ht.get("ALIAS")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("SEX")).equals("")) {
            sql.append("AND S02.SEX = '" + Utility.nullToSpace(ht.get("SEX")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("SELF_IDENTITY_SEX")).equals("")) {
            sql.append("AND S02.SELF_IDENTITY_SEX = '" + Utility.nullToSpace(ht.get("SELF_IDENTITY_SEX")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("NATIONCODE")).equals("")) {
            sql.append("AND S02.NATIONCODE = '" + Utility.nullToSpace(ht.get("NATIONCODE")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("BIRTHPLACE")).equals("")) {
            sql.append("AND S02.BIRTHPLACE = '" + Utility.nullToSpace(ht.get("BIRTHPLACE")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("PASSPORT_NO")).equals("")) {
            sql.append("AND S02.PASSPORT_NO = '" + Utility.nullToSpace(ht.get("PASSPORT_NO")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("VOCATION")).equals("")) {
            sql.append("AND S02.VOCATION = '" + Utility.nullToSpace(ht.get("VOCATION")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("EDUBKGRD_GRADE")).equals("")) {
            sql.append("AND S02.EDUBKGRD_GRADE = '" + Utility.nullToSpace(ht.get("EDUBKGRD_GRADE")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("AREACODE_OFFICE")).equals("")) {
            sql.append("AND S02.AREACODE_OFFICE = '" + Utility.nullToSpace(ht.get("AREACODE_OFFICE")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("TEL_OFFICE")).equals("")) {
            sql.append("AND S02.TEL_OFFICE = '" + Utility.nullToSpace(ht.get("TEL_OFFICE")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("TEL_OFFICE_EXT")).equals("")) {
            sql.append("AND S02.TEL_OFFICE_EXT = '" + Utility.nullToSpace(ht.get("TEL_OFFICE_EXT")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("AREACODE_HOME")).equals("")) {
            sql.append("AND S02.AREACODE_HOME = '" + Utility.nullToSpace(ht.get("AREACODE_HOME")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("TEL_HOME")).equals("")) {
            sql.append("AND S02.TEL_HOME = '" + Utility.nullToSpace(ht.get("TEL_HOME")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("FAX_AREACODE")).equals("")) {
            sql.append("AND S02.FAX_AREACODE = '" + Utility.nullToSpace(ht.get("FAX_AREACODE")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("FAX_TEL")).equals("")) {
            sql.append("AND S02.FAX_TEL = '" + Utility.nullToSpace(ht.get("FAX_TEL")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("MOBILE")).equals("")) {
            sql.append("AND S02.MOBILE = '" + Utility.nullToSpace(ht.get("MOBILE")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("MARRIAGE")).equals("")) {
            sql.append("AND S02.MARRIAGE = '" + Utility.nullToSpace(ht.get("MARRIAGE")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("DMSTADDR")).equals("")) {
            sql.append("AND S02.DMSTADDR = '" + Utility.nullToSpace(ht.get("DMSTADDR")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("DMSTADDR_ZIP")).equals("")) {
            sql.append("AND S02.DMSTADDR_ZIP = '" + Utility.nullToSpace(ht.get("DMSTADDR_ZIP")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("CRRSADDR_ZIP")).equals("")) {
            sql.append("AND S02.CRRSADDR_ZIP = '" + Utility.nullToSpace(ht.get("CRRSADDR_ZIP")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("CRRSADDR")).equals("")) {
            sql.append("AND S02.CRRSADDR = '" + Utility.nullToSpace(ht.get("CRRSADDR")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("EMAIL")).equals("")) {
            sql.append("AND S02.EMAIL = '" + Utility.nullToSpace(ht.get("EMAIL")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("SPECIAL_MK")).equals("")) {
            sql.append("AND S02.SPECIAL_MK = '" + Utility.nullToSpace(ht.get("SPECIAL_MK")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("EMRGNCY_TEL")).equals("")) {
            sql.append("AND S02.EMRGNCY_TEL = '" + Utility.nullToSpace(ht.get("EMRGNCY_TEL")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("EMRGNCY_RELATION")).equals("")) {
            sql.append("AND S02.EMRGNCY_RELATION = '" + Utility.nullToSpace(ht.get("EMRGNCY_RELATION")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("EMRGNCY_NAME")).equals("")) {
            sql.append("AND S02.EMRGNCY_NAME = '" + Utility.nullToSpace(ht.get("EMRGNCY_NAME")) + "' ");
        }
            if(!Utility.nullToSpace(ht.get("UPD_RMK")).equals("")) {
            sql.append("AND S02.UPD_RMK = '" + Utility.nullToSpace(ht.get("UPD_RMK")) + "' ");
        }
        //====================================================================================================
        
		if(!Utility.nullToSpace(ht.get("STU002M")).equals("")){
			sql.append(" AND S03.ENROLL_STATUS <> '7' ");
		}
        
        if(!Utility.nullToSpace(ht.get("STTYPE")).equals("")) {
            sql.append("AND S03.STTYPE = '" + Utility.nullToSpace(ht.get("STTYPE")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("ENROLL_AYEARSMS")).equals("")) {
            sql.append("AND S03.ENROLL_AYEARSMS = '" + Utility.nullToSpace(ht.get("ENROLL_AYEARSMS")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("FTSTUD_ENROLL_AYEARSMS")).equals("")) {
            sql.append("AND S03.FTSTUD_ENROLL_AYEARSMS = '" + Utility.nullToSpace(ht.get("FTSTUD_ENROLL_AYEARSMS")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("SUSPEND_AYEARSMS")).equals("")) {
            sql.append("AND S03.SUSPEND_AYEARSMS = '" + Utility.nullToSpace(ht.get("SUSPEND_AYEARSMS")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("DROPOUT_AYEARSMS")).equals("")) {
            sql.append("AND S03.DROPOUT_AYEARSMS = '" + Utility.nullToSpace(ht.get("DROPOUT_AYEARSMS")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("STOP_PRVLG_SAYEARSMS")).equals("")) {
            sql.append("AND S03.STOP_PRVLG_SAYEARSMS = '" + Utility.nullToSpace(ht.get("STOP_PRVLG_SAYEARSMS")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("STOP_PRVLG_EAYEARSMS")).equals("")) {
            sql.append("AND S03.STOP_PRVLG_EAYEARSMS = '" + Utility.nullToSpace(ht.get("STOP_PRVLG_EAYEARSMS")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("PRE_MAJOR_FACULTY")).equals("")) {
            sql.append("AND S03.PRE_MAJOR_FACULTY = '" + Utility.nullToSpace(ht.get("PRE_MAJOR_FACULTY")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("J_FACULTY_CODE")).equals("")) {
            sql.append("AND S03.J_FACULTY_CODE = '" + Utility.nullToSpace(ht.get("J_FACULTY_CODE")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("REG_EDUBKGRD_GRAD_YEAR")).equals("")) {
            sql.append("AND S03.REG_EDUBKGRD_GRAD_YEAR = '" + Utility.nullToSpace(ht.get("REG_EDUBKGRD_GRAD_YEAR")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("EDUBKGRD")).equals("")) {
            sql.append("AND S03.EDUBKGRD = '" + Utility.nullToSpace(ht.get("EDUBKGRD")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("NOU_EMAIL")).equals("")) {
            sql.append("AND S03.NOU_EMAIL = '" + Utility.nullToSpace(ht.get("NOU_EMAIL")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("TUTOR_CLASS_MK")).equals("")) {
            sql.append("AND S03.TUTOR_CLASS_MK = '" + Utility.nullToSpace(ht.get("TUTOR_CLASS_MK")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("DBMAJOR_MK")).equals("")) {
            sql.append("AND S03.DBMAJOR_MK = '" + Utility.nullToSpace(ht.get("DBMAJOR_MK")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("OTHER_REG_MK")).equals("")) {
            sql.append("AND S03.OTHER_REG_MK = '" + Utility.nullToSpace(ht.get("OTHER_REG_MK")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("ENROLL_STATUS")).equals("")) {
            sql.append("AND S03.ENROLL_STATUS = '" + Utility.nullToSpace(ht.get("ENROLL_STATUS")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("ST_PICTURE_SEQ_NO")).equals("")) {
            sql.append("AND S03.ST_PICTURE_SEQ_NO = '" + Utility.nullToSpace(ht.get("ST_PICTURE_SEQ_NO")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("ACCUM_REPL_CRD")).equals("")) {
            sql.append("AND S03.ACCUM_REPL_CRD = '" + Utility.nullToSpace(ht.get("ACCUM_REPL_CRD")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("ACCUM_REDUCE_CRD")).equals("")) {
            sql.append("AND S03.ACCUM_REDUCE_CRD = '" + Utility.nullToSpace(ht.get("ACCUM_REDUCE_CRD")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("ACCUM_PASS_CRD")).equals("")) {
            sql.append("AND S03.ACCUM_PASS_CRD = '" + Utility.nullToSpace(ht.get("ACCUM_PASS_CRD")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("REDUCE_TYPE")).equals("")) {
            sql.append("AND S03.REDUCE_TYPE = '" + Utility.nullToSpace(ht.get("REDUCE_TYPE")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("RMK")).equals("")) {
            sql.append("AND S03.RMK = '" + Utility.nullToSpace(ht.get("RMK")) + "' ");
        }

    
        if(!orderBy.equals("")) {
            String[] orderByArray = orderBy.split(",");
            orderBy = "";
            String STUT002Column = "IDNO, BIRTHDATE, NAME, ENG_NAME, ALIAS, SEX, SELF_IDENTITY_SEX, NATIONCODE, NEWNATION, BIRTHPLACE, PASSPORT_NO, VOCATION, EDUBKGRD_GRADE, AREACODE_OFFICE, TEL_OFFICE, TEL_OFFICE_EXT, AREACODE_HOME, TEL_HOME, FAX_AREACODE, FAX_TEL, MOBILE, MARRIAGE, DMSTADDR, DMSTADDR_ZIP, CRRSADDR_ZIP, CRRSADDR, EMAIL, SPECIAL_MK, EMRGNCY_TEL, EMRGNCY_RELATION, EMRGNCY_NAME";
            String STUT003Column = "STNO, ASYS, CENTER_CODE, STTYPE, ENROLL_AYEARSMS, FTSTUD_ENROLL_AYEARSMS, SUSPEND_AYEARSMS, DROPOUT_AYEARSMS, STOP_PRVLG_SAYEARSMS, STOP_PRVLG_EAYEARSMS, PRE_MAJOR_FACULTY, J_FACULTY_CODE, REG_EDUBKGRD_GRAD_YEAR, EDUBKGRD, NOU_EMAIL, TUTOR_CLASS_MK, DBMAJOR_MK, OTHER_REG_MK, ENROLL_STATUS, ST_PICTURE_SEQ_NO, ACCUM_REPL_CRD, ACCUM_REDUCE_CRD, ACCUM_PASS_CRD, REDUCE_TYPE, RMK,EDUBKGRD_AYEAR";
            for(int i = 0; i < orderByArray.length; i++) {
                if(STUT002Column.trim().indexOf(orderByArray[i]) > 0) {
                    orderByArray[i] = "S02." + orderByArray[i].trim();
                } else if(STUT003Column.trim().indexOf(orderByArray[i]) > 0) {
                    orderByArray[i] = "S03." + orderByArray[i].trim();
                }

                if(i == 0) {
                    orderBy += "ORDER BY ";
                } else {
                    orderBy += ", ";
                }
                orderBy += orderByArray[i].trim();
            }
            sql.append(orderBy.toUpperCase());
            orderBy = "";
        }

        DBResult rs = null;
        try {
            if(pageQuery) {
                // 依分頁取出資料
                rs = Page.getPageResultSet(dbmanager, conn, sql.toString(), pageNo, pageSize);
            } else {
                // 取出所有資料
                rs = dbmanager.getSimpleResultSet(conn);
                rs.open();
                rs.executeQuery(sql.toString());
            }
            Hashtable rowHt = null;
            while (rs.next()) {
                rowHt = new Hashtable();
                /** 將欄位抄一份過去 */
                for (int i = 1; i <= rs.getColumnCount(); i++)
                    rowHt.put(rs.getColumnName(i), rs.getString(i));

                result.add(rowHt);
            }
        } catch (Exception e) {
            throw e;
        } finally {
            if(rs != null) {
                rs.close();
            }
        }
        return result;
    }

 /**
     * 取得學生基本資料及學籍資料
     * @param ht 條件值
     * @return 回傳 Vector 物件，內容為 Hashtable 的集合，<br>
     *         每一個 Hashtable 其 KEY 為欄位名稱，KEY 的值為欄位的值<br>
     *         若該欄位有中文名稱，則其 KEY 請加上 _NAME, EX: SMS 其中文欄位請設為 SMS_NAME
     * @throws Exception
     */
    public void getStuData3(Hashtable ht,Vector vt) throws Exception {
        if(ht == null) {
            ht = new Hashtable();
        }
        if(sql.length() > 0) {
            sql.delete(0, sql.length());
        }

       	/* sql.append("SELECT AYEAR,E.CODE_NAME AS SMS_DESC,STNO,STTYPE,B.CODE_NAME AS STTYPE_DESC,C.CODE_NAME AS CENTER_CODE_DESC,D.CODE_NAME AS REDUCE_TYPE_DESC, A.ENROLL_STATUS, G.CODE_NAME AS ENROLL_STATUS_NAME, A.DBMAJOR_MK, A.FTSTUD_ENROLL_AYEARSMS, A.UPD_RMK,A.UPD_DATE,A.UPD_USER_ID, " );
       	sql.append("(select (select G.CODE_NAME from SYST001 G where G.kind='PAYMENT_STATUS' and F.payment_status=G.code ) as payment_status from REGT005 F where F.STNO=A.STNO and A.AYEAR=F.AYEAR and A.SMS=F.SMS) AS PAYMENT_STATUS ");
		if(ht.get("ASYS").toString().equals("2"))
			sql.append(", ( SELECT H.TOTAL_CRS_NAME FROM SYST008 H WHERE H.TOTAL_CRS_NO=A.J_FACULTY_CODE AND H.FACULTY_CODE=A.PRE_MAJOR_FACULTY )  J_FACULTY_CODE ");
		sql.append(", (SELECT STUT002.NAME FROM STUT002 JOIN STUT003 ON STUT002.IDNO=STUT003.IDNO AND STUT002.BIRTHDATE=STUT003.BIRTHDATE WHERE STUT003.STNO=A.STNO) NAME ");
        sql.append(" FROM STUT004 A ");
		sql.append("LEFT OUTER JOIN SYST001 B ON A.STTYPE = B.CODE AND B.KIND = 'STTYPE' ");
		sql.append("LEFT OUTER JOIN SYST001 C ON A.CENTER_CODE = C.CODE AND C.KIND = 'CENTER_CODE' ");
		sql.append("LEFT OUTER JOIN SYST001 D ON A.REDUCE_TYPE = D.CODE AND D.KIND = 'REDUCE_TYPE' ");
		sql.append("LEFT OUTER JOIN SYST001 E ON A.SMS = E.CODE AND E.KIND = 'SMS' ");
                sql.append("LEFT OUTER JOIN SYST001 G ON A.ENROLL_STATUS = G.CODE AND G.KIND = 'ENROLL_STATUS' ");
		//sql.append("LEFT OUTER JOIN STUT002 F ON A.SMS = F.SMS AND A.AYEAR = F.AYEAR ");
		sql.append("WHERE 1=1 ");
		// == 查詢條件 ST ==
		if(!Utility.checkNull(ht.get("STNO"), "").equals("")) {
			sql.append("AND A.STNO	=	'").append(Utility.dbStr(ht.get("STNO"))).append("'");
		}
		// == 查詢條件 ED ==

		sql.append(" ORDER BY A.AYEAR, A.SMS"); */
		String ayear_sms = "";
		String stno = ht.get("STNO").toString();
		ayear_sms = ht.get("AYEAR").toString();
		if(ht.get("SMS").toString().equals("0"))
			ayear_sms += "0";
		else
			ayear_sms += ht.get("SMS").toString();
		sql.append( "select b.ayear ayear, b.sms sms, b.stno stno, b.take_abndn, c.sttype, c.enroll_status, " +
					"b.ayear||(decode(b.sms, '1', '1', '2', '2', '3', '0', 9)) AS ayear_sms, " +
					"(select code_name from syst001 where syst001.kind='STTYPE' and syst001.code=c.sttype) AS sttype_desc, " +
					"(select code_name from syst001 where syst001.kind='SMS' and syst001.code=b.sms) AS sms_desc, " +
					"(select center_name from syst002 where syst002.center_code=c.center_code) AS center_code_desc, " +
					"(select code_name from syst001 where syst001.kind='REDUCE_TYPE' and syst001.code=d.reduce_type) AS reduce_type_desc, " +
					"(select code_name from syst001 where syst001.kind='ENROLL_STATUS' and syst001.code=c.enroll_status) AS enroll_status_name, " +
					"c.dbmajor_mk, c.ftstud_enroll_ayearsms, c.upd_rmk, c.upd_date, c.upd_user_id, " +
					"(select code_name from syst001 where syst001.kind='PAYMENT_STATUS' and syst001.code=b.payment_status) AS payment_status, " +
					"b.payment_status payment_status_code,"+
					"(select stut002.name from stut003 join stut002 on stut003.idno=stut002.idno and stut003.birthdate=stut002.birthdate where stut003.stno=b.stno) AS name ");
		if(ht.get("ASYS").toString().equals("2"))
			sql.append( ", (select syst008.total_crs_name from syst008 where syst008.total_crs_no = c.j_faculty_code AND syst008.faculty_code = c.pre_major_faculty and syst008.asys = '2') AS j_faculty_code ");
		sql.append( "from (select a.ayear, a.sms, a.stno, a.payment_status, a.take_abndn from regt005 a where  a.ayear||(decode(a.sms, '1', '1', '2', '2', '3', '0', 9)) <= '" + ayear_sms + "' and a.stno='" + stno + "') b " +
					"left join stut004 c on c.ayear=b.ayear and c.sms=b.sms and c.stno=b.stno " +
					// 減免類別
					"left join regt004 d on d.ayear=b.ayear and d.sms=b.sms and d.stno=b.stno and d.audit_status='1' " +
					"union " +
					"select b.ayear ayear, b.sms sms, b.stno stno, c.take_abndn, b.sttype, b.enroll_status, " +
					"b.ayear||(decode(b.sms, '1', '1', '2', '2', '3', '0', 9)) AS ayear_sms, " +
					"(select code_name from syst001 where syst001.kind='STTYPE' and syst001.code=b.sttype) AS sttype_desc, " +
					"(select code_name from syst001 where syst001.kind='SMS' and syst001.code=b.sms) AS sms_desc, " +
					"(select center_name from syst002 where syst002.center_code=b.center_code) AS center_code_desc, " +
					"(select code_name from syst001 where syst001.kind='REDUCE_TYPE' and syst001.code=d.reduce_type) AS reduce_type_desc, " +
					"(select code_name from syst001 where syst001.kind='ENROLL_STATUS' and syst001.code=b.enroll_status) AS enroll_status_name, " +
					"b.dbmajor_mk, b.ftstud_enroll_ayearsms, b.upd_rmk, b.upd_date, b.upd_user_id, " +
					"(select code_name from syst001 where syst001.kind='PAYMENT_STATUS' and syst001.code=c.payment_status) AS payment_status, " +
					"c.payment_status payment_status_code,"+
					"(select stut002.name from stut003 join stut002 on stut003.idno=stut002.idno and stut003.birthdate=stut002.birthdate where stut003.stno=b.stno) AS name ");
		if(ht.get("ASYS").toString().equals("2"))
			sql.append( ", (select syst008.total_crs_name from syst008 where syst008.total_crs_no = b.j_faculty_code AND syst008.faculty_code = b.pre_major_faculty and syst008.asys = '2') AS j_faculty_code ");
		sql.append( "from (select a.ayear, a.sms, a.stno, a.sttype, a.center_code, a.enroll_status, a.dbmajor_mk, a.ftstud_enroll_ayearsms, a.upd_rmk, a.upd_date, a.upd_user_id, a.j_faculty_code, a.pre_major_faculty " +
					//"from stut004 a where  a.ayear||(decode(a.sms, '1', '1', '2', '2', '3', '0', 9)) <= '" + ayear_sms + "' and a.stno='" + stno + "') b " +
					"from stut004 a where  1=1 and a.stno='" + stno + "') b " +
					"left join regt005 c on c.ayear=b.ayear and c.sms=b.sms and c.stno=b.stno " +
					// 減免類別
					"left join regt004 d on d.ayear=b.ayear and d.sms=b.sms and d.stno=b.stno and d.audit_status='1' " +
					"order by ayear_sms desc");
        if(!orderBy.equals("")) {
            String[] orderByArray = orderBy.split(",");
            orderBy = "";
            for(int i = 0; i < orderByArray.length; i++) {
                orderByArray[i] = "S02." + orderByArray[i].trim();

                if(i == 0) {
                    orderBy += "ORDER BY ";
                } else {
                    orderBy += ", ";
                }
                orderBy += orderByArray[i].trim();
            }
            sql.append(orderBy.toUpperCase());
            orderBy = "";
        }

        DBResult rs = null;
        try {
            if(pageQuery) {
                // 依分頁取出資料
                rs = Page.getPageResultSet(dbmanager, conn, sql.toString(), pageNo, pageSize);
            } else {
                // 取出所有資料
                rs = dbmanager.getSimpleResultSet(conn);
                rs.open();
                rs.executeQuery(sql.toString());
            }
            Hashtable rowHt = null;
            while (rs.next()) {
                rowHt = new Hashtable();
                /** 將欄位抄一份過去 */
                for (int i = 1; i <= rs.getColumnCount(); i++)
						rowHt.put(rs.getColumnName(i), rs.getString(i));
                vt.add(rowHt);
            }
        } catch (Exception e) {
            throw e;
        } finally {
            if(rs != null) {
                rs.close();
            }
        }
    }
    /**
     * 取得學生基本資料及學籍資料
     * @param ht 條件值
     * @return 回傳 Vector 物件，內容為 Hashtable 的集合，<br>
     *         每一個 Hashtable 其 KEY 為欄位名稱，KEY 的值為欄位的值<br>
     *         若該欄位有中文名稱，則其 KEY 請加上 _NAME, EX: SMS 其中文欄位請設為 SMS_NAME
     * @throws Exception
     * by poto 修改為dao格式  96/06/25
     */
    public void getStuData2(Hashtable ht,Vector vt) throws Exception {
        if(ht == null) {
            ht = new Hashtable();
        }
        if(sql.length() > 0) {
            sql.delete(0, sql.length());
        }

		sql.append("SELECT A.EDUBKGRD,A.EDUBKGRD_AYEAR, A.GRAD_KIND, ");
		sql.append("SUBSTR(A.GRAD_AYEARSMS,1,3) AS GRAD_AYEAR, ");
        sql.append("SUBSTR(A.GRAD_AYEARSMS,4,1) AS GRAD_SMS,  ");
        sql.append("SUBSTR(A.FTSTUD_ENROLL_AYEARSMS,1,3) AS FTSTUD_ENROLL_AYEAR, ");
        sql.append("SUBSTR(A.FTSTUD_ENROLL_AYEARSMS,4,1) AS FTSTUD_ENROLL_SMS, ");
        sql.append("A.TUTOR_CLASS_MK AS TUTOR_CLASS_MK, "); //班導師
        sql.append("A.OTHER_REG_MK AS OTHER_REG_MK, ");     //跨校報名
		//sql.append("(SELECT L.CODE_NAME FROM SYST001 L WHERE L.KIND='REDUCE_TYPE' AND L.CODE=A.REDUCE_TYPE) AS REDUCE_TYPE, ");
        sql.append("decode(NVL(N.PERMANENT_MK,'N'),'Y','是','否')  AS REDUCE_TYPE, ");
        sql.append("B.AYEAR AS SAYEAR, ");
		sql.append("B.SMS AS SSMS, ");
		//sql.append("SUBSTR(B.SAYEARSMS,1,3) AS SAYEAR, ");
        //sql.append("SUBSTR(B.SAYEARSMS,4,1) AS SSMS,  ");
        //sql.append("SUBSTR(B.EAYEARSMS,1,3) AS EAYEAR, ");
        //sql.append("SUBSTR(B.EAYEARSMS,4,1) AS ESMS, ");
        sql.append("SUBSTR(ENROLL_AYEARSMS,1,3) AS ENROLL_AYEAR, ");
        sql.append("SUBSTR(ENROLL_AYEARSMS,4,1) AS ENROLL_SMS, ");
        sql.append("SUBSTR(A.STOP_PRVLG_SAYEARSMS,1,3) AS STOP_PRVLG_SAYEAR, ");
        sql.append("SUBSTR(A.STOP_PRVLG_SAYEARSMS,4,1) AS STOP_PRVLG_SSMS, ");
        sql.append("SUBSTR(A.STOP_PRVLG_EAYEARSMS,1,3) AS STOP_PRVLG_EAYEAR, ");
        sql.append("SUBSTR(A.STOP_PRVLG_EAYEARSMS,4,1) AS STOP_PRVLG_ESMS, ");
        sql.append("H.CODE_NAME AS SPCLASS_CODE, "); //專班名稱
        sql.append("L.CODE_NAME AS INFORMAL_STUTYPE, "); //旁聽生註記
       // sql.append("A.PRE_MAJOR_FACULTY AS PRE_MAJOR_FACULTY, ");
        sql.append("A.NOU_EMAIL,A.STNO,C.CODE_NAME AS CENTER_CODE, ");
        sql.append(" D.CODE_NAME AS STTYPE, ");
        sql.append("SUBSTR(A.DROPOUT_AYEARSMS,1,3) AS DROPOUT_AYEAR, ");
        sql.append("SUBSTR(A.DROPOUT_AYEARSMS,4,1) AS DROPOUT_SMS,  ");
        //sql.append(" K.FACULTY_NAME AS PRE_MAJOR_FACULTY, ");

        String s= Utility.nullToSpace(ht.get("STNO"));
        System.out.println("stno.length="+s.length());
        if(s.length()!=7)
            sql.append(" DECODE(A.PRE_MAJOR_FACULTY,'00','',A.PRE_MAJOR_FACULTY) AS PRE_MAJOR_FACULTY, ");

        sql.append(" S3.FACULTY_NAME AS GRAD_MAJOR_FACULTY, ");
        sql.append(" S8.TOTAL_CRS_NAME AS J_FACULTY_CODE, ");
        sql.append(" DBMAJOR_MK,'' AS SPCLASS_TYPE,E.CODE_NAME AS ENROLL_STATUS,  M.NAME, A.EDUBKGRD_GRADE,  ");
        sql.append(" DECODE(A.EDUBKGRD_GRADE,'','',S4.CODE_NAME) AS EDUBKGRDABILITY,  ");
        sql.append(" S5.CODE_NAME AS GRAD_KIND_1, S6.CODE_NAME AS EDUBKGRD_ABILITY,  ");
        sql.append(" A.REG_UPD_AYEARSMS  ");
        sql.append(" FROM STUT003 A ");
		sql.append(" LEFT OUTER JOIN STUT031 B ON A.STNO = B.STNO ");
		sql.append(" LEFT OUTER JOIN SYST001 C ON A.CENTER_CODE = C.CODE AND C.KIND = 'CENTER_CODE' ");
		sql.append(" LEFT OUTER JOIN SYST001 D ON A.STTYPE = D.CODE AND D.KIND = 'STTYPE' ");
		sql.append(" LEFT OUTER JOIN SYST001 E ON A.ENROLL_STATUS = E.CODE AND E.KIND = 'ENROLL_STATUS' ");
		sql.append(" LEFT OUTER JOIN SYST001 I ON SUBSTR(A.STOP_PRVLG_SAYEARSMS,4) = I.CODE AND I.KIND = 'SMS' ");
		sql.append(" LEFT OUTER JOIN SYST001 J ON SUBSTR(A.STOP_PRVLG_EAYEARSMS,4) = J.CODE AND J.KIND = 'SMS' ");
		sql.append(" LEFT OUTER JOIN SYST003 K ON A.PRE_MAJOR_FACULTY = K.FACULTY_CODE ");
		sql.append(" LEFT OUTER JOIN GRAT003 G ON A.STNO = G.STNO AND G.GRAD_REEXAM_STATUS ='2' AND SUBSTR(A.GRAD_AYEARSMS,1,3) = G.AYEAR AND SUBSTR(A.GRAD_AYEARSMS,4,1) = G.SMS");
        sql.append(" LEFT OUTER JOIN SYST003 S3 ON G.GRAD_MAJOR_FACULTY = S3.FACULTY_CODE  ");
        sql.append(" LEFT OUTER JOIN SYST001 H ON H.KIND = 'SPECIAL_STTYPE_MK' AND B.SPCLASS_TYPE = H.CODE  ");
        sql.append(" LEFT OUTER JOIN SYST001 L ON L.KIND = 'INFORMAL_STUTYPE' AND A.INFORMAL_STUTYPE = L.CODE  ");
        sql.append(" LEFT OUTER JOIN SYST008 S8 ON A.J_FACULTY_CODE = S8.FACULTY_CODE  AND S8.ASYS='2' ");
		sql.append(" JOIN STUT002 M ON M.IDNO=A.IDNO AND M.BIRTHDATE=A.BIRTHDATE ");
		sql.append(" LEFT OUTER JOIN SGUT004 N ON A.STNO = N.STNO AND N.HAND_NATIVE = '1' ");
		sql.append(" LEFT OUTER JOIN GRAT049 G4 ON A.EDUBKGRD_GRADE = G4.EDUBKGRD_GRADE ");
		sql.append(" LEFT OUTER JOIN SYST001 S4 ON S4.KIND = 'EDUBKGRD_ABILITY' AND S4.CODE = G4.EDUBKGRD_ABILITY ");
		sql.append(" LEFT OUTER JOIN SYST001 S5 ON S5.KIND = 'GRAD_KIND' AND S5.CODE = A.GRAD_KIND  ");
		sql.append(" LEFT OUTER JOIN SYST001 S6 ON S6.KIND = 'EDUBKGRD_ABILITY' AND S6.CODE = A.EDUBKGRD_ABILITY ");
		sql.append(" WHERE 1=1 ");
		if(!Utility.checkNull(ht.get("STNO"), "").trim().equals("")) {
			sql.append("AND A.STNO	=	'").append(Utility.dbStr(ht.get("STNO"))).append("'");
		}
		sql.append(" order by APP_GRAD_TYPE desc ");
        if(!orderBy.equals("")) {
            String[] orderByArray = orderBy.split(",");
            orderBy = "";
            for(int i = 0; i < orderByArray.length; i++) {
                orderByArray[i] = "S02." + orderByArray[i].trim();

                if(i == 0) {
                    orderBy += "ORDER BY ";
                } else {
                    orderBy += ", ";
                }
                orderBy += orderByArray[i].trim();
            }
            sql.append(orderBy.toUpperCase());
            orderBy = "";
        }

System.out.println("doQueryEdit2="+sql.toString());
        DBResult rs = null;
        try {
            if(pageQuery) {
                // 依分頁取出資料
                rs = Page.getPageResultSet(dbmanager, conn, sql.toString(), pageNo, pageSize);
            } else {
                // 取出所有資料
                rs = dbmanager.getSimpleResultSet(conn);
                rs.open();
                rs.executeQuery(sql.toString());
            }
            Hashtable rowHt = null;
            while(rs.next()) {
                rowHt = new Hashtable();
                /**將欄位抄一份過去**/
                for (int i = 1; i <= rs.getColumnCount(); i++){
                    rowHt.put(rs.getColumnName(i), rs.getString(i));
                }
                 vt.add(rowHt);
            }
        } catch (Exception e) {
            throw e;
        } finally {
            if(rs != null) {
                rs.close();
            }
        }
    }
/**
     * 取得學生基本資料及學籍資料
     * @param ht 條件值
     * @return 回傳 Vector 物件，內容為 Hashtable 的集合，<br>
     *         每一個 Hashtable 其 KEY 為欄位名稱，KEY 的值為欄位的值<br>
     *         若該欄位有中文名稱，則其 KEY 請加上 _NAME, EX: SMS 其中文欄位請設為 SMS_NAME
     * @throws Exception
     */
    public void getStuData1(Hashtable ht,Vector vt) throws Exception {
        if(ht == null) {
            ht = new Hashtable();
        }
        if(sql.length() > 0) {
            sql.delete(0, sql.length());
        }

		String	sql	=	"SELECT IDNO, BIRTHDATE, NAME, ENG_NAME, ALIAS, SEX, SELF_IDENTITY_SEX, MARRIAGE, VOCATION, EDUBKGRD_GRADE, EMAIL, DMSTADDR_ZIP, DMSTADDR, CRRSADDR_ZIP, CRRSADDR, AREACODE_OFFICE, TEL_OFFICE, AREACODE_HOME, TEL_HOME, MOBILE, EMRGNCY_NAME, EMRGNCY_TEL, EMRGNCY_RELATION, ROWSTAMP " +
        				"FROM STUT002 A " +
        				"JOIN STUT003 B ON A.IDNO = B.IDNO AND A.BIRTHDATE = B.BIRTHDATE " +
        				"WHERE 1=1 " +
        				"AND A.IDNO		=	'" + Utility.dbStr(ht.get("IDNO"))+ "' " +
        				"AND A.BIRTHDATE	=	'" + Utility.dbStr(ht.get("BIRTHDATE"))+ "' "+
        				"ADN B.STNO		=	'" + Utility.dbStr(ht.get("STNO"))+ "'  ";
		/** == 查詢條件 ED == */



        if(!orderBy.equals("")) {
            String[] orderByArray = orderBy.split(",");
            orderBy = "";
            for(int i = 0; i < orderByArray.length; i++) {
                orderByArray[i] = "S02." + orderByArray[i].trim();

                if(i == 0) {
                    orderBy += "ORDER BY ";
                } else {
                    orderBy += ", ";
                }
                orderBy += orderByArray[i].trim();
            }
            //sql.append(orderBy.toUpperCase());
            orderBy = "";
        }


        DBResult rs = null;
        try {
            if(pageQuery) {
                // 依分頁取出資料
                rs = Page.getPageResultSet(dbmanager, conn, sql, pageNo, pageSize);
            } else {
                // 取出所有資料
                rs = dbmanager.getSimpleResultSet(conn);
                rs.open();
                rs.executeQuery(sql);
            }
            Hashtable rowHt = null;
            while (rs.next()) {
                rowHt = new Hashtable();
                /** 將欄位抄一份過去 */
                for (int i = 1; i <= rs.getColumnCount(); i++)
                    rowHt.put(rs.getColumnName(i), rs.getString(i));

                vt.add(rowHt);
            }
        } catch (Exception e) {
            throw e;
        } finally {
            if(rs != null) {
                rs.close();
            }
        }
    }
    /**
     * @列印不准抵免清冊- 取得學生姓名 (STUT002, STUT003)
     * @param stno 條件值
     * @return 回傳 String 物件<br>
     * @throws Exception
     */
    public String getStuName(String stno)throws Exception {

        DBResult    rs      =   null;
        String stuName = "";
        try{

            if(sql.length() > 0) {
                sql.delete(0, sql.length());
            }

            sql.append
            (
                " SELECT A.NAME FROM STUT002 A JOIN STUT003 B ON A.IDNO = B.IDNO WHERE B.STNO = '" + stno + "'"
            );

            rs = dbmanager.getSimpleResultSet(conn);
            rs.open();
            rs.executeQuery(sql.toString());

            while(rs.next()){
                stuName = rs.getString("NAME");
            }
        }
        catch(Exception e)
        {
        	stuName="";
            throw e;
        }
        finally
        {
            if (rs != null)
                rs.close();
        }

        return stuName;
    }


    /**
     * 取得學生基本資料 (STUT002, STUT003)
     * @param ht 條件值
     * @return 回傳 DBResult 物件
     * @throws Exception
     */
    public DBResult getStuBaseData(Hashtable ht) throws Exception
    {
        DBResult    rs      =   null;


        try
        {
            //條件欄位
            String  STNO    =   Utility.checkNull((String)ht.get("STNO"), "");      //學號


            //將 SQL 清空
            if (sql.length() > 0)
                sql.delete(0, sql.length());

            sql.append
            (
                "SELECT STUT002.NAME, STUT002.ENG_NAME, STUT002.IDNO, STUT002.AREACODE_HOME, " +
                "STUT002.TEL_HOME, STUT002.CRRSADDR_ZIP, STUT002.CRRSADDR, STUT002.EMAIL,STUT003.ENROLL_AYEARSMS " +
                "FROM STUT002, STUT003 " +
                "WHERE "
            );


            //JOIN
            sql.append
            (
                "STUT002.IDNO = STUT003.IDNO AND " +
                "STUT002.BIRTHDATE = STUT003.BIRTHDATE "
            );


            //加入條件 - 學號
            if (!"".equals(STNO))
                sql.append("AND STUT003.STNO = '" + STNO + "' ");
            if (!"".equals(Utility.nullToSpace(ht.get("IDNO"))))
                sql.append("AND STUT003.IDNO = '" + ht.get("IDNO") + "' ");
            if (!"".equals(Utility.nullToSpace(ht.get("BIRTHDATE"))))
                sql.append("AND STUT003.BIRTHDATE = '" + ht.get("BIRTHDATE") + "' ");


            //排序
            if (!"".equals(orderBy))
            {
                sql.append("ORDER BY " + orderBy);
                orderBy = "";
            }


            System.out.println(sql.toString());


            // 依分頁取出資料
            if (pageQuery)
            {
                rs = Page.getPageResultSet(dbmanager, conn, sql.toString(), pageNo, pageSize);
            }
            // 取出所有資料
            else
            {
                rs = dbmanager.getSimpleResultSet(conn);
                rs.open();
                rs.executeQuery(sql.toString());
            }


            return rs;
        }
        catch(Exception e)
        {
            throw e;
        }
    }


   /**
     * 取得學生基本資料 (STUT002, STUT003)
     * @param ht 條件值     *
     * @throws Exception
     * by poto
     */
    public DBResult doExportstut005(Hashtable ht) throws Exception
    {
        DBResult    rs      =   null;


        try
        {    //將 SQL 清空
            if (sql.length() > 0)
                sql.delete(0, sql.length());


            //排序
            if (!"".equals(orderBy))
            {
                sql.append("ORDER BY " + orderBy);
                orderBy = "";
            }
            System.out.println(sql.toString());
            // 依分頁取出資料
            if (pageQuery)
            {
                rs = Page.getPageResultSet(dbmanager, conn, sql.toString(), pageNo, pageSize);
            }
            // 取出所有資料
            else
            {
                rs = dbmanager.getSimpleResultSet(conn);
                rs.open();
                rs.executeQuery(sql.toString());
            }
            return rs;
        }
        catch(Exception e)
        {
            throw e;
        }
    }

    //**********取亂數************//
    //for doExportstut005  by poto//
	public Vector getRandom(long para1, long para2) {
    	Vector vt = new Vector();

        if (para1 <= para2) {
        	for (int i=1;i<=para1;i++) {
        		vt.add(new Integer(i));
        	}
        	return vt;
        }
        next: for (int i = 0; i < para2;) {
    		int v = 1 + (int) (para1 * Math.random());
    		if (vt.contains(new Integer(v))) {
				continue next;
			}
			i++;
    		vt.add(new Integer(v));
    	}
        return vt;

	}



    /**
     * 取得學生基本資料及學籍資料
     * by poto 修改為dao格式  96/08/31
     */
    public DBResult getStut003Query(Hashtable requestMap) throws Exception {
        if(requestMap == null) {
            requestMap = new Hashtable();
        }
        if(sql.length() > 0) {
            sql.delete(0, sql.length());
        }
        sql.append
		(
			"SELECT STUT002.IDNO, STUT002.NAME " +
			"FROM  STUT002 " +
			"WHERE " +
			"1	=	1 "
		);

		/** == 查詢條件 ST == */
		if(!Utility.checkNull(requestMap.get("IDNO"), "").equals(""))
			sql.append("AND STUT002.IDNO	=	'" + Utility.dbStr(requestMap.get("IDNO"))+ "'");
		if(!Utility.checkNull(requestMap.get("BIRTHDATE"), "").equals(""))
			sql.append("AND STUT002.BIRTHDATE	=	'" + Utility.dbStr(requestMap.get("BIRTHDATE"))+ "'");
		if(!Utility.checkNull(requestMap.get("NAME"), "").equals(""))
			sql.append("AND STUT002.NAME	=	'" + Utility.dbStr(requestMap.get("NAME"))+ "'");
		if(!Utility.checkNull(requestMap.get("ENG_NAME"), "").equals(""))
			sql.append("AND STUT002.ENG_NAME	=	'" + Utility.dbStr(requestMap.get("ENG_NAME"))+ "'");
		if(!Utility.checkNull(requestMap.get("ALIAS"), "").equals(""))
			sql.append("AND STUT002.ALIAS	=	'" + Utility.dbStr(requestMap.get("ALIAS"))+ "'");
		if(!Utility.checkNull(requestMap.get("CRRSADDR_ZIP"), "").equals(""))
			sql.append("AND STUT002.CRRSADDR_ZIP	=	'" + Utility.dbStr(requestMap.get("CRRSADDR_ZIP"))+ "'");
		if(!Utility.checkNull(requestMap.get("CRRSADDR"), "").equals(""))
			sql.append("AND STUT002.CRRSADDR	=	'" + Utility.dbStr(requestMap.get("CRRSADDR"))+ "'");
		if(!Utility.checkNull(requestMap.get("AREACODE_OFFICE"), "").equals(""))
			sql.append("AND STUT002.AREACODE_OFFICE	=	'" + Utility.dbStr(requestMap.get("AREACODE_OFFICE"))+ "'");
		if(!Utility.checkNull(requestMap.get("TEL_OFFICE"), "").equals(""))
			sql.append("AND STUT002.TEL_OFFICE	=	'" + Utility.dbStr(requestMap.get("TEL_OFFICE"))+ "'");
		if(!Utility.checkNull(requestMap.get("TEL_OFFICE_EXT"), "").equals(""))
			sql.append("AND STUT002.TEL_OFFICE_EXT	=	'" + Utility.dbStr(requestMap.get("TEL_OFFICE_EXT"))+ "'");
		if(!Utility.checkNull(requestMap.get("AREACODE_HOME"), "").equals(""))
			sql.append("AND STUT002.AREACODE_HOME	=	'" + Utility.dbStr(requestMap.get("AREACODE_HOME"))+ "'");
		if(!Utility.checkNull(requestMap.get("TEL_HOME"), "").equals(""))
			sql.append("AND STUT002.TEL_HOME	=	'" + Utility.dbStr(requestMap.get("TEL_HOME"))+ "'");
		if(!Utility.checkNull(requestMap.get("MOBILE"), "").equals(""))
			sql.append("AND STUT002.MOBILE	=	'" + Utility.dbStr(requestMap.get("MOBILE"))+ "'");
		if(!Utility.checkNull(requestMap.get("MARRIAGE"), "").equals(""))
			sql.append("AND STUT002.MARRIAGE	=	'" + Utility.dbStr(requestMap.get("MARRIAGE"))+ "'");
		if(!Utility.checkNull(requestMap.get("EMAIL"), "").equals(""))
			sql.append("AND STUT002.EMAIL	=	'" + Utility.dbStr(requestMap.get("EMAIL"))+ "'");
		if(!Utility.checkNull(requestMap.get("EMRGNCY_NAME"), "").equals(""))
			sql.append("AND STUT002.EMRGNCY_NAME	=	'" + Utility.dbStr(requestMap.get("EMRGNCY_NAME"))+ "'");
		if(!Utility.checkNull(requestMap.get("EMRGNCY_TEL"), "").equals(""))
			sql.append("AND STUT002.EMRGNCY_TEL	=	'" + Utility.dbStr(requestMap.get("EMRGNCY_TEL"))+ "'");
		if(!Utility.checkNull(requestMap.get("EMRGNCY_RELATION"), "").equals(""))
			sql.append("AND STUT002.EMRGNCY_RELATION	=	'" + Utility.dbStr(requestMap.get("EMRGNCY_RELATION"))+ "'");
		/** == 查詢條件 ED == */

		sql.append(" ORDER BY STUT002.IDNO, STUT002.NAME");



        if(!orderBy.equals("")) {
            String[] orderByArray = orderBy.split(",");
            orderBy = "";
            for(int i = 0; i < orderByArray.length; i++) {
                orderByArray[i] = "S02." + orderByArray[i].trim();

                if(i == 0) {
                    orderBy += "ORDER BY ";
                } else {
                    orderBy += ", ";
                }
                orderBy += orderByArray[i].trim();
            }
            sql.append(orderBy.toUpperCase());
            orderBy = "";
        }


        DBResult rs = null;
        try {
            if(pageQuery) {
                // 依分頁取出資料
                rs = Page.getPageResultSet(dbmanager, conn, sql.toString(), pageNo, pageSize);
            } else {
                // 取出所有資料
                rs = dbmanager.getSimpleResultSet(conn);
                rs.open();
                rs.executeQuery(sql.toString());
            }
//            Hashtable rowHt = null;
//
//            while (rs.next()) {
//                rowHt = new Hashtable();
//                /** 將欄位抄一份過去 */
//                for (int i = 1; i <= rs.getColumnCount(); i++)
//                    rowHt.put(rs.getColumnName(i), rs.getString(i));
//
//                vt.add(rowHt);
//            }
        } catch (Exception e) {
            throw e;
        } finally {
            if(rs != null) {
                rs.close();
            }
        }
        return rs;
    }



   /**
     * 取得學生基本資料及學籍資料
     * by poto 修改為dao格式  96/08/31
     */
    public DBResult getStut003QueryEdit(String idno,String name,String stno) throws Exception {
        if(sql.length() > 0) {
            sql.delete(0, sql.length());
        }
    	 sql.append(
                    "SELECT B.NOU_EMAIL,A.IDNO, A.BIRTHDATE, A.NAME, A.ENG_NAME, A.ALIAS, A.CRRSADDR_ZIP, A.CRRSADDR, A.AREACODE_OFFICE, A.TEL_OFFICE, A.TEL_OFFICE_EXT, A.AREACODE_HOME, A.TEL_HOME, A.MOBILE, A.EMAIL, A.EMRGNCY_NAME, A.EMRGNCY_TEL, A.EMRGNCY_RELATION, A.ROWSTAMP " +
					"FROM STUT002 A JOIN STUT003 B ON A.IDNO = B.IDNO AND A.BIRTHDATE = B.BIRTHDATE " +
					"WHERE 1=1 " +
					"AND B.STNO ='"+stno+"' " +
					"AND A.IDNO	='" + idno + "' "
                    );


//        if(!orderBy.equals("")) {
//            String[] orderByArray = orderBy.split(",");
//            orderBy = "";
//            for(int i = 0; i < orderByArray.length; i++) {
//                orderByArray[i] = "S02." + orderByArray[i].trim();
//
//                if(i == 0) {
//                    orderBy += "ORDER BY ";
//                } else {
//                    orderBy += ", ";
//                }
//                orderBy += orderByArray[i].trim();
//            }
//            sql.append(orderBy.toUpperCase());
//            orderBy = "";
//        }


        DBResult rs = null;
//        try {
//            if(pageQuery) {
//                // 依分頁取出資料
//                rs = Page.getPageResultSet(dbmanager, conn, sql.toString(), pageNo, pageSize);
//            } else {
                // 取出所有資料
                rs = dbmanager.getSimpleResultSet(conn);
                rs.open();
                rs.executeQuery(sql.toString());
//            }
//            Hashtable rowHt = null;
//
//            while (rs.next()) {
//                rowHt = new Hashtable();
//                /** 將欄位抄一份過去 */
//                for (int i = 1; i <= rs.getColumnCount(); i++)
//                    rowHt.put(rs.getColumnName(i), rs.getString(i));
//
//                vt.add(rowHt);
//            }
//        } catch (Exception e) {
//            throw e;
//        } finally {
//            if(rs != null) {
//                rs.close();
//            }
//        }
        return rs;
    }


    /**
      * 列印地址名冊
      * by tonny 修改為dao格式  96/09/05
      */
     public DBResult stu303r_1(Vector vt,Hashtable requestMap,String ASYS) throws Exception {
         if(requestMap == null) {
             requestMap = new Hashtable();
         }
         if(sql.length() > 0) {
             sql.delete(0, sql.length());
         }

		String SMS	=	Utility.checkNull(requestMap.get("SMS"), "");
		String YR	=	Utility.checkNull(requestMap.get("YR"), "");

        sql.append
        (
			"SELECT  A.CRRSADDR_ZIP, A.CRRSADDR, A.NAME, B.STNO,B.CENTER_CODE, B.FTSTUD_ENROLL_AYEARSMS, B.ST_PICTURE_SEQ_NO " +
			"FROM STUT002 A, STUT003 B " +
			"WHERE A.IDNO=B.IDNO " +
			"AND A.BIRTHDATE=B.BIRTHDATE "
		);

        if(ASYS.equals("1"))
        {
			sql.append("AND B.ASYS	=	'" + ASYS + "' ");

			if(!YR.equals("") && !SMS.equals(""))
				sql.append("AND B.FTSTUD_ENROLL_AYEARSMS =	'" + Utility.dbStr(requestMap.get("YR"))+ Utility.dbStr(requestMap.get("SMS")) +"' ");

			sql.append
			(
				"AND (B.ENROLL_STATUS='2' OR  B.DROPOUT_AYEARSMS !='" + Utility.dbStr(requestMap.get("YR"))+ Utility.dbStr(requestMap.get("SMS")) + "' ) "
			);
		}
		else if (ASYS.equals("2"))
		{
			sql.append("AND B.ASYS	=	'" + ASYS + "' ");

			if(!YR.equals(""))
				sql.append("AND B.ENROLL_AYEAR =	'" + Utility.dbStr(requestMap.get("YR"))+ "' ");
			if(!SMS.equals(""))
				sql.append("AND B.ENROLL_SMS =	'" + Utility.dbStr(requestMap.get("SMS"))+ "' ");

			sql.append
			(
				"AND (B.ENROLL_STATUS='2' OR  B.DROPOUT_AYEARSMS !='" + Utility.dbStr(requestMap.get("YR"))+ Utility.dbStr(requestMap.get("SMS")) + "' ) "
			);
		}

		sql.append
		(
			"ORDER BY B.CENTER_CODE, B.ST_PICTURE_SEQ_NO, B.STNO "
		);




         DBResult rs = null;
         try {
             if(pageQuery) {
                 // 依分頁取出資料
                 rs = Page.getPageResultSet(dbmanager, conn, sql.toString(), pageNo, pageSize);
             } else {
                 // 取出所有資料
                 rs = dbmanager.getSimpleResultSet(conn);
                 rs.open();
                 rs.executeQuery(sql.toString());
             }
             Hashtable rowHt = null;

             while (rs.next()) {
                 rowHt = new Hashtable();
                 /** 將欄位抄一份過去 */
                 for (int i = 1; i <= rs.getColumnCount(); i++)
                     rowHt.put(rs.getColumnName(i), rs.getString(i));

                 vt.add(rowHt);
             }
         } catch (Exception e) {
             throw e;
         } finally {
             if(rs != null) {
                 rs.close();
             }
         }
         return rs;
     }

     /**
      * 列印地址名冊
      * by tonny 修改為dao格式  96/09/05
      */
     public DBResult stu304r_1(Vector vt,Hashtable requestMap,String ASYS,String USER_IDNO,String USER_NAME) throws Exception {
         if(requestMap == null) {
             requestMap = new Hashtable();
         }
         if(sql.length() > 0) {
             sql.delete(0, sql.length());
         }

         Utility util  = new Utility();

		String SMS	=	Utility.checkNull(requestMap.get("SMS"), "");
		String YR	=	Utility.checkNull(requestMap.get("YR"), "");

        String strREGY_SNO = util.checkNull(requestMap.get("REGY_SNO"), "") ; // 起號
        String strREGY_ENO = util.checkNull(requestMap.get("REGY_ENO"), "") ; // 起號
		sql.append
		(
			" SELECT A.NAME , A.CRRSADDR , B.STNO , B.CENTER_CODE , B.ST_PICTURE_SEQ_NO " +
            " FROM  STUT002 A , STUT003 B " +
            " WHERE A.IDNO = B.IDNO AND A.BIRTHDATE = B.BIRTHDATE AND B.ASYS = '"+ util.checkNull(ASYS,"")+"' AND B.ST_PICTURE_SEQ_NO IS NOT NULL AND B.STTYPE in ('1','3') "
		);

       if(util.checkNull(ASYS,"").equals("1")){
          if(!util.checkNull(requestMap.get("AYEAR"), "").equals("") && !util.checkNull(requestMap.get("SMS"), "").equals("") )
			sql.append(" AND NVL(B.FTSTUD_ENROLL_AYEARSMS, B.ENROLL_AYEARSMS) = '"+ util.dbStr(requestMap.get("AYEAR")) + util.dbStr(requestMap.get("SMS"))+ "'  ");
       } else if (util.checkNull(ASYS,"").equals("2")){
           if(!util.checkNull(requestMap.get("AYEAR"), "").equals("") && !util.checkNull(requestMap.get("SMS"), "").equals("") )
                 //sql.append(" AND B.ENROLL_AYEAR = '"+util.dbStr(requestMap.get("AYEAR"))+"' AND B.ENROLL_SMS = '"+util.dbStr(requestMap.get("SMS"))+"' " );
        	   sql.append(" AND NVL(B.FTSTUD_ENROLL_AYEARSMS, B.ENROLL_AYEARSMS) = '"+ util.dbStr(requestMap.get("AYEAR")) + util.dbStr(requestMap.get("SMS"))+ "'  ");
         }
        sql.append(" AND ( B.ENROLL_STATUS = '2' OR B.DROPOUT_AYEARSMS <> '"+ util.dbStr(requestMap.get("AYEAR")) + util.dbStr(requestMap.get("SMS"))+ "' ) " );

        sql.append(" ORDER BY B.CENTER_CODE , B.ST_PICTURE_SEQ_NO , B.STNO " );



         DBResult rs = null;
         DBResult	rs1	=	null;
         try {
             if(pageQuery) {
                 // 依分頁取出資料
                 rs = Page.getPageResultSet(dbmanager, conn, sql.toString(), pageNo, pageSize);
             } else {
                 // 取出所有資料
                 rs = dbmanager.getSimpleResultSet(conn);
                 rs.open();
                 rs.executeQuery(sql.toString());
             }
             Hashtable rowHt = null;

  			rs1 = dbmanager.getSimpleResultSet(conn);
             rs1.open();

             while (rs.next()) {
                 rowHt = new Hashtable();

                 /** 取得TRAT001 教職員基本資料檔 Start... **/
                 /*
                 String strTrat = " SELECT TEL_OFFICE,TEL_OFFICE_EXT FROM TRAT001 WHERE IDNO = '"+util.checkNull(USER_IDNO,"")+"' AND NAME = '"+util.checkNull(USER_NAME,"")+"' " ;
                 rs1.executeQuery( strTrat );
                 rs1.close();
                 rs1.open();
                 if(rs1.next()){
                	 rowHt.put("tel1",util.checkNull(rs1.getString("TEL_OFFICE"),"&nbsp;&nbsp;")+"轉"+util.checkNull(rs1.getString("TEL_OFFICE_EXT"),"&nbsp;&nbsp;"));		//電話分機
                 }else {
                	 rowHt.put("tel1","");
                  }

                 /** 將欄位抄一份過去 */
                 for (int i = 1; i <= rs.getColumnCount(); i++)
                     rowHt.put(rs.getColumnName(i), rs.getString(i));

                 vt.add(rowHt);
             }
         } catch (Exception e) {
             throw e;
         } finally {
             if(rs != null) {
                 rs.close();
             }
             if(rs1 != null) {
                 rs1.close();
             }
         }
         return rs;
     }


   /**
     *stut007架構調整 by poto
     * @throws Exception
     */
    public DBResult getStut007QueryEditSTNO(Hashtable requestMap) throws Exception {
        if(requestMap == null) {
            requestMap = new Hashtable();
        }
        String  CENTER_CODE = Utility.checkNull((String)requestMap.get("CENTER_CODE2"), ""); //中心

        Vector result = new Vector();
        if(sql.length() > 0) {
            sql.delete(0, sql.length());
        }
		sql.append("SELECT B.ENROLL_STATUS,B.ASYS,A.NAME,B.CENTER_CODE,C.CODE_NAME AS CENTER_CODE_DESC,B.STTYPE,D.CODE_NAME AS STTYPE_DESC,B.IDNO,CRRSADDR,CRRSADDR_ZIP ");
		sql.append("FROM STUT002 A ");
		sql.append("JOIN STUT003 B ON A.IDNO = B.IDNO AND A.BIRTHDATE = B.BIRTHDATE ");
		sql.append("JOIN SYST001 C ON B.CENTER_CODE = C.CODE AND C.KIND = 'CENTER_CODE' ");
		sql.append("JOIN SYST001 D ON B.STTYPE = D.CODE AND D.KIND = 'STTYPE' ");
		sql.append("WHERE B.STNO = '").append(Utility.dbStr(requestMap.get("STNO"))).append("'");
		sql.append(" AND  B.ASYS = '").append(Utility.dbStr(requestMap.get("ASYS"))).append("'");
		/*
        if (!"".equals(CENTER_CODE))
        {
            CENTER_CODE = CENTER_CODE.substring(0,CENTER_CODE.length()-1);
            sql.append("AND B.CENTER_CODE IN (" + CENTER_CODE + ") ");
        }
        */

        if(!orderBy.equals("")) {
            String[] orderByArray = orderBy.split(",");
            orderBy = "";
            for(int i = 0; i < orderByArray.length; i++) {
                orderByArray[i] = "S07." + orderByArray[i].trim();

                if(i == 0) {
                    orderBy += "ORDER BY ";
                } else {
                    orderBy += ", ";
                }
                orderBy += orderByArray[i].trim();
            }
            sql.append(orderBy.toUpperCase());
            orderBy = "";
        }
        DBResult rs = null;
//        rs = Page.getPageResultSet(dbmanager, conn, sql.toString(), pageNo, pageSize);
        rs = dbmanager.getSimpleResultSet(conn);
        rs.open();
        rs.executeQuery(sql.toString());
        return rs;
    }

    /**
     * 列印英文在學證明書 A4 - 列印 (STUT002, STUT003, REGT005)
     * @param ht 條件值
     * @return 回傳 DBResult 物件
     * @throws Exception
     */
    public DBResult getStu309rPrint(Hashtable ht) throws Exception
    {
        DBResult    rs      =   null;


        try
        {
            //條件欄位
            String  ASYS        =   Utility.checkNull((String)ht.get("ASYS"), "");          //學制
            String  AYEAR       =   Utility.checkNull((String)ht.get("AYEAR"), "");         //學年
            String  SMS         =   Utility.checkNull((String)ht.get("SMS"), "");           //學期
            String  STNO        =   Utility.checkNull((String)ht.get("STNO"), "");          //學號
            String  NAME        =   Utility.checkNull((String)ht.get("NAME"), "");          //中文姓名
            String  queryType   =   Utility.checkNull((String)ht.get("queryType"), "");     //查詢方式


            //將 SQL 清空
            if (sql.length() > 0)
                sql.delete(0, sql.length());


            sql.append
            (
                "SELECT DISTINCT A.NAME, A.ENG_NAME, A.BIRTHDATE, B.STNO, B.ENROLL_AYEARSMS, C.TAKE_ABNDN, C.PAYMENT_STATUS, " +
                "B.ENROLL_STATUS, B.CENTER_CODE " +
                "FROM STUT002 A, STUT003 B, REGT005 C " +
                "WHERE " +
                "A.IDNO = B.IDNO AND " +
                "A.BIRTHDATE = B.BIRTHDATE AND " +
                "B.STNO = C.STNO "
            );


            if (!"".equals(ASYS))
                sql.append("AND B.ASYS = '" + ASYS + "' ");

            if (!"".equals(AYEAR))
                sql.append("AND C.AYEAR = '" + AYEAR + "' ");

            if (!"".equals(SMS))
                sql.append("AND C.SMS = '" + SMS + "' ");

            if ("1".equals(queryType))
            {
                if(!"".equals(STNO))
                    sql.append("AND B.STNO = '" + STNO + "' ");
            }
            else
            {
                if(!"".equals(NAME))
                    sql.append("AND A.NAME = '" + NAME + "' ");
            }


            //排序
            if (!"".equals(orderBy))
            {
                sql.append("ORDER BY " + orderBy);
                orderBy = "";
            }


            System.out.println(sql.toString());


            // 依分頁取出資料
            if (pageQuery)
            {
                rs = Page.getPageResultSet(dbmanager, conn, sql.toString(), pageNo, pageSize);
            }
            // 取出所有資料
            else
            {
                rs = dbmanager.getSimpleResultSet(conn);
                rs.open();
                rs.executeQuery(sql.toString());
            }


            return rs;
        }
        catch(Exception e)
        {
            throw e;
        }
    }
    
    /**
     * 列印中文在學證明書 A4 - 列印 (STUT002, STUT003, REGT005)
     * @param ht 條件值
     * @return 回傳 DBResult 物件
     * @throws Exception
     */
    public DBResult getStu316rPrint(Hashtable ht) throws Exception
    {
        DBResult    rs      =   null;


        try
        {
            //條件欄位
            String  ASYS        =   Utility.checkNull((String)ht.get("ASYS"), "");          //學制
            String  AYEAR       =   Utility.checkNull((String)ht.get("AYEAR"), "");         //學年
            String  SMS         =   Utility.checkNull((String)ht.get("SMS"), "");           //學期
            String  STNO        =   Utility.checkNull((String)ht.get("STNO"), "");          //學號
            String  NAME        =   Utility.checkNull((String)ht.get("NAME"), "");          //中文姓名
            String  queryType   =   Utility.checkNull((String)ht.get("queryType"), "");     //查詢方式


            //將 SQL 清空
            if (sql.length() > 0)
                sql.delete(0, sql.length());


            sql.append
            (
                "SELECT DISTINCT C.AYEAR, C.SMS, A.NAME, D.CODE_NAME AS ASYS_NAME, SUBSTR(A.BIRTHDATE,1,4)-1911||'年'||SUBSTR(A.BIRTHDATE,5,2)||'月'||SUBSTR(A.BIRTHDATE,7,2)||'日' AS BIRTHDATE, B.STNO, B.ENROLL_AYEARSMS, C.TAKE_ABNDN, C.PAYMENT_STATUS, " +
                "B.ENROLL_STATUS, B.CENTER_CODE, C.TOTAL_CRD_CNT " +
                "FROM STUT002 A " +
                "JOIN STUT003 B ON A.IDNO = B.IDNO AND A.BIRTHDATE = B.BIRTHDATE " +
                "JOIN REGT005 C ON B.STNO = C.STNO " +
                "JOIN SYST001 D ON D.KIND = 'ASYS' AND D.CODE = B.ASYS " +
                "JOIN STUT004 E ON E.STNO = C.STNO AND E.AYEAR = C.AYEAR AND E.SMS = C.SMS " +
                "WHERE E.STTYPE !='2' " +
                " "
            );


           // if (!"".equals(ASYS))
           //     sql.append("AND B.ASYS = '" + ASYS + "' ");

            if (!"".equals(AYEAR))
                sql.append("AND C.AYEAR = '" + AYEAR + "' ");

            if (!"".equals(SMS))
                sql.append("AND C.SMS = '" + SMS + "' ");

            if ("1".equals(queryType))
            {
                if(!"".equals(STNO))
                    sql.append("AND B.STNO = '" + STNO + "' ");
            }
            else
            {
                if(!"".equals(NAME))
                    sql.append("AND A.NAME = '" + NAME + "' ");
            }


            //排序
            if (!"".equals(orderBy))
            {
                sql.append("ORDER BY " + orderBy);
                orderBy = "";
            }


            System.out.println(sql.toString());


            // 依分頁取出資料
            if (pageQuery)
            {
                rs = Page.getPageResultSet(dbmanager, conn, sql.toString(), pageNo, pageSize);
            }
            // 取出所有資料
            else
            {
                rs = dbmanager.getSimpleResultSet(conn);
                rs.open();
                rs.executeQuery(sql.toString());
            }


            return rs;
        }
        catch(Exception e)
        {
            throw e;
        }
    }

    /**
	 * 招生報名_取出學籍資料
	 *
	 * @throws Exception
	 */
	public SignupInfo getStut002SignupInfo(String idno,String birthdate) throws Exception {
		DBResult rs = null;
		SignupInfo si = null;
		try {
			StringBuffer sqls = new StringBuffer();
			sqls.append("select a.NAME, a.DMSTADDR, a.DMSTADDR_ZIP, a.CRRSADDR, a.CRRSADDR_ZIP, a.TEL_OFFICE, a.TEL_HOME, a.MOBILE, a.EMAIL, a.MARRIAGE, a.VOCATION,");
			sqls.append("a.EMRGNCY_NAME, a.EMRGNCY_RELATION, a.EMRGNCY_TEL, a.IDNO, a.BIRTHDATE "); 
			sqls.append("from STUT002 a ");
			sqls.append("where a.IDNO = '"+idno+"' and a.BIRTHDATE = '"+birthdate+"'");		
			
			rs = dbmanager.getSimpleResultSet(conn);
			rs.open();
			rs.executeQuery(sqls.toString());

			while (rs.next()) {
				si = new SignupInfo();
				Class cls = si.getClass();

				for (int i = 1; i <= rs.getColumnCount(); i++) {
					Transformer tf = new Transformer();
					Method method = cls.getMethod(tf.getMethodName(rs.getColumnName(i)), new Class[] { String.class });
					method.invoke(si, new String[] { rs.getString(i) });
				}
			}
		} catch (Exception e) {
			throw e;
		} finally {
			if (rs != null) {
				rs.close();
			}
		}

		return si;
	}

	/**
	 * 取出學生姓名
	 *
	 * @throws Exception
	 */
	public Hashtable getStut002Stut003Query(String stno) throws Exception {
		DBResult rs = null;
		Hashtable ht = new Hashtable();
		try {
			StringBuffer sqls = new StringBuffer();
			sqls.append("SELECT A.NAME ");
			sqls.append("FROM STUT002 A JOIN STUT003 B ON A.IDNO = B.IDNO AND A.BIRTHDATE = B.BIRTHDATE ");
			sqls.append("WHERE B.STNO = '");
			sqls.append(stno);
			sqls.append("'");

			rs = dbmanager.getSimpleResultSet(conn);
			rs.open();
			rs.executeQuery(sqls.toString());

			while (rs.next()) {
				ht.put(rs.getColumnName(1), rs.getString("NAME"));
			}
		} catch (Exception e) {
			throw e;
		} finally {
			if (rs != null) {
				rs.close();
			}
		}

		return ht;
	}

	public void getStu013mQuery(Vector vt, Hashtable ht) throws Exception {
		DBResult rs = null;
		try
		{
			if(sql.length() >0)
				sql.delete(0, sql.length());
            /*
			sql.append
			(
				"SELECT a.IDNO, b.STNO, a.NAME, a.BIRTHDATE, b.CENTER_CODE, " +
				"(SELECT c.CENTER_ABBRNAME FROM SYST002 c WHERE b.CENTER_CODE=c.CENTER_CODE) CENTER_NAME, " +
				"b.STTYPE, " +
				"SUBSTR(d.UPD_DOC_NO_REASON, INSTR(d.UPD_DOC_NO_REASON, '|')+1) UPD_REASON, " +
				"SUBSTR(d.UPD_DOC_NO_REASON, 0, INSTR(d.UPD_DOC_NO_REASON, '|')-1) UPD_DOC_NO " +
				"FROM STUT002 a JOIN STUT003 b ON a.IDNO=b.IDNO AND a.BIRTHDATE=b.BIRTHDATE " +
				"LEFT JOIN STUT021 d ON b.STNO=d.STNO " +
				"WHERE '1'='1'"
			);
            */
            sql.append
			(
				"SELECT a.IDNO, b.STNO, a.NAME, a.BIRTHDATE, b.CENTER_CODE, " +
				"c.CENTER_ABBRNAME AS CENTER_NAME, " +
				"b.STTYPE, " +
				"'' UPD_REASON, " +
				"'' UPD_DOC_NO " +
				"FROM STUT002 a "+
                "JOIN STUT003 b ON a.IDNO=b.IDNO AND a.BIRTHDATE=b.BIRTHDATE " +
                "JOIN SYST002 C ON b.CENTER_CODE=c.CENTER_CODE " +
				"WHERE '1'='1'"
			);
			if(!Utility.checkNull(ht.get("STNO"), "").equals(""))
				sql.append("AND b.STNO = '" + Utility.dbStr(ht.get("STNO")) + "' ");

			if(!Utility.checkNull(ht.get("IDNO"), "").equals(""))
				sql.append("AND b.IDNO = '" + Utility.dbStr(ht.get("IDNO")) + "' ");

			if(!Utility.checkNull(ht.get("NAME"), "").equals(""))
				sql.append("AND a.NAME = '" + Utility.dbStr(ht.get("NAME")) + "' ");

			sql.append("ORDER BY a.IDNO ASC" );

			if(pageQuery) {
				rs = Page.getPageResultSet(dbmanager, conn, sql.toString(), pageNo, pageSize);
			} else {
				rs = dbmanager.getSimpleResultSet(conn);
				rs.open();
				rs.executeQuery(sql.toString());
			}

			Hashtable rowHt = null;
			while (rs.next())
			{
				rowHt = new Hashtable();
				for (int i = 1; i <= rs.getColumnCount(); i++)
					rowHt.put(rs.getColumnName(i), rs.getString(i));
				vt.add(rowHt);
			}

		}
		catch(Exception e)
		{
			throw e;
		}
		finally
		{
			if (rs != null)
				rs.close();
		}
	}

	/*
    * 判斷所輸入的資料是否為學生
    *
    */
	public Vector  isStudent(Hashtable ht) throws Exception {
		Vector result = new Vector();

		DBResult rs = null;
		try
		{
			if(sql.length() >0)
				sql.delete(0, sql.length());

			sql.append(
					"select c.EMAIL "+
					"from autt001 a, autt005 b, stut002 c "+
					"where "+
				    "    a.user_idno='"+Utility.dbStr(ht.get("IDNO"))+"' "+
					"and a.user_id='"+Utility.dbStr(ht.get("inputRememberText"))+"' "+
					"and a.user_id= b.user_id "+
					"and b.id_type='1' "+
					"and c.idno=a.user_idno "+
					"and c.BIRTHDATE='"+Utility.dbStr(ht.get("BIRTHDATE"))+"' "
				);

			rs = dbmanager.getSimpleResultSet(conn);
			rs.open();
			rs.executeQuery(sql.toString());

			String hasData = "not"; // 檢核是否有資料
			String eMail = "";
			if (rs.next()){
				hasData = "yes";
				eMail = rs.getString("EMAIL");
			}
			result.add(hasData);
			result.add(eMail);
		}
		catch(Exception e)
		{
			throw e;
		}
		finally
		{
			if (rs != null)
				rs.close();
		}
		return result;
	}
	
	 public Vector getDataForDes001m_01v1_GRA_DATA(Hashtable ht) throws Exception {
        if(ht == null) {
            ht = new Hashtable();
        }
        Vector result = new Vector();
        if(sql.length() > 0) {
            sql.delete(0, sql.length());
        }
        
        sql.append(
			"SELECT E.TOTAL_CRS_NAME AS FACULTY_NAME,B.STNO,D.CENTER_NAME,SUBSTR(B.ENROLL_AYEARSMS,1,3)||SUBSTR(G.CODE_NAME,1,1) AS ENROLL_AYEAR_SMS,C.AYEAR||SUBSTR(F.CODE_NAME,1,1) AS GRA_AYEAR_SMS "+
			"FROM STUT002 A  "+
			"JOIN STUT003 B ON A.IDNO = B.IDNO AND A.BIRTHDATE = B.BIRTHDATE "+
			"JOIN GRAT003 C ON B.STNO = C.STNO AND C.GRAD_REEXAM_STATUS = '2' "+
			"JOIN SYST002 D ON D.CENTER_CODE = C.GRAD_CEN "+
			"JOIN SYST008 E ON E.FACULTY_CODE = C.GRAD_MAJOR_FACULTY AND E.TOTAL_CRS_NO = '01' "+
			"JOIN SYST001 F ON F.KIND = 'SMS' AND F.CODE = C.SMS "+
			"JOIN SYST001 G ON G.KIND = 'SMS' AND G.CODE = SUBSTR(B.ENROLL_AYEARSMS,4,1) "+
			"WHERE 1=1 "+
			"AND A.IDNO = '" + Utility.nullToSpace(ht.get("IDNO")) + "' "+
			"AND A.BIRTHDATE = '" + Utility.nullToSpace(ht.get("BIRTHDATE")) + "' "+
			"UNION "+
			"SELECT E.TOTAL_CRS_NAME AS FACULTY_NAME,B.STNO,D.CENTER_NAME,SUBSTR(B.ENROLL_AYEARSMS,1,3)||SUBSTR(G.CODE_NAME,1,1) AS ENROLL_AYEAR_SMS,C.AYEAR||SUBSTR(F.CODE_NAME,1,1) AS GRA_AYEAR_SMS "+
			"FROM STUT002 A  "+
			"JOIN STUT003 B ON A.IDNO = B.IDNO AND A.BIRTHDATE = B.BIRTHDATE "+
			"JOIN GRAT003 C ON B.STNO = C.STNO AND C.GRAD_REEXAM_STATUS = '2' "+
			"JOIN SYST002 D ON D.CENTER_CODE = C.GRAD_CEN "+
			"JOIN SYST008 E ON E.FACULTY_CODE = C.DBMAJOR_GRAD_FACULTY_CODE1 AND E.TOTAL_CRS_NO = '01' "+
			"JOIN SYST001 F ON F.KIND = 'SMS' AND F.CODE = C.SMS "+
			"JOIN SYST001 G ON G.KIND = 'SMS' AND G.CODE = SUBSTR(B.ENROLL_AYEARSMS,4,1) "+
			"WHERE 1=1 "+
			"AND A.IDNO = '" + Utility.nullToSpace(ht.get("IDNO")) + "' "+
			"AND A.BIRTHDATE = '" + Utility.nullToSpace(ht.get("BIRTHDATE")) + "' "+
			"UNION "+
			"SELECT E.TOTAL_CRS_NAME AS FACULTY_NAME,B.STNO,D.CENTER_NAME,SUBSTR(B.ENROLL_AYEARSMS,1,3)||SUBSTR(G.CODE_NAME,1,1) AS ENROLL_AYEAR_SMS,C.AYEAR||SUBSTR(F.CODE_NAME,1,1) AS GRA_AYEAR_SMS "+
			"FROM STUT002 A  "+
			"JOIN STUT003 B ON A.IDNO = B.IDNO AND A.BIRTHDATE = B.BIRTHDATE "+
			"JOIN GRAT003 C ON B.STNO = C.STNO AND C.GRAD_REEXAM_STATUS = '2' "+
			"JOIN SYST002 D ON D.CENTER_CODE = C.GRAD_CEN "+
			"JOIN SYST008 E ON E.FACULTY_CODE = C.DBMAJOR_GRAD_FACULTY_CODE2 AND E.TOTAL_CRS_NO = '01' "+
			"JOIN SYST001 F ON F.KIND = 'SMS' AND F.CODE = C.SMS "+
			"JOIN SYST001 G ON G.KIND = 'SMS' AND G.CODE = SUBSTR(B.ENROLL_AYEARSMS,4,1) "+
			"WHERE 1=1 "+
			"AND A.IDNO = '" + Utility.nullToSpace(ht.get("IDNO")) + "' "+
			"AND A.BIRTHDATE = '" + Utility.nullToSpace(ht.get("BIRTHDATE")) + "' "+
			"UNION "+
			"SELECT E.TOTAL_CRS_NAME AS FACULTY_NAME,B.STNO,D.CENTER_NAME,SUBSTR(B.ENROLL_AYEARSMS,1,3)||SUBSTR(G.CODE_NAME,1,1) AS ENROLL_AYEAR_SMS,C.AYEAR||SUBSTR(F.CODE_NAME,1,1) AS GRA_AYEAR_SMS "+
			"FROM STUT002 A  "+
			"JOIN STUT003 B ON A.IDNO = B.IDNO AND A.BIRTHDATE = B.BIRTHDATE "+
			"JOIN GRAV014 C ON B.STNO = C.STNO AND C.STATUS = '2' "+
			"JOIN SYST002 D ON D.CENTER_CODE = C.CENTER_CODE "+
			"JOIN SYST008 E ON E.FACULTY_CODE||E.TOTAL_CRS_NO = C.FACULTY_CODE AND E.TOTAL_CRS_NO <> '01' AND SUBSTR(E.TOTAL_CRS_NO,1,1) = '0' "+
			"JOIN SYST001 F ON F.KIND = 'SMS' AND F.CODE = C.SMS "+
			"JOIN SYST001 G ON G.KIND = 'SMS' AND G.CODE = SUBSTR(B.ENROLL_AYEARSMS,4,1) "+
			"WHERE 1=1 "+
			"AND A.IDNO = '" + Utility.nullToSpace(ht.get("IDNO")) + "' "+
			"AND A.BIRTHDATE = '" + Utility.nullToSpace(ht.get("BIRTHDATE")) + "' "
    	);

        DBResult rs = null;
        try {
            if(pageQuery) {
                // 依分頁取出資料
                rs = Page.getPageResultSet(dbmanager, conn, sql.toString(), pageNo, pageSize);
            } else {
                // 取出所有資料
                rs = dbmanager.getSimpleResultSet(conn);
                rs.open();
                rs.executeQuery(sql.toString());
            }
            Hashtable rowHt = null;
            while (rs.next()) {
                rowHt = new Hashtable();
                /** 將欄位抄一份過去 */
                for (int i = 1; i <= rs.getColumnCount(); i++)
                    rowHt.put(rs.getColumnName(i), rs.getString(i));

                result.add(rowHt);
            }
        } catch (Exception e) {
            throw e;
        } finally {
            if(rs != null) {
                rs.close();
            }
        }
        return result;
    }
	 
	 public Hashtable getDataForDes001m_01v1_STU_DATA(Hashtable ht) throws Exception {
        if(ht == null) {
            ht = new Hashtable();
        }
        Hashtable rowHt = new Hashtable();
        if(sql.length() > 0) {
            sql.delete(0, sql.length());
        }
        
        sql.append(
    		"SELECT A.NAME,A.ENG_NAME,A.IDNO,A.BIRTHDATE,B.CODE_NAME AS SEX_NAME, "+
        	"       A.FAX_AREACODE,A.FAX_TEL,A.DMSTADDR_ZIP,A.DMSTADDR,A.CRRSADDR_ZIP,A.CRRSADDR, "+
        	"       A.AREACODE_OFFICE,A.TEL_OFFICE,A.TEL_OFFICE_EXT,A.AREACODE_HOME,A.TEL_HOME, "+
        	"       A.MOBILE,A.EMAIL,C.IS_DATE_MK,C.RMK "+
	        "		,( "+
	        "		    SELECT TO_CHAR(WMSYS.WM_CONCAT(UNIQUE TO_CHAR(GRA40.STATUS)))  "+
	        "		    FROM GRAT040 GRA40  "+
	        "		    WHERE 1=1  "+
	        "		    AND GRA40.IDNO = A.IDNO "+
	        "		    AND GRA40.BIRTHDATE = A.BIRTHDATE "+
	        "		) AS DES_STATUS_VAL "+
	        "		,( "+
	        "		    SELECT TO_CHAR(WMSYS.WM_CONCAT(UNIQUE TO_CHAR(GRA39.PROFESSIONAL)))  "+
	        "		    FROM GRAT039 GRA39  "+
	        "		    WHERE 1=1  "+
	        "		    AND GRA39.IDNO = A.IDNO "+
	        "		    AND GRA39.BIRTHDATE = A.BIRTHDATE "+
	        "		) AS VOCATION_VAL "+
        	"FROM STUT002 A "+
        	"JOIN SYST001 B ON B.KIND = 'SEX' AND A.SEX = B.CODE "+
        	"LEFT JOIN DEST001 C ON C.IDNO = A.IDNO AND C.BIRTHDATE = A.BIRTHDATE "+
        	"WHERE 1=1  "+
        	"AND A.IDNO = '" + Utility.nullToSpace(ht.get("IDNO")) + "' "+ 
        	"AND A.BIRTHDATE = '" + Utility.nullToSpace(ht.get("BIRTHDATE")) + "' "
    	);

        DBResult rs = null;
        try {
            rs = dbmanager.getSimpleResultSet(conn);
            rs.open();
            rs.executeQuery(sql.toString());
            
            if (rs.next()) {
                for (int i = 1; i <= rs.getColumnCount(); i++)
                    rowHt.put(rs.getColumnName(i), rs.getString(i));
            }
        } catch (Exception e) {
            throw e;
        } finally {
            if(rs != null) {
                rs.close();
            }
        }
        return rowHt;
    }
	 
	 public DBResult CheckSTNO_isGra(Hashtable ht) throws Exception {
        sql.append(
			"SELECT COUNT(1) AS EXIST " +
			"FROM STUT003 "+
			"WHERE 1=1 "+
			"AND IDNO = '"+Utility.nullToSpace(ht.get("IDNO"))+"' "+
			"AND BIRTHDATE =  '"+Utility.nullToSpace(ht.get("BIRTHDATE"))+"' "+
			"AND  "+
			"( "+
			"    EXISTS (SELECT 1 FROM GRAT003 WHERE  STUT003.STNO = GRAT003.STNO AND STUT003.ASYS = '1' AND GRAT003.GRAD_REEXAM_STATUS ='2') "+
			"    OR "+
			"    EXISTS (SELECT 1 FROM GRAV014 WHERE STUT003.STNO = GRAV014.STNO AND STUT003.ASYS = '2' AND GRAV014.STATUS ='2' ) "+
			") "
    	);

        DBResult rs = null;
        try {
            rs = dbmanager.getSimpleResultSet(conn);
            rs.open();
            rs.executeQuery(sql.toString());
        } catch (Exception e) {
            if(rs != null) {
                rs.close();
            }
            throw e;
        }
        return rs;
    }
	 
	 /**
     *
     * @param ht 條件值
     * @return 回傳 Vector 物件，內容為 Hashtable 的集合，<br>
     *         每一個 Hashtable 其 KEY 為欄位名稱，KEY 的值為欄位的值<br>
     *         若該欄位有中文名稱，則其 KEY 請加上 _NAME, EX: SMS 其中文欄位請設為 SMS_NAME
     * @throws Exception
     */
    public Vector getStut002_stu003q(Hashtable ht) throws Exception {
        if(ht == null) {
            ht = new Hashtable();
        }
        Vector result = new Vector();
        if(sql.length() > 0) {
            sql.delete(0, sql.length());
        }
        sql.append(
            "SELECT DISTINCT S02.*, " +
            "S11.CODE_NAME AS SEX_NAME, "+
            "S12.CODE_NAME AS NATION_NAME, "+
            "S13.CODE_NAME AS VOCATION_NAME, "+
            "S14.CODE_NAME AS EDUBKGRD_NAME " +
            "FROM STUT002 S02 " +
            "JOIN STUT003 S03 ON S02.IDNO = S03.IDNO AND S02.BIRTHDATE = S03.BIRTHDATE " +
            "JOIN SYST001 S11 ON S11.KIND = 'SEX' AND S02.SEX = S11.CODE " +
            "LEFT JOIN SYST001 S12 ON S12.KIND = 'NATIONCODE' AND S12.CODE = S02.NATIONCODE " +
            "LEFT JOIN SYST001 S13 ON S13.KIND = 'VOCATION' AND S02.VOCATION = S13.CODE  " +
            "LEFT JOIN SYST001 S14 ON S14.KIND = 'EDUBKGRD_GRADE' AND S02.EDUBKGRD_GRADE = S14.CODE " +
            
            "WHERE 1 = 1 "
        );
        if(!Utility.nullToSpace(ht.get("IDNO")).equals("")) {
            sql.append("AND S02.IDNO = '" + Utility.nullToSpace(ht.get("IDNO")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("STNO")).equals("")) {
            sql.append("AND S03.STNO = '" + Utility.nullToSpace(ht.get("STNO")) + "' ");
        }
        

        if(!orderBy.equals("")) {
            String[] orderByArray = orderBy.split(",");
            orderBy = "";
            for(int i = 0; i < orderByArray.length; i++) {
                orderByArray[i] = "S02." + orderByArray[i].trim();

                if(i == 0) {
                    orderBy += "ORDER BY ";
                } else {
                    orderBy += ", ";
                }
                orderBy += orderByArray[i].trim();
            }
            sql.append(orderBy.toUpperCase());
            orderBy = "";
        }

        DBResult rs = null;
        try {
            if(pageQuery) {
                // 依分頁取出資料
                rs = Page.getPageResultSet(dbmanager, conn, sql.toString(), pageNo, pageSize);
            } else {
                // 取出所有資料
                rs = dbmanager.getSimpleResultSet(conn);
                rs.open();
                rs.executeQuery(sql.toString());
            }
            Hashtable rowHt = null;
            while (rs.next()) {
                rowHt = new Hashtable();
                /** 將欄位抄一份過去 */
                for (int i = 1; i <= rs.getColumnCount(); i++)
                    rowHt.put(rs.getColumnName(i), rs.getString(i));

                result.add(rowHt);
            }
        } catch (Exception e) {
            throw e;
        } finally {
            if(rs != null) {
                rs.close();
            }
        }
        return result;
    }
}