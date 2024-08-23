package com.nou.stu.dao;

import com.nou.DAO;
import com.acer.db.DBManager;
import com.acer.util.DateUtil;
import com.acer.util.Utility;

import java.sql.Connection;
import java.util.Hashtable;

import javax.servlet.http.HttpSession;

public class STUU002DAO extends DAO
{
    private STUU002DAO(){
        this.columnAry    =    new String[]{"IDNO","BIRTHDATE","NAME","ENG_NAME","ALIAS","SEX","NATIONCODE","BIRTHPLACE","PASSPORT_NO","VOCATION","EDUBKGRD_GRADE","AREACODE_OFFICE","TEL_OFFICE","TEL_OFFICE_EXT","AREACODE_HOME","TEL_HOME","FAX_AREACODE","FAX_TEL","MOBILE","MARRIAGE","DMSTADDR","DMSTADDR_ZIP","CRRSADDR_ZIP","CRRSADDR","EMAIL","SPECIAL_MK","EMRGNCY_TEL","EMRGNCY_RELATION","EMRGNCY_NAME","UPD_MK","UPD_RMK","UPD_DATE","UPD_TIME","UPD_USER_ID","ROWSTAMP","NEWNATION","RE_IDENTIFY_YYMM","IS_DATE_MK","RMK","RESIDENCE_DATE","SELF_IDENTITY_SEX" };
    }

    public STUU002DAO(DBManager dbManager, Connection conn)
    {
        this();
        this.dbManager    =    dbManager;
        this.conn    =    conn;
        this.tableName    =    "STUU002";
    }

    public STUU002DAO(DBManager dbManager, Connection conn, String USER_ID) throws Exception
    {
        this();
        this.dbManager    =    dbManager;
        this.conn    =    conn;
        this.tableName    =    "STUU002";
        this.setUPD_DATE(DateUtil.getNowDate());
        this.setUPD_TIME(DateUtil.getNowTimeS());
        this.setUPD_USER_ID(USER_ID);
        this.setROWSTAMP(DateUtil.getNowTimeMs());
    }

    public STUU002DAO(DBManager dbManager, Connection conn, Hashtable requestMap, HttpSession session) throws Exception
    {
        this();
        this.dbManager    =    dbManager;
        this.conn    =    conn;
        this.tableName    =    "STUU002";
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

    public STUU002DAO(DBManager dbManager, Connection conn, Hashtable requestMap, String USER_ID) throws Exception
    {
        this();
        this.dbManager    =    dbManager;
        this.conn    =    conn;
        this.tableName    =    "STUU002";
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
    
    public void setIDNO(String IDNO)
    {
        this.columnMap.put ("IDNO", IDNO);
    }

    public void setBIRTHDATE(String BIRTHDATE)
    {
        this.columnMap.put ("BIRTHDATE", BIRTHDATE);
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

    public void setNATIONCODE(String NATIONCODE)
    {
        this.columnMap.put ("NATIONCODE", NATIONCODE);
    }

    public void setBIRTHPLACE(String BIRTHPLACE)
    {
        this.columnMap.put ("BIRTHPLACE", BIRTHPLACE);
    }

    public void setPASSPORT_NO(String PASSPORT_NO)
    {
        this.columnMap.put ("PASSPORT_NO", PASSPORT_NO);
    }

    public void setVOCATION(String VOCATION)
    {
        this.columnMap.put ("VOCATION", VOCATION);
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

    public void setFAX_AREACODE(String FAX_AREACODE)
    {
        this.columnMap.put ("FAX_AREACODE", FAX_AREACODE);
    }

    public void setFAX_TEL(String FAX_TEL)
    {
        this.columnMap.put ("FAX_TEL", FAX_TEL);
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

    public void setSPECIAL_MK(String SPECIAL_MK)
    {
        this.columnMap.put ("SPECIAL_MK", SPECIAL_MK);
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

    public void setUPD_MK(String UPD_MK)
    {
        this.columnMap.put ("UPD_MK", UPD_MK);
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

    public void setNEWNATION(String NEWNATION)
    {
        this.columnMap.put ("NEWNATION", NEWNATION);
    }

    public void setRE_IDENTIFY_YYMM(String RE_IDENTIFY_YYMM)
    {
        this.columnMap.put ("RE_IDENTIFY_YYMM", RE_IDENTIFY_YYMM);
    }

    public void setIS_DATE_MK(String IS_DATE_MK)
    {
        this.columnMap.put ("IS_DATE_MK", IS_DATE_MK);
    }

    public void setRMK(String RMK)
    {
        this.columnMap.put ("RMK", RMK);
    }

    public void setRESIDENCE_DATE(String RESIDENCE_DATE)
    {
        this.columnMap.put ("RESIDENCE_DATE", RESIDENCE_DATE);
    }

    public void setSELF_IDENTITY_SEX(String SELF_IDENTITY_SEX)
    {
        this.columnMap.put ("SELF_IDENTITY_SEX", SELF_IDENTITY_SEX);
    }
}
