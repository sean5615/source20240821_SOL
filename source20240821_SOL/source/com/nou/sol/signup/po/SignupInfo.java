package com.nou.sol.signup.po;

public class SignupInfo {
	private String asys;//學制
	private String idno;//身份證字號
	private String birthdate;//出生日期
	private String centerCode;//報名學習指導中心
	private String sttype;//報名身份別
	private String name;//姓名
	private String alias;//別名
	private String engName;//英文名字
	private String sex;//性別
	private String selfIdentitySex;//自我認同性別
	private String dmstaddr;//戶籍地址
	private String dmstaddrZip;//戶籍地址郵遞區號
	private String crrsaddr;//通訊地址
	private String crrsaddrZip;//通訊地址郵遞區號
	private String areacodeOffice;//電話區碼(公)
	private String telOffice;//電話(公)
	private String telOfficeExt;//電話分機(公)
	private String areacodeHome;//電話區碼(宅)
	private String telHome;//電話(宅)
	private String mobile;//行動電話
	private String email;//電子郵件信箱
	private String edubkgrd;//學歷,
	private String edubkgrdGrade;//最高學歷類別
	private String marriage;//婚姻狀況
	private String vocation;//職業
	private String vocationDept;//服務機關(單位)全銜
	private String preMajorFaculty;//預定科別,預定主修學系
	private String tutorClassMk;//導師班註記
	private String getinfo;//獲得空大招生來源
	private String getinfo_name;//獲得空大招生來源親友姓名
	private String handicapType;//身心殘障種類
	private String handicapGrade;//身心殘障級別
	private String originRace;//原住民族別
	private String emrgncyName;//緊急聯絡人姓名
	private String emrgncyTel;//緊急聯絡人電話
	private String emrgncyRelation;//緊急聯絡人關係
	private String emrgncyEmail;//緊急聯絡人信箱
	private String regManner;//報名方式
	private String updUserId;//異動人員帳號
	private String updDate;//異動日期
	private String updTime;//異動時間
	private String updRmk;//異動註記
	private String ayear;//學年
	private String sms;//學期
	private String jFacultyCode;//報名空專科別
	private String auditResult;//中心審查結果
	private String totalResult;//教務處審查結果
	private String newnation;//新住民原國別
	private String recommendName;//推薦人姓名
	private String recommendId;//推薦人身份證或學號
	private String edubkgrdAyear;//學歷畢業(修)年度
	private String specialSttypeType;//專班類別
	private String overseaNation;//海外居留國別
	private String overseaNationRmk;//海外居留其他國別備註
	private String overseaReason;//海外居留原因
	private String overseaReasonRmk;//海外居留其他原因備註
	private String overseaDoc;//海外居留證件
	private String overseaDocDate;//海外居留證件期限
	private String overseaDocRmk;//海外居留其他證件備註
	private String overseaAddr;//海外居留地址	
	private String mailDoc;//證件郵寄
	private String docAgreeMk;//證明文件真實無誤註記 Y:同意		
	private String newResidentChd;//新住民子女 2:是
	private String fatherName;//新住民子女父親姓名
	private String fatherOriginalCountry;//新住民子女父親國別
	private String motherName;//新住民子女母親姓名	
	private String motherOriginalCountry;//新住民子女母親國別	
	
	public String getEdubkgrdAyear() {
		return edubkgrdAyear;
	}
	public void setEdubkgrdAyear(String edubkgrdAyear) {
		this.edubkgrdAyear = edubkgrdAyear;
	}	
	
	public String getRecommendName() {
		return recommendName;
	}
	public void setRecommendName(String recommendName) {
		this.recommendName = recommendName;
	}	
	
	public String getRecommendId() {
		return recommendId;
	}
	public void setRecommendId(String recommendId) {
		this.recommendId = recommendId;
	}	
	
	public String getTotalResult() {
		return totalResult;
	}
	public void setTotalResult(String totalResult) {
		this.totalResult = totalResult;
	}
	public String getAuditResult() {
		return auditResult;
	}
	public void setAuditResult(String auditResult) {
		this.auditResult = auditResult;
	}
	public String getJFacultyCode() {
		return jFacultyCode;
	}
	public void setJFacultyCode(String facultyCode) {
		jFacultyCode = facultyCode;
	}
	public String getAyear() {
		return ayear;
	}
	public void setAyear(String ayear) {
		this.ayear = ayear;
	}
	public String getSms() {
		return sms;
	}
	public void setSms(String sms) {
		this.sms = sms;
	}
	public String getRegManner() {
		return regManner;
	}
	public void setRegManner(String regManner) {
		this.regManner = regManner;
	}
	public String getUpdDate() {
		return updDate;
	}
	public void setUpdDate(String updDate) {
		this.updDate = updDate;
	}
	public String getUpdRmk() {
		return updRmk;
	}
	public void setUpdRmk(String updRmk) {
		this.updRmk = updRmk;
	}
	public String getUpdTime() {
		return updTime;
	}
	public void setUpdTime(String updTime) {
		this.updTime = updTime;
	}
	public String getUpdUserId() {
		return updUserId;
	}
	public void setUpdUserId(String updUserId) {
		this.updUserId = updUserId;
	}
	public String getBirthdate() {
		return birthdate;
	}
	public void setBirthdate(String birthdate) {
		this.birthdate = birthdate;
	}
	public String getIdno() {
		return idno;
	}
	public void setIdno(String idno) {
		this.idno = idno;
	}
	public String getAreacodeHome() {
		return areacodeHome;
	}
	public void setAreacodeHome(String areacodeHome) {
		this.areacodeHome = areacodeHome;
	}
	public String getAreacodeOffice() {
		return areacodeOffice;
	}
	public void setAreacodeOffice(String areacodeOffice) {
		this.areacodeOffice = areacodeOffice;
	}
	public String getAsys() {
		return asys;
	}
	public void setAsys(String asys) {
		this.asys = asys;
	}
	public String getCrrsaddr() {
		return crrsaddr;
	}
	public void setCrrsaddr(String crrsaddr) {
		this.crrsaddr = crrsaddr;
	}
	public String getDmstaddr() {
		return dmstaddr;
	}
	public void setDmstaddr(String dmstaddr) {
		this.dmstaddr = dmstaddr;
	}
	public String getEdubkgrd() {
		return edubkgrd;
	}
	public void setEdubkgrd(String edubkgrd) {
		this.edubkgrd = edubkgrd;
	}
	public String getEdubkgrdGrade() {
		return edubkgrdGrade;
	}
	public void setEdubkgrdGrade(String edubkgrdGrade) {
		this.edubkgrdGrade = edubkgrdGrade;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public String getEmrgncyName() {
		return emrgncyName;
	}
	public void setEmrgncyName(String emrgncyName) {
		this.emrgncyName = emrgncyName;
	}
	public String getEmrgncyRelation() {
		return emrgncyRelation;
	}
	public void setEmrgncyRelation(String emrgncyRelation) {
		this.emrgncyRelation = emrgncyRelation;
	}
	public String getEmrgncyTel() {
		return emrgncyTel;
	}
	public void setEmrgncyTel(String emrgncyTel) {
		this.emrgncyTel = emrgncyTel;
	}
	public String getEmrgncyEmail() {
		return emrgncyEmail;
	}
	public void setEmrgncyEmail(String emrgncyEmail) {
		this.emrgncyEmail = emrgncyEmail;
	}	
	public String getGetinfo() {
		return getinfo;
	}	
	public void setGetinfo(String getinfo) {
		this.getinfo = getinfo;
	}
	public String getGetinfo_name() {
		return getinfo_name;
	}
	public void setGetinfo_name(String getinfo_name) {
		this.getinfo_name = getinfo_name;
	}
	public String getHandicapGrade() {
		return handicapGrade;
	}
	public void setHandicapGrade(String handicapGrade) {
		this.handicapGrade = handicapGrade;
	}
	public String getHandicapType() {
		return handicapType;
	}
	public void setHandicapType(String handicapType) {
		this.handicapType = handicapType;
	}
	public String getMarriage() {
		return marriage;
	}
	public void setMarriage(String marriage) {
		this.marriage = marriage;
	}
	public String getMobile() {
		return mobile;
	}
	public void setMobile(String mobile) {
		this.mobile = mobile;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getAlias() {
		return alias;
	}
	public void setAlias(String alias) {
		this.alias = alias;
	}
	public String getEngName() {
		return engName;
	}
	public void setEngName(String engName) {
		this.engName = engName;
	}
	public String getOriginRace() {
		return originRace;
	}
	public void setOriginRace(String originRace) {
		this.originRace = originRace;
	}
	public String getPreMajorFaculty() {
		return preMajorFaculty;
	}
	public void setPreMajorFaculty(String preMajorFaculty) {
		this.preMajorFaculty = preMajorFaculty;
	}
	public String getSex() {
		return sex;
	}
	public void setSex(String sex) {
		this.sex = sex;
	}
	public String getSelfIdentitySex() {
		return selfIdentitySex;
	}
	public void setSelfIdentitySex(String selfIdentitySex) {
		this.selfIdentitySex = selfIdentitySex;
	}	
	public String getSttype() {
		return sttype;
	}
	public void setSttype(String sttype) {
		this.sttype = sttype;
	}
	public String getTelHome() {
		return telHome;
	}
	public void setTelHome(String telHome) {
		this.telHome = telHome;
	}
	public String getTelOffice() {
		return telOffice;
	}
	public void setTelOffice(String telOffice) {
		this.telOffice = telOffice;
	}
	public String getTelOfficeExt() {
		return telOfficeExt;
	}
	public void setTelOfficeExt(String telOfficeExt) {
		this.telOfficeExt = telOfficeExt;
	}
	public String getTutorClassMk() {
		return tutorClassMk;
	}
	public void setTutorClassMk(String tutorClassMk) {
		this.tutorClassMk = tutorClassMk;
	}
	public String getVocation() {
		return vocation;
	}
	public void setVocation(String vocation) {
		this.vocation = vocation;
	}
	public String getVocationDept() {
		return vocationDept;
	}
	public void setVocationDept(String vocationDept) {
		this.vocationDept = vocationDept;
	}
	public String getCenterCode() {
		return centerCode;
	}
	public void setCenterCode(String centerCode) {
		this.centerCode = centerCode;
	}
	public String getCrrsaddrZip() {
		return crrsaddrZip;
	}
	public void setCrrsaddrZip(String crrsaddrZip) {
		this.crrsaddrZip = crrsaddrZip;
	}
	public String getDmstaddrZip() {
		return dmstaddrZip;
	}
	public void setDmstaddrZip(String dmstaddrZip) {
		this.dmstaddrZip = dmstaddrZip;
	}
	public String getNewnation() {
		return newnation;
	}
	public void setNewnation(String newnation) {
		this.newnation = newnation;
	}	
	public String getSpecialSttypeType() {
		return specialSttypeType;
	}	
	public void setSpecialSttypeType(String specialSttypeType) {
		this.specialSttypeType = specialSttypeType;
	}
	public String getOverseaNation() {
		return overseaNation;
	}	
	public void setOverseaNation(String overseaNation) {
		this.overseaNation = overseaNation;
	}	
	public String getOverseaNationRmk() {
		return overseaNationRmk;
	}	
	public void setOverseaNationRmk(String overseaNationRmk) {
		this.overseaNationRmk = overseaNationRmk;
	}
	public String getOverseaReason() {
		return overseaReason;
	}	
	public void setOverseaReason(String overseaReason) {
		this.overseaReason = overseaReason;
	}	
	public String getOverseaReasonRmk() {
		return overseaReasonRmk;
	}	
	public void setOverseaReasonRmk(String overseaReasonRmk) {
		this.overseaReasonRmk = overseaReasonRmk;
	}		
	public String getOverseaDoc() {
		return overseaDoc;
	}	
	public void setOverseaDoc(String overseaDoc) {
		this.overseaDoc = overseaDoc;
	}		
	public String getOverseaDocDate() {
		return overseaDocDate;
	}	
	public void setOverseaDocDate(String overseaDocDate) {
		this.overseaDocDate = overseaDocDate;
	}	
	public String getOverseaDocRmk() {
		return overseaDocRmk;
	}	
	public void setOverseaDocRmk(String overseaDocRmk) {
		this.overseaDocRmk = overseaDocRmk;
	}
	public String getOverseaAddr() {
		return overseaAddr;
	}	
	public void setOverseaAddr(String overseaAddr) {
		this.overseaAddr = overseaAddr;
	}
	public String getMailDoc() {
		return mailDoc;
	}	
	public void setMailDoc(String mailDoc) {
		this.mailDoc = mailDoc;
	}
	public String getDocAgreeMk() {
		return docAgreeMk;
	}	
	public void setDocAgreeMk(String docAgreeMk) {
		this.docAgreeMk = docAgreeMk;
	}
	public String getNewResidentChd() {
		return newResidentChd;
	}	
	public void setNewResidentChd(String newResidentChd) {
		this.newResidentChd = newResidentChd;
	}
	public String getFatherName() {
		return fatherName;
	}	
	public void setFatherName(String fatherName) {
		this.fatherName = fatherName;
	}
	public String getFatherOriginalCountry() {
		return fatherOriginalCountry;
	}	
	public void setFatherOriginalCountry(String fatherOriginalCountry) {
		this.fatherOriginalCountry = fatherOriginalCountry;
	}
	public String getMotherName() {
		return motherName;
	}	
	public void setMotherName(String motherName) {
		this.motherName = motherName;
	}
	public String getMotherOriginalCountry() {
		return motherOriginalCountry;
	}	
	public void setMotherOriginalCountry(String motherOriginalCountry) {
		this.motherOriginalCountry = motherOriginalCountry;
	}	
	
}
