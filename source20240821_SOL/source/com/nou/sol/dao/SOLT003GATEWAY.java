package com.nou.sol.dao;

import java.lang.reflect.Method;
import java.sql.Connection;
import java.util.Hashtable;
import java.util.Vector;

import com.acer.apps.Page;
import com.acer.db.DBManager;
import com.acer.db.query.DBResult;
import com.acer.util.DateUtil;
import com.acer.util.Utility;
import com.nou.pop.signup.tool.Transformer;
import com.nou.sol.signup.po.PrintInfo;
import com.nou.sol.signup.po.SignupInfo;

/*
 * (SOLT003) Gateway/*
 *-------------------------------------------------------------------------------*
 * Author    : 國長      2007/05/04
 * Modification Log :
 * Vers     Date           By             Notes
 *--------- -------------- -------------- ----------------------------------------
 * V0.0.1   2007/05/04     國長           建立程式
 *                                        新增 getSolt003ForUse(Hashtable ht)
 * VO.0.2   2007/05/09     俊賢           新增 getSolt003Solt006ForUse(Hashtable ht)
 * V0.0.3   2007/05/14     俊賢           新增 getSolt003Trau001Forprint(Hashtable ht)
 * V0.0.4   2007/05/11     國榮           新增 getSolt003SingupChargeNotpay()
 * V0.0.5   2007/05/17     國榮           新增 getEntranceList()
 *                                        CENTER_CODE
 *                                        getCENTER_CODE()
 *                                        setCENTER_CODE(String CENTER_CODE)
 *                                        AREAR
 *                                        getAyear()
 *                                        setAyear(String AREAR)
 *                                        SMS
 *                                        getSMS()
 *                                        setSMS(String SMS)
 * V0.0.6   2007/05/18     jeff           新增 getDataForSol010(Vector vt, Hashtable ht)
 * V0.0.7   2007/06/07     審判無名氏     新增 getSolt003ForGettingCredits(Hashtable ht, int credit)
 *                                             getSolt003ForRegManner2(Hashtable ht)
 *                                             getSolt003ForNameAddrList(Hashtable ht)
 * V0.0.8   2007/08/08       hung              getSoltoo3Solt006ForUse(Hashtable ht)
                                               getSoltoo3Compare(Hashtable ht)
 * V0.0.9   2007/08/08      alex          新增 getSolt003Trat001ForUse(Hashtable ht)
 * V0.0.10  2007/08/15      alex          新增 getSolt003Solt006Solt007Print(Hashtable ht)
 * V0.0.11  2007/08/15      俊賢          新增 getSoltoo3Solt002Solt006ForUse(Hashtable ht)
 * V0.0.12  2007/08/16      alex          新增 getSolt003Solt006Solt007Print1(Hashtable ht)
 * V0.0.13  2007/8/23       俊賢          新增 getSolt003Syst001ForUse(Hashtable ht)
 * V0.0.14  2007/9/20       alex          新增 getSolt003Regt007Print(Hashtable ht)
 * V0.0.15  2007/9/20       alex          新增 getSolt003Solt006Print(Hashtable ht)
 * V0.0.15  2007/10/1       alex          新增 getSolt003PayManPrint(Hashtable ht)
 * V0.0.15  2007/10/1       alex          新增 getSolt003Sun_MoneyPrint(Hashtable ht)
 * V0.0.16  2007/10/1       alex          新增 getSolt003reg_manner1Print(Hashtable ht)
 * V0.0.17  2007/11/05       shony          新增 getSolt003QuerySignupInfo(String idno, String birthday, String ayear, String sms, String asys)
 * V0.0.18  2007/11/5       alex          修改 getSolt003Solt006Solt007Print(Hashtable ht)
 * V0.0.19  2007/11/06       leon          修改 getSolt003Solt006ForUse(Hashtable ht)
 * V0.0.20  2007/11/09       shony          新增 getSolt003CheckSignupInfo(String idno, String ayear, String sms, String asys)
 * V0.0.21  2007/11/09       shony          新增  getSolt003Solt006Solt007QueryPrintInfo(String idno, String ayear, String sms, String asys, String birthday)
 * V0.0.22  2007/11/28       shony          修改getSolt003Solt006Solt007QueryPrintInfo(String idno, String ayear, String sms, String asys, String birthday)
 * VO.0.23  2008/03/26     barry           新增 getSolt003Solt006ForUse(Hashtable ht, int corss)
 * VO.0.24  2010/08/24      xdghost          新增getSolt003LimitStudentDateForUse(Hashtable ht)
 *--------------------------------------------------------------------------------
 */
public class SOLT003GATEWAY {

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
    private SOLT003GATEWAY() {}

    /** 建構子，查詢全部資料用 */
    public SOLT003GATEWAY(DBManager dbmanager, Connection conn) {
        this.dbmanager = dbmanager;
        this.conn = conn;
    }

    /** 建構子，查詢分頁資料用 */
    public SOLT003GATEWAY(DBManager dbmanager, Connection conn, int pageNo, int pageSize) {
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
    public Vector getSolt003ForUse(Hashtable ht) throws Exception {
        if(ht == null) {
            ht = new Hashtable();
        }
        Vector result = new Vector();
        if(sql.length() > 0) {
            sql.delete(0, sql.length());
        }
        sql.append(
            //"SELECT S03.ASYS, S03.AYEAR, S03.SMS, S03.IDNO, S03.BIRTHDATE, S03.CENTER_ABBRNAME, S03.STTYPE, S03.NAME, S03.ENG_NAME, S03.ALIAS, S03.SEX, S03.VOCATION, S03.EDUBKGRD, S03.EDUBKGRD_GRADE, S03.AREACODE_OFFICE, S03.TEL_OFFICE, S03.TEL_OFFICE__EXT, S03.AREACODE_HOME, S03.TEL_HOME, S03.MOBILE, S03.MARRIAGE, S03.DMSTADDR, S03.DMSTADDR_ZIP, S03.CRRSADDR_ZIP, S03.CRRSADDR, S03.EMAIL, S03.EMRGNCY_TEL, S03.EMRGNCY_RELATION, S03.EMRGNCY_NAME, S03.UPD_RMK, S03.UPD_DATE, S03.UPD_TIME, S03.UPD_USER_ID, S03.ROWSTAMP, S03.GETINFO, S03.TUTOR_CLASS_MK, S03.PRE_MAJOR_FACULTY, S03.HANDICAP_TYPE, S03.HANDICAP_GRADE, S03.ORIGIN_RACE, S03.STNO, S03.REG_MANNER, S03.SERNO, S03.J_FACULTY_CODE, S03.GRAD_AYEAR " +
        	  "SELECT S03.ASYS, S03.AYEAR, S03.SMS, S03.IDNO, S03.BIRTHDATE, S03.CENTER_CODE, S03.STTYPE, S03.NAME, S03.ENG_NAME, S03.ALIAS, S03.SEX, S03.A.SELF_IDENTITY_SEX, S03.VOCATION, S03.EDUBKGRD, S03.EDUBKGRD_GRADE, S03.AREACODE_OFFICE, S03.TEL_OFFICE, S03.TEL_OFFICE_EXT, S03.AREACODE_HOME, S03.TEL_HOME, S03.MOBILE, S03.MARRIAGE, S03.DMSTADDR, S03.DMSTADDR_ZIP, S03.CRRSADDR_ZIP, S03.CRRSADDR, S03.EMAIL, S03.EMRGNCY_TEL, S03.EMRGNCY_RELATION, S03.EMRGNCY_NAME, S03.UPD_RMK, S03.UPD_DATE, S03.UPD_TIME, S03.UPD_USER_ID, S03.ROWSTAMP, S03.GETINFO, S03.TUTOR_CLASS_MK, S03.PRE_MAJOR_FACULTY, S03.HANDICAP_TYPE, S03.HANDICAP_GRADE, S03.ORIGIN_RACE, S03.STNO, S03.REG_MANNER, S03.SERNO, S03.J_FACULTY_CODE, S03.GRAD_AYEAR, S03.MAIL_DOC " +
            "FROM SOLT003 S03 " +
            "WHERE 1 = 1 "
        );
        if(!Utility.nullToSpace(ht.get("ASYS")).equals("")) {
            sql.append("AND S03.ASYS = '" + Utility.nullToSpace(ht.get("ASYS")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("AYEAR")).equals("")) {
            sql.append("AND S03.AYEAR = '" + Utility.nullToSpace(ht.get("AYEAR")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("SMS")).equals("")) {
            sql.append("AND S03.SMS = '" + Utility.nullToSpace(ht.get("SMS")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("IDNO")).equals("")) {
            sql.append("AND S03.IDNO = '" + Utility.nullToSpace(ht.get("IDNO")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("BIRTHDATE")).equals("")) {
            sql.append("AND S03.BIRTHDATE = '" + Utility.nullToSpace(ht.get("BIRTHDATE")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("CENTER_CODE")).equals("")) {
            sql.append("AND S03.CENTER_CODE = '" + Utility.nullToSpace(ht.get("CENTER_CODE")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("STTYPE")).equals("")) {
            sql.append("AND S03.STTYPE = '" + Utility.nullToSpace(ht.get("STTYPE")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("NAME")).equals("")) {
            sql.append("AND S03.NAME = '" + Utility.nullToSpace(ht.get("NAME")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("ENG_NAME")).equals("")) {
            sql.append("AND S03.ENG_NAME = '" + Utility.nullToSpace(ht.get("ENG_NAME")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("ALIAS")).equals("")) {
            sql.append("AND S03.ALIAS = '" + Utility.nullToSpace(ht.get("ALIAS")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("SEX")).equals("")) {
            sql.append("AND S03.SEX = '" + Utility.nullToSpace(ht.get("SEX")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("SELF_IDENTITY_SEX")).equals("")) {
            sql.append("AND S03.SELF_IDENTITY_SEX = '" + Utility.nullToSpace(ht.get("SELF_IDENTITY_SEX")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("VOCATION")).equals("")) {
            sql.append("AND S03.VOCATION = '" + Utility.nullToSpace(ht.get("VOCATION")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("EDUBKGRD")).equals("")) {
            sql.append("AND S03.EDUBKGRD = '" + Utility.nullToSpace(ht.get("EDUBKGRD")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("EDUBKGRD_GRADE")).equals("")) {
            sql.append("AND S03.EDUBKGRD_GRADE = '" + Utility.nullToSpace(ht.get("EDUBKGRD_GRADE")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("AREACODE_OFFICE")).equals("")) {
            sql.append("AND S03.AREACODE_OFFICE = '" + Utility.nullToSpace(ht.get("AREACODE_OFFICE")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("TEL_OFFICE")).equals("")) {
            sql.append("AND S03.TEL_OFFICE = '" + Utility.nullToSpace(ht.get("TEL_OFFICE")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("TEL_OFFICE__EXT")).equals("")) {
            sql.append("AND S03.TEL_OFFICE__EXT = '" + Utility.nullToSpace(ht.get("TEL_OFFICE__EXT")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("AREACODE_HOME")).equals("")) {
            sql.append("AND S03.AREACODE_HOME = '" + Utility.nullToSpace(ht.get("AREACODE_HOME")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("TEL_HOME")).equals("")) {
            sql.append("AND S03.TEL_HOME = '" + Utility.nullToSpace(ht.get("TEL_HOME")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("MOBILE")).equals("")) {
            sql.append("AND S03.MOBILE = '" + Utility.nullToSpace(ht.get("MOBILE")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("MARRIAGE")).equals("")) {
            sql.append("AND S03.MARRIAGE = '" + Utility.nullToSpace(ht.get("MARRIAGE")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("DMSTADDR")).equals("")) {
            sql.append("AND S03.DMSTADDR = '" + Utility.nullToSpace(ht.get("DMSTADDR")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("DMSTADDR_ZIP")).equals("")) {
            sql.append("AND S03.DMSTADDR_ZIP = '" + Utility.nullToSpace(ht.get("DMSTADDR_ZIP")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("CRRSADDR_ZIP")).equals("")) {
            sql.append("AND S03.CRRSADDR_ZIP = '" + Utility.nullToSpace(ht.get("CRRSADDR_ZIP")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("CRRSADDR")).equals("")) {
            sql.append("AND S03.CRRSADDR = '" + Utility.nullToSpace(ht.get("CRRSADDR")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("EMAIL")).equals("")) {
            sql.append("AND S03.EMAIL = '" + Utility.nullToSpace(ht.get("EMAIL")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("EMRGNCY_TEL")).equals("")) {
            sql.append("AND S03.EMRGNCY_TEL = '" + Utility.nullToSpace(ht.get("EMRGNCY_TEL")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("EMRGNCY_RELATION")).equals("")) {
            sql.append("AND S03.EMRGNCY_RELATION = '" + Utility.nullToSpace(ht.get("EMRGNCY_RELATION")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("EMRGNCY_NAME")).equals("")) {
            sql.append("AND S03.EMRGNCY_NAME = '" + Utility.nullToSpace(ht.get("EMRGNCY_NAME")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("UPD_RMK")).equals("")) {
            sql.append("AND S03.UPD_RMK = '" + Utility.nullToSpace(ht.get("UPD_RMK")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("UPD_DATE")).equals("")) {
            sql.append("AND S03.UPD_DATE = '" + Utility.nullToSpace(ht.get("UPD_DATE")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("UPD_TIME")).equals("")) {
            sql.append("AND S03.UPD_TIME = '" + Utility.nullToSpace(ht.get("UPD_TIME")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("UPD_USER_ID")).equals("")) {
            sql.append("AND S03.UPD_USER_ID = '" + Utility.nullToSpace(ht.get("UPD_USER_ID")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("ROWSTAMP")).equals("")) {
            sql.append("AND S03.ROWSTAMP = '" + Utility.nullToSpace(ht.get("ROWSTAMP")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("GETINFO")).equals("")) {
            sql.append("AND S03.GETINFO = '" + Utility.nullToSpace(ht.get("GETINFO")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("TUTOR_CLASS_MK")).equals("")) {
            sql.append("AND S03.TUTOR_CLASS_MK = '" + Utility.nullToSpace(ht.get("TUTOR_CLASS_MK")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("PRE_MAJOR_FACULTY")).equals("")) {
            sql.append("AND S03.PRE_MAJOR_FACULTY = '" + Utility.nullToSpace(ht.get("PRE_MAJOR_FACULTY")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("HANDICAP_TYPE")).equals("")) {
            sql.append("AND S03.HANDICAP_TYPE = '" + Utility.nullToSpace(ht.get("HANDICAP_TYPE")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("HANDICAP_GRADE")).equals("")) {
            sql.append("AND S03.HANDICAP_GRADE = '" + Utility.nullToSpace(ht.get("HANDICAP_GRADE")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("ORIGIN_RACE")).equals("")) {
            sql.append("AND S03.ORIGIN_RACE = '" + Utility.nullToSpace(ht.get("ORIGIN_RACE")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("STNO")).equals("")) {
            sql.append("AND S03.STNO = '" + Utility.nullToSpace(ht.get("STNO")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("REG_MANNER")).equals("")) {
            sql.append("AND S03.REG_MANNER = '" + Utility.nullToSpace(ht.get("REG_MANNER")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("SERNO")).equals("")) {
            sql.append("AND S03.SERNO = '" + Utility.nullToSpace(ht.get("SERNO")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("J_FACULTY_CODE")).equals("")) {
            sql.append("AND S03.J_FACULTY_CODE = '" + Utility.nullToSpace(ht.get("J_FACULTY_CODE")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("GRAD_AYEAR")).equals("")) {
            sql.append("AND S03.GRAD_AYEAR = '" + Utility.nullToSpace(ht.get("GRAD_AYEAR")) + "' ");
        }

        if(!orderBy.equals("")) {
            String[] orderByArray = orderBy.split(",");
            orderBy = "";
            for(int i = 0; i < orderByArray.length; i++) {
                orderByArray[i] = "S03." + orderByArray[i].trim();

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
     * JOIN 其它 TABLE 將欄位的值抓出來
     * @param ht 條件值
     * @return 回傳 Vector 物件，內容為 Hashtable 的集合，<br>
     *         每一個 Hashtable 其 KEY 為欄位名稱，KEY 的值為欄位的值<br>
     * @throws Exception
     */
    public Vector getSolt003Solt006ForUse(Hashtable ht) throws Exception {

        Vector result = new Vector();
        if(sql.length() > 0) {
            sql.delete(0, sql.length());
        }

        sql.append
        (
          " SELECT A.NEWNATION,A.ASYS, A.AYEAR, A.SMS, A.IDNO, A.BIRTHDATE, A.CENTER_CODE, A.STTYPE, \n"+
          "		A.PRE_MAJOR_FACULTY||A.J_FACULTY_CODE AS PRE_MAJOR_FACULTY, A.NAME, A.ENG_NAME, A.ALIAS, A.SEX, A.SELF_IDENTITY_SEX, A.VOCATION, A.EDUBKGRD, \n"+
          "		A.EDUBKGRD_GRADE, A.EDUBKGRD_AYEAR, A.AREACODE_OFFICE, A.TEL_OFFICE, A.TEL_OFFICE_EXT, A.AREACODE_HOME, A.TEL_HOME, A.MOBILE, A.MARRIAGE, \n"+
          "		A.DMSTADDR, A.DMSTADDR_ZIP, A.CRRSADDR_ZIP, A.CRRSADDR, A.EMAIL, A.EMRGNCY_TEL, A.EMRGNCY_RELATION, A.EMRGNCY_NAME, \n"+
          "		A.GETINFO, A.TUTOR_CLASS_MK, A.HANDICAP_TYPE, A.HANDICAP_GRADE, A.ORIGIN_RACE, A.STNO, A.REG_MANNER, A.SERNO, \n"+
          "		A.GRAD_AYEAR, A.REG_DATE, A.UPD_RMK, A.UPD_DATE, A.UPD_TIME, A.UPD_USER_ID, A.UPD_IDNO, A.MAIL_DSTRBT_STATUS, \n"+
          "		A.SPECIAL_STTYPE_TYPE, B.AUDIT_CODE1, B.AUDIT_EXER, B.PAYMENT_STATUS, B.PAYMENT_METHOD, B.CHECK_DOC, B.DOC_UNQUAL_REASON, \n"+
          "		B.HANDICAP_AUDIT_MK, B.HANDICAP_UNQUAL_REASON, B.LOW_INCOME_AUDIT, B.LOW_INCOME_UNQUAL_REASON, B.DRAFT_NO, B.WRITEOFF_NO, \n"+
          "		B.AUDIT_RESULT, B.AUDIT_UNQUAL_REASON, B.KEYIN_EXER, B.KEYIN_DATE, B.TOTAL_RESULT, C.SCHOOL_NAME_OLD, C.FACULTY_OLD, \n"+
          "		C.GRADE_OLD, C.STNO_OLD, C.ST_OLD_MK, C.N_STNO, D.ENROLL_STATUS AS INIT_ENROLL_STATUS, D.STTYPE AS INIT_STTYPE, \n" +
          "		A.GETINFO_NAME,A.NATIONCODE,A.RECOMMEND_NAME,A.RECOMMEND_ID,A.VOCATION_DEPT,A.RESIDENCE_DATE, \n" +
          " 	A.EMRGNCY_EMAIL, A.OVERSEA_ADDR, A.OVERSEA_NATION, A.OVERSEA_NATION_RMK, A.OVERSEA_REASON, A.OVERSEA_REASON_RMK, A.OVERSEA_DOC, A.OVERSEA_DOC_DATE, A.OVERSEA_DOC_RMK, \n" +
          " 	A.NEW_RESIDENT_CHD, A.FATHER_NAME, A.FATHER_ORIGINAL_COUNTRY, A.MOTHER_NAME, A.MOTHER_ORIGINAL_COUNTRY, A.DOC_AGREE_MK  \n" +
          " FROM SOLT003 A  \n" +
          " JOIN SOLT006 B ON A.ASYS=B.ASYS AND A.AYEAR=B.AYEAR AND A.SMS=B.SMS AND A.IDNO=B.IDNO AND A.BIRTHDATE=B.BIRTHDATE \n" +
          " LEFT JOIN SOLT005 C ON A.ASYS=C.ASYS AND A.AYEAR=C.AYEAR AND A.SMS=C.SMS AND A.IDNO=C.IDNO AND A.BIRTHDATE=C.BIRTHDATE \n" +
          " LEFT JOIN STUT003 D ON A.STNO=D.STNO \n"+
          " WHERE 0=0 \n"
        );

        // == 查詢條件 ST ==
        if(!Utility.nullToSpace(ht.get("IDNO")).equals("")) {
            sql.append("AND A.IDNO = '" + Utility.dbStr(ht.get("IDNO")) + "' \n");
        }
        if(!Utility.nullToSpace(ht.get("BIRTHDATE")).equals("")) {
            sql.append("AND A.BIRTHDATE = '" + Utility.dbStr(ht.get("BIRTHDATE")) + "' \n");
        }
        if(!Utility.nullToSpace(ht.get("ASYS")).equals("")) {
            sql.append("AND A.ASYS = '" + Utility.dbStr(ht.get("ASYS")) + "' \n");
        }
        if(!Utility.nullToSpace(ht.get("AYEAR")).equals("")) {
            sql.append("AND A.AYEAR = '" + Utility.dbStr(ht.get("AYEAR")) + "' \n");
        }
        if(!Utility.nullToSpace(ht.get("SMS")).equals("")) {
            sql.append("AND A.SMS = '" + Utility.dbStr(ht.get("SMS")) + "' \n");
        }
        //== 查詢條件 ED ==


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
     * JOIN 其它 TABLE 將欄位的值抓出來
     * @param ht 條件值
     * @return 回傳 Vector 物件，內容為 Hashtable 的集合，<br>
     *         每一個 Hashtable 其 KEY 為欄位名稱，KEY 的值為欄位的值<br>
     * @throws Exception
     */
    public Vector getSolt003Solt006ForUse(Hashtable ht, int cross) throws Exception {

        Vector result = new Vector();
        if(sql.length() > 0) {
            sql.delete(0, sql.length());
        }

        sql.append
        (
          " SELECT A.ASYS, A.AYEAR, A.SMS, A.IDNO, A.BIRTHDATE, A.CENTER_CODE, A.STTYPE, A.PRE_MAJOR_FACULTY||J_FACULTY_CODE AS PRE_MAJOR_FACULTY, A.NAME, A.ENG_NAME, A.ALIAS, A.SEX, A.SELF_IDENTITY_SEX, A.VOCATION, A.EDUBKGRD, A.EDUBKGRD_GRADE, A.AREACODE_OFFICE, A.TEL_OFFICE, A.TEL_OFFICE_EXT, A.AREACODE_HOME, A.TEL_HOME, A.MOBILE, A.MARRIAGE, A.DMSTADDR, A.DMSTADDR_ZIP, A.CRRSADDR_ZIP, A.CRRSADDR, A.EMAIL, A.EMRGNCY_TEL, A.EMRGNCY_RELATION, A.EMRGNCY_NAME, A.GETINFO, A.TUTOR_CLASS_MK, A.HANDICAP_TYPE, A.HANDICAP_GRADE, A.ORIGIN_RACE, A.STNO, A.REG_MANNER, A.SERNO, A.GRAD_AYEAR, A.REG_DATE, A.UPD_RMK, A.UPD_DATE, A.UPD_TIME, A.UPD_USER_ID, A.UPD_IDNO, A.MAIL_DSTRBT_STATUS, E.ENROLL_STATUS, " +
		  " (SELECT code_name FROM syst001 WHERE kind = 'ENROLL_STATUS' AND   code = e.enroll_status ) enroll_status_name, " +
		  " (select code_name from syst001 where kind='EDUBKGRD_GRADE' and code=A.EDUBKGRD_GRADE)  EDUBKGRD_GRADE_NAME, " +
		  " (select code_name from syst001 where kind='STTYPE' and code=A.STTYPE)  STTYPE_NAME, " +
		  " (select code_name from syst001 where kind='ASYS' and code=A.ASYS)  ASYS_NAME, " +
          " B.AUDIT_CODE1, B.AUDIT_EXER, B.PAYMENT_STATUS, B.PAYMENT_METHOD, B.CHECK_DOC, B.DOC_UNQUAL_REASON, B.HANDICAP_AUDIT_MK, B.HANDICAP_UNQUAL_REASON, B.LOW_INCOME_AUDIT, B.LOW_INCOME_UNQUAL_REASON, B.DRAFT_NO, B.WRITEOFF_NO, B.AUDIT_RESULT, B.AUDIT_UNQUAL_REASON, B.KEYIN_EXER, B.KEYIN_DATE, B.TOTAL_RESULT, " +
          " C.SCHOOL_NAME_OLD, C.FACULTY_OLD, C.GRADE_OLD, C.STNO_OLD, C.ST_OLD_MK, C.N_STNO, D.COMPARED, A.EDUBKGRD_AYEAR, A.VOCATION_DEPT, RESIDENCE_DATE, " +
          " A.EMRGNCY_EMAIL, A.OVERSEA_ADDR, A.OVERSEA_NATION, A.OVERSEA_NATION_RMK, A.OVERSEA_REASON, A.OVERSEA_REASON_RMK, A.OVERSEA_DOC, A.OVERSEA_DOC_DATE, A.OVERSEA_DOC_RMK, A.DOC_AGREE_MK " +
          " FROM SOLT003 A  " +
		  " JOIN SOLT001 D ON D.ASYS=A.ASYS AND D.AYEAR=A.AYEAR AND D.SMS=A.SMS " +
          " JOIN SOLT006 B ON A.ASYS=B.ASYS AND A.AYEAR=B.AYEAR AND A.SMS=B.SMS AND A.IDNO=B.IDNO AND A.BIRTHDATE=B.BIRTHDATE " + 
		  " LEFT JOIN STUT003 E on a.stno = E.stno "
		);
		if(cross == 1)
		{
			sql.append
	        (
	          " JOIN SOLT005 C ON A.ASYS=C.ASYS AND A.AYEAR=C.AYEAR AND A.SMS=C.SMS AND A.IDNO=C.IDNO AND A.BIRTHDATE=C.BIRTHDATE " +
	          " WHERE 0=0 "
	        );
		}else{
			sql.append
	        (
	          " LEFT JOIN SOLT005 C ON A.ASYS=C.ASYS AND A.AYEAR=C.AYEAR AND A.SMS=C.SMS AND A.IDNO=C.IDNO AND A.BIRTHDATE=C.BIRTHDATE " +
	          " WHERE 0=0 "
	        );
		}
        // == 查詢條件 ST ==
        if(!Utility.nullToSpace(ht.get("ASYS")).equals("")) {
            sql.append("AND A.ASYS = '" + Utility.dbStr(ht.get("ASYS")) + "' ");
        }
		if(!Utility.nullToSpace(ht.get("AYEAR")).equals("")) {
            sql.append("AND A.AYEAR = '" + Utility.dbStr(ht.get("AYEAR")) + "' ");
        }
		if(!Utility.nullToSpace(ht.get("SMS")).equals("")) {
            sql.append("AND A.SMS = '" + Utility.dbStr(ht.get("SMS")) + "' ");
        }
		if(!Utility.nullToSpace(ht.get("CENTER_CODE")).equals("")) {
            sql.append("AND A.CENTER_CODE = '" + Utility.dbStr(ht.get("CENTER_CODE")) + "' ");
        }
		if(!Utility.nullToSpace(ht.get("STNO")).equals("")) {
            sql.append("AND A.STNO = '" + Utility.dbStr(ht.get("STNO")) + "' ");
        }
		if(!Utility.nullToSpace(ht.get("IDNO")).equals("")) {
            sql.append("AND A.IDNO = '" + Utility.dbStr(ht.get("IDNO")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("BIRTHDATE")).equals("")) {
            sql.append("AND A.BIRTHDATE = '" + Utility.dbStr(ht.get("BIRTHDATE")) + "' ");
        }
		if(!Utility.nullToSpace(ht.get("NAME")).equals("")) {
            sql.append("AND A.NAME = '" + Utility.dbStr(ht.get("NAME")) + "' ");
        }
        //== 查詢條件 ED ==

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

    public Vector getSolt003Trau001Forprint(Hashtable ht) throws Exception {

        Vector result = new Vector();
        if(sql.length() > 0) {
            sql.delete(0, sql.length());
        }

        sql.append
        (
            "SELECT SOLT003.IDNO, SOLT003.BIRTHDATE, TRAU001.NAME, SOLT003.EDUBKGRD_GRADE, SOLT003.STTYPE, SOLT003.ASYS, SOLT003.TEL_HOME " +
            "FROM  SOLT003, TRAU001 " +
            "WHERE " +
            "1    =    1 "
        );

        /** 勾選列印處理 */
        if (ht.get("PRINTFORM").toString().equals("RESULT"))
        {
            String[]    IDNO        =    Utility.split(ht.get("IDNO").toString(), ",");
            String[]    BIRTHDATE    =    Utility.split(ht.get("BIRTHDATE").toString(), ",");


            sql.append("AND ");
            for (int i = 0; i < IDNO.length; i++)
            {
                if (i > 0)
                    sql.append (" OR ");

                sql.append
                (
                    "(" +
                    "    IDNO        =    '" + Utility.dbStr(IDNO[i])+ "' AND " +
                    "    BIRTHDATE    =    '" + Utility.dbStr(BIRTHDATE[i])+ "' " +
                    ")"
                );
            }
        }
        else
        {
            if(!Utility.checkNull(ht.get("IDNO"), "").equals(""))
                sql.append("AND SOLT003.IDNO    =    '" + Utility.dbStr(ht.get("IDNO"))+ "'");
            if(!Utility.checkNull(ht.get("BIRTHDATE"), "").equals(""))
                sql.append("AND SOLT003.BIRTHDATE    =    '" + Utility.dbStr(ht.get("BIRTHDATE"))+ "'");

        }

        //== 查詢條件 ED ==

        if(!orderBy.equals("")) {
            String[] orderByArray = orderBy.split(",");
            orderBy = "";
            for(int i = 0; i < orderByArray.length; i++) {
                orderByArray[i] = "SOLT001." + orderByArray[i].trim();

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
     * 帶出網路報名未繳報名費清單
     * @return 回傳 Vector 物件，內容為 Hashtable 的集合，<br>
     *         每一個 Hashtable 其 KEY 為欄位名稱，KEY 的值為欄位的值<br>
     *         若該欄位有中文名稱，則其 KEY 請加上 _NAME, EX: SMS 其中文欄位請設為 SMS_NAME
     * @throws Exception
     */
    public Vector getSolt003SingupChargeNotpay() throws Exception {
        sql.append(" SELECT SOLT003.NAME,SOLT003.SEX,SOLT003.BIRTHDATE,SOLT003.IDNO,SOLT003.AREACODE_OFFICE,SOLT003.TEL_OFFICE,SOLT003.TEL_OFFICE__EXT " +
                   " FROM SOLT003,SOLT006 " +
                   " WHERE SOLT003.REG_MANNER = '3' "+                  //報名方式 (1.通訊、2.現場、3.網路)
                   " AND SOLT006.PAYMENT_STATUS = '1'  "+               //繳費狀態 (1.未繳、2.已繳、3.短繳、4.溢繳)
                   " AND SOLT003.AYEAR = '"+ this.getAyear() +"'" +     //學年
                   " AND SOLT003.ASYS = SOLT006.ASYS " +
                   " AND SOLT003.AYEAR = SOLT006.AYEAR " +
                   " AND SOLT003.SMS = SOLT006.SMS " +
                   " AND SOLT003.IDNO = SOLT006.IDNO " +
                   " AND SOLT003.BIRTHDATE = SOLT006.BIRTHDATE "
        );

        Vector result = new Vector();

        DBResult rs = null;
        try {
            // 取出所有資料
            rs = dbmanager.getSimpleResultSet(conn);
            rs.open();
            rs.executeQuery(sql.toString());

            Hashtable rowHt = null;
            while(rs.next())
            {
                rowHt = new Hashtable();
                for(int i=1;i<=rs.getColumnCount();i++)
                {
                    rowHt.put(rs.getColumnName(i),rs.getString(i));
                }
                result.add(rowHt);
            }
            return result;
        } catch (Exception e) {
            throw e;
        } finally {
            if(rs != null) {
                rs.close();
            }
        }
    }



    /**
     * 帶出符合列印入學通知單的清冊
     * @return 回傳 Vector 物件，內容為 Hashtable 的集合，<br>
     *         每一個 Hashtable 其 KEY 為欄位名稱，KEY 的值為欄位的值<br>
     *         若該欄位有中文名稱，則其 KEY 請加上 _NAME, EX: SMS 其中文欄位請設為 SMS_NAME
     * @throws Exception
     */
    public Vector getEntranceList() throws Exception {
        sql.append(" SELECT SOLT003.NAME,SOLT003.STNO,SYST002.ZIP,SYST002.ADDR, " +
                    " substr(SOLT001.VENUE_REG_SDATE,1,4) VENUE_REG_SDATE_YEAR, " +         //現場報名起始日_年
                    " substr(SOLT001.VENUE_REG_SDATE,5,2) VENUE_REG_SDATE_MONTH, " +        //現場報名起始日_月
                    " substr(SOLT001.VENUE_REG_SDATE,7,2) VENUE_REG_SDATE_DAY, " +          //現場報名起始日_日
                    " substr(SOLT001.VENUE_REG_EDATE,1,4) VENUE_REG_EDATE_YEAR, " +         //現場報名截止日_年
                    " substr(SOLT001.VENUE_REG_EDATE,5,2) VENUE_REG_EDATE_MONTH, " +        //現場報名截止日_月
                    " substr(SOLT001.VENUE_REG_EDATE,7,2) VENUE_REG_EDATE_DAY " +           //現場報名截止日_日
                    " FROM SOLT003,SOLT006,SYST002,SOLT001 " +
                    " WHERE SOLT003.AYEAR = SOLT006.AYEAR " +
                    " AND SOLT003.ASYS = SOLT003.ASYS " +
                    " AND SOLT003.IDNO = SOLT006.IDNO " +
                    " AND SOLT003.BIRTHDATE = SOLT006.BIRTHDATE " +
                    " AND SOLT003.SMS = SOLT006.SMS " +
                    " AND SOLT003.ASYS = SOLT001.ASYS " +
                    " AND SOLT003.AYEAR = SOLT001.AYEAR " +
                    " AND SOLT003.SMS = SOLT001.SMS " +
                    " AND SOLT003.AYEAR = '"+this.getAyear()+"' " +
                    " AND SOLT003.SMS = '"+this.getSMS()+"' " +
                    " AND SOLT006.AUDIT_CODE1 = 'Y' " +                                     //初審註記(初審通過的新生註記為"Y",非新生為"N")
                    " AND SYST002.CENTER_CODE = '"+this.getCENTER_CODE()+"' " +
                    " ORDER BY STNO"
        );

        Vector result = new Vector();

        DBResult rs = null;
        try {
            // 取出所有資料
            rs = dbmanager.getSimpleResultSet(conn);
            rs.open();
            rs.executeQuery(sql.toString());

            Hashtable rowHt = null;
            while(rs.next())
            {


                rowHt = new Hashtable();
                for(int i=1;i<=rs.getColumnCount();i++)
                {
                    rowHt.put(rs.getColumnName(i),rs.getString(i));
                }
                result.add(rowHt);
            }
            return result;
        } catch (Exception e) {
            throw e;
        } finally {
            if(rs != null) {
                rs.close();
            }
        }


    }


    //學年
    private String AREAR = "";

    public void setAyear(String AREAR){
        this.AREAR = AREAR;
    }

    private String getAyear(){
        return AREAR;
    }

    //學期
    private String SMS = "";
    public void setSMS(String SMS){
        this.SMS = SMS;
    }
    private String getSMS(){
        return SMS;
    }

    //中心代號
    private String CENTER_CODE = "";
    public void setCENTER_CODE(String CENTER_CODE){
        this.CENTER_CODE = CENTER_CODE;
    }
    private String getCENTER_CODE(){
        return CENTER_CODE;
    }

    /**
     * 列印招生地址名條 - 新生基本資料(SOLT003)、SYST001
     * @param ht 條件值
     * @return 回傳 Vector 物件，內容為 Hashtable 的集合，<br>
     *         每一個 Hashtable 其 KEY 為欄位名稱，KEY 的值為欄位的值<br>
     *         若該欄位有中文名稱，則其 KEY 請加上 _NAME, EX: SMS 其中文欄位請設為 SMS_NAME
     * @throws Exception
     */
    public void getDataForSol010(Vector vt, Hashtable ht) throws Exception {
        if(sql.length() > 0) {
            sql.delete(0, sql.length());
        }

        sql.append
        (
            "SELECT a.CRRSADDR_ZIP, a.CRRSADDR, a.NAME, a.STNO, " +
            "(SELECT CODE_NAME FROM SYST001 WHERE KIND = 'CENTER_CODE' AND CODE = a.CENTER_CODE AND ROWNUM = 1) as CENTER_NAME, " +
            "(SELECT CODE_NAME FROM SYST001 WHERE KIND = 'STTYPE' AND CODE = a.STTYPE AND ROWNUM = 1) as STTYPE_NAME " +
            "FROM SOLT003 a " +
            "WHERE " +
            "1 = 1 "
        );

		if(!Utility.checkNull(ht.get("AYEAR"), "").equals(""))
			sql.append("AND a.AYEAR	=	'" + Utility.dbStr(ht.get("AYEAR"))+ "'");
		if(!Utility.checkNull(ht.get("SMS"), "").equals(""))
			sql.append("AND a.SMS	=	'" + Utility.dbStr(ht.get("SMS"))+ "'");
		if(!Utility.checkNull(ht.get("CENTER_ABBRNAME"), "").equals(""))
			sql.append("AND a.CENTER_ABBRNAME	=	'" + Utility.dbStr(ht.get("CENTER_ABBRNAME"))+ "'");
		if(!Utility.checkNull(ht.get("STTYPE"), "").equals(""))
			sql.append("AND a.STTYPE	=	'" + Utility.dbStr(ht.get("STTYPE"))+ "'");

        sql.append("ORDER BY a.STNO ");

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

            while (rs.next()) {
                Hashtable    content    = new Hashtable();
                /** 將欄位抄一份過去 */
                for (int i = 1; i <= rs.getColumnCount(); i++){
                    content.put(rs.getColumnName(i), rs.getString(i));
                }

                vt.add(content);
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
     * 列印選修生修滿40學分名冊
     * @param ht 條件值
     * @return 回傳 Vector 物件，內容為 Hashtable 的集合，<br>
     *         每一個 Hashtable 其 KEY 為欄位名稱，KEY 的值為欄位的值<br>
     *         若該欄位有中文名稱，則其 KEY 請加上 _NAME, EX: SMS 其中文欄位請設為 SMS_NAME
     * @throws Exception
     */
    public Vector getSolt003ForGettingCredits(Hashtable ht, int credit) throws Exception {
        if(ht == null) {
            ht = new Hashtable();
        }
        Vector result = new Vector();
        if(sql.length() > 0) {
            sql.delete(0, sql.length());
        }
        sql.append(
		"SELECT STNO, NAME, IDNO, CENTER_CODE, (SELECT a.ACCUM_PASS_CRD FROM STUT003 a WHERE STNO=a.STNO AND ACCUM_PASS_CRD>='"+String.valueOf(credit)+"' AND rownum=1) AS CREDIT "+
		"FROM SOLT003 "+
		"WHERE STTYPE='2' AND CENTER_CODE='"+Utility.checkNull(ht.get("CENTER_CODE"), "")+"' "+
		"ORDER BY STNO "
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

    /**
     * 列印通信報名繳交報名費名冊
     * @param ht 條件值
     * @return 回傳 Vector 物件，內容為 Hashtable 的集合，<br>
     *         每一個 Hashtable 其 KEY 為欄位名稱，KEY 的值為欄位的值<br>
     *         若該欄位有中文名稱，則其 KEY 請加上 _NAME, EX: SMS 其中文欄位請設為 SMS_NAME
     * @throws Exception
     */
    public Vector getSolt003ForRegManner2(Hashtable ht) throws Exception {
        if(ht == null) {
            ht = new Hashtable();
        }
        Vector result = new Vector();
        if(sql.length() > 0) {
            sql.delete(0, sql.length());
        }
        sql.append(
		"SELECT KEYIN_DATE, "+
		"	(SELECT NAME FROM SOLT003 a WHERE STNO=a.STNO) NAME, "+ 		"	DRAFT_NO, "+
		"	WRITEOFF_NO "+
		"FROM SOLT006 "+
		"WHERE IDNO IN ( "+
		"		SELECT IDNO "+
		"		FROM SOLT003 "+
		"		WHERE AYEAR='"+Utility.checkNull(ht.get("AYEAR"), "")+"' AND SMS='"+Utility.checkNull(ht.get("SMS"), "")+"' AND REG_MANNER='1' "+
		"		) "+
		"ORDER BY KEYIN_DATE "
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

    /**
     * 列印招生地址名條
     * @param ht 條件值
     * @return 回傳 Vector 物件，內容為 Hashtable 的集合，<br>
     *         每一個 Hashtable 其 KEY 為欄位名稱，KEY 的值為欄位的值<br>
     *         若該欄位有中文名稱，則其 KEY 請加上 _NAME, EX: SMS 其中文欄位請設為 SMS_NAME
     * @throws Exception
     */
    public Vector getSolt003ForNameAddrList(Hashtable ht) throws Exception {
        if(ht == null) {
            ht = new Hashtable();
        }
        Vector result = new Vector();
        if(sql.length() > 0) {
            sql.delete(0, sql.length());
        }
        sql.append(
		"SELECT * "+
		"FROM SOLT003 "+
		"WHERE 1=1"
        );
        if(!Utility.nullToSpace(ht.get("AYEAR")).equals("")) {
            sql.append("AND AYEAR = '" + Utility.checkNull(ht.get("AYEAR"), "") + "' ");
        }
        if(!Utility.nullToSpace(ht.get("SMS")).equals("")) {
            sql.append("AND SMS = '" + Utility.checkNull(ht.get("SMS"), "") + "' ");
        }
        if(!Utility.nullToSpace(ht.get("CENTER_CODE")).equals("")) {
            sql.append("AND CENTER_CODE = '" + Utility.checkNull(ht.get("CENTER_CODE"), "") + "' ");
        }
        if(!Utility.nullToSpace(ht.get("STTYPE")).equals("")) {
            sql.append("AND STTYPE = '" + Utility.checkNull(ht.get("STTYPE"), "") + "' ");
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
     * 列印招生地址名條 - 新生基本資料(SOLT003)、SYST001
     * @param ht 條件值
     * @return 回傳 Vector 物件，內容為 Hashtable 的集合，<br>
     *         每一個 Hashtable 其 KEY 為欄位名稱，KEY 的值為欄位的值<br>
     *         若該欄位有中文名稱，則其 KEY 請加上 _NAME, EX: SMS 其中文欄位請設為 SMS_NAME
     * @throws Exception
     */
    public Vector getSoltoo3Solt006ForUse(Hashtable ht) throws Exception {

        Vector result = new Vector();

        if(sql.length() > 0) {
            sql.delete(0, sql.length());
        }

        sql.append
        (
        		" select a.asys ,e.CODE_NAME AS CASYS ,a.stno, a.ayear, a.sms,f.CODE_NAME AS CSMS, a.idno,a.birthdate , a.center_code   ,"+
        		" h.CENTER_ABBRNAME as ccenter_code  ,a.sttype,  d.CODE_NAME as csttype ,a.reg_manner,c.CODE_NAME AS Creg_manner ,A.SEX, A.SELF_IDENTITY_SEX ,"+
        		" g.CODE_NAME AS Csex ,A.NAME, nvl(a.edubkgrd, '　') as edubkgrd,"+
        		" (SELECT CODE_NAME FROM SYST001 WHERE KIND='HANDICAP_TYPE' AND CODE=a.HANDICAP_TYPE) as HANDICAP_TYPE_NAME,"+
        		" (SELECT CODE_NAME FROM SYST001 WHERE KIND='HANDICAP_GRADE' AND CODE=a.HANDICAP_GRADE) as HANDICAP_GRADE_NAME,"+
        		" (SELECT CODE_NAME FROM SYST001 WHERE KIND='ORIGIN_RACE' AND CODE=a.ORIGIN_RACE) as ORIGIN_RACE_NAME, "+
        		" (SELECT CODE_NAME FROM SYST001 WHERE KIND='PAYMENT_STATUS' AND CODE=b.PAYMENT_STATUS) AS PAYMENT_STATUS, "+
        		" a.AREACODE_HOME, a.TEL_HOME, a.CRRSADDR_ZIP, a.CRRSADDR, a.MOBILE, a.email,z.TOTAL_CRS_NAME " +
        		" , K.CODE_NAME AS ENROLLSTATUS " +
        		" ,CASE WHEN (J.TAKE_ABNDN = 'N' AND J.TOTAL_CRD_CNT > '0' AND J.PAYMENT_STATUS != '1') THEN '已選課已繳費' " +
        		"       WHEN (J.TAKE_ABNDN = 'N' AND J.TOTAL_CRD_CNT > '0' AND J.PAYMENT_STATUS = '1') THEN '已選課未繳費' " +
        		"       WHEN (J.TAKE_ABNDN = 'N' AND J.TOTAL_CRD_CNT = '0' ) THEN '已取消選課' " +
        		"       WHEN (A.STNO IS NULL ) THEN '未新生報到' ELSE '尚未選課' END AS REG_STATUS " +
        		" from solt003 a "+
        		" join solt006 b on  a.asys=b.asys  and a.ayear=b.ayear and a.sms=b.sms and a.idno=b.idno and a.birthdate=b.birthdate"+
        		" left join syst001 c on a.reg_manner = c.code and c.kind='REG_MANNER'"+
        		" left join syst001 d on a.sttype = d.code and d.kind='STTYPE' "+
        		" left join syst001 e on a.asys = e.code and e.kind='ASYS'"+
        		" left join syst001 f on a.sms = f.code and f.kind='SMS'"+
        		" left join syst001 g on a.sex = g.code and g.kind='SEX'"+
        		" left join syst002 h on a.center_code = h.center_code" +
        		" LEFT JOIN STUT003 I ON I.STNO = A.STNO " +
        		" LEFT JOIN REGT005 J ON J.AYEAR = A.AYEAR AND J.SMS = A.SMS AND J.STNO = A.STNO " +
        		" LEFT JOIN SYST001 K ON K.KIND = 'ENROLL_STATUS' AND K.CODE = I.ENROLL_STATUS " +
        		" left join syst008 z on a.PRE_MAJOR_FACULTY = z.FACULTY_CODE and a.J_FACULTY_CODE = z.TOTAL_CRS_NO "+
                //" where 1  =  1 and (b.AUDIT_RESULT='0' or b.TOTAL_RESULT='0') "
				//為了印出沒學號的資料，取消(b.AUDIT_RESULT='0' or b.TOTAL_RESULT='0')條件
				" where 1  =  1 "
        );
/*
        sql.append
        (
            "select a.asys ,e.CODE_NAME AS CASYS ,a.stno, a.ayear, a.sms,f.CODE_NAME AS CSMS, a.idno,a.birthdate , a.center_code   ,h.center_name as ccenter_code  ,a.sttype,  d.CODE_NAME as csttype ,a.reg_manner,c.CODE_NAME AS Creg_manner ,A.SEX ,g.CODE_NAME AS Csex ,A.NAME,A.EDUBKGRD " +
            "from solt003 a join solt006 b on a.asys=b.asys  and a.ayear=b.ayear and a.sms=b.sms and a.idno=b.idno and a.birthdate=b.birthdate "+
            "join syst001 c on a.reg_manner = c.code and c.kind='REG_MANNER' " +
            "join syst001 d on a.sttype = d.code and d.kind='STTYPE' " +
            "join syst001 e on a.asys = e.code and e.kind='ASYS' " +
            "join syst001 f on a.sms = f.code and f.kind='SMS' " +
            "join syst001 g on a.sex = g.code and g.kind='SEX' " +
            "join syst002 h on a.center_code = h.center_code " +
            "where 1  =  1 and b.AUDIT_RESULT='0'"
        );
*/
		if(!Utility.checkNull(ht.get("AYEAR"), "").equals(""))
			sql.append("AND a.AYEAR	= '" + Utility.dbStr(ht.get("AYEAR"))+ "' ");
		if(!Utility.checkNull(ht.get("SMS"), "").equals(""))
			sql.append("AND a.SMS = '" + Utility.dbStr(ht.get("SMS"))+ "' ");
		if(!Utility.checkNull(ht.get("CENTER_CODE"), "").equals(""))
			sql.append("AND a.CENTER_CODE	=	'" + Utility.dbStr(ht.get("CENTER_CODE"))+ "' ");
		if(!Utility.checkNull(ht.get("STTYPE"), "").equals(""))
			sql.append("AND a.STTYPE = '" + Utility.dbStr(ht.get("STTYPE"))+ "' ");
		if(!Utility.checkNull(ht.get("IDNO"), "").equals(""))
			sql.append("AND a.IDNO = '" + Utility.dbStr(ht.get("IDNO"))+ "' ");
		if(!Utility.checkNull(ht.get("NAME"), "").equals(""))
			sql.append("AND a.NAME = '" + Utility.dbStr(ht.get("NAME"))+ "' ");
		if(!Utility.checkNull(ht.get("STNO"), "").equals(""))
			sql.append("AND a.STNO = '" + Utility.dbStr(ht.get("STNO"))+ "' ");
		if(!Utility.checkNull(ht.get("CENTER_ABBRNAME"), "").equals(""))
			sql.append("AND a.CENTER_ABBRNAMEE	=	'" + Utility.dbStr(ht.get("CENTER_ABBRNAME"))+ "' ");
		if(!Utility.checkNull(ht.get("REG_MANNER"), "").equals(""))
			sql.append("AND a.REG_MANNER = '" + Utility.dbStr(ht.get("REG_MANNER"))+ "' ");
		if(!Utility.checkNull(ht.get("ASYS"), "").equals(""))
			sql.append("AND a.ASYS = '" + Utility.dbStr(ht.get("ASYS"))+ "' ");
		if(!Utility.checkNull(ht.get("PAYMENT_STATUS"), "").equals(""))
		{
			if( Utility.dbStr(ht.get("PAYMENT_STATUS")).equals("1") )
				sql.append("AND b.PAYMENT_STATUS = '1' ");
			else
				sql.append("AND b.PAYMENT_STATUS != '1' ");
		}

        sql.append("ORDER BY a.CENTER_CODE, a.STTYPE, a.REG_MANNER, a.idno");
        DBResult rs = null;
System.out.println("solt003r->"+sql.toString());
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
            Hashtable    rsht = null;
            while (rs.next()) {
                rsht  = new Hashtable();
                /** 將欄位抄一份過去 */
                for (int i = 1; i <= rs.getColumnCount(); i++){
                    rsht.put(rs.getColumnName(i), rs.getString(i));
                }

                result.add(rsht);
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
	/**
     * 列印現場報名名單清冊(SOLT203)
     * @param ht 條件值
     * @return 回傳 Vector 物件，內容為 Hashtable 的集合，<br>
     *         每一個 Hashtable 其 KEY 為欄位名稱，KEY 的值為欄位的值<br>
     *         若該欄位有中文名稱，則其 KEY 請加上 _NAME, EX: SMS 其中文欄位請設為 SMS_NAME
     * @throws Exception
     */
    public Vector getSolt203ForUse(Hashtable ht) throws Exception {

        Vector result = new Vector();

        if(sql.length() > 0) {
            sql.delete(0, sql.length());
        }

        sql.append
        (
        		//" select row_number() over (order by aa.CENTER_CODE, aa.STTYPE, aa.REG_MANNER, aa.idno) as RROWNUM ,aa.* from("+
				" select a.reg_manner,c.CODE_NAME AS Creg_manner ,a.center_code ,h.CENTER_ABBRNAME as ccenter_code ,a.sttype ,d.CODE_NAME as csttype ,a.stno ,a.NAME ,A.SEX ,g.CODE_NAME AS Csex ,a.birthdate ,a.idno ,"+
        		" a.asys ,e.CODE_NAME AS CASYS ,a.ayear ,a.sms ,f.CODE_NAME AS CSMS ,z.TOTAL_CRS_NAME,a.UPD_DATE,a.DMSTADDR_ZIP,a.CRRSADDR_ZIP "+
                " from solt003 a "+        		
        		" left join syst001 c on a.reg_manner = c.code and c.kind='REG_MANNER' "+
        		" left join syst001 d on a.sttype = d.code and d.kind='STTYPE' "+
        		" left join syst001 e on a.asys = e.code and e.kind='ASYS' "+
        		" left join syst001 f on a.sms = f.code and f.kind='SMS' "+
        		" left join syst001 g on a.sex = g.code and g.kind='SEX' "+
        		" left join syst002 h on a.center_code = h.center_code "+
        		" left join syst008 z on a.PRE_MAJOR_FACULTY = z.FACULTY_CODE and a.J_FACULTY_CODE = z.TOTAL_CRS_NO "+
        		//" join stut003 s3 on a.idno=s3.idno and a.birthdate=s3.birthdate"+
				" where 1  =  1  "

        );
		if(!Utility.checkNull(ht.get("ASYS"), "").equals(""))
			sql.append("AND a.ASYS = '" + Utility.dbStr(ht.get("ASYS"))+ "' ");
		if(!Utility.checkNull(ht.get("AYEAR"), "").equals(""))
			sql.append("AND a.AYEAR	= '" + Utility.dbStr(ht.get("AYEAR"))+ "' ");
		if(!Utility.checkNull(ht.get("SMS"), "").equals(""))
			sql.append("AND a.SMS = '" + Utility.dbStr(ht.get("SMS"))+ "' ");
		if(!Utility.checkNull(ht.get("CENTER_CODE"), "").equals(""))
			sql.append("AND a.CENTER_CODE = '" + Utility.dbStr(ht.get("CENTER_CODE"))+ "' ");
		/*if(!Utility.checkNull(ht.get("STTYPE"), "").equals(""))
			sql.append("AND a.STTYPE = '" + Utility.dbStr(ht.get("STTYPE"))+ "' ");
		if(!Utility.checkNull(ht.get("IDNO"), "").equals(""))
			sql.append("AND a.IDNO = '" + Utility.dbStr(ht.get("IDNO"))+ "' ");
		if(!Utility.checkNull(ht.get("NAME"), "").equals(""))
			sql.append("AND a.NAME = '" + Utility.dbStr(ht.get("NAME"))+ "' ");
		if(!Utility.checkNull(ht.get("STNO"), "").equals(""))
			sql.append("AND a.STNO = '" + Utility.dbStr(ht.get("STNO"))+ "' ");
		if(!Utility.checkNull(ht.get("CENTER_ABBRNAME"), "").equals(""))
			sql.append("AND a.CENTER_ABBRNAMEE	=	'" + Utility.dbStr(ht.get("CENTER_ABBRNAME"))+ "' ");
		if(!Utility.checkNull(ht.get("REG_MANNER"), "").equals(""))
			//sql.append("AND a.REG_MANNER = '" + Utility.dbStr(ht.get("REG_MANNER"))+ "' ");
            sql.append(" AND a.REG_MANNER = '2' ");*/
        if (!Utility.checkNull(ht.get("UPD_DATE_S"), "").equals(""))
            sql.append("AND a.UPD_DATE >= '" + Utility.dbStr(ht.get("UPD_DATE_S")) + "' ");       
        if (!Utility.checkNull(ht.get("UPD_DATE_E"), "").equals(""))
            sql.append("AND a.UPD_DATE <= '" + Utility.dbStr(ht.get("UPD_DATE_E")) + "' "); 

		sql.append(
				" AND a.REG_MANNER = '2' "+
				" and a.stno is not null "+
				" and a.stno in ("+
        		" select s3.stno from stut003 s3 " +
        		" where a.idno = s3.idno and a.birthdate = s3.birthdate " +
        		" and s3.ENROLL_STATUS in ('1','2')" +
        		" and s3.ENROLL_AYEARSMS = a.ayear||a.sms )" +
				" and ("+
        		" (select count(s3.stno) as num " +
        		" from stut003 s3 " +
        		" where a.idno = s3.idno and a.birthdate = s3.birthdate " +
        		" ) = 1 " +
        		" or (( select count(s3.stno) as num " +
        		" from stut003 s3 " +
        		" where a.idno = s3.idno and a.birthdate = s3.birthdate " +
        		" and s3.ENROLL_AYEARSMS = a.ayear||a.sms " +
        		" ) = 2 " +
        		" and ( select count(s3.stno) as num " +
        		" from stut003 s3 " +
        		" where a.idno = s3.idno and a.birthdate = s3.birthdate " +
        		" and s3.ENROLL_AYEARSMS < a.ayear||a.sms " +
        		" ) = 0 ) " +
        		" ) " 
				);
        
        sql.append("ORDER BY a.CENTER_CODE, a.STTYPE, a.REG_MANNER, a.stno ");
		//sql.append(" )aa");
        DBResult rs = null;
        //System.out.println("sol203r->"+sql.toString());
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
            Hashtable    rsht = null;
            while (rs.next()) {
                rsht  = new Hashtable();
                /** 將欄位抄一份過去 */
                for (int i = 1; i <= rs.getColumnCount(); i++){
                    rsht.put(rs.getColumnName(i), rs.getString(i));
                }

                result.add(rsht);
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
     *  列印各中心新生報名人數年度比較表(SOL014R)
     * @param ht 條件值
     * @return 回傳 Vector 物件，內容為 Hashtable 的集合，<br>
     *         每一個 Hashtable 其 KEY 為欄位名稱，KEY 的值為欄位的值<br>
     *         若該欄位有中文名稱，則其 KEY 請加上 _NAME, EX: SMS 其中文欄位請設為 SMS_NAME
     * @throws Exception
     */
    public Vector getSoltoo3Compare(Hashtable ht) throws Exception
    {
        Vector result = new Vector();
        Vector result1 = new Vector();
        Vector result2  = new Vector();

        StringBuffer sql1 = new StringBuffer();

        if(sql.length() > 0) {
            sql.delete(0, sql.length());
        }

        sql.append
        (
            "SELECT CENTER_CODE,CENTER_NAME,SUM(TYPE1) AS TYPE1,SUM(TYPE2) AS TYPE2,SUM(TYPE3) AS TYPE3, SUM(TYPE1)+SUM(TYPE2)+SUM(TYPE3) AS TOTAL " +
            "FROM (select A.CENTER_CODE,A.CENTER_NAME,B.IDNO, " +
            "CASE NVL(TO_CHAR(b.REG_MANNER),'0') WHEN '1' THEN '1' ELSE '0' END AS TYPE1, " +
            "CASE NVL(TO_CHAR(b.REG_MANNER),'0') WHEN '2' THEN '1' ELSE '0' END AS TYPE2, " +
            "CASE NVL(TO_CHAR(b.REG_MANNER),'0') WHEN '3' THEN '1' ELSE '0' END AS TYPE3 " +
            "from syst002 a left join solt003 b on a.center_code = b.center_code AND " +
            "B.ASYS = '" + Utility.dbStr(ht.get("ASYS")) + "' AND B.AYEAR = '" + Utility.dbStr(ht.get("AYEAR1"))+ "' AND B.SMS = '" + Utility.dbStr(ht.get("SMS1"))+ "'  ) A " +
            "GROUP BY CENTER_CODE,CENTER_NAME " +
            "ORDER BY CENTER_CODE "
        );

        sql1.append
        (
            "SELECT CENTER_CODE, SUM(TYPE1)+SUM(TYPE2)+SUM(TYPE3) AS TOTAL " +
            "FROM (select A.CENTER_CODE,A.CENTER_NAME,B.IDNO, " +
            "CASE NVL(TO_CHAR(b.REG_MANNER),'0') WHEN '1' THEN '1' ELSE '0' END AS TYPE1, " +
            "CASE NVL(TO_CHAR(b.REG_MANNER),'0') WHEN '2' THEN '1' ELSE '0' END AS TYPE2, " +
            "CASE NVL(TO_CHAR(b.REG_MANNER),'0') WHEN '3' THEN '1' ELSE '0' END AS TYPE3 " +
            "from syst002 a left join solt003 b on a.center_code = b.center_code AND  " +
            "B.ASYS='" + Utility.dbStr(ht.get("ASYS"))+ "' AND B.AYEAR='" + Utility.dbStr(ht.get("AYEAR2"))+ "' AND B.SMS='" + Utility.dbStr(ht.get("SMS2"))+ "'  ) A  " +
            "GROUP BY CENTER_CODE,CENTER_NAME " +
            "ORDER BY CENTER_CODE "
        );

        DBResult rs = null;
        DBResult rs1 = null;

        try {
            if(pageQuery) {
                // 依分頁取出資料
                rs = Page.getPageResultSet(dbmanager, conn, sql.toString(), pageNo, pageSize);
            } else {
                // 取出所有資料
                rs = dbmanager.getSimpleResultSet(conn);
                rs.open();
                rs.executeQuery(sql.toString());

                rs1 = dbmanager.getSimpleResultSet(conn);
                rs1.open();
                rs1.executeQuery(sql1.toString());
            }
            Hashtable    rsht = null;
            while (rs.next()) {
                rsht  = new Hashtable();
                /** 將欄位抄一份過去 */
                for (int i = 1; i <= rs.getColumnCount(); i++)
                    rsht.put(rs.getColumnName(i), rs.getString(i));

                result.add(rsht);
            }
            while (rs1.next()) {
                rsht  = new Hashtable();
                /** 將欄位抄一份過去 */
                for (int i = 1; i <= rs1.getColumnCount(); i++)
                    rsht.put(rs1.getColumnName(i), rs1.getString(i));

                result1.add(rsht);
            }
            for(int i=0;i<result.size();i++)
            {
                System.out.println("CENTER_CODE===========>"+((Hashtable)result.get(i)).get("CENTER_CODE"));
                System.out.println("CENTER_NAME===========>"+((Hashtable)result.get(i)).get("CENTER_NAME"));
                System.out.println("TYPE1===========>"+((Hashtable)result.get(i)).get("TYPE1"));
                System.out.println("TYPE2===========>"+((Hashtable)result.get(i)).get("TYPE2"));
                System.out.println("TYPE3===========>"+"CENTER_CODE"+((Hashtable)result.get(i)).get("TYPE3"));
                System.out.println("TOTAL===========>"+((Hashtable)result.get(i)).get("TOTAL"));
                System.out.println("CENTER_CODE===========>"+((Hashtable)result1.get(i)).get("CENTER_CODE"));
                System.out.println("TOTAL===========>"+((Hashtable)result1.get(i)).get("TOTAL"));
                System.out.println("-=====================================");
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

        return result;
    }
     /**
     *  列印審件人報表(SOL012R)
     * @param ht 條件值
     * @return 回傳 Vector 物件，內容為 Hashtable 的集合，<br>
     *         每一個 Hashtable 其 KEY 為欄位名稱，KEY 的值為欄位的值<br>
     *         若該欄位有中文名稱，則其 KEY 請加上 _NAME, EX: SMS 其中文欄位請設為 SMS_NAME
     * @throws Exception
     */
    public Vector getSolt003Trat001ForUse(Hashtable ht) throws Exception
    {

        //======================================================================
        Vector result = new Vector();

        if(sql.length() > 0) {
            sql.delete(0, sql.length());
        }

        sql.append
        (

        "SELECT NVL(UPD_IDNO,'0000000000')AS IDNO,NVL((SELECT NAME FROM TRAT001 WHERE UPD_IDNO=IDNO ),'不詳')"+
        " AS NAME ,COUNT(NVL(UPD_IDNO,'0000000000'))AS COUNT_NUM FROM SOLT003 "+
        " WHERE 0=0 "
        );


        /** == 查詢條件 ST == */
       if(!Utility.nullToSpace(ht.get("ASYS")).equals("")) {
            sql.append(" AND ASYS = '" + Utility.nullToSpace(ht.get("ASYS")) + "' ");
        }

        if(!Utility.nullToSpace(ht.get("AYEAR")).equals("")) {
            sql.append(" AND AYEAR = '" + Utility.nullToSpace(ht.get("AYEAR")) + "' ");
        }

        if(!Utility.nullToSpace(ht.get("SMS")).equals("")) {
            sql.append(" AND SMS = '" + Utility.nullToSpace(ht.get("SMS")) + "' ");
        }
        sql.append(" GROUP BY UPD_IDNO ");


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
            Hashtable    rsht = null;
            while (rs.next()) {
                rsht  = new Hashtable();

                /** 將欄位抄一份過去 */
                for (int i = 1; i <= rs.getColumnCount(); i++)
                    rsht.put(rs.getColumnName(i), rs.getString(i));

                result.add(rsht);
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
     *  列印報名費送款單(SOL011R_)
     * @param ht 條件值
     * @return 回傳 Vector 物件，內容為 Hashtable 的集合，<br>
     *         每一個 Hashtable 其 KEY 為欄位名稱，KEY 的值為欄位的值<br>
     *         若該欄位有中文名稱，則其 KEY 請加上 _NAME, EX: SMS 其中文欄位請設為 SMS_NAME
     * @throws Exception
     */
    public Vector getSolt003Solt006Solt007Print(Hashtable ht) throws Exception
    {
        String NowDate = DateUtil.getNowDate();
        String year = String.valueOf(Integer.parseInt(NowDate.substring(0,4))-1911);
        String month = String.valueOf(Integer.parseInt(NowDate.substring(4,6)));
        String day = String.valueOf(Integer.parseInt(NowDate.substring(6,8)));
        //======================================================================
        Vector result = new Vector();

        if(sql.length() > 0) {
            sql.delete(0, sql.length());
        }

        sql.append
        (

            " SELECT A4.CENTER_NAME,A1.CENTER_CODE " +
            " ,(SELECT COUNT(PAYMENT_METHOD) FROM SOLT003 B1 JOIN SOLT006 B2 ON 0=0 " +
                " AND  B1.ASYS=B2.ASYS AND B1.AYEAR=B2.AYEAR " +
                " AND B1.SMS=B2.SMS AND B1.IDNO=B2.IDNO AND B1.BIRTHDATE=B2.BIRTHDATE AND  B2.AUDIT_RESULT ='0'  " +
                " JOIN SOLT007 B3 ON B2.ASYS=B3.ASYS AND B2.AYEAR=B3.AYEAR AND B2.SMS=B3.SMS   AND B2.WRITEOFF_NO=B3.WRITEOFF_NO   " +
                " WHERE  B2.PAYMENT_METHOD='6' AND B1.CENTER_CODE = A1.CENTER_CODE AND B1.ASYS='" + Utility.nullToSpace(ht.get("ASYS")) + "' " +

                "  AND B3.WRITEOFF_DATE BETWEEN '" + Utility.nullToSpace(ht.get("WRITEOFF_DATE_1")) + "' AND '" + Utility.nullToSpace(ht.get("WRITEOFF_DATE_2")) + "') AS DRAFT_COUNT " +

            " ,(SELECT NVL(SUM(PAID_AMT),'0') FROM SOLT003 B1 JOIN SOLT006 B2 ON 0=0  " +
                " AND  B1.ASYS=B2.ASYS AND B1.AYEAR=B2.AYEAR " +
                " AND B1.SMS=B2.SMS AND B1.IDNO=B2.IDNO AND B1.BIRTHDATE=B2.BIRTHDATE AND B2.AUDIT_RESULT ='0'  " +
                " JOIN SOLT007 B3 ON B2.ASYS=B3.ASYS AND B2.AYEAR=B3.AYEAR AND B2.SMS=B3.SMS  " +
                " AND B2.WRITEOFF_NO=B3.WRITEOFF_NO  " +
                " WHERE  B2.PAYMENT_METHOD='6' AND B1.CENTER_CODE = A1.CENTER_CODE AND B1.ASYS='" + Utility.nullToSpace(ht.get("ASYS")) + "'  " +
                " AND B3.WRITEOFF_DATE BETWEEN '" + Utility.nullToSpace(ht.get("WRITEOFF_DATE_1")) + "' AND '" + Utility.nullToSpace(ht.get("WRITEOFF_DATE_2")) + "') AS DRAFT_AMT   " +

            " ,'N' AS SCRIP_D_NUM  " +

            " ,(SELECT NVL(SUM(PAID_AMT),'0') FROM SOLT003 B1 JOIN SOLT006 B2 ON 0=0  " +
                " AND  B1.ASYS=B2.ASYS AND B1.AYEAR=B2.AYEAR  " +
                " AND B1.SMS=B2.SMS AND B1.IDNO=B2.IDNO AND B1.BIRTHDATE=B2.BIRTHDATE AND B2.AUDIT_RESULT ='0' " +
                " JOIN SOLT007 B3 ON B2.ASYS=B3.ASYS AND B2.AYEAR=B3.AYEAR AND B2.SMS=B3.SMS  " +
                " AND B2.WRITEOFF_NO=B3.WRITEOFF_NO " +
                " WHERE   B2.PAYMENT_METHOD='5' AND B1.CENTER_CODE = A1.CENTER_CODE AND B1.ASYS='" + Utility.nullToSpace(ht.get("ASYS")) + "' " +
                " AND B3.WRITEOFF_DATE BETWEEN '" + Utility.nullToSpace(ht.get("WRITEOFF_DATE_1")) + "' AND '" + Utility.nullToSpace(ht.get("WRITEOFF_DATE_2")) + "') AS CASH_AMT " +

            " ,'N' AS SCRIP_C_NUM " +

            " FROM SOLT003 A1 JOIN SOLT006 A2 ON A1.ASYS=A2.ASYS AND A1.AYEAR=A2.AYEAR  " +
            " AND A1.SMS=A2.SMS AND A1.IDNO=A2.IDNO AND A1.BIRTHDATE=A2.BIRTHDATE AND A2.AUDIT_RESULT ='0' " +
            " JOIN SOLT007 A3 ON A2.ASYS=A3.ASYS AND A2.AYEAR=A3.AYEAR AND A2.SMS=A3.SMS " +
            " AND A2.WRITEOFF_NO=A3.WRITEOFF_NO " +
            " JOIN SYST002 A4 ON A1.CENTER_CODE=A4.CENTER_CODE  " +
            " WHERE 1  =  1 "
        );

        /** == 查詢條件 ST == */
        if(!Utility.nullToSpace(ht.get("ASYS")).equals("")) {
            sql.append(" AND A1.ASYS = '" + Utility.nullToSpace(ht.get("ASYS")) + "' ");
        }

        if(!Utility.nullToSpace(ht.get("WRITEOFF_DATE_1")).equals("")) {
            sql.append(" AND A3.WRITEOFF_DATE BETWEEN  '" + Utility.nullToSpace(ht.get("WRITEOFF_DATE_1")) + "' ");
        }

        if(!Utility.nullToSpace(ht.get("WRITEOFF_DATE_2")).equals("")) {
            sql.append(" AND  '" + Utility.nullToSpace(ht.get("WRITEOFF_DATE_2")) + "' ");
        }
        sql.append(" GROUP BY A4.CENTER_NAME,A1.CENTER_CODE ");

        System.out.println(sql.toString());
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
            Hashtable    rsht = null;


            while (rs.next())
            {
                rsht  = new Hashtable();
                int cash_amt = 0;
                int draft_amt= 0;

                rsht.put("YEAR",year);
                rsht.put("MONTH",month);
                rsht.put("DAY",day);

                /** 將欄位抄一份過去 */
                for (int i = 1; i <= rs.getColumnCount(); i++)
                {
                    cash_amt=0;
                    draft_amt=0;
                    if(rs.getColumnName(i).equals("DRAFT_AMT")){
                        draft_amt = Integer.parseInt(rs.getString(i));
                    }
                    else if(rs.getColumnName(i).equals("CASH_AMT")){
                        cash_amt = Integer.parseInt(rs.getString(i));
                    }
                        String aa = String.valueOf(draft_amt + cash_amt);
                        System.out.println("draft_amt" + draft_amt);
                        System.out.println("cash_amt" + cash_amt);
                        System.out.println("TOTAL_AMT" + aa);
                        rsht.put("TOTAL_AMT",aa);

                    //System.out.println(rs.getColumnName(i) + "==========" + rs.getString(i));
                    rsht.put(rs.getColumnName(i), rs.getString(i));

                }

                result.add(rsht);
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
     * 寄發各種繳費狀態mail
     */
    public Vector getSoltoo3Solt002Solt006ForUse(Hashtable ht) throws Exception {

        Vector result = new Vector();

        if(sql.length() > 0) {
            sql.delete(0, sql.length());
        }

        sql.append
        (
            "SELECT SOLT003.ASYS,SOLT003.STTYPE,S1.CODE_NAME AS ASYS1,SOLT003.AYEAR,SOLT003.SMS,S2.CODE_NAME AS SMS1,SOLT003.CENTER_CODE,SYST002.CENTER_NAME, " +
            "SOLT003.IDNO,SOLT003.BIRTHDATE,SOLT003.NAME,SOLT003.STNO,SOLT003.EMAIL,SOLT003.MAIL_DSTRBT_STATUS,S3.CODE_NAME AS MAIL_DSTRBT_STATUS1, " +
            "SOLT006.PAYMENT_STATUS,S4.CODE_NAME AS PAYMENT_STATUS1,SOLT002.CONTENT " +
            "FROM SOLT003 JOIN SOLT002 ON SOLT003.ASYS = SOLT002.ASYS AND SOLT003.AYEAR = SOLT002.AYEAR AND SOLT003.SMS = SOLT002.SMS " +
            "AND SOLT002.KIND='MAIL' " +
            "JOIN SOLT006 ON SOLT003.ASYS = SOLT006.ASYS AND SOLT003.AYEAR = SOLT006.AYEAR AND SOLT003.SMS = SOLT006.SMS " +
            "AND SOLT003.IDNO = SOLT006.IDNO AND SOLT003.BIRTHDATE = SOLT006.BIRTHDATE " +
            "JOIN SYST001 S1 ON S1.KIND='ASYS' AND S1.CODE = SOLT003.ASYS " +
            "JOIN SYST001 S2 ON S2.KIND='SMS' AND S2.CODE = SOLT003.SMS " +
            "JOIN SYST002 ON SYST002.CENTER_CODE = SOLT003.CENTER_CODE " +
            "LEFT JOIN SYST001 S3 ON S3.KIND='MAIL_DSTRBT_STATUS' AND SOLT003.MAIL_DSTRBT_STATUS = S3.CODE " +
            "JOIN SYST001 S4 ON S4.KIND='PAYMENT_STATUS' AND S4.CODE = SOLT006.PAYMENT_STATUS " +
            "WHERE  1   =  1 "
        );

        if(!Utility.checkNull(ht.get("ASYS"), "").equals(""))
			sql.append("AND SOLT003.ASYS	=	'" + Utility.dbStr(ht.get("ASYS"))+ "'");
		if(!Utility.checkNull(ht.get("AYEAR"), "").equals(""))
			sql.append("AND SOLT003.AYEAR	=	'" + Utility.dbStr(ht.get("AYEAR"))+ "'");
		if(!Utility.checkNull(ht.get("SMS"), "").equals(""))
			sql.append("AND SOLT003.SMS	=	'" + Utility.dbStr(ht.get("SMS"))+ "'");
		if(!Utility.checkNull(ht.get("CENTER_CODE"), "").equals(""))
			sql.append("AND SOLT003.CENTER_CODE	=	'" + Utility.dbStr(ht.get("CENTER_CODE"))+ "'");
		if(!Utility.checkNull(ht.get("STTYPE"), "").equals(""))
			sql.append("AND SOLT003.STTYPE	=	'" + Utility.dbStr(ht.get("STTYPE"))+ "'");
		if(!Utility.checkNull(ht.get("BIRTHDATE"), "").equals(""))
			sql.append("AND SOLT003.BIRTHDATE	=	'" + Utility.dbStr(ht.get("BIRTHDATE"))+ "'");
		if(!Utility.checkNull(ht.get("IDNO"), "").equals(""))
			sql.append("AND SOLT003.IDNO	=	'" + Utility.dbStr(ht.get("IDNO"))+ "'");
		if(!Utility.checkNull(ht.get("REG_MANNER"), "").equals(""))
			sql.append("AND SOLT003.REG_MANNER	=	'" + Utility.dbStr(ht.get("REG_MANNER"))+ "'");
		if(!Utility.checkNull(ht.get("AUDIT_RESULT"), "").equals(""))  
			sql.append("AND SOLT006.AUDIT_RESULT =	'" + Utility.dbStr(ht.get("AUDIT_RESULT"))+ "'");
		if(!Utility.checkNull(ht.get("EMAIL"), "").equals("")){
            if(ht.get("EMAIL").toString().equals("1")){
                sql.append("AND SOLT002.TYPE = '1' AND SOLT006.PAYMENT_STATUS ='1' ");
            }
            if(ht.get("EMAIL").toString().equals("2")){
                sql.append("AND SOLT002.TYPE = '2' AND SOLT006.PAYMENT_STATUS IN (1,3) ");
            }
            if(ht.get("EMAIL").toString().equals("3")){
                sql.append("AND SOLT002.TYPE = '3' AND SOLT006.PAYMENT_STATUS IN (2,3,4) ");
            }
            if(ht.get("EMAIL").toString().equals("4")){
                sql.append("AND SOLT002.TYPE = '4' ");
            }
		}

        //== 查詢條件 ED ==

        if(!orderBy.equals("")){
            String[] orderByArray = orderBy.split(",");
            orderBy = "";
            for(int i = 0; i < orderByArray.length; i++) {
                orderByArray[i] = "SOLT003." + orderByArray[i].trim();

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
     *  列印報名費送款單(SOL011R_1)
     * @param ht 條件值
     * @return 回傳 Vector 物件，內容為 Hashtable 的集合，<br>
     *         每一個 Hashtable 其 KEY 為欄位名稱，KEY 的值為欄位的值<br>
     *         若該欄位有中文名稱，則其 KEY 請加上 _NAME, EX: SMS 其中文欄位請設為 SMS_NAME
     * @throws Exception
     */
    public Vector getSolt003Solt006Solt007Print1(Hashtable ht) throws Exception
    {
        String NowDate = DateUtil.getNowDate();
        String year = String.valueOf(Integer.parseInt(NowDate.substring(0,4))-1911);
        String month = String.valueOf(Integer.parseInt(NowDate.substring(4,6)));
        String day = String.valueOf(Integer.parseInt(NowDate.substring(6,8)));
        //======================================================================
        Vector result = new Vector();

        if(sql.length() > 0) {
            sql.delete(0, sql.length());
        }

        sql.append
        (
         " SELECT A1.CENTER_CODE,'N' AS SCRIP_NUM , NVL(A2.DRAFT_NO,'N') AS DRAFT_NO ,A3.PAID_AMT " +
         " FROM SOLT003 A1 JOIN SOLT006 A2 ON A1.ASYS=A2.ASYS AND A1.AYEAR=A2.AYEAR "+
         " AND A1.SMS=A2.SMS AND A1.IDNO=A2.IDNO AND A1.BIRTHDATE=A2.BIRTHDATE AND A2.AUDIT_RESULT ='0' "+
         " JOIN SOLT007 A3 ON A2.ASYS=A3.ASYS AND A2.AYEAR=A3.AYEAR AND A2.SMS=A3.SMS "+
         " AND A2.WRITEOFF_NO=A3.WRITEOFF_NO "+
         " JOIN SYST002 A4 ON A1.CENTER_CODE=A4.CENTER_CODE "+
         " WHERE 0 = 0 "

        );
        /** == 查詢條件 ST == */
       if(!Utility.nullToSpace(ht.get("ASYS")).equals("")) {
            sql.append(" AND A1.ASYS = '" + Utility.nullToSpace(ht.get("ASYS")) + "' ");
        }

        if(!Utility.nullToSpace(ht.get("WRITEOFF_DATE_1")).equals("")) {
            sql.append(" AND A3.WRITEOFF_DATE BETWEEN  '" + Utility.nullToSpace(ht.get("WRITEOFF_DATE_1")) + "' ");
        }

        if(!Utility.nullToSpace(ht.get("WRITEOFF_DATE_2")).equals("")) {
            sql.append(" AND  '" + Utility.nullToSpace(ht.get("WRITEOFF_DATE_2")) + "' ");
        }
        sql.append(" ORDER BY A1.CENTER_CODE ");

        System.out.println(sql.toString());
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
            Hashtable    rsht = null;


            while (rs.next())
            {
                 rsht = new Hashtable();
                /** 將欄位抄一份過去 */
                for (int i = 1; i <= rs.getColumnCount(); i++)
                {

                   // System.out.println(rs.getColumnName(i) + "==========" + rs.getString(i));
                    rsht.put(rs.getColumnName(i), rs.getString(i));
                }

                result.add(rsht);
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
     * 寄發各種繳費狀態mail
     */
    public Vector getSolt003Syst001ForUse(Hashtable ht) throws Exception {

        Vector result = new Vector();

        if(sql.length() > 0) {
            sql.delete(0, sql.length());
        }

        sql.append
        (
            "SELECT  S1.CODE_NAME AS ASYS, SOLT003.AYEAR, S2.CODE_NAME AS SMS, SYST002.CENTER_NAME AS CENTER_CODE, SOLT003.IDNO, " +
            "SOLT003.BIRTHDATE, S3.CODE_NAME AS STTYPE, SOLT003.NAME, S4.CODE_NAME AS SEX, SOLT003.CRRSADDR, SOLT003.AREACODE_OFFICE, " +
            "SOLT003.TEL_OFFICE, SOLT003.TEL_OFFICE_EXT, SOLT003.AREACODE_HOME, SOLT003.TEL_HOME, SOLT003.MOBILE, SOLT003.EMAIL, " +
            "S5.CODE_NAME AS EDUBKGRD_GRADE, SOLT003.EDUBKGRD_AYEAR, S6.CODE_NAME AS MARRIAGE, S7.CODE_NAME AS VOCATION,DECODE(SYST003.FACULTY_NAME,'校屬課程','尚未決定',SYST003.FACULTY_NAME) AS PRE_MAJOR_FACULTY, " +
            "S8.CODE_NAME AS TUTOR_CLASS_MK, S9.CODE_NAME AS HANDICAP_TYPE, S10.CODE_NAME AS HANDICAP_GRADE, S11.CODE_NAME AS ORIGIN_RACE, " +
            "REPLACE(SOLT003.GETINFO,',',';') AS GETINFO,  SOLT003.RECOMMEND_NAME,  SOLT003.RECOMMEND_ID, SOLT003.EMRGNCY_EMAIL, " +
            "S13.CODE_NAME AS OVERSEA_NATION, SOLT003.OVERSEA_NATION_RMK, S12.CODE_NAME AS OVERSEA_REASON, SOLT003.OVERSEA_REASON_RMK, S14.CODE_NAME AS OVERSEA_DOC, SOLT003.OVERSEA_DOC_DATE, SOLT003.OVERSEA_DOC_RMK, SOLT003.OVERSEA_ADDR " +
            "FROM SOLT003 JOIN SYST001 S1 ON S1.KIND='ASYS' AND S1.CODE = SOLT003.ASYS " +
            "LEFT JOIN SYST001 S2 ON S2.KIND='SMS' AND S2.CODE = SOLT003.SMS " +
            "LEFT JOIN SYST002 ON SYST002.CENTER_CODE = SOLT003.CENTER_CODE " +
            "LEFT JOIN SYST001 S3 ON S3.KIND='STTYPE' AND S3.CODE = SOLT003.STTYPE " +
            "LEFT JOIN SYST001 S4 ON S4.KIND='SEX' AND S4.CODE = SOLT003.SEX " +
            "LEFT JOIN SYST001 S5 ON S5.KIND='EDUBKGRD_GRADE' AND S5.CODE = SOLT003.EDUBKGRD_GRADE " +
            "LEFT JOIN SYST001 S6 ON S6.KIND='MARRIAGE' AND S6.CODE = SOLT003.MARRIAGE " +
            "LEFT JOIN SYST001 S7 ON S7.KIND='VOCATION' AND S7.CODE = SOLT003.VOCATION " +
            "LEFT JOIN SYST003 ON SYST003.ASYS = SOLT003.ASYS AND SYST003.FACULTY_CODE = SOLT003.PRE_MAJOR_FACULTY " +
            "LEFT JOIN SYST001 S8 ON S8.KIND='TUTOR_CLASS_MK' AND S8.CODE = SOLT003.TUTOR_CLASS_MK " +
            "LEFT JOIN SYST001 S9 ON S9.KIND='HANDICAP_TYPE' AND S9.CODE = SOLT003.HANDICAP_TYPE " +
            "LEFT JOIN SYST001 S10 ON S10.KIND='HANDICAP_GRADE' AND S10.CODE = SOLT003.HANDICAP_GRADE " +
            "LEFT JOIN SYST001 S11 ON S11.KIND='ORIGIN_RACE' AND S11.CODE = SOLT003.ORIGIN_RACE " +
            "LEFT JOIN SYST001 S12 ON S12.KIND='OVERSEA_REASON' AND S12.CODE = SOLT003.OVERSEA_REASON " +
            "LEFT JOIN SYST001 S13 ON S13.KIND='OVERSEA_NATION' AND S13.CODE = SOLT003.OVERSEA_NATION " +
            "LEFT JOIN SYST001 S14 ON S14.KIND='OVERSEA_DOC' AND S14.CODE = SOLT003.OVERSEA_DOC " +
            "WHERE 1  =  1 "
        );

        if(!Utility.checkNull(ht.get("ASYS"), "").equals(""))
			sql.append("AND SOLT003.ASYS	=	'" + Utility.dbStr(ht.get("ASYS"))+ "'");
		if(!Utility.checkNull(ht.get("AYEAR"), "").equals(""))
			sql.append("AND SOLT003.AYEAR	=	'" + Utility.dbStr(ht.get("AYEAR"))+ "'");
		if(!Utility.checkNull(ht.get("SMS"), "").equals(""))
			sql.append("AND SOLT003.SMS	=	'" + Utility.dbStr(ht.get("SMS"))+ "'");
		if(!Utility.checkNull(ht.get("CENTER_CODE"), "").equals(""))
			sql.append("AND SOLT003.CENTER_CODE	=	'" + Utility.dbStr(ht.get("CENTER_CODE"))+ "'");
		if(!Utility.checkNull(ht.get("BIRTHDATE"), "").equals(""))
			sql.append("AND SOLT003.BIRTHDATE	=	'" + Utility.dbStr(ht.get("BIRTHDATE"))+ "'");
		if(!Utility.checkNull(ht.get("IDNO"), "").equals(""))
			sql.append("AND SOLT003.IDNO	=	'" + Utility.dbStr(ht.get("IDNO"))+ "'");
		if(!Utility.checkNull(ht.get("STTYPE"), "").equals("")){
            sql.append("AND SOLT003.STTYPE	=	'" + Utility.dbStr(ht.get("STTYPE"))+ "'");
		}

        //== 查詢條件 ED ==

        if(!orderBy.equals("")){
            String[] orderByArray = orderBy.split(",");
            orderBy = "";
            for(int i = 0; i < orderByArray.length; i++) {
                orderByArray[i] = "SOLT003." + orderByArray[i].trim();

                if(i == 0) {
                    orderBy += " ORDER BY ";
                } else {
                    orderBy += ", ";
                }
                orderBy += orderByArray[i].trim();
            }
            sql.append(orderBy.toUpperCase());
            orderBy = "";
        }
        System.out.println(sql);
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
     * 列印REG_110R各中心各階段新生人數統計表  (計算註冊選課人數)
     * @param ht 條件值
     * @return 回傳 Vector 物件，內容為 Hashtable 的集合，<br>
     *         每一個 Hashtable 其 KEY 為欄位名稱，KEY 的值為欄位的值<br>
     *         若該欄位有中文名稱，則其 KEY 請加上 _NAME, EX: SMS 其中文欄位請設為 SMS_NAME
     * @throws Exception
     */
    public Vector getSolt003Regt007Print(Hashtable ht) throws Exception
    {

        Vector result = new Vector();

        if(sql.length() > 0) {
            sql.delete(0, sql.length());
        }

        sql.append
        (
         " SELECT COUNT(*) AS REG_CNT FROM  "+
         " (SELECT DISTINCT A.STNO "+
         " FROM SOLT003 A "+
         " JOIN REGT007 B ON A.STNO=B.STNO AND A.AYEAR=B.AYEAR AND A.SMS=B.SMS AND A.ASYS=B.ASYS "+
         " WHERE (B.UNQUAL_TAKE_MK<>'Y' OR B.UNQUAL_TAKE_MK IS NULL) "+
         " AND B.UNTAKECRS_MK<>'Y' AND B.PAYMENT_STATUS='Y' "




        );
        /** == 查詢條件 ST == */
       if(!Utility.nullToSpace(ht.get("ASYS")).equals("")) {
            sql.append(" AND A.ASYS = '" + Utility.nullToSpace(ht.get("ASYS")) + "' ");
        }

        if(!Utility.nullToSpace(ht.get("AYEAR")).equals("")) {
            sql.append(" AND A.AYEAR = '" + Utility.nullToSpace(ht.get("AYEAR")) + "' ");
        }

        if(!Utility.nullToSpace(ht.get("SMS")).equals("")) {
            sql.append(" AND A.SMS = '" + Utility.nullToSpace(ht.get("SMS")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("CENTER_CODE")).equals("")) {
            sql.append(" AND A.CENTER_CODE = '" + Utility.nullToSpace(ht.get("CENTER_CODE")) + "' ");
        }
        sql.append("  ) A  ");


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
            Hashtable    rsht = null;


            while (rs.next())
            {
                 rsht = new Hashtable();
                /** 將欄位抄一份過去 */
                for (int i = 1; i <= rs.getColumnCount(); i++)
                {


                    rsht.put(rs.getColumnName(i), rs.getString(i));
                }

                result.add(rsht);
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
     * 列印REG_110R各中心各階段新生人數統計表  (計算現場繳費人數)
     * @param ht 條件值
     * @return 回傳 Vector 物件，內容為 Hashtable 的集合，<br>
     *         每一個 Hashtable 其 KEY 為欄位名稱，KEY 的值為欄位的值<br>
     *         若該欄位有中文名稱，則其 KEY 請加上 _NAME, EX: SMS 其中文欄位請設為 SMS_NAME
     * @throws Exception
     */
    public Vector getSolt003Solt006Print(Hashtable ht) throws Exception
    {

        Vector result = new Vector();

        if(sql.length() > 0) {
            sql.delete(0, sql.length());
        }

        sql.append
        (
            " SELECT COUNT(*) AS CASH_CNT "+
            " FROM SOLT003 A "+
            " JOIN SOLT006 B ON A.ASYS=B.ASYS AND A.AYEAR=B.AYEAR AND A.SMS=B.SMS AND A.IDNO=B.IDNO AND A.BIRTHDATE=B.BIRTHDATE " +
            " WHERE 1 = 1 "
        );
        /** == 查詢條件 ST == */
       if(!Utility.nullToSpace(ht.get("ASYS")).equals("")) {
            sql.append(" AND A.ASYS = '" + Utility.nullToSpace(ht.get("ASYS")) + "' ");
        }

        if(!Utility.nullToSpace(ht.get("AYEAR")).equals("")) {
            sql.append(" AND A.AYEAR = '" + Utility.nullToSpace(ht.get("AYEAR")) + "' ");
        }

        if(!Utility.nullToSpace(ht.get("SMS")).equals("")) {
            sql.append(" AND A.SMS = '" + Utility.nullToSpace(ht.get("SMS")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("CENTER_CODE")).equals("")) {
            sql.append(" AND A.CENTER_CODE = '" + Utility.nullToSpace(ht.get("CENTER_CODE")) + "' ");
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
            Hashtable    rsht = null;


            while (rs.next())
            {
                 rsht = new Hashtable();
                /** 將欄位抄一份過去 */
                for (int i = 1; i <= rs.getColumnCount(); i++)
                {


                    rsht.put(rs.getColumnName(i), rs.getString(i));
                }

                result.add(rsht);
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
     * 列印SOL_008R報名費統計表 (計算繳費人數及免繳費人數))
     * @param ht 條件值
     * @return 回傳 Vector 物件，內容為 Hashtable 的集合，<br>
     *         每一個 Hashtable 其 KEY 為欄位名稱，KEY 的值為欄位的值<br>
     *         若該欄位有中文名稱，則其 KEY 請加上 _NAME, EX: SMS 其中文欄位請設為 SMS_NAME
     * @throws Exception
     */
    public Vector getSolt003PayManPrint(Hashtable ht) throws Exception
    {

        Vector result = new Vector();

        if(sql.length() > 0) {
            sql.delete(0, sql.length());
        }

        sql.append
        (
        " SELECT COUNT(*) AS PAY_MAN ,NVL(SUM(PAID_AMT),'0') AS SUM_MONEY "+
        " FROM SOLT003 A "+
        " JOIN SOLT006 B ON A.ASYS=B.ASYS AND A.AYEAR=B.AYEAR AND A.SMS=B.SMS AND A.IDNO=B.IDNO AND A.BIRTHDATE=B.BIRTHDATE "+
        " JOIN SOLT007 C ON B.ASYS=C.ASYS AND B.AYEAR=C.AYEAR AND B.SMS=C.SMS AND B.IDNO=C.IDNO AND B.WRITEOFF_NO=C.WRITEOFF_NO "+
        " WHERE 1 = 1 "

        );
        /** == 查詢條件 ST == */
       if(!Utility.nullToSpace(ht.get("ASYS")).equals("")) {
            sql.append(" AND A.ASYS = '" + Utility.nullToSpace(ht.get("ASYS")) + "' ");
        }

        if(!Utility.nullToSpace(ht.get("AYEAR")).equals("")) {
            sql.append(" AND A.AYEAR = '" + Utility.nullToSpace(ht.get("AYEAR")) + "' ");
        }

        if(!Utility.nullToSpace(ht.get("SMS")).equals("")) {
            sql.append(" AND A.SMS = '" + Utility.nullToSpace(ht.get("SMS")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("CENTER_CODE")).equals("")) {
            sql.append(" AND A.CENTER_CODE = '" + Utility.nullToSpace(ht.get("CENTER_CODE")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("REG_MANNER")).equals("")) {
            sql.append(" AND A.REG_MANNER = '" + Utility.nullToSpace(ht.get("REG_MANNER")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("PAY")).equals("2")) {   //要繳費人數
            sql.append(" AND C.PAYABLE_AMT > 0 AND C.PAYMENT_STATUS in ('2','3','4') ");
        }
        if(Utility.nullToSpace(ht.get("PAY")).equals("2")) {   //免繳費人數
            sql.append(" AND C.PAYABLE_AMT = 0 AND C.PAYMENT_STATUS in ('2','3','4') ");
        }
        if(!Utility.nullToSpace(ht.get("AUDIT_RESULT")).equals("")) {   // 中心審核狀態
        	sql.append(" AND B.AUDIT_RESULT = '" + Utility.nullToSpace(ht.get("AUDIT_RESULT")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("TOTAL_RESULT")).equals("")) {   // 教務處審核狀態
        	sql.append(" AND B.TOTAL_RESULT = '" + Utility.nullToSpace(ht.get("TOTAL_RESULT")) + "' ");
        }
//		sql.append(" AND (B.AUDIT_RESULT='0' OR B.TOTAL_RESULT='0') ");

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
            Hashtable    rsht = null;


            while (rs.next())
            {
                 rsht = new Hashtable();
                /** 將欄位抄一份過去 */
                for (int i = 1; i <= rs.getColumnCount(); i++)
                {


                    rsht.put(rs.getColumnName(i), rs.getString(i));
                }

                result.add(rsht);
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
     * 列印SOL_008R報名費統計表 (計算報名總金額))
     * @param ht 條件值
     * @return 回傳 Vector 物件，內容為 Hashtable 的集合，<br>
     *         每一個 Hashtable 其 KEY 為欄位名稱，KEY 的值為欄位的值<br>
     *         若該欄位有中文名稱，則其 KEY 請加上 _NAME, EX: SMS 其中文欄位請設為 SMS_NAME
     * @throws Exception
     */
    public Vector getSolt003Sun_MoneyPrint(Hashtable ht) throws Exception
    {

        Vector result = new Vector();

        if(sql.length() > 0) {
            sql.delete(0, sql.length());
        }

        sql.append
        (
        " SELECT NVL(SUM(PAID_AMT),'0') AS SUM_MONEY "+
        " FROM SOLT003 A "+
        " JOIN SOLT006 B ON A.ASYS=B.ASYS AND A.AYEAR=B.AYEAR AND A.SMS=B.SMS AND A.IDNO=B.IDNO AND A.BIRTHDATE=B.BIRTHDATE "+
        " JOIN SOLT007 C ON B.ASYS=C.ASYS AND B.AYEAR=C.AYEAR AND B.SMS=C.SMS AND B.IDNO=C.IDNO AND B.WRITEOFF_NO=C.WRITEOFF_NO "+
        " WHERE 1 = 1 "

        );
        /** == 查詢條件 ST == */
       if(!Utility.nullToSpace(ht.get("ASYS")).equals("")) {
            sql.append(" AND A.ASYS = '" + Utility.nullToSpace(ht.get("ASYS")) + "' ");
        }

        if(!Utility.nullToSpace(ht.get("AYEAR")).equals("")) {
            sql.append(" AND A.AYEAR = '" + Utility.nullToSpace(ht.get("AYEAR")) + "' ");
        }

        if(!Utility.nullToSpace(ht.get("SMS")).equals("")) {
            sql.append(" AND A.SMS = '" + Utility.nullToSpace(ht.get("SMS")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("CENTER_CODE")).equals("")) {
            sql.append(" AND A.CENTER_CODE = '" + Utility.nullToSpace(ht.get("CENTER_CODE")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("REG_MANNER")).equals("")) {
            sql.append(" AND A.REG_MANNER = '" + Utility.nullToSpace(ht.get("REG_MANNER")) + "' ");
        }
        if(Utility.nullToSpace(ht.get("PAY")).equals("1")) {   //要繳費人數
            sql.append(" AND C.PAYABLE_AMT > 0 AND C.PAYMENT_STATUS in ('2','3','4') ");
        }
        if(Utility.nullToSpace(ht.get("PAY")).equals("2")) {   //免繳費人數
            sql.append(" AND C.PAYABLE_AMT = 0 AND C.PAYMENT_STATUS in ('2','3','4') ");
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
            Hashtable    rsht = null;


            while (rs.next())
            {
                 rsht = new Hashtable();
                /** 將欄位抄一份過去 */
                for (int i = 1; i <= rs.getColumnCount(); i++)
                {


                    rsht.put(rs.getColumnName(i), rs.getString(i));
                }

                result.add(rsht);
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
     * 列印SOL_015R通信報名繳交報名費名冊
     * @param ht 條件值
     * @return 回傳 Vector 物件，內容為 Hashtable 的集合，<br>
     *         每一個 Hashtable 其 KEY 為欄位名稱，KEY 的值為欄位的值<br>
     *         若該欄位有中文名稱，則其 KEY 請加上 _NAME, EX: SMS 其中文欄位請設為 SMS_NAME
     * @throws Exception
     */
    public Vector getSolt003reg_manner1Print(Hashtable ht) throws Exception
    {

        Vector result = new Vector();

        if(sql.length() > 0) {
            sql.delete(0, sql.length());
        }

        sql.append
        (

        " SELECT NVL(C.PAYMENT_DATE,'&nbsp;') AS PAYMENT_DATE, A.NAME,NVL(C.PAID_AMT,'0') AS PAID_AMT, NVL(B.DRAFT_NO,'') AS DRAFT_NO, NVL(C.PAYABLE_AMT,'0') AS PAYABLE_AMT, NVL(B.WRITEOFF_NO,'&nbsp;') AS WRITEOFF_NO"+
        " FROM SOLT003 A "+
        " JOIN SOLT006 B ON A.ASYS = B.ASYS AND A.AYEAR=B.AYEAR AND A.SMS=B.SMS AND A.IDNO=B.IDNO AND A.BIRTHDATE=B.BIRTHDATE "+
        " JOIN SOLT007 C ON B.ASYS=C.ASYS AND B.AYEAR=C.AYEAR AND B.SMS=C.SMS AND B.IDNO=C.IDNO AND B.WRITEOFF_NO=C.WRITEOFF_NO "+
        " WHERE 1 = 1 AND C.PAYMENT_STATUS = '2' "

        );
        /** == 查詢條件 ST == */
       if(!Utility.nullToSpace(ht.get("ASYS")).equals("")) {
            sql.append(" AND A.ASYS = '" + Utility.nullToSpace(ht.get("ASYS")) + "' ");
        }

        if(!Utility.nullToSpace(ht.get("AYEAR")).equals("")) {
            sql.append(" AND A.AYEAR = '" + Utility.nullToSpace(ht.get("AYEAR")) + "' ");
        }

        if(!Utility.nullToSpace(ht.get("SMS")).equals("")) {
            sql.append(" AND A.SMS = '" + Utility.nullToSpace(ht.get("SMS")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("CENTER_CODE")).equals("")) {
            sql.append(" AND A.CENTER_CODE = '" + Utility.nullToSpace(ht.get("CENTER_CODE")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("REG_MANNER")).equals("")) {
            sql.append(" AND A.REG_MANNER = '" + Utility.nullToSpace(ht.get("REG_MANNER")) + "' ");
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
            Hashtable    rsht = null;


            while (rs.next())
            {
                 rsht = new Hashtable();
                /** 將欄位抄一份過去 */
                for (int i = 1; i <= rs.getColumnCount(); i++)
                {


                    rsht.put(rs.getColumnName(i), rs.getString(i));
                }

                result.add(rsht);
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
	 * 招生報名_取出報名資料
	 * @throws Exception
	 */
	public SignupInfo getSolt003QuerySignupInfo(String idno, String birthday, String ayear, String sms, String asys)
			throws Exception {
		DBResult rs = null;
		SignupInfo si = null;
		try {
			StringBuffer sqls = new StringBuffer();
			sqls.append("select a.ASYS, a.AYEAR, a.SMS, a.IDNO, a.BIRTHDATE, a.CENTER_CODE, a.STTYPE, ");
			sqls.append("a.NAME, a.SEX, a.VOCATION, a.EDUBKGRD, a.EDUBKGRD_GRADE, a.EDUBKGRD_AYEAR, a.ALIAS, a.ENG_NAME,  ");
			sqls.append("a.AREACODE_OFFICE,  a.TEL_OFFICE, a.TEL_OFFICE_EXT, a.AREACODE_HOME, a.VOCATION_DEPT, ");
			sqls.append("a.TEL_HOME, a.MOBILE, a.MARRIAGE, a.DMSTADDR, a.CRRSADDR, a.EMAIL, ");
			sqls.append("a.EMRGNCY_TEL, a.EMRGNCY_RELATION, a.EMRGNCY_NAME, a.EMRGNCY_EMAIL, a.GETINFO, a.TUTOR_CLASS_MK, ");
			sqls.append("a.PRE_MAJOR_FACULTY, a.HANDICAP_TYPE, a.HANDICAP_GRADE, a.NEWNATION, a.SPECIAL_STTYPE_TYPE, ");
			sqls.append("a.ORIGIN_RACE, a.REG_MANNER, a.J_FACULTY_CODE, a.DMSTADDR_ZIP, a.CRRSADDR_ZIP, b.AUDIT_RESULT, b.TOTAL_RESULT, ");
			sqls.append("a.OVERSEA_NATION, a.OVERSEA_NATION_RMK, a.OVERSEA_REASON, a.OVERSEA_REASON_RMK, a.OVERSEA_DOC, a.OVERSEA_DOC_DATE, a.OVERSEA_DOC_RMK, a.OVERSEA_ADDR, ");
			sqls.append("a.RECOMMEND_NAME, a.RECOMMEND_ID, DECODE(A.MAIL_DOC,'Y','證件已寄發','') AS MAIL_DOC, A.DOC_AGREE_MK, ");
			sqls.append("a.NEW_RESIDENT_CHD, a.FATHER_NAME, FATHER_ORIGINAL_COUNTRY, A.MOTHER_NAME, A.MOTHER_ORIGINAL_COUNTRY, A.SELF_IDENTITY_SEX ");
			sqls.append("from SOLT003 a, SOLT006 b ");
			sqls.append("where a.IDNO = '");
			sqls.append(idno);
			sqls.append("' and a.ASYS = '");
			sqls.append(asys);
			sqls.append("' and a.AYEAR = '");
			sqls.append(ayear);
			sqls.append("' and a.SMS = '");
			sqls.append(sms);
			sqls.append("' and a.BIRTHDATE = '");
			sqls.append(birthday);
			sqls.append("'");
			sqls.append(" and a.ASYS = b.ASYS and a.AYEAR = b.AYEAR and a.IDNO = b.IDNO and a.SMS = b.SMS and a.BIRTHDATE = b.BIRTHDATE");
System.out.println("sqls:"+sqls);
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
	 * 招生報名_取出報名資料
	 * @throws Exception
	 */
	public SignupInfo getSolt003CheckSignupInfo(String idno, String ayear, String sms, String asys)
			throws Exception {
		DBResult rs = null;
		SignupInfo si = null;
		try {
			StringBuffer sqls = new StringBuffer();
			sqls.append("select a.ASYS, a.AYEAR, a.SMS, a.IDNO, a.BIRTHDATE, a.CENTER_CODE, a.STTYPE, ");
			sqls.append("a.NAME, a.SEX, a.VOCATION, a.EDUBKGRD, a.EDUBKGRD_GRADE, a.EDUBKGRD_AYEAR, ");
			sqls.append("a.AREACODE_OFFICE,  a.TEL_OFFICE, a.TEL_OFFICE_EXT, a.AREACODE_HOME, ");
			sqls.append("a.TEL_HOME, a.MOBILE, a.MARRIAGE, a.DMSTADDR, a.CRRSADDR, a.EMAIL, ");
			sqls.append("a.EMRGNCY_TEL, a.EMRGNCY_RELATION, a.EMRGNCY_NAME, a.EMRGNCY_EMAIL, a.GETINFO, a.TUTOR_CLASS_MK, ");
			sqls.append("a.PRE_MAJOR_FACULTY, a.HANDICAP_TYPE, a.HANDICAP_GRADE, a.SPECIAL_STTYPE_TYPE, ");
			sqls.append("a.ORIGIN_RACE, a.REG_MANNER, a.J_FACULTY_CODE, a.DMSTADDR_ZIP, a.CRRSADDR_ZIP, a.NEWNATION, a.SELF_IDENTITY_SEX ");
			sqls.append("from SOLT003 a ");
			sqls.append("where a.IDNO = '");
			sqls.append(idno);
			//檢查身分證與生日，不需分學制
			// sqls.append("' and a.ASYS = '");
			// sqls.append(asys);
			sqls.append("' and a.AYEAR = '");
			sqls.append(ayear);
			sqls.append("' and a.SMS = '");
			sqls.append(sms);
			sqls.append("'");

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
	 * 招生報名_取出報名資料
	 * @throws Exception
	 */
	public PrintInfo getSolt003Solt006Solt007QueryPrintInfo(String idno, String ayear, String sms, String asys, String birthday) throws Exception {
		DBResult rs = null;
		PrintInfo pi = null;
		try {
			
			StringBuffer sqls = new StringBuffer();
			sqls.delete(0, sqls.length());
			sqls.append("select b.WRITEOFF_NO, c.PAYABLE_AMT, a.STNO, a.NAME, a.AYEAR, a.SMS, c.BOT_BARCODE, c.CS_BARCODE1, c.CS_BARCODE2, a.ASYS, ");
			sqls.append("c.POST_BARCODE1,c.POST_BARCODE2,c.POST_BARCODE3,");
			sqls.append("(select unique USER_NAME from AUTT001 where USER_IDNO= (select idno from syst010 where DUTY_TYPE = '05' and DEP_CODE = '555')) USER_NAME1, "); 
			sqls.append("(select unique USER_NAME from AUTT001 where USER_IDNO= (select idno from syst010 where DUTY_TYPE = '04' and DEP_CODE = '600')) USER_NAME2, "); 
			sqls.append("(select unique USER_NAME from AUTT001 where USER_IDNO= (select idno from syst010 where DUTY_TYPE = '01' and DEP_CODE = '500')) USER_NAME3  ");			 
			sqls.append("from SOLT003 a join SOLT006 b on a.ASYS = b.ASYS and a.AYEAR = b.AYEAR and a.SMS = b.SMS and a.IDNO = b.IDNO and a.BIRTHDATE = b.BIRTHDATE ");
			sqls.append("join SOLT007 c on a.ASYS = c.ASYS  and a.AYEAR = c.AYEAR  and a.IDNO = c.IDNO and a.SMS = c.SMS  and a.BIRTHDATE = c.BIRTHDATE ");
			sqls.append("where a.ASYS = '");
			sqls.append(asys);
			sqls.append("' and a.AYEAR = '");
			sqls.append(ayear);
			sqls.append("' and a.IDNO = '");
			sqls.append(idno);
			sqls.append("' and a.SMS = '");
			sqls.append(sms);
			sqls.append("' and a.BIRTHDATE = '");
			sqls.append(birthday);
			sqls.append("'");

			rs = dbmanager.getSimpleResultSet(conn);
			rs.open();
			rs.executeQuery(sqls.toString());

			while (rs.next()) {
				pi = new PrintInfo();
				Class cls = pi.getClass();

				for (int i = 1; i <= rs.getColumnCount(); i++) {
					Transformer tf = new Transformer();
					Method method = cls.getMethod(tf.getMethodName(rs.getColumnName(i)), new Class[] { String.class });
					method.invoke(pi, new String[] { rs.getString(i) });
				}
			}
		} catch (Exception e) {
			throw e;
		} finally {
			if (rs != null) {
				rs.close();
			}
		}

		return pi;
	}

	public DBResult getDataForSOL002R(Hashtable ht) throws Exception {
	if(sql.length() > 0) {
		sql.delete(0, sql.length());
	}

	String PAYMENT_STATUS = Utility.checkNull(ht.get("PAYMENT_STATUS"), "");


	sql.append
	(
		"SELECT " +
		"a.NAME, " +
		"(SELECT CENTER_NAME FROM SYST002 WHERE CENTER_CODE=a.CENTER_CODE) AS CENTER_ABBRNAME, " +
		"(SELECT CENTER_CODE FROM SYST002 WHERE CENTER_CODE=a.CENTER_CODE) AS CENTER_CODE, " +
		"a.IDNO, a.STNO, " +
		"b.VENUE_TAKE_SDATE, " +
		"b.VENUE_TAKE_EDATE, " +
		"(SELECT ADDR FROM SYST002 WHERE CENTER_CODE=a.CENTER_CODE) AS ADDR, " +
		"(SELECT ADDR2 FROM SYST002 WHERE CENTER_CODE=a.CENTER_CODE) AS ADDR2, " +
		"c.CONTENT, SUBSTR(e.WRITEOFF_NO, 7, 10) AS SSS1 " +
		"FROM SOLT003 a join REGT001 b on a.ASYS=b.ASYS and a.AYEAR=b.AYEAR and a.SMS=b.SMS " +
		"join SOLT002 c on a.ASYS=c.ASYS and a.AYEAR=c.AYEAR and a.SMS=c.SMS " +
		"JOIN SOLT006 d ON a.ASYS = d.ASYS AND a.AYEAR = d.AYEAR AND a.SMS = d.SMS AND a.IDNO = d.IDNO AND a.BIRTHDATE = d.BIRTHDATE "+
		//by poto
		"JOIN pcst004 f ON f.writeoff_no = d.writeoff_no "+
		(!PAYMENT_STATUS.equals("1") ? "" : "") +"LEFT　JOIN PCST013 e ON  e.WRITEOFF_NO = d.WRITEOFF_NO " +
		"WHERE " +
		"c.KIND='ENROLLMENT' " +
		"AND SUBSTR(c.TYPE,2,1)=(SELECT DECODE(NVL(PAYMENT_STATUS,'0'),'1','1','2') FROM SOLT007 WHERE ASYS=a.ASYS AND AYEAR=a.AYEAR AND SMS=a.SMS AND IDNO=a.IDNO AND BIRTHDATE=a.BIRTHDATE AND ROWNUM=1) " +
		"AND SUBSTR(c.TYPE,1,1)=a.STTYPE "
	);

	// if(!Utility.checkNull(ht.get("ASYS"), "").equals(""))
		// sql.append("AND a.ASYS	=	'" + Utility.dbStr(ht.get("ASYS"))+ "' ");
	sql.append("AND d.PAYMENT_STATUS in ("+PAYMENT_STATUS+") ");
	if(!Utility.checkNull(ht.get("AYEAR"), "").equals(""))
		sql.append("AND a.AYEAR	=	'" + Utility.dbStr(ht.get("AYEAR"))+ "' ");
	if(!Utility.checkNull(ht.get("SMS"), "").equals(""))
		sql.append("AND a.SMS	=	'" + Utility.dbStr(ht.get("SMS"))+ "' ");
	if(!Utility.checkNull(ht.get("CENTER_CODE"), "").equals(""))
		sql.append("AND a.CENTER_CODE	=	'" + Utility.dbStr(ht.get("CENTER_CODE"))+ "' ");
	if(!Utility.checkNull(ht.get("STTYPE"), "").equals(""))
		sql.append("AND a.STTYPE	=	'" + Utility.dbStr(ht.get("STTYPE"))+ "' ");
	if(!Utility.checkNull(ht.get("IDNO"), "").equals(""))
		sql.append("AND a.IDNO	=	'" + Utility.dbStr(ht.get("IDNO"))+ "' ");
	if(!Utility.checkNull(ht.get("REG_MANNER"), "").equals(""))
		sql.append("AND a.REG_MANNER	=	'" + Utility.dbStr(ht.get("REG_MANNER"))+ "' ");
	if(!Utility.checkNull(ht.get("WRITEOFF_NO"), "").equals(""))
		sql.append("AND d.WRITEOFF_NO	=	'" + Utility.dbStr(ht.get("WRITEOFF_NO"))+ "' ");
	if(!Utility.checkNull(ht.get("TOTAL_RESULT"), "").equals(""))
		sql.append("AND d.TOTAL_RESULT = '" + Utility.dbStr(ht.get("TOTAL_RESULT")) +"' ");
	if(!Utility.checkNull(ht.get("AUDIT_RESULT"), "").equals(""))
		sql.append("AND d.AUDIT_RESULT = '" + Utility.dbStr(ht.get("AUDIT_RESULT")) +"' ");
	if(!Utility.checkNull(ht.get("BATNUM_S"), "").equals(""))
		sql.append("AND e.BATNUM	>=	'" + Utility.dbStr(ht.get("BATNUM_S"))+ "' ");
	if(!Utility.checkNull(ht.get("BATNUM_E"), "").equals(""))
		sql.append("AND e.BATNUM	<=	'" + Utility.dbStr(ht.get("BATNUM_E"))+ "' ");
    //by poto 加入 PAYMENT_MANNER 條件 20090623
	String PAYMENT_MANNER = Utility.checkNull(ht.get("PAYMENT_MANNER"), "");
    if("ATM".equals(PAYMENT_MANNER)){
        sql.append("AND (f.PAYMENT_MANNER = '3' or e.PAYMENT_MANNER = '3') ");
        //sql.append("AND e.PAYMENT_MANNER = '3' ");//現場報名尚未對帳
    }else if("NO_ATM".equals(PAYMENT_MANNER)){
        sql.append("AND (f.PAYMENT_MANNER != '3' or e.PAYMENT_MANNER != '3') ");
        //sql.append("AND e.PAYMENT_MANNER != '3'	 ");//現場報名尚未對帳
    }else{

    }

	sql.append("ORDER BY a.CENTER_CODE, " + (!PAYMENT_STATUS.equals("1") ? "SSS1" : "IDNO "));

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

			return rs;
	} catch (Exception e) {
            throw e;
	}
    }
	
	/**
    *
    by poto sol006m sol015m審核 solt003 data
    */
   public Hashtable getSolt003StuData(Hashtable ht) throws Exception {
	   Hashtable rowHt = new Hashtable();
       if(sql.length() > 0) {
           sql.delete(0, sql.length());
       }
       sql.append(
           "SELECT * " +
           "FROM SOLT003 S03 " +
           "WHERE 1 = 1 "
       );
       if(!Utility.nullToSpace(ht.get("ASYS")).equals("")) {
           sql.append("AND S03.ASYS = '" + Utility.nullToSpace(ht.get("ASYS")) + "' ");
       }
       if(!Utility.nullToSpace(ht.get("AYEAR")).equals("")) {
           sql.append("AND S03.AYEAR = '" + Utility.nullToSpace(ht.get("AYEAR")) + "' ");
       }
       if(!Utility.nullToSpace(ht.get("SMS")).equals("")) {
           sql.append("AND S03.SMS = '" + Utility.nullToSpace(ht.get("SMS")) + "' ");
       }
       if(!Utility.nullToSpace(ht.get("IDNO")).equals("")) {
           sql.append("AND S03.IDNO = '" + Utility.nullToSpace(ht.get("IDNO")) + "' ");
       }
       if(!Utility.nullToSpace(ht.get("BIRTHDATE")).equals("")) {
           sql.append("AND S03.BIRTHDATE = '" + Utility.nullToSpace(ht.get("BIRTHDATE")) + "' ");
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
           if(rs.next()) {               
               for (int i = 1; i <= rs.getColumnCount(); i++){
                   rowHt.put(rs.getColumnName(i), rs.getString(i));
               }    
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

   /**
   *
   by poto for sol003m
   OLD 舊選轉新全  NEW 新生
   */
  public String getSttypeCheck(Hashtable ht) throws Exception {
	  
	  String type = "NEW";
      if(sql.length() > 0) {
          sql.delete(0, sql.length());
      }
      sql.append(
          "SELECT 1 " +
          "FROM STUT003 S03 " +
          "WHERE 1 = 1 AND S03.STTYPE = '2' AND S03.ENROLL_STATUS ='2' "
      );
     
      if(!Utility.nullToSpace(ht.get("IDNO")).equals("")) {
          sql.append("AND S03.IDNO = '" + Utility.nullToSpace(ht.get("IDNO")) + "' ");
      }
      if(!Utility.nullToSpace(ht.get("BIRTHDATE")).equals("")) {
          sql.append("AND S03.BIRTHDATE = '" + Utility.nullToSpace(ht.get("BIRTHDATE")) + "' ");
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
          if(rs.next()) {               
        	  type = "OLD";
          }
      } catch (Exception e) {
          throw e;
      } finally {
          if(rs != null) {
              rs.close();
          }
      }
      return type;
  }    
   
  
  
	/**
	 * 修改招生學生主要資料_取出學生資料
	 * @throws Exception
	 */
	public void getSol017mQuery(Vector vt, Hashtable ht) throws Exception {
		DBResult rs = null;
		try
		{
			String ayear = new String("");
			String sms = new String("");
			if(!Utility.checkNull(ht.get("YEARSMS"), "").equals(""))
			{
				ayear = Utility.dbStr(ht.get("YEARSMS")).substring(0,3);
				sms = Utility.dbStr(ht.get("YEARSMS")).substring(3);
				if(sms.equals("暑期"))
					sms = "3";
				else if (sms.equals("上學期"))
					sms = "1";
				else if (sms.equals("下學期"))
					sms = "2";
			}
			if(sql.length() >0)
				sql.delete(0, sql.length());
			sql.append
			(
				"SELECT DISTINCT A.IDNO, B.STNO, A.NAME, A.BIRTHDATE, A.CENTER_CODE,A.CENTER_NAME,A.STTYPE,A.UPD_REASON,A.UPD_DOC_NO,D.COMPARED,A.REG_MANNER,B.ENROLL_AYEARSMS " +
				"				 ,C.CODE_NAME AS ENROLL_STATUS_NAME " +
				"FROM ( " +
				"	SELECT a.IDNO, a.NAME, a.BIRTHDATE, a.CENTER_CODE, "+
				"		b.CENTER_ABBRNAME AS CENTER_NAME, "+
				"		a.STTYPE, "+
				"		'' UPD_REASON, "+
				"		''UPD_DOC_NO, " +
				"		a.REG_MANNER" +
				"	FROM SOLT003 a "+
				"	JOIN SYST002 b ON a.CENTER_CODE=b.CENTER_CODE "+
				"	WHERE '1'='1' "
			);
			if(!Utility.checkNull(ht.get("STNO"), "").equals(""))
				sql.append("	AND a.STNO = '" + Utility.dbStr(ht.get("STNO")) + "' ");
			if(!Utility.checkNull(ht.get("IDNO"), "").equals(""))
				sql.append("	AND a.IDNO = '" + Utility.dbStr(ht.get("IDNO")) + "' ");

			sql.append
			(
				"	ORDER BY a.IDNO ASC " +
				"	) A " +
				"	LEFT JOIN STUT003 B ON A.IDNO = B.IDNO AND A.BIRTHDATE = B.BIRTHDATE " +
				"	LEFT JOIN SYST001 C ON C.KIND = 'ENROLL_STATUS' AND C.CODE = B.ENROLL_STATUS "  +
				"	LEFT JOIN SOLT001 D ON D.AYEAR = "+ ayear +" AND D.SMS = "+ sms +" " 
			);

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
	
	/**
  *
  * @param ht 條件值
  * 修改招生學生主要資料_取出學生最大學年期資料
  * @return 回傳 Vector 物件，內容為 Hashtable 的集合，<br>
  *         每一個 Hashtable 其 KEY 為欄位名稱，KEY 的值為欄位的值<br>
  *         若該欄位有中文名稱，則其 KEY 請加上 _NAME, EX: SMS 其中文欄位請設為 SMS_NAME
  *         SMS為暑期時會被轉換成0
  * @throws Exception
  */
 public Vector getSolt003LimitStudentDateForUse(Hashtable ht) throws Exception {
     if(ht == null) {
         ht = new Hashtable();
     }
     Vector result = new Vector();
     if(sql.length() > 0) {
         sql.delete(0, sql.length());
     }
     sql.append(
         "SELECT S03.ASYS, S03.AYEAR, DECODE(S03.SMS,3,0,S03.SMS) AS SMS, S03.IDNO, S03.BIRTHDATE, S03.CENTER_CODE, S03.STTYPE, S03.NAME, S03.ENG_NAME, S03.ALIAS, S03.SEX, S03.SELF_IDENTITY_SEX, S03.VOCATION, S03.EDUBKGRD, S03.EDUBKGRD_GRADE, S03.AREACODE_OFFICE, S03.TEL_OFFICE, S03.TEL_OFFICE_EXT, S03.AREACODE_HOME, S03.TEL_HOME, S03.MOBILE, S03.MARRIAGE, S03.DMSTADDR, S03.DMSTADDR_ZIP, S03.CRRSADDR_ZIP, S03.CRRSADDR, S03.EMAIL, S03.EMRGNCY_TEL, S03.EMRGNCY_RELATION, S03.EMRGNCY_NAME, S03.UPD_RMK, S03.UPD_DATE, S03.UPD_TIME, S03.UPD_USER_ID, S03.ROWSTAMP, S03.GETINFO, S03.TUTOR_CLASS_MK, S03.PRE_MAJOR_FACULTY, S03.HANDICAP_TYPE, S03.HANDICAP_GRADE, S03.ORIGIN_RACE, S03.STNO, S03.REG_MANNER, S03.SERNO, S03.J_FACULTY_CODE, S03.GRAD_AYEAR, S03.REG_DATE,S03.UPD_IDNO, S03.MAIL_DSTRBT_STATUS, S03.SPECIAL_STTYPE_TYPE, S03.NEWNATION " +
         "FROM SOLT003 S03 " +
         "WHERE 1 = 1 "
     );
     
     if(!Utility.nullToSpace(ht.get("STNO")).equals("")) {
         sql.append("AND S03.STNO = '" + Utility.nullToSpace(ht.get("STNO")) + "' ");
     }
     if(!Utility.nullToSpace(ht.get("IDNO")).equals("")) {
         sql.append("AND S03.IDNO = '" + Utility.nullToSpace(ht.get("IDNO")) + "' ");
     }
     if(!Utility.nullToSpace(ht.get("BIRTHDATE")).equals("")) {
         sql.append("AND S03.BIRTHDATE = '" + Utility.nullToSpace(ht.get("BIRTHDATE")) + "' ");
     }
     
     if(!orderBy.equals("")) {
         String[] orderByArray = orderBy.split(",");
         orderBy = "";
         for(int i = 0; i < orderByArray.length; i++) {
             orderByArray[i] = "S03." + orderByArray[i].trim();

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