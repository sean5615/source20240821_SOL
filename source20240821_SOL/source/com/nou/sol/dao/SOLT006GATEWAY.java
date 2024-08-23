package com.nou.sol.dao;

import com.acer.db.DBManager;
import com.acer.db.query.DBResult;
import com.acer.util.Utility;
import com.acer.apps.Page;

import java.sql.Connection;
import java.util.Vector;
import java.util.Hashtable;

/*
 * (SOLT006) Gateway/*
 *-------------------------------------------------------------------------------*
 * Author    : 國長      2007/05/04
 * Modification Log :
 * Vers     Date           By             Notes
 *--------- -------------- -------------- ----------------------------------------
 * V0.0.1   2007/05/04     國長           建立程式
 *                                        新增 getSolt006ForUse(Hashtable ht)
 * V0.0.2   2007/05/17     俊賢           建立程式
 *                                        新增 getSolt003Solt006ForUse(Hashtable ht,String AYEAR,String SMS)
 * V0.0.3   2007/06/07     審判無名氏     新增 getSolt006Result01(Hashtable ht)
 * V0.0.4   2007/09/29     Jason          修改 getSolt003Solt006ForUse(Hashtable ht)
  * V0.0.5   2007/11/7     leon          新增 getSolt003Solt006ForUse1(Hashtable ht)
 *--------------------------------------------------------------------------------
 */
public class SOLT006GATEWAY {

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
    private SOLT006GATEWAY() {}

    /** 建構子，查詢全部資料用 */
    public SOLT006GATEWAY(DBManager dbmanager, Connection conn) {
        this.dbmanager = dbmanager;
        this.conn = conn;
    }

    /** 建構子，查詢分頁資料用 */
    public SOLT006GATEWAY(DBManager dbmanager, Connection conn, int pageNo, int pageSize) {
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
    public Vector getSolt006ForUse(Hashtable ht) throws Exception {
        if(ht == null) {
            ht = new Hashtable();
        }
        Vector result = new Vector();
        if(sql.length() > 0) {
            sql.delete(0, sql.length());
        }
        sql.append(
            "SELECT S06.ASYS, S06.AYEAR, S06.SMS, S06.IDNO, S06.BIRTHDATE, S06.AUDIT_CODE1, S06.AUDIT_EXER, S06.PAYMENT_STATUS, S06.PAYMENT_METHOD, S06.CHECK_DOC, S06.DOC_UNQUAL_REASON, S06.HANDICAP_AUDIT_MK, S06.HANDICAP_UNQUAL_REASON, S06.LOW_INCOME_AUDIT, S06.LOW_INCOME_UNQUAL_REASON, S06.DRAFT_NO, S06.WRITEOFF_NO, S06.AUDIT_RESULT, S06.AUDIT_UNQUAL_REASON, S06.KEYIN_EXER, S06.KEYIN_DATE " +
            "FROM SOLT006 S06 " +
            "WHERE 1 = 1 "
        );
        if(!Utility.nullToSpace(ht.get("ASYS")).equals("")) {
            sql.append("AND S06.ASYS = '" + Utility.nullToSpace(ht.get("ASYS")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("AYEAR")).equals("")) {
            sql.append("AND S06.AYEAR = '" + Utility.nullToSpace(ht.get("AYEAR")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("SMS")).equals("")) {
            sql.append("AND S06.SMS = '" + Utility.nullToSpace(ht.get("SMS")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("IDNO")).equals("")) {
            sql.append("AND S06.IDNO = '" + Utility.nullToSpace(ht.get("IDNO")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("BIRTHDATE")).equals("")) {
            sql.append("AND S06.BIRTHDATE = '" + Utility.nullToSpace(ht.get("BIRTHDATE")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("AUDIT_CODE1")).equals("")) {
            sql.append("AND S06.AUDIT_CODE1 = '" + Utility.nullToSpace(ht.get("AUDIT_CODE1")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("AUDIT_EXER")).equals("")) {
            sql.append("AND S06.AUDIT_EXER = '" + Utility.nullToSpace(ht.get("AUDIT_EXER")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("PAYMENT_STATUS")).equals("")) {
            sql.append("AND S06.PAYMENT_STATUS = '" + Utility.nullToSpace(ht.get("PAYMENT_STATUS")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("PAYMENT_METHOD")).equals("")) {
            sql.append("AND S06.PAYMENT_METHOD = '" + Utility.nullToSpace(ht.get("PAYMENT_METHOD")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("CHECK_DOC")).equals("")) {
            sql.append("AND S06.CHECK_DOC = '" + Utility.nullToSpace(ht.get("CHECK_DOC")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("DOC_UNQUAL_REASON")).equals("")) {
            sql.append("AND S06.DOC_UNQUAL_REASON = '" + Utility.nullToSpace(ht.get("DOC_UNQUAL_REASON")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("HANDICAP_AUDIT_MK")).equals("")) {
            sql.append("AND S06.HANDICAP_AUDIT_MK = '" + Utility.nullToSpace(ht.get("HANDICAP_AUDIT_MK")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("HANDICAP_UNQUAL_REASON")).equals("")) {
            sql.append("AND S06.HANDICAP_UNQUAL_REASON = '" + Utility.nullToSpace(ht.get("HANDICAP_UNQUAL_REASON")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("LOW_INCOME_AUDIT")).equals("")) {
            sql.append("AND S06.LOW_INCOME_AUDIT = '" + Utility.nullToSpace(ht.get("LOW_INCOME_AUDIT")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("LOW_INCOME_UNQUAL_REASON")).equals("")) {
            sql.append("AND S06.LOW_INCOME_UNQUAL_REASON = '" + Utility.nullToSpace(ht.get("LOW_INCOME_UNQUAL_REASON")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("DRAFT_NO")).equals("")) {
            sql.append("AND S06.DRAFT_NO = '" + Utility.nullToSpace(ht.get("DRAFT_NO")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("WRITEOFF_NO")).equals("")) {
            sql.append("AND S06.WRITEOFF_NO = '" + Utility.nullToSpace(ht.get("WRITEOFF_NO")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("AUDIT_RESULT")).equals("")) {
            sql.append("AND S06.AUDIT_RESULT = '" + Utility.nullToSpace(ht.get("AUDIT_RESULT")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("AUDIT_UNQUAL_REASON")).equals("")) {
            sql.append("AND S06.AUDIT_UNQUAL_REASON = '" + Utility.nullToSpace(ht.get("AUDIT_UNQUAL_REASON")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("KEYIN_EXER")).equals("")) {
            sql.append("AND S06.KEYIN_EXER = '" + Utility.nullToSpace(ht.get("KEYIN_EXER")) + "' ");
        }
        if(!Utility.nullToSpace(ht.get("KEYIN_DATE")).equals("")) {
            sql.append("AND S06.KEYIN_DATE = '" + Utility.nullToSpace(ht.get("KEYIN_DATE")) + "' ");
        }

        if(!orderBy.equals("")) {
            String[] orderByArray = orderBy.split(",");
            orderBy = "";
            for(int i = 0; i < orderByArray.length; i++) {
                orderByArray[i] = "S06." + orderByArray[i].trim();

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
     *
     * @param ht 條件值
     * @return 回傳 Vector 物件，內容為 Hashtable 的集合，<br>
     *         每一個 Hashtable 其 KEY 為欄位名稱，KEY 的值為欄位的值<br>
     *         若該欄位有中文名稱，則其 KEY 請加上 _NAME, EX: SMS 其中文欄位請設為 SMS_NAME
     * @throws Exception
     *        SOLT006查詢用的
     */
    public Vector getSolt003Solt006ForUse(Hashtable ht,String AYEAR,String SMS) throws Exception {

        Vector result = new Vector();
        if(sql.length() > 0) {
            sql.delete(0, sql.length());
        }

        sql.append
        (
            "SELECT SOLT003.AYEAR, SOLT003.AYEAR AS AYEAR1, SOLT003.SMS, SOLT003.SMS AS SMS1, SOLT003.IDNO, SOLT003.BIRTHDATE, " +
            "SOLT003.CENTER_CODE, SOLT003.CENTER_CODE AS CENTER_CODE1, SOLT003.STNO, SOLT003.NAME, SOLT003.EDUBKGRD_GRADE, " +
            "SOLT003.ASYS, SOLT003.ASYS AS ASYS1, SOLT003.STTYPE, SOLT006.AUDIT_RESULT,SOLT003.REG_MANNER " +
            "FROM  SOLT003 JOIN SOLT006 ON SOLT003.IDNO = SOLT006.IDNO AND SOLT003.BIRTHDATE = SOLT006.BIRTHDATE AND " +
            "SOLT003.AYEAR = SOLT006.AYEAR AND SOLT003.SMS = SOLT006.SMS AND SOLT003.ASYS = SOLT006.ASYS " +
            "WHERE 1  =  1 " +
            "AND SOLT006.AYEAR = '" + AYEAR + "' " +
            "AND SOLT006.SMS = '" + SMS + "' "
        );

        // == 查詢條件 ST ==
        if(!Utility.nullToSpace(ht.get("ASYS")).equals(""))
            sql.append("AND SOLT006.ASYS    =    '" + Utility.dbStr(ht.get("ASYS"))+ "' ");
        if(!Utility.nullToSpace(ht.get("IDNO")).equals(""))
            sql.append("AND SOLT003.IDNO    =    '" + Utility.dbStr(ht.get("IDNO"))+ "' ");
        if(!Utility.nullToSpace(ht.get("BIRTHDATE")).equals(""))
            sql.append("AND SOLT003.BIRTHDATE    =    '" + Utility.dbStr(ht.get("BIRTHDATE"))+ "' ");
        if(!Utility.nullToSpace(ht.get("NAME")).equals(""))
            sql.append("AND SOLT003.NAME    =    '" + Utility.dbStr(ht.get("NAME"))+ "' ");
        if(!Utility.nullToSpace(ht.get("CENTER_CODE")).equals(""))
            sql.append("AND SOLT003.CENTER_CODE    =    '" + Utility.dbStr(ht.get("CENTER_CODE"))+ "' ");
        if(!Utility.nullToSpace(ht.get("REG_MANNER")).equals(""))
            sql.append("AND SOLT003.REG_MANNER    =    '" + Utility.dbStr(ht.get("REG_MANNER"))+ "' ");
        if(!Utility.nullToSpace(ht.get("AUDIT_RESULT")).equals(""))
            sql.append("AND SOLT006.AUDIT_RESULT    =    '" + Utility.dbStr(ht.get("AUDIT_RESULT"))+ "' ");

        //== 查詢條件 ED ==

        if(!orderBy.equals("")) {
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
     *
     * @param ht 條件值
     * @return 回傳 Vector 物件，內容為 Hashtable 的集合，<br>
     *         每一個 Hashtable 其 KEY 為欄位名稱，KEY 的值為欄位的值<br>
     *         若該欄位有中文名稱，則其 KEY 請加上 _NAME, EX: SMS 其中文欄位請設為 SMS_NAME
     * @throws Exception
     *        SOLT006修改用的
     */
    public Vector getSolt003Solt006ForUse1(Hashtable ht) throws Exception {

        Vector result = new Vector();
        if(sql.length() > 0) {
            sql.delete(0, sql.length());
        }

        sql.append
        (
            " SELECT A.NATIONCODE,A.HANDICAP_TYPE, A.HANDICAP_GRADE, A.ORIGIN_RACE, A.NEWNATION, A.ASYS, A.AYEAR,A.SMS,F.CODE_NAME AS CSMS,A.IDNO,A.BIRTHDATE,A.NAME,A.STTYPE,G.CODE_NAME AS CSTTYPE,A.SEX,H.CODE_NAME AS CSEX,A.EDUBKGRD_GRADE,  "+
            " A.SELF_IDENTITY_SEX, S12.CODE_NAME AS CSELF_IDENTITY_SEX, "+ 
            " D.CENTER_CODE, D.CENTER_ABBRNAME AS CCENTER_CODE,M.PAYMENT_STATUS,M.PAYMENT_MANNER as PAYMENT_METHOD,B.CHECK_DOC,B.DOC_UNQUAL_REASON, "+
            " B.HANDICAP_AUDIT_MK, B.HANDICAP_UNQUAL_REASON, "+
            " B.LOW_INCOME_AUDIT ,B.LOW_INCOME_UNQUAL_REASON, "+
            " B.NEW_RESIDENT_AUDIT_MK ,B.NEW_RESIDENT_UNQUAL_REASON, "+
            " B.DRAFT_NO,A.STNO ,A.CRRSADDR, A.CRRSADDR_ZIP, A.DMSTADDR, A.DMSTADDR_ZIP, A.EMAIL, A.MOBILE, "+
            " A.AREACODE_HOME, A.AREACODE_OFFICE, A.TEL_HOME, A.TEL_OFFICE, A.TEL_OFFICE_EXT, " +
            " B.AUDIT_RESULT,B.AUDIT_UNQUAL_REASON, "+
            " B.WRITEOFF_NO,A.EDUBKGRD,A.EDUBKGRD_AYEAR,A.ROWSTAMP,B.TOTAL_RESULT,B.AUDIT_UNQUAL_REASON1,A.DOC_AGREE_MK, "+
            " NVL(N.PAID_AMT,C.PAID_AMT) as PAID_AMT,C.PAYABLE_AMT,A.REG_MANNER,C.NPAYMENT_BAR ,J.CODE_NAME AS CEDUBKGRD_GRADE,I.CODE_NAME AS CAUDIT_RESULT,L.CODE_NAME AS CTOTAL_RESULT,K.CODE_NAME AS CREG_MANNER, "+
			" (SELECT COUNT(1) FROM REGT005 O WHERE O.AYEAR=A.AYEAR AND O.SMS=A.SMS AND O.STNO=A.STNO AND TAKE_ABNDN='N') NUM, "+
			" (SELECT SMS_SDATE FROM SYST005 X WHERE A.AYEAR=X.AYEAR AND A.SMS=X.SMS ) AS SMS_SDATE, "+
			" (SELECT COUNT(1) FROM STUT003 S03 WHERE S03.IDNO = A.IDNO AND S03.BIRTHDATE = A.BIRTHDATE AND S03.ASYS = '1' AND S03.ASYS = A.ASYS AND S03.ENROLL_STATUS ='2' AND S03.ENROLL_AYEARSMS != '"+Utility.dbStr(ht.get("AYEAR"))+Utility.dbStr(ht.get("SMS"))+"') AS ST_TYPE, "+
			" (SELECT COUNT(1) FROM SGUT037 X1 WHERE X1.IDNO = A.IDNO AND X1.BIRTHDATE = A.BIRTHDATE ) AS SGU037_CHK, "+
			" O.PAYMENT_DATE, O.INTO_DATE, O.BATNUM, R1.CODE_NAME AS PAYMENT_MANNER, S1.CODE_NAME AS ENROLL_STATUS, A.RESIDENCE_DATE "+
            " ,DECODE(A.MAIL_DOC,'Y','SOL'||A.ASYS||A.AYEAR||A.SMS||SUBSTR(A.IDNO,1,1)||'***'||SUBSTR(A.IDNO,5,6)||A.BIRTHDATE,'') AS MAIL_SUBJECT "+
            " ,A.NEW_RESIDENT_CHD, A.FATHER_NAME, A.FATHER_ORIGINAL_COUNTRY, A.MOTHER_NAME, A.MOTHER_ORIGINAL_COUNTRY "+
            " FROM SOLT003 A  "+
            " JOIN SOLT006 B ON A.ASYS = B.ASYS AND A.AYEAR = B.AYEAR AND A.SMS = B.SMS AND A.IDNO = B.IDNO AND A.BIRTHDATE = B.BIRTHDATE "+
            " JOIN SOLT007 C ON A.ASYS = C.ASYS AND A.AYEAR = C.AYEAR AND A.SMS = C.SMS AND A.IDNO = C.IDNO AND A.BIRTHDATE = C.BIRTHDATE AND B.WRITEOFF_NO=C.WRITEOFF_NO "+
            " JOIN SYST002 D ON  A.CENTER_CODE = D.CENTER_CODE "+
            " JOIN PCST004 M ON  M.WRITEOFF_NO = B.WRITEOFF_NO "+
            " LEFT JOIN PCST018 N ON  N.WRITEOFF_NO = B.WRITEOFF_NO "+
            " LEFT JOIN PCST013 O ON  O.WRITEOFF_NO = B.WRITEOFF_NO "+
            " LEFT JOIN SYST001 R1 ON R1.KIND = 'PAYMENT_MANNER' AND R1.CODE = O.PAYMENT_MANNER "+
            " LEFT JOIN SYST001 E ON  A.ASYS = E.CODE AND E.KIND='ASYS' "+
            " LEFT JOIN SYST001 F ON  A.SMS = F.CODE AND F.KIND='SMS' "+
            " LEFT JOIN SYST001 G ON  A.STTYPE = G.CODE AND G.KIND='STTYPE' "+
            " LEFT JOIN SYST001 H ON  A.SEX = H.CODE AND H.KIND='SEX' "+
            " LEFT JOIN SYST001 J ON  A.EDUBKGRD_GRADE = J.CODE AND J.KIND='EDUBKGRD_GRADE' "+
            " LEFT JOIN SYST001 I ON  B.AUDIT_RESULT = I.CODE AND I.KIND='AUDIT_RESULT' "+
            " LEFT JOIN SYST001 K ON  A.REG_MANNER = K.CODE AND K.KIND='REG_MANNER' "+
            " LEFT JOIN SYST001 L ON  B.TOTAL_RESULT = L.CODE AND L.KIND='AUDIT_RESULT' "+
            " LEFT JOIN SYST001 P ON  A.NATIONCODE = P.CODE AND P.KIND='NATIONCODE' "+
            " LEFT JOIN STUT003 S3 ON S3.STNO = A.STNO "+
            " LEFT JOIN SYST001 S1 ON S1.KIND = 'ENROLL_STATUS' AND S1.CODE = S3.ENROLL_STATUS "+
            " LEFT JOIN SYST001 S12 ON S12.KIND = 'SEX' AND S12.CODE = A.SELF_IDENTITY_SEX "+
            
            " WHERE 1=1 "
        );

        if(!Utility.nullToSpace(ht.get("ASYS")).equals(""))
            sql.append("AND A.ASYS    =    '" + Utility.dbStr(ht.get("ASYS"))+ "' ");
        if(!Utility.nullToSpace(ht.get("IDNO")).equals(""))
            sql.append("AND A.IDNO    =    '" + Utility.dbStr(ht.get("IDNO"))+ "' ");
        if(!Utility.nullToSpace(ht.get("BIRTHDATE")).equals(""))
            sql.append("AND A.BIRTHDATE    =    '" + Utility.dbStr(ht.get("BIRTHDATE"))+ "' ");
        if(!Utility.nullToSpace(ht.get("AYEAR")).equals(""))
            sql.append("AND A.AYEAR    =    '" + Utility.dbStr(ht.get("AYEAR"))+ "' ");
        if(!Utility.nullToSpace(ht.get("SMS")).equals(""))
            sql.append("AND A.SMS    =    '" + Utility.dbStr(ht.get("SMS"))+ "' ");

        /** 20090625因為按審到第二頁基本資料都沒帶出來所以拿掉 ALECK 修改  */
        if(!Utility.nullToSpace(ht.get("NAME")).equals(""))
            sql.append("AND A.NAME    LIKE    '%" + Utility.dbStr(ht.get("NAME"))+ "%' ");
        if(!Utility.nullToSpace(ht.get("REG_MANNER")).equals(""))
            sql.append("AND A.REG_MANNER    =    '" + Utility.dbStr(ht.get("REG_MANNER"))+ "' ");
        if(!Utility.nullToSpace(ht.get("AUDIT_RESULT")).equals(""))
            sql.append("AND B.AUDIT_RESULT    =    '" + Utility.dbStr(ht.get("AUDIT_RESULT"))+ "' ");
        if(!Utility.nullToSpace(ht.get("TOTAL_RESULT")).equals(""))
            sql.append("AND B.TOTAL_RESULT    =    '" + Utility.dbStr(ht.get("TOTAL_RESULT"))+ "' ");
        if(!Utility.nullToSpace(ht.get("CENTER_CODE")).equals(""))
            sql.append("AND A.CENTER_CODE    =    '" + Utility.dbStr(ht.get("CENTER_CODE"))+ "' ");
        if(!Utility.nullToSpace(ht.get("PAYMENT_STATUS")).equals(""))
            sql.append("AND B.PAYMENT_STATUS    =    '" + Utility.dbStr(ht.get("PAYMENT_STATUS"))+ "' ");
        if(!Utility.nullToSpace(ht.get("MAIL_DOC")).equals(""))
            sql.append("AND A.MAIL_DOC    =    '" + Utility.dbStr(ht.get("MAIL_DOC"))+ "' ");
        


        if(!Utility.nullToSpace(ht.get("BATCH_CONDITION")).equals("")){
            // 之前已審核/待補件
			sql.append("and A.STNO IS NULL ");
        	// 之前已審核/待補件
			sql.append("and B.TOTAL_RESULT in ('0','4') ");
			// 表示已繳費
			sql.append("and M.PAYMENT_STATUS in ('2','4') ");
        }
        sql.append(" ORDER BY A.IDNO,A.BIRTHDATE ");


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
     * 列印審查表件清單
     * @param ht 條件值
     * @return 回傳 Vector 物件，內容為 Hashtable 的集合，<br>
     *         每一個 Hashtable 其 KEY 為欄位名稱，KEY 的值為欄位的值<br>
     *         若該欄位有中文名稱，則其 KEY 請加上 _NAME, EX: SMS 其中文欄位請設為 SMS_NAME
     * @throws Exception
     */
    public Vector getSolt006Result01(Hashtable ht) throws Exception {
        if(ht == null) {
            ht = new Hashtable();
        }
        Vector result = new Vector();
        if(sql.length() > 0) {
            sql.delete(0, sql.length());
        }
        sql.append(
		"SELECT AYEAR, "+
		"	SMS,"+
	   	"	(SELECT CENTER_CODE FROM SOLT003 a WHERE AYEAR=a.AYEAR AND SMS=a.SMS AND IDNO=a.IDNO AND STNO=a.STNO) AS CENTER_CODE, "+
		"	(SELECT NAME FROM SOLT003 a WHERE AYEAR=a.AYEAR AND SMS=a.SMS AND IDNO=a.IDNO AND STNO=a.STNO) AS NAME, "+
		"	(SELECT STTYPE FROM SOLT003 a WHERE AYEAR=a.AYEAR AND SMS=a.SMS AND IDNO=a.IDNO AND STNO=a.STNO) AS STTYPE, "+
	   	"	(SELECT STNO FROM SOLT003 a WHERE AYEAR=a.AYEAR AND SMS=a.SMS AND IDNO=a.IDNO AND STNO=a.STNO) AS STNO, "+
	   	"	AUDIT_RESULT, "+
   	   	"	(SELECT PAYABLE_AMT FROM SOLT007 a WHERE AYEAR=a.AYEAR AND SMS=a.SMS AND IDNO=a.IDNO) AS PAYABLE_AMT "+
		"FROM SOLT006 "+
		"WHERE AUDIT_RESULT='3' "
        );
        if(ht.get("CENTER_CODE") != null) {
            sql.append("AND IDNO IN (SELECT IDNO FROM SOLT003 WHERE CENTER_CODE='"+Utility.checkNull(ht.get("CENTER_CODE"), "")+"') ");
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
     * 取得招生審核通過外的相關統計資料
     * @param ht 條件值
     * @return 回傳 Vector 物件，內容為 Hashtable 的集合，<br>
     *         每一個 Hashtable 其 KEY 為欄位名稱，KEY 的值為欄位的值<br>
     *         若該欄位有中文名稱，則其 KEY 請加上 _NAME, EX: SMS 其中文欄位請設為 SMS_NAME
     * @throws Exception
     */
    public Vector getSolt006StaticData(Hashtable ht) throws Exception {
    	Vector result = new Vector();

        if(sql.length() > 0)
            sql.delete(0, sql.length());

        sql.append(
        		// 教務處審核狀態
        		"SELECT A.TOTAL_RESULT, B.CODE_NAME, COUNT(1) AS THIS_KIND_NUM, NVL(SUM(PAID_AMT),'0') AS TOTAL_PAID_AMT, '1-'||A.TOTAL_RESULT as CHECK_VAR "+
        		"FROM SOLT006 A, SYST001 B, SOLT007 C "+
        		"WHERE "+
        		"        A.AYEAR='"+ht.get("AYEAR")+"' "+
        		"    AND A.SMS='"+ht.get("SMS")+"' "+
        		"    AND A.ASYS='"+ht.get("ASYS")+"' "+
        		//"    AND A.TOTAL_RESULT>0  "+ // 排除已通過
        		"    AND B.KIND='AUDIT_RESULT' "+
        		"    AND B.CODE=A.TOTAL_RESULT "+
        		"    AND C.ASYS=A.ASYS  "+
        		"    AND C.AYEAR=A.AYEAR "+
        		"    AND C.SMS=A.SMS  "+
        		"    AND C.IDNO=A.IDNO  "+
        		"    AND C.WRITEOFF_NO=A.WRITEOFF_NO "+
        		"    AND C.PAYMENT_STATUS<>'1'  "+  // 已繳費
        		"GROUP BY A.TOTAL_RESULT, B.CODE_NAME "+
        		"UNION "+
        		// 中心審核狀態
        		"SELECT A.AUDIT_RESULT, B.CODE_NAME, COUNT(1) AS THIS_KIND_NUM, NVL(SUM(PAID_AMT),'0') AS TOTAL_PAID_AMT, '2-'||A.AUDIT_RESULT as CHECK_VAR "+
        		"FROM SOLT006 A, SYST001 B, SOLT007 C "+
        		"WHERE "+
        		"        A.AYEAR='"+ht.get("AYEAR")+"' "+
        		"    AND A.SMS='"+ht.get("SMS")+"' "+
        		"    AND A.ASYS='"+ht.get("ASYS")+"' "+
        		//"    AND A.AUDIT_RESULT>0 "+
        		"    AND B.KIND='AUDIT_RESULT' "+
        		"    AND B.CODE=A.AUDIT_RESULT "+
        		"    AND C.ASYS=A.ASYS  "+
        		"    AND C.AYEAR=A.AYEAR "+
        		"    AND C.SMS=A.SMS  "+
        		"    AND C.IDNO=A.IDNO  "+
        		"    AND C.WRITEOFF_NO=A.WRITEOFF_NO "+
        		"    AND C.PAYMENT_STATUS<>'1' "+
        		"GROUP BY A.AUDIT_RESULT, B.CODE_NAME "+
        		"ORDER BY 4 "
        );

        DBResult rs = null;
        try {
        	// 取出所有資料
            rs = dbmanager.getSimpleResultSet(conn);
            rs.open();
            rs.executeQuery(sql.toString());

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
     * 取得招生重複繳費的人數與繳費資料
     * @param ht 條件值
     * @return 回傳 Vector 物件，內容為 Hashtable 的集合，<br>
     *         每一個 Hashtable 其 KEY 為欄位名稱，KEY 的值為欄位的值<br>
     *         若該欄位有中文名稱，則其 KEY 請加上 _NAME, EX: SMS 其中文欄位請設為 SMS_NAME
     * @throws Exception
     */
    public Hashtable getSolt006DoublePaidData(Hashtable ht) throws Exception {
    	Hashtable result = new Hashtable();

        if(sql.length() > 0)
            sql.delete(0, sql.length());

        sql.append(
        	"SELECT CASE WHEN NVL(SUM(X.TOTAL_PAID_AMT),0) < 0 THEN 0 ELSE NVL(SUM(X.TOTAL_PAID_AMT),0) END AS TOTAL_DOUBLE_PAID_AMT, COUNT(1) AS TOTAL_DOUBLE_COUNT "+
        	"FROM "+
        	"( "+
        	"    SELECT SUM(B.PAID_AMT)-300 AS TOTAL_PAID_AMT "+
        	"    FROM SOLT006 A, PCST013 B "+
        	"    WHERE "+
        	"            A.ASYS='"+ht.get("ASYS")+"' "+
        	"        AND A.AYEAR='"+ht.get("AYEAR")+"' "+
        	"        AND A.SMS='"+ht.get("SMS")+"' "+
        	"        AND B.WRITEOFF_NO=A.WRITEOFF_NO "+
        	"    GROUP BY A.WRITEOFF_NO "+
        	"    HAVING COUNT(A.WRITEOFF_NO) >1 "+
        	") X "
        );

        DBResult rs = null;
        try {
        	// 取出所有資料
            rs = dbmanager.getSimpleResultSet(conn);
            rs.open();
            rs.executeQuery(sql.toString());

            if (rs.next()) {
            	result.put("TOTAL_DOUBLE_PAID_AMT", rs.getString("TOTAL_DOUBLE_PAID_AMT"));
            	result.put("TOTAL_DOUBLE_COUNT", rs.getString("TOTAL_DOUBLE_COUNT"));
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
     * 取得招生重複繳費的人數與繳費資料
     * @param ht 條件值
     * @return 回傳 Vector 物件，內容為 Hashtable 的集合，<br>
     *         每一個 Hashtable 其 KEY 為欄位名稱，KEY 的值為欄位的值<br>
     *         若該欄位有中文名稱，則其 KEY 請加上 _NAME, EX: SMS 其中文欄位請設為 SMS_NAME
     * @throws Exception
     */
    public Vector getSolt006DoublePaidStData(Hashtable ht) throws Exception {    	
    	Vector result = new Vector();
        if(sql.length() > 0)
            sql.delete(0, sql.length());

        sql.append(
            	"SELECT A.WRITEOFF_NO,C.STNO \n"+
            	"      FROM SOLT006 A \n"+
            	"      JOIN PCST013 B ON B.WRITEOFF_NO = A.WRITEOFF_NO \n"+
            	"      JOIN SOLT003 C ON A.ASYS = C.ASYS AND A.AYEAR = C.AYEAR AND A.SMS = C.SMS AND A.IDNO = C.IDNO AND A.BIRTHDATE = C.BIRTHDATE \n"+
            	"        WHERE A.ASYS='"+ht.get("ASYS")+"' \n"+
            	"        AND A.AYEAR='"+ht.get("AYEAR")+"' \n"+
            	"        AND A.SMS='"+ht.get("SMS")+"' \n"+
            	"     GROUP BY A.WRITEOFF_NO,C.STNO \n"+
            	"    HAVING COUNT(A.WRITEOFF_NO) > 1 "
        );

        DBResult rs = null;
        try {
        	// 取出所有資料
            rs = dbmanager.getSimpleResultSet(conn);
            rs.open();
            rs.executeQuery(sql.toString());

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
    
    public Hashtable getSolt006RegNum(Hashtable ht) throws Exception { 
    	Hashtable rowHt = new Hashtable();
        if(sql.length() > 0)
            sql.delete(0, sql.length());

        sql.append(
        		"SELECT COUNT(1) AS NUM,'1' AS TYPE \n"+
        		"FROM SOLT003 A  \n"+
        		"LEFT JOIN SOLT006 B ON A.ASYS=B.ASYS AND A.AYEAR=B.AYEAR AND A.SMS=B.SMS AND A.IDNO=B.IDNO AND A.BIRTHDATE=B.BIRTHDATE  \n"+
        		"LEFT JOIN SOLT007 C ON B.ASYS=C.ASYS AND B.AYEAR=C.AYEAR AND B.SMS=C.SMS AND B.IDNO=C.IDNO AND B.WRITEOFF_NO=C.WRITEOFF_NO  \n"+
        		"WHERE A.ASYS = '"+ht.get("ASYS")+"' AND A.AYEAR = '"+ht.get("AYEAR")+"' AND A.SMS = '"+ht.get("SMS")+"'  \n"+
        		"AND C.PAYMENT_STATUS IN ('2','3','4') \n"+
        		"AND TRIM(A.STNO) IS NOT NULL \n"+
        		"AND TRIM(B.ASYS) IS NOT NULL \n"+
        		"AND  EXISTS( \n"+
        		"	SELECT 1  \n"+
        		"	FROM REGT005 R5  \n"+
        		"	WHERE R5.AYEAR = A.AYEAR AND R5.SMS = A.SMS AND  R5.STNO = A.STNO  \n"+
        		"	AND R5.TAKE_ABNDN = 'N'  \n"+
        		") \n"+
        		"UNION \n"+
        		"SELECT COUNT(1) AS NUM,'2' AS TYPE \n"+
        		"FROM SOLT003 A  \n"+
        		"LEFT JOIN SOLT006 B ON A.ASYS=B.ASYS AND A.AYEAR=B.AYEAR AND A.SMS=B.SMS AND A.IDNO=B.IDNO AND A.BIRTHDATE=B.BIRTHDATE  \n"+
        		"LEFT JOIN SOLT007 C ON B.ASYS=C.ASYS AND B.AYEAR=C.AYEAR AND B.SMS=C.SMS AND B.IDNO=C.IDNO AND B.WRITEOFF_NO=C.WRITEOFF_NO  \n"+
        		"WHERE A.ASYS = '"+ht.get("ASYS")+"' AND A.AYEAR = '"+ht.get("AYEAR")+"' AND A.SMS = '"+ht.get("SMS")+"'  \n"+
        		"AND C.PAYMENT_STATUS IN ('2','3','4')AND TRIM(A.STNO) IS NOT NULL \n"+
        		"AND TRIM(B.ASYS) IS NOT NULL \n"+
        		"AND NOT EXISTS( \n"+
        		"	SELECT 1  \n"+
        		"	FROM REGT005 R5  \n"+
        		"	WHERE R5.AYEAR = A.AYEAR AND R5.SMS = A.SMS AND  R5.STNO = A.STNO  \n"+
        		"	AND R5.TAKE_ABNDN = 'N'   \n"+
        		") \n" +
        		"UNION \n"+
        		"SELECT COUNT(1) AS NUM,'3' AS TYPE \n"+
        		"FROM SOLT003 A  \n"+
        		"LEFT JOIN SOLT006 B ON A.ASYS=B.ASYS AND A.AYEAR=B.AYEAR AND A.SMS=B.SMS AND A.IDNO=B.IDNO AND A.BIRTHDATE=B.BIRTHDATE  \n"+
        		"LEFT JOIN SOLT007 C ON B.ASYS=C.ASYS AND B.AYEAR=C.AYEAR AND B.SMS=C.SMS AND B.IDNO=C.IDNO AND B.WRITEOFF_NO=C.WRITEOFF_NO  \n"+
        		"WHERE A.ASYS = '"+ht.get("ASYS")+"' AND A.AYEAR = '"+ht.get("AYEAR")+"' AND A.SMS = '"+ht.get("SMS")+"'  \n"+
        		"AND TRIM(B.ASYS) IS NOT NULL \n"+
        		"AND C.PAYMENT_STATUS IN ('2','3','4') AND TRIM(A.STNO) IS NULL \n"         		
        );

        DBResult rs = null;
        try {
        	// 取出所有資料
            rs = dbmanager.getSimpleResultSet(conn);
            rs.open();
            rs.executeQuery(sql.toString());

            
            while (rs.next()) {
            	rowHt.put(rs.getString("TYPE"),rs.getString("NUM"));                    
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
     * 列印新生報名尚未註冊選課名冊
     * @param ht 條件值
     * @return 回傳 Vector 物件，內容為 Hashtable 的集合，<br>
     *         每一個 Hashtable 其 KEY 為欄位名稱，KEY 的值為欄位的值<br>
     *         若該欄位有中文名稱，則其 KEY 請加上 _NAME, EX: SMS 其中文欄位請設為 SMS_NAME
     * @throws Exception
     */
    public Vector getSolt006NotChoosestheClassReport(Hashtable ht) throws Exception {
        if(ht == null) {
            ht = new Hashtable();
        }
        Vector result = new Vector();
        if(sql.length() > 0) {
            sql.delete(0, sql.length());
        }
        
        String ayear = null;
        if( !"".equals((String)ht.get("AYEAR")) )
        	ayear = Utility.checkNull(ht.get("AYEAR"), "");
        
        String sms = null;
        if( !"".equals((String)ht.get("SMS")) )
        	sms = Utility.checkNull(ht.get("SMS"), "");
        
        sql.append(
		"SELECT D.CODE_NAME AS REG_MANNER,C.CENTER_ABBRNAME,A.STNO,A.NAME,M.IDNO,M.BIRTHDATE,E.CODE_NAME AS STTYPE, "+
		"	   A.AREACODE_OFFICE,A.TEL_OFFICE,A.TEL_OFFICE_EXT,A.AREACODE_HOME,A.TEL_HOME,A.MOBILE,A.EMAIL,F.CODE_NAME AS SPECIAL_STTYPE_TYPE "+
		"FROM SOLT006 M LEFT JOIN SOLT003 A ON M.IDNO = A.IDNO AND M.ASYS = A.ASYS AND M.AYEAR = A.AYEAR AND M.SMS = A.SMS AND M.BIRTHDATE = A.BIRTHDATE "+
		"              LEFT JOIN REGT005 B ON M.AYEAR = B.AYEAR AND M.SMS = B.SMS AND A.STNO = B.STNO "+
		"			   LEFT JOIN SYST002 C ON A.CENTER_CODE = C.CENTER_CODE "+
		"			   LEFT JOIN SYST001 D ON D.KIND = 'REG_MANNER' AND A.REG_MANNER = D.CODE "+
		"			   LEFT JOIN SYST001 E ON E.KIND = 'STTYPE' AND A.STTYPE = E.CODE "+
		"			   LEFT JOIN SYST001 F ON F.KIND = 'SPECIAL_STTYPE_MK' AND A.SPECIAL_STTYPE_TYPE = F.CODE "+
		"WHERE M.AYEAR = '"+ayear+"' AND M.SMS = '"+sms+"' "
        );
        
        if(!"".equals((String)ht.get("PAYMENT_STATUS"))){
        	sql.append("AND M.PAYMENT_STATUS = "+Utility.checkNull(ht.get("PAYMENT_STATUS"), "")+" ");
        }
        
        if(!"".equals((String)ht.get("ASYS"))){
        	sql.append("AND M.ASYS = "+Utility.checkNull(ht.get("ASYS"), "")+" ");
        }
        
        if(!"".equals((String)ht.get("CENTER_CODE"))){
        	sql.append("AND A.CENTER_CODE = '"+Utility.checkNull(ht.get("CENTER_CODE"), "")+"' ");
        }
        
        if(!"".equals((String)ht.get("SPECIAL_STTYPE_TYPE"))){
        	sql.append("AND A.SPECIAL_STTYPE_TYPE ='"+Utility.checkNull(ht.get("SPECIAL_STTYPE_TYPE"), "")+"' ");
        }
        
        sql.append(
        " AND A.STNO IS NULL AND M.AUDIT_RESULT = 3 " +//中心審核通過
        "ORDER BY A.CENTER_CODE "
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
     * 取得學生enroll狀態
     */
    public Vector getSolt006EnrollStatus(Hashtable ht) throws Exception {
        if(ht == null) {
            ht = new Hashtable();
        }
        Vector result = new Vector();
        if(sql.length() > 0) {
            sql.delete(0, sql.length());
        }
        
        String stno = null;
        if( !"".equals((String)ht.get("STNO")) )
        	stno = Utility.checkNull(ht.get("STNO"), "");
        
        sql.append(
		"SELECT STNO, ENROLL_STATUS, ENROLL_AYEARSMS FROM STUT003 "+
		"WHERE STNO = '"+stno+"' "
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
}