package com.nou.sol.signup.po;

public class SignupInfo {
	private String asys;//�Ǩ�
	private String idno;//�����Ҧr��
	private String birthdate;//�X�ͤ��
	private String centerCode;//���W�ǲ߫��ɤ���
	private String sttype;//���W�����O
	private String name;//�m�W
	private String alias;//�O�W
	private String engName;//�^��W�r
	private String sex;//�ʧO
	private String selfIdentitySex;//�ۧڻ{�P�ʧO
	private String dmstaddr;//���y�a�}
	private String dmstaddrZip;//���y�a�}�l���ϸ�
	private String crrsaddr;//�q�T�a�}
	private String crrsaddrZip;//�q�T�a�}�l���ϸ�
	private String areacodeOffice;//�q�ܰϽX(��)
	private String telOffice;//�q��(��)
	private String telOfficeExt;//�q�ܤ���(��)
	private String areacodeHome;//�q�ܰϽX(�v)
	private String telHome;//�q��(�v)
	private String mobile;//��ʹq��
	private String email;//�q�l�l��H�c
	private String edubkgrd;//�Ǿ�,
	private String edubkgrdGrade;//�̰��Ǿ����O
	private String marriage;//�B�ê��p
	private String vocation;//¾�~
	private String vocationDept;//�A�Ⱦ���(���)����
	private String preMajorFaculty;//�w�w��O,�w�w�D�׾Ǩt
	private String tutorClassMk;//�ɮv�Z���O
	private String getinfo;//��o�Ťj�ۥͨӷ�
	private String getinfo_name;//��o�Ťj�ۥͨӷ��ˤͩm�W
	private String handicapType;//���ߴݻٺ���
	private String handicapGrade;//���ߴݻٯŧO
	private String originRace;//�����ڧO
	private String emrgncyName;//����p���H�m�W
	private String emrgncyTel;//����p���H�q��
	private String emrgncyRelation;//����p���H���Y
	private String emrgncyEmail;//����p���H�H�c
	private String regManner;//���W�覡
	private String updUserId;//���ʤH���b��
	private String updDate;//���ʤ��
	private String updTime;//���ʮɶ�
	private String updRmk;//���ʵ��O
	private String ayear;//�Ǧ~
	private String sms;//�Ǵ�
	private String jFacultyCode;//���W�űM��O
	private String auditResult;//���߼f�d���G
	private String totalResult;//�аȳB�f�d���G
	private String newnation;//�s������O
	private String recommendName;//���ˤH�m�W
	private String recommendId;//���ˤH�����ҩξǸ�
	private String edubkgrdAyear;//�Ǿ����~(��)�~��
	private String specialSttypeType;//�M�Z���O
	private String overseaNation;//���~�~�d��O
	private String overseaNationRmk;//���~�~�d��L��O�Ƶ�
	private String overseaReason;//���~�~�d��]
	private String overseaReasonRmk;//���~�~�d��L��]�Ƶ�
	private String overseaDoc;//���~�~�d�ҥ�
	private String overseaDocDate;//���~�~�d�ҥ����
	private String overseaDocRmk;//���~�~�d��L�ҥ�Ƶ�
	private String overseaAddr;//���~�~�d�a�}	
	private String mailDoc;//�ҥ�l�H
	private String docAgreeMk;//�ҩ����u��L�~���O Y:�P�N		
	private String newResidentChd;//�s����l�k 2:�O
	private String fatherName;//�s����l�k���˩m�W
	private String fatherOriginalCountry;//�s����l�k���˰�O
	private String motherName;//�s����l�k���˩m�W	
	private String motherOriginalCountry;//�s����l�k���˰�O	
	
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
