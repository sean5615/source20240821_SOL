<%/*
----------------------------------------------------------------------------------
File Name        : sol006m_01m1.jsp
Author            : ����L
Description        : SOL006M_�n�����W�f�d���G - �B�z�޿譶��
Modification Log    :

Vers        Date           By                Notes
--------------    --------------    --------------    ----------------------------------
0.0.1        096/01/25    ����L        Code Generate Create
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
/** �B�z�d�� Grid ��� */
public void doQuery(JspWriter out, DBManager dbManager, Hashtable requestMap, HttpSession session) throws Exception
{
    try
    {
        int        pageNo        =    Integer.parseInt(Utility.checkNull(requestMap.get("pageNo"), "1"));
        int        pageSize    =    Integer.parseInt(Utility.checkNull(requestMap.get("pageSize"), "10"));
        Connection conn    =    dbManager.getConnection(AUTCONNECT.mapConnect("SOL", session));

        Vector result = new Vector();
        SOLT006GATEWAY sol03Jsol06 = new SOLT006GATEWAY(dbManager,conn,pageNo,pageSize);

        result = sol03Jsol06.getSolt003Solt006ForUse1(requestMap);  // �ȷ|��1�������

        sol03Jsol06 = new SOLT006GATEWAY(dbManager,conn);
        Vector allResult = sol03Jsol06.getSolt003Solt006ForUse1(requestMap); // �Ҧ������
        // �b���v�Tgateway�����p�U,�]���b�o�N�Ҧ��������Ҧr��+�ͤ��b�e����
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

/** �ˬd�O�_�����D�ץ�*/
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
		//���d���L�Ǹ�
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

/** �ק�a�X��� */
public void doQueryEdit(JspWriter out, DBManager dbManager, Hashtable requestMap, HttpSession session) throws Exception
{
    try
    {
        int        pageNo        =    Integer.parseInt(Utility.checkNull(requestMap.get("pageNo"), "1"));
        int        pageSize    =    Integer.parseInt(Utility.checkNull(requestMap.get("pageSize"), "10"));
        Connection conn    =    dbManager.getConnection(AUTCONNECT.mapConnect("SOL", session));

        // �P�_�O�_�g�Ѧs�ɫ�a�X�U�@����ƪ��覡
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

/** �ק�s�� */
public void doModify(JspWriter out, DBManager dbManager, Hashtable requestMap, HttpSession session) throws Exception
{
    String STNO=""; //�Ǹ�
    String paymentStatus = Utility.nullToSpace(requestMap.get("PAYMENT_STATUS")); // ú�O���A
	String specialStudent = Utility.checkNull(requestMap.get("SPECIAL_STUDENT_TMP"), "");
	//by poto �[�J��ҧP�_		
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
	/** �N���ۤ@���L�h */
	for (int i = 1; i <= rs3.getColumnCount(); i++){
		rowHt.put(rs3.getColumnName(i), rs3.getString(i));
	}	
	rs3.close();
	
	int x = 5;              //�P�_�s�W��Ʀܾ��y�O�_���\
	int z = 0;				//�O�_�ϥ��¾Ǹ�������B�z(�ϥηs�Ǹ��G0�F�ϥ��¾Ǹ��G1)
	
	
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
					
	// �P�_�O�_�nú�O...
	String npaymentBar = requestMap.get("NPAYMENT_BAR").toString(); // ���ȫh��ܧKú�O�����w�q�L
	String beforeNpaymentBar = requestMap.get("BEFORE_NPAYMENT_BAR").toString();
	// case 1.npaymentBar���ȫh��ܧKú�O�����w�q�L
	// case 2.npaymentBar�L�Ȧ�beforeNpaymentBar���Ȫ�ܥ�ú<==�o�ت��p�����Ǹ�
	// case 3.npaymentBar�L�Ȧ�beforeNpaymentBar�L���ٻݬ�paymentStatus>1  �~�i���Ǹ�    
	boolean isPayment = !npaymentBar.equals("")||(npaymentBar.equals("")&&beforeNpaymentBar.equals("")&&!(paymentStatus.equals("1")||paymentStatus.equals(""))); // �Kú�O��]�p����J�h��ܤwú�O
	// ���n�J�̨����P�_�M�w���G,�u�n�ճq�L�άO�ݸɥ󳣺�q�L
	boolean isAudit = isAudit(session,requestMap);
	
    int Success=0;
	String NUM = "";
	// �q�L�B��ú�O�~�i���o�Ǹ�  
    //if((Utility.checkNull(requestMap.get("AUDIT_RESULT"), "").equals("0") || Utility.checkNull(requestMap.get("TOTAL_RESULT"), "").equals("0"))&&isPayment){
    if(isAudit&&isPayment){
        Success=0;
        if(Utility.nullToSpace(requestMap.get("STNO")).equals("")){
            //���o�Ǹ��A�¿���s�����ϥ��¾Ǹ�
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
			// �űM�j�����o�s�Ǹ�  2008.11.27  north
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



        // �ק����
        String    condition    =    "ASYS         =    '" + Utility.dbStr(requestMap.get("ASYS"))+ "' AND " +
                                    "AYEAR         =    '" + Utility.dbStr(requestMap.get("AYEAR"))+ "' AND " +
                                    "SMS         =    '" + Utility.dbStr(requestMap.get("SMS"))+ "' AND " +
                                    "IDNO         =    '" + Utility.dbStr(requestMap.get("IDNO"))+ "' AND " +
                                    "BIRTHDATE    =    '" + Utility.dbStr(requestMap.get("BIRTHDATE"))+ "' " ;

        /** �B�z�ק�ʧ@solt006 */
        SOLT006DAO    SOLT006    =    new SOLT006DAO(dbManager, conn, requestMap, session);
        solt006updateCount       =    SOLT006.update(condition);

        /** �B�z�ק�ʧ@solt007 */
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
				/** �B�z�ק�ʧ@ solt003�s�W�Ǹ�*/
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

				//by poto �s�W���y���
			    x = insertDataToStu_1(dbManager,session, rowHt,Utility.nullToSpace(requestMap.get("STNO")),z,regCheck);			
				if(x == 1 && z == 0){
					System.out.println("�s�W���y��Ƨ���");
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
						System.out.println("�s�W�v����Ƨ���");
						x = 5;
						//�N�ǥ͸����JPUB 2008/05/12 by barry 2008/05/12 by barry
						PubAddStu pubAdd = new PubAddStu(dbManager, conn, session);
						pubAdd.setBIRTHDATE((String)rowHt.get("BIRTHDATE"));
						pubAdd.setIDNO((String)rowHt.get("IDNO"));
						pubAdd.setSTNO(STNO);
						x = pubAdd.execute();
						if(x == 1)
						{
							System.out.println("�s�W�X����Ƨ���");
							//������D�פ~���榹�q	2008/08/29	by barry
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
									System.out.println("������D�׳B�z����");
								}else{
									System.out.println("������D�׳B�z����");
									dbManager.rollback();
								}
							}
						}else{
							System.out.println("�s�W�X����ƥ���");
							dbManager.rollback();
						}
					}else{
						System.out.println("�s�W�v����ƥ���");
					}
				}else if(x == 1 && z == 1){
					System.out.println("�ϥ��¾Ǹ��A�w���v����ơA���@�s�W���ʧ@�C");
				}else{
					out.println(DataToJson.faileJson("�s�W�Ǹ����ơA�Э��s�s��!"));
					System.out.println("�s�W���y��ƥ���");
					return;
				}
				//�s�W�����M���߻�ê��Ʀ�SGUT004
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
						System.out.println("�s�WSGUT004��Ƨ���");
					}else{
						System.out.println("�s�WSGUT004��ƥ���");
					}
				}
				
				//�s�W�����M���߻�ê��Ʀ�SGUT039
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
						System.out.println("�s�WSGUT039��Ƨ���");
					}else{
						System.out.println("�s�WSGUT039��ƥ���");
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
				/** �B�z�ק�ʧ@ �f�d���q�L�A����solt003�Ǹ�*/
				SOLT003DAO    SOLT003    =    new SOLT003DAO(dbManager, conn);
	            SOLT003.setSTNO("");
	            solt003updateCount       =    SOLT003.update(condition);
				/** �B�z�ק�ʧ@ �f�d���q�L�A����pcst004�Ǹ�*/
				PCST004DAO PCST004 = new PCST004DAO(dbManager, conn);
				PCST004.setSTNO("");
				pcst004updateCount = PCST004.update("WRITEOFF_NO='" + Utility.dbStr(requestMap.get("WRITEOFF_NO"))+ "' ");
				/** �B�z�ק�ʧ@ �f�d���q�L�A����solt009�Ǹ�*/
				SOLT009DAO    SOLT009    =    new SOLT009DAO(dbManager, conn);
	            SOLT009.setSTNO("");
	            String    condition2    =    "AYEAR         =    '" + Utility.dbStr(requestMap.get("AYEAR"))+ "' AND " +
	                                         "SMS         =    '" + Utility.dbStr(requestMap.get("SMS"))+ "' AND " +
	                                         "IDNO         =    '" + Utility.dbStr(requestMap.get("IDNO"))+ "' ";
	            solt009updateCount       =    SOLT009.update(condition2);
				/** �B�z�ק�ʧ@ �f�d���q�L�A���O����STUT003���y���*/
				String ENROLL_AYEARSMS = "";
				String FTSTUD_ENROLL_AYEARSMS = "";
				STUT003DAO	STUT003_1 = new STUT003DAO(dbManager, conn);
				String condition3 = "STNO = '" + Utility.dbStr(requestMap.get("STNO")) + "' ";
				STUT003_1.setResultColumn("*");
				STUT003_1.setSTNO(requestMap.get("STNO").toString());
				DBResult rs4 = STUT003_1.query();
				rs4.next();
				rowHt = new Hashtable();
				/** �N���ۤ@���L�h */
				for (int i = 1; i <= rs4.getColumnCount(); i++){
					rowHt.put(rs4.getColumnName(i), rs4.getString(i));
					FTSTUD_ENROLL_AYEARSMS = rs4.getString("FTSTUD_ENROLL_AYEARSMS");					
					ENROLL_AYEARSMS = rs4.getString("ENROLL_AYEARSMS");					
				}	
				rs4.close();
				STUU003DAO STUU003 = new STUU003DAO(dbManager, conn, rowHt, session);
				STUU003.insert();
				String ayearSms = requestMap.get("AYEAR").toString()+requestMap.get("SMS").toString();
				//�@��������y�@�~
				if(ayearSms.equals(ENROLL_AYEARSMS))
				{
					STUT003DAO	STUT003_2 = new STUT003DAO(dbManager, conn);
					STUT003_2.setUPD_RMK("SOL006M,�ק���y���,�ק�");
					STUT003_2.setENROLL_STATUS("7");
					STUT003_2.update(condition3);

					AUTSTOPAC autStop = new AUTSTOPAC(dbManager);
					autStop.setUSER_ID(Utility.dbStr(requestMap.get("STNO")) );
					autStop.setPRESENT_STATUS("4");
					autStop.execute();

				//�¿���s���������y�@�~
				}else if(!ayearSms.equals(ENROLL_AYEARSMS)&&ayearSms.equals(FTSTUD_ENROLL_AYEARSMS)){
					STUT003DAO	STUT003_2 = new STUT003DAO(dbManager, conn);
					STUT003_2.setUPD_RMK("SOL006M,�ק���y���,�ק�");
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
				//������D�ר������y�@�~ 20090817 aleck �W�[
				//�a�X���D�׾Ǹ�
				STUT003DAO	STUT003_3 = new STUT003DAO(dbManager, conn);
				rs4 = STUT003_3.query("SELECT A.STNO FROM STUT003 A "+
				                      "WHERE A.IDNO = '"+Utility.dbStr(requestMap.get("IDNO"))+"' "+
                                      "AND   A.ENROLL_STATUS = '9' "+
                                      "AND   0 = (SELECT COUNT(1) FROM STUT003 B "+
                                      "WHERE B.IDNO = A.IDNO "+
                                      "AND   B.ASYS = '1' "+
                                      "AND   B.ENROLL_STATUS IN ('1','2'))" );
                //�Y�����o�Ǹ��h�N�ӾǸ������y���A�^�_�� 2 �b�y�A�NSTUT004���{���(��Ǧ~)�R��                      
                if (rs4.next())
                {                    
                    String strSTNO = rs4.getString("STNO");    
                    STUT003DAO	STUT003_4 = new STUT003DAO(dbManager, conn);
					STUT003_4.setUPD_RMK("SOL006M,�ק���y���,�ק�");
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
		
		// �P�_�O�_�nú���W�O(�p�Kú�O��]����J�h��ܧKú�O,�_�h��ܭnú�O)  <== ��ú�O�άOú0���~����		
		if(requestMap.get("PAYMENT_STATUS").toString().equals("1")||!requestMap.get("BEFORE_NPAYMENT_BAR").toString().equals("")){
		   if (requestMap.get("BATNUM").toString().equals("")){ //��帹���Ůɪ�ܥ���I��b�~�i����
			   updateSolAmt(dbManager,conn,requestMap,session);
		   }
		} 

        /** Commit Transaction */
		dbManager.commit();

        /** �۰ʱa�X�U�@�Ӿǥͪ���� */
		Vector willAuditStus = (Vector)session.getAttribute("WILL_AUDIT_STUS");
		boolean isMatch = false; // �P�_�O�_���ثe�s�ɪ��o�����,�n�a�X�U�@��
		String nextStuData = "";
		for(int i=0;i <willAuditStus.size(); i++){
			// ��ܧ��ŦX�{�b�s�ɪ��o��ǥ᪺ͫ�U�@�����
			if(isMatch){
				nextStuData = willAuditStus.get(i).toString();
				break;
			}

			// ���ثe�s�ɪ��o�Ӿǥͪ����
			if(willAuditStus.get(i).toString().equals(requestMap.get("IDNO").toString()+"-"+requestMap.get("BIRTHDATE").toString()))
				isMatch=true;
		}

		out.println(DataToJson.successJson(nextStuData));
    }
    catch (Exception ex)
    {
    	out.println(DataToJson.faileJson("�ק�s�ɮɵo�Ϳ��~!"));
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

// �P�_�O�_�nú���W�O(�p�Kú�O��]����J�h��ܧKú�O,�_�h��ܭnú�O)
private void updateSolAmt(DBManager dbManager, Connection conn, Hashtable requestMap, HttpSession session)throws Exception{	
	String npaymentBar = requestMap.get("NPAYMENT_BAR").toString();
	String beforeNpaymentBar = requestMap.get("BEFORE_NPAYMENT_BAR").toString();
	
	String solt006Condition = "WRITEOFF_NO='"+requestMap.get("WRITEOFF_NO")+"' AND ASYS='"+requestMap.get("ASYS")+"' AND AYEAR='"+requestMap.get("AYEAR")+"' AND SMS='"+requestMap.get("SMS")+"' ";
	String solt007Condition = "ASYS='"+requestMap.get("ASYS")+"' AND AYEAR='"+requestMap.get("AYEAR")+"' AND SMS='"+requestMap.get("SMS")+"' AND WRITEOFF_NO='"+requestMap.get("WRITEOFF_NO")+"' AND IDNO='"+requestMap.get("IDNO")+"' AND BIRTHDATE='"+requestMap.get("BIRTHDATE")+"' ";
	String pcst004Condition = "WRITEOFF_NO='"+requestMap.get("WRITEOFF_NO")+"' ";
	String pcst018Condition = "WRITEOFF_NO='"+requestMap.get("WRITEOFF_NO")+"' ";
	
	// �u�n�Kú�O��]���ȴN��ܧKú�O
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
				
		// �g�J�{���ꦬ
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
	// �ܦ���ú
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

/** ���e�b���W��,��ܳq�L/�a�ɥ� ���|��ú�O��,�i���`�s��,���|�����o�Ǹ�,���ʧ@�O�T�w�wú�O(PCST004)�h�ݰ����e�s�ɪ��ʧ@,�æ^�g�ۥͨt�Χאּ�wú�O */
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

		// ���o�@���h�־ǥͤwú�O���|�����o�Ǹ�
		STUT003GATEWAY stut003 = new STUT003GATEWAY(dbManager, conn);
		Vector totalStus = stut003.getHasPaidStus(requestMap);

		for(int i=0; i<totalStus.size(); i++){
			Hashtable eachStu = (Hashtable)totalStus.get(i);
			eachStu.put("CRNO", eachStu.get("IDNO").toString());
			
			String beforeStno = eachStu.get("BEFORE_STNO").toString();
			String idno = eachStu.get("IDNO").toString();
			String centerCode = eachStu.get("CENTER_CODE").toString();
			String birthdate = eachStu.get("BIRTHDATE").toString();
			String paymentStatus = eachStu.get("PAYMENT_STATUS").toString(); // ú�O���A
			String writeoffNo = eachStu.get("WRITEOFF_NO").toString();
			String paymentManner = eachStu.get("PAYMENT_MANNER").toString(); // ú�O�覡
			String paymentDate = eachStu.get("PAYMENT_DATE").toString(); // ú�O���
			String isDoubleMajor = eachStu.get("IS_DOUBLE_MAJOR").toString(); // �O�_�����D��
			String originRace = eachStu.get("ORIGIN_RACE").toString(); // ����
			String handicapType = eachStu.get("HANDICAP_TYPE").toString(); // �������O
			String handicapGrade = eachStu.get("HANDICAP_GRADE").toString(); // ���ٵ���

			/** ���o�Ǹ� */
			// �P�_�O�_���¿���s��,�ϥ��¾Ǹ�-->���W�Ťj�ɤ~�ݧP�_
			String stno=""; //�Ǹ�
			int z = 0; // 1 �¿���s�� 0 �@��s��
			if(asys.equals("1")&&!beforeStno.equals("")){
				stno = beforeStno;
				z = 1;
			// ��L���p�@�ߨ��s�Ǹ�
			}else{
	            SOLGETSTNO sysSTNO = new SOLGETSTNO(dbManager);
	            sysSTNO.setASYS(asys);
	            sysSTNO.setAYEAR(ayear);
	            sysSTNO.setSMS(sms);
	            sysSTNO.setCENTER_CODE(centerCode);
	            if(sysSTNO.execute()!=sysSTNO.SUCCESS){
	            	errResult="���ͷs�Ǹ��ɵo�Ϳ��~!";
	            	throw new Exception();
	            }				
	            stno = sysSTNO.getSTNO();
				z = 0;
			}

			/** ��s����table */
			// ��sSOLT006
			SOLT006DAO    solt006    =    new SOLT006DAO(dbManager, conn);
			solt006.setPAYMENT_STATUS(paymentStatus);
			solt006.setPAYMENT_METHOD(paymentManner);
			solt006.update(
				   "ASYS='" + asys+ "' AND AYEAR='" + ayear+ "' AND " +
 				   "SMS='" + sms+ "' AND IDNO='" + idno+ "' AND " +
				   "BIRTHDATE='" + birthdate+ "' "
			);

			// ��sSOLT007
			SOLT007DAO    solt007    =    new SOLT007DAO(dbManager, conn);
			solt007.setPAYMENT_STATUS(paymentStatus);
			solt007.setPAYMENT_DATE(paymentDate);
			solt007.update(
				"ASYS='" + asys+ "' AND AYEAR='" + ayear+ "' AND " +
 				"SMS='" + sms+ "' AND IDNO='" + idno+ "' AND " +
				"BIRTHDATE='" + birthdate+ "' AND WRITEOFF_NO='"+writeoffNo+"' "
			);

			// ��sSOLT003
			SOLT003DAO    solt003    =    new SOLT003DAO(dbManager, conn);
			solt003.setSTNO(stno);
			solt003.update(
			   	"ASYS='" + asys+ "' AND AYEAR='" + ayear+ "' AND " +
	 			"SMS='" + sms+ "' AND IDNO='" + idno+ "' AND " +
				"BIRTHDATE='" + birthdate+ "' "
			);

			// ��sPCST004
			PCST004DAO    pcst004    =    new PCST004DAO(dbManager, conn);
			pcst004.setSTNO(stno);
			pcst004.update("WRITEOFF_NO='"+writeoffNo+"'");

			
			
			// �P�_���y���O�_���ӾǸ������,�p�L�h�s�W�ܾ��y
			STUT003DAO stut003Dao = new STUT003DAO(dbManager, conn);
			stut003Dao.setResultColumn("count(1) as NUM");
			stut003Dao.setSTNO(stno);
			rs=stut003Dao.query();

			// ��ܾ��y��Ƥ��w���ӾǸ������,�]�����ݩ��U�~�����
			if(rs.next()&&rs.getInt("NUM")!=0){
				rs.close();
				continue;				
			}
			rs.close();
			
			
			// �s�W��ƨ���y
			String errMsg = this.insertDataToStu(dbManager, session, eachStu, stno,z,true);
			if(!errMsg.equals("")){
				errResult=errMsg;
	            throw new Exception();				
			}	
				
			// �s�W��ƨ��v��
			errMsg = this.insertDataToAut(dbManager, session, eachStu, stno);
			if(!errMsg.equals("")){
				errResult=errMsg;
	            throw new Exception();
			}

			// �s�W��ƨ�X��
			errMsg = this.insertDataToPub(dbManager, conn, session, eachStu, stno);
			if(!errMsg.equals("")){
				errResult=errMsg;
	            throw new Exception();
			}

			// �p�ӥͦ����D�׫h�ݰ����ʧ@
			if(isDoubleMajor.equals("Y")){
				errMsg = this.giveupDoubleMajor(dbManager, conn, session, eachStu, stno);
				if(!errMsg.equals("")){
					errResult=errMsg;
	            	throw new Exception();
				}
			}

			// �s�W�����M���߻�ê��Ʀ�SGUT004
			if(!(originRace.equals("") || handicapType.equals("") || handicapGrade.equals(""))){
				errMsg = this.insertDataToSgu(dbManager, conn, session, eachStu, stno);
				if(!errMsg.equals("")){
					errResult=errMsg;
	            	throw new Exception();
				}
			}

			// ��sSOLT009
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
    	out.println(DataToJson.faileJson(errResult.equals("")?"����妸�����ɵo�Ϳ��~":errResult));
        ex.printStackTrace();
    }
    finally
    {
        if (dbManager != null)
        	dbManager.close();
    }
}

// �g�J��Ʀܾ��y�ɤ�
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
		stuAdd.setEDUBKGRD(rowHt.get("EDUBKGRD").toString().replaceAll(",","").replaceAll("��L",""));
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
			stuAdd.setSTTYPE_CHECK(true);//�¿���s��
			stuAdd.setUPD_MK("2");//��s
		}else{
			if(regCheck){
				stuAdd.setUPD_MK("1");//�s�W
			}else{
				stuAdd.setUPD_MK("2");//��s
			}
			stuAdd.setENROLL_AYEARSMS((String)rowHt.get("AYEAR") + (String)rowHt.get("SMS"));							
		}
		a = stuAdd.execute();		
	}catch(Exception e){
		e.printStackTrace();		
	}

	return a;
}

// �g�J��Ʀܾ��y�ɤ�
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
		stuAdd.setEDUBKGRD(rowHt.get("EDUBKGRD").toString().replaceAll(",","").replaceAll("��L",""));
		stuAdd.setEDUBKGRD_AYEAR((String)rowHt.get("EDUBKGRD_AYEAR"));
		stuAdd.setPRE_MAJOR_FACULTY((String)rowHt.get("PRE_MAJOR_FACULTY"));
		stuAdd.setJ_FACULTY_CODE((String)rowHt.get("J_FACULTY_CODE"));
		stuAdd.setTUTOR_CLASS_MK((String)rowHt.get("TUTOR_CLASS_MK"));		
		//by poto 20091207 teno�n�D�űM�ͤ]�n��JFTSTUD_ENROLL_AYEARSMS,FTSTUD_CENTER_CODE
		stuAdd.setFTSTUD_ENROLL_AYEARSMS((String)rowHt.get("AYEAR") + (String)rowHt.get("SMS"));
		stuAdd.setFTSTUD_CENTER_CODE((String)rowHt.get("CENTER_CODE"));
		stuAdd.setNATIONCODE(Utility.nullToSpace(rowHt.get("NATIONCODE")));
		stuAdd.setSPECIAL_STTYPE_TYPE(Utility.nullToSpace(rowHt.get("SPECIAL_STTYPE_TYPE")));
		stuAdd.setIDNO_CHECK(UtilityX.stuIdnoChk(Utility.nullToSpace(rowHt.get("NATIONCODE"))));
		System.out.println("z="+z);					
		System.out.println("regCheck="+regCheck);
		if(z == 1){
			stuAdd.setSTTYPE_CHECK(true);//�¿���s��
			stuAdd.setUPD_MK("2");//��s
		}else{
			
			if(regCheck){
				stuAdd.setUPD_MK("1");//�s�W
			}else{
				stuAdd.setUPD_MK("2");//��s
			}
			
			stuAdd.setENROLL_AYEARSMS((String)rowHt.get("AYEAR") + (String)rowHt.get("SMS"));							
		}
		
		if(stuAdd.execute()!=stuAdd.SUCCESS){
			result="�����Ҧr��:"+idno+"����s�W��Ʀܾ��y���Ƶ{����,�o�Ϳ��~!"+stuAdd.getAllError();
		}
		if(stuAdd.hasNextError()){
			System.out.println("ERRORS="+stuAdd.nextError()+"---EDUBKGRD1:"+rowHt.get("EDUBKGRD")+"---EDUBKGRD2:"+rowHt.get("EDUBKGRD").toString().replaceAll(",",""));
		}
		
	}catch(Exception e){
		e.printStackTrace();
		result = "�����Ҧr��:"+idno+",�s�W��Ʀܾ��y�ɵo�Ϳ��~";
	}

	return result;
}

// �g�J��Ʀ��v���ɤ�
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
			result="�����Ҧr��:"+idno+"����s�W��Ʀ��v���t�Ϊ��Ƶ{����,�o�Ϳ��~!"+autAdd.getAllError();
		}
	}catch(Exception e){
		e.printStackTrace();
		result = "�����Ҧr��:"+idno+",�s�W��Ʀ��v���t�ήɵo�Ϳ��~";
	}

	return result;
}

//�g�J��ƦܥX���ɤ�
private String insertDataToPub(DBManager dbManager, Connection conn, HttpSession session, Hashtable rowHt, String stno){
	String result = "";
	String idno = Utility.nullToSpace(rowHt.get("IDNO"));

	try{
		PubAddStu pubAdd = new PubAddStu(dbManager, conn, session);
		pubAdd.setBIRTHDATE((String)rowHt.get("BIRTHDATE"));
		pubAdd.setIDNO((String)rowHt.get("IDNO"));
		pubAdd.setSTNO(stno);

		if(pubAdd.execute()!=pubAdd.SUCCESS){
			result="�����Ҧr��:"+idno+"����s�W��ƦܥX���t�Ϊ��Ƶ{����,�o�Ϳ��~!"+pubAdd.getAllError();
		}
	}catch(Exception e){
		e.printStackTrace();
		result = "�����Ҧr��:"+idno+",�s�W��ƦܥX���t�ήɵo�Ϳ��~";
	}

	return result;
}

// ������D�׸��
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
			result="�����Ҧr��:"+idno+"���������D�ת��Ƶ{����,�o�Ϳ��~!"+stuDis.getAllError();
		}
	}catch(Exception e){
		e.printStackTrace();
		result = "�����Ҧr��:"+idno+",���������D�׮ɵo�Ϳ��~";
	}

	return result;
}

// �s�W�����M���߻�ê��Ʀ�SGUT004
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
			result="�����Ҧr��:"+idno+"�s�W�����M���߻�ê��ƪ��Ƶ{����,�o�Ϳ��~!"+SGUT004.getAllError();
		}
	}catch(Exception e){
		e.printStackTrace();
		result = "�����Ҧr��:"+idno+",�s�W�����M���߻�ê��Ʈɵo�Ϳ��~";
	}

	return result;
}

/** �R����� */
public void doDelete(JspWriter out, DBManager dbManager, Hashtable requestMap, HttpSession session) throws Exception
{
    try
    {
        Connection    conn        =    dbManager.getConnection(AUTCONNECT.mapConnect("SOL", session));

        /** �R������ */
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

        /** �B�z�R���ʧ@ */
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
	// ���߼f�d
	boolean isAuditResult = Utility.nullToSpace(requestMap.get("AUDIT_RESULT")).equals("0")||Utility.nullToSpace(requestMap.get("AUDIT_RESULT")).equals("4");
	// �аȳB�f�d
	boolean isTotalResult = Utility.nullToSpace(requestMap.get("TOTAL_RESULT")).equals("0")||Utility.nullToSpace(requestMap.get("TOTAL_RESULT")).equals("4");
	
	
	//return (depType.equals("43")&&isAuditResult)||(depType.equals("33")&&isTotalResult);
	return (depType.equals("43")&&isAuditResult)||(depType.equals("33")&&false);
}

/**
*�P�_�p�G�O �аȳB �B �L�O�q�L��a�ɥ� �B �L�w�g���Ǹ��F �N���n�b�M�žǸ��F
**/
private boolean isAudit_1(HttpSession session, Hashtable requestMap)throws Exception{
	Hashtable autHt = Permision.processAllPermision(session);
	String depType = autHt.get("DEP_TYPE").toString();
	// �аȳB�f�d
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

/** �ˬd���y���A*/
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

/** �h�f��� */
public void doReject(JspWriter out, DBManager dbManager, Hashtable requestMap, HttpSession session) throws Exception
{
    try
    {
        Connection    conn        =    dbManager.getConnection(AUTCONNECT.mapConnect("SOL", session));

        /** �R������ */
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
       			throw new Exception("doReject���ѼƨS��Ū��");
       		}
        	
       
        	/** �B�z�ק�ʧ@solt007 */
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