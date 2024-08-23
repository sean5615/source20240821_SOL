<%/*
----------------------------------------------------------------------------------
File Name        : sol0051_01m1.jsp
Author            : ����L
Description        : SOL0051_�n�����W�ǥ͸�� - �B�z�޿譶��
Modification Log    :

Vers        Date           By                Notes
--------------    --------------    --------------    ----------------------------------
1.0.0        097/07/30    barry         �s�W�S��͵��O(SPECIAL_STTYPE_TYPE)���
0.0.1        096/02/27    ����L        Code Generate Create
----------------------------------------------------------------------------------
*/%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="MS950"%>
<%@ include file="/utility/header.jsp"%>
<%@ include file="/utility/modulepageinit.jsp"%>
<%@ page import="com.acer.util.DateUtil"%>
<%@ page import="com.nou.sys.*"%>
<%@ page import="com.nou.sys.dao.*"%>
<%@ page import="com.nou.aut.dao.*"%>
<%@ page import="com.nou.stu.dao.*"%>
<%@ page import="com.nou.stu.STUADDDATA"%>
<%@ page import="com.nou.stu.bo.STUDISDBMAJOR"%>
<%@ page import="com.nou.sol.*"%>
<%@ page import="com.nou.sol.bo.*"%>
<%@ page import="com.nou.sol.dao.*"%>
<%@ page import="com.nou.pcs.bo.*"%>
<%@ page import="com.nou.pcs.dao.*"%>
<%@ page import="com.nou.aut.bo.AUTADDUSER"%>
<%@ page import="com.nou.sgu.bo.*"%>
<%@ page import="com.acer.log.MyLogger"%>
<%@ page import="com.acer.db.DBManager"%>
<%@ page import="com.nou.pub.bo.PubAddStu"%>

<%!
/** �B�z�d�� Grid ��� */
public void doQuery(JspWriter out, DBManager dbManager, Hashtable requestMap, HttpSession session) throws Exception
{
    Connection    conn    =    null;
    DBResult    rs    =    null;

    try
    {
        conn    =    dbManager.getConnection(AUTCONNECT.mapConnect("NOU", session));

        int        pageNo        =    Integer.parseInt(Utility.checkNull(requestMap.get("pageNo"), "1"));
        int        pageSize    =    Integer.parseInt(Utility.checkNull(requestMap.get("pageSize"), "10"));
        StringBuffer    sql        =    new StringBuffer();

        /* === LoadingBar === */
        dbManager.logger.append("(S)�}�l�զ��d�߱���");
        LoadingStatus.setStatus(session.getId(), 30, "(S)�}�l�զ��d�߱���", LoadingStatus.process);

        sql.append
        (
            "SELECT SOLT003.ASYS, SOLT003.AYEAR, SOLT003.SMS, SOLT003.CENTER_CODE, SOLT003.STTYPE, SOLT003.IDNO, SOLT003.BIRTHDATE,SOLT003.NATIONCODE " +
            "FROM  SOLT003 " +
            "WHERE " +
            "1    =    1 "
        );

        /** == �d�߱��� ST == */
        if(!Utility.checkNull(requestMap.get("IDNO"), "").equals(""))
            sql.append("AND SOLT003.IDNO    =    '" + Utility.dbStr(requestMap.get("IDNO"))+ "'");
        if(!Utility.checkNull(requestMap.get("BIRTHDATE"), "").equals(""))
            sql.append("AND SOLT003.BIRTHDATE    =    '" + Utility.dbStr(requestMap.get("BIRTHDATE"))+ "'");
        /** == �d�߱��� ED == */

        sql.append(" ORDER BY SOLT003.ASYS, SOLT003.AYEAR, SOLT003.SMS, SOLT003.CENTER_CODE, SOLT003.STTYPE, SOLT003.IDNO, SOLT003.BIRTHDATE");


        /* === LoadingBar === */
        LoadingStatus.setStatus(session.getId(), 40, "(S)Page ����I�s����, �}�l�B�z���", LoadingStatus.success);

        rs    =    Page.getPageResultSet(dbManager, conn, sql.toString(), pageNo, pageSize);

        /** ���B�~�B�z�d��, �аѦ� Sample.txt */

        out.println(DataToJson.rsToJson (Page.getTotalRowCount(), rs));
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

        rs    =    null;
        conn    =    null;
    }
}

/** �ק�s�� */
public void doAdd(JspWriter out, DBManager dbManager, Hashtable requestMap, HttpSession session) throws Exception
{
	Connection	conn	=	null;
	int x = 5;
	try
	{
		/* === LoadingBar === */
        LoadingStatus.setStatus(session.getId(), 30, "(S)�ǳ��x�s���", LoadingStatus.process);
        
        /* === LoadingBar === */
        LoadingStatus.setStatus(session.getId(), 40, "(S)�}�l�x�s SOLT005 ���", LoadingStatus.process);
        
        String code = (String) requestMap.get("PRE_MAJOR_FACULTY");
        requestMap.put("PRE_MAJOR_FACULTY", code.substring(0, 2));
        requestMap.put("J_FACULTY_CODE", code.substring(2));
        
        String serNo = (String) requestMap.get("SERNO");
        if("".equals(serNo)){
        	requestMap.put("REG_MANNER", "2");
        }else if(!"".equals(serNo)){
        	requestMap.put("REG_MANNER", "1");
        }
        
        String e1 = (String) requestMap.get("edubkgrd1");
        String e2 = (String) requestMap.get("edubkgrd2");
        String e3 = (String) requestMap.get("edubkgrd3");
        StringBuffer edubkgrd = new StringBuffer();
		edubkgrd.append(e1 == null ? "" : e1);
		edubkgrd.append(",");
		edubkgrd.append(e2 == null ? "" : e2);
		edubkgrd.append(",");
		edubkgrd.append(e3 == null ? "" : e3);
		requestMap.put("EDUBKGRD", edubkgrd.toString());
		
		conn = dbManager.getConnection(AUTCONNECT.mapConnect("NOU", session));
		String specialStudent = Utility.checkNull(requestMap.get("SPECIAL_STUDENT"), "");
		// �f�d�q�L�h���Ǹ�
        String STNO = Utility.checkNull(requestMap.get("STNO"), "");
		//�¿���s���ϥέ�Ǹ�
		if(STNO.equals("")){
			if("0".equals((String) requestMap.get("AUDIT_RESULT")) || "4".equals((String) requestMap.get("AUDIT_RESULT"))){
	        	//���o�Ǹ�
	    		SOLGETSTNO sysSTNO = new SOLGETSTNO(dbManager);

	    		sysSTNO.setASYS(Utility.dbStr(requestMap.get("ASYS")));
	    		sysSTNO.setAYEAR(Utility.dbStr(requestMap.get("AYEAR")));
	    		sysSTNO.setSMS(Utility.dbStr(requestMap.get("SMS")));
	    		//�令 �Ťj�űM���ݿ�JCENTER_CODE 2008/10/05 by barry
	    		sysSTNO.setCENTER_CODE(Utility.dbStr(requestMap.get("CENTER_CODE")));
	    		sysSTNO.execute();
	    		STNO = sysSTNO.getSTNO();
				STUADDDATA stuAdd = new STUADDDATA(dbManager);
				stuAdd.setUSER_ID((String)session.getAttribute("USER_ID"));
				stuAdd.setAYEAR((String)requestMap.get("AYEAR"));
				stuAdd.setSMS((String)requestMap.get("SMS"));
				stuAdd.setIDNO((String)requestMap.get("IDNO"));
				stuAdd.setBIRTHDATE((String)requestMap.get("BIRTHDATE"));
				stuAdd.setCENTER_CODE((String)requestMap.get("CENTER_CODE"));
				//���W�����O���O��ץ͡A�[��H�U���(�Q�f����)      2008/11/22 by barry 
				if(!"2".equals(Utility.checkNull(requestMap.get("STTYPE"), "")))
				{
					stuAdd.setFTSTUD_CENTER_CODE((String)requestMap.get("CENTER_CODE"));
					stuAdd.setFTSTUD_ENROLL_AYEARSMS((String)requestMap.get("AYEAR") + (String)requestMap.get("SMS"));
				}
				stuAdd.setSTTYPE((String)requestMap.get("STTYPE"));
				stuAdd.setNAME((String)requestMap.get("NAME"));
				stuAdd.setENG_NAME((String)requestMap.get("ENG_NAME"));
				stuAdd.setSEX((String)requestMap.get("SEX"));
				stuAdd.setSELF_IDENTITY_SEX((String)requestMap.get("SELF_IDENTITY_SEX"));
				stuAdd.setALIAS((String)requestMap.get("ALIAS"));
				stuAdd.setVOCATION((String)requestMap.get("VOCATION"));
				stuAdd.setEDUBKGRD_GRADE((String)requestMap.get("EDUBKGRD_GRADE"));
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
				stuAdd.setSTNO(STNO);
				stuAdd.setENROLL_AYEARSMS((String)requestMap.get("AYEAR") + (String)requestMap.get("SMS"));
				stuAdd.setEMRGNCY_NAME((String)requestMap.get("EMRGNCY_NAME"));
				stuAdd.setEMRGNCY_TEL((String)requestMap.get("EMRGNCY_TEL"));
				stuAdd.setEDUBKGRD(requestMap.get("EDUBKGRD").toString().replaceAll(",","").replaceAll("��L",""));
				stuAdd.setEDUBKGRD_AYEAR((String)requestMap.get("EDUBKGRD_AYEAR"));
				stuAdd.setPRE_MAJOR_FACULTY((String)requestMap.get("PRE_MAJOR_FACULTY"));
				stuAdd.setJ_FACULTY_CODE((String)requestMap.get("J_FACULTY_CODE"));
				stuAdd.setTUTOR_CLASS_MK((String)requestMap.get("TUTOR_CLASS_MK"));
				stuAdd.setEDUBKGRD_AYEAR((String)requestMap.get("EDUBKGRD_AYEAR"));
				stuAdd.setRESIDENCE_DATE(Utility.nullToSpace(requestMap.get("RESIDENCE_DATE")));
				stuAdd.setSPECIAL_STTYPE_TYPE(Utility.nullToSpace(requestMap.get("SPECIAL_STTYPE_TYPE")));
				stuAdd.setFROM_PROG_CODE("SOL005M");
				stuAdd.setUPD_MK("1");//�s�W
				
				
				if("3".equals(requestMap.get("idtype"))) {
					stuAdd.setIDNO_CHECK(false);
					stuAdd.setPASSPORT_NO((String)requestMap.get("IDNO"));
				} else {
					stuAdd.setIDNO_CHECK(UtilityX.stuIdnoChk(Utility.nullToSpace(requestMap.get("NATIONCODE"))));
				}
				
				
				stuAdd.setNATIONCODE(Utility.nullToSpace(requestMap.get("NATIONCODE")));
				stuAdd.setNEWNATION(Utility.nullToSpace(requestMap.get("NEWNATION")));
				x = stuAdd.execute();
				System.out.println("ERRORS="+stuAdd.nextError());
				if(x == 1){
					System.out.println("�s�W���y��Ƨ���");
					x = 5;
					AUTADDUSER autAdd = new AUTADDUSER(dbManager);
					autAdd.setUSER_ID(STNO);
					autAdd.setASYS((String)requestMap.get("ASYS"));
					autAdd.setDEP_CODE((String)requestMap.get("CENTER_CODE"));
					autAdd.setID_TYPE("1");
					autAdd.setUSER_NM((String)requestMap.get("NAME"));
					autAdd.setUSER_IDNO((String)requestMap.get("IDNO"));
					autAdd.setUPD_USER_ID((String)session.getAttribute("USER_ID"));
					autAdd.setINSERT_PRESENT_STATUS("1");
					
					if("3".equals(requestMap.get("idtype"))) {
						autAdd.setIDNO_CHECK(false);
					} else {
						autAdd.setIDNO_CHECK(UtilityX.stuIdnoChk(Utility.nullToSpace(requestMap.get("NATIONCODE"))));
					}
					
					x = autAdd.execute();
					if(x == 1){
						System.out.println("�s�W�v����Ƨ���");
						x = 5;
						//�N�ǥ͸����JPUB 2008/05/12 by barry
						PubAddStu pubAdd = new PubAddStu(dbManager, conn, session);
						pubAdd.setBIRTHDATE((String)requestMap.get("BIRTHDATE"));
						pubAdd.setIDNO((String)requestMap.get("IDNO"));
						pubAdd.setSTNO(STNO);
						
						
						if("3".equals(requestMap.get("idtype"))) {
							pubAdd.setIDNO_CHECK(false);
						} else {
							pubAdd.setIDNO_CHECK(UtilityX.stuIdnoChk(Utility.nullToSpace(requestMap.get("NATIONCODE"))));
						}
						
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
							    stuDis.setIDNO((String)requestMap.get("IDNO"));
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
						dbManager.rollback();
					}
					//�s�W�����M���߻�ê��Ʀ�SGUT004
					if(!(Utility.nullToSpace(requestMap.get("ORIGIN_RACE")).equals("") || Utility.nullToSpace(requestMap.get("ORIGIN_RACE")).equals("0")) || !(Utility.nullToSpace(requestMap.get("HANDICAP_TYPE")).equals("") || Utility.nullToSpace(requestMap.get("HANDICAP_TYPE")).equals("00")) )
					{
						SGUUPDSGUT004 SGUT004 = new SGUUPDSGUT004(dbManager);
						SGUT004.setSTNO(STNO);
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
						x = SGUT004.execute();
						System.out.println("ERRORS="+SGUT004.nextError());
						if(x == 1){
							System.out.println("�s�WSGUT004��Ƨ���");
						}else{
							System.out.println("�s�WSGUT004��ƥ���");
							dbManager.rollback();
						}
					}
				}else{
					System.out.println("�s�W���y��ƥ���");
					dbManager.rollback();
				}
	        }
		}else{
			if("0".equals((String) requestMap.get("AUDIT_RESULT")) || "4".equals((String) requestMap.get("AUDIT_RESULT")))
			{
				//�¿���s��(��s�J�ǾǦ~���A�Φ���J�����)
				STUADDDATA stuAdd = new STUADDDATA(dbManager);
				stuAdd.setUSER_ID((String)session.getAttribute("USER_ID"));
				stuAdd.setAYEAR((String)requestMap.get("AYEAR"));
				stuAdd.setSMS((String)requestMap.get("SMS"));
				stuAdd.setIDNO((String)requestMap.get("IDNO"));
				stuAdd.setBIRTHDATE((String)requestMap.get("BIRTHDATE"));
				stuAdd.setCENTER_CODE((String)requestMap.get("CENTER_CODE"));
				//���W�����O���O��ץ͡A�[��H�U���(�Q�f����)      2008/11/22 by barry
				if(!"2".equals(Utility.checkNull(requestMap.get("STTYPE"), "")))
				{
					stuAdd.setFTSTUD_CENTER_CODE((String)requestMap.get("CENTER_CODE"));
					stuAdd.setFTSTUD_ENROLL_AYEARSMS((String)requestMap.get("AYEAR") + (String)requestMap.get("SMS"));
				}
				stuAdd.setSTTYPE((String)requestMap.get("STTYPE"));
				stuAdd.setNAME((String)requestMap.get("NAME"));
				stuAdd.setENG_NAME((String)requestMap.get("ENG_NAME"));
				stuAdd.setSEX((String)requestMap.get("SEX"));
				stuAdd.setSELF_IDENTITY_SEX((String)requestMap.get("SELF_IDENTITY_SEX"));
				stuAdd.setALIAS((String)requestMap.get("ALIAS"));
				stuAdd.setVOCATION((String)requestMap.get("VOCATION"));
				stuAdd.setEDUBKGRD_GRADE((String)requestMap.get("EDUBKGRD_GRADE"));
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
				stuAdd.setSTNO(STNO);
				//���sENROLL_AYEARSMS��令��sFTSTUD_ENROLL_AYEARSMS(�Q�f����)  2008/05/09 by barry  
				stuAdd.setFTSTUD_ENROLL_AYEARSMS((String)requestMap.get("AYEAR") + (String)requestMap.get("SMS"));
				stuAdd.setEMRGNCY_NAME((String)requestMap.get("EMRGNCY_NAME"));
				stuAdd.setEMRGNCY_TEL((String)requestMap.get("EMRGNCY_TEL"));
				stuAdd.setEDUBKGRD(requestMap.get("EDUBKGRD").toString().replaceAll(",","").replaceAll("��L",""));	
				stuAdd.setEDUBKGRD_AYEAR((String)requestMap.get("EDUBKGRD_AYEAR"));
				stuAdd.setPRE_MAJOR_FACULTY((String)requestMap.get("PRE_MAJOR_FACULTY"));
				stuAdd.setJ_FACULTY_CODE((String)requestMap.get("J_FACULTY_CODE"));
				stuAdd.setTUTOR_CLASS_MK((String)requestMap.get("TUTOR_CLASS_MK"));
				stuAdd.setSPECIAL_STTYPE_TYPE((String)requestMap.get("SPECIAL_STTYPE_TYPE"));
				stuAdd.setRESIDENCE_DATE(Utility.nullToSpace(requestMap.get("RESIDENCE_DATE")));
				stuAdd.setFROM_PROG_CODE("SOL005M");
				//by poto �¿���s�����ˮ�
				String AyearSms = requestMap.get("AYEAR").toString().substring(1) + requestMap.get("SMS").toString();
				String STNO_CHECK = STNO.substring(0,3);
				if("1".equals((String)requestMap.get("ASYS"))&&!STNO_CHECK.equals(AyearSms)){
					stuAdd.setSTTYPE_CHECK(true);
				}
				
				if("3".equals(requestMap.get("idtype"))) {
					stuAdd.setIDNO_CHECK(false);
					stuAdd.setPASSPORT_NO((String)requestMap.get("IDNO"));
				} else {
					stuAdd.setIDNO_CHECK(UtilityX.stuIdnoChk(Utility.nullToSpace(requestMap.get("NATIONCODE"))));
				}
				
				
				stuAdd.setNATIONCODE(Utility.nullToSpace(requestMap.get("NATIONCODE")));
				stuAdd.setNEWNATION(Utility.nullToSpace(requestMap.get("NEWNATION")));
				
				stuAdd.setUPD_MK("2");//��s
				x = stuAdd.execute();
				System.out.println("ERRORS="+stuAdd.nextError());
				if(x == 1)
				{
					System.out.println("��s���y��Ƨ���");
					x = 5;
					//�N�ǥ͸����JPUB 2008/05/12 by barry
					PubAddStu pubAdd = new PubAddStu(dbManager, conn, session);
					pubAdd.setBIRTHDATE((String)requestMap.get("BIRTHDATE"));
					pubAdd.setIDNO((String)requestMap.get("IDNO"));
					pubAdd.setSTNO(STNO);
					
					if("3".equals(requestMap.get("idtype"))) {
						pubAdd.setIDNO_CHECK(false);
					} else {
						pubAdd.setIDNO_CHECK(UtilityX.stuIdnoChk(Utility.nullToSpace(requestMap.get("NATIONCODE"))));
					}
					
					x = pubAdd.execute();
					if(x == 1)
					{
						System.out.println("�s�W�X����Ƨ���");
					}else{
						System.out.println("�s�W�X����ƥ���");
						dbManager.rollback();
					}
				}else{
					System.out.println("��s���y��ƥ���");
					dbManager.rollback();
				}
				
				//�s�W�����M���߻�ê��Ʀ�SGUT004
				if(!(Utility.nullToSpace(requestMap.get("ORIGIN_RACE")).equals("") || Utility.nullToSpace(requestMap.get("ORIGIN_RACE")).equals("0")) || !(Utility.nullToSpace(requestMap.get("HANDICAP_TYPE")).equals("") || Utility.nullToSpace(requestMap.get("HANDICAP_TYPE")).equals("00")) )
				{
					SGUUPDSGUT004 SGUT004 = new SGUUPDSGUT004(dbManager);
					SGUT004.setSTNO(STNO);
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
					x = SGUT004.execute();
					System.out.println("ERRORS="+SGUT004.nextError());
					if(x == 1){
						System.out.println("�s�WSGUT004��Ƨ���");
					}else{
						System.out.println("�s�WSGUT004��ƥ���");
					}
				}
	        }
			x = 1;
		}
		
		if("0".equals((String) requestMap.get("AUDIT_RESULT")) || "4".equals((String) requestMap.get("AUDIT_RESULT")))
			requestMap.put("STNO", STNO);
		else
			requestMap.remove("STNO");
        
        requestMap.put("UPD_RMK", "1");
		if(x==1 || Utility.checkNull(requestMap.get("STNO"), "").equals(""))
		{
			// ���o���U�ǶO
			SOLPAY_FEE_EDATE edate = new SOLPAY_FEE_EDATE(dbManager, conn);
			Hashtable clsFee = new Hashtable();
			clsFee.put("AYEAR", (String) requestMap.get("AYEAR"));
			clsFee.put("SMS", (String) requestMap.get("SMS"));
			clsFee.put("ASYS", (String) requestMap.get("ASYS"));
			String edateStr = edate.SOLPAY_FEE_EDATE(clsFee, "3");
			
			SOLGETREGFEEBO treFee = new SOLGETREGFEEBO(dbManager, conn);
			String fee = treFee.GETREGFEE(clsFee);
			
			if("5".equals(specialStudent) || "13".equals(specialStudent) || "14".equals(specialStudent) || "2".equals(specialStudent)){
				fee = "0";
			}
			
			if(!Utility.nullToSpace(requestMap.get("NPAYMENT_BAR")).equals("")){
				fee = "0";
			}
			
			// ��o�Ťj�ۥͰT���ӷ�
			Vector dataVt = DBUtil.getSQLData("sol007m_.jsp", "NOU", "SELECT CODE, CODE_NAME FROM SYST001 WHERE KIND = 'GETINFO' ORDER BY CODE");
			VtResultSet rs1	=	new VtResultSet(dataVt);
			String GETINFO = "";
			String GETINFO_TMP = "";
			//System.out.println("requestMap="+requestMap);
			while(rs1.next()) {
				String CODE = rs1.getString("CODE");
				//System.out.println("CODE=" + CODE);
				GETINFO_TMP = UtilityX.checkNull(requestMap.get("GETINFO_"+CODE), "");
				//GETINFO_TMP = requestMap.get("GETINFO_"+CODE);
				//System.out.println("GETINFO_TMP=" + GETINFO_TMP);
				if (GETINFO_TMP.length()>0){
					if (GETINFO.length()>0){
						GETINFO += ",";
					}
					GETINFO +=GETINFO_TMP;
				}
				//s.append("<input type='checkbox' id='GETINFO_"+rs.getString("CODE")+"' name='GETINFO_"+rs.getString("CODE")+"' value='"+rs.getString("CODE")+"' >"+rs.getString("CODE_NAME")+"&nbsp;&nbsp;");	
			}
			
			requestMap.remove("GETINFO");
	        requestMap.put("GETINFO",GETINFO);
			// SOLT003-�򥻸��
			SOLT003DAO solt003Dao = new SOLT003DAO(dbManager, conn, requestMap, (String)session.getAttribute("USER_ID"));
			solt003Dao.insert();
		
			// SOLT009-�S��͸��
			System.out.println("specialStudent"+specialStudent);
			if ("2".equals(specialStudent) || "4".equals(specialStudent) || "5".equals(specialStudent) 
				|| "13".equals(specialStudent) || "14".equals(specialStudent)) {
				STUT003DAO STU = new STUT003DAO(dbManager, conn);
				STU.setResultColumn(" STNO ");
				STU.setWhere(" ASYS ='" + Utility.dbStr((String) requestMap.get("ASYS")) + "' AND IDNO = '" + Utility.dbStr((String) requestMap.get("IDNO"))
						+ "' AND BIRTHDATE='" + Utility.dbStr((String) requestMap.get("BIRTHDATE")) + "'");
				DBResult rs = STU.query();
				String STNO_TMP = "";
				while (rs.next()) {
					if (!rs.getString(1).equals("")) {
						STNO_TMP = rs.getString(1);
					}
				}
				
				Hashtable ss = new Hashtable();
				ss.put("ASYS", (String) requestMap.get("ASYS"));
				ss.put("AYEAR", (String) requestMap.get("AYEAR"));
				ss.put("SMS", (String) requestMap.get("SMS"));
				ss.put("IDNO", (String) requestMap.get("IDNO"));
				ss.put("N_STNO", STNO_TMP);
				ss.put("STNO", "");
				String sql2 = " select count(*) NUM from solt009 where AYEAR ='" + requestMap.get("AYEAR").toString() + "' " + 
			              " and SMS = '" + requestMap.get("SMS").toString() + "' " + 
						  " and IDNO = '" + requestMap.get("IDNO").toString() + "' ";
				rs	= dbManager.getSimpleResultSet(conn);
				rs.open();
				rs.executeQuery(sql2);
				String SOLT009_NUM = "";
				if(rs.next())
		            SOLT009_NUM = rs.getString("NUM");
				SOLT009DAO solt009 = new SOLT009DAO(dbManager, conn, ss, (String)session.getAttribute("USER_ID"));
				if(SOLT009_NUM.equals("0"))
					solt009.insert();
				else
					solt009.update("AYEAR='" + requestMap.get("AYEAR").toString() + "' " + " and SMS = '" + requestMap.get("SMS").toString() + "' " + " and IDNO = '" + requestMap.get("IDNO").toString() + "' ");
			}
		
			GETWRITEOFF_NO writeoffNo = new GETWRITEOFF_NO(dbManager, conn);

			writeoffNo.setAYEAR(Utility.dbStr((String) requestMap.get("AYEAR")));
			writeoffNo.setSMS(Utility.dbStr((String) requestMap.get("SMS")));
			
			// 1:�i�ϥ�  2:�O�����W
			if("1".equals((String)requestMap.get("LIMIT")))
				writeoffNo.setPAYMENT_TYPE("1" + Utility.dbStr((String) requestMap.get("ASYS")));	//ú�O���O  1 �ۥ� 1�Ťj 2�M�� 3�Ŭ�
			else if("2".equals((String)requestMap.get("LIMIT")))
				writeoffNo.setPAYMENT_TYPE("1" + Utility.dbStr((String) requestMap.get("ASYS")));	//ú�O���O  1 �ۥ� 1�Ťj 2�M�� 3�Ŭ�
				// �ȮɱN�U�C����,�U�C��ú�O�覡���u���O,�ثe�O��ú�O����u���O
		//		writeoffNo.setPAYMENT_TYPE("5" + Utility.dbStr((String) requestMap.get("ASYS")));	//�p�G�O�� ú�O���O  5 �O�� 1�Ťj 2�M�� 3�Ŭ�
			writeoffNo.setPAYMENT_EDATE(edateStr);
			writeoffNo.setUPD_ID(Utility.dbStr((String)session.getAttribute("USER_ID")));
			writeoffNo.setMONEY(fee);
			writeoffNo.setSTNO(STNO);
			writeoffNo.setASYS(Utility.dbStr((String) requestMap.get("ASYS")));
			writeoffNo.setIDNO(Utility.dbStr((String) requestMap.get("IDNO")));
			writeoffNo.setCENTER_CODE(Utility.dbStr((String) requestMap.get("CD")));
			writeoffNo.setWR_MANNER("3"); //1.����2.�q�H3.�{��
			String strWRITEOFF_NO = null;
			String botBarcode = null;
			String csBarcode1 = null;
			String csBarcode2 = null;
			String POST_BARCODE1 = "";
			String POST_BARCODE2 = "";
			String POST_BARCODE3 = "";
			if (writeoffNo.execute() == 1) {
				strWRITEOFF_NO = writeoffNo.getWRITEOFF_NO();
				botBarcode = writeoffNo.getCS_BARCODE();
				csBarcode1 = writeoffNo.getCS_BARCODE1();
				csBarcode2 = writeoffNo.getCS_BARCODE2();
				POST_BARCODE1 = writeoffNo.getPOST_BARCODE1();
				POST_BARCODE2 = writeoffNo.getPOST_BARCODE2();
				POST_BARCODE3 = writeoffNo.getPOST_BARCODE3();
			}
			session.setAttribute("SOLT0051_WRITEOFF_NO", strWRITEOFF_NO);
			session.setAttribute("SOLT0051_NAME", (String) requestMap.get("NAME"));
			session.setAttribute("SOLT0051_AYEAR", (String) requestMap.get("AYEAR"));
			
			// SOLT007-����ú�O��
			Hashtable pi = new Hashtable();
			pi.put("ASYS", (String) requestMap.get("ASYS"));
			pi.put("AYEAR", (String) requestMap.get("AYEAR"));
			pi.put("SMS", (String) requestMap.get("SMS"));
			pi.put("IDNO", (String) requestMap.get("IDNO"));
			pi.put("BIRTHDATE", (String) requestMap.get("BIRTHDATE"));
			pi.put("WRITEOFF_NO", strWRITEOFF_NO);
			pi.put("PAYABLE_AMT", fee);
			
			if("5".equals((String) requestMap.get("PAYMENT_METHOD")) || "6".equals((String) requestMap.get("PAYMENT_METHOD"))){
				requestMap.put("PAYMENT_STATUS", "2");
			}
		
			if("5".equals(specialStudent) || "13".equals(specialStudent) || "14".equals(specialStudent) || "2".equals(specialStudent)){
				pi.put("PAYMENT_STATUS", "2");
			}else{
				pi.put("PAYMENT_STATUS", (String) requestMap.get("PAYMENT_STATUS"));
			}
			
			//�wú�O
			if("2".equals((String) requestMap.get("PAYMENT_STATUS"))){
				pi.put("PAID_AMT", fee);
			}else{//��ú�O
				pi.put("PAID_AMT", "0");
			}
			
			pi.put("ORDER_DATE", DateUtil.getNowDate());
			pi.put("ABNDN_EXER", (String)session.getAttribute("USER_ID"));
			pi.put("ABNDN_DATE", Utility.dbStr(DateUtil.getNowDate()));
			pi.put("NPAYMENT_BAR", (String) requestMap.get("NPAYMENT_BAR"));
			pi.put("BOT_BARCODE", botBarcode);
			pi.put("CS_BARCODE1", csBarcode1);
			pi.put("CS_BARCODE2", csBarcode2);
			pi.put("POST_BARCODE1",POST_BARCODE1);
			pi.put("POST_BARCODE2",POST_BARCODE2);
			pi.put("POST_BARCODE3",POST_BARCODE3);

			
			SOLT007DAO solt007 = new SOLT007DAO(dbManager, conn, pi, (String)session.getAttribute("USER_ID"));
			solt007.insert();
			
			// SOLT006-���ͩۥͼf�d���
			Hashtable ei = new Hashtable();
			ei.put("ASYS", (String) requestMap.get("ASYS"));
			ei.put("AYEAR", (String) requestMap.get("AYEAR"));
			ei.put("SMS", (String) requestMap.get("SMS"));
			ei.put("IDNO", (String) requestMap.get("IDNO"));
			ei.put("BIRTHDATE", (String) requestMap.get("BIRTHDATE"));
			
			if("5".equals(specialStudent) || "13".equals(specialStudent) || "14".equals(specialStudent) || "2".equals(specialStudent)){
				ei.put("PAYMENT_STATUS", "2");
			}else{
				ei.put("PAYMENT_STATUS", (String) requestMap.get("PAYMENT_STATUS"));
			}
		
			ei.put("PAYMENT_METHOD", (String) requestMap.get("PAYMENT_METHOD"));
			ei.put("CHECK_DOC", (String) requestMap.get("CHECK_DOC"));
			ei.put("DOC_UNQUAL_REASON", (String) requestMap.get("DOC_UNQUAL_REASON"));
			ei.put("WRITEOFF_NO", strWRITEOFF_NO);
			ei.put("AUDIT_RESULT", (String) requestMap.get("AUDIT_RESULT"));
			//�g�J�ײ����X   2008/06/19 by barry
			ei.put("DRAFT_NO", (String) requestMap.get("DRAFT_NO"));
			//ei.put("AUDIT_UNQUAL_REASON", "NON");
			ei.put("KEYIN_EXER", (String)session.getAttribute("USER_ID"));
			ei.put("KEYIN_DATE", Utility.dbStr(DateUtil.getNowDate()));
			
			SOLT006DAO solt006 = new SOLT006DAO(dbManager, conn, ei, (String)session.getAttribute("USER_ID"));
			solt006.insert();
			
			// ú�O��b(��ú�O�~��s���A)
			if("2".equals((String) requestMap.get("PAYMENT_STATUS"))){
				Hashtable pcs = new Hashtable();
				pcs.put("PAYMENT_MANNER", (String) requestMap.get("PAYMENT_METHOD"));
				pcs.put("PAYMENT_STATUS", (String) requestMap.get("PAYMENT_STATUS"));

				PCST004DAO pcst004 = new PCST004DAO(dbManager, conn, pcs, (String)session.getAttribute("USER_ID"));
				StringBuffer condition = new StringBuffer();

				System.out.println(strWRITEOFF_NO);
				condition.append("WRITEOFF_NO = '" + strWRITEOFF_NO + "'");
				pcst004.update(condition.toString());
				
				PCSINTAMT SOL1  = new PCSINTAMT(dbManager,conn);
		        //�ÿ�J
		        SOL1.setSYS_CODE("SOL");       //�t�ΥN��
		        SOL1.setASYS(requestMap.get("ASYS").toString());             //�Ǩ�
		        SOL1.setAYEAR(requestMap.get("AYEAR").toString());          //�Ǧ~
		        SOL1.setSMS(requestMap.get("SMS").toString());              //�Ǵ�
		        SOL1.setIDNO(requestMap.get("IDNO").toString());    //�����Ҧr��
		        SOL1.setBIRTHDATE(requestMap.get("BIRTHDATE").toString()); //�ͤ�
		        SOL1.setPAYMENT_MANNER(requestMap.get("PAYMENT_METHOD").toString());   //ú�O�覡
		        SOL1.setPAYMENT_DATE(com.acer.util.DateUtil.getNowDate()); //ú�O���
		        if("1".equals((String)requestMap.get("LIMIT")))
					SOL1.setPAYMENT_TYPE("1"+requestMap.get("ASYS").toString());    //ú�O���O  1 �ۥ� 1�Ťj 2�M�� 3�Ŭ�
				else if("2".equals((String)requestMap.get("LIMIT")))
					SOL1.setPAYMENT_TYPE("1"+requestMap.get("ASYS").toString());    //ú�O���O  1 �ۥ� 1�Ťj 2�M�� 3�Ŭ�
					//SOL1.setPAYMENT_TYPE("5"+requestMap.get("ASYS").toString());    //�O��  5 �ۥ� 1�Ťj 2�M�� 3�Ŭ�
		        SOL1.setCENTER_CODE(requestMap.get("CD").toString());     //���O����
		        SOL1.setWRITEOFF_NO(strWRITEOFF_NO); //�P�b�s��
		        SOL1.setUSER_ID((String)session.getAttribute("USER_ID"));                 //�ϥΪ̽s��
		        SOL1.setPAID_AMT(fee);                 //�ꦬ���B
				System.out.println("NOWDATE="+com.acer.util.DateUtil.getNowDate());
				int j = SOL1.execute();
				
				PCSGETRECEIPT_NO PCS1  = new PCSGETRECEIPT_NO(dbManager,conn);
	            PCS1.setAYEAR((String) requestMap.get("AYEAR"));
	            PCS1.setSMS((String) requestMap.get("SMS"));
				if("1".equals((String)requestMap.get("LIMIT")))
					PCS1.setPAYMENT_TYPE("1" + (String) requestMap.get("ASYS"));
				else if("2".equals((String)requestMap.get("LIMIT")))    //ú�O���O  1 �ۥ� 1�Ťj 2�M�� 3�Ŭ�
					PCS1.setPAYMENT_TYPE("1"+requestMap.get("ASYS").toString());    //ú�O���O  1 �ۥ� 1�Ťj 2�M�� 3�Ŭ�
					//PCS1.setPAYMENT_TYPE("5"+requestMap.get("ASYS").toString());    //�O��  5 �ۥ� 1�Ťj 2�M�� 3�Ŭ�
	            PCS1.setCENTER_CODE((String) requestMap.get("CENTER_CODE"));
	            PCS1.setUSER_ID((String)session.getAttribute("USER_ID"));
	            PCS1.setPAYMENT_AMT(fee);
	            PCS1.setWRITEOFF_NO(strWRITEOFF_NO);
				PCS1.setNAME((String) requestMap.get("NAME")); //����ú�ڤH
				System.out.println("NAME="+(String) requestMap.get("NAME"));
				if("5".equals((String) requestMap.get("PAYMENT_METHOD")))
					PCS1.setRMK("�{��");    //�p�G�n�Ƶ����ܭn��    (�D����)
				if("6".equals((String) requestMap.get("PAYMENT_METHOD")))
					PCS1.setRMK("�ײ�");    //�p�G�n�Ƶ����ܭn��    (�D����)
				String ayear = requestMap.get("AYEAR").toString();
				if(ayear.indexOf("0") == 0)
					ayear = ayear.substring(1);
		        PCS1.setSUBJECT(ayear+"�Ǧ~�תŤj�s�ͳ��W�O");  //�ƥ�  (�D����)
				//����|�p��� �p�G�O�浧�u���O���� �ǤJ�N��
		        PCS1.setACNT_TYPE("01");
				//�|�p��ة���
				PCS1.setACNTS_TYPE("01");
				//���Ӫ��B
		        PCS1.setACNT_AMT(fee);
	            //PCS1.setORDER_NO("1234567890");
	            PCS1.setIDNO((String) requestMap.get("IDNO"));
	            //=======================
	            if(!"".equals(STNO)){
	            	PCS1.setSTNO(STNO);
	            }
	            
	            PCS1.setASYS((String) requestMap.get("ASYS"));
	            int i = PCS1.execute();
			}
			
		}
		
		/** Commit Transaction */
	        dbManager.commit();
			
        /* === LoadingBar === */
        LoadingStatus.setStatus(session.getId(), 60, "(S)SOLT005 ����x�s����", LoadingStatus.success);

        Hashtable ht = new Hashtable();
		ht.put("STNO", STNO);
        out.println(DataToJson.htToJson(ht));
	}
	catch (Exception ex)
	{
        System.out.println("error: "+ex.toString()) ;
		/** Rollback Transaction */
		if(dbManager != null){
		dbManager.rollback();
        }
		throw ex;
	}
	finally
	{
		if (conn != null)
			conn.close();
		conn	=	null;
	}
}

public void doSOLCK(JspWriter out, DBManager dbManager, Hashtable requestMap, HttpSession session) throws Exception
{
	Connection	conn	=	null;

	try
	{

         conn	=	dbManager.getConnection(AUTCONNECT.mapConnect("SOL", session));
         System.out.println("AYEAR:"+(String)requestMap.get("AYEAR"));//session.getAttribute("nextayear").toString());
         System.out.println("SMS:"+(String)requestMap.get("SMS"));
         System.out.println("BIRTHDATE:"+(String)requestMap.get("BIRTHDATE"));
         System.out.println("ASYS:"+(String)requestMap.get("ASYS"));
         System.out.println("IDNO:"+(String)requestMap.get("IDNO"));

         SOLCKBO solck = new SOLCKBO(dbManager,conn);

         String rtn = solck.SOLCK(requestMap);

        if(rtn.equals("1"))
        {
            out.println(DataToJson.successJson("OK"));
        }else{
            out.println(DataToJson.successJson(rtn));
        }

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
public void doCHKOLDSTD(JspWriter out, DBManager dbManager, Hashtable requestMap, HttpSession session) throws Exception
{
    Connection	conn	= null;
    try
    {
	   conn	=	dbManager.getConnection(AUTCONNECT.mapConnect("STU", session));
       STUT003DAO STU = new STUT003DAO(dbManager,conn);
       STU.setResultColumn("STNO");
       STU.setWhere(" ASYS ='"+Utility.dbStr(requestMap.get("ASYS"))+"' AND IDNO = '"+Utility.dbStr(requestMap.get("IDNO"))+"' AND BIRTHDATE='"+Utility.dbStr(requestMap.get("BIRTHDATE"))+"'");
       DBResult	rs	=	STU.query();
       if (rs.next()){
           out.println(DataToJson.successJson("Y"));
       }else{
           out.println(DataToJson.successJson("N"));
       }
	}
	catch (Exception ex)
	{
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

public void doGETMSG(JspWriter out, DBManager dbManager, Hashtable requestMap, HttpSession session,String msg) throws Exception
{
    SYSGETSMSDATA sysgetsmsdata = new SYSGETSMSDATA(dbManager);
    sysgetsmsdata.setSYS_DATE(DateUtil.getNowDate());
    sysgetsmsdata.setSMS_TYPE("3");
    sysgetsmsdata.execute();

       SOLGETMSGBO solmsg = new SOLGETMSGBO(dbManager);
       solmsg.setASYS((String)requestMap.get("ASYS"));
       solmsg.setAYEAR(sysgetsmsdata.getAYEAR());
       solmsg.setSMS(sysgetsmsdata.getSMS());
       solmsg.setKIND("���W�e���T��");
       solmsg.setTYPE(msg);

    solmsg.execute();
    out.println(solmsg.getConient());
}

/** �B�z�C�L�\�� */
DBManager   dbm = null;
Connection  conn = null;

private void doPrint(JspWriter out, DBManager dbManager, Hashtable requestMap, HttpSession session) throws Exception
{
	DBResult rs = null;
	try
	{
		System.out.println("�C�L");
		
		dbm = dbManager;
        conn = dbManager.getConnection(AUTCONNECT.mapConnect("SOL", session));
		RptFile		rptFile	=	new RptFile(session.getId());
		rptFile.setColumn("");

        Hashtable	ht	=	new Hashtable();





        String where = new String();

        if(!Utility.nullToSpace(requestMap.get("AYEAR")).equals(""))  //095
            where +=" AND AYEAR ='"+requestMap.get("AYEAR")+"' ";
        if(!Utility.nullToSpace(requestMap.get("SMS")).equals(""))    //2
            where +=" AND SMS ='"+requestMap.get("SMS")+"' ";
        if(!Utility.nullToSpace(requestMap.get("ASYS")).equals(""))    //1
            where +=" AND ASYS ='"+requestMap.get("ASYS")+"' ";
        if(!Utility.nullToSpace(requestMap.get("BIRTHDATE")).equals(""))    //20071031
            where +=" AND BIRTHDATE ='"+requestMap.get("BIRTHDATE")+"' ";
        if(!Utility.nullToSpace(requestMap.get("IDNO")).equals(""))   //A123456789
            where +=" AND IDNO ='"+requestMap.get("IDNO")+"' ";
        if(!Utility.nullToSpace(requestMap.get("WRITEOFF_NO")).equals(""))    //4243519521100016
            where +=" AND WRITEOFF_NO ='"+requestMap.get("WRITEOFF_NO")+"' ";
		String ayear = String.valueOf(Integer.parseInt(requestMap.get("AYEAR").toString()));
        String sms    = getSYST001("SMS","").get(requestMap.get("SMS").toString()).toString();
		String asys    = requestMap.get("ASYS").toString();
		String title = "��ߪŤ��j��"+ayear+"�Ǧ~��"+sms+"���W�O����";
		if(asys.equals("2"))
			title = "��ߪŤ��j�Ǫ��]�Ť��M��i�׾Ǯ�"+ayear+"�Ǧ~��"+sms+"���W�O����";



        StringBuffer sql = new StringBuffer().append(" SELECT * FROM ("+
                "SELECT A.AYEAR,A.SMS,A.ASYS,A.BIRTHDATE,A.STNO,A.IDNO "+
                ",A.CENTER_CODE,A.NAME,A.CRRSADDR_ZIP AS ZIP,A.CRRSADDR AS ADDR "+
                ",C.WRITEOFF_NO,C.PAYABLE_AMT,C.PAYMENT_STATUS,Z.CODE_NAME,C.BOT_BARCODE,C.CS_BARCODE1,CS_BARCODE2 "+
                ",E.PAYMENT_RMK_CODE1,E.PAYMENT_RMK_CODE2 "+
                "FROM SOLT003 A "+
                "JOIN SOLT006 B ON A.ASYS=B.ASYS AND A.AYEAR=B.AYEAR AND A.SMS=B.SMS "+
                "	 		   AND A.IDNO=B.IDNO AND A.BIRTHDATE=B.BIRTHDATE "+
                "JOIN SOLT007 C ON A.ASYS=C.ASYS AND A.AYEAR=C.AYEAR AND A.SMS=C.SMS "+
                "	 		   AND A.IDNO=C.IDNO AND A.BIRTHDATE=C.BIRTHDATE AND B.WRITEOFF_NO=C.WRITEOFF_NO "+
                "JOIN SYST001 Z ON Z.KIND='PAYMENT_STATUS' AND Z.CODE=C.PAYMENT_STATUS "+
                //"JOIN STUT003 D ON A.IDNO=D.IDNO "+
                "JOIN SOLT001 E ON A.ASYS=E.ASYS AND A.AYEAR=E.AYEAR AND A.SMS=E.SMS "+
            ") WHERE 0=0 "+ where
        );
		Vector result = gateway(sql);
		System.out.println("SOLT005= "+sql);


        String C1 = "<img src='/BarcodeServlet?type=Code39&fontsize=12&headless=false&drawText=true&width=0.5&height=30&data=";
        String C2 = "'/>";
		
		String sSignNM1   =  "";
        String sSignNM2   =  "";
        String sSignNM3   =  "";
        String sTmpIDNO   =  "";
		String USER_IDNO1 = "";
		String USER_IDNO2 = "";
		String USER_IDNO3 = "";


        //----------------------------------------------------------//
        StringBuffer sqls = new StringBuffer();
		sqls.append("select (select idno from syst010 where DUTY_TYPE = '07' and DEP_CODE = '555') USER_IDNO1, ");
		sqls.append("(select idno from syst010 where DUTY_TYPE = '07' and DEP_CODE = '600') USER_IDNO2, ");
		sqls.append("(select idno from syst010 where DUTY_TYPE = '01' and DEP_CODE = '500') USER_IDNO3 from dual ");
		rs = dbManager.getSimpleResultSet(conn);
		rs.open();
		rs.executeQuery(sqls.toString());
		if(rs.next())
		{
			USER_IDNO1=rs.getString("USER_IDNO1");
			USER_IDNO2=rs.getString("USER_IDNO2");
			USER_IDNO3=rs.getString("USER_IDNO3");
		}
		
		AUTT001DAO AUTT001 = new AUTT001DAO(dbManager, conn);
        AUTT001.setResultColumn(" USER_NAME ");
        AUTT001.setUSER_IDNO(USER_IDNO1);
        rs    =    AUTT001.query();

        if(rs.next())
        {
        	sSignNM1 = rs.getString("USER_NAME");

        }
        AUTT001 = new AUTT001DAO(dbManager, conn);
        AUTT001.setResultColumn(" USER_NAME ");
        AUTT001.setUSER_IDNO(USER_IDNO2);
        rs    =    AUTT001.query();

        if(rs.next())
        {
        	sSignNM2 = rs.getString("USER_NAME");
        }
        AUTT001 = new AUTT001DAO(dbManager, conn);
        AUTT001.setResultColumn(" USER_NAME ");
        AUTT001.setUSER_IDNO(USER_IDNO3);
        rs    =    AUTT001.query();
        if(rs.next())
        {
        	sSignNM3 = rs.getString("USER_NAME");
        }
        rs.close();

        for(int i = 0 ; i<result.size() ; i++){
            rptFile.add(" ");
            ht.put("BANK","004");
            ht.put("WRITEOFFNO",((Hashtable)result.get(i)).get("WRITEOFF_NO").toString());

            ht.put("STNO",((Hashtable)result.get(i)).get("STNO") == null ? "" : ((Hashtable)result.get(i)).get("STNO"));
            ht.put("ADDR",((Hashtable)result.get(i)).get("ZIP").toString()+"<br>"+((Hashtable)result.get(i)).get("ADDR").toString());
            ht.put("NAME",((Hashtable)result.get(i)).get("NAME").toString());

            // ht.put("RMK1",((Hashtable)result.get(i)).get("PAYMENT_RMK_CODE2").toString());
            // ht.put("RMK2",((Hashtable)result.get(i)).get("PAYMENT_RMK_CODE2").toString());
			ht.put("RMK1","&nbsp;");
            ht.put("RMK2","&nbsp;");
            ht.put("RMK3",((Hashtable)result.get(i)).get("PAYMENT_RMK_CODE1").toString());


            ht.put("LEFT1","���W�O");
            ht.put("RIGHT1",((Hashtable)result.get(i)).get("PAYABLE_AMT").toString());

            ht.put("CTMONEY",numberToCh(((Hashtable)result.get(i)).get("PAYABLE_AMT").toString()));
            ht.put("TMONEY",((Hashtable)result.get(i)).get("PAYABLE_AMT").toString());

            ht.put("DETIL","&nbsp;");
			ht.put("SIGN01",sSignNM1);
            ht.put("SIGN02",sSignNM2);
            ht.put("SIGN03",sSignNM3);

            ht.put("TITLE",title);

            //ht.put("BANKCODE",C1+((Hashtable)result.get(i)).get("BOT_BARCODE").toString()+zero_money_to_6_length(((Hashtable)result.get(i)).get("WRITEOFF_NO").toString())+C2);
			ht.put("BANKCODE",C1+((Hashtable)result.get(0)).get("BOT_BARCODE").toString()+C2);
            ht.put("WRITEOFFNO_4",((Hashtable)result.get(i)).get("WRITEOFF_NO").toString().substring(0,4));
            ht.put("STORECODE1",C1+((Hashtable)result.get(i)).get("CS_BARCODE1").toString()+C2);
            ht.put("STORECODE2",C1+((Hashtable)result.get(i)).get("WRITEOFF_NO").toString()+C2);
            ht.put("STORECODE3",C1+((Hashtable)result.get(i)).get("CS_BARCODE2").toString()+C2);
        }


		if (rptFile.size() == 0)
		{
			out.println("<script>top.close();alert(\"�L�ŦX��ƥi�ѦC�L!!\");</script>");
			return;
		}

		/** ��l�Ƴ����� */
		report		report_	=	new report(dbManager, conn, out, "sol118r_01r1", report.onlineHtmlMode);

		/** �R�A�ܼƳB�z */



		report_.setDynamicVariable(ht);

		/** �}�l�C�L */
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
}


// dbm = DBManager , conn = Connection
private Vector gateway(StringBuffer sql) throws Exception
{
	DBResult	rs	=	null;
	try
	{
        rs	= dbm.getSimpleResultSet(conn);
		rs.open();
		rs.executeQuery(sql.toString());
        Hashtable rsHt = new Hashtable();
        Vector result = new Vector();
		while (rs.next()){
		     rsHt = new Hashtable();
             for (int i = 1 ; i<=rs.getColumnCount();i++)
                 rsHt.put(rs.getColumnName(i), rs.getString(i));
             result.add(rsHt);
        }
        return result;
	}
    catch(Exception e){throw e;}
	finally{if (rs != null)	rs.close();}
}

private Hashtable getSYST001(String kind, String code) throws Exception
{
	DBResult	rs	=	null;
	try
	{
	    int i=0;
        Hashtable ht = new Hashtable();
		kind = Utility.checkNull(kind, "");
        code = Utility.checkNull(code, "");
		SYST001DAO	dao	=	new SYST001DAO(dbm,conn);
		dao.setResultColumn("CODE,CODE_NAME");
		kind = "KIND = '"+kind+"' ";
		if (!code.equals("")) kind += " AND CODE='"+code+"' ";
		dao.setWhere(kind);
		rs	=	dao.query();
		while (rs.next()){
			ht.put(rs.getString("CODE"),rs.getString("CODE_NAME"));
		}                                              //�h�s
		return ht;
	}
    catch(Exception e){throw e;}
	finally{if (rs != null)	rs.close();}
}

private String zero_money_to_6_length(String str)
{
    for(int i=0;i<(7-str.length());i++)
            str="0"+str;
    return str;
}

    /** �ƭ��त��  */
    public String numberToCh(String str)
    {
         char strs[] = str.toCharArray();
         String ch = new String();
         String stra[] = new String[strs.length];
         for(int i=strs.length-1,j=0;i>=0;i--,j++){
                 switch(Integer.parseInt(String.valueOf(strs[i]))){
                      case 1: stra[i] += "��"; break;
                      case 2: stra[i] += "�L"; break;
                      case 3: stra[i] += "��"; break;
                      case 4: stra[i] += "�v"; break;
                      case 5: stra[i] += "��"; break;
                      case 6: stra[i] += "��"; break;
                      case 7: stra[i] += "�m"; break;
                      case 8: stra[i] += "��"; break;
                      case 9: stra[i] += "�h"; break;
                 }
                 if(strs[i]=='0'){
                     switch(j%4){
                          case 2:
                               if((i+1)<=strs.length-1) if(strs[i+1]!='0') stra[i] += "�s";
                               break;
                          case 3: stra[i] += "�s"; break;
                     }
                 }else{
                     switch(j%4){
                          case 1: stra[i] += "�B"; break;
                          case 2: stra[i] += "��"; break;
                          case 3: stra[i] += "�a"; break;
                     }
                 }
                 switch(j){
                      case 0: stra[i] += "��"; break;
                      case 4: stra[i] += "�U"; break;
                      case 8: stra[i] += "��"; break;
                      case 12: stra[i] += "��"; break;
                 }
         }
         for(int i=0;i<strs.length;i++){
                 ch += stra[i];
         }
         return ch.replaceAll("null","");
     }

/** �B�z�C�L�\�� */
private void doPrint2(JspWriter out, DBManager dbManager, Hashtable requestMap, HttpSession session) throws Exception
{
	try
	{
		Connection	conn	=	dbManager.getConnection(AUTCONNECT.mapConnect("PCS", session));

//    requestMap.put("WRITEOFF_NO","4242889612314270");
//    requestMap.put("NAME","�����");
      requestMap.put("DETAIL","�������J");
      requestMap.put("REASON","�Ǧ~�׳��W�O");
      //requestMap.put("NOTE","�ܦ������L�l");



	DBResult	rs	=	null;
	Vector		vt	=	null;




		vt	=	new Vector();

		PCST003DAO	dao	=	new PCST003DAO(dbManager, conn);
		dao.setResultColumn("RECEIPT_NO,PAYMENT_AMT,RECEIPT_DATE");
		String writeoffNo = (String) session.getAttribute("SOLT0051_WRITEOFF_NO");
		String name = (String) session.getAttribute("SOLT0051_NAME");
		String ayear = (String) session.getAttribute("SOLT0051_AYEAR");
		session.setAttribute("SOLT0051_WRITEOFF_NO", null);
		session.setAttribute("SOLT0051_NAME", null);
		session.setAttribute("SOLT0051_AYEAR", null);

		dao.setWRITEOFF_NO(writeoffNo);

		rs	=	dao.query();

		/** ��l�� rptFile */
		RptFile		rptFile	=	new RptFile(session.getId());
		rptFile.setColumn("CDATE,RECEIPT_NO,NAME,DETAIL,PAYMENT_AMT,REASON,NOTE,C_PAYMENT");


        String cdate = "";
		while (rs.next())
		{
		    Hashtable	rsHt	=	new Hashtable();
			for (int i = 1; i <= rs.getColumnCount(); i++)  {

                System.out.println(rs.getColumnName(i));
                System.out.println(rs.getString(i));
                rsHt.put(rs.getColumnName(i),rs.getString(i));

            }

               System.out.println(rsHt);
               cdate = DateUtil.formatCDateForPrint(DateUtil.convertDate(rsHt.get("RECEIPT_DATE").toString()));
               
			   rptFile.add(cdate);
			   rptFile.add("��NO."+rsHt.get("RECEIPT_NO").toString()+"��"+"&nbsp;");
			   rptFile.add(name+"&nbsp;");
			   rptFile.add((String) requestMap.get("DETAIL")+"&nbsp;");
			   rptFile.add((String) rsHt.get("PAYMENT_AMT")+"&nbsp;");
			   rptFile.add(ayear+(String) requestMap.get("REASON")+"&nbsp;");
			   rptFile.add((requestMap.get("NOTE") == null ? "" : (String) requestMap.get("NOTE"))+"&nbsp;");
               rptFile.add("&nbsp;&nbsp;"+Utility.getCNum(Integer.parseInt(rsHt.get("PAYMENT_AMT").toString()),1)+"&nbsp;");
		}

		if (rptFile.size() == 0)
		{
			out.println("<script>top.close();alert(\"�L�ŦX��ƥi�ѦC�L!!\");</script>");
			return;
		}

		/** ��l�Ƴ����� */
		report		report_	=	new report(dbManager, conn, out, "pcs112r_01r1", report.onlineHtmlMode);

		/** �R�A�ܼƳB�z */
		Hashtable	ht	=	new Hashtable();
		report_.setDynamicVariable(ht);

		/** �}�l�C�L */
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
}

public void doGrat003Check(JspWriter out, DBManager dbManager, Hashtable requestMap, HttpSession session) throws Exception
{
    Connection	conn	= null;
    try
    {
    	if("".equals(requestMap.get("IDNO"))){
    		out.println(DataToJson.successJson("X"));
    		return;
    	}
    	
	   conn	=	dbManager.getConnection(AUTCONNECT.mapConnect("GRA", session));
	   com.nou.gra.dao.GRAT003DAO g003 = new com.nou.gra.dao.GRAT003DAO(dbManager,conn);
       g003.setResultColumn("STNO");
	   g003.setWhere("GRAD_PROVE_NUMBER_1 is not null  and idno = '" + requestMap.get("IDNO") + "' ");
	   DBResult	rs	=	g003.query();
       if (rs.next()){
           out.println(DataToJson.successJson("Y"));
       }else{
           out.println(DataToJson.successJson("N"));
       }
	}
	catch (Exception ex)
	{
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