package com.nou.stu;

import com.nou.AbstractMedium;
import com.acer.db.*;
import java.sql.*;
import com.nou.aut.AUTCONNECT;
import com.acer.util.*;
import com.nou.sys.*;
import com.nou.stu.bo.*;
import com.nou.stu.dao.STUU003DAO;
import com.nou.stu.dao.STUU002DAO;
import com.nou.stu.dao.STUT003DAO;
import com.nou.stu.dao.STUT002DAO;
import java.util.Hashtable;
import com.acer.db.query.DBResult;

/**
 * <p>Title: </p>
 *
 * <p>Description: </p>
 *
 * <p>Copyright: Copyright (c) 2006</p>
 *
 * <p>Company: </p>
 *
 * @author not attributable
 * @version 1.0
 */
public class STUADDDATA extends AbstractMedium {
    private String USER_ID;
    private String AYEAR;
    private String SMS;
    private String IDNO;
    private String BIRTHDATE;
    private String CENTER_CODE;
	private String FTSTUD_CENTER_CODE;
    private String STTYPE;
    private String NAME;
    private String ENG_NAME;
    private String ALIAS;
    private String SEX;
    private String SELF_IDENTITY_SEX;  //�ۧڻ{�P�ʧO
    private String VOCATION;
    private String EDUBKGRD_GRADE;   //�Ǿ�����
    private String EDUBKGRD_AYEAR;   //�Ǿ�
    private String AREACODE_OFFICE;
    private String TEL_OFFICE;
    private String TEL_OFFICE_EXT;
    private String AREACODE_HOME;
    private String TEL_HOME;
    private String MOBILE;
    private String MARRIAGE;        //�B�ê��p
    private String DMSTADDR_ZIP;    //���y�a�}�l���ϸ�
    private String DMSTADDR;        //���y�a�}
    private String CRRSADDR_ZIP;
    private String CRRSADDR;
    private String EMAIL;
    private String EMRGNCY_RELATION;   //����p���H���Y
    private String ASYS;
    private String STNO;
    private String ENROLL_AYEARSMS;
    private String EMRGNCY_NAME;       //����p���H�m�W
    private String EMRGNCY_TEL;        //����p���H�q��
    private String EDUBKGRD;           //�Ǿ����~(��)�~��
    private String PRE_MAJOR_FACULTY;
    private String J_FACULTY_CODE;
    private String TUTOR_CLASS_MK;     //�ѥ[�ɮv�Z���O
    private String UPD_MK;
	private String SPECIAL_STTYPE_TYPE;		//�S��͵��O
	private String FTSTUD_ENROLL_AYEARSMS;    //���ץͤJ�ǾǦ~��(�¿���s����)
	private String FROM_PROG_CODE = "";    // �����{���b�ϥγo���Ƶ{��(�ѯS��ݨD�ϥ�,EX:SOL013M,SOL0006M)
	private String ENROLL_STATUS;
	private String NATIONCODE = "";    
	private String NEWNATION = "";		//�s������O
	private boolean IDNO_CHECK = true;
	private String PASSPORT_NO = "";
	private String RESIDENCE_DATE = "";
	private boolean checkEdubkgrdGradeStut002 = false;
	
	
	private boolean STTYPE_CHECK = false; //�¿���s���ץ� ���O   T: �O(�s�WSTUT004�]�t�������Ǧ~��) F:�_ (���B�z)

    //private String HANDICAP_GRADE;
    //private String HANDICAP_TYPE;
    //private String ORIGIN_RACE;
    public STUADDDATA(DBManager dbManager) {
        super(dbManager);
    }

    /**
     * checkArguments
     *
     * @return boolean
     * @todo Implement this com.nou.AbstractMedium method
     */
	protected boolean checkArguments() {
        if (isEmpty(this.USER_ID)) this.addError("�ϥΪ̱b����J�ѼƬ��ť�");
        if (isEmpty(this.IDNO)) {
            this.addError("�����Ҧr����J�ѼƬ��ť�");
        } else {
        	System.out.println("IDNO_CHECK="+this.IDNO_CHECK);
        	if(IDNO_CHECK){
        		
        		SYSCHKIDN syschkidn = new SYSCHKIDN();
                syschkidn.setIDN(IDNO);
                int rtn = 0;
                try {
                    rtn = syschkidn.execute();
                } catch (Exception e) {
                    rtn = AbstractMedium.FAIL;
                }
                if (rtn != AbstractMedium.SUCCESS) addError("�����Ҧr�����~");
        		
        	}
            
        }
        if (isEmpty(this.BIRTHDATE)) {
            this.addError("�X�ͤ����J�ѼƬ��ť�");
        } else {
            if (!isDate(this.BIRTHDATE)) this.addError("�X�ͤ���榡���~");
        }
        if (isEmpty(this.NAME)) this.addError("�m�W��J�ѼƬ��ť�");
        if (isEmpty(this.EDUBKGRD_GRADE)) this.addError("�Ǿ����ſ�J�ѼƬ��ť�");
        if (isEmpty(this.ASYS)) this.addError("�Ǩ��J�ѼƬ��ť�");
        if (isEmpty(this.STNO)) this.addError("�Ǹ���J�ѼƬ��ť�");
        if (isEmpty(this.CENTER_CODE)) this.addError("���ߧO��J�ѼƬ��ť�");
        // �p��SOLT013M�h���ˮֳo��
        if(!FROM_PROG_CODE.equals("SOL013M")){
	        if (isEmpty(this.STTYPE)) this.addError("���W�����O��J�ѼƬ��ť�");
	        if (isEmpty(this.ENROLL_AYEARSMS) && isEmpty(this.FTSTUD_ENROLL_AYEARSMS)) this.addError("�J�ǾǦ~���B���ץͤJ�ǾǦ~����J�ѼƬҬ��ťաA�G�̶��ܤ@��J");
        }
        if (isEmpty(this.UPD_MK)) this.addError("���ʵ��O��J���ťաA�п�J�G1.�s�W 2.�ק�");

        if (this.getErrorCount() > 0 ) return false;
        return true;
    }

    /**
     * mainProcess
     *
     * @return int
     * @throws Exception
     * @todo Implement this com.nou.AbstractMedium method
     */
	protected int mainProcess() throws Exception {
        Connection con = null;
        try {
            con = dbManager.getConnection(AUTCONNECT.mapConnect("STU", "0"));
            //con.setAutoCommit(false);
            DBAccess dba = dbManager.getDBAccess(con);
            try {
                Hashtable ht_st2 = new Hashtable();
                ht_st2.put("IDNO",this.IDNO);
                ht_st2.put("BIRTHDATE",this.BIRTHDATE);
                ht_st2.put("NAME",this.NAME);
				if (!isEmpty(this.ENG_NAME))
					ht_st2.put("ENG_NAME",this.ENG_NAME);
				if (!isEmpty(this.ALIAS))
					ht_st2.put("ALIAS",this.ALIAS);
				if (!isEmpty(this.SEX))
					ht_st2.put("SEX",this.SEX);
				if (!isEmpty(this.SELF_IDENTITY_SEX))
					ht_st2.put("SELF_IDENTITY_SEX",this.SELF_IDENTITY_SEX);
				if (!isEmpty(this.VOCATION))
					ht_st2.put("VOCATION",this.VOCATION);
				
				//if (!isEmpty(this.EDUBKGRD_GRADE) && checkEdubkgrdGradeStut002)
					ht_st2.put("EDUBKGRD_GRADE",this.EDUBKGRD_GRADE);
				
				if (!isEmpty(this.AREACODE_OFFICE))
					ht_st2.put("AREACODE_OFFICE",this.AREACODE_OFFICE);
				if (!isEmpty(this.TEL_OFFICE))
					ht_st2.put("TEL_OFFICE",this.TEL_OFFICE);
				if (!isEmpty(this.TEL_OFFICE_EXT))
					ht_st2.put("TEL_OFFICE_EXT",this.TEL_OFFICE_EXT);
				if (!isEmpty(this.AREACODE_HOME))
					ht_st2.put("AREACODE_HOME",this.AREACODE_HOME);
				if (!isEmpty(this.TEL_HOME))
					ht_st2.put("TEL_HOME",this.TEL_HOME);
				if (!isEmpty(this.MOBILE))
					ht_st2.put("MOBILE",this.MOBILE);
				if (!isEmpty(this.MARRIAGE))
					ht_st2.put("MARRIAGE",this.MARRIAGE);
				if (!isEmpty(this.DMSTADDR_ZIP))
					ht_st2.put("DMSTADDR_ZIP",this.DMSTADDR_ZIP);
				if (!isEmpty(this.DMSTADDR))
					ht_st2.put("DMSTADDR",this.DMSTADDR);
				if (!isEmpty(this.CRRSADDR_ZIP))
					ht_st2.put("CRRSADDR_ZIP",this.CRRSADDR_ZIP);
				if (!isEmpty(this.CRRSADDR))
					ht_st2.put("CRRSADDR",this.CRRSADDR);
				if (!isEmpty(this.EMAIL))
					ht_st2.put("EMAIL",this.EMAIL);
				if (!isEmpty(this.EMRGNCY_NAME))
					ht_st2.put("EMRGNCY_NAME",this.EMRGNCY_NAME);
				if (!isEmpty(this.EMRGNCY_TEL))
					ht_st2.put("EMRGNCY_TEL",this.EMRGNCY_TEL);
				if (!isEmpty(this.EMRGNCY_RELATION))
					ht_st2.put("EMRGNCY_RELATION",this.EMRGNCY_RELATION);
				if (!isEmpty(this.NATIONCODE))
					ht_st2.put("NATIONCODE",this.NATIONCODE);
				if (!isEmpty(this.NEWNATION))
					ht_st2.put("NEWNATION",this.NEWNATION);
				if (!isEmpty(this.RESIDENCE_DATE))
					ht_st2.put("RESIDENCE_DATE",this.RESIDENCE_DATE);
				if (!isEmpty(this.PASSPORT_NO))
					ht_st2.put("PASSPORT_NO",this.PASSPORT_NO);
				
                ht_st2.put("UPD_MK",this.UPD_MK);

                if(this.UPD_MK.equals("1")){
                    try{
                        ht_st2.put("UPD_RMK","STUADDDATA,�s�W���y���,�s�W");
                        STUT002DAO	ST2 = new STUT002DAO(dbManager, con,ht_st2,this.USER_ID);
                        ST2.insert();
                    }catch  (Exception e1) {
                         //�g���ʬ���
                         LOG_STUT002(dbManager,con);
                         ht_st2.put("UPD_RMK","STUADDDATA,�ק���y���,�ק�");
                         STUT002DAO	ST2 = new STUT002DAO(dbManager, con,ht_st2,this.USER_ID);
                         ST2.update("IDNO = '" + this.IDNO + "' AND BIRTHDATE = '" + this.BIRTHDATE + "' ");
                    }
                }else if(this.UPD_MK.equals("2")){
                    //�g���ʬ���
                    LOG_STUT002(dbManager,con);
                    ht_st2.put("UPD_RMK","STUADDDATA,�ק���y���,�ק�");
                    STUT002DAO	ST2 = new STUT002DAO(dbManager, con,ht_st2,this.USER_ID);
                    ST2.update("IDNO = '" + this.IDNO + "' AND BIRTHDATE = '" + this.BIRTHDATE + "' ");
                }
            } catch (Exception e) {
            	e.printStackTrace();
                this.addError("�g�JSTUT002����");
                throw e;
            }
            //by poto �¿���s�� �b�٨S���ܾ��y���A ���[�J�@�� ��Ǧ~�䪺���{
            doStuCareerFirstProcess(con) ;
            try {
                Hashtable ht_st3 = new Hashtable();
                ht_st3.put("STNO",this.STNO);
                ht_st3.put("IDNO",this.IDNO);
                ht_st3.put("BIRTHDATE",this.BIRTHDATE);
                ht_st3.put("ASYS",this.ASYS);
                ht_st3.put("CENTER_CODE",this.CENTER_CODE);
				ht_st3.put("NOU_EMAIL",this.STNO+"@WEBMAIL.NOU.EDU.TW");
				
				if (!isEmpty(this.ENROLL_AYEARSMS)&&!FROM_PROG_CODE.equals("SOL013M"))
					ht_st3.put("ENROLL_AYEARSMS",this.ENROLL_AYEARSMS);
				if (!isEmpty(this.EDUBKGRD))
					ht_st3.put("EDUBKGRD",this.EDUBKGRD);
				if (!isEmpty(this.PRE_MAJOR_FACULTY))
					ht_st3.put("PRE_MAJOR_FACULTY",this.PRE_MAJOR_FACULTY);
				if (!isEmpty(this.J_FACULTY_CODE))
					ht_st3.put("J_FACULTY_CODE",this.J_FACULTY_CODE);
				if (!isEmpty(this.TUTOR_CLASS_MK))
					ht_st3.put("TUTOR_CLASS_MK",this.TUTOR_CLASS_MK);				
				if (!isEmpty(this.SPECIAL_STTYPE_TYPE))
					ht_st3.put("SPECIAL_STTYPE_TYPE",this.SPECIAL_STTYPE_TYPE);
				if (!isEmpty(this.ENROLL_STATUS))
					ht_st3.put("ENROLL_STATUS",this.ENROLL_STATUS);
				if (!isEmpty(this.STTYPE))
					ht_st3.put("STTYPE",this.STTYPE);
				if (!isEmpty(this.EDUBKGRD_AYEAR))
					ht_st3.put("EDUBKGRD_AYEAR",this.EDUBKGRD_AYEAR);
				if (!isEmpty(this.EDUBKGRD_GRADE))
					ht_st3.put("EDUBKGRD_GRADE",this.EDUBKGRD_GRADE);
				
                ht_st3.put("UPD_MK",this.UPD_MK);
                //��ץͤ��g�JFTSTUD_CENTER_CODE,FTSTUD_ENROLL_AYEARSMS
                if(!"2".equals(this.STTYPE)){
                	if (!isEmpty(this.FTSTUD_ENROLL_AYEARSMS)){
    					ht_st3.put("FTSTUD_ENROLL_AYEARSMS",this.FTSTUD_ENROLL_AYEARSMS);
                    }	
    				if (!isEmpty(this.FTSTUD_CENTER_CODE)){
    					ht_st3.put("FTSTUD_CENTER_CODE",this.FTSTUD_CENTER_CODE);
    				}
                }else{
                	ht_st3.put("FTSTUD_ENROLL_AYEARSMS","");
                	ht_st3.put("FTSTUD_CENTER_CODE","");
                }
                	
				if(this.UPD_MK.equals("1")){
					try{
					    // SOL013M ���o�ק�STTYPE,ENROLL_STATUS(2011/8/25)
    	                if(!FROM_PROG_CODE.equals("SOL013M")){
    	                	ht_st3.put("STTYPE",this.STTYPE);
    						ht_st3.put("ENROLL_STATUS","1");
    	                }
					    ht_st3.put("UPD_RMK","STUADDDATA,�s�W���y���,�s�W");
					    STUT003DAO	ST3 = new STUT003DAO(dbManager, con,ht_st3,this.USER_ID);
                        ST3.insert();
                    }catch  (Exception e2) {
                    	 
                    	if("SOL006M".equals(FROM_PROG_CODE) || "SOL005M".equals(FROM_PROG_CODE)){
                    		//�p�G�s�W���� �ˬdSTNO,IDNO,BIRTHDATE �O�_�s�b �O:�ק� �_:���X�s�W���~
                    		if(checkStut003( dbManager,con, this.STNO, this.IDNO, this.BIRTHDATE)){
                                LOG_STUT003(dbManager,con);
                                ht_st3.put("UPD_RMK","STUADDDATA,�ק���y���,�ק�");
                                STUT003DAO	ST3 = new STUT003DAO(dbManager, con,ht_st3,this.USER_ID);
        						ST3.update("STNO='"+this.STNO+"'");
                        	}else{
                        		this.addError("�g�JSTUT003����");
                                throw e2;
                        	}
                    		
    	                }else{
    	                	//�g���ʬ���
                            LOG_STUT003(dbManager,con);
                            ht_st3.put("UPD_RMK","STUADDDATA,�ק���y���,�ק�");
                            STUT003DAO	ST3 = new STUT003DAO(dbManager, con,ht_st3,this.USER_ID);
    						ST3.update("STNO='"+this.STNO+"'");
    	                }
                        
                    }
                }else if(this.UPD_MK.equals("2")){
                    //�g���ʬ���
                    LOG_STUT003(dbManager,con);
					ht_st3.put("UPD_RMK","STUADDDATA,�ק���y���,�ק�");
					STUT003DAO	ST3 = new STUT003DAO(dbManager, con,ht_st3,this.USER_ID);
                    ST3.update("STNO='"+this.STNO+"'");
                }
            } catch (Exception e) {
                this.addError("�g�JSTUT003����");
                throw e;
            }

			DBResult	rs	=	null;
			StringBuffer	sql		=	new StringBuffer();
			sql.append("SELECT COUNT(1) NUM FROM STUT031 WHERE STNO = '"+this.STNO+"' ");
			rs	=	dbManager.getSimpleResultSet(con);
			rs.open();
			rs.executeQuery(sql.toString());
			rs.next();
			String NUM = rs.getString("NUM");

			if (!isEmpty(this.SPECIAL_STTYPE_TYPE))
			{
				//�D�ʺ��� �~�g STUT031
				if(!this.SPECIAL_STTYPE_TYPE.equals("1"))
				{
					try{
						dba.setTableName("STUT031");
		                dba.setColumn("STNO",this.STNO);
		                dba.setColumn("AYEAR",this.AYEAR);
		                dba.setColumn("SMS",this.SMS);
		                dba.setColumn("SPCLASS_TYPE",this.SPECIAL_STTYPE_TYPE);
		                //dba.setColumn("UPD_MK","STUADDDATA,�s�W���y���,�s�W");
		                dba.setColumn("UPD_DATE",DateUtil.getNowDate());
		                dba.setColumn("UPD_TIME",DateUtil.getNowTimeS());
		                dba.setColumn("UPD_USER_ID",this.USER_ID);
		                dba.setColumn("ROWSTAMP",DateUtil.getNowTimeMs());

						if(NUM.equals("0"))
						{
							//dba.setColumn("UPD_MK","STUADDDATA,�s�W���y���,�s�W");
							dba.insert();
						}else{
							//dba.setColumn("UPD_RMK","STUADDDATA,�ק���y���,�ק�");
							dba.update("STNO='"+this.STNO+"'");
						}
					}catch (Exception e3) {
		                this.addError("�g�JSTUT031����");
		                throw e3;
					}
				}
			}else{
				if(!NUM.equals("0"))
				{
					try{
						dba.setTableName("STUT031");
						dba.delete("STNO='"+this.STNO+"'");
					}catch (Exception e3) {
		                this.addError("�R��STUT031���(STNO='"+this.STNO+"')����");
		                throw e3;
					}
				}
			}
			//by poto �B�z�s�Wstut004			
			doStuCareerMainProcess(con);
			if (rs != null) rs.close();
			if(this.hasNextError())
			{
				return AbstractMedium.FAIL;
			}else{
				return AbstractMedium.SUCCESS;
			}


        } catch (Exception e) {
            try {
                //con.rollback();
            } catch (Exception e1) {}
            throw e;
        } finally {
            try {
                //con.setAutoCommit(true);
            } catch (Exception e) {}
        }
    }

    public void setUSER_ID(String USER_ID) {
        this.USER_ID = USER_ID;
    }
    
    public void setENROLL_STATUS(String ENROLL_STATUS) {
        this.ENROLL_STATUS = ENROLL_STATUS;
    }
    
    public void setAYEAR(String AYEAR) {
        this.AYEAR = AYEAR;
    }

    public void setSMS(String SMS) {
        this.SMS = SMS;
    }

    public void setIDNO(String IDNO) {
        this.IDNO = IDNO;
    }

    public void setBIRTHDATE(String BIRTHDATE) {
        this.BIRTHDATE = BIRTHDATE;
    }

    public void setCENTER_CODE(String CENTER_CODE) {
        this.CENTER_CODE = CENTER_CODE;
    }

    public void setSTTYPE(String STTYPE) {
        this.STTYPE = STTYPE;
    }

    public void setNAME(String NAME) {
        this.NAME = NAME;
    }

    public void setENG_NAME(String ENG_NAME) {
        this.ENG_NAME = ENG_NAME;
    }

    public void setALIAS(String ALIAS) {
        this.ALIAS = ALIAS;
    }

    public void setSEX(String SEX) {
        this.SEX = SEX;
    }

    public void setSELF_IDENTITY_SEX(String SELF_IDENTITY_SEX) {
        this.SELF_IDENTITY_SEX = SELF_IDENTITY_SEX;
    }

    public void setVOCATION(String VOCATION) {
        this.VOCATION = VOCATION;
    }

    //by poto �g�J�h���r�� 
    public void setEDUBKGRD_GRADE(String EDUBKGRD_GRADE) {
        this.EDUBKGRD_GRADE = EDUBKGRD_GRADE.replaceAll(",","");
    }    

    public void setAREACODE_OFFICE(String AREACODE_OFFICE) {
        this.AREACODE_OFFICE = AREACODE_OFFICE;
    }

    public void setTEL_OFFICE(String TEL_OFFICE) {
        this.TEL_OFFICE = TEL_OFFICE;
    }

    public void setTEL_OFFICE_EXT(String TEL_OFFICE_EXT) {
        this.TEL_OFFICE_EXT = TEL_OFFICE_EXT;
    }

    public void setAREACODE_HOME(String AREACODE_HOME) {
        this.AREACODE_HOME = AREACODE_HOME;
    }

    public void setTEL_HOME(String TEL_HOME) {
        this.TEL_HOME = TEL_HOME;
    }

    public void setMOBILE(String MOBILE) {
        this.MOBILE = MOBILE;
    }

    public void setMARRIAGE(String MARRIAGE) {
        this.MARRIAGE = MARRIAGE;
    }

    public void setDMSTADDR_ZIP(String DMSTADDR_ZIP) {
        this.DMSTADDR_ZIP = DMSTADDR_ZIP;
    }

    public void setDMSTADDR(String DMSTADDR) {
        this.DMSTADDR = DMSTADDR;
    }

    public void setCRRSADDR_ZIP(String CRRSADDR_ZIP) {
        this.CRRSADDR_ZIP = CRRSADDR_ZIP;
    }

    public void setCRRSADDR(String CRRSADDR) {
        this.CRRSADDR = CRRSADDR;
    }

    public void setEMAIL(String EMAIL) {
        this.EMAIL = EMAIL;
    }

    public void setEMRGNCY_RELATION(String EMRGNCY_RELATION) {
        this.EMRGNCY_RELATION = EMRGNCY_RELATION;
    }

    public void setASYS(String ASYS) {
        this.ASYS = ASYS;
    }

    public void setSTNO(String STNO) {
        this.STNO = STNO;
    }

    public void setENROLL_AYEARSMS(String ENROLL_AYEARSMS) {
        this.ENROLL_AYEARSMS = ENROLL_AYEARSMS;
    }

    public void setEMRGNCY_NAME(String EMRGNCY_NAME) {
        this.EMRGNCY_NAME = EMRGNCY_NAME;
    }

    public String getEMRGNCY_NAME() {
        return EMRGNCY_NAME;
    }

    public void setEMRGNCY_TEL(String EMRGNCY_TEL) {
        this.EMRGNCY_TEL = EMRGNCY_TEL;
    }

    public String getEMRGNCY_TEL() {
        return EMRGNCY_TEL;
    }

    public void setEDUBKGRD(String EDUBKGRD) {
        this.EDUBKGRD = EDUBKGRD;
    }

    public String getEDUBKGRD() {
        return EDUBKGRD;
    }

    public void setEDUBKGRD_AYEAR(String EDUBKGRD_AYEAR) {
        this.EDUBKGRD_AYEAR = EDUBKGRD_AYEAR;
    }

    public String getEDUBKGRD_AYEAR() {
        return EDUBKGRD_AYEAR;
    }

    public void setPRE_MAJOR_FACULTY(String PRE_MAJOR_FACULTY) {
        this.PRE_MAJOR_FACULTY = PRE_MAJOR_FACULTY;
    }

    public String getPRE_MAJOR_FACULTY() {
        return PRE_MAJOR_FACULTY;
    }

    public void setJ_FACULTY_CODE(String J_FACULTY_CODE) {
        this.J_FACULTY_CODE = J_FACULTY_CODE;
    }

    public void setTUTOR_CLASS_MK(String TUTOR_CLASS_MK) {
        this.TUTOR_CLASS_MK = TUTOR_CLASS_MK;
    }

    public String getTUTOR_CLASS_MK() {
        return TUTOR_CLASS_MK;
    }

    public void setUPD_MK(String UPD_MK) {
        this.UPD_MK = UPD_MK;
    }

	public String getFTSTUD_ENROLL_AYEARSMS() {
        return FTSTUD_ENROLL_AYEARSMS;
    }

    public void setFTSTUD_ENROLL_AYEARSMS(String FTSTUD_ENROLL_AYEARSMS) {
        this.FTSTUD_ENROLL_AYEARSMS = FTSTUD_ENROLL_AYEARSMS;
    }

	public String getFTSTUD_CENTER_CODE() {
        return FTSTUD_CENTER_CODE;
    }

    public void setFTSTUD_CENTER_CODE(String FTSTUD_CENTER_CODE) {
        this.FTSTUD_CENTER_CODE = FTSTUD_CENTER_CODE;
    }

	public void setSPECIAL_STTYPE_TYPE(String SPECIAL_STTYPE_TYPE) {
        this.SPECIAL_STTYPE_TYPE = SPECIAL_STTYPE_TYPE;
    }

    public void setFROM_PROG_CODE(String FROM_PROG_CODE) {
        this.FROM_PROG_CODE = FROM_PROG_CODE;
    }

    public void setSTTYPE_CHECK(boolean STTYPE_CHECK) {
        this.STTYPE_CHECK = STTYPE_CHECK;
    }
    
    public void setIDNO_CHECK(boolean IDNO_CHECK) { 
		this.IDNO_CHECK = IDNO_CHECK;
	}
    
    public void setNATIONCODE(String NATIONCODE) { 
		this.NATIONCODE = NATIONCODE;
	}
    
    public void setNEWNATION(String NEWNATION) { 
		this.NEWNATION = NEWNATION;
	}
    
    public void setRESIDENCE_DATE(String RESIDENCE_DATE) { 
		this.RESIDENCE_DATE = RESIDENCE_DATE;
	}
    
    public void setPASSPORT_NO(String PASSPORT_NO) { 
		this.PASSPORT_NO = PASSPORT_NO;  
	}
    
    public void setCheckEdubkgrdGradeStut002(boolean checkEdubkgrdGradeStut002) { 
		this.checkEdubkgrdGradeStut002 = checkEdubkgrdGradeStut002;  //�ק�P�_EDUBKGRD_GRADE='00' �h�������stut002.EDUBKGRD_GRADE
	}
    
    //by poto �]���ۥ� �¿���s�� �m�W�Q�\�������D  �ҥH�n�g������
    public void LOG_STUT002(DBManager dbManager, Connection conn) throws Exception
    {
    	STUT002DAO	STUT002 = new STUT002DAO(dbManager, conn);
    	STUT002.setResultColumn("UPD_RMK, UPD_DATE, UPD_TIME, UPD_USER_ID, ROWSTAMP, IDNO, BIRTHDATE, NAME, ENG_NAME, ALIAS, SEX, SELF_IDENTITY_SEX, VOCATION, EDUBKGRD_GRADE, AREACODE_OFFICE, TEL_OFFICE, TEL_OFFICE_EXT, AREACODE_HOME, TEL_HOME, MOBILE, MARRIAGE, DMSTADDR, DMSTADDR_ZIP, CRRSADDR_ZIP, CRRSADDR, EMAIL, EMRGNCY_TEL, EMRGNCY_RELATION, EMRGNCY_NAME, FAX_AREACODE, FAX_TEL ");
    	STUT002.setIDNO(this.IDNO);
    	STUT002.setBIRTHDATE(this.BIRTHDATE);
    	DBResult rs = STUT002.query();

    	while( rs.next() )
    	{ 
    		Hashtable ht = new Hashtable();
    		ht.put("UPD_RMK","STUADDDATA,���ʾ��y���");
    		ht.put("UPD_DATE", rs.getString("UPD_DATE"));
    		ht.put("UPD_TIME", rs.getString("UPD_TIME"));
    		ht.put("UPD_USER_ID", rs.getString("UPD_USER_ID"));
    		ht.put("ROWSTAMP", rs.getString("ROWSTAMP"));
    		ht.put("IDNO", rs.getString("IDNO"));
    		ht.put("BIRTHDATE", rs.getString("BIRTHDATE"));
    		ht.put("NAME", rs.getString("NAME"));
    		ht.put("ENG_NAME", rs.getString("ENG_NAME"));
    		ht.put("ALIAS", rs.getString("ALIAS"));
    		ht.put("SEX", rs.getString("SEX"));
    		ht.put("SELF_IDENTITY_SEX", rs.getString("SELF_IDENTITY_SEX"));
    		ht.put("VOCATION", rs.getString("VOCATION"));
    		ht.put("EDUBKGRD_GRADE", rs.getString("EDUBKGRD_GRADE"));
    		ht.put("AREACODE_OFFICE", rs.getString("AREACODE_OFFICE"));
    		ht.put("TEL_OFFICE", rs.getString("TEL_OFFICE"));
    		ht.put("TEL_OFFICE_EXT", rs.getString("TEL_OFFICE_EXT"));
    		ht.put("AREACODE_HOME", rs.getString("AREACODE_HOME"));
    		ht.put("TEL_HOME", rs.getString("TEL_HOME"));
    		ht.put("MOBILE", rs.getString("MOBILE"));
    		ht.put("MARRIAGE", rs.getString("MARRIAGE"));
    		ht.put("DMSTADDR", rs.getString("DMSTADDR"));
    		ht.put("DMSTADDR_ZIP", rs.getString("DMSTADDR_ZIP"));
    		ht.put("CRRSADDR_ZIP", rs.getString("CRRSADDR_ZIP"));
    		ht.put("CRRSADDR", rs.getString("CRRSADDR"));
    		ht.put("EMAIL", rs.getString("EMAIL"));
    		ht.put("EMRGNCY_TEL", rs.getString("EMRGNCY_TEL"));
    		ht.put("EMRGNCY_RELATION", rs.getString("EMRGNCY_RELATION"));
    		ht.put("EMRGNCY_NAME", rs.getString("EMRGNCY_NAME"));
    		ht.put("FAX_AREACODE", rs.getString("FAX_AREACODE"));
    		ht.put("FAX_TEL", rs.getString("FAX_TEL"));

    		STUU002DAO	STUU002 = new STUU002DAO(dbManager, conn, ht, this.USER_ID);
    		STUU002.insert();
    	}
    	rs.close();
    }

    public void LOG_STUT003(DBManager dbManager, Connection conn)  throws Exception
    {
    	STUT003DAO	STUT003 = new STUT003DAO(dbManager, conn);
    	STUT003.setResultColumn("STNO, IDNO, BIRTHDATE, ASYS, CENTER_CODE, STTYPE, ENROLL_AYEARSMS, FTSTUD_ENROLL_AYEARSMS, FTSTUD_CENTER_CODE, SUSPEND_AYEARSMS, GRAD_AYEARSMS, DROPOUT_AYEARSMS, STOP_PRVLG_SAYEARSMS, STOP_PRVLG_EAYEARSMS, PRE_MAJOR_FACULTY, J_FACULTY_CODE, EDUBKGRD, NOU_EMAIL, TUTOR_CLASS_MK, DBMAJOR_MK, OTHER_REG_MK, ENROLL_STATUS, ST_PICTURE_SEQ_NO, ACCUM_REPL_CRD, ACCUM_REDUCE_CRD, ACCUM_PASS_CRD, REPL_CNT, REDUCE_TYPE, RMK, UPD_MK, UPD_RMK, UPD_DATE, UPD_TIME, UPD_USER_ID, ROWSTAMP,EDUBKGRD_AYEAR,SPECIAL_STTYPE_TYPE ");
    	STUT003.setSTNO(this.STNO);
    	DBResult rs = STUT003.query();

    	while( rs.next() )
    	{
    		Hashtable ht = new Hashtable();
            ht.put("UPD_RMK","STUADDDATA,���ʾ��y���");
    		ht.put("STNO", rs.getString("STNO"));
    		ht.put("IDNO", rs.getString("IDNO"));
    		ht.put("BIRTHDATE", rs.getString("BIRTHDATE"));
    		ht.put("ASYS", rs.getString("ASYS"));
    		ht.put("CENTER_CODE", rs.getString("CENTER_CODE"));
    		ht.put("STTYPE", rs.getString("STTYPE"));
    		ht.put("ENROLL_AYEARSMS", rs.getString("ENROLL_AYEARSMS"));
    		ht.put("FTSTUD_ENROLL_AYEARSMS", rs.getString("FTSTUD_ENROLL_AYEARSMS"));
    		ht.put("FTSTUD_CENTER_CODE", rs.getString("FTSTUD_CENTER_CODE"));
    		ht.put("SUSPEND_AYEARSMS", rs.getString("SUSPEND_AYEARSMS"));
    		ht.put("DROPOUT_AYEARSMS", rs.getString("DROPOUT_AYEARSMS"));
    		ht.put("STOP_PRVLG_SAYEARSMS", rs.getString("STOP_PRVLG_SAYEARSMS"));
    		ht.put("STOP_PRVLG_EAYEARSMS", rs.getString("STOP_PRVLG_EAYEARSMS"));
    		ht.put("PRE_MAJOR_FACULTY", rs.getString("PRE_MAJOR_FACULTY"));
    		ht.put("J_FACULTY_CODE", rs.getString("J_FACULTY_CODE"));
    		ht.put("EDUBKGRD", rs.getString("EDUBKGRD"));
    		ht.put("NOU_EMAIL", rs.getString("NOU_EMAIL"));
    		ht.put("TUTOR_CLASS_MK", rs.getString("TUTOR_CLASS_MK"));
    		ht.put("DBMAJOR_MK", rs.getString("DBMAJOR_MK"));
    		ht.put("OTHER_REG_MK", rs.getString("OTHER_REG_MK"));
    		ht.put("ENROLL_STATUS", rs.getString("ENROLL_STATUS"));
    		ht.put("ST_PICTURE_SEQ_NO", rs.getString("ST_PICTURE_SEQ_NO"));
    		ht.put("ACCUM_REPL_CRD", rs.getString("ACCUM_REPL_CRD"));
    		ht.put("ACCUM_REDUCE_CRD", rs.getString("ACCUM_REDUCE_CRD"));
    		ht.put("ACCUM_PASS_CRD", rs.getString("ACCUM_PASS_CRD"));
    		ht.put("REDUCE_TYPE", rs.getString("REDUCE_TYPE"));
    		ht.put("RMK", rs.getString("RMK"));
    		ht.put("UPD_RMK", rs.getString("UPD_RMK"));
    		ht.put("UPD_DATE", rs.getString("UPD_DATE"));
    		ht.put("UPD_TIME", rs.getString("UPD_TIME"));
    		ht.put("UPD_USER_ID", rs.getString("UPD_USER_ID"));
    		ht.put("ROWSTAMP", rs.getString("ROWSTAMP"));
    		ht.put("EDUBKGRD_AYEAR", rs.getString("EDUBKGRD_AYEAR"));

    		STUU003DAO	STUU003 = new STUU003DAO(dbManager, conn, ht, this.USER_ID);
    		STUU003.insert();
    	}
    	rs.close();
    }
    public void doStuCareerMainProcess(Connection con)  throws Exception{
    	doAddStuCareer(con,this.AYEAR,this.SMS);    	  	    	
    }
    //���o�e�@�ӾǦ~��
    public Hashtable getAyearSms(String AYEAR,String SMS)  throws Exception
    {
    	Hashtable ht = new Hashtable();
    	String AYEAR_1 = "";
    	String SMS_1 = "";
    	
    	if("2".equals(SMS)){
    		SMS_1 = "1";
    		AYEAR_1 = AYEAR;
    	}else if("3".equals(SMS)){
    		SMS_1 = "2";	
    		AYEAR_1 = String.valueOf(Integer.parseInt(AYEAR)-1);
    	}else if("1".equals(SMS)){
    		SMS_1 = "3";
    		AYEAR_1 = AYEAR;
    	}
    	ht.put("AYEAR_1",AYEAR_1);
    	ht.put("SMS_1",SMS_1);
    	return ht;
    }
    //STUT004����ơA�I�sstucareer�Ƶ{�� �g�J���{
    public void doAddStuCareer(Connection con,String AYEAR,String SMS)  throws Exception{
    	DBResult rs =	dbManager.getSimpleResultSet(con);	
    	StringBuffer	sql		=	new StringBuffer();
		sql.append("SELECT COUNT(1) NUM FROM STUT004 WHERE AYEAR = '"+AYEAR+"' AND SMS = '"+SMS+"' AND STNO = '"+this.STNO+"' ");
		rs.open();
		rs.executeQuery(sql.toString());
		rs.next();
		String NUM = rs.getString("NUM");		
		if("1".equals(NUM))
		{
			STUCAREER stuCareer = new STUCAREER(dbManager);
			stuCareer.setAYEAR(AYEAR);
			stuCareer.setSMS(SMS);
			stuCareer.setSTNO(this.STNO);
			if(!"".equals(this.STTYPE))
				stuCareer.setSTTYPE(this.STTYPE);
			if(!"".equals(this.PRE_MAJOR_FACULTY))
				stuCareer.setPRE_MAJOR_FACULTY(this.PRE_MAJOR_FACULTY);
			if(!"".equals(this.CENTER_CODE))
				stuCareer.setCENTER_CODE(this.CENTER_CODE);
			if(!"".equals(this.J_FACULTY_CODE))
				stuCareer.setJ_FACULTY_CODE(this.J_FACULTY_CODE);
			if(!"".equals(this.PRE_MAJOR_FACULTY))
				stuCareer.setPRE_MAJOR_FACULTY(this.PRE_MAJOR_FACULTY);
			stuCareer.setUSER_ID(this.USER_ID);
			stuCareer.execute();
		}    	
    }
    
    public void doStuCareerFirstProcess(Connection con)  throws Exception{    	
    	if(this.STTYPE_CHECK&&"1".equals(this.ASYS)){    		
    		STUADDCAREER STUADD = new STUADDCAREER(dbManager, con);
            STUADD.setAYEAR(this.AYEAR);
            STUADD.setSMS(this.SMS);
            STUADD.setSTNO(this.STNO);
            STUADD.setUSER_ID(this.USER_ID);
            STUADD.setUPD_RMK("STUADDDATA_�¿���s���s�W");
            STUADD.execute();
    	}    	    	
    }
    /*
     * �ˬdSTUT003, STNO,IDNO ,BIRTHDATE �O�_�s�b
     * ***/
    private boolean checkStut003(DBManager dbManager, Connection conn,String STNO,String IDNO,String BIRTHDATE)  throws Exception
    {
    	boolean check = false;    	
    	DBResult rs = null;
    	try {
    		STUT003DAO	STUT003 = new STUT003DAO(dbManager, conn);
        	STUT003.setResultColumn(" 1 ");
        	STUT003.setWhere("STNO = '"+Utility.dbStr(STNO)+"' AND IDNO = '"+Utility.dbStr(IDNO)+"' AND BIRTHDATE = '"+Utility.dbStr(BIRTHDATE)+"' ");
        	rs = STUT003.query();
        	if( rs.next() )
        	{
        		check = true;
        	}
        } catch (Exception e) {
        	throw e;
    	} finally { 
    		if(rs!=null){
    			rs.close();
    		}
    	}
    	return check;
    }
    
}