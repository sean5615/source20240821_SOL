<%/*
----------------------------------------------------------------------------------
File Name        : sol006m_01m1.jsp
Author            : 曾國昭
Description        : SOL006M_登錄報名審查結果 - 處理邏輯頁面
Modification Log    :

Vers        Date           By                Notes
--------------    --------------    --------------    ----------------------------------
0.0.1        096/01/25    曾國昭        Code Generate Create
----------------------------------------------------------------------------------
*/%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="MS950"%>
<%@ include file="/utility/header.jsp"%>
<%@ include file="/utility/modulepageinit.jsp"%>
<%@ page import="com.nou.sol.dao.SOLT006GATEWAY"%>
<%@ page import="java.util.Vector"%>
<%@ page import="com.nou.sol.dao.*"%>
<%@ page import="com.nou.stu.dao.*"%>
<%@ page import="com.nou.stu.STUADDDATA"%>
<%@ page import="com.nou.pcs.dao.PCST004DAO"%>
<%@ page import="com.nou.sol.bo.SOLGETSTNO"%>
<%@ page import="com.nou.aut.bo.AUTADDUSER"%>
<%@ page import="com.nou.aut.bo.AUTSTOPAC"%>
<%@ page import="com.nou.sgu.bo.*"%>
<%@ page import="com.nou.reg.dao.REGT005DAO"%>
<%@ page import="com.acer.db.DBManager"%>
<%@ page import="com.nou.pub.bo.PubAddStu"%>
<%@ page import="com.nou.stu.bo.STUDISDBMAJOR"%>
<%@page import="com.nou.pcs.dao.PCST018DAO"%>
<%@page import="com.nou.sol.signup.tool.Permision"%>

<%!
/** 處理查詢 Grid 資料 */
public void doQuery(JspWriter out, DBManager dbManager, Hashtable requestMap, HttpSession session) throws Exception
{
    try
    {
        int        pageNo        =    Integer.parseInt(Utility.checkNull(requestMap.get("pageNo"), "1"));
        int        pageSize    =    Integer.parseInt(Utility.checkNull(requestMap.get("pageSize"), "10"));
        Connection conn    =    dbManager.getConnection(AUTCONNECT.mapConnect("SOL", session));

        Vector result = new Vector();
        SOLT006GATEWAY sol03Jsol06 = new SOLT006GATEWAY(dbManager,conn,pageNo,pageSize);

        result = sol03Jsol06.getSolt003Solt006ForUse1(requestMap);  // 僅會有1頁的資料

        sol03Jsol06 = new SOLT006GATEWAY(dbManager,conn);
        Vector allResult = sol03Jsol06.getSolt003Solt006ForUse1(requestMap); // 所有的資料
        // 在不影響gateway的情況下,因此在這將所有的身分證字號+生日放在容器內
        Vector willAuditStus = new Vector();
        for(int i=0; i<allResult.size(); i++){
        	Hashtable content = (Hashtable)allResult.get(i);
        	willAuditStus.add(content.get("IDNO").toString()+"-"+content.get("BIRTHDATE").toString());        	
        }
        session.setAttribute("WILL_AUDIT_STUS", willAuditStus);
        

        out.println(DataToJson.vtToJson(sol03Jsol06.getTotalRowCount(), result));

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

/** 檢查是否為雙主修生*/
public void doSOLCK1(JspWriter out, DBManager dbManager, Hashtable requestMap, HttpSession session) throws Exception
{
    Connection	conn	=	null;
	try
	{
		StringBuffer sql = new StringBuffer();
		String IDNO = (String)requestMap.get("IDNO");
		String BIRTHDATE = (String)requestMap.get("BIRTHDATE");
        String rtn = "1";
        conn = dbManager.getConnection(AUTCONNECT.mapConnect("SOL", session));
		//先查有無學號
		sql.append(" SELECT STNO ,STOP_PRVLG_SAYEARSMS,STOP_PRVLG_EAYEARSMS,ENROLL_STATUS,DBMAJOR_MK,ACCUM_PASS_CRD,STTYPE,OTHER_REG_MK FROM nou.STUT003 WHERE 0=0 ");
        sql.append(" AND IDNO = '").append(IDNO).append("'");
        sql.append(" AND BIRTHDATE = '").append(BIRTHDATE).append("'");
        sql.append(" AND ENROLL_STATUS = '2' ");
		sql.append(" AND ASYS = '1'");
		sql.append(" ORDER BY STNO DESC");
		DBResult rs = dbManager.getSimpleResultSet(conn);
        rs.open();
        rs.executeQuery(sql.toString());
		if(rs.next())
		{
			sql.delete(0, sql.length());
			sql.append("SELECT AYEAR, STNO, APP_GRAD_TYPE FROM GRAT003 WHERE ");
	        sql.append(" IDNO = '").append(IDNO).append("'");
			sql.append(" AND STNO = '").append(rs.getString("STNO")).append("'");
	        sql.append(" ORDER BY AYEAR DESC");
			rs = dbManager.getSimpleResultSet(conn);
	        rs.open();
	        rs.executeQuery(sql.toString());
	        if(rs.next())
	        {
	            if("04".equals(rs.getString("APP_GRAD_TYPE")))
				{
					sql.delete(0, sql.length());
					sql.append("SELECT DISDBMAJOR_AUDIT FROM STUT032 WHERE ");
					sql.append("STNO = '").append(rs.getString("STNO")).append("' ");
					sql.append("AND DISDBMAJOR_AUDIT = 'Y' ");
					rs = dbManager.getSimpleResultSet(conn);
					rs.open();
					rs.executeQuery(sql.toString());
					if(!rs.next())
						rtn =  "2";
				}
	        }
		}


		out.println(DataToJson.successJson(rtn));
	}
	catch (Exception ex)
	{
		throw ex;
	}
	finally
	{
		if (conn != null)
			conn.close();
		conn	=	null;
	}

}

/** 修改帶出資料 */
public void doQueryEdit(JspWriter out, DBManager dbManager, Hashtable requestMap, HttpSession session) throws Exception
{
    try
    {
        int        pageNo        =    Integer.parseInt(Utility.checkNull(requestMap.get("pageNo"), "1"));
        int        pageSize    =    Integer.parseInt(Utility.checkNull(requestMap.get("pageSize"), "10"));
        Connection conn    =    dbManager.getConnection(AUTCONNECT.mapConnect("SOL", session));

        // 判斷是否經由存檔後帶出下一筆資料的方式
        if(!Utility.nullToSpace(requestMap.get("NEXT_STU_DATA")).equals("")){
        	requestMap.remove("NAME");
        	requestMap.remove("REG_MANNER");
        	requestMap.remove("AUDIT_RESULT");
        	requestMap.remove("TOTAL_RESULT");
        	requestMap.remove("CENTER_CODE");
        	requestMap.remove("PAYMENT_STATUS");

        	requestMap.put("IDNO", Utility.split(requestMap.get("NEXT_STU_DATA").toString(), "-")[0]);
        	requestMap.put("BIRTHDATE", Utility.split(requestMap.get("NEXT_STU_DATA").toString(), "-")[1]);
        }

        SOLT006GATEWAY sol03Jsol06 = new SOLT006GATEWAY(dbManager,conn,pageNo,pageSize);
        Vector result = sol03Jsol06.getSolt003Solt006ForUse1(requestMap);

        PhraseInfo    info    =    new PhraseInfo();

        info.add("SEX", "SEX");

        out.println(DataToJson.vtToJson (result, info));

    }
    catch (Exception ex)
    {
    	ex.printStackTrace();
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
    String STNO=""; //學號
    String paymentStatus = Utility.nullToSpace(requestMap.get("PAYMENT_STATUS")); // 繳費狀態
	String specialStudent = Utility.checkNull(requestMap.get("SPECIAL_STUDENT_TMP"), "");
	//by poto 加入選課判斷		
    boolean regCheck = false;
	
	Connection conn =  dbManager.getConnection(AUTCONNECT.mapConnect("SOL", session));
	 
	SOLT003DAO solt003 = new SOLT003DAO(dbManager, conn);
	solt003.setResultColumn("*");
	solt003.setIDNO((String)requestMap.get("IDNO"));
	solt003.setBIRTHDATE((String)requestMap.get("BIRTHDATE"));
	solt003.setAYEAR((String)requestMap.get("AYEAR"));
	solt003.setSMS((String)requestMap.get("SMS"));
	solt003.setASYS((String)requestMap.get("ASYS"));
	DBResult rs3 = solt003.query();
	rs3.next();
	Hashtable rowHt = new Hashtable();
	/** 將欄位抄一份過去 */
	for (int i = 1; i <= rs3.getColumnCount(); i++){
		rowHt.put(rs3.getColumnName(i), rs3.getString(i));
	}	
	rs3.close();
	
	int x = 5;              //判斷新增資料至學籍是否成功
	int z = 0;				//是否使用舊學號的後續處理(使用新學號：0；使用舊學號：1)
	
	
    //======================================================================
	String sql_1 =  "SELECT count(1) NUM FROM STUT003 WHERE 0=0 " +
					"AND IDNO = '" + requestMap.get("IDNO").toString() + "' " +
					"AND BIRTHDATE = '" + requestMap.get("BIRTHDATE").toString() + "' " +
					"AND ASYS = '1' " +
					"AND STTYPE = '1' " +
					"AND ENROLL_STATUS = '2'  ";
	String sql_2 =  "SELECT STNO FROM STUT003 WHERE 0=0 " +
					"AND IDNO = '" + requestMap.get("IDNO").toString() + "' " +
					"AND BIRTHDATE = '" + requestMap.get("BIRTHDATE").toString() + "' " +
					"AND ASYS = '1' " +				
					"AND STTYPE = '2' AND ENROLL_STATUS = '2' ORDER BY STNO DESC";
					
	// 判斷是否要繳費...
	String npaymentBar = requestMap.get("NPAYMENT_BAR").toString(); // 有值則表示免繳費視為已通過
	String beforeNpaymentBar = requestMap.get("BEFORE_NPAYMENT_BAR").toString();
	// case 1.npaymentBar有值則表示免繳費視為已通過
	// case 2.npaymentBar無值但beforeNpaymentBar有值表示未繳<==這種狀況不取學號
	// case 3.npaymentBar無值但beforeNpaymentBar無值還需看paymentStatus>1  才可取學號    
	boolean isPayment = !npaymentBar.equals("")||(npaymentBar.equals("")&&beforeNpaymentBar.equals("")&&!(paymentStatus.equals("1")||paymentStatus.equals(""))); // 免繳費原因如有輸入則表示已繳費
	// 按登入者身分判斷決定結果,只要試通過或是待補件都算通過
	boolean isAudit = isAudit(session,requestMap);
	
    int Success=0;
	String NUM = "";
	// 通過且有繳費才可取得學號  
    //if((Utility.checkNull(requestMap.get("AUDIT_RESULT"), "").equals("0") || Utility.checkNull(requestMap.get("TOTAL_RESULT"), "").equals("0"))&&isPayment){
    if(isAudit&&isPayment){
        Success=0;
        if(Utility.nullToSpace(requestMap.get("STNO")).equals("")){
            //取得學號，舊選轉新全須使用舊學號
            if(requestMap.get("ASYS").equals("1")){
				DBResult rs5 = dbManager.getSimpleResultSet(conn);
			    rs5.open();
			    rs5.executeQuery(sql_1);
				if(rs5.next()){
					NUM = rs5.getString("NUM");
				}	
				if(NUM.equals("0"))
				{
					rs5.executeQuery(sql_2);
					if(rs5.next())
					{
						STNO = rs5.getString("STNO");
						z = 1;
					}
				}
				rs5.close();
			}
			// 空專強迫取得新學號  2008.11.27  north
			if(STNO.equals("")||requestMap.get("ASYS").equals("2"))
			{				
	            SOLGETSTNO sysSTNO = new SOLGETSTNO(dbManager);
	            sysSTNO.setASYS(Utility.dbStr(requestMap.get("ASYS")));
	            sysSTNO.setAYEAR(Utility.dbStr(requestMap.get("AYEAR")));
	            sysSTNO.setSMS(Utility.dbStr(requestMap.get("SMS")));
	            sysSTNO.setCENTER_CODE(Utility.dbStr(requestMap.get("CENTER_CODE")));
	            sysSTNO.execute();
	            STNO = sysSTNO.getSTNO();
				z = 0;
			}
			
        }
        
        if(!checkRegt005(dbManager,conn,Utility.dbStr(requestMap.get("AYEAR")),Utility.dbStr(requestMap.get("SMS")),Utility.dbStr(requestMap.get("STNO")))){
			requestMap.put("ENROLL_STATUS", "1");
			regCheck = true;
        }		
    }
    else{
        Success=1;		
    }
    
    
    try
    {
        requestMap.put("KEYIN_EXER", (String)session.getAttribute("USER_ID"));
        requestMap.put("KEYIN_DATE", DateUtil.getNowDate());

        int totalupdata=0;
        int solt006updateCount=0;
        int solt007updateCount=0;
        int solt003updateCount=0;
        int solt009updateCount=0;
		int pcst004updateCount=0;



        // 修改條件
        String    condition    =    "ASYS         =    '" + Utility.dbStr(requestMap.get("ASYS"))+ "' AND " +
                                    "AYEAR         =    '" + Utility.dbStr(requestMap.get("AYEAR"))+ "' AND " +
                                    "SMS         =    '" + Utility.dbStr(requestMap.get("SMS"))+ "' AND " +
                                    "IDNO         =    '" + Utility.dbStr(requestMap.get("IDNO"))+ "' AND " +
                                    "BIRTHDATE    =    '" + Utility.dbStr(requestMap.get("BIRTHDATE"))+ "' " ;

        /** 處理修改動作solt006 */
        SOLT006DAO    SOLT006    =    new SOLT006DAO(dbManager, conn, requestMap, session);
        solt006updateCount       =    SOLT006.update(condition);

        /** 處理修改動作solt007 */
        SOLT007DAO    SOLT007    =    new SOLT007DAO(dbManager,conn);
        SOLT007.setPAYMENT_STATUS(Utility.dbStr(requestMap.get("PAYMENT_STATUS")));
        if(Utility.checkNull(requestMap.get("CHKPAYMENT"), "").equals("on")){
	        SOLT007.setNPAYMENT_BAR(Utility.dbStr(requestMap.get("NPAYMENT_BAR")));
			SOLT007.setPAYMENT_DATE(DateUtil.getNowDate());
        }else{
            SOLT007.setNPAYMENT_BAR(Utility.dbStr(requestMap.get("")));
            SOLT007.setPAYMENT_DATE("");
        }
        String    condition1    =     "ASYS         =    '" + Utility.dbStr(requestMap.get("ASYS"))+ "' AND " +
                                      "AYEAR         =    '" + Utility.dbStr(requestMap.get("AYEAR"))+ "' AND " +
                                      "SMS         =    '" + Utility.dbStr(requestMap.get("SMS"))+ "' AND " +
                                      "IDNO         =    '" + Utility.dbStr(requestMap.get("IDNO"))+ "' AND " +
                                      "WRITEOFF_NO         =    '" + Utility.dbStr(requestMap.get("WRITEOFF_NO"))+ "' AND " +
                                      "BIRTHDATE    =    '" + Utility.dbStr(requestMap.get("BIRTHDATE"))+ "' " ;
        solt007updateCount       =    SOLT007.update(condition1);
        if(solt006updateCount == 0 && solt007updateCount == 0)
            totalupdata = 0;
        else
            totalupdata = 1;


        if(Success==0){

            if("".equals(Utility.nullToSpace(requestMap.get("STNO")))){
				/** 處理修改動作 solt003新增學號*/
                SOLT003DAO    SOLT003    =    new SOLT003DAO(dbManager, conn);
                SOLT003.setSTNO(STNO);
                solt003updateCount       =    SOLT003.update(condition);
				requestMap.put("STNO", STNO);				
				PCST004DAO PCST004 = new PCST004DAO(dbManager, conn);
				PCST004.setSTNO(STNO);
				pcst004updateCount = PCST004.update("WRITEOFF_NO='" + Utility.dbStr(requestMap.get("WRITEOFF_NO"))+ "' ");
            }

			STUT003DAO	STUT003_1 = new STUT003DAO(dbManager, conn);
			STUT003_1.setResultColumn(" COUNT(*) NUM ");
			STUT003_1.setSTNO(Utility.dbStr(requestMap.get("STNO")));
			DBResult rs1 = STUT003_1.query();
			NUM = "";

			if(rs1.next())
			{					

				//by poto 新增學籍資料
			    x = insertDataToStu_1(dbManager,session, rowHt,Utility.nullToSpace(requestMap.get("STNO")),z,regCheck);			
				if(x == 1 && z == 0){
					System.out.println("新增學籍資料完成");
					x = 5;
					AUTADDUSER autAdd = new AUTADDUSER(dbManager);
					autAdd.setUSER_ID(STNO);
					autAdd.setASYS((String)rowHt.get("ASYS"));
					autAdd.setDEP_CODE((String)rowHt.get("CENTER_CODE"));
					autAdd.setID_TYPE("1");
					autAdd.setUSER_NM((String)rowHt.get("NAME"));
					autAdd.setUSER_IDNO((String)rowHt.get("IDNO"));
					autAdd.setUPD_USER_ID((String)session.getAttribute("USER_ID"));
					autAdd.setINSERT_PRESENT_STATUS("1");
					x = autAdd.execute();
					if(x == 1){
						System.out.println("新增權限資料完成");
						x = 5;
						//將學生資料轉入PUB 2008/05/12 by barry 2008/05/12 by barry
						PubAddStu pubAdd = new PubAddStu(dbManager, conn, session);
						pubAdd.setBIRTHDATE((String)rowHt.get("BIRTHDATE"));
						pubAdd.setIDNO((String)rowHt.get("IDNO"));
						pubAdd.setSTNO(STNO);
						x = pubAdd.execute();
						if(x == 1)
						{
							System.out.println("新增出版資料完成");
							//放棄雙主修才執行此段	2008/08/29	by barry
							if("2".equals(specialStudent))
							{
								x = 5;
								STUDISDBMAJOR stuDis = new STUDISDBMAJOR(dbManager);
								stuDis.setAYEAR((String)requestMap.get("AYEAR"));
								stuDis.setSMS((String)requestMap.get("SMS"));
								stuDis.setSTNO(STNO);
								stuDis.setIDNO((String)rowHt.get("IDNO"));
								stuDis.setUSER_ID((String)session.getAttribute("USER_ID"));
								x = stuDis.execute();
								if(x == 1)
								{
									System.out.println("放棄雙主修處理完成");
								}else{
									System.out.println("放棄雙主修處理失敗");
									dbManager.rollback();
								}
							}
						}else{
							System.out.println("新增出版資料失敗");
							dbManager.rollback();
						}
					}else{
						System.out.println("新增權限資料失敗");
					}
				}else if(x == 1 && z == 1){
					System.out.println("使用舊學號，已有權限資料，不作新增的動作。");
				}else{
					out.println(DataToJson.faileJson("新增學號重複，請重新存檔!"));
					System.out.println("新增學籍資料失敗");
					return;
				}
				//新增原住民和身心障礙資料至SGUT004
				if(!(Utility.nullToSpace(rowHt.get("ORIGIN_RACE")).equals("") || Utility.nullToSpace(rowHt.get("HANDICAP_TYPE")).equals("") || Utility.nullToSpace(rowHt.get("HANDICAP_GRADE")).equals("")))
				{
					SGUUPDSGUT004 SGUT004 = new SGUUPDSGUT004(dbManager);
					SGUT004.setSTNO(STNO);
					SGUT004.setAYEAR((String)rowHt.get("AYEAR"));
					SGUT004.setSMS((String)rowHt.get("SMS"));
					SGUT004.setPARENTS_RACE(Utility.nullToSpace(rowHt.get("ORIGIN_RACE")));
					SGUT004.setHANDICAP_TYPE(Utility.nullToSpace(rowHt.get("HANDICAP_TYPE")));
					SGUT004.setHANDICAP_GRADE(Utility.nullToSpace(rowHt.get("HANDICAP_GRADE")));
					SGUT004.setUPD_USER_ID((String)session.getAttribute("USER_ID"));
					x = SGUT004.execute();
					System.out.println("ERRORS="+SGUT004.nextError());
					if(x == 1){
						System.out.println("新增SGUT004資料完成");
					}else{
						System.out.println("新增SGUT004資料失敗");
					}
				}
				
				//新增原住民和身心障礙資料至SGUT039
				if(!(Utility.nullToSpace(rowHt.get("NEWNATION")).equals("") || Utility.nullToSpace(rowHt.get("FATHER_NAME")).equals("") || Utility.nullToSpace(rowHt.get("FATHER_ORIGINAL_COUNTRY")).equals("")))
				{
					SGUUPDSGUT039 SGUT039 = new SGUUPDSGUT039(dbManager);
					SGUT039.setSTNO(STNO);
					SGUT039.setAYEAR((String)rowHt.get("AYEAR"));
					SGUT039.setSMS((String)rowHt.get("SMS"));
					SGUT039.setNEWNATION(Utility.nullToSpace(rowHt.get("NEWNATION")));
					SGUT039.setFATHER_NAME(Utility.nullToSpace(rowHt.get("FATHER_NAME")));
					SGUT039.setFATHER_ORIGINAL_COUNTRY(Utility.nullToSpace(rowHt.get("FATHER_ORIGINAL_COUNTRY")));
					SGUT039.setMOTHER_NAME(Utility.nullToSpace(rowHt.get("MOTHER_NAME")));
					SGUT039.setMOTHER_ORIGINAL_COUNTRY(Utility.nullToSpace(rowHt.get("MOTHER_ORIGINAL_COUNTRY")));
					SGUT039.setUPD_USER_ID((String)session.getAttribute("USER_ID"));
					x = SGUT039.execute();
					System.out.println("ERRORS="+SGUT039.nextError());
					if(x == 1){
						System.out.println("新增SGUT039資料完成");
					}else{
						System.out.println("新增SGUT039資料失敗");
					}
				}
					 
			}

			if(x==1){
	            SOLT009DAO    SOLT009    =    new SOLT009DAO(dbManager, conn);
	            SOLT009.setSTNO(STNO);
	            String    condition2    =    "AYEAR         =    '" + Utility.dbStr(requestMap.get("AYEAR"))+ "' AND " +
	                                         "SMS         =    '" + Utility.dbStr(requestMap.get("SMS"))+ "' AND " +
	                                         "IDNO         =    '" + Utility.dbStr(requestMap.get("IDNO"))+ "' ";
	            solt009updateCount       =    SOLT009.update(condition2);
			}
        }else if(Success==1){
        
			if(!"".equals(Utility.nullToSpace(requestMap.get("STNO")))&&!isAudit_1(session,requestMap))
			{
				/** 處理修改動作 審查不通過，移除solt003學號*/
				SOLT003DAO    SOLT003    =    new SOLT003DAO(dbManager, conn);
	            SOLT003.setSTNO("");
	            solt003updateCount       =    SOLT003.update(condition);
				/** 處理修改動作 審查不通過，移除pcst004學號*/
				PCST004DAO PCST004 = new PCST004DAO(dbManager, conn);
				PCST004.setSTNO("");
				pcst004updateCount = PCST004.update("WRITEOFF_NO='" + Utility.dbStr(requestMap.get("WRITEOFF_NO"))+ "' ");
				/** 處理修改動作 審查不通過，移除solt009學號*/
				SOLT009DAO    SOLT009    =    new SOLT009DAO(dbManager, conn);
	            SOLT009.setSTNO("");
	            String    condition2    =    "AYEAR         =    '" + Utility.dbStr(requestMap.get("AYEAR"))+ "' AND " +
	                                         "SMS         =    '" + Utility.dbStr(requestMap.get("SMS"))+ "' AND " +
	                                         "IDNO         =    '" + Utility.dbStr(requestMap.get("IDNO"))+ "' ";
	            solt009updateCount       =    SOLT009.update(condition2);
				/** 處理修改動作 審查不通過，註記取消STUT003學籍資料*/
				String ENROLL_AYEARSMS = "";
				String FTSTUD_ENROLL_AYEARSMS = "";
				STUT003DAO	STUT003_1 = new STUT003DAO(dbManager, conn);
				String condition3 = "STNO = '" + Utility.dbStr(requestMap.get("STNO")) + "' ";
				STUT003_1.setResultColumn("*");
				STUT003_1.setSTNO(requestMap.get("STNO").toString());
				DBResult rs4 = STUT003_1.query();
				rs4.next();
				rowHt = new Hashtable();
				/** 將欄位抄一份過去 */
				for (int i = 1; i <= rs4.getColumnCount(); i++){
					rowHt.put(rs4.getColumnName(i), rs4.getString(i));
					FTSTUD_ENROLL_AYEARSMS = rs4.getString("FTSTUD_ENROLL_AYEARSMS");					
					ENROLL_AYEARSMS = rs4.getString("ENROLL_AYEARSMS");					
				}	
				rs4.close();
				STUU003DAO STUU003 = new STUU003DAO(dbManager, conn, rowHt, session);
				STUU003.insert();
				String ayearSms = requestMap.get("AYEAR").toString()+requestMap.get("SMS").toString();
				//一般取消學籍作業
				if(ayearSms.equals(ENROLL_AYEARSMS))
				{
					STUT003DAO	STUT003_2 = new STUT003DAO(dbManager, conn);
					STUT003_2.setUPD_RMK("SOL006M,修改學籍資料,修改");
					STUT003_2.setENROLL_STATUS("7");
					STUT003_2.update(condition3);

					AUTSTOPAC autStop = new AUTSTOPAC(dbManager);
					autStop.setUSER_ID(Utility.dbStr(requestMap.get("STNO")) );
					autStop.setPRESENT_STATUS("4");
					autStop.execute();

				//舊選轉新全取消學籍作業
				}else if(!ayearSms.equals(ENROLL_AYEARSMS)&&ayearSms.equals(FTSTUD_ENROLL_AYEARSMS)){
					STUT003DAO	STUT003_2 = new STUT003DAO(dbManager, conn);
					STUT003_2.setUPD_RMK("SOL006M,修改學籍資料,修改");
					STUT003_2.setENROLL_STATUS("2");
					STUT003_2.setSTTYPE("2");
					//by poto
					STUT003_2.setFTSTUD_CENTER_CODE("");
					STUT003_2.setFTSTUD_ENROLL_AYEARSMS("");
					STUT003_2.update(condition3);
					StringBuffer	sqlx		=	new StringBuffer();
					sqlx.append("SELECT count(1) NUM from stut004 where ayear='"+Utility.dbStr(requestMap.get("AYEAR"))+"' ");
					sqlx.append("and sms='"+Utility.dbStr(requestMap.get("SMS"))+"' ");
					sqlx.append("and stno='"+Utility.dbStr(requestMap.get("STNO"))+"'");
					rs4	=	dbManager.getSimpleResultSet(conn);
					rs4.open();
					rs4.executeQuery(sqlx.toString());
					rs4.next();
					if(!"0".equals(rs4.getString("NUM")))
					{
						STUT004DAO STUT004 = new STUT004DAO(dbManager, conn);
						STUT004.setSTTYPE("2");
						STUT004.update("AYEAR='"+Utility.dbStr(requestMap.get("AYEAR"))+"' AND SMS='"+Utility.dbStr(requestMap.get("SMS"))+"' AND "+condition3);
					}
					rs4.close();
				}
				//放棄雙主修取消學籍作業 20090817 aleck 增加
				//帶出雙主修學號
				STUT003DAO	STUT003_3 = new STUT003DAO(dbManager, conn);
				rs4 = STUT003_3.query("SELECT A.STNO FROM STUT003 A "+
				                      "WHERE A.IDNO = '"+Utility.dbStr(requestMap.get("IDNO"))+"' "+
                                      "AND   A.ENROLL_STATUS = '9' "+
                                      "AND   0 = (SELECT COUNT(1) FROM STUT003 B "+
                                      "WHERE B.IDNO = A.IDNO "+
                                      "AND   B.ASYS = '1' "+
                                      "AND   B.ENROLL_STATUS IN ('1','2'))" );
                //若有取得學號則將該學號的學籍狀態回復為 2 在籍，將STUT004歷程資料(當學年)刪除                      
                if (rs4.next())
                {                    
                    String strSTNO = rs4.getString("STNO");    
                    STUT003DAO	STUT003_4 = new STUT003DAO(dbManager, conn);
					STUT003_4.setUPD_RMK("SOL006M,修改學籍資料,修改");
					STUT003_4.setENROLL_STATUS("2");
					STUT003_4.update("STNO = '"+strSTNO+"' ");
					STUT004DAO STUT004 = new STUT004DAO(dbManager, conn);
					STUT004.delete("AYEAR='"+Utility.dbStr(requestMap.get("AYEAR"))+"' AND SMS='"+Utility.dbStr(requestMap.get("SMS"))+"' AND STNO = '"+strSTNO+"' ");					
					STUT032DAO STUT032 = new STUT032DAO(dbManager, conn);
					STUT032.delete("AYEARSMS='"+Utility.dbStr(requestMap.get("AYEAR"))+"' || '"+Utility.dbStr(requestMap.get("SMS"))+"' AND STNO = '"+strSTNO+"' ");					
					rs4.close();      
                }
			}
		}
		
		// 判斷是否要繳報名費(如免繳費原因有輸入則表示免繳費,否則表示要繳費)  <== 未繳費或是繳0元才執行		
		if(requestMap.get("PAYMENT_STATUS").toString().equals("1")||!requestMap.get("BEFORE_NPAYMENT_BAR").toString().equals("")){
		   if (requestMap.get("BATNUM").toString().equals("")){ //當批號為空時表示未交付對帳才可執行
			   updateSolAmt(dbManager,conn,requestMap,session);
		   }
		} 

        /** Commit Transaction */
		dbManager.commit();

        /** 自動帶出下一個學生的資料 */
		Vector willAuditStus = (Vector)session.getAttribute("WILL_AUDIT_STUS");
		boolean isMatch = false; // 判斷是否為目前存檔的這筆資料,要帶出下一筆
		String nextStuData = "";
		for(int i=0;i <willAuditStus.size(); i++){
			// 表示找到符合現在存檔的這位學生後的下一筆資料
			if(isMatch){
				nextStuData = willAuditStus.get(i).toString();
				break;
			}

			// 找到目前存檔的這個學生的資料
			if(willAuditStus.get(i).toString().equals(requestMap.get("IDNO").toString()+"-"+requestMap.get("BIRTHDATE").toString()))
				isMatch=true;
		}

		out.println(DataToJson.successJson(nextStuData));
    }
    catch (Exception ex)
    {
    	out.println(DataToJson.faileJson("修改存檔時發生錯誤!"));
    	ex.printStackTrace();
    	dbManager.rollback();
        dbManager.close();
    }
    finally
    {
        if (conn != null)
            conn.close();
        conn    =    null;
    }
}

// 判斷是否要繳報名費(如免繳費原因有輸入則表示免繳費,否則表示要繳費)
private void updateSolAmt(DBManager dbManager, Connection conn, Hashtable requestMap, HttpSession session)throws Exception{	
	String npaymentBar = requestMap.get("NPAYMENT_BAR").toString();
	String beforeNpaymentBar = requestMap.get("BEFORE_NPAYMENT_BAR").toString();
	
	String solt006Condition = "WRITEOFF_NO='"+requestMap.get("WRITEOFF_NO")+"' AND ASYS='"+requestMap.get("ASYS")+"' AND AYEAR='"+requestMap.get("AYEAR")+"' AND SMS='"+requestMap.get("SMS")+"' ";
	String solt007Condition = "ASYS='"+requestMap.get("ASYS")+"' AND AYEAR='"+requestMap.get("AYEAR")+"' AND SMS='"+requestMap.get("SMS")+"' AND WRITEOFF_NO='"+requestMap.get("WRITEOFF_NO")+"' AND IDNO='"+requestMap.get("IDNO")+"' AND BIRTHDATE='"+requestMap.get("BIRTHDATE")+"' ";
	String pcst004Condition = "WRITEOFF_NO='"+requestMap.get("WRITEOFF_NO")+"' ";
	String pcst018Condition = "WRITEOFF_NO='"+requestMap.get("WRITEOFF_NO")+"' ";
	
	// 只要免繳費原因有值就表示免繳費
	if(!npaymentBar.equals("")){
		SOLT006DAO solt006 = new SOLT006DAO(dbManager, conn);
		solt006.setPAYMENT_STATUS("2");
		solt006.setPAYMENT_METHOD("5");
		solt006.update(solt006Condition);
	
		SOLT007DAO solt007 = new SOLT007DAO(dbManager, conn);
		solt007.setPAYABLE_AMT("0");
		solt007.setPAID_AMT("0");
		solt007.setPAYMENT_DATE(DateUtil.getNowDate());
		solt007.setPAYMENT_STATUS("2");
		solt007.setNPAYMENT_BAR(npaymentBar);
		solt007.update(solt007Condition);
		
		PCST004DAO pcst004 = new PCST004DAO(dbManager, conn);
		pcst004.setPAYABLE_TOTAL_AMT("0");
		pcst004.setPAYMENT_STATUS("2");
		pcst004.setPAYMENT_MANNER("5");
		pcst004.update(pcst004Condition);
				
		// 寫入現場實收
		PCST018DAO pcst018 = new PCST018DAO(dbManager, conn, session.getAttribute("USER_ID").toString());
		pcst018.delete(pcst018Condition);
		
		pcst018 = new PCST018DAO(dbManager, conn, session.getAttribute("USER_ID").toString());
		pcst018.setWRITEOFF_NO(requestMap.get("WRITEOFF_NO").toString());
		pcst018.setPAYABLE_TOTAL_AMT("0");
		pcst018.setPAID_AMT("0");
		pcst018.setPAYMENT_MANNER("5");
		pcst018.setLOG_DATE(DateUtil.getNowDate());
		pcst018.setLOGER_ACNT(session.getAttribute("USER_ID").toString());
		pcst018.setCENTER_CODE(requestMap.get("CENTER_CODE").toString());
		pcst018.setPAYMENT_DATE(DateUtil.getNowDate());
		pcst018.setPAYMENT_TYPE(requestMap.get("ASYS").toString().equals("1")?"11":"12");
		pcst018.setUPD_MK("1");
		pcst018.insert();		
	}
	// 變成未繳
	else if(!beforeNpaymentBar.equals("")&&npaymentBar.equals("")){
		SOLT006DAO solt006 = new SOLT006DAO(dbManager, conn);
		solt006.setPAYMENT_STATUS("1");
		solt006.setPAYMENT_METHOD("");
		solt006.update(solt006Condition);
		
		SOLT007DAO solt007 = new SOLT007DAO(dbManager, conn);
		solt007.setPAYABLE_AMT("300");
		solt007.setPAID_AMT("0");
		solt007.setPAYMENT_STATUS("1");
		solt007.setPAYMENT_DATE("");
		solt007.setNPAYMENT_BAR("");
		solt007.update(solt007Condition);
		
		PCST004DAO pcst004 = new PCST004DAO(dbManager, conn);
		pcst004.setPAYABLE_TOTAL_AMT("300");
		pcst004.setPAYMENT_STATUS("1");
		pcst004.setPAYMENT_MANNER("");
		pcst004.update(pcst004Condition);
	}
}

/** 先前在報名時,選擇通過/帶補件 但尚未繳費時,可正常存檔,但尚未取得學號,此動作是確定已繳費(PCST004)則需做之前存檔的動作,並回寫招生系統改為已繳費 */
public void batchGetStno(JspWriter out, DBManager dbManager, Hashtable requestMap, HttpSession session) throws Exception
{
	DBResult rs = null;
	String errResult = "";
	Connection conn = null;
	try
    {
		conn    =    dbManager.getConnection(AUTCONNECT.mapConnect("SOL", session));

		String asys = requestMap.get("ASYS").toString();
		String ayear = requestMap.get("AYEAR").toString();
		String sms = requestMap.get("SMS").toString();

		// 取得共有多少學生已繳費但尚未取得學號
		STUT003GATEWAY stut003 = new STUT003GATEWAY(dbManager, conn);
		Vector totalStus = stut003.getHasPaidStus(requestMap);

		for(int i=0; i<totalStus.size(); i++){
			Hashtable eachStu = (Hashtable)totalStus.get(i);
			eachStu.put("CRNO", eachStu.get("IDNO").toString());
			
			String beforeStno = eachStu.get("BEFORE_STNO").toString();
			String idno = eachStu.get("IDNO").toString();
			String centerCode = eachStu.get("CENTER_CODE").toString();
			String birthdate = eachStu.get("BIRTHDATE").toString();
			String paymentStatus = eachStu.get("PAYMENT_STATUS").toString(); // 繳費狀態
			String writeoffNo = eachStu.get("WRITEOFF_NO").toString();
			String paymentManner = eachStu.get("PAYMENT_MANNER").toString(); // 繳費方式
			String paymentDate = eachStu.get("PAYMENT_DATE").toString(); // 繳費日期
			String isDoubleMajor = eachStu.get("IS_DOUBLE_MAJOR").toString(); // 是否為雙主修
			String originRace = eachStu.get("ORIGIN_RACE").toString(); // 原住民
			String handicapType = eachStu.get("HANDICAP_TYPE").toString(); // 身障類別
			String handicapGrade = eachStu.get("HANDICAP_GRADE").toString(); // 身障等級

			/** 取得學號 */
			// 判斷是否為舊選轉新全,使用舊學號-->報名空大時才需判斷
			String stno=""; //學號
			int z = 0; // 1 舊選轉新全 0 一般新生
			if(asys.equals("1")&&!beforeStno.equals("")){
				stno = beforeStno;
				z = 1;
			// 其他狀況一律取新學號
			}else{
	            SOLGETSTNO sysSTNO = new SOLGETSTNO(dbManager);
	            sysSTNO.setASYS(asys);
	            sysSTNO.setAYEAR(ayear);
	            sysSTNO.setSMS(sms);
	            sysSTNO.setCENTER_CODE(centerCode);
	            if(sysSTNO.execute()!=sysSTNO.SUCCESS){
	            	errResult="產生新學號時發生錯誤!";
	            	throw new Exception();
	            }				
	            stno = sysSTNO.getSTNO();
				z = 0;
			}

			/** 更新相關table */
			// 更新SOLT006
			SOLT006DAO    solt006    =    new SOLT006DAO(dbManager, conn);
			solt006.setPAYMENT_STATUS(paymentStatus);
			solt006.setPAYMENT_METHOD(paymentManner);
			solt006.update(
				   "ASYS='" + asys+ "' AND AYEAR='" + ayear+ "' AND " +
 				   "SMS='" + sms+ "' AND IDNO='" + idno+ "' AND " +
				   "BIRTHDATE='" + birthdate+ "' "
			);

			// 更新SOLT007
			SOLT007DAO    solt007    =    new SOLT007DAO(dbManager, conn);
			solt007.setPAYMENT_STATUS(paymentStatus);
			solt007.setPAYMENT_DATE(paymentDate);
			solt007.update(
				"ASYS='" + asys+ "' AND AYEAR='" + ayear+ "' AND " +
 				"SMS='" + sms+ "' AND IDNO='" + idno+ "' AND " +
				"BIRTHDATE='" + birthdate+ "' AND WRITEOFF_NO='"+writeoffNo+"' "
			);

			// 更新SOLT003
			SOLT003DAO    solt003    =    new SOLT003DAO(dbManager, conn);
			solt003.setSTNO(stno);
			solt003.update(
			   	"ASYS='" + asys+ "' AND AYEAR='" + ayear+ "' AND " +
	 			"SMS='" + sms+ "' AND IDNO='" + idno+ "' AND " +
				"BIRTHDATE='" + birthdate+ "' "
			);

			// 更新PCST004
			PCST004DAO    pcst004    =    new PCST004DAO(dbManager, conn);
			pcst004.setSTNO(stno);
			pcst004.update("WRITEOFF_NO='"+writeoffNo+"'");

			
			
			// 判斷學籍中是否有該學號的資料,如無則新增至學籍
			STUT003DAO stut003Dao = new STUT003DAO(dbManager, conn);
			stut003Dao.setResultColumn("count(1) as NUM");
			stut003Dao.setSTNO(stno);
			rs=stut003Dao.query();

			// 表示學籍資料中已有該學號的資料,因此不需往下繼續執行
			if(rs.next()&&rs.getInt("NUM")!=0){
				rs.close();
				continue;				
			}
			rs.close();
			
			
			// 新增資料到學籍
			String errMsg = this.insertDataToStu(dbManager, session, eachStu, stno,z,true);
			if(!errMsg.equals("")){
				errResult=errMsg;
	            throw new Exception();				
			}	
				
			// 新增資料到權限
			errMsg = this.insertDataToAut(dbManager, session, eachStu, stno);
			if(!errMsg.equals("")){
				errResult=errMsg;
	            throw new Exception();
			}

			// 新增資料到出版
			errMsg = this.insertDataToPub(dbManager, conn, session, eachStu, stno);
			if(!errMsg.equals("")){
				errResult=errMsg;
	            throw new Exception();
			}

			// 如該生有雙主修則需做此動作
			if(isDoubleMajor.equals("Y")){
				errMsg = this.giveupDoubleMajor(dbManager, conn, session, eachStu, stno);
				if(!errMsg.equals("")){
					errResult=errMsg;
	            	throw new Exception();
				}
			}

			// 新增原住民和身心障礙資料至SGUT004
			if(!(originRace.equals("") || handicapType.equals("") || handicapGrade.equals(""))){
				errMsg = this.insertDataToSgu(dbManager, conn, session, eachStu, stno);
				if(!errMsg.equals("")){
					errResult=errMsg;
	            	throw new Exception();
				}
			}

			// 更新SOLT009
			SOLT009DAO solt009 = new SOLT009DAO(dbManager, conn);
			solt009.setSTNO(stno);
            solt009.update(
            		"AYEAR='"+ayear+ "' AND " +
                    "SMS='"+sms+"' AND " +
                    "IDNO='"+idno+"' "
            );
		}
		
		dbManager.commit();
		out.println(DataToJson.successJson(totalStus.size()+""));
    }
    catch (Exception ex)
    {
    	dbManager.rollback();
    	out.println(DataToJson.faileJson(errResult.equals("")?"執行批次取號時發生錯誤":errResult));
        ex.printStackTrace();
    }
    finally
    {
        if (dbManager != null)
        	dbManager.close();
    }
}

// 寫入資料至學籍檔中
private int insertDataToStu_1(DBManager dbManager, HttpSession session, Hashtable rowHt, String stno,int z,boolean regCheck){
	int a = 0;
	try{
		STUADDDATA stuAdd = new STUADDDATA(dbManager);
		stuAdd.setUSER_ID((String)session.getAttribute("USER_ID"));
		stuAdd.setAYEAR((String)rowHt.get("AYEAR"));
		stuAdd.setSMS((String)rowHt.get("SMS"));
		stuAdd.setIDNO((String)rowHt.get("IDNO"));
		stuAdd.setBIRTHDATE((String)rowHt.get("BIRTHDATE"));
		stuAdd.setCENTER_CODE((String)rowHt.get("CENTER_CODE"));
		stuAdd.setSTTYPE((String)rowHt.get("STTYPE"));
		stuAdd.setNAME((String)rowHt.get("NAME"));
		stuAdd.setENG_NAME((String)rowHt.get("ENG_NAME"));
		stuAdd.setSEX((String)rowHt.get("SEX"));
		stuAdd.setSELF_IDENTITY_SEX((String)rowHt.get("SELF_IDENTITY_SEX"));
		stuAdd.setALIAS((String)rowHt.get("ALIAS"));
		stuAdd.setVOCATION((String)rowHt.get("VOCATION"));
		stuAdd.setEDUBKGRD_GRADE((String)rowHt.get("EDUBKGRD_GRADE"));
		stuAdd.setAREACODE_OFFICE((String)rowHt.get("AREACODE_OFFICE"));
		stuAdd.setTEL_OFFICE((String)rowHt.get("TEL_OFFICE"));
		stuAdd.setTEL_OFFICE_EXT((String)rowHt.get("TEL_OFFICE_EXT"));
		stuAdd.setAREACODE_HOME((String)rowHt.get("AREACODE_HOME"));
		stuAdd.setTEL_HOME((String)rowHt.get("TEL_HOME"));
		stuAdd.setMOBILE((String)rowHt.get("MOBILE"));
		stuAdd.setMARRIAGE((String)rowHt.get("MARRIAGE"));
		stuAdd.setDMSTADDR_ZIP((String)rowHt.get("DMSTADDR_ZIP"));
		stuAdd.setDMSTADDR((String)rowHt.get("DMSTADDR"));
		stuAdd.setCRRSADDR_ZIP((String)rowHt.get("CRRSADDR_ZIP"));
		stuAdd.setCRRSADDR((String)rowHt.get("CRRSADDR"));
		stuAdd.setEMAIL((String)rowHt.get("EMAIL"));
		stuAdd.setEMRGNCY_RELATION((String)rowHt.get("EMRGNCY_RELATION"));
		stuAdd.setASYS((String)rowHt.get("ASYS"));
		stuAdd.setSTNO(stno);
		stuAdd.setEMRGNCY_NAME((String)rowHt.get("EMRGNCY_NAME"));
		stuAdd.setEMRGNCY_TEL((String)rowHt.get("EMRGNCY_TEL"));
		stuAdd.setEDUBKGRD(rowHt.get("EDUBKGRD").toString().replaceAll(",","").replaceAll("其他",""));
		stuAdd.setEDUBKGRD_AYEAR((String)rowHt.get("EDUBKGRD_AYEAR"));
		stuAdd.setPRE_MAJOR_FACULTY((String)rowHt.get("PRE_MAJOR_FACULTY"));
		stuAdd.setJ_FACULTY_CODE((String)rowHt.get("J_FACULTY_CODE"));
		stuAdd.setTUTOR_CLASS_MK((String)rowHt.get("TUTOR_CLASS_MK"));		
		stuAdd.setFTSTUD_ENROLL_AYEARSMS((String)rowHt.get("AYEAR") + (String)rowHt.get("SMS"));
		stuAdd.setFTSTUD_CENTER_CODE((String)rowHt.get("CENTER_CODE"));		
		stuAdd.setNATIONCODE(Utility.nullToSpace(rowHt.get("NATIONCODE")));
		stuAdd.setIDNO_CHECK(UtilityX.stuIdnoChk(Utility.nullToSpace(rowHt.get("NATIONCODE"))));
		stuAdd.setNEWNATION(Utility.nullToSpace(rowHt.get("NEWNATION")));
		stuAdd.setSPECIAL_STTYPE_TYPE(Utility.nullToSpace(rowHt.get("SPECIAL_STTYPE_TYPE")));
		stuAdd.setFROM_PROG_CODE("SOL006M");
		if(z == 1){
			stuAdd.setSTTYPE_CHECK(true);//舊選轉新全
			stuAdd.setUPD_MK("2");//更新
		}else{
			if(regCheck){
				stuAdd.setUPD_MK("1");//新增
			}else{
				stuAdd.setUPD_MK("2");//更新
			}
			stuAdd.setENROLL_AYEARSMS((String)rowHt.get("AYEAR") + (String)rowHt.get("SMS"));							
		}
		a = stuAdd.execute();		
	}catch(Exception e){
		e.printStackTrace();		
	}

	return a;
}

// 寫入資料至學籍檔中
private String insertDataToStu(DBManager dbManager, HttpSession session, Hashtable rowHt, String stno,int z,boolean regCheck){
	String result = "";
	String idno = Utility.nullToSpace(rowHt.get("IDNO"));
	try{
		STUADDDATA stuAdd = new STUADDDATA(dbManager);
		stuAdd.setUSER_ID((String)session.getAttribute("USER_ID"));
		stuAdd.setAYEAR((String)rowHt.get("AYEAR"));
		stuAdd.setSMS((String)rowHt.get("SMS"));
		stuAdd.setIDNO((String)rowHt.get("IDNO"));
		stuAdd.setBIRTHDATE((String)rowHt.get("BIRTHDATE"));
		stuAdd.setCENTER_CODE((String)rowHt.get("CENTER_CODE"));
		stuAdd.setSTTYPE((String)rowHt.get("STTYPE"));
		stuAdd.setNAME((String)rowHt.get("NAME"));
		stuAdd.setENG_NAME((String)rowHt.get("ENG_NAME"));
		stuAdd.setSEX((String)rowHt.get("SEX"));
		stuAdd.setSELF_IDENTITY_SEX((String)rowHt.get("SELF_IDENTITY_SEX"));
		stuAdd.setALIAS((String)rowHt.get("ALIAS"));
		stuAdd.setVOCATION((String)rowHt.get("VOCATION"));
		stuAdd.setEDUBKGRD_GRADE((String)rowHt.get("EDUBKGRD_GRADE"));
		stuAdd.setAREACODE_OFFICE((String)rowHt.get("AREACODE_OFFICE"));
		stuAdd.setTEL_OFFICE((String)rowHt.get("TEL_OFFICE"));
		stuAdd.setTEL_OFFICE_EXT((String)rowHt.get("TEL_OFFICE_EXT"));
		stuAdd.setAREACODE_HOME((String)rowHt.get("AREACODE_HOME"));
		stuAdd.setTEL_HOME((String)rowHt.get("TEL_HOME"));
		stuAdd.setMOBILE((String)rowHt.get("MOBILE"));
		stuAdd.setMARRIAGE((String)rowHt.get("MARRIAGE"));
		stuAdd.setDMSTADDR_ZIP((String)rowHt.get("DMSTADDR_ZIP"));
		stuAdd.setDMSTADDR((String)rowHt.get("DMSTADDR"));
		stuAdd.setCRRSADDR_ZIP((String)rowHt.get("CRRSADDR_ZIP"));
		stuAdd.setCRRSADDR((String)rowHt.get("CRRSADDR"));
		stuAdd.setEMAIL((String)rowHt.get("EMAIL"));
		stuAdd.setEMRGNCY_RELATION((String)rowHt.get("EMRGNCY_RELATION"));
		stuAdd.setASYS((String)rowHt.get("ASYS"));
		stuAdd.setSTNO(stno);
		stuAdd.setEMRGNCY_NAME((String)rowHt.get("EMRGNCY_NAME"));
		stuAdd.setEMRGNCY_TEL((String)rowHt.get("EMRGNCY_TEL"));
		stuAdd.setEDUBKGRD(rowHt.get("EDUBKGRD").toString().replaceAll(",","").replaceAll("其他",""));
		stuAdd.setEDUBKGRD_AYEAR((String)rowHt.get("EDUBKGRD_AYEAR"));
		stuAdd.setPRE_MAJOR_FACULTY((String)rowHt.get("PRE_MAJOR_FACULTY"));
		stuAdd.setJ_FACULTY_CODE((String)rowHt.get("J_FACULTY_CODE"));
		stuAdd.setTUTOR_CLASS_MK((String)rowHt.get("TUTOR_CLASS_MK"));		
		//by poto 20091207 teno要求空專生也要填入FTSTUD_ENROLL_AYEARSMS,FTSTUD_CENTER_CODE
		stuAdd.setFTSTUD_ENROLL_AYEARSMS((String)rowHt.get("AYEAR") + (String)rowHt.get("SMS"));
		stuAdd.setFTSTUD_CENTER_CODE((String)rowHt.get("CENTER_CODE"));
		stuAdd.setNATIONCODE(Utility.nullToSpace(rowHt.get("NATIONCODE")));
		stuAdd.setSPECIAL_STTYPE_TYPE(Utility.nullToSpace(rowHt.get("SPECIAL_STTYPE_TYPE")));
		stuAdd.setIDNO_CHECK(UtilityX.stuIdnoChk(Utility.nullToSpace(rowHt.get("NATIONCODE"))));
		System.out.println("z="+z);					
		System.out.println("regCheck="+regCheck);
		if(z == 1){
			stuAdd.setSTTYPE_CHECK(true);//舊選轉新全
			stuAdd.setUPD_MK("2");//更新
		}else{
			
			if(regCheck){
				stuAdd.setUPD_MK("1");//新增
			}else{
				stuAdd.setUPD_MK("2");//更新
			}
			
			stuAdd.setENROLL_AYEARSMS((String)rowHt.get("AYEAR") + (String)rowHt.get("SMS"));							
		}
		
		if(stuAdd.execute()!=stuAdd.SUCCESS){
			result="身分證字號:"+idno+"執行新增資料至學籍的副程式時,發生錯誤!"+stuAdd.getAllError();
		}
		if(stuAdd.hasNextError()){
			System.out.println("ERRORS="+stuAdd.nextError()+"---EDUBKGRD1:"+rowHt.get("EDUBKGRD")+"---EDUBKGRD2:"+rowHt.get("EDUBKGRD").toString().replaceAll(",",""));
		}
		
	}catch(Exception e){
		e.printStackTrace();
		result = "身分證字號:"+idno+",新增資料至學籍時發生錯誤";
	}

	return result;
}

// 寫入資料至權限檔中
private String insertDataToAut(DBManager dbManager, HttpSession session, Hashtable rowHt, String stno){
	String result = "";
	String idno = Utility.nullToSpace(rowHt.get("IDNO"));

	try{
		AUTADDUSER autAdd = new AUTADDUSER(dbManager);
		autAdd.setUSER_ID(stno);
		autAdd.setASYS((String)rowHt.get("ASYS"));
		autAdd.setDEP_CODE((String)rowHt.get("CENTER_CODE"));
		autAdd.setID_TYPE("1");
		autAdd.setUSER_NM((String)rowHt.get("NAME"));
		autAdd.setUSER_IDNO((String)rowHt.get("IDNO"));
		autAdd.setUPD_USER_ID((String)session.getAttribute("USER_ID"));
		autAdd.setINSERT_PRESENT_STATUS("1");
		if(autAdd.execute()!=autAdd.SUCCESS){
			result="身分證字號:"+idno+"執行新增資料至權限系統的副程式時,發生錯誤!"+autAdd.getAllError();
		}
	}catch(Exception e){
		e.printStackTrace();
		result = "身分證字號:"+idno+",新增資料至權限系統時發生錯誤";
	}

	return result;
}

//寫入資料至出版檔中
private String insertDataToPub(DBManager dbManager, Connection conn, HttpSession session, Hashtable rowHt, String stno){
	String result = "";
	String idno = Utility.nullToSpace(rowHt.get("IDNO"));

	try{
		PubAddStu pubAdd = new PubAddStu(dbManager, conn, session);
		pubAdd.setBIRTHDATE((String)rowHt.get("BIRTHDATE"));
		pubAdd.setIDNO((String)rowHt.get("IDNO"));
		pubAdd.setSTNO(stno);

		if(pubAdd.execute()!=pubAdd.SUCCESS){
			result="身分證字號:"+idno+"執行新增資料至出版系統的副程式時,發生錯誤!"+pubAdd.getAllError();
		}
	}catch(Exception e){
		e.printStackTrace();
		result = "身分證字號:"+idno+",新增資料至出版系統時發生錯誤";
	}

	return result;
}

// 放棄雙主修資料
private String giveupDoubleMajor(DBManager dbManager, Connection conn, HttpSession session, Hashtable rowHt, String stno){
	String result = "";
	String idno = Utility.nullToSpace(rowHt.get("IDNO"));

	try{
		STUDISDBMAJOR stuDis = new STUDISDBMAJOR(dbManager);
		stuDis.setAYEAR((String)rowHt.get("AYEAR"));
		stuDis.setSMS((String)rowHt.get("SMS"));
		stuDis.setSTNO(stno);
		stuDis.setIDNO(idno);
		stuDis.setUSER_ID((String)session.getAttribute("USER_ID"));

		if(stuDis.execute()!=stuDis.SUCCESS){
			result="身分證字號:"+idno+"執行放棄雙主修的副程式時,發生錯誤!"+stuDis.getAllError();
		}
	}catch(Exception e){
		e.printStackTrace();
		result = "身分證字號:"+idno+",執行放棄雙主修時發生錯誤";
	}

	return result;
}

// 新增原住民和身心障礙資料至SGUT004
private String insertDataToSgu(DBManager dbManager, Connection conn, HttpSession session, Hashtable rowHt, String stno){
	String result = "";
	String idno = Utility.nullToSpace(rowHt.get("IDNO"));

	try{
		SGUUPDSGUT004 SGUT004 = new SGUUPDSGUT004(dbManager);
		SGUT004.setSTNO(stno);
		SGUT004.setAYEAR((String)rowHt.get("AYEAR"));
		SGUT004.setSMS((String)rowHt.get("SMS"));
		SGUT004.setPARENTS_RACE(Utility.nullToSpace(rowHt.get("ORIGIN_RACE")));
		SGUT004.setHANDICAP_TYPE(Utility.nullToSpace(rowHt.get("HANDICAP_TYPE")));
		SGUT004.setHANDICAP_GRADE(Utility.nullToSpace(rowHt.get("HANDICAP_GRADE")));
		SGUT004.setUPD_USER_ID((String)session.getAttribute("USER_ID"));
		SGUT004.execute();

		if(SGUT004.execute()!=SGUT004.SUCCESS){
			result="身分證字號:"+idno+"新增原住民和身心障礙資料的副程式時,發生錯誤!"+SGUT004.getAllError();
		}
	}catch(Exception e){
		e.printStackTrace();
		result = "身分證字號:"+idno+",新增原住民和身心障礙資料時發生錯誤";
	}

	return result;
}

/** 刪除資料 */
public void doDelete(JspWriter out, DBManager dbManager, Hashtable requestMap, HttpSession session) throws Exception
{
    try
    {
        Connection    conn        =    dbManager.getConnection(AUTCONNECT.mapConnect("SOL", session));

        /** 刪除條件 */
        StringBuffer    conditionBuff    =    new StringBuffer();
        StringBuffer    conditionBuff_1    =    new StringBuffer();
        String[]    AYEAR        =    Utility.split(requestMap.get("AYEAR").toString(), ",");
        String[]    SMS        =    Utility.split(requestMap.get("SMS").toString(), ",");
        String[]    ASYS    =    Utility.split(requestMap.get("ASYS").toString(), ",");
        String[]    BIRTHDATE    =    Utility.split(requestMap.get("BIRTHDATE").toString(), ",");
        String[]    IDNO    =    Utility.split(requestMap.get("IDNO").toString(), ",");
        String[]    STNO    =    Utility.split(requestMap.get("STNO").toString(), ",");

        for (int i = 0; i < AYEAR.length; i++)
        {
            //1
            if (i > 0){
                conditionBuff.append (" OR ");
            }

            conditionBuff.append
            (
                "(" +
                "    AYEAR        =    '" + Utility.dbStr(AYEAR[i]) + "' AND " +
                "    SMS        =    '" + Utility.dbStr(SMS[i]) + "' AND " +
                "    ASYS        =    '" + Utility.dbStr(ASYS[i]) + "' AND " +
                "    BIRTHDATE   =    '" + Utility.dbStr(BIRTHDATE[i]) + "' AND " +
                "    IDNO    =    '" + Utility.dbStr(IDNO[i]) + "' " +
                ")"
            );
            //2
            if (i > 0){
                conditionBuff_1.append (" OR ");
            }

            conditionBuff_1.append
            (
                "(" +
                "    IDNO        =    '" + Utility.dbStr(IDNO[i]) + "' " +
                ")"
            );	
        }

        PCST004DAO P4 = new PCST004DAO(dbManager, conn, requestMap, session);
        P4.delete(" WRITEOFF_NO IN ( SELECT S7.WRITEOFF_NO FROM SOLT007 S7 WHERE S7.WRITEOFF_NO = PCST004.WRITEOFF_NO AND "+conditionBuff.toString()+")");

        /** 處理刪除動作 */
        SOLT003DAO    SOLT003    =    new SOLT003DAO(dbManager, conn, requestMap, session);
        SOLT003.delete(conditionBuff.toString());

        SOLT006DAO    SOLT006    =    new SOLT006DAO(dbManager, conn, requestMap, session);
        SOLT006.delete(conditionBuff.toString());

        SOLT007DAO    SOLT007    =    new SOLT007DAO(dbManager, conn, requestMap, session);
        SOLT007.delete(conditionBuff.toString());

        SOLT009DAO    SOLT009    =    new SOLT009DAO(dbManager, conn, requestMap, session);
        SOLT009.delete(conditionBuff_1.toString());
		
		
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

private boolean isAudit(HttpSession session, Hashtable requestMap)throws Exception{
	Hashtable autHt = Permision.processAllPermision(session);
	String depType = autHt.get("DEP_TYPE").toString();
	// 中心審查
	boolean isAuditResult = Utility.nullToSpace(requestMap.get("AUDIT_RESULT")).equals("0")||Utility.nullToSpace(requestMap.get("AUDIT_RESULT")).equals("4");
	// 教務處審查
	boolean isTotalResult = Utility.nullToSpace(requestMap.get("TOTAL_RESULT")).equals("0")||Utility.nullToSpace(requestMap.get("TOTAL_RESULT")).equals("4");
	
	
	//return (depType.equals("43")&&isAuditResult)||(depType.equals("33")&&isTotalResult);
	return (depType.equals("43")&&isAuditResult)||(depType.equals("33")&&false);
}

/**
*判斷如果是 教務處 且 他是通過跟帶補件 且 他已經有學號了 就不要在清空學號了
**/
private boolean isAudit_1(HttpSession session, Hashtable requestMap)throws Exception{
	Hashtable autHt = Permision.processAllPermision(session);
	String depType = autHt.get("DEP_TYPE").toString();
	// 教務處審查
	boolean isTotalResult = Utility.nullToSpace(requestMap.get("TOTAL_RESULT")).equals("0")||Utility.nullToSpace(requestMap.get("TOTAL_RESULT")).equals("4");
	return (depType.equals("33")&&isTotalResult);
}





// regt
private boolean checkRegt005(DBManager dbManager, Connection conn ,String AYEAR, String SMS, String STNO) throws Exception{
	boolean check = false ;
	try{
		REGT005DAO REGT005DAO = new REGT005DAO(dbManager,conn);
		REGT005DAO.setResultColumn(" 1 ");
		REGT005DAO.setWhere(" AYEAR = '"+AYEAR+"' AND SMS = '"+SMS+"' AND STNO = '"+STNO+"' AND TAKE_MANNER ='N' AND PAYMENT_STATUS = '2' ");
		DBResult rs  = REGT005DAO.query();
		if(rs.next()){
			check = true;
		}else{
			check = false;
		}	

	}catch(Exception e){

	}
	return check;
}

/** 檢查學籍狀態*/
public void doEnroll(JspWriter out, DBManager dbManager, Hashtable requestMap, HttpSession session) throws Exception
{
	Connection conn = null;
	try
	{
		int        pageNo        =    Integer.parseInt(Utility.checkNull(requestMap.get("pageNo"), "1"));
        int        pageSize    =    Integer.parseInt(Utility.checkNull(requestMap.get("pageSize"), "10"));
        conn    =    dbManager.getConnection(AUTCONNECT.mapConnect("SOL", session));

        SOLT006GATEWAY solt006gateway = new SOLT006GATEWAY(dbManager,conn,pageNo,pageSize);
        Vector result = solt006gateway.getSolt006EnrollStatus(requestMap);

        out.println(DataToJson.vtToJson (result));
	}
	catch (Exception ex)
	{
		throw ex;
	}
	finally
	{
		if (conn != null)
			conn.close();
		conn	=	null;
	}

}

/** 退審資料 */
public void doReject(JspWriter out, DBManager dbManager, Hashtable requestMap, HttpSession session) throws Exception
{
    try
    {
        Connection    conn        =    dbManager.getConnection(AUTCONNECT.mapConnect("SOL", session));

        /** 刪除條件 */
        StringBuffer    conditionBuff    =    new StringBuffer();
        StringBuffer    conditionBuff_1    =    new StringBuffer();
        String[]    AYEAR        =    Utility.split(requestMap.get("AYEAR").toString(), ",");
        String[]    SMS        =    Utility.split(requestMap.get("SMS").toString(), ",");
        String[]    ASYS    =    Utility.split(requestMap.get("ASYS").toString(), ",");
        String[]    BIRTHDATE    =    Utility.split(requestMap.get("BIRTHDATE").toString(), ",");
        String[]    IDNO    =    Utility.split(requestMap.get("IDNO").toString(), ",");

        int solt006updateCount = 0;
        int solt003updateCount = 0;
        System.out.println("do reject");
        for (int i = 0; i < AYEAR.length; i++)
        {
        	
       		if(AYEAR[i] == "" || SMS[i] == "" || ASYS[i] == "" || BIRTHDATE[i] == "" || IDNO[i] == "" ) {
       			throw new Exception("doReject有參數沒有讀到");
       		}
        	
       
        	/** 處理修改動作solt007 */
            SOLT006DAO    SOLT006    =    new SOLT006DAO(dbManager,conn);
            
            SOLT006.setAUDIT_RESULT("3");
            SOLT006.setCHECK_DOC("3");
            
            String    condition1    =     "ASYS         =    '" + Utility.dbStr(ASYS[i])+ "' AND " +
                                          "AYEAR         =    '" + Utility.dbStr(AYEAR[i])+ "' AND " +
                                          "SMS         =    '" + Utility.dbStr(SMS[i])+ "' AND " +
                                          "IDNO         =    '" + Utility.dbStr(IDNO[i])+ "' AND " +
                                          "BIRTHDATE    =    '" + Utility.dbStr(BIRTHDATE[i])+ "' " ;
            solt006updateCount       +=    SOLT006.update(condition1);
            
            SOLT003DAO    SOLT003    =    new SOLT003DAO(dbManager, conn);
            SOLT003.setSTNO("");
            condition1    =     "ASYS         =    '" + Utility.dbStr(ASYS[i])+ "' AND " +
                    			"AYEAR         =    '" + Utility.dbStr(AYEAR[i])+ "' AND " +
                    			"SMS         =    '" + Utility.dbStr(SMS[i])+ "' AND " +
                    			"IDNO         =    '" + Utility.dbStr(IDNO[i])+ "' AND " +
                    			"BIRTHDATE    =    '" + Utility.dbStr(BIRTHDATE[i])+ "' " ;
            solt003updateCount       +=    SOLT003.update(condition1);
            
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

%>