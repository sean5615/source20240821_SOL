<%/*
----------------------------------------------------------------------------------
File Name		: stu002m_01m1.jsp
Author			: matt
Description		: 維護學籍資料 - 處理邏輯頁面
Modification Log	:

Vers		Date       	By            	Notes
----------	----------	--------------	------------------------------------------
0.0.1		096/01/24	matt			Code Generate Create
0.0.2		096/11/06	poto			加入sgut004 query
0.0.3		096/11/06	poto			加入儲存 架構調整
0.0.4		097/04/07	lin				修正族別及身心障礙註記的取得
0.0.5		097/04/09	lin				學籍資料的「報名身份別」、「學籍狀態」及「中心別」改抓 STUT004 當學年期的資料
----------------------------------------------------------------------------------
*/%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="MS950"%>
<%@ include file="/utility/header.jsp"%>
<%@ include file="/utility/modulepageinit.jsp"%>
<%@page import="com.nou.stu.dao.*, com.nou.*, com.nou.sgu.dao.*, com.nou.sys.dao.*"%>

<%!
/** 處理查詢 Grid 資料 */
public void doQuery(JspWriter out, DBManager dbManager, Hashtable requestMap, HttpSession session) throws Exception
{
	Connection	conn	=	null;
	DBResult	rs	=	null;
	try
	{
		conn	=	dbManager.getConnection(AUTCONNECT.mapConnect("STU", session));

		int		pageNo		=	Integer.parseInt(Utility.checkNull(requestMap.get("pageNo"), "1"));
		int		pageSize	=	Integer.parseInt(Utility.checkNull(requestMap.get("pageSize"), "10"));

		com.nou.stu.dao.STUT002GATEWAY s02Gateway = new com.nou.stu.dao.STUT002GATEWAY(dbManager, conn, pageNo, pageSize);
		Hashtable ht = new Hashtable();
		ht.put("ASYS", session.getAttribute("ASYS"));
		ht.put("IDNO", com.acer.util.Utility.nullToSpace(requestMap.get("IDNO")));
		ht.put("STNO", com.acer.util.Utility.nullToSpace(requestMap.get("STNO")));
		ht.put("NAME", com.acer.util.Utility.nullToSpace(com.acer.util.Utility.replace((String)requestMap.get("NAME"),"*","_")));		
		ht.put("CENTER_CODE", com.acer.util.Utility.nullToSpace(requestMap.get("CENTER_CODE")));
		ht.put("STU002M", "111");		
        Vector vc = s02Gateway.getStuData(ht);
        out.println(com.acer.ajax.DataToJson.vtToJson(s02Gateway.getTotalRowCount(), vc));
	}
	catch (Exception ex)
	{
		throw ex;
	}
	finally
	{
		if (rs != null)
			rs.close();
		if (conn != null)
			conn.close();

		rs	=	null;
		conn	=	null;
	}
}

/** 修改帶出資料 */
public void doQueryEdit(JspWriter out, DBManager dbManager, Hashtable requestMap, HttpSession session) throws Exception
{
	Connection	conn	=	null;
	DBResult	rs	=	null;
	DBResult	rs1	=	null;
	DBResult	rs2	=	null;
	DBResult	rs3	=	null;
	Hashtable rowHt = null;
	Vector vt =new Vector();
	try
	{
		conn	=	dbManager.getConnection(AUTCONNECT.mapConnect("STU", session));

        com.nou.stu.dao.STUT002DAO s02Dao = new com.nou.stu.dao.STUT002DAO(dbManager, conn);
        s02Dao.setResultColumn(
		"NEWNATION,SPECIAL_MK,IDNO, BIRTHDATE, NAME, ENG_NAME, ALIAS, SEX, SELF_IDENTITY_SEX, BIRTHPLACE, PASSPORT_NO, VOCATION, EDUBKGRD_GRADE, AREACODE_OFFICE, "+
		"TEL_OFFICE, TEL_OFFICE_EXT, AREACODE_HOME, TEL_HOME, FAX_AREACODE, FAX_TEL, MOBILE, MARRIAGE, "+
		"DMSTADDR, DMSTADDR_ZIP, CRRSADDR_ZIP, CRRSADDR, EMAIL, SPECIAL_MK, EMRGNCY_TEL, "+
		"EMRGNCY_RELATION, EMRGNCY_NAME, UPD_MK, UPD_RMK, UPD_DATE, UPD_TIME, UPD_USER_ID, "+
		"ROWSTAMP,decode(NATIONCODE,null,'000',NATIONCODE) AS NATIONCODE ,FAX_TEL,PASSPORT_NO,RESIDENCE_DATE,ROWSTAMP ");
        s02Dao.setIDNO(Utility.dbStr(requestMap.get("IDNO")));
        s02Dao.setBIRTHDATE(Utility.dbStr(requestMap.get("BIRTHDATE")));		
        rs = s02Dao.query();		
		if(rs.next()) {
			rowHt = new Hashtable();
			/** 將欄位抄一份過去 */		
			for (int i = 1; i <= rs.getColumnCount(); i++)
				rowHt.put(rs.getColumnName(i), rs.getString(i));			
		}
		//v0.0.4
		// 族別 --------------------------------------------- 開始
		
		//族別註記
		SGUT004DAO	SGUT004DAO	=	new SGUT004DAO(dbManager, conn);
		SGUT004DAO.setResultColumn("PARENTS_RACE,AUDIT_MK");
		SGUT004DAO.setSTNO(Utility.dbStr(requestMap.get("STNO")));
		SGUT004DAO.setHAND_NATIVE("1");
		
		rs1	=	SGUT004DAO.query();
		
		if (rs1.next())
		{
			//族別中文
			SYST001DAO	SYST001DAO	=	new SYST001DAO(dbManager, conn);
			SYST001DAO.setResultColumn("CODE_NAME");
			SYST001DAO.setKIND("ORIGIN_RACE");
			SYST001DAO.setCODE(rs1.getString("PARENTS_RACE"));
			
			rs2	=	SYST001DAO.query();
			if (rs2.next()){
				if("2".equals(rs1.getString("AUDIT_MK")))			
					rowHt.put("PARENTS_RACE", rs2.getString("CODE_NAME") + "-審核通過");
				else if("1".equals(rs1.getString("AUDIT_MK")))			
					rowHt.put("PARENTS_RACE", rs2.getString("CODE_NAME") + "-審核不通過");
				else
					rowHt.put("PARENTS_RACE", rs2.getString("CODE_NAME") + "-未審核");
			}else
				rowHt.put("PARENTS_RACE", "");
		}
		else
		{
			rowHt.put("PARENTS_RACE", "");
		}
		
		// 族別 --------------------------------------------- 結束
		
		
		
		//v0.0.4
		// 身心障礙類別 ------------------------------------- 開始
		
		//身心障礙註記
		SGUT004DAO	=	new SGUT004DAO(dbManager, conn);
		SGUT004DAO.setResultColumn("HANDICAP_TYPE, HANDICAP_GRADE, AUDIT_MK");
		SGUT004DAO.setSTNO(Utility.dbStr(requestMap.get("STNO")));
		SGUT004DAO.setHAND_NATIVE("2");
		
		rs1	=	SGUT004DAO.query();
		String HANDICAP_TYPE = "";
		String HANDICAP_GRADE = "";
		if (rs1.next())
		{
			//身心障礙中文
			SYST001DAO	SYST001DAO	=	new SYST001DAO(dbManager, conn);
			SYST001DAO.setResultColumn("CODE_NAME");
			SYST001DAO.setKIND("HANDICAP_TYPE");
			SYST001DAO.setCODE(rs1.getString("HANDICAP_TYPE"));
			
			rs2	=	SYST001DAO.query();
			
			if (rs2.next())
			{
				HANDICAP_TYPE = rs2.getString("CODE_NAME");
				rs2.close();
				SYST001DAO	=	new SYST001DAO(dbManager, conn);
				SYST001DAO.setResultColumn("CODE_NAME");
				SYST001DAO.setKIND("HANDICAP_GRADE");
				SYST001DAO.setCODE(rs1.getString("HANDICAP_GRADE"));
				rs2	=	SYST001DAO.query();
				if (rs2.next())
				{
					HANDICAP_GRADE = "(" + rs2.getString("CODE_NAME") + ")";
					rs2.close();
					if("2".equals(rs1.getString("AUDIT_MK")))			
						rowHt.put("HANDICAP_TYPE", HANDICAP_GRADE + HANDICAP_TYPE + "-審核通過");
					else if("1".equals(rs1.getString("AUDIT_MK")))			
						rowHt.put("HANDICAP_TYPE", HANDICAP_GRADE + HANDICAP_TYPE + "-審核不通過");
					else
						rowHt.put("HANDICAP_TYPE", HANDICAP_GRADE + HANDICAP_TYPE + "-未審核");
				}else{
					rowHt.put("HANDICAP_TYPE", HANDICAP_TYPE);
					rs2.close();
				}
			}
		}
		else
		{
			rowHt.put("HANDICAP_TYPE", HANDICAP_TYPE);
			rs1.close();
		}
		
		// 身心障礙類別 ------------------------------------- 結束	
		
		//v0.0.4
		// 新住民子女 ------------------------------------- 開始
		
		//新住民子女
		SGUT039DAO	SGUT039DAO	=	new SGUT039DAO(dbManager, conn);
		SGUT039DAO.setResultColumn("FATHER_NAME, FATHER_ORIGINAL_COUNTRY,MOTHER_NAME, MOTHER_ORIGINAL_COUNTRY, AUDIT_MK");
		SGUT039DAO.setSTNO(Utility.dbStr(requestMap.get("STNO")));
		SGUT039DAO.setNEW_RESIDENT("2");
		
		rs1	=	SGUT039DAO.query();
		String NEW_RESIDENT_CHD = "";
		String FATHER_ORIGINAL_COUNTRY = "";
		String MOTHER_ORIGINAL_COUNTRY = "";
		if (rs1.next())
		{
			//父親中文國別
			SYST001DAO	SYST001DAO	=	new SYST001DAO(dbManager, conn);
			SYST001DAO.setResultColumn("CODE_NAME");
			SYST001DAO.setKIND("NATIONCODE");
			SYST001DAO.setCODE(rs1.getString("FATHER_ORIGINAL_COUNTRY"));
			
			rs2	=	SYST001DAO.query();
			
			if (rs2.next())
			{
				FATHER_ORIGINAL_COUNTRY = rs1.getString("FATHER_NAME") + "(" +rs2.getString("CODE_NAME") + ")";
				rs2.close();
				//母親中文國別
				SYST001DAO	=	new SYST001DAO(dbManager, conn);
				SYST001DAO.setResultColumn("CODE_NAME");
				SYST001DAO.setKIND("NATIONCODE");
				SYST001DAO.setCODE(rs1.getString("MOTHER_ORIGINAL_COUNTRY"));
				rs2	=	SYST001DAO.query();
				if (rs2.next())
				{
					MOTHER_ORIGINAL_COUNTRY = rs1.getString("MOTHER_NAME") +  "(" + rs2.getString("CODE_NAME") + ")";
					rs2.close();
					if("2".equals(rs1.getString("AUDIT_MK")))			
						rowHt.put("NEW_RESIDENT_CHD", FATHER_ORIGINAL_COUNTRY + MOTHER_ORIGINAL_COUNTRY + "-審核通過");
					else if("1".equals(rs1.getString("AUDIT_MK")))			
						rowHt.put("NEW_RESIDENT_CHD", FATHER_ORIGINAL_COUNTRY + MOTHER_ORIGINAL_COUNTRY + "-審核不通過");
					else
						rowHt.put("NEW_RESIDENT_CHD", FATHER_ORIGINAL_COUNTRY + MOTHER_ORIGINAL_COUNTRY + "-未審核");
				}else{
					rowHt.put("NEW_RESIDENT_CHD", FATHER_ORIGINAL_COUNTRY + MOTHER_ORIGINAL_COUNTRY);
					rs2.close();
				}
			}
		}
		else
		{
			rowHt.put("NEW_RESIDENT_CHD", FATHER_ORIGINAL_COUNTRY + MOTHER_ORIGINAL_COUNTRY);
			rs1.close();
		}		
		
		// 新住民子女------------------------------------- 結束
		
		vt.add(rowHt);		
        out.println(DataToJson.vtToJson(vt));        
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
		if (rs1 != null)
			rs1.close();
		rs1=	null;
		rs=	null;
		conn	=	null;
	}
}

public void doQueryEdit2(JspWriter out, DBManager dbManager, Hashtable requestMap, HttpSession session) throws Exception
{
	try
	{
		Connection	conn	=	dbManager.getConnection(AUTCONNECT.mapConnect("NOU", session));
		
		int		pageNo		=	Integer.parseInt(Utility.checkNull(requestMap.get("pageNo"), "1"));
		int		pageSize	=	Integer.parseInt(Utility.checkNull(requestMap.get("pageSize"), "10"));
		
		Vector	vtData		=	new	Vector();			
		
		STUT002GATEWAY stut = new STUT002GATEWAY(dbManager,conn);
		stut.getStuData2(requestMap,vtData);
		
		
		
		// 取得當學年期 ------------------------------------------- 開始
		
		String	AYEAR	=	"";
		String	SMS		=	"";
		
		com.nou.sys.SYSGETSMSDATA	sysgetsmsdata	=	new com.nou.sys.SYSGETSMSDATA(dbManager);		
		sysgetsmsdata.setSYS_DATE(DateUtil.getNowDate());
		sysgetsmsdata.setSMS_TYPE("1");
		sysgetsmsdata.setCONN_TYPE("1");
		int	rtn	=	sysgetsmsdata.execute();
		
		if (rtn == 1)
		{
			AYEAR	=	sysgetsmsdata.getAYEAR();
			SMS		=	sysgetsmsdata.getSMS();
		}
		
		// 取得當學年期 ------------------------------------------- 結束
		
		
		
		// 取得當學年期之歷程資料 --------------------------------- 開始
		
		String	STTYPE			=	"";
		String	CENTER_CODE		=	"";
		String	ENROLL_STATUS	=	"";
		String	J_FACULTY_CODE	=	"";
		
		STUT004DAO	STUT004DAO	=	new STUT004DAO(dbManager, conn);
		STUT004DAO.setResultColumn("STTYPE, CENTER_CODE, ENROLL_STATUS, J_FACULTY_CODE, PRE_MAJOR_FACULTY");
		STUT004DAO.setAYEAR(AYEAR);
		STUT004DAO.setSMS(SMS);
		STUT004DAO.setSTNO(Utility.checkNull(requestMap.get("STNO"), ""));
		
		DBResult	rs1	=	STUT004DAO.query();
		
		if (rs1.next())
		{
			//身份別中文
			SYST001DAO	SYST001DAO	=	new SYST001DAO(dbManager, conn);
			SYST001DAO.setResultColumn("CODE_NAME");
			SYST001DAO.setKIND("STTYPE");
			SYST001DAO.setCODE(rs1.getString("STTYPE"));
			
			DBResult	rs2	=	SYST001DAO.query();
			
			if (rs2.next())
				STTYPE	=	rs2.getString("CODE_NAME");
			
			
			//中心別中文
			SYST001DAO	=	new SYST001DAO(dbManager, conn);
			SYST001DAO.setResultColumn("CODE_NAME");
			SYST001DAO.setKIND("CENTER_CODE");
			SYST001DAO.setCODE(rs1.getString("CENTER_CODE"));
			
			rs2	=	SYST001DAO.query();
			
			if (rs2.next())
				CENTER_CODE	=	rs2.getString("CODE_NAME");
			
			
			//學籍狀態中文
			SYST001DAO	=	new SYST001DAO(dbManager, conn);
			SYST001DAO.setResultColumn("CODE_NAME");
			SYST001DAO.setKIND("ENROLL_STATUS");
			SYST001DAO.setCODE(rs1.getString("ENROLL_STATUS"));
			
			rs2	=	SYST001DAO.query();
			
			if (rs2.next())
				ENROLL_STATUS	=	rs2.getString("CODE_NAME");
			System.out.println("J_FACULTY_CODE="+rs1.getString("J_FACULTY_CODE"));
			//空專科組別中文
			if(!Utility.checkNull(rs1.getString("J_FACULTY_CODE"), "").equals("") && !Utility.checkNull(rs1.getString("PRE_MAJOR_FACULTY"), "").equals("") && requestMap.get("ASYS").toString().equals("2"))
			{
				StringBuffer sql = new StringBuffer();
				sql.append(" select TOTAL_CRS_NAME J_FACULTY_CODE from syst008 where FACULTY_CODE='" + rs1.getString("PRE_MAJOR_FACULTY") + "' AND TOTAL_CRS_NO='" + rs1.getString("J_FACULTY_CODE") + "'");
				rs2.open();
				rs2.executeQuery(sql.toString());
				if (rs2.next())
					J_FACULTY_CODE	=	rs2.getString("J_FACULTY_CODE");
			}
		}
		System.out.println("J_FACULTY_CODE="+J_FACULTY_CODE);
		
		// 取得當學年期之歷程資料 --------------------------------- 結束
		
		DBResult	rs2	= null;
		//歷程內無中心別、身份別、學籍狀態時，改撈STUT003的中心別帶入
		if(CENTER_CODE.equals("") || STTYPE.equals("") || ENROLL_STATUS.equals("") || (J_FACULTY_CODE.equals("") && requestMap.get("ASYS").toString().equals("2")))
		{
			String STNO = requestMap.get("STNO").toString();
			StringBuffer sql = new StringBuffer();
			sql.append("select (select CENTER_NAME from syst002 b where b.CENTER_CODE=a.CENTER_CODE) CENTER_CODE, " +
						"(select c.CODE_NAME from syst001 c where c.KIND='STTYPE' AND c.CODE=a.STTYPE) STTYPE, " + 
						"(select d.CODE_NAME from syst001 d where d.KIND='ENROLL_STATUS' AND d.CODE=a.ENROLL_STATUS) ENROLL_STATUS ");
			if(requestMap.get("ASYS").toString().equals("2"))
				sql.append(",(select e.TOTAL_CRS_NAME from syst008 e where e.FACULTY_CODE=a.PRE_MAJOR_FACULTY AND e.TOTAL_CRS_NO=a.J_FACULTY_CODE) J_FACULTY_CODE ");
			sql.append("from stut003 a where a.stno='" + STNO + "' ");

			rs2	=	dbManager.getSimpleResultSet(conn);
			rs2.open();
			rs2.executeQuery(sql.toString());
			if(rs2.next())
			{
				if(CENTER_CODE.equals(""))
					CENTER_CODE = rs2.getString("CENTER_CODE");
				if(STTYPE.equals(""))
					STTYPE = rs2.getString("STTYPE");
				if(ENROLL_STATUS.equals(""))
					ENROLL_STATUS = rs2.getString("ENROLL_STATUS");
				if(J_FACULTY_CODE.equals("") && requestMap.get("ASYS").toString().equals("2"))
					J_FACULTY_CODE = rs2.getString("J_FACULTY_CODE");
			}
		}
		
		
		
		Hashtable	ht	=	(Hashtable)vtData.get(0);
		ht.put("STTYPE",			STTYPE);
		ht.put("CENTER_CODE",		CENTER_CODE);
		ht.put("ENROLL_STATUS",		ENROLL_STATUS);
		ht.put("J_FACULTY_CODE",		J_FACULTY_CODE);
		
		/*查詢STUT003 SPECIAL_STTYPE_TYPE 
		若有值且不等於1(監獄生) 則需多查STUT031的起始學年期
		2008/07/30 by barry*/
		StringBuffer	sql		=	new StringBuffer();
		sql.append("SELECT SPECIAL_STTYPE_TYPE,INFORMAL_STUTYPE,ACCUM_REPL_CRD, ACCUM_REDUCE_CRD, ACCUM_PASS_CRD FROM STUT003 WHERE STNO= '" + Utility.dbStr(requestMap.get("STNO")) + "' ");
		rs2	=	dbManager.getSimpleResultSet(conn);
		rs2.open();
		rs2.executeQuery(sql.toString());
		String SPECIAL_STTYPE_TYPE = "";
		String SPECIAL_AYEAR = "";
		String SPECIAL_SMS = "";
		String INFORMAL_STUTYPE = "";
		String ACCUM_REPL_CRD = "0";
		String ACCUM_REDUCE_CRD = "0";
		String ACCUM_PASS_CRD = "0";
		if(rs2.next()){
			SPECIAL_STTYPE_TYPE = rs2.getString("SPECIAL_STTYPE_TYPE");
			INFORMAL_STUTYPE = rs2.getString("INFORMAL_STUTYPE");
			//by poto 加入 累積學分數	
			ACCUM_REPL_CRD = rs2.getString("ACCUM_REPL_CRD");
			ACCUM_REDUCE_CRD = rs2.getString("ACCUM_REDUCE_CRD");
			ACCUM_PASS_CRD = rs2.getString("ACCUM_PASS_CRD");
		}	
		if(!SPECIAL_STTYPE_TYPE.equals(""))
		{
			if(!SPECIAL_STTYPE_TYPE.equals("1"))
			{
				sql		=	new StringBuffer();
				sql.append("SELECT AYEAR, SMS FROM STUT031 WHERE STNO= '" + Utility.dbStr(requestMap.get("STNO")) + "' ");
				rs2	=	dbManager.getSimpleResultSet(conn);
				rs2.open();
				rs2.executeQuery(sql.toString());
				if(rs2.next())
				{
					SPECIAL_AYEAR = rs2.getString("AYEAR");
					SPECIAL_SMS = rs2.getString("SMS");
				}
			}
		}
		
		ht.put("SPECIAL_STTYPE_TYPE", SPECIAL_STTYPE_TYPE);
		ht.put("SPECIAL_AYEAR", SPECIAL_AYEAR);
		ht.put("SPECIAL_SMS", SPECIAL_SMS);
		ht.put("INFORMAL_STUTYPE", INFORMAL_STUTYPE);
		//by poto 加入 累積學分數
		ht.put("ACCUM_REPL_CRD", ACCUM_REPL_CRD);
		ht.put("ACCUM_REDUCE_CRD", ACCUM_REDUCE_CRD);
		ht.put("ACCUM_PASS_CRD", ACCUM_PASS_CRD);
		System.out.println((String)ht.get("GRAD_MAJOR_FACULTY")+"XX");
		
		vtData	=	new Vector();
		vtData.add(ht);
		
		
		/** 需額外處理範例, 請參考 Sample.txt */ 
		out.println(DataToJson.vtToJson (stut.getTotalRowCount(), vtData));
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

public void doQueryEdit3(JspWriter out, DBManager dbManager, Hashtable requestMap, HttpSession session) throws Exception
{
	try
	{
		Connection	conn	=	dbManager.getConnection(AUTCONNECT.mapConnect("NOU", session));
		int		pageNo		=	Integer.parseInt(Utility.checkNull(requestMap.get("pageNo"), "1"));
		int		pageSize	=	Integer.parseInt(Utility.checkNull(requestMap.get("pageSize"), "10"));
		Vector	vtData		=	new	Vector();	
		String ayear = "";
		String sms = "";
		String nowDate = com.acer.util.DateUtil.getNowDate();
		com.nou.sys.SYSGETSMSDATA nowSMS = new com.nou.sys.SYSGETSMSDATA(dbManager);
		nowSMS.setSYS_DATE(nowDate);
		nowSMS.setSMS_TYPE("1");
		nowSMS.setCONN_TYPE("111");
		int i = nowSMS.execute();
		if(i == 1)
		{
			ayear = nowSMS.getAYEAR();
			sms = nowSMS.getSMS();
		}
		requestMap.put("AYEAR", ayear);
		requestMap.put("SMS", sms);
		STUT002GATEWAY stut = new STUT002GATEWAY(dbManager,conn,pageNo,pageSize);
	    stut.getStuData3(requestMap,vtData);	
		/** 需額外處理範例, 請參考 Sample.txt */ 
		out.println(DataToJson.vtToJson (stut.getTotalRowCount(), vtData));		
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

/** 修改存檔 */
public void doModify(JspWriter out, DBManager dbManager, Hashtable requestMap, HttpSession session) throws Exception
{
	Connection	conn	=	null;
	DBResult rs = null;
	try
	{
		conn	=	dbManager.getConnection(AUTCONNECT.mapConnect("STU", session));
		rs = dbManager.getResultSet(conn);		

		/** 修改條件 */
		/*
		String	condition	=	"IDNO	=	'" + Utility.dbStr(requestMap.get("IDNO"))+ "' AND " +
								"BIRTHDATE	=	'" + Utility.dbStr(requestMap.get("BIRTHDATE"))+ "' AND " +
								"ROWSTAMP	=	'" + Utility.dbStr(requestMap.get("ROWSTAMP")) + "' ";
		*/
		String	condition	=	"IDNO	=	'" + Utility.dbStr(requestMap.get("IDNO"))+ "' AND " +
								"BIRTHDATE	=	'" + Utility.dbStr(requestMap.get("BIRTHDATE"))+ "' ";
								
		/** 處理修改動作 */
		DBAccess	dba	=	dbManager.getDBAccess(conn);
		rs.open();
		try {
			rs.executeQuery("SELECT * FROM STUT002 WHERE " + condition);
			if (rs.next()) {
				dba.setTableName("STUU002");
				for (int i=1;i<=rs.getColumnCount();i++) {
					dba.setColumn(rs.getColumnName(i),rs.getString(i));					
				}
				//by poto 2008/11/17 要寫異動檔
				dba.setColumn("UPD_RMK","STU002M_,異動學生基本資料");
				dba.setColumn("UPD_DATE",	DateUtil.getNowDate());
				dba.setColumn("UPD_TIME",	DateUtil.getNowTimeS());
				dba.setColumn("UPD_USER_ID",	(String)session.getAttribute("USER_ID"));
				dba.setColumn("ROWSTAMP",	DateUtil.getNowTimeMs());
				dba.insert();
			}
		} finally {
			if (rs != null) rs.close();
		}

		/** Set Table */
		dba.setTableName("STUT002");		
		/** Set Column */
		//dba.setColumn("NAME",		Utility.dbStr(requestMap.get("NAME")));
		dba.setColumn("ENG_NAME",		Utility.dbStr(requestMap.get("ENG_NAME")));
		dba.setColumn("ALIAS",			Utility.dbStr(requestMap.get("ALIAS")));
		dba.setColumn("SEX",			Utility.dbStr(requestMap.get("SEX")));
		dba.setColumn("SELF_IDENTITY_SEX",	Utility.dbStr(requestMap.get("SELF_IDENTITY_SEX")));
		dba.setColumn("MARRIAGE",		Utility.dbStr(requestMap.get("MARRIAGE")));
		dba.setColumn("VOCATION",		Utility.dbStr(requestMap.get("VOCATION")));
		dba.setColumn("EDUBKGRD_GRADE",		Utility.dbStr(requestMap.get("EDUBKGRD_GRADE")));
		dba.setColumn("EMAIL",			Utility.dbStr(requestMap.get("EMAIL")));
		dba.setColumn("DMSTADDR_ZIP",		Utility.dbStr(requestMap.get("DMSTADDR_ZIP")));
		dba.setColumn("DMSTADDR",		Utility.dbStr(requestMap.get("DMSTADDR")));
		dba.setColumn("CRRSADDR_ZIP",		Utility.dbStr(requestMap.get("CRRSADDR_ZIP")));
		dba.setColumn("CRRSADDR",		Utility.dbStr(requestMap.get("CRRSADDR")));
		dba.setColumn("AREACODE_OFFICE",		Utility.dbStr(requestMap.get("AREACODE_OFFICE")));
		dba.setColumn("TEL_OFFICE",		Utility.dbStr(requestMap.get("TEL_OFFICE")));
		dba.setColumn("TEL_OFFICE_EXT",		Utility.dbStr(requestMap.get("TEL_OFFICE_EXT")));
		dba.setColumn("AREACODE_HOME",		Utility.dbStr(requestMap.get("AREACODE_HOME")));
		dba.setColumn("TEL_HOME",		Utility.dbStr(requestMap.get("TEL_HOME")));
		dba.setColumn("MOBILE",			Utility.dbStr(requestMap.get("MOBILE")));
		dba.setColumn("EMRGNCY_NAME",		Utility.dbStr(requestMap.get("EMRGNCY_NAME")));
		dba.setColumn("EMRGNCY_TEL",		Utility.dbStr(requestMap.get("EMRGNCY_TEL")));
		dba.setColumn("EMRGNCY_RELATION",	Utility.dbStr(requestMap.get("EMRGNCY_RELATION")));
		
		dba.setColumn("NATIONCODE",	Utility.dbStr(requestMap.get("NATIONCODE")));
        dba.setColumn("RESIDENCE_DATE",	Utility.dbStr(requestMap.get("RESIDENCE_DATE")));
		dba.setColumn("PASSPORT_NO",	Utility.dbStr(requestMap.get("PASSPORT_NO")));
		dba.setColumn("FAX_TEL",	Utility.dbStr(requestMap.get("FAX_TEL")));
		dba.setColumn("UPD_RMK","STU002M_,異動學生基本資料");
		dba.setColumn("UPD_DATE",	DateUtil.getNowDate());
		dba.setColumn("UPD_TIME",	DateUtil.getNowTimeS());
		dba.setColumn("UPD_USER_ID",	(String)session.getAttribute("USER_ID"));
		dba.setColumn("ROWSTAMP",	DateUtil.getNowTimeMs());
        
        dba.setColumn("NEWNATION",	Utility.dbStr(requestMap.get("NEWNATION")));
        dba.setColumn("SPECIAL_MK",	Utility.dbStr(requestMap.get("SPECIAL_MK")));
		/** Start Update */
		int	updateCount	=	dba.update(condition);
		
		String ayearSms1 = com.acer.util.Utility.nullToSpace(requestMap.get("STOP_PRVLG_SAYEARSMS"));
		String ayearSms2 = com.acer.util.Utility.nullToSpace(requestMap.get("STOP_PRVLG_EAYEARSMS"));
		
		//停權起迄學年期(期間內的各個學年期都要在歷程STUT004中加一筆紀錄)--START  2008/06/03 by barry
		if(!com.acer.util.Utility.nullToSpace(requestMap.get("STOP_PRVLG_SAYEARSMS")).equals("") && !com.acer.util.Utility.nullToSpace(requestMap.get("STOP_PRVLG_EAYEARSMS")).equals(""))
		{
			
			int sms1 = 9;
			int sms2 = 9;
			String ayear1 = "";
			String ayear2 = "";
			
			if(ayearSms1.substring(3).equals("3"))
				sms1 = 0;
			else
				sms1 = Integer.parseInt(ayearSms1.substring(3));
			if(ayearSms2.substring(3).equals("3"))
				sms2 = 0;
			else
				sms2 = Integer.parseInt(ayearSms2.substring(3));
			
			ayear1 = ayearSms1.substring(0,3);
			ayear2 = ayearSms2.substring(0,3);		
				
			com.nou.stu.bo.STUCAREER sa = null;
			for(int x = Integer.parseInt(ayear1); x <= Integer.parseInt(ayear2); x++)
			{
				if(x == Integer.parseInt(ayear1))
				{
					if(x == Integer.parseInt(ayear2))
					{
						for(int y = sms1; y <= sms2; y++)
						{
							sa = new com.nou.stu.bo.STUCAREER(dbManager);
							if(String.valueOf(x).length()==2)
								sa.setAYEAR("0"+String.valueOf(x));
							else
								sa.setAYEAR(String.valueOf(x));
							if(y == 0)
								sa.setSMS(String.valueOf(3));
							else
								sa.setSMS(String.valueOf(y));
							sa.setSTNO(requestMap.get("STNO").toString());
							sa.setENROLL_STATUS("6");
							sa.setUSER_ID((String)session.getAttribute("USER_ID"));
							sa.execute();
						}
					}else{
						for(int y = sms1; y <= 2; y++)
						{
							sa = new com.nou.stu.bo.STUCAREER(dbManager);
							if(String.valueOf(x).length()==2)
								sa.setAYEAR("0"+String.valueOf(x));
							else
								sa.setAYEAR(String.valueOf(x));
							if(y == 0)
								sa.setSMS(String.valueOf(3));
							else
								sa.setSMS(String.valueOf(y));
							sa.setSTNO(requestMap.get("STNO").toString());
							sa.setENROLL_STATUS("6");
							sa.setUSER_ID((String)session.getAttribute("USER_ID"));
							sa.execute();
						}
					}
				}else{
					if(x == Integer.parseInt(ayear2))
					{
						for(int y = 0; y <= sms2; y++)
						{
							sa = new com.nou.stu.bo.STUCAREER(dbManager);
							if(String.valueOf(x).length()==2)
								sa.setAYEAR("0"+String.valueOf(x));
							else
								sa.setAYEAR(String.valueOf(x));
							if(y == 0)
								sa.setSMS(String.valueOf(3));
							else
								sa.setSMS(String.valueOf(y));
							sa.setSTNO(requestMap.get("STNO").toString());
							sa.setENROLL_STATUS("6");
							sa.setUSER_ID((String)session.getAttribute("USER_ID"));
							sa.execute();
						}
					}else{
						for(int y = 0; y <= 2; y++)
						{
							sa = new com.nou.stu.bo.STUCAREER(dbManager);
							if(String.valueOf(x).length()==2)
								sa.setAYEAR("0"+String.valueOf(x));
							else
								sa.setAYEAR(String.valueOf(x));
							if(y == 0)
								sa.setSMS(String.valueOf(3));
							else
								sa.setSMS(String.valueOf(y));
							sa.setSTNO(requestMap.get("STNO").toString());
							sa.setENROLL_STATUS("6");
							sa.setUSER_ID((String)session.getAttribute("USER_ID"));
							sa.execute();
						}
					}
				}
			}
		//停權起迄學年期(期間內的各個學年期都要在歷程STUT004中加一筆紀錄)--END  2008/06/03 by barry
		}else{
		//取消停權起迄學年期(期間內的各個學年期都要在歷程STUT004中更新ENROLL_STATUS="")--START  2008/06/03 by barry
			conn	=	dbManager.getConnection(AUTCONNECT.mapConnect("NOU", session));
			StringBuffer	sql		=	new StringBuffer();
			sql.append("select ASYS,STOP_PRVLG_SAYEARSMS, STOP_PRVLG_EAYEARSMS, ENROLL_STATUS from stut003 where stno='"+Utility.dbStr(requestMap.get("STNO"))+"' ");
			DBResult	rs2	=	dbManager.getSimpleResultSet(conn);
			rs2.open();
			rs2.executeQuery(sql.toString());
			// String ayearSms1 = "";
			// String ayearSms2 = "";
			int sms1 = 9;
			int sms2 = 9;						
			String ayear1 = "";
			String ayear2 = "";
			String ENROLL_STATUS = "";
			
			if(rs2.next())
			{				
				ayearSms1 = rs2.getString("STOP_PRVLG_SAYEARSMS");
				ayearSms2 = rs2.getString("STOP_PRVLG_EAYEARSMS");
				ENROLL_STATUS = rs2.getString("ENROLL_STATUS");
			}
			if(!ayearSms1.equals("") && !ayearSms2.equals(""))
			{
				if(ayearSms1.substring(3).equals("3"))
					sms1 = 0;
				else
					sms1 = Integer.parseInt(ayearSms1.substring(3));
				if(ayearSms2.substring(3).equals("3"))
					sms2 = 0;
				else
					sms2 = Integer.parseInt(ayearSms2.substring(3));
				ayear1 = ayearSms1.substring(0,3);
				ayear2 = ayearSms2.substring(0,3);
								
				com.nou.stu.bo.STUCAREER sa = null;
				for(int x = Integer.parseInt(ayear1); x <= Integer.parseInt(ayear2); x++)
				{
					if(x == Integer.parseInt(ayear1))
					{
						if(x == Integer.parseInt(ayear2))
						{
							for(int y = sms1; y <= sms2; y++)
							{
								sa = new com.nou.stu.bo.STUCAREER(dbManager);
								if(String.valueOf(x).length()==2)
									sa.setAYEAR("0"+String.valueOf(x));
								else
									sa.setAYEAR(String.valueOf(x));
								if(y == 0)
									sa.setSMS(String.valueOf(3));
								else
									sa.setSMS(String.valueOf(y));
								sa.setSTNO(requestMap.get("STNO").toString());
								sa.setENROLL_STATUS(ENROLL_STATUS);
								sa.setUSER_ID((String)session.getAttribute("USER_ID"));
								sa.execute();
							}
						}else{
							for(int y = sms1; y <= 2; y++)
							{
								sa = new com.nou.stu.bo.STUCAREER(dbManager);
								if(String.valueOf(x).length()==2)
									sa.setAYEAR("0"+String.valueOf(x));
								else
									sa.setAYEAR(String.valueOf(x));
								if(y == 0)
									sa.setSMS(String.valueOf(3));
								else
									sa.setSMS(String.valueOf(y));
								sa.setSTNO(requestMap.get("STNO").toString());
								sa.setENROLL_STATUS(ENROLL_STATUS);
								sa.setUSER_ID((String)session.getAttribute("USER_ID"));
								sa.execute();
							}
						}
					}else{
						if(x == Integer.parseInt(ayear2))
						{
							for(int y = 0; y <= sms2; y++)
							{
								sa = new com.nou.stu.bo.STUCAREER(dbManager);
								if(String.valueOf(x).length()==2)
									sa.setAYEAR("0"+String.valueOf(x));
								else
									sa.setAYEAR(String.valueOf(x));
								if(y == 0)
									sa.setSMS(String.valueOf(3));
								else
									sa.setSMS(String.valueOf(y));
								sa.setSTNO(requestMap.get("STNO").toString());
								sa.setENROLL_STATUS(ENROLL_STATUS);
								sa.setUSER_ID((String)session.getAttribute("USER_ID"));
								sa.execute();
							}
						}else{
							for(int y = 0; y <= 2; y++)
							{
								sa = new com.nou.stu.bo.STUCAREER(dbManager);
								if(String.valueOf(x).length()==2)
									sa.setAYEAR("0"+String.valueOf(x));
								else
									sa.setAYEAR(String.valueOf(x));
								if(y == 0)
									sa.setSMS(String.valueOf(3));
								else
									sa.setSMS(String.valueOf(y));
								sa.setSTNO(requestMap.get("STNO").toString());
								sa.setENROLL_STATUS(ENROLL_STATUS);
								sa.setUSER_ID((String)session.getAttribute("USER_ID"));
								sa.execute();
							}
						}
					}
				}
			}
		}
		//取消停權起迄學年期(期間內的各個學年期都要在歷程STUT004中更新ENROLL_STATUS="")--END  2008/06/03 by barry
		//by poto補stuu003 log //2007/11/17		
		/** 處理修改動作 */
		dba	=	dbManager.getDBAccess(conn);
		rs.open();
		try {
			rs.executeQuery("SELECT * FROM STUT003 WHERE STNO ='"+Utility.dbStr(requestMap.get("STNO"))+"'");
			if (rs.next()) {
				dba.setTableName("STUU003");
				for (int i=1;i<=rs.getColumnCount();i++) {
					dba.setColumn(rs.getColumnName(i),rs.getString(i));					
				}
				//by poto 2008/11/17 要寫異動檔
				dba.setColumn("UPD_RMK","STU002M_,異動學生基本資料");
				dba.setColumn("UPD_DATE",	DateUtil.getNowDate());
				dba.setColumn("UPD_TIME",	DateUtil.getNowTimeS());
				dba.setColumn("UPD_USER_ID",	(String)session.getAttribute("USER_ID"));
				dba.setColumn("ROWSTAMP",	DateUtil.getNowTimeMs());
				dba.insert();
			}
		} finally {
			if (rs != null) rs.close();
		}
		
		//by poto
		//2007/11/6
		//2008/09/25 
		STUT003DAO SS= new STUT003DAO(dbManager,conn,(String)session.getAttribute("USER_ID"));
		if(Utility.dbStr(requestMap.get("STNO")).length()==9){
			// 2008/09/25 避免空專生存檔 把空值存入 stut003
			if(Utility.dbStr(requestMap.get("PRE_MAJOR_FACULTY"))==null||"".equals(Utility.dbStr(requestMap.get("PRE_MAJOR_FACULTY")))){
				SS.setPRE_MAJOR_FACULTY("00");
			}else{
				SS.setPRE_MAJOR_FACULTY(Utility.dbStr(requestMap.get("PRE_MAJOR_FACULTY")));
			}
		}
		SS.setSTOP_PRVLG_SAYEARSMS(Utility.dbStr(requestMap.get("STOP_PRVLG_SAYEARSMS")));
		SS.setSTOP_PRVLG_EAYEARSMS(Utility.dbStr(requestMap.get("STOP_PRVLG_EAYEARSMS")));
		SS.setSPECIAL_STTYPE_TYPE(Utility.dbStr(requestMap.get("SPECIAL_STTYPE_TYPE")));
		SS.setINFORMAL_STUTYPE(Utility.dbStr(requestMap.get("INFORMAL_STUTYPE")));
		SS.setEDUBKGRD(Utility.dbStr(requestMap.get("EDUBKGRD")));
		SS.setEDUBKGRD_AYEAR(Utility.dbStr(requestMap.get("EDUBKGRD_AYEAR")));
		SS.setEDUBKGRD_GRADE(Utility.dbStr(requestMap.get("EDUBKGRD_GRADE_STUT003")));
		SS.update(" STNO ='"+Utility.dbStr(requestMap.get("STNO"))+"' ");
		
		
		String SPECIAL_STTYPE_TYPE = Utility.checkNull(requestMap.get("SPECIAL_STTYPE_TYPE"), "");
		
		STUT031DAO STUT031 = new STUT031DAO(dbManager,conn,(String)session.getAttribute("USER_ID"));
		if(!SPECIAL_STTYPE_TYPE.equals(""))
		{
			if(SPECIAL_STTYPE_TYPE.equals("1"))
			{
				STUT031.delete(" STNO = '" + Utility.dbStr(requestMap.get("STNO")) + "' ");
			}else{
				STUT031.setAYEAR(Utility.dbStr(requestMap.get("SPECIAL_AYEAR")));
				STUT031.setSMS(Utility.dbStr(requestMap.get("SPECIAL_SMS")));
				STUT031.setSPCLASS_TYPE(SPECIAL_STTYPE_TYPE);
				STUT031.setSTNO(Utility.dbStr(requestMap.get("STNO")));
				try{
					STUT031.insert();
				}catch (Exception ex){
					STUT031.update(" STNO ='"+Utility.dbStr(requestMap.get("STNO"))+"' ");				
				}
			}
		}else{
			STUT031.delete(" STNO = '" + Utility.dbStr(requestMap.get("STNO")) + "' ");
		}
		
		/** Commit Transaction */
		dbManager.commit();

		/* === LoadingBar === */
		LoadingStatus.setStatus(session.getId(), 60, "(S)STUT002 資料儲存完畢", LoadingStatus.success);

		if (updateCount == 0)
			out.println(DataToJson.faileJson("此筆資料已被異動過, <br>請重新查詢修改!!"));
		else
			out.println(DataToJson.successJson());
	}
	catch (Exception ex)
	{
		/* === LoadingBar === */
		LoadingStatus.setStatus(session.getId(), 60, "(S)STUT002 資料儲存失敗", LoadingStatus.success);

		/** Rollback Transaction */
		dbManager.rollback();

		throw ex;
	}
	finally
	{
		if (conn != null)
			conn.close();
		conn	=	null;
	}

}

%>