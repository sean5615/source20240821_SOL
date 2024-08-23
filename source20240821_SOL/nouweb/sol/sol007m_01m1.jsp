<%/*
----------------------------------------------------------------------------------
File Name        : sol007m_01m1.jsp
Author            : 曾國昭
Description        : SOL007M_異動報名新生資料 - 處理邏輯頁面
Modification Log    :

Vers        Date           By                Notes
--------------    --------------    --------------    ----------------------------------
1.0.1        097/07/30    barry         新增特殊生註記(SPECIAL_STTYPE_TYPE)欄位
1.0.0        097/07/15    barry         QA SOL10-01
0.0.1        096/01/29    曾國昭        Code Generate Create
0.0.2        096/05/11    陳俊賢        updata Cod DAO
----------------------------------------------------------------------------------
*/%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="MS950"%>
<%@ include file="/utility/header.jsp"%>
<%@ include file="/utility/modulepageinit.jsp"%>
<%@ page import="com.nou.sol.dao.*"%>
<%@ page import="com.nou.sys.dao.*"%>
<%@ page import="com.nou.stu.dao.*"%>
<%@ page import="com.nou.sgu.bo.*"%>
<%@ page import="java.util.Vector"%>
<%@ page import="com.nou.stu.STUADDDATA"%>
<%@ page import="com.nou.aut.bo.AUTUPDUSER"%>

<%!
/** 處理查詢 Grid 資料 */
public void doQuery(JspWriter out, DBManager dbManager, Hashtable requestMap, HttpSession session) throws Exception
{
    try
    {
        int        pageNo        =    Integer.parseInt(Utility.checkNull(requestMap.get("pageNo"), "1"));
        int        pageSize    =    Integer.parseInt(Utility.checkNull(requestMap.get("pageSize"), "10"));
        Connection    conn    =    dbManager.getConnection(AUTCONNECT.mapConnect("SOL", session));
        	
		Vector result = new Vector();

        SOLT003GATEWAY  Solt03JSolt06  =    new SOLT003GATEWAY(dbManager, conn, pageNo, pageSize);
		if(Utility.nullToSpace(requestMap.get("CROSS")).equals("1"))
			result =  Solt03JSolt06.getSolt003Solt006ForUse(requestMap, 1);
		else
			result =  Solt03JSolt06.getSolt003Solt006ForUse(requestMap, 0);
		
        // == 查詢條件 ST ==
        // == 查詢條件 ED ==
        //SOLT003.setWhere("IDNO,BIRTHDATE");
        /** 需額外處理範例, 請參考 Sample.txt */

        // out.println(DataToJson.rsToJson (SOLT003.getTotalRowCount(), rs, info));
        //out.println(DataToJson.rsToJson (SOLT003.getTotalRowCount(), rs));
		out.println(DataToJson.vtToJson (Solt03JSolt06.getTotalRowCount(),result));
    }
    catch (Exception ex)
    {
        throw ex;
    }
    finally
    {
        dbManager.close();
    }

}

/** 修改帶出資料 */
public void doQueryEdit(JspWriter out, DBManager dbManager, Hashtable requestMap, HttpSession session) throws Exception
{
    try
    {
        Vector result = new Vector();
        int        pageNo        =    Integer.parseInt(Utility.checkNull(requestMap.get("pageNo"), "1"));
        int        pageSize      =    Integer.parseInt(Utility.checkNull(requestMap.get("pageSize"), "10"));
        Connection    conn       =    dbManager.getConnection(AUTCONNECT.mapConnect("SOL", session));

        SOLT003GATEWAY  Solt03JSolt06  =    new SOLT003GATEWAY(dbManager, conn);

        result =  Solt03JSolt06.getSolt003Solt006ForUse(requestMap);
		if (result.size() !=0){			
			((Hashtable)result.get(0)).put("GETINFO_TMP", ((Hashtable)result.get(0)).get("GETINFO"));
		}
        
		SOLT005DAO SOLT005 = new SOLT005DAO(dbManager, conn);
		SOLT005.setResultColumn(" COUNT(*) NUM ");
		SOLT005.setASYS(Utility.checkNull(requestMap.get("ASYS"), ""));
		SOLT005.setIDNO(Utility.checkNull(requestMap.get("IDNO"), ""));
		SOLT005.setBIRTHDATE(Utility.checkNull(requestMap.get("BIRTHDATE"), ""));
		DBResult rs = SOLT005.query();
		rs.next();
		if(rs.getString("NUM").equals("0"))
			((Hashtable)result.get(0)).put("NUM", "0");
		else
			((Hashtable)result.get(0)).put("NUM", "1");
			
		// 取得姓名
        STUT002GATEWAY stut002 = new STUT002GATEWAY(dbManager, conn);
        rs = stut002.getStuBaseData(requestMap);
        if(rs.next()){
        	((Hashtable)result.get(0)).put("IS_OLD", "Y");
        	((Hashtable)result.get(0)).put("NAME", rs.getString("NAME"));
        }else{
        	((Hashtable)result.get(0)).put("IS_OLD", "N");
        	//((Hashtable)result.get(0)).put("NAME", requestMap.get("NAME"));
        }			
		
        out.println(DataToJson.vtToJson(Solt03JSolt06.getTotalRowCount(), result));
    }catch (Exception ex)
    {
        throw ex;
    }
    finally
    {
        dbManager.close();
    }
}

/** 修改存檔 */
public void doModify(JspWriter out, DBManager dbManager, Hashtable requestMap, HttpSession session) throws Exception
{
    try
    {
        Connection    conn    =    dbManager.getConnection(AUTCONNECT.mapConnect("SOL", session));

        /** 修改條件 */
        String    condition    =    "ASYS        =    '" + Utility.dbStr(requestMap.get("ASYS"))+ "' AND " +
                                    "AYEAR        =    '" + Utility.dbStr(requestMap.get("AYEAR"))+ "' AND " +
                                    "SMS        =    '" + Utility.dbStr(requestMap.get("SMS"))+ "' AND " +
                                    "IDNO        =    '" + Utility.dbStr(requestMap.get("IDNO"))+ "' AND " +
                                    "BIRTHDATE    =    '" + Utility.dbStr(requestMap.get("BIRTHDATE"))+ "'";

        /** 處理修改動作 */		
        String EDUBKGRD=(Utility.dbStr(requestMap.get("EDUBKGRD"))+Utility.dbStr(requestMap.get("EDUBKGRD1")+Utility.dbStr(requestMap.get("aaa"))));
        String PRE_MAJOR_FACULTY=Utility.dbStr(requestMap.get("PRE_MAJOR_FACULTY"));
        String J_FACULTY_CODE="";
        if(!Utility.checkNull(requestMap.get("PRE_MAJOR_FACULTY"), "").equals("")){
             J_FACULTY_CODE=PRE_MAJOR_FACULTY.substring(2,4);
             PRE_MAJOR_FACULTY=PRE_MAJOR_FACULTY.substring(0,2);
        }

        requestMap.remove("EDUBKGRD");
        requestMap.remove("PRE_MAJOR_FACULTY");
        requestMap.remove("GETINFO");
        requestMap.put("EDUBKGRD",EDUBKGRD);
        requestMap.put("PRE_MAJOR_FACULTY",PRE_MAJOR_FACULTY);
        requestMap.put("J_FACULTY_CODE",J_FACULTY_CODE);
        requestMap.put("GETINFO",Utility.dbStr(requestMap.get("GETINFO_TMP")));
        
        int    updateCount;
        SOLT003DAO    SOLT003    =    new SOLT003DAO(dbManager, conn,requestMap,session);
        updateCount    =    SOLT003.update(condition);
		// SOLU003-基本資料LOG
		SOLU003DAO solu003Dao = new SOLU003DAO(dbManager, conn, requestMap, (String)session.getAttribute("USER_ID"));
		solu003Dao.insert();
		
		//寫入autt005 
		//by poto 20110913
		//如果沒有學號 就是沒有帳號 就不要做這段處理
		if( !"".equals(Utility.checkNull(requestMap.get("STNO"), ""))){
		
			// 姓名有修改需額外更新到權限系統
			AUTUPDUSER aut = new AUTUPDUSER(dbManager);
			aut.setIDNO(Utility.checkNull(requestMap.get("IDNO"), ""));
			aut.setNAME(Utility.checkNull(requestMap.get("NAME"), ""));
			aut.setUPD_TYPE("1");  // 1:同步修改權限姓名
			
			if(aut.execute()==aut.FAIL){
				out.println(DataToJson.faileJson("更新權限系統發生錯誤:"+aut.getAllError()));
				return;
			}
			
			
			AUTUPDUSER aut_1 = new AUTUPDUSER(dbManager);
			aut_1.setUSER_ID(Utility.checkNull(requestMap.get("STNO"), ""));		
			aut_1.setDEP_CODE(Utility.checkNull(requestMap.get("CENTER_CODE"), ""));	
			aut_1.setO_DEP_CODE(Utility.checkNull(requestMap.get("OLD_CENTER_CODE"), ""));	
			aut_1.execute();
			
			if(aut_1.execute()==aut_1.FAIL){
				out.println(DataToJson.faileJson("更新權限系統發生錯誤:"+aut_1.getAllError()));
				return;
			}
		
		}		
		dbManager.commit();
		//STNO不為空值，必須同步更新學籍資料  2008/07/30 by barry
		
		System.out.println("STNO="+Utility.checkNull(requestMap.get("STNO"), ""));
		if(!Utility.checkNull(requestMap.get("STNO"), "").equals(""))
		{
			DBResult	rs	=	null;
			StringBuffer	sql		=	new StringBuffer();
			sql.append("select a.ENROLL_AYEARSMS, a.FTSTUD_ENROLL_AYEARSMS from stut003 a join stut002 b on a.idno=b.idno and a.birthdate=b.birthdate where a.stno='"+requestMap.get("STNO").toString()+"'");
			rs	=	dbManager.getSimpleResultSet(conn);
			rs.open();
			rs.executeQuery(sql.toString());
			String ENROLL_AYEARSMS = "";
			String FTSTUD_ENROLL_AYEARSMS = "";
			if(rs.next()){
				ENROLL_AYEARSMS = rs.getString("ENROLL_AYEARSMS");
				FTSTUD_ENROLL_AYEARSMS = rs.getString("FTSTUD_ENROLL_AYEARSMS");
				
				String ayearSms = Utility.checkNull(requestMap.get("AYEAR"), "") + Utility.checkNull(requestMap.get("SMS"), "");
				STUADDDATA stuAdd = new STUADDDATA(dbManager);
				stuAdd.setUSER_ID((String)session.getAttribute("USER_ID"));
				stuAdd.setAYEAR((String)requestMap.get("AYEAR"));
				stuAdd.setSMS((String)requestMap.get("SMS"));
				stuAdd.setIDNO((String)requestMap.get("IDNO"));
				stuAdd.setBIRTHDATE((String)requestMap.get("BIRTHDATE"));
				stuAdd.setCENTER_CODE((String)requestMap.get("CENTER_CODE"));
				stuAdd.setSTTYPE((String)requestMap.get("STTYPE"));
				stuAdd.setNAME((String)requestMap.get("NAME"));
				stuAdd.setENG_NAME((String)requestMap.get("ENG_NAME"));
				stuAdd.setSEX((String)requestMap.get("SEX"));
				stuAdd.setSELF_IDENTITY_SEX((String)requestMap.get("SELF_IDENTITY_SEX"));
				stuAdd.setALIAS((String)requestMap.get("ALIAS"));
				stuAdd.setVOCATION((String)requestMap.get("VOCATION"));
				stuAdd.setEDUBKGRD_GRADE((String)requestMap.get("EDUBKGRD_GRADE"));
				//stuAdd.setCheckEdubkgrdGradeStut002(false);
				
				stuAdd.setAREACODE_OFFICE((String)requestMap.get("AREACODE_OFFICE"));
				stuAdd.setTEL_OFFICE((String)requestMap.get("TEL_OFFICE"));
				stuAdd.setTEL_OFFICE_EXT((String)requestMap.get("TEL_OFFICE_EXT"));
				stuAdd.setAREACODE_HOME((String)requestMap.get("AREACODE_HOME"));
				stuAdd.setTEL_HOME((String)requestMap.get("TEL_HOME"));
				stuAdd.setMOBILE((String)requestMap.get("MOBILE"));
				stuAdd.setMARRIAGE((String)requestMap.get("MARRIAGE"));
				stuAdd.setDMSTADDR_ZIP((String)requestMap.get("DMSTADDR_ZIP"));
				stuAdd.setDMSTADDR((String)requestMap.get("DMSTADDR"));
				stuAdd.setCRRSADDR_ZIP((String)requestMap.get("CRRSADDR_ZIP"));
				stuAdd.setCRRSADDR((String)requestMap.get("CRRSADDR"));
				stuAdd.setEMAIL((String)requestMap.get("EMAIL"));
				stuAdd.setEMRGNCY_RELATION((String)requestMap.get("EMRGNCY_RELATION"));
				stuAdd.setASYS((String)requestMap.get("ASYS"));
				stuAdd.setSTNO((String)requestMap.get("STNO"));
				stuAdd.setSPECIAL_STTYPE_TYPE((String)requestMap.get("SPECIAL_STTYPE_TYPE"));
				stuAdd.setNATIONCODE(Utility.nullToSpace(requestMap.get("NATIONCODE")));
				stuAdd.setIDNO_CHECK(UtilityX.stuIdnoChk(Utility.nullToSpace(requestMap.get("NATIONCODE"))));
				stuAdd.setNEWNATION(Utility.nullToSpace(requestMap.get("NEWNATION")));
				stuAdd.setRESIDENCE_DATE(Utility.nullToSpace(requestMap.get("RESIDENCE_DATE")));
				stuAdd.setEDUBKGRD_AYEAR(Utility.nullToSpace(requestMap.get("EDUBKGRD_AYEAR")));
				//by poto 選修生 2   FTSTUD_ENROLL_AYEARSMS,FTSTUD_CENTER_CODE 清空
				if( "2".equals( (String)requestMap.get("STTYPE")) ){
					stuAdd.setFTSTUD_ENROLL_AYEARSMS("");
					stuAdd.setFTSTUD_CENTER_CODE("");
				}else{
					stuAdd.setFTSTUD_ENROLL_AYEARSMS((String)requestMap.get("AYEAR") + (String)requestMap.get("SMS"));
					stuAdd.setFTSTUD_CENTER_CODE((String)requestMap.get("CENTER_CODE"));
				}
				
				if(ENROLL_AYEARSMS.equals(ayearSms)){
					stuAdd.setENROLL_AYEARSMS((String)requestMap.get("AYEAR") + (String)requestMap.get("SMS"));
				}	
				stuAdd.setEMRGNCY_NAME((String)requestMap.get("EMRGNCY_NAME"));
				stuAdd.setEMRGNCY_TEL((String)requestMap.get("EMRGNCY_TEL"));
				stuAdd.setEDUBKGRD(EDUBKGRD.replaceAll("其他",""));
				stuAdd.setPRE_MAJOR_FACULTY((String)requestMap.get("PRE_MAJOR_FACULTY"));
				stuAdd.setJ_FACULTY_CODE((String)requestMap.get("J_FACULTY_CODE"));
				stuAdd.setTUTOR_CLASS_MK((String)requestMap.get("TUTOR_CLASS_MK"));
				stuAdd.setUPD_MK("2");//修改
				stuAdd.execute();
				System.out.println("ERRORS="+stuAdd.nextError());
			}
		}
		
		
//        SOLT006DAO    SOLT006    =    new SOLT006DAO(dbManager, conn,requestMap,session);
//        updateCount    =    SOLT006.update(condition);

        if(Utility.checkNull(requestMap.get("CHKSTD"), "").equals("on")){
            SOLT005DAO    SOLT005    =    new SOLT005DAO(dbManager, conn,requestMap,session);
            updateCount    =    SOLT005.delete(condition);
            if(!Utility.nullToSpace(requestMap.get("ASYS")).equals(""))
                SOLT005.setASYS(Utility.dbStr(requestMap.get("ASYS")));
            if(!Utility.nullToSpace(requestMap.get("AYEAR")).equals(""))
                SOLT005.setAYEAR(Utility.dbStr(requestMap.get("AYEAR")));
            if(!Utility.nullToSpace(requestMap.get("SMS")).equals(""))
                SOLT005.setSMS(Utility.dbStr(requestMap.get("SMS")));
            if(!Utility.nullToSpace(requestMap.get("IDNO")).equals(""))
                SOLT005.setIDNO(Utility.dbStr(requestMap.get("IDNO")));
            if(!Utility.nullToSpace(requestMap.get("BIRTHDATE")).equals(""))
                SOLT005.setBIRTHDATE(Utility.dbStr(requestMap.get("BIRTHDATE")));
            if(!Utility.nullToSpace(requestMap.get("SCHOOL_NAME_OLD")).equals(""))
                SOLT005.setSCHOOL_NAME_OLD(Utility.dbStr(requestMap.get("SCHOOL_NAME_OLD")));
            if(!Utility.nullToSpace(requestMap.get("FACULTY_OLD")).equals(""))
                SOLT005.setFACULTY_OLD(Utility.dbStr(requestMap.get("FACULTY_OLD")));
            if(!Utility.nullToSpace(requestMap.get("GRADE_OLD")).equals(""))
                SOLT005.setGRADE_OLD(Utility.dbStr(requestMap.get("GRADE_OLD")));
            if(!Utility.nullToSpace(requestMap.get("STNO_OLD")).equals(""))
                SOLT005.setSTNO_OLD(Utility.dbStr(requestMap.get("STNO_OLD")));

            SOLT005.insert();
        }else{

            SOLT005DAO    SOLT005    =    new SOLT005DAO(dbManager, conn,requestMap,session);
            updateCount    =    SOLT005.delete(condition);

        }
		
		//新增原住民和身心障礙資料至SGUT004
		if(!Utility.checkNull(requestMap.get("STNO"), "").equals(""))
		{
			if(!(Utility.nullToSpace(requestMap.get("ORIGIN_RACE")).equals("") || Utility.nullToSpace(requestMap.get("ORIGIN_RACE")).equals("0")) || !(Utility.nullToSpace(requestMap.get("HANDICAP_TYPE")).equals("") || Utility.nullToSpace(requestMap.get("HANDICAP_TYPE")).equals("00")) )
			{
				SGUUPDSGUT004 SGUT004 = new SGUUPDSGUT004(dbManager);
				SGUT004.setSTNO((String)requestMap.get("STNO"));
				SGUT004.setAYEAR((String)requestMap.get("AYEAR"));
				SGUT004.setSMS((String)requestMap.get("SMS"));
				if(!(Utility.nullToSpace(requestMap.get("ORIGIN_RACE")).equals("") || Utility.nullToSpace(requestMap.get("ORIGIN_RACE")).equals("0")))
					SGUT004.setPARENTS_RACE(Utility.nullToSpace(requestMap.get("ORIGIN_RACE")));
				if(!(Utility.nullToSpace(requestMap.get("HANDICAP_TYPE")).equals("") || Utility.nullToSpace(requestMap.get("HANDICAP_TYPE")).equals("00")) )
				{
					SGUT004.setHANDICAP_TYPE(Utility.nullToSpace(requestMap.get("HANDICAP_TYPE")));
					SGUT004.setHANDICAP_GRADE(Utility.nullToSpace(requestMap.get("HANDICAP_GRADE")));
				}
				SGUT004.setUPD_USER_ID((String)session.getAttribute("USER_ID"));
				int x = SGUT004.execute();
				System.out.println("ERRORS="+SGUT004.nextError());
				if(x == 1){
					System.out.println("新增SGUT004資料完成");
				}else{
					System.out.println("新增SGUT004資料失敗");
					dbManager.rollback();
				}
			}
		}
		
		//新增新住民和新住民子女至SGUT039
		if(!Utility.checkNull(requestMap.get("STNO"), "").equals(""))
		{
			if(!(Utility.nullToSpace(requestMap.get("NEWNATION")).equals("") || Utility.nullToSpace(requestMap.get("FATHER_NAME")).equals("") || Utility.nullToSpace(requestMap.get("FATHER_ORIGINAL_COUNTRY")).equals("") || !Utility.nullToSpace(requestMap.get("MOTHER_NAME")).equals("") || Utility.nullToSpace(requestMap.get("MOTHER_ORIGINAL_COUNTRY")).equals("")) )
			{
				SGUUPDSGUT039 SGUT039 = new SGUUPDSGUT039(dbManager);
				SGUT039.setSTNO((String)requestMap.get("STNO"));
				SGUT039.setAYEAR((String)requestMap.get("AYEAR"));
				SGUT039.setSMS((String)requestMap.get("SMS"));
				if(!(Utility.nullToSpace(requestMap.get("NEWNATION")).equals("")))
					SGUT039.setNEWNATION(Utility.nullToSpace(requestMap.get("NEWNATION")));
				if(!(Utility.nullToSpace(requestMap.get("FATHER_NAME")).equals("") || Utility.nullToSpace(requestMap.get("FATHER_ORIGINAL_COUNTRY")).equals("") || Utility.nullToSpace(requestMap.get("MOTHER_NAME")).equals("") || Utility.nullToSpace(requestMap.get("MOTHER_ORIGINAL_COUNTRY")).equals("")) )
				{
					SGUT039.setFATHER_NAME(Utility.nullToSpace(requestMap.get("FATHER_NAME")));
					SGUT039.setFATHER_ORIGINAL_COUNTRY(Utility.nullToSpace(requestMap.get("FATHER_ORIGINAL_COUNTRY")));
					SGUT039.setMOTHER_NAME(Utility.nullToSpace(requestMap.get("MOTHER_NAME")));
					SGUT039.setMOTHER_ORIGINAL_COUNTRY(Utility.nullToSpace(requestMap.get("MOTHER_ORIGINAL_COUNTRY")));
				}
				SGUT039.setUPD_USER_ID((String)session.getAttribute("USER_ID"));
				int x = SGUT039.execute();
				System.out.println("ERRORS="+SGUT039.nextError());
				if(x == 1){
					System.out.println("新增SGUT039資料完成");
				}else{
					System.out.println("新增SGUT039資料失敗");
					dbManager.rollback();
				}
			}
		}
        /** Commit Transaction */
        dbManager.commit();

            out.println(DataToJson.successJson());
    }
    catch (Exception ex)
    {
        /** Rollback Transaction */
        dbManager.rollback();

        throw ex;
    }
    finally
    {
        dbManager.close();
    }
}

/** 修改到PK，先刪除再新增 */
public void doModifySpecial(JspWriter out, DBManager dbManager, Hashtable requestMap, HttpSession session) throws Exception
{
    try
    {
        Connection    conn    =    dbManager.getConnection(AUTCONNECT.mapConnect("SOL", session));
		int updateCount = 0;
        /** 查詢條件 */
        String    condition    =    "ASYS        =    '" + Utility.dbStr(requestMap.get("ASYS"))+ "' AND " +
                                    "AYEAR        =    '" + Utility.dbStr(requestMap.get("AYEAR"))+ "' AND " +
                                    "SMS        =    '" + Utility.dbStr(requestMap.get("SMS"))+ "' AND " +
                                    "IDNO        =    '" + Utility.dbStr(requestMap.get("IDNO_OLD"))+ "' AND " +
                                    "BIRTHDATE    =    '" + Utility.dbStr(requestMap.get("BIRTHDATE_OLD"))+ "'";

        /** 處理修改動作 */
		String ASYS=Utility.dbStr(requestMap.get("ASYS"));
		String AYEAR=Utility.dbStr(requestMap.get("AYEAR"));
		String SMS=Utility.dbStr(requestMap.get("SMS"));
		String IDNO=Utility.dbStr(requestMap.get("IDNO"));
		String BIRTHDATE=Utility.dbStr(requestMap.get("BIRTHDATE"));
		String IDNO_OLD=Utility.dbStr(requestMap.get("IDNO_OLD"));
		String BIRTHDATE_OLD=Utility.dbStr(requestMap.get("BIRTHDATE_OLD"));
		String NAME=Utility.dbStr(requestMap.get("NAME"));
		String ENG_NAME=Utility.dbStr(requestMap.get("ENG_NAME"));
        String EDUBKGRD=(Utility.dbStr(requestMap.get("EDUBKGRD"))+Utility.dbStr(requestMap.get("EDUBKGRD1")+Utility.dbStr(requestMap.get("aaa"))));
        String PRE_MAJOR_FACULTY=Utility.dbStr(requestMap.get("PRE_MAJOR_FACULTY"));
        String J_FACULTY_CODE="";
        if(!Utility.checkNull(requestMap.get("PRE_MAJOR_FACULTY"), "").equals("")){
                 J_FACULTY_CODE=PRE_MAJOR_FACULTY.substring(2,4);
                 PRE_MAJOR_FACULTY=PRE_MAJOR_FACULTY.substring(0,2);
        }
        requestMap.remove("EDUBKGRD");
        requestMap.remove("PRE_MAJOR_FACULTY");
        requestMap.put("EDUBKGRD",EDUBKGRD);
        requestMap.put("PRE_MAJOR_FACULTY",PRE_MAJOR_FACULTY);
        requestMap.put("J_FACULTY_CODE",J_FACULTY_CODE);
		
		SOLT003DAO    SOLT003_Q    =    new SOLT003DAO(dbManager, conn);
		DBResult rs1 = SOLT003_Q.query("SELECT * FROM SOLT003 WHERE " + condition);
		
		Hashtable result = new Hashtable();
		while (rs1.next()) 
		{
            /** 將欄位抄一份過去 */
            for (int i = 1; i <= rs1.getColumnCount(); i++)
				result.put(rs1.getColumnName(i), rs1.getString(i));
        }
		
		// SOLU003-基本資料LOG
		SOLU003DAO    SOLU003    =    new SOLU003DAO(dbManager, conn,requestMap,session);
		SOLU003.insert();
		
		SOLT003_Q.delete(condition);
		
		result.remove("ROWSTAMP");
        result.remove("UPD_TIME");
		result.remove("UPD_DATE");
		result.remove("UPD_USER_ID");
		result.put("IDNO", IDNO);
		result.put("BIRTHDATE", BIRTHDATE);
		result.put("EDUBKGRD", EDUBKGRD);
		result.put("PRE_MAJOR_FACULTY", PRE_MAJOR_FACULTY);
		result.put("J_FACULTY_CODE", J_FACULTY_CODE);
		result.put("ASYS", ASYS);
		result.put("AYEAR", AYEAR);
		result.put("SMS", SMS);
		result.put("STTYPE", Utility.dbStr(requestMap.get("STTYPE")));
		result.put("CENTER_CODE", Utility.dbStr(requestMap.get("CENTER_CODE")));
		result.put("NAME", NAME);
		result.put("ENG_NAME", ENG_NAME);
		result.put("SEX", Utility.dbStr(requestMap.get("SEX")));
		result.put("SELF_IDENTITY_SEX", Utility.dbStr(requestMap.get("SELF_IDENTITY_SEX")));
		result.put("VOCATION", Utility.dbStr(requestMap.get("VOCATION")));
		result.put("DMSTADDR_ZIP", Utility.dbStr(requestMap.get("DMSTADDR_ZIP")));
		result.put("DMSTADDR", Utility.dbStr(requestMap.get("DMSTADDR")));
		result.put("CRRSADDR_ZIP", Utility.dbStr(requestMap.get("CRRSADDR_ZIP")));
		result.put("CRRSADDR", Utility.dbStr(requestMap.get("CRRSADDR")));
		result.put("AREACODE_OFFICE", Utility.dbStr(requestMap.get("AREACODE_OFFICE")));
		result.put("TEL_OFFICE", Utility.dbStr(requestMap.get("TEL_OFFICE")));
		result.put("TEL_OFFICE_EXT", Utility.dbStr(requestMap.get("TEL_OFFICE_EXT")));
		result.put("AREACODE_HOME", Utility.dbStr(requestMap.get("AREACODE_HOME")));
		result.put("TEL_HOME", Utility.dbStr(requestMap.get("TEL_HOME")));
		result.put("MOBILE", Utility.dbStr(requestMap.get("MOBILE")));
		result.put("EMAIL", Utility.dbStr(requestMap.get("EMAIL")));
		result.put("MARRIAGE", Utility.dbStr(requestMap.get("MARRIAGE")));
		result.put("EDUBKGRD_GRADE", Utility.dbStr(requestMap.get("EDUBKGRD_GRADE")));
		result.put("TUTOR_CLASS_MK", Utility.dbStr(requestMap.get("TUTOR_CLASS_MK")));
		result.put("GETINFO", Utility.dbStr(requestMap.get("GETINFO")));
		result.put("HANDICAP_TYPE", Utility.dbStr(requestMap.get("HANDICAP_TYPE")));
		result.put("HANDICAP_GRADE", Utility.dbStr(requestMap.get("HANDICAP_GRADE")));
		result.put("ORIGIN_RACE", Utility.dbStr(requestMap.get("ORIGIN_RACE")));
		result.put("HANDICAP_TYPE", Utility.dbStr(requestMap.get("HANDICAP_TYPE")));
		result.put("HANDICAP_TYPE", Utility.dbStr(requestMap.get("HANDICAP_TYPE")));
		result.put("NEWNATION", Utility.dbStr(requestMap.get("NEWNATION")));
		result.put("EDUBKGRD_AYEAR", Utility.dbStr(requestMap.get("EDUBKGRD_AYEAR")));
		result.put("EMRGNCY_EMAIL", Utility.dbStr(requestMap.get("EMRGNCY_EMAIL")));
		result.put("OVERSEA_ADDR", Utility.dbStr(requestMap.get("OVERSEA_ADDR")));
		result.put("OVERSEA_NATION", Utility.dbStr(requestMap.get("OVERSEA_NATION")));
		result.put("OVERSEA_NATION_RMK", Utility.dbStr(requestMap.get("OVERSEA_NATION_RMK")));
		result.put("OVERSEA_REASON", Utility.dbStr(requestMap.get("OVERSEA_REASON")));
		result.put("OVERSEA_REASON_RMK", Utility.dbStr(requestMap.get("OVERSEA_REASON_RMK")));
		result.put("OVERSEA_DOC", Utility.dbStr(requestMap.get("OVERSEA_DOC")));
		result.put("OVERSEA_DOC_RMK", Utility.dbStr(requestMap.get("OVERSEA_DOC_RMK")));
		result.put("OVERSEA_DOC_DATE", Utility.dbStr(requestMap.get("OVERSEA_DOC_DATE")));
		result.put("NEW_RESIDENT_CHD", Utility.dbStr(requestMap.get("NEW_RESIDENT_CHD")));
		result.put("FATHER_NAME", Utility.dbStr(requestMap.get("FATHER_NAME")));
		result.put("FATHER_ORIGINAL_COUNTRY", Utility.dbStr(requestMap.get("FATHER_ORIGINAL_COUNTRY")));
		result.put("MOTHER_NAME", Utility.dbStr(requestMap.get("MOTHER_NAME")));
		result.put("MOTHER_ORIGINAL_COUNTRY", Utility.dbStr(requestMap.get("MOTHER_ORIGINAL_COUNTRY")));		
		
        System.out.println("RESULT="+result.toString());
		
		SOLT003DAO    SOLT003_1    =    new SOLT003DAO(dbManager, conn,result,session);
		SOLT003_1.insert();
		if(!"".equals(Utility.checkNull(requestMap.get("SERNO"), "")))
		{
			String condition2 = "ASYS        =    '" + Utility.dbStr(requestMap.get("ASYS"))+ "' AND " +
                                "AYEAR        =    '" + Utility.dbStr(requestMap.get("AYEAR"))+ "' AND " +
                                "SMS        =    '" + Utility.dbStr(requestMap.get("SMS"))+ "' AND " +
                                "SERNO    =    '" + Utility.dbStr(requestMap.get("SERNO"))+ "'";
			SOLT004DAO    SOLT004    =    new SOLT004DAO(dbManager, conn);
			SOLT004.setNAME(Utility.dbStr(requestMap.get("NAME")));
			SOLT004.update(condition2);
		}
		
				
		SOLT006DAO    SOLT006    =    new SOLT006DAO(dbManager, conn);
		SOLT006DAO    SOLT006_1    =    null;
		DBResult rs3 = SOLT006.query("SELECT * FROM SOLT006 WHERE " + condition);
		Hashtable result3 = null;
		while (rs3.next()) 
		{
            result3 = new Hashtable();
			/** 將欄位抄一份過去 */
            for (int i = 1; i <= rs3.getColumnCount(); i++)
				result3.put(rs3.getColumnName(i), rs3.getString(i));
			result3.remove("IDNO");
			result3.remove("BIRTHDATE");
			result3.put("IDNO", IDNO);
			result3.put("BIRTHDATE", BIRTHDATE);
			SOLT006_1    =    new SOLT006DAO(dbManager, conn,result3,session);
			SOLT006_1.insert();
        }
		SOLT006.delete(condition);
				
		SOLT007DAO    SOLT007    =    new SOLT007DAO(dbManager, conn);
		SOLT007DAO    SOLT007_1 = null;
		DBResult rs4 = SOLT007.query("SELECT * FROM SOLT007 WHERE " + condition);
		Hashtable result4 = null;
		Vector set1 = new Vector();
		while (rs4.next()) 
		{
            result4 = new Hashtable();
			/** 將欄位抄一份過去 */
            for (int i = 1; i <= rs4.getColumnCount(); i++)
				result4.put(rs4.getColumnName(i), rs4.getString(i));
			result4.remove("IDNO");
			result4.remove("BIRTHDATE");
			result4.put("IDNO", IDNO);
			result4.put("BIRTHDATE", BIRTHDATE);
			SOLT007_1    =    new SOLT007DAO(dbManager, conn,result4,session);
			SOLT007_1.insert();
        }
		SOLT007.delete(condition);
		
		if(Utility.checkNull(requestMap.get("CHKSTD"), "").equals("on"))
		{
			SOLT005DAO    SOLT005    =    new SOLT005DAO(dbManager, conn,requestMap,session);
            updateCount    =    SOLT005.delete(condition);
            if(!Utility.nullToSpace(requestMap.get("ASYS")).equals(""))
                SOLT005.setASYS(Utility.dbStr(requestMap.get("ASYS")));
            if(!Utility.nullToSpace(requestMap.get("AYEAR")).equals(""))
                SOLT005.setAYEAR(Utility.dbStr(requestMap.get("AYEAR")));
            if(!Utility.nullToSpace(requestMap.get("SMS")).equals(""))
                SOLT005.setSMS(Utility.dbStr(requestMap.get("SMS")));
            if(!Utility.nullToSpace(requestMap.get("IDNO")).equals(""))
                SOLT005.setIDNO(Utility.dbStr(requestMap.get("IDNO")));
            if(!Utility.nullToSpace(requestMap.get("BIRTHDATE")).equals(""))
                SOLT005.setBIRTHDATE(Utility.dbStr(requestMap.get("BIRTHDATE")));
            if(!Utility.nullToSpace(requestMap.get("SCHOOL_NAME_OLD")).equals(""))
                SOLT005.setSCHOOL_NAME_OLD(Utility.dbStr(requestMap.get("SCHOOL_NAME_OLD")));
            if(!Utility.nullToSpace(requestMap.get("FACULTY_OLD")).equals(""))
                SOLT005.setFACULTY_OLD(Utility.dbStr(requestMap.get("FACULTY_OLD")));
            if(!Utility.nullToSpace(requestMap.get("GRADE_OLD")).equals(""))
                SOLT005.setGRADE_OLD(Utility.dbStr(requestMap.get("GRADE_OLD")));
            if(!Utility.nullToSpace(requestMap.get("STNO_OLD")).equals(""))
                SOLT005.setSTNO_OLD(Utility.dbStr(requestMap.get("STNO_OLD")));

            SOLT005.insert();
        }else{

            SOLT005DAO    SOLT005    =    new SOLT005DAO(dbManager, conn,requestMap,session);
            updateCount    =    SOLT005.delete(condition);

        }
		
		//新增原住民和身心障礙資料至SGUT004
		if(!Utility.checkNull(requestMap.get("STNO"), "").equals(""))
		{
			if(!(Utility.nullToSpace(requestMap.get("ORIGIN_RACE")).equals("") || Utility.nullToSpace(requestMap.get("ORIGIN_RACE")).equals("0")) || !(Utility.nullToSpace(requestMap.get("HANDICAP_TYPE")).equals("") || Utility.nullToSpace(requestMap.get("HANDICAP_TYPE")).equals("00")) )
			{
				SGUUPDSGUT004 SGUT004 = new SGUUPDSGUT004(dbManager);
				SGUT004.setSTNO((String)requestMap.get("STNO"));
				SGUT004.setAYEAR((String)requestMap.get("AYEAR"));
				SGUT004.setSMS((String)requestMap.get("SMS"));
				if(!(Utility.nullToSpace(requestMap.get("ORIGIN_RACE")).equals("") || Utility.nullToSpace(requestMap.get("ORIGIN_RACE")).equals("0")))
					SGUT004.setPARENTS_RACE(Utility.nullToSpace(requestMap.get("ORIGIN_RACE")));
				if(!(Utility.nullToSpace(requestMap.get("HANDICAP_TYPE")).equals("") || Utility.nullToSpace(requestMap.get("HANDICAP_TYPE")).equals("00")) )
				{
					SGUT004.setHANDICAP_TYPE(Utility.nullToSpace(requestMap.get("HANDICAP_TYPE")));
					SGUT004.setHANDICAP_GRADE(Utility.nullToSpace(requestMap.get("HANDICAP_GRADE")));
				}
				SGUT004.setUPD_USER_ID((String)session.getAttribute("USER_ID"));
				int x = SGUT004.execute();
				System.out.println("ERRORS="+SGUT004.nextError());
				if(x == 1){
					System.out.println("新增SGUT004資料完成");
				}else{
					System.out.println("新增SGUT004資料失敗");
					dbManager.rollback();
				}
			}
		}
		
        /** Commit Transaction */
        dbManager.commit();

        out.println(DataToJson.successJson());
    }
    catch (Exception ex)
    {
        /** Rollback Transaction */
        dbManager.rollback();

        throw ex;
    }
    finally
    {
        dbManager.close();
    }
}

private void doPrint(JspWriter out, DBManager dbManager, Hashtable requestMap, HttpSession session) throws Exception
{
    try
    {
        Vector result = new Vector();
        int        pageNo        =    Integer.parseInt(Utility.checkNull(requestMap.get("pageNo"), "1"));
        int        pageSize      =    Integer.parseInt(Utility.checkNull(requestMap.get("pageSize"), "10"));
        Connection    conn       =    dbManager.getConnection(AUTCONNECT.mapConnect("SOL", session));

        SOLT003GATEWAY  Solt01JTrau01  =    new SOLT003GATEWAY(dbManager, conn,pageNo,pageSize);

        result =  Solt01JTrau01.getSolt003Trau001Forprint(requestMap);

        //out.println(DataToJson.vtToJson(Solt01JTrau01.getTotalRowCount(), result));

        // 初始化 rptFile
        RptFile        rptFile    =    new RptFile(session.getId());

        for (int i = 0; i < result.size(); i++)
            rptFile.add(result.get(i));

        if (rptFile.size() == 0)
        {
            out.println("<script>top.close();alert(\"無符合資料可供列印!!\");</script>");
            return;
        }

        // 初始化報表物件
        report        report_    =    new report(dbManager, conn, out, "sol007m_01r1", report.onlineHtmlMode);

        // 靜態變數處理
        Hashtable    ht    =    new Hashtable();
        report_.setDynamicVariable(ht);

        // 開始列印
        report_.genReport(rptFile);

    }
    catch (Exception ex)
    {
        throw ex;
    }
    finally
    {
        dbManager.close();
    }

    /*Connection    conn    =    null;
    DBResult    rs    =    null;

    try
    {
        conn    =    dbManager.getConnection(AUTCONNECT.mapConnect("NOU", session));

        // 參數處理
        StringBuffer    sql        =    new StringBuffer();

        sql.append
        (
            "SELECT SOLT003.IDNO, SOLT003.BIRTHDATE, TRAU001.NAME, SOLT003.EDUBKGRD_GRADE, SOLT003.STTYPE, SOLT003.ASYS, SOLT003.TEL_HOME " +
            "FROM  SOLT003, TRAU001 " +
            "WHERE " +
            "1    =    1 "
        );

        // 勾選列印處理
        if (requestMap.get("PRINTFORM").toString().equals("RESULT"))
        {
            String[]    IDNO        =    Utility.split(requestMap.get("IDNO").toString(), ",");
            String[]    BIRTHDATE    =    Utility.split(requestMap.get("BIRTHDATE").toString(), ",");


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
            if(!Utility.checkNull(requestMap.get("IDNO"), "").equals(""))
                sql.append("AND SOLT003.IDNO    =    '" + Utility.dbStr(requestMap.get("IDNO"))+ "'");
            if(!Utility.checkNull(requestMap.get("BIRTHDATE"), "").equals(""))
                sql.append("AND SOLT003.BIRTHDATE    =    '" + Utility.dbStr(requestMap.get("BIRTHDATE"))+ "'");

        }

        // 取得 DBResult
        rs    =    dbManager.getSimpleResultSet(conn);
        rs.open();
        rs.executeQuery(sql.toString());

        // 初始化 rptFile
        RptFile        rptFile    =    new RptFile(session.getId());

        while (rs.next())
        {
            for (int i = 1; i <= rs.getColumnCount(); i++)
                rptFile.add(rs.getString(i));
        }

        if (rptFile.size() == 0)
        {
            out.println("<script>top.close();alert(\"無符合資料可供列印!!\");</script>");
            return;
        }

        // 初始化報表物件
        report        report_    =    new report(dbManager, conn, out, "sol007m_01r1", report.onlineHtmlMode);

        // 靜態變數處理
        Hashtable    ht    =    new Hashtable();
        report_.setDynamicVariable(ht);

        // 開始列印
        report_.genReport(rptFile);
    }
    catch (Exception ex)
    {
        throw ex;
    }
    finally
    {
        if (conn != null)
            conn.close();
        if (rs != null)
            rs.close();

        rs    =    null;
        conn    =    null;
    }*/
}

/** 修改帶出資料 */
public void doCheckLimit(JspWriter out, DBManager dbManager, Hashtable requestMap, HttpSession session) throws Exception
{
    try
    {
        Hashtable result = new Hashtable();
		String NETWK_REG_SDATE = "";
		String CRRSPND_REG_SDATE = "";
		String VENUE_REG_SDATE = "";
		String startDate = "";
		String endDate = "";
        Connection    conn       =    dbManager.getConnection(AUTCONNECT.mapConnect("SOL", session));
		DBResult	rs	=	null;
		StringBuffer	sql		=	new StringBuffer();
		sql.append("SELECT NETWK_REG_SDATE, CRRSPND_REG_SDATE, VENUE_REG_SDATE FROM SOLT001 ");
		sql.append("WHERE AYEAR='" + Utility.checkNull(requestMap.get("AYEAR"), "") + "' ");
		sql.append("AND SMS='" + Utility.checkNull(requestMap.get("SMS"), "") + "' ");
		sql.append("AND ASYS='" + Utility.checkNull(requestMap.get("ASYS"), "") + "' ");
		rs	=	dbManager.getSimpleResultSet(conn);
		rs.open();
		rs.executeQuery(sql.toString());
		if(rs.next())
		{
			NETWK_REG_SDATE = rs.getString("NETWK_REG_SDATE");
			CRRSPND_REG_SDATE = rs.getString("CRRSPND_REG_SDATE");
			VENUE_REG_SDATE = rs.getString("VENUE_REG_SDATE");
		}
		if(NETWK_REG_SDATE.equals("") || CRRSPND_REG_SDATE.equals("") || VENUE_REG_SDATE.equals(""))
		{
			//三者任一無資料，提示系統參數未設定，且不允許存檔
			result.put("YN", "N");
			out.println(DataToJson.htToJson(result));
		}else{
			result.put("YN", "Y");
			if(Integer.parseInt(NETWK_REG_SDATE) <= Integer.parseInt(CRRSPND_REG_SDATE))
			{
				if(Integer.parseInt(NETWK_REG_SDATE) <= Integer.parseInt(VENUE_REG_SDATE))
					startDate = NETWK_REG_SDATE;
				else
					startDate = VENUE_REG_SDATE;
			}else{
				if(Integer.parseInt(CRRSPND_REG_SDATE) <= Integer.parseInt(VENUE_REG_SDATE))
					startDate = CRRSPND_REG_SDATE;
				else
					startDate = VENUE_REG_SDATE;
			}

			if(Utility.checkNull(requestMap.get("SMS"), "").equals("1"))
				endDate = startDate.substring(0,4)+1 + "1031";
			else
				endDate = String.valueOf(Integer.parseInt(startDate.substring(0,4))+1) + "0331";

			String nowDate = DateUtil.getNowDate();
			if(Integer.parseInt(nowDate) >= Integer.parseInt(startDate) && Integer.parseInt(nowDate) <= Integer.parseInt(endDate))
			{
				//存檔功能不受限制
				result.put("LIMITED", "N");
			}else{
				//存檔功能受限制
				result.put("LIMITED", "Y");
				result.put("ENDDATE", endDate);
			}
	        out.println(DataToJson.htToJson(result));
		}
		
    }catch (Exception ex)
    {
        throw ex;
    }
    finally
    {
        dbManager.close();
    }
}


/** 取得學期基準日 */
public void doEnrollBasedate(JspWriter out, DBManager dbManager, Hashtable requestMap, HttpSession session) throws Exception
{
    Connection	conn	=	null;
	Hashtable ht = new Hashtable();
	try
	{
        conn = dbManager.getConnection(AUTCONNECT.mapConnect("SOL", session));
		//1年齡
		SYST005DAO SYST005 = new SYST005DAO(dbManager,conn);
		SYST005.setResultColumn("ENROLL_BASEDATE");
		SYST005.setAYEAR(requestMap.get("AYEAR").toString());
		SYST005.setSMS(requestMap.get("SMS").toString());
        DBResult rs = SYST005.query();		
		if(rs.next()){
			ht.put("ENROLL_BASEDATE",rs.getString("ENROLL_BASEDATE"));
		}else{
			ht.put("ENROLL_BASEDATE","");
		}
        
		//是否為舊選轉新全
		String STNO = Utility.checkNull(requestMap.get("STNO"), "");
		if(!"".equals(STNO)){
			STUT003DAO STUT003 = new STUT003DAO(dbManager,conn);
			STUT003.setResultColumn(" 1 ");
			STUT003.setWhere(" STNO = '"+STNO+"' AND TRIM(FTSTUD_ENROLL_AYEARSMS) ! = TRIM(ENROLL_AYEARSMS) ");
			rs = STUT003.query();		
			if(rs.next()){
				ht.put("STTYPE_CHECK","OLD");
			}else{
				ht.put("STTYPE_CHECK","NEW");			
			}
		}else{
			//表示還沒取號
			STUT003DAO STUT003 = new STUT003DAO(dbManager,conn);
			STUT003.setResultColumn(" 1 ");
			STUT003.setWhere(" IDNO = '"+requestMap.get("IDNO").toString()+"' AND BIRTHDATE = '"+requestMap.get("BIRTHDATE").toString()+"' AND STTYPE = '2' AND ENROLL_STATUS ='2' ");						
			rs = STUT003.query();		
			if(rs.next()){
				ht.put("STTYPE_CHECK","OLD");
			}else{
				ht.put("STTYPE_CHECK","NEW");			
			}		
		}
		
		
		out.println(DataToJson.htToJson (ht));
	}
	catch (Exception ex)
	{
		throw ex;
	}
	finally
	{
		dbManager.close();
	}
}

/** 取得轉入註記 */
public void doCOMPARED(JspWriter out, DBManager dbManager, Hashtable requestMap, HttpSession session) throws Exception
{
    Connection	conn	=	null;
	Hashtable ht = new Hashtable();
	try
	{
        conn = dbManager.getConnection(AUTCONNECT.mapConnect("SOL", session));
		SOLT001DAO SOL = new SOLT001DAO(dbManager,conn);		
		SOL.setResultColumn("CASE WHEN UPDATE_STU_EDATE < TO_CHAR(SYSDATE,'YYYYMMDD') OR COMPARED = 'Y' THEN 'Y' ELSE 'N' END AS COMPARED ");
		//SOL.setResultColumn("COMPARED");
		SOL.setWhere("AYEAR ='"+requestMap.get("AYEAR").toString()+"' AND SMS='"+requestMap.get("SMS").toString()+"' ");
        DBResult rs = SOL.query();		
		if(rs.next()){
			ht.put("COMPARED",rs.getString("COMPARED"));
		}else{
			ht.put("COMPARED","");
		}        		
		out.println(DataToJson.htToJson (ht));
	}
	catch (Exception ex)
	{
		throw ex;
	}
	finally
	{
		dbManager.close();
	}
}


%>