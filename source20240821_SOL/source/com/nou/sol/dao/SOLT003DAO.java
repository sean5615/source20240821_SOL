package com.nou.sol.dao;

import com.nou.DAO;
import com.acer.db.DBManager;
import com.acer.util.DateUtil;
import com.acer.util.Utility;

import java.sql.Connection;
import java.util.Hashtable;

import javax.servlet.http.HttpSession;

public class SOLT003DAO extends DAO
{
    private SOLT003DAO(){
        this.columnAry    =    new String[]{"ASYS","AYEAR","SMS","IDNO","BIRTHDATE","CENTER_CODE","STTYPE","PRE_MAJOR_FACULTY","J_FACULTY_CODE","NAME","ENG_NAME","ALIAS","SEX","VOCATION","EDUBKGRD","EDUBKGRD_GRADE","AREACODE_OFFICE","TEL_OFFICE","TEL_OFFICE_EXT","AREACODE_HOME","TEL_HOME","MOBILE","MARRIAGE","DMSTADDR","DMSTADDR_ZIP","CRRSADDR_ZIP","CRRSADDR","EMAIL","EMRGNCY_TEL","EMRGNCY_RELATION","EMRGNCY_NAME","GETINFO","TUTOR_CLASS_MK","HANDICAP_TYPE","HANDICAP_GRADE","ORIGIN_RACE","STNO","REG_MANNER","SERNO","GRAD_AYEAR","REG_DATE","UPD_RMK","UPD_DATE","UPD_TIME","UPD_USER_ID","ROWSTAMP","UPD_IDNO","MAIL_DSTRBT_STATUS","SPECIAL_STTYPE_TYPE","NEWNATION","GETINFO_NAME","NATIONCODE","RECOMMEND_NAME","RECOMMEND_ID","EDUBKGRD_AYEAR","VOCATION_DEPT","RESIDENCE_DATE","OVERSEA_NATION","OVERSEA_NATION_RMK","OVERSEA_REASON","OVERSEA_REASON_RMK","OVERSEA_DOC","OVERSEA_DOC_DATE","OVERSEA_DOC_RMK","OVERSEA_ADDR","EMRGNCY_EMAIL", "MAIL_DOC", "DOC_AGREE_MK", "NEW_RESIDENT_CHD", "FATHER_NAME", "FATHER_ORIGINAL_COUNTRY", "MOTHER_NAME", "MOTHER_ORIGINAL_COUNTRY", "SELF_IDENTITY_SEX"};
    }

    public SOLT003DAO(DBManager dbManager, Connection conn)
    {
        this();
        this.dbManager    =    dbManager;
        this.conn    =    conn;
        this.tableName    =    "SOLT003";
    }

    public SOLT003DAO(DBManager dbManager, Connection conn, String USER_ID) throws Exception
    {
        this();
        this.dbManager    =    dbManager;
        this.conn    =    conn;
        this.tableName    =    "SOLT003";
        this.setUPD_DATE(DateUtil.getNowDate());
        this.setUPD_TIME(DateUtil.getNowTimeS());
        this.setUPD_USER_ID(USER_ID);
        this.setROWSTAMP(DateUtil.getNowTimeMs());
    }

    public SOLT003DAO(DBManager dbManager, Connection conn, Hashtable requestMap, HttpSession session) throws Exception
    {
        this();
        this.dbManager    =    dbManager;
        this.conn    =    conn;
        this.tableName    =    "SOLT003";
        for (int i = 0; i < this.columnAry.length; i++)
        {
            if (requestMap.get(this.columnAry[i]) != null)
                this.columnMap.put(this.columnAry[i], Utility.dbStr(requestMap.get(this.columnAry[i])));
        }
        this.setUPD_DATE(DateUtil.getNowDate());
        this.setUPD_TIME(DateUtil.getNowTimeS());
        this.setUPD_USER_ID((String)session.getAttribute("USER_ID"));
        this.setROWSTAMP(DateUtil.getNowTimeMs());
    }

    public SOLT003DAO(DBManager dbManager, Connection conn, Hashtable requestMap, String USER_ID) throws Exception
    {
        this();
        this.dbManager    =    dbManager;
        this.conn    =    conn;
        this.tableName    =    "SOLT003";
        for (int i = 0; i < this.columnAry.length; i++)
        {
            if (requestMap.get(this.columnAry[i]) != null)
                this.columnMap.put(this.columnAry[i], Utility.dbStr(requestMap.get(this.columnAry[i])));
        }
        this.setUPD_DATE(DateUtil.getNowDate());
        this.setUPD_TIME(DateUtil.getNowTimeS());
        this.setUPD_USER_ID(USER_ID);
        this.setROWSTAMP(DateUtil.getNowTimeMs());
    }
    
    public void setASYS(String ASYS)
    {
        this.columnMap.put ("ASYS", ASYS);
    }

    public void setAYEAR(String AYEAR)
    {
        this.columnMap.put ("AYEAR", AYEAR);
    }

    public void setSMS(String SMS)
    {
        this.columnMap.put ("SMS", SMS);
    }

    public void setIDNO(String IDNO)
    {
        this.columnMap.put ("IDNO", IDNO);
    }

    public void setBIRTHDATE(String BIRTHDATE)
    {
        this.columnMap.put ("BIRTHDATE", BIRTHDATE);
    }

    public void setCENTER_CODE(String CENTER_CODE)
    {
        this.columnMap.put ("CENTER_CODE", CENTER_CODE);
    }

    public void setSTTYPE(String STTYPE)
    {
        this.columnMap.put ("STTYPE", STTYPE);
    }

    public void setPRE_MAJOR_FACULTY(String PRE_MAJOR_FACULTY)
    {
        this.columnMap.put ("PRE_MAJOR_FACULTY", PRE_MAJOR_FACULTY);
    }

    public void setJ_FACULTY_CODE(String J_FACULTY_CODE)
    {
        this.columnMap.put ("J_FACULTY_CODE", J_FACULTY_CODE);
    }

    public void setNAME(String NAME)
    {
        this.columnMap.put ("NAME", NAME);
    }

    public void setENG_NAME(String ENG_NAME)
    {
        this.columnMap.put ("ENG_NAME", ENG_NAME);
    }

    public void setALIAS(String ALIAS)
    {
        this.columnMap.put ("ALIAS", ALIAS);
    }

    public void setSEX(String SEX)
    {
        this.columnMap.put ("SEX", SEX);
    }

    public void setVOCATION(String VOCATION)
    {
        this.columnMap.put ("VOCATION", VOCATION);
    }

    public void setEDUBKGRD(String EDUBKGRD)
    {
        this.columnMap.put ("EDUBKGRD", EDUBKGRD);
    }

    public void setEDUBKGRD_GRADE(String EDUBKGRD_GRADE)
    {
        this.columnMap.put ("EDUBKGRD_GRADE", EDUBKGRD_GRADE);
    }

    public void setAREACODE_OFFICE(String AREACODE_OFFICE)
    {
        this.columnMap.put ("AREACODE_OFFICE", AREACODE_OFFICE);
    }

    public void setTEL_OFFICE(String TEL_OFFICE)
    {
        this.columnMap.put ("TEL_OFFICE", TEL_OFFICE);
    }

    public void setTEL_OFFICE_EXT(String TEL_OFFICE_EXT)
    {
        this.columnMap.put ("TEL_OFFICE_EXT", TEL_OFFICE_EXT);
    }

    public void setAREACODE_HOME(String AREACODE_HOME)
    {
        this.columnMap.put ("AREACODE_HOME", AREACODE_HOME);
    }

    public void setTEL_HOME(String TEL_HOME)
    {
        this.columnMap.put ("TEL_HOME", TEL_HOME);
    }

    public void setMOBILE(String MOBILE)
    {
        this.columnMap.put ("MOBILE", MOBILE);
    }

    public void setMARRIAGE(String MARRIAGE)
    {
        this.columnMap.put ("MARRIAGE", MARRIAGE);
    }

    public void setDMSTADDR(String DMSTADDR)
    {
        this.columnMap.put ("DMSTADDR", DMSTADDR);
    }

    public void setDMSTADDR_ZIP(String DMSTADDR_ZIP)
    {
        this.columnMap.put ("DMSTADDR_ZIP", DMSTADDR_ZIP);
    }

    public void setCRRSADDR_ZIP(String CRRSADDR_ZIP)
    {
        this.columnMap.put ("CRRSADDR_ZIP", CRRSADDR_ZIP);
    }

    public void setCRRSADDR(String CRRSADDR)
    {
        this.columnMap.put ("CRRSADDR", CRRSADDR);
    }

    public void setEMAIL(String EMAIL)
    {
        this.columnMap.put ("EMAIL", EMAIL);
    }

    public void setEMRGNCY_TEL(String EMRGNCY_TEL)
    {
        this.columnMap.put ("EMRGNCY_TEL", EMRGNCY_TEL);
    }

    public void setEMRGNCY_RELATION(String EMRGNCY_RELATION)
    {
        this.columnMap.put ("EMRGNCY_RELATION", EMRGNCY_RELATION);
    }

    public void setEMRGNCY_NAME(String EMRGNCY_NAME)
    {
        this.columnMap.put ("EMRGNCY_NAME", EMRGNCY_NAME);
    }

    public void setGETINFO(String GETINFO)
    {
        this.columnMap.put ("GETINFO", GETINFO);
    }

    public void setTUTOR_CLASS_MK(String TUTOR_CLASS_MK)
    {
        this.columnMap.put ("TUTOR_CLASS_MK", TUTOR_CLASS_MK);
    }

    public void setHANDICAP_TYPE(String HANDICAP_TYPE)
    {
        this.columnMap.put ("HANDICAP_TYPE", HANDICAP_TYPE);
    }

    public void setHANDICAP_GRADE(String HANDICAP_GRADE)
    {
        this.columnMap.put ("HANDICAP_GRADE", HANDICAP_GRADE);
    }

    public void setORIGIN_RACE(String ORIGIN_RACE)
    {
        this.columnMap.put ("ORIGIN_RACE", ORIGIN_RACE);
    }

    public void setSTNO(String STNO)
    {
        this.columnMap.put ("STNO", STNO);
    }

    public void setREG_MANNER(String REG_MANNER)
    {
        this.columnMap.put ("REG_MANNER", REG_MANNER);
    }

    public void setSERNO(String SERNO)
    {
        this.columnMap.put ("SERNO", SERNO);
    }

    public void setGRAD_AYEAR(String GRAD_AYEAR)
    {
        this.columnMap.put ("GRAD_AYEAR", GRAD_AYEAR);
    }

    public void setREG_DATE(String REG_DATE)
    {
        this.columnMap.put ("REG_DATE", REG_DATE);
    }

    public void setUPD_RMK(String UPD_RMK)
    {
        this.columnMap.put ("UPD_RMK", UPD_RMK);
    }

    public void setUPD_DATE(String UPD_DATE)
    {
        this.columnMap.put ("UPD_DATE", UPD_DATE);
    }

    public void setUPD_TIME(String UPD_TIME)
    {
        this.columnMap.put ("UPD_TIME", UPD_TIME);
    }

    public void setUPD_USER_ID(String UPD_USER_ID)
    {
        this.columnMap.put ("UPD_USER_ID", UPD_USER_ID);
    }

    public void setROWSTAMP(String ROWSTAMP)
    {
        this.columnMap.put ("ROWSTAMP", ROWSTAMP);
    }

    public void setUPD_IDNO(String UPD_IDNO)
    {
        this.columnMap.put ("UPD_IDNO", UPD_IDNO);
    }

    public void setMAIL_DSTRBT_STATUS(String MAIL_DSTRBT_STATUS)
    {
        this.columnMap.put ("MAIL_DSTRBT_STATUS", MAIL_DSTRBT_STATUS);
    }

    public void setSPECIAL_STTYPE_TYPE(String SPECIAL_STTYPE_TYPE)
    {
        this.columnMap.put ("SPECIAL_STTYPE_TYPE", SPECIAL_STTYPE_TYPE);
    }
    
    public void setNEWNATION(String NEWNATION)
    {
        this.columnMap.put ("NEWNATION", NEWNATION);
    }
    
    public void setGETINFO_NAME(String GETINFO_NAME)
    {
        this.columnMap.put ("GETINFO_NAME", GETINFO_NAME);
    }
     
    public void setNATIONCODE(String NATIONCODE)
    {
        this.columnMap.put ("NATIONCODE", NATIONCODE);
    }
    
    public void setRECOMMEND_NAME(String RECOMMEND_NAME)
    {
        this.columnMap.put ("RECOMMEND_NAME", RECOMMEND_NAME);
    }
    
    public void setRECOMMEND_ID(String RECOMMEND_ID)
    {
        this.columnMap.put ("RECOMMEND_ID", RECOMMEND_ID);
    }
    
    public void setEDUBKGRD_AYEAR(String EDUBKGRD_AYEAR)
    {
        this.columnMap.put ("EDUBKGRD_AYEAR", EDUBKGRD_AYEAR);
    }
    
    public void setVOCATION_DEPT(String VOCATION_DEPT)
    {
        this.columnMap.put ("VOCATION_DEPT", VOCATION_DEPT);
    }
    
    public void setRESIDENCE_DATE(String RESIDENCE_DATE)
    {
        this.columnMap.put ("RESIDENCE_DATE", RESIDENCE_DATE);
    }
 
    public void setOVERSEA_NATION(String OVERSEA_NATION)
    {
        this.columnMap.put ("OVERSEA_NATION", OVERSEA_NATION);
    }
    
    public void setOVERSEA_NATION_RMK(String OVERSEA_NATION_RMK)
    {
        this.columnMap.put ("OVERSEA_NATION_RMK", OVERSEA_NATION_RMK);
    }
    
    public void setOVERSEA_REASON(String OVERSEA_REASON)
    {
        this.columnMap.put ("OVERSEA_REASON", OVERSEA_REASON);
    }
    
    public void setOVERSEA_REASON_RMK(String OVERSEA_REASON_RMK)
    {
        this.columnMap.put ("OVERSEA_REASON_RMK", OVERSEA_REASON_RMK);
    }
    
    public void setOVERSEA_DOC(String OVERSEA_DOC)
    {
        this.columnMap.put ("OVERSEA_DOC", OVERSEA_DOC);
    }
    
    public void setOVERSEA_DOC_DATE(String OVERSEA_DOC_DATE)
    {
        this.columnMap.put ("OVERSEA_DOC_DATE", OVERSEA_DOC_DATE);
    }
    
    public void setOVERSEA_DOC_RMK(String OVERSEA_DOC_RMK)
    {
        this.columnMap.put ("OVERSEA_DOC_RMK", OVERSEA_DOC_RMK);
    }    
    
    public void setOVERSEA_ADDR(String OVERSEA_ADDR)
    {
        this.columnMap.put ("OVERSEA_ADDR", OVERSEA_ADDR);
    }  
    
    public void setEMRGNCY_EMAIL(String EMRGNCY_EMAIL)
    {
        this.columnMap.put ("EMRGNCY_EMAIL", EMRGNCY_EMAIL);
    }
    
    public void setMAIL_DOC(String MAIL_DOC)
    {
        this.columnMap.put ("MAIL_DOC", MAIL_DOC);
    }
    
    public void setDOC_AGREE_MK(String DOC_AGREE_MK)
    {
        this.columnMap.put ("DOC_AGREE_MK", DOC_AGREE_MK);
    }
    
    public void setNEW_RESIDENT_CHD(String NEW_RESIDENT_CHD)
    {
        this.columnMap.put ("NEW_RESIDENT_CHD", NEW_RESIDENT_CHD);
    }
    
    public void setFATHER_NAME(String FATHER_NAME)
    {
        this.columnMap.put ("FATHER_NAME", FATHER_NAME);
    }  
    
    public void setFATHER_ORIGINAL_COUNTRY(String FATHER_ORIGINAL_COUNTRY)
    {
        this.columnMap.put ("FATHER_ORIGINAL_COUNTRY", FATHER_ORIGINAL_COUNTRY);
    }  
    
    public void setMOTHER_NAME(String MOTHER_NAME)
    {
        this.columnMap.put ("MOTHER_NAME", MOTHER_NAME);
    }  
    
    public void setMOTHER_ORIGINAL_COUNTRY(String MOTHER_ORIGINAL_COUNTRY)
    {
        this.columnMap.put ("MOTHER_ORIGINAL_COUNTRY", MOTHER_ORIGINAL_COUNTRY);
    }

    public void setSELF_IDENTITY_SEX(String SELF_IDENTITY_SEX)
    {
        this.columnMap.put ("SELF_IDENTITY_SEX", SELF_IDENTITY_SEX);
    } 
}