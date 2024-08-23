<%@ page contentType="text/html;charset=utf-8"%>
<%@page import="java.util.*"%>
<%@page import="com.nou.sol.signup.po.*"%>
<%@page import="com.nou.sol.signup.tool.*"%>
<%@ page import="com.nou.sys.dao.*"%>
<%@ page import="com.nou.sys.*"%>
<%@page import="com.nou.sol.dao.*"%>
<%@page import="com.acer.ajax.*,
		com.acer.util.*,
		com.acer.db.query.*,
		com.acer.form.*,
		com.acer.ajax.*,
		com.acer.log.*,
		com.acer.apps.*,
		com.acer.report.*,
		com.acer.file.*,
		com.acer.db.*,
		com.nou.aut.*,
		com.nou.gra.dao.GRAT003DAO,
		com.nou.pcs.dao.PCST012DAO,
		java.sql.*,
		java.util.*,
		java.io.*,com.nou.aut.*,
		java.util.Date,
		java.text.SimpleDateFormat"%>
<%
	SignupInfo signupInfo = (SignupInfo) request.getAttribute("signupInfo");
	String edubkgrd1 = Utility.checkNull(request.getAttribute("edubkgrd1"),"");
	String edubkgrd2 = (String) request.getAttribute("edubkgrd2");
	//String edubkgrd3 = (String) request.getAttribute("edubkgrd3");
	String mode = (String) request.getAttribute("mode");
	// String type = (String) request.getAttribute("type");
	String type = Utility.checkNull((String) request.getAttribute("type"), "");	
	String checktype = Utility.checkNull((String) request.getAttribute("checktype"), "");//by poto 檢查身分別 舊選轉新全 or 新生
	String sttype = (String) request.getAttribute("STTYPE");
	String edubkgrdGrade = (String) request.getAttribute("EDUBKGRD_GRADE");
	String vocation = (String) request.getAttribute("VOCATION");
	String vocationDept = signupInfo.getVocationDept();
	String tutorClassMk = (String) request.getAttribute("TUTOR_CLASS_MK");
	String getinfo = (String) request.getAttribute("GETINFO");
	String handicapType = (String) request.getAttribute("HANDICAP_TYPE");
	String handicapGrade = (String) request.getAttribute("HANDICAP_GRADE");
	String originRace = (String) request.getAttribute("ORIGIN_RACE");
	String nation = (String) request.getAttribute("NATIONCODE");
	String newnation = (String) request.getAttribute("NEWNATION");
	//String auditResult = (String) request.getAttribute("AUDIT_RESULT");
	String sex = (String) request.getAttribute("SEX");
	String selfIdentitySex = (String) request.getAttribute("SELF_IDENTITY_SEX");
	String asys = (String) request.getAttribute("ASYS");
	String emrgncyRelation = (String) request.getAttribute("EMRGNCY_RELATION");
	String emrgncyEmail = (String) request.getAttribute("EMRGNCY_EMAIL");
	String preMajorFaculty = (String) request.getAttribute("PRE_MAJOR_FACULTY");
	String centerCode = (String) request.getAttribute("CENTER_CODE");
	String sms = (String) request.getAttribute("SMS");
	String alias = (String) request.getAttribute("ALIAS");
	String engName = (String) request.getAttribute("ENG_NAME");
	String specialSttypeType = signupInfo.getSpecialSttypeType();
	String overseaNation = (String) request.getAttribute("OVERSEA_NATION"); //海外居留國別
	String overseaNationRmk = (String) request.getAttribute("OVERSEA_NATION_RMK");//海外居留其他國別備註
	String overseaReason = (String) request.getAttribute("OVERSEA_REASON");//海外居留原因
	String overseaReasonRmk = (String) request.getAttribute("OVERSEA_REASON_RMK");//海外居留其他原因備註
	String overseaDoc = (String) request.getAttribute("OVERSEA_DOC");//海外居留證件
	String overseaDocDate = (String) request.getAttribute("OVERSEA_DOC_DATE");//海外居留證件期限
	String overseaDocRmk = (String) request.getAttribute("OVERSEA_DOC_RMK");//海外居留其他證件備註
	String overseaAddr = (String) request.getAttribute("OVERSEA_ADDR");//海外居留地址
	String docAgreeMk = (String) request.getAttribute("DOC_AGREE_MK");//證明文件真實無誤註記 Y:同意
	String newResidentChd = (String) request.getAttribute("NEW_RESIDENT_CHD");//新住民子女 2:是
	String fatherName = (String) request.getAttribute("FATHER_NAME");//新住民子女父親姓名
	String fatherOriginalCountry = (String) request.getAttribute("FATHER_ORIGINAL_COUNTRY");//新住民子女父親國別
	String motherName = (String) request.getAttribute("MOTHER_NAME");//新住民子女母親姓名
	String motherOriginalCountry = (String) request.getAttribute("MOTHER_ORIGINAL_COUNTR");//新住民子女母親國別
	
	
	String fromSite = (String) session.getAttribute("site");		//20210409 (海外生 site = "oversea")
	String specialSwitch = (String) request.getAttribute("specialSwitch");
	
	System.out.println("special switch = " + specialSwitch);
	
	String security = Utility.checkNull((String) request.getAttribute("security"),"");  // 認證訊息--檢核不過後
	session.removeAttribute("NEXTAYEAR");
    session.removeAttribute("NEXTSMS");
    MyLogger logger  =  new MyLogger(request.getRequestURI().toString() + "(sol/signup)");
    logger.iniUserInfo(Log4jInit.getIP(request));
    DBManager dbManager    =    new DBManager(logger);
    SYSGETSMSDATA sysgetsmsdata = new SYSGETSMSDATA(dbManager);
    sysgetsmsdata.setSYS_DATE(DateUtil.getNowDate());
    sysgetsmsdata.setSMS_TYPE("3");
    sysgetsmsdata.execute();
    String nextayear = sysgetsmsdata.getAYEAR();
    String nextsms   = sysgetsmsdata.getSMS();
	if(nextsms.equals("3"))
		nextsms = "1";
    session.setAttribute("NEXTAYEAR",nextayear);
    session.setAttribute("NEXTSMS",nextsms);
	Connection	conn	=	null;
	String enrollBasedate = "";
	try
	{
		conn = dbManager.getConnection(AUTCONNECT.mapConnect("SOL", session));
		SYST005DAO SYST005 = new SYST005DAO(dbManager,conn);
		SYST005.setResultColumn("ENROLL_BASEDATE");
		SYST005.setAYEAR(nextayear);
		SYST005.setSMS(nextsms);
	    DBResult rs = SYST005.query();
		if(rs.next()) 
		{
		    enrollBasedate = rs.getString("ENROLL_BASEDATE");
		}
	}
	catch (Exception ex)
	{
		throw ex;
	}
	finally
	{
		dbManager.close();
	}
	
%>

<%
	/* 20200529 新增 去判斷有沒有在本校大學部取得學士學位 */
	String g003HasData = "N";
	try {
		String g003Idno = signupInfo.getIdno();
		if(!"".equals(g003Idno)) {
			conn = dbManager.getConnection(AUTCONNECT.mapConnect("SOL", session));
			GRAT003DAO g003 = new GRAT003DAO(dbManager,conn);
			g003.setResultColumn("STNO");
			g003.setWhere("GRAD_PROVE_NUMBER_1 is not null  and idno = '" + signupInfo.getIdno() + "' ");
		    DBResult rs = g003.query();
			if(rs.next()) {
				g003HasData = "Y";
			}
		}
	}
	catch (Exception ex)
	{
		throw ex;
	}
	finally
	{
		dbManager.close();
	}
	
	/* 20210428 新增 判斷信用卡繳費開關是否要開啟 */
	String showPayBtn = "Y";
	try {
		
		if(!"".equals(signupInfo.getIdno())) {
			conn = dbManager.getConnection(AUTCONNECT.mapConnect("SOL", session));
			PCST012DAO p012 = new PCST012DAO(dbManager,conn);
			p012.setResultColumn("BUSS_RESULT");
			p012.setWhere("STNO = 'SOL' and idno = '" + signupInfo.getIdno() + "' ");
		    DBResult rs = p012.query();
			if(rs.next()) {
				if("000".equals(rs.getString("BUSS_RESULT"))) {
					showPayBtn = "N";
				}
			}
		}
	}
	catch (Exception ex)
	{
		throw ex;
	}
	finally
	{
		dbManager.close();
	}
	
	/*	20210511修改 只有海外生可透過信用卡繳費, 20210823全面開放不分身分別	*/
	//if(!"oversea".equals(fromSite)) {
	//	showPayBtn = "N";
	//}

%>

<%

//新增專班類別下拉選單取得 及來源網址判斷

	String SpecialSttypeMk = "";
	String isSolStud1 = "N";
	
	
	

	if("Y".equals(specialSwitch)) {
		Vector result = new Vector();
		
		if(!"special".equals(fromSite)) {
			isSolStud1 = "N";
		} else {
			isSolStud1 = "Y";
			try {
				
				SpecialSttypeMk = "<option value=''>請選擇</option>";
				
			    conn       =    dbManager.getConnection(AUTCONNECT.mapConnect("SOL", session));
			    SOLT011GATEWAY  SOLT011gatway  =    new SOLT011GATEWAY(dbManager, conn);
			    result =  SOLT011gatway.getSolt011SpecialSttypeType(signupInfo.getAyear(), signupInfo.getSms());
			    String ymd = DateUtils.getNowDate();
			    
			    for(int i = 0 ; i < result.size(); i++) {
		            Hashtable rowHt = (Hashtable) result.get(i);
		            String sDate = Utility.nullToSpace(rowHt.get("SDATE"));
		            String eDate = Utility.nullToSpace(rowHt.get("EDATE"));
		            //日期判斷
		            if( ymd.compareTo(sDate) > 0 && ymd.compareTo(eDate) < 0 ) {
		            	//在開始日期跟結束日期中間
		            	SpecialSttypeMk += "<option value='";
		                SpecialSttypeMk += Utility.nullToSpace(rowHt.get("SPECIAL_STTYPE_TYPE"));
		                
						if(Utility.nullToSpace(rowHt.get("SPECIAL_STTYPE_TYPE")).equals(specialSttypeType)) {
							SpecialSttypeMk += "' selected>";
		            	} else {
		            		SpecialSttypeMk += "'>";
		            	}
		                
		                SpecialSttypeMk += Utility.nullToSpace(rowHt.get("CODE_NAME"));
		                SpecialSttypeMk += "</option>";
		            } else if(sDate.equals(ymd) || eDate.equals(ymd)) {
		            	
	            		//今天日期跟開始或結束日期一樣
	            		SpecialSttypeMk += "<option value='";
	                    SpecialSttypeMk += Utility.nullToSpace(rowHt.get("SPECIAL_STTYPE_MK"));
	                    
	                    if(Utility.nullToSpace(rowHt.get("SPECIAL_STTYPE_TYPE")).equals(specialSttypeType)) {
							SpecialSttypeMk += "' selected>";
		            	} else {
		            		SpecialSttypeMk += "'>";
		            	}
	                    
	                    SpecialSttypeMk += Utility.nullToSpace(rowHt.get("CODE_NAME"));
	                    SpecialSttypeMk += "</option>";
		            }
		            
			    }
			    
			} catch (Exception ex) {				
			    throw ex;
			} finally {
			    dbManager.close();
			    if (conn != null)
			        conn.close();
			    conn    =    null;			    
			}
		}
	}else if("oversea".equals(fromSite)) {
		//海外生要處理邏輯
		
	}
	
%>

<html>
<head>
<title>國立空中大學教務行政資訊系統</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="css/signup.css" rel="stylesheet" type="text/css" />

<style type="text/css">
<!--
a:hover {
	position : relative; top : 1px; left : 1px;
}
.font01{
	color:#165ccf;
	size:10px;
	}

-->

body.loading {
    overflow: hidden;   
}
body.loading .modal {
    display: block;
}
.modal {
    display:    none;
    position:   fixed;
    z-index:    1000;
    top:        0;
    left:       0;
    height:     100%;
    width:      100%;
   color: 		#000000;
   text-align:	center;
   background: rgba( 255, 255, 255, .8 );          
}

</style>

<!-- 懸浮視窗用 -->
<style> 
        .black_overlay{ 
            display: none; 
            position: absolute; 
            top: 0%; 
            left: 0%; 
            width: 100%; 
            height: 100%; 
            background-color: black; 
            z-index:1001; 
            -moz-opacity: 0.8; 
            opacity:.80; 
            filter: alpha(opacity=88); 
        } 
        .white_content { 
            display: none; 
            position: absolute; 
            top: 25%; 
            left: 25%; 
            width: 55%; 
            height: 55%; 
            padding: 20px; 
/*             border: 5px solid #ff4c00;  */
            background-color: white; 
            z-index:1002; 
            overflow: auto; 
        } 
    </style> 


<script type='text/javascript'>
var permission='2';
var mode='';
</script>

<script type="text/javascript" src="js/check.js"></script>
<script type="text/javascript" src="js/message.js"></script>
<script type="text/javascript" src="js/strfunc.js"></script>
<script type="text/javascript" src="js/form.js"></script>
<script src="../../script/Base.js"></script>

<script type="text/javascript">
//doImport("Form.js, Ajax_0_2.js");
function init(){
	
	try{
		document.getElementById("body").setAttribute("class","loading" );	
		
		var theForm = document.forms["solMainForm"];
		
		var message = "<%= (String) request.getAttribute("message") %>";
		if(message != null && message != "" && message != "null"){
			alert(message);
		}
		
		theForm.elements["asys"].value = '<%= signupInfo.getAsys() == null ? "" : signupInfo.getAsys() %>';
		theForm.elements["sms"].value = '<%= signupInfo.getSms() == null ? "" : signupInfo.getSms() %>';
		theForm.elements["type"].value = '<%= type == null ? "" : type %>';
		theForm.elements["signupInfo.centerCode"].value = '<%= signupInfo.getCenterCode() == null ? "" : signupInfo.getCenterCode() %>';

		
		if(theForm.elements["asys"].value == '2'){
			theForm.elements["signupInfo.sttype"].value = '3';
		}else{
			theForm.elements["signupInfo.sttype"].value = '<%= signupInfo.getSttype() == null ? "" : signupInfo.getSttype() %>';
		}
		
		theForm.elements["signupInfo.sex"].value = '<%= signupInfo.getSex() == null ? signupInfo.getIdno().substring(1, 2) : signupInfo.getSex() %>';
		theForm.elements["signupInfo.selfIdentitySex"].value = '<%= signupInfo.getSelfIdentitySex() == null ? "" : signupInfo.getSelfIdentitySex() %>';
		theForm.elements["edubkgrd2"].value = '<%= edubkgrd2 == null ? "" : edubkgrd2 %>';
		theForm.elements["signupInfo.edubkgrdGrade"].value = '<%= signupInfo.getEdubkgrdGrade() == null ? "" : signupInfo.getEdubkgrdGrade() %>';
		theForm.elements["signupInfo.vocation"].value = '<%= signupInfo.getVocation() == null ? "" : signupInfo.getVocation() %>';
		theForm.elements["signupInfo.preMajorFaculty"].value = '<%= signupInfo.getPreMajorFaculty() == null ? "" : signupInfo.getPreMajorFaculty() %>';
		theForm.elements["signupInfo.tutorClassMk"].value = '<%= signupInfo.getTutorClassMk() == null ? "1" : signupInfo.getTutorClassMk() %>';
		theForm.elements["signupInfo.getinfo"].value = '<%= signupInfo.getGetinfo() == null ? "" : signupInfo.getGetinfo() %>';
		theForm.elements["signupInfo.handicapType"].value = '<%= signupInfo.getHandicapType() == null ? "" : signupInfo.getHandicapType() %>';
		theForm.elements["signupInfo.handicapGrade"].value = '<%= signupInfo.getHandicapGrade() == null ? "" : signupInfo.getHandicapGrade() %>';
		theForm.elements["signupInfo.originRace"].value = '<%= signupInfo.getOriginRace() == null ? "" : signupInfo.getOriginRace() %>';
		theForm.elements["signupInfo.emrgncyRelation"].value = '<%= signupInfo.getEmrgncyRelation() == null ? "" : signupInfo.getEmrgncyRelation() %>';
		theForm.elements["signupInfo.emrgncyEmail"].value = '<%= signupInfo.getEmrgncyEmail() == null ? "" : signupInfo.getEmrgncyEmail() %>';
		theForm.elements["signupInfo.tutorClassMk"].disabled = true;
		theForm.elements["signupInfo.newnation"].value = '<%= signupInfo.getNewnation() == null ? "" : signupInfo.getNewnation() %>';
		theForm.elements["signupInfo.overseaNation"].value = '<%= signupInfo.getOverseaNation() == null ? "" : signupInfo.getOverseaNation() %>';
		theForm.elements["signupInfo.overseaNationRmk"].value = '<%= signupInfo.getOverseaNationRmk() == null ? "" : signupInfo.getOverseaNationRmk() %>';
		theForm.elements["signupInfo.overseaReason"].value = '<%= signupInfo.getOverseaReason() == null ? "" : signupInfo.getOverseaReason() %>';
		theForm.elements["signupInfo.overseaReasonRmk"].value = '<%= signupInfo.getOverseaReasonRmk() == null ? "" : signupInfo.getOverseaReasonRmk() %>';
		theForm.elements["signupInfo.overseaDoc"].value = '<%= signupInfo.getOverseaDoc() == null ? "" : signupInfo.getOverseaDoc() %>';
		theForm.elements["signupInfo.overseaDocDate"].value = '<%= signupInfo.getOverseaDocDate() == null ? "" : signupInfo.getOverseaDocDate() %>';
		theForm.elements["signupInfo.overseaDocRmk"].value = '<%= signupInfo.getOverseaDocRmk() == null ? "" : signupInfo.getOverseaDocRmk() %>';
		theForm.elements["signupInfo.overseaAddr"].value = '<%= signupInfo.getOverseaAddr() == null ? "" : signupInfo.getOverseaAddr() %>';
		theForm.elements["signupInfo.docAgreeMk"].value = '<%= signupInfo.getDocAgreeMk() == null ? "" : signupInfo.getDocAgreeMk() %>';
		theForm.elements["signupInfo.newResidentChd"].value = '<%= signupInfo.getNewResidentChd() == null ? "" : signupInfo.getNewResidentChd() %>';
		theForm.elements["signupInfo.fatherName"].value = '<%= signupInfo.getFatherName() == null ? "" : signupInfo.getFatherName() %>';
		theForm.elements["signupInfo.fatherOriginalCountry"].value = '<%= signupInfo.getFatherOriginalCountry() == null ? "" : signupInfo.getFatherOriginalCountry() %>';
		theForm.elements["signupInfo.motherName"].value = '<%= signupInfo.getMotherName() == null ? "" : signupInfo.getMotherName() %>';
		theForm.elements["signupInfo.motherOriginalCountry"].value = '<%= signupInfo.getMotherOriginalCountry() == null ? "" : signupInfo.getMotherOriginalCountry() %>';
		// 若審查通過則不允許修改
		var auditResult = "<%= signupInfo.getAuditResult() %>";
		var totalResult = "<%= signupInfo.getTotalResult() %>";
		if(auditResult == "0" || totalResult == "0"){
			var e = document.getElementsByTagName("input");
			for(var i=0;i<e.length;i++){
				if(e[i].name != 'print'){
					e[i].disabled = true;
				}
			}
			
			e = document.getElementsByTagName("select");
			for(var i=0;i<e.length;i++){
				e[i].disabled = true;
			}
		}
		
		if(<%=!"oversea".equals(fromSite) %>) {
			theForm.elements["signupInfo.overseaReason"].disabled = true;
			theForm.elements["signupInfo.overseaNation"].disabled = true;
			theForm.elements["signupInfo.overseaDoc"].disabled = true;
			theForm.elements["signupInfo.overseaDocDate"].disabled = true;
			theForm.elements["signupInfo.overseaAddr"].disabled = true;
		}
		
		var sttypeMessage = "<%= type %>";	
		if(<%=type.equals("5")%>)
		{
			//舊選轉新全
			document.getElementById("sttypeMessage").innerHTML  = "舊選修生修滿40學分";
			theForm.elements["signupInfo.sttype"].value = theForm.elements["asys"].value=='1'?"1":"3";
			theForm.elements["signupInfo.sttype"].disabled = true;

			// 當所帶出的學歷為空時且為就選轉新全,則虛有預設值
			if(<%=edubkgrd1.equals("")%>){
				theForm.elements["edubkgrd1"].value = "選修生身分修得國立空中大學開設之課程40學分";
				theForm.elements["signupInfo.edubkgrdGrade"].value = "10";
				// 最高學歷預設為其他
				theForm.elements["edubkgrd2"].value = "其他";
			}
		}else if(<%=type.equals("13")%>){
			//空大畢業生
			document.getElementById("sttypeMessage").innerHTML  = "空大畢業生";
			theForm.elements["edubkgrd1"].value = "國立空中大學";
			theForm.elements["edubkgrd2"].value = "畢業";
		}else if(<%=type.equals("14")%>){
			//空專畢業生
			document.getElementById("sttypeMessage").innerHTML  = "空專畢業生";
			theForm.elements["edubkgrd1"].value = "國立空中大學附設專科部";
			theForm.elements["edubkgrd2"].value = "畢業";
		}else if(<%=type.equals("2")%>){
			//雙主修
			theForm.elements["signupInfo.sttype"].value = "1";
			theForm.elements["signupInfo.sttype"].disabled = true;
			document.getElementById("sttypeMessage").innerHTML  = "放棄雙主修";
		}
		// 如全修生曾修滿40學分且報名空專(因空大已不得報名)則免收報名費--此時為空專
		else if(<%=type.equals("20")%>)
		{
			document.getElementById("sttypeMessage").innerHTML  = "全修生修滿40學分";
			theForm.elements["signupInfo.sttype"].value = "3";
			theForm.elements["signupInfo.sttype"].disabled = true;
		}
		// 如全修生曾修滿40學分且報名空專(因空大已不得報名)則免收報名費--此時為空專
		else if(<%=type.equals("6")%>)
		{
			//alert('選修生不滿40學分，如有學歷證明可報全修生\r\n舊生網路選課請勿報名，請進教務行政資訊系統');
			if (confirm("選修生不滿40學分，如有學歷證明可報全修生\r\n\r\n舊生網路選課請勿報名，請進教務行政資訊系統")){
				document.getElementById("sttypeMessage").innerHTML  = "選修生未滿40學分";
				theForm.elements["signupInfo.sttype"].value = "1";
				theForm.elements["signupInfo.sttype"].disabled = true;
			}else{
				var theForm = document.forms["solMainForm"];
				theForm.action = '/sol/signup/SolMainAction.do?method=index';
				theForm.submit();
			}
			
		//	checkAge(); // 選全修生需檢核年齡
		}
		else{
			document.getElementById("sttypeMessage").innerHTML  = "";
		} 
		
		doLock(theForm.elements["signupInfo.handicapType"].value);
		
		doLock1(theForm.elements["signupInfo.newResidentChd"].value);

		// 顯示認證失敗的訊息
		if(<%=!security.equals("")%>){
			alert('認證失敗，請重新輸入認證碼');
			document.solMainForm.securityCode.focus();
		}
		
		//判斷從哪來的
		
		if(<%="N".equals(specialSwitch) || "".equals(specialSwitch) ||  specialSwitch == null %>) {
			removeSpecialSelectOption();
		} 
		
		if(<%="N".equals(isSolStud1) %>) {
			removeSpecialSelectOption();
		}
		
		if(<%="Y".equals(g003HasData) %>) {
			theForm.elements["edubkgrd1"].value = "國立空中大學";
			theForm.elements["edubkgrd2"].value = "畢業";
			theForm.elements["signupInfo.edubkgrdGrade"].value = "11";
		}

		//海外生畫面控制
		if(!<%="oversea".equals(fromSite) %>) {
			document.getElementById("overSeaTr1").style.display= "none";
			document.getElementById("overSeaTr2").style.display= "none";
			document.getElementById('signupInfo.overseaReason').check = "";
			document.getElementById('signupInfo.overseaNation').check = "";
			document.getElementById('signupInfo.overseaDoc').check = "";
			document.getElementById('signupInfo.overseaAddr').check = "";
		}
		
		//by poto
// 		Form.iniFormSet('solMainForm', 'signupInfo.dmstaddr', 'FS');
// 		Form.iniFormSet('solMainForm', 'signupInfo.crrsaddr', 'FS');
	} finally {
		document.getElementById("body").setAttribute("class","" );
	}
	
}

function removeSpecialSelectOption() {
	try{
		var asysTR = document.getElementById("asysTR");
		var classSSM = document.getElementById("CLASS_SPECIAL_STTYPE_MK");
		var specialSelectOption = document.getElementById("specialSelectOption");
		var classASYS = document.getElementById("CLASS_ASYS");
		asysTR.removeChild(classSSM);
		asysTR.removeChild(specialSelectOption);
		classASYS.setAttribute("colSpan", "3");
	} catch(e) {
		console.log("removeSpecialSelectOption 有錯誤");
		console.log(e);
	}
}

function doSave(){	
	
	
	var theForm = document.forms["solMainForm"];
	
	var sttypeTmp = theForm.elements["signupInfo.sttype"].value;
	// 按所選的入學方式來檢核年紀
	if(!checkAge()){
		theForm.elements["signupInfo.sttype"].value = sttypeTmp;
		return;
	}

	
	if(submitCheck(document.solMainForm)){
		if(doSttype()){
			if(doCheckOldStudent()){
				if(confirm("請核對資料是否正確！資料確定存檔〝姓名〞資料將無法再做更改！※重要提醒：為使您可收到校務或教學相關訊息，請再次確認您的「個人電子信箱」是否正確無誤。")){
					var mode = "<%= mode %>";

					theForm.elements["signupInfo.idno"].disabled = false;
					theForm.elements["signupInfo.birthdate"].disabled = false;
					theForm.elements["signupInfo.sttype"].disabled = false;
					theForm.elements["signupInfo.tutorClassMk"].disabled = false;
					
					if(theForm.elements["signupInfo.recommendName"].value != "" && theForm.elements["signupInfo.recommendId"].value == ""){
						alert("請輸入推薦人學號或身分證字號！");
						return;
    				}
					
					if(theForm.elements["signupInfo.sttype"].value == "1"){
				    	var EDU = theForm.elements["signupInfo.edubkgrdGrade"].value*1;
						if(EDU < 3){
							alert("報名空大全修生\"最高學歷類別\"必須高中以上！");
	    					return;
						}
    				}
					
					if(theForm.elements["signupInfo.asys"].value == "2"){
				    	var EDU = theForm.elements["signupInfo.edubkgrdGrade"].value*1;
						if(EDU < 3){
							alert("報名空專\"最高學歷類別\"必須高中以上！");
					    	return;
						}
				    }
					
					if(mode == "update"){
						theForm.elements["signupInfo.birthdate"].disabled = false;
						theForm.action = '/sol/signup/SolMainAction.do?method=update';
						theForm.submit();
					}else if(mode == "save"){
						theForm.action = '/sol/signup/SolMainAction.do?method=save';
						theForm.submit();
					}
				}
			}
		}else{
			//alert('尚有資料未輸入，請檢查！');
			alert('學歷不可空白！');
		}
	}
	// 如有檢核不通過的
	else{
		var centerCode = theForm.elements["signupInfo.centerCode"].value;
		var sttype = theForm.elements["signupInfo.sttype"].value;
		var name = theForm.elements["signupInfo.name"].value;
		var sex = theForm.elements["signupInfo.sex"].value;
		var dmstaddrZip = theForm.elements["signupInfo.dmstaddrZip"].value;
		var dmstaddr = theForm.elements["signupInfo.dmstaddr"].value;
		var crrsaddrZip = theForm.elements["signupInfo.crrsaddrZip"].value;
		var crrsaddr = theForm.elements["signupInfo.crrsaddr"].value;
		var edubkgrdGrade = theForm.elements["signupInfo.edubkgrdGrade"].value;
		var preMajorFaculty = theForm.elements["signupInfo.preMajorFaculty"].value;
		var tutorClassMk = theForm.elements["signupInfo.tutorClassMk"].value;
		var getinfo = "";
		
		var getInfoObj = theForm.elements["signupInfo.getinfo"];
		for(var i = 0; i < getInfoObj.length; i++ ) {
			if(getInfoObj[i].checked) {
				getinfo = "Y";
				break;
			}
		}
		
		var asys = theForm.elements["signupInfo.asys"].value;
		var messageContent = "";
		
		
		if(<%="Y".equals(isSolStud1) %>) {
			if(theForm.elements["signupInfo.specialSttypeType"].value == "")
				messageContent = messageContent+"請輸入專班類別！";
		}

		if(<%="oversea".equals(fromSite) %>) {
			if(theForm.elements["signupInfo.overseaReason"].value == "")
				messageContent = messageContent+"請輸入海外居留原因！";
			if(theForm.elements["signupInfo.overseaNation"].value == "")
				messageContent = messageContent+"請輸入海外居留國別！";
			if(theForm.elements["signupInfo.overseaDoc"].value == "")
				messageContent = messageContent+"請輸入海外居留證件！";
			if(theForm.elements["signupInfo.overseaDocDate"].value == "")
				messageContent = messageContent+"請輸入海外居留證件有效期！";
			if(theForm.elements["signupInfo.overseaAddr"].value == "")
				messageContent = messageContent+"請輸入海外居留地址！";
		}
		
		
		if(centerCode == "")
		{
			if(asys == "1")
				messageContent = messageContent+"\r\n請輸入報名學習指導中心！";
			else
				messageContent = messageContent+"\r\n請輸入報名學習指導中心！";
		}
		
		if(sttype == "")
			messageContent = messageContent+"\r\n請輸入報名身份別！";
		if(name == "")
			messageContent = messageContent+"\r\n請輸入必填資料！";
		if(sex == "")
			messageContent = messageContent+"\r\n請輸入性別！";
		if(dmstaddrZip == "" || dmstaddr == "")
			messageContent = messageContent+"\r\n請輸入戶籍地址(含郵遞區號)！";
		if(crrsaddrZip == "" || crrsaddr == "")
			messageContent = messageContent+"\r\n請輸入通訊地址(含郵遞區號)！";
		if(edubkgrdGrade == "")
			messageContent = messageContent+"\r\n請輸入最高學歷類別！";
		if(theForm.elements["signupInfo.mobile"].value == "")
			messageContent = messageContent+"\r\n請輸入手機號碼！如果沒有請輸入0000";
		if(theForm.elements["signupInfo.email"].value == "")
			messageContent = messageContent+"\r\n請輸入個人電子信箱！如果沒有請輸入0@0.0";
		if(tutorClassMk == "")
			messageContent = messageContent+"\r\n請輸入是否參加導師班！";
		if(getinfo == "")
			messageContent = messageContent+"\r\n請輸入獲得空大招生來源！";
		if(theForm.elements["signupInfo.vocation"].value == "")
			messageContent = messageContent+"\r\n請輸入職業！";
		if(preMajorFaculty == "")
			messageContent = messageContent+"\r\n請輸入預定主修學系！";
		if(theForm.elements["signupInfo.emrgncyName"].value == "")
			messageContent = messageContent+"\r\n請輸入緊急聯絡人！";
		if(theForm.elements["signupInfo.emrgncyTel"].value == "")
			messageContent = messageContent+"\r\n請輸入緊急聯絡人電話！";		
		if(theForm.elements["signupInfo.emrgncyRelation"].value == "")
			messageContent = messageContent+"\r\n請輸入緊急聯絡人關係！";
		if(theForm.elements["signupInfo.emrgncyEmail"].value == "")
			messageContent = messageContent+"\r\n請輸入緊急聯絡人信箱！";
		if(theForm.elements["signupInfo.docAgreeMk"].value == "")
			messageContent = messageContent+"\r\n尚未同意切結所填各項資料及報名繳交證明文件真實無誤！";
				
		if(theForm.elements["securityCode"].value == "")
			messageContent = messageContent+"\r\n請輸入系統產生的認證碼！※重要提醒：為使您可收到校務或教學相關訊息，請再次確認您的「個人電子信箱」是否正確無誤。";
	
		if(messageContent!='')
			alert(messageContent);
		//alert('尚有資料未輸入，請檢查！');
	}
}

function doCopy(){
	var theForm = document.forms["solMainForm"];
	
	if(theForm.elements["same"].checked == true){
		theForm.elements["signupInfo.crrsaddr"].value = theForm.elements["signupInfo.dmstaddr"].value;
		theForm.elements["signupInfo.crrsaddrZip"].value = theForm.elements["signupInfo.dmstaddrZip"].value;
	}
}

function doSttype(){
	var theForm = document.forms["solMainForm"];
	var value = theForm.elements["signupInfo.sttype"].value;
	var edubkgrd1 = theForm.elements["edubkgrd1"].value;
	var edubkgrd2 = theForm.elements["edubkgrd2"].value;
	//var edubkgrd3 = theForm.elements["edubkgrd3"].value;
	
	if(value == "2" || <%=type.equals("5")%> ){
		document.getElementById("validate_edubkgrd1").innerHTML = "";
		document.getElementById("validate_edubkgrd2").innerHTML = "";
		return true;
	}else{
		if(edubkgrd1 == "" || edubkgrd2 == ""){
			document.getElementById("validate_edubkgrd1").innerHTML = "<font color='red'>不可為空白</font>";
			document.getElementById("validate_edubkgrd2").innerHTML = "<font color='red'>不可為空白</font>";
			return false;
		}else{
			return true;
		}
	}
}

function goIndex(){
	window.close();
 	if(confirm("確定要放棄嗎？")){
 		var url = "/sol/signup/SolMainAction.do?method=index";
		
 		if(<%="oversea".equals(fromSite) %>) {
 			url = '/sol/signup/SolMainAction.do?method=indexOversea';
 		} else if(<%="special".equals(fromSite) %>) {
 			url = '/sol/signup/SolMainAction.do?method=indexSpecial';
 		} 
		
		
 		var theForm = document.forms["solMainForm"];
 		theForm.action = url;
 		theForm.submit();
 	}
}

function goIndex2(){
	
	var url = "/sol/signup/SolMainAction.do?method=index";
		
	if(<%="oversea".equals(fromSite) %>) {
		url = '/sol/signup/SolMainAction.do?method=indexOversea';
	} else if(<%="special".equals(fromSite) %>) {
		url = '/sol/signup/SolMainAction.do?method=indexSpecial';
	}
	
	var theForm = document.forms["solMainForm"];
	theForm.action = url;
	theForm.submit();
}

function doReset(){
	if(confirm("確定要清除嗎？")){
		var theForm = document.forms["solMainForm"];
		var sex = theForm.elements["signupInfo.sex"].value;
		var sttype = theForm.elements["signupInfo.sttype"].value;
		theForm.reset();
		theForm.elements["asys"].value = '<%= signupInfo.getAsys() == null ? "" : signupInfo.getAsys() %>';
		theForm.elements["sms"].value = '<%= signupInfo.getSms() == null ? "" : signupInfo.getSms() %>';
		theForm.elements["signupInfo.sex"].value =  sex;
		theForm.elements["signupInfo.sttype"].value = sttype;
	}
} 

function doPrint(){
	var theForm = document.forms["solMainForm"];
	theForm.elements["signupInfo.idno"].disabled = false;
	theForm.elements["signupInfo.birthdate"].disabled = false;
	theForm.elements["signupInfo.asys"].disabled = false;
	theForm.elements["signupInfo.sms"].disabled = false;
	theForm.elements["signupInfo.ayear"].disabled = false;
	theForm.action = '/sol/signup/SolMainAction.do?method=doPrintForUpdate';
	theForm.target = "_blank";
	theForm.submit();
	theForm.target = "";
	theForm.elements["signupInfo.idno"].disabled = true;
	theForm.elements["signupInfo.birthdate"].disabled = true;
	theForm.elements["signupInfo.asys"].disabled = true;
	theForm.elements["signupInfo.sms"].disabled = true;
	theForm.elements["signupInfo.ayear"].disabled = true;
}

function doLock(value){
	var theForm = document.forms["solMainForm"];
	if(value == ''){
		theForm.elements["signupInfo.handicapGrade"].value = "";
		theForm.elements["signupInfo.handicapGrade"].disabled = true;
	}else{
		theForm.elements["signupInfo.handicapGrade"].disabled = false;
	}
}

function doLock1(value){	
	//alert(value);
	var theForm = document.forms["solMainForm"];
	if( value == '' ){		
		theForm.elements["signupInfo.fatherName"].disabled = true;
		theForm.elements["signupInfo.fatherOriginalCountry"].disabled = true;
		theForm.elements["signupInfo.motherName"].disabled = true;
		theForm.elements["signupInfo.motherOriginalCountry"].disabled = true;
	}else{
		theForm.elements["signupInfo.fatherName"].disabled = false;
		theForm.elements["signupInfo.fatherOriginalCountry"].disabled = false;
		theForm.elements["signupInfo.motherName"].disabled = false;
		theForm.elements["signupInfo.motherOriginalCountry"].disabled = false;
	}
}

function doCheckOldStudent(){
	var kind = "<%= type %>";
	if(kind != "5"){
		return true;
	}else{
		var theForm = document.forms["solMainForm"];
		var value = theForm.elements["signupInfo.sttype"].value;
		if(value == "2"){
			alert("由於您是選修生修滿40學分，報名身份別不可為「選修生」！");
			return false;
		}else{
			return true;
		}
	}
}

function checkAge()
{
	var theForm = document.forms["solMainForm"];
	var enroll = "<%=enrollBasedate%>";
	var enroll_int = parseInt(enroll);
	var birthdate = theForm.elements["signupInfo.birthdate"].value;	
	var tmp=parseInt(birthdate);	
	
	//if(theForm.elements["signupInfo.sttype"].value == "1")
	//{
	// 20140516 Maggie 改成空大全修生不限制年齡(只要有高中畢業證書即可)，比照空專
	//	if(tmp+200000>enroll_int)
	//	{
	//		alert("報名全修生必須年滿20歲！！");
	//		theForm.elements["signupInfo.sttype"].value = "";
	//		return false;
	//
	//}
	//}else 
	if(theForm.elements["signupInfo.sttype"].value == "2"){
	
		if(tmp+180000>enroll_int)
		{
			alert("報名選修生必須年滿18歲！！");
			theForm.elements["signupInfo.sttype"].value = "";
			return false;
		}
		
		//by poto 
		if(<%="OLD".equals(checktype)%>){
			if(theForm.elements["signupInfo.asys"].value == "1"){
				alert("舊選修生，不可更改身份別！！");
				theForm.elements["signupInfo.sttype"].value = "1";	
				return false;
			}
		}
	}
	// 20100209 north 改成空專不限制年齡(只要有高中畢業證書即可)
//	else if(theForm.elements["signupInfo.sttype"].value == "3"){
//		if(tmp+160000>enroll_int)
//		{
//			alert("報名專科生必須年滿16歲！！");
//			theForm.elements["signupInfo.sttype"].value = "";
//			return false;
//		}
//	}
	
	return true;
} 

function doUpperCase(a){
	var theForm = document.forms["solMainForm"];
	var value = theForm.elements[a].value;
	theForm.elements[a].value = value.toUpperCase();
}

/** ===選擇〝肄業〞提示以高中或同等學歷報名 === */
function edubk2Check() {
	if("肄業" == (document.forms["solMainForm"].edubkgrd2.value)){
		alert("「二專、三專、二技、四技與大學肄業者，請務須填寫高中（職）畢業學校全銜或同等學力名稱」");
	}
	
}

</script>



<script>

/** 信用卡繳費同意確認 **/
 function goPayCheck() {
	 document.getElementById('light').style.display='block';
	 document.getElementById('fade').style.display='block';
}

function goPay() {
	//alert('同意了');
	document.getElementById('light').style.display='none';document.getElementById('fade').style.display='none';
	
	var theForm = document.forms["solMainForm"];
	theForm.elements["signupInfo.idno"].disabled = false;
	theForm.elements["signupInfo.birthdate"].disabled = false;
	theForm.elements["signupInfo.asys"].disabled = false;
	theForm.elements["signupInfo.sms"].disabled = false;
	theForm.elements["signupInfo.ayear"].disabled = false;
	theForm.action = '/sol/signup/SolMainAction.do?method=getPayInfo';
	theForm.target = "_blank";
	theForm.submit();
	theForm.target = "";
	theForm.elements["signupInfo.idno"].disabled = true;
	theForm.elements["signupInfo.birthdate"].disabled = true;
	theForm.elements["signupInfo.asys"].disabled = true;
	theForm.elements["signupInfo.sms"].disabled = true;
	theForm.elements["signupInfo.ayear"].disabled = true;
	
}

function setCheckValue(){
	if(document.getElementById("CHK").checked) {
		document.getElementById("b1").disabled = false;
	} else {
		document.getElementById("b1").disabled = true;
	}
}

function refreshImg() {
	var url = "/sol/signup/SolMainAction.do?method=showImage";
	var r = Math.random().toString();
	var ele = document.getElementById("checkImg");
	ele.src = url + "&r=" + r;
	
}

</script>


</head>

<body id="body" background="images/ap_index_bg.jpg" alt="背景圖" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onload="init();initForm(document.solMainForm);">
<!-- 定義編輯的 Form 起始 -->
<form name="solMainForm" action="/sol/signup/SolMainAction" method="post" onsubmit="doSave();" style="margin:5,0,0,0;">
	<input type="hidden" name="signupInfo.asys" value="<%= signupInfo.getAsys() %>" > 
	<input type="hidden" name="signupInfo.ayear" value="<%= signupInfo.getAyear() %>" > 
	<input type="hidden" name="signupInfo.sms" value="<%= signupInfo.getSms() %>" > 
	<input type="hidden" name="type" value="<%= type == null ? "" : type %>" > 
	<input type='hidden' name='signupInfo.marriage'>
	
<!-- 	開放銀行 -->
	<input type='hidden' name='E_BANK' value='F'>
	

<!-- 編輯全畫面起始 -->
<TABLE id="EDIT_DIV" width="96%" border="0" align="center" cellpadding="0" cellspacing="0" summary="排版用表格">
	<tr>
		<td width="13"><img src="images/ap_index_mtb_01.gif" alt="排版用圖示" width="13" height="14"></td>
		<td width="100%"><img src="images/ap_index_mtb_02.gif" alt="排版用圖示" width="100%" height="14"></td>
		<td width="13"><img src="images/ap_index_mtb_03.gif" alt="排版用圖示" width="13" height="14"></td>
	</tr>
	<tr>
		<td width="13" background="images/ap_index_mtb_04.gif" alt="排版用圖示">&nbsp;</td>
		<td width="100%" valign="top" bgcolor="#FFFFFF"><!-- 按鈕畫面起始 -->
		<table width="100%" border="0" align="center" cellpadding="2" cellspacing="0" summary="排版用表格">
			<tr class="mtbGreenBg">
 				<td align=left>【編輯畫面】- <%="update".equals(mode) == true ? "修改" : "新增"%>　<span id='sttypeMessage'></span></td>
				<td align=right>
				<div id="edit_btn">
				<%
				if ("update".equals(mode)) {
				%> 
					<%
						if ("Y".equals(showPayBtn)){
					%>
				<!--報名資料查詢移除繳費功能僅存在於繳費查詢  -->
				<!--
						<input type="button" name="print" class="btn" value='信用卡繳費' onclick="goPayCheck();">
						<input type="button" name="print" class="btn" value='列印繳費單' onclick="doPrint();">
				-->
					<% 
						}
					%>
				<input type="button" name="print" class="btn" value='回首頁' onclick="goIndex2();"><%
 }
 %> <input type="button" class="btn" value='關閉視窗' onclick="goIndex();"> <input type="button" class="btn" value='清  除' onclick="doReset();"> <input type=button name="SAVE_BTN" class="btn" value='存  檔' onclick="doSave();" onkeypress="doSave();"></div>
				</td>
			</tr>
		</table>
		<!-- 按鈕畫面結束 --> <!-- 編輯畫面起始 -->
		<table id="table2" width="100%" border="0" align="center" cellpadding="2" cellspacing="0" summary="排版用表格">
			<tr>
				<td align='right' class='tdgl1'>學年期：</td>
				<td class='tdGrayLight'><%=signupInfo.getAyear()%></td>
				<td align='right' class='tdgl1'>學期：</td>
				<td class='tdGrayLight'><select name='sms' disabled>
					<%=sms%>
				</select></td>
			</tr>
			<tr>
				<td align='right' class='tdgl2'>身分證字號：</td>
				<td class='tdGrayLight'><input type=text name='signupInfo.idno' disabled="true" value="<%= signupInfo.getIdno() == null ? "" : signupInfo.getIdno() %>"></td>
				<td class='tdgl2' align='right'>出生日期：</td>
				<td class='tdGrayLight'><input type=text name='signupInfo.birthdate' disabled="true" value="<%= signupInfo.getBirthdate() == null ? "" :signupInfo.getBirthdate() %>"></td>
			</tr>
			<tr id="asysTR">
				<td class='tdgl1' align='right'>學制：</td>
				<td class='tdGrayLight' id='CLASS_ASYS' colspan="1">
					<select name='asys' disabled>
						<%=asys%>
					</select>
				</td>
				
				<td class='tdgl1' align='right' id='CLASS_SPECIAL_STTYPE_MK'>專班類別<font color="red"><span id='validate_signupInfo.sttype'></span></font>：</td>
				<td class='tdGrayLight' colspan="1" id='specialSelectOption'>
					<select name='signupInfo.specialSttypeType' id='signupInfo.specialSttypeType' check="U1">
						<%=SpecialSttypeMk %>
					</select>
				</td>
			</tr>
		</table>
		<br />
		<center><font size="5">學生報名基本資料</font></center>
		<table id="table2" width="100%" border="0" align="center" cellpadding="2" cellspacing="0" summary="排版用表格">
			<tr>
				<td align='right' class='tdgl2'>報名<%="1".equals(signupInfo.getAsys()) == true ? "學習指導中心" : "學習指導中心"%><font color="#CC0033"><span id='validate_signupInfo.centerCode'></span></font>：</td>
				<td class='tdGrayLight'><select id="signupInfo.centerCode" name='signupInfo.centerCode' check="U1">
					<%=centerCode%>
				</select></td>
				<td align='right' class='tdgl2'>報名身分別<font color="red"><span id='validate_signupInfo.sttype'></span></font>：</td>
				<td class='tdGrayLight'><select id="signupInfo.sttype" name='signupInfo.sttype' check="U1" onchange="checkAge();" <%= "2".equals(signupInfo.getAsys()) == true ? "disabled" : "" %>>
					<%=sttype%>
				</select></td>
			</tr>
			<tr>
				<td align='right' class='tdgl1'>姓名<font color="red"><span id='validate_signupInfo.name'></span></font>：</td>
				<td class='tdGrayLight'><input type=text size='12' maxlength='12' name='signupInfo.name' value="<%= signupInfo.getName() == null ? "" : signupInfo.getName() %>" check="U1" <%= signupInfo.getName() == null ? "" : "disabled" %> ><%= signupInfo.getName() == null ? "" : "<br><font color='red'>備註：<br>如有更名，請於新生報到時攜帶戶籍謄本及身分證影本提出申請</font><input type='hidden' name='signupInfo.name' value='"+signupInfo.getName()+"'>"%></td>
				<td align='right' class='tdgl1'>法定性別<font color=red><span id='validate_signupInfo.sex'></span></font>：</td>
				<td class='tdGrayLight'>
					<select name='signupInfo.sex' check="U1" disabled> <%=sex%> </select>
					自我認同性別：<select name='signupInfo.selfIdentitySex'> <%=sex%> </select>
				</td>
			</tr>
			<tr>
				<td align='right' class='tdgl1' STYLE='display:none'>別名<font color="red"><span id='validate_signupInfo.alias'></span></font>：</td>
				<td class='tdGrayLight'  STYLE='display:none'><input type=text  size='12' maxlength='12' name='signupInfo.alias' check="U0" value="<%= signupInfo.getAlias() == null ? "" : signupInfo.getAlias() %>"></td>
				<td align='right' class='tdgl1'>英文姓名<font color=red><span id='validate_signupInfo.engName'></span></font>：</td> 
			 	<td class='tdGrayLight' colspan="3"><input type=text  size='30' maxlength='30' name='signupInfo.engName' check="U0" value="<%= signupInfo.getEngName() == null ? "" : signupInfo.getEngName() %>"  onkeyup="doUpperCase('signupInfo.engName');" >需與護照相同例：王小明 WANG, HSIAO-MING，<a href='https://goo.gl/4hH8Y' target="_blank" >外交部拼音參考</a></td> 
			</tr>
			<tr>
				<td align='right' class='tdgl2' rowspan="4"><font size="3">報名全修生<BR>入 學  學 歷<br>
				(選修生免填)
				</font></td>
				<td class='tdGrayLight' colspan="2"><font size="3">校名全銜：<span id='validate_edubkgrd1'></span> <input id="edubkgrd1" type="text" name="edubkgrd1" size="50" maxlength='50' value="<%= edubkgrd1 == null ? "" : edubkgrd1 %>"></td>
				<td class='tdGrayLight'><span id='validate_edubkgrd2'></span>
				<select name="edubkgrd2" onchange="edubk2Check()">
					<option value="">請選擇</option>
					<option value="畢業">畢業</option>
					<option value="結業">結業</option>
					<option value="肄業">肄業</option>
					<option value="其他">其他</option>
				</select>
				<font color='GREEN'>學歷畢業(修)年度</font><span id='validate_signupInfo.edubkgrdAyear'></span>
				<input size="3" type=text name='signupInfo.edubkgrdAyear' check="N0" maxlength="3" value="<%= signupInfo.getEdubkgrdAyear() == null ? "" : signupInfo.getEdubkgrdAyear() %>"><span id='validate_signupInfo.edubkgrdAyear'></span>
				</td>
			</tr>
			<tr STYLE='display:none'>
				<td class='tdGrayLight' colspan="2" align="center"><font size="3">(請填證書上之校名全銜)</font></td>
				<td class='tdGrayLight'><font size="3">(畢業、結業、肄業等)</font></td>
			</tr>
			<tr>
 				<td class='tdGrayLight' colspan="3">
 					<font size="3" color='red'>※入學學歷及入學學歷類別資料，涉及學生畢業、抵免及減免相關權益，既經學校審查證件後，不得申請變更，請妥慎勾選、填寫，並再確認後存檔送出；入學學歷欄位務請填寫證書上之校名全銜。</font>
				</td>
			</tr>
			
			<tr>
				<td class='tdGrayLight' colspan="3">
					<font size="3">填寫範例：
					<table width='100%' border="0" cellspacing="0" cellpadding="0" >
						<tr><td width='60%' colspan='2' align='left'>1.畢業生例：台灣省立大山高級中學</td></tr>
						<tr><td width='60%' colspan='2' align='left'>2.結業生例：台灣省立大山高級工業職業學校附設高級工業職業進修補習學校</td></tr>
						<tr><td width='60%' colspan='2' align='left'>3.肄業生例：台灣省立大山高級中學 修畢二下課程可升級</td></tr>
						<tr><td width='60%' colspan='2' align='left'>4.技術士證例：丙級技術士證五年以上、乙級技術士證二年以上</td></tr>
						<tr><td width='60%' align='left'>5.考試名稱及類科例：公務人員高等考試、二級考試人事行政科</td></tr>
						<tr><td width='60%' align='left'>6.大學肄業者，請持高中（職）畢業或同等學歷報名</td></tr>
					</table>
				</td>
			</tr>
			<tr>
				<td align='right' class='tdgl1'>入學學歷類別<font color=red><span id='validate_signupInfo.edubkgrdGrade'></span></font>：</td>
				<td class='tdGrayLight' colspan="3">
					<select name='signupInfo.edubkgrdGrade' check="U1">
						<%=edubkgrdGrade%>
					</select>
				</td>
			</tr>
			<tr>
				<td align='right' class='tdgl2'>戶籍地址：</td>
				<td class='tdGrayLight' colspan="3"><font color=red><span id='validate_signupInfo.dmstaddrZip'></span></font> <input type=text id="signupInfo.dmstaddrZip" name='signupInfo.dmstaddrZip' size="5" maxlength="5" check="N1" value="<%= signupInfo.getDmstaddrZip() == null ? "" : signupInfo.getDmstaddrZip() %>"> <A href="http://www.post.gov.tw/post/internet/f_searchzone/index.jsp?ID=190102" target=_blank>(郵遞區號)</A>			 
				<font color=red><span id='validate_signupInfo.dmstaddr'></span></font> <input type=text id="signupInfo.dmstaddr" name='signupInfo.dmstaddr'  size='50' maxlength='50' check="U1"
					value="<%= signupInfo.getDmstaddr() == null ? "" : signupInfo.getDmstaddr() %>"> <input type="checkbox" name="same" onkeypress="doCopy();" onclick="doCopy();">如通訊地址與戶籍地址相同，請打勾</td>
			</tr>
			<tr>
				<td align='right' class='tdgl1'>通訊地址：</td>
				<td class='tdGrayLight' colspan="3"><font color=red><span id='validate_signupInfo.crrsaddrZip'></span></font> <input type=text id="signupInfo.crrsaddrZip" name='signupInfo.crrsaddrZip' size="5" maxlength="5" check="N1" value="<%= signupInfo.getCrrsaddrZip() == null ? "" : signupInfo.getCrrsaddrZip() %>"> <A href="http://www.post.gov.tw/post/internet/f_searchzone/index.jsp?ID=190102" target=_blank>(郵遞區號)</A> <font color=red><span id='validate_signupInfo.crrsaddr'></span></font> <input type=text id="signupInfo.crrsaddr" name='signupInfo.crrsaddr'  size='50' maxlength='50' check="U1"
					value="<%= signupInfo.getCrrsaddr() == null ? "" : signupInfo.getCrrsaddr() %>"></td>
			</tr>
			<tr>
				<td align='right' class='tdgl2'>聯絡電話(公)<span id='validate_signupInfo.areacodeOffice'></span>：</td>
				<td class='tdGrayLight'>(<input size="3" type=text name='signupInfo.areacodeOffice' check="N0" maxlength="3" value="<%= signupInfo.getAreacodeOffice() == null ? "" : signupInfo.getAreacodeOffice() %>">) <span id='validate_signupInfo.telOffice'></span><input  size='8' maxlength='8' type=text name='signupInfo.telOffice' check="N0" value="<%= signupInfo.getTelOffice() == null ? "" : signupInfo.getTelOffice() %>"><br>分機<span id='validate_signupInfo.telOfficeExt'></span>：<input size="6"
					type=text name='signupInfo.telOfficeExt' check="N0" maxlength="6" value="<%= signupInfo.getTelOfficeExt() == null ? "" : signupInfo.getTelOfficeExt() %>"></td>
				<td align='right' class='tdgl2'>聯絡電話(宅)<span id='validate_signupInfo.areacodeHome'></span>：</td>
				<td class='tdGrayLight'>(<input size="3" type=text name='signupInfo.areacodeHome' check="N0" maxlength="3" value="<%= signupInfo.getAreacodeHome() == null ? "" : signupInfo.getAreacodeHome() %>">)<span id='validate_signupInfo.telHome'></span><input  size='8' maxlength='8' type=text name='signupInfo.telHome' check="N0" value="<%= signupInfo.getTelHome() == null ? "" : signupInfo.getTelHome() %>"></td>
			</tr>
			<tr>
				<td align='right' class='tdgl1'>行動電話<span id='validate_signupInfo.mobile'></span>：</td>
				<td class='tdGrayLight'><input type=text name='signupInfo.mobile'  size='15' check="N1" maxlength='15' value="<%= signupInfo.getMobile() == null ? "" : signupInfo.getMobile() %>"><br>如果沒有個人手機，請填寫「0000」</td>
				<td align='right' class='tdgl1' check="U0">個人電子信箱<span id='validate_signupInfo.email'></span>：</td>
				<td class='tdGrayLight'><input type=text  size='50' maxlength='60' name='signupInfo.email' check="E1" value="<%= signupInfo.getEmail() == null ? "" : signupInfo.getEmail() %>"><br>如果沒有個人電子信箱，請填寫「0@0.0」</td>
			</tr>
			
			<tr>
				<td class='tdGrayLight' colspan="3"></td>
			</tr>
			<tr>
				<td class='tdGrayLight' colspan="3"></td>
			</tr>
			<tr>
				<td align='right' class='tdgl1' colspan='1'>職業<span id='validate_signupInfo.vocation'></span>：</td>
				<td class='tdGrayLight' colspan="3">
					<select name='signupInfo.vocation' check="U1">
						<%=vocation%>
					</select>
					服務機關(單位)全銜：<span id='validate_signupInfo.vocationDept'></span><input id="signupInfo.vocationDept" type="text" name="signupInfo.vocationDept" size="40" maxlength='40' value="<%= vocationDept == null ? "" : vocationDept %>">
				</td>
			</tr>
			<tr>
				<td align='right' class='tdgl2'>
					<DIV ID="DIV2">
					<%
							if ("1".equals(signupInfo.getAsys())) {
							out.println("預定主修學系");
						} else if ("2".equals(signupInfo.getAsys())) {
							out.println("主修科別");
						}
					%> <font color=red><span id='validate_signupInfo.preMajorFaculty'></span></font>：
					</DIV2>
				</td>
				<td class='tdGrayLight'><select name='signupInfo.preMajorFaculty' check="U1">
					<%=preMajorFaculty%>
					<%if ("1".equals(signupInfo.getAsys())) {%>
						<option value='0000'>尚未決定</option>
					<%}%>
				</select></td>
				<td align='right' class='tdgl2'>導師班：</td>
				<td class='tdGrayLight'>
					<select name='signupInfo.tutorClassMk' check="U1">
						<%=tutorClassMk%>
					</select>
				</td>
			<tr>
				<td align='right' class='tdgl1'>獲得空大招生來源<font color=red>(可複選)</font><font color=red><span id='validate_signupInfo.getinfo'></span></font>：</td>
				<td class='tdGrayLight' colspan='3'>
					<%=getinfo%>　
				</td>
			</tr>
			<tr>
				<td align='right' class='tdgl2'>持有身心障礙手冊者，<br>請填類別：</td>
				<td class='tdGrayLight' colspan=''><select name='signupInfo.handicapType' onchange='doLock(this.value);'>
					<%=handicapType%>
				</select></td>
							
				<td align='right' class='tdgl1'>持有身心障礙手冊者，<br>請填級別：</td>
				<td colspan='' class='tdGrayLight'><select name='signupInfo.handicapGrade'>
					<%=handicapGrade%>
				</select></td>
			</tr>
			 
			<tr>				
				<td align='right' class='tdgl1'>具有原住民身分者，請填族別：</td>
				<td class='tdGrayLight'><select name='signupInfo.originRace'>
					<%=originRace%>
				</select>族</td>
				<td align='right' class='tdgl2'>具有新住民身分者，請填原國別：</td>
				<td colspan='1' class='tdGrayLight'>
					<!--
					<input type="text" name="signupInfo.newnation" size="10" maxlength="10" value="<%= signupInfo.getNewnation() == null ? "" : signupInfo.getNewnation() %>" />  
					-->
					<select name='signupInfo.newnation'>
					<%=nation%>
					</select>
				</td>
			</tr>
			<tr>
				<td align='right' class='tdgl2'>新住民子女</td>
				<td class='tdGrayLight' colspan='3'>
				<select name='signupInfo.newResidentChd' onchange=doLock1(this.value);>
				<!-- 
					<select name='signupInfo.newResidentChd' >
				-->
						<option value=""   >否</option>
						<option value="2"  >是</option>
					</select>
					父親姓名<input type=text size='20' maxlength='20' name='signupInfo.fatherName' check="U0" value="<%= signupInfo.getFatherName() == null ? "" : signupInfo.getFatherName() %>">
					父親原國別<select name='signupInfo.fatherOriginalCountry'><%=nation%></select>
					母親姓名<input type=text size='20' maxlength='20' name='signupInfo.motherName' check="U0" value="<%= signupInfo.getMotherName() == null ? "" : signupInfo.getMotherName() %>">
					母親原國別<select name='signupInfo.motherOriginalCountry'><%=nation%></select>
				</td>
			</tr>			 
			<tr>
				<td align='right' class='tdgl1'>緊急聯絡人<font color=red><span id='validate_signupInfo.emrgncyName'></span></font>：</td>
				<td class='tdGrayLight'><input type=text name='signupInfo.emrgncyName' check="U1"  size='20' maxlength='20' value="<%= signupInfo.getEmrgncyName() == null ? "" : signupInfo.getEmrgncyName() %>"></td>
				<td align='right' class='tdgl2'>緊急聯絡人關係<font color=red><span id='validate_signupInfo.emrgncyRelation'></span></font>：</td>
				<td class='tdGrayLight'><input type="text" name='signupInfo.emrgncyRelation' check="U1" size='2' maxlength='2' value="<%= signupInfo.getEmrgncyRelation() == null ? "" : signupInfo.getEmrgncyRelation() %>"></td>
			</tr>
			<tr>
				<td align='right' class='tdgl2'>緊急聯絡人電話<font color=red><span id='validate_signupInfo.emrgncyTel'></span></font>：</td>
				<td class='tdGrayLight' colspan='1'><input type=text size='17' maxlength='17' name='signupInfo.emrgncyTel' check="N1" value="<%= signupInfo.getEmrgncyTel() == null ? "" : signupInfo.getEmrgncyTel() %>"></td>
				<td align='right' class='tdgl2'>緊急聯絡人電子信箱<font color=red><span id='validate_signupInfo.emrgncyEmail'></span></font>：</td>
				<td class='tdGrayLight'><input type=text  size='50' maxlength='60' name='signupInfo.emrgncyEmail' check="E1" value="<%= signupInfo.getEmrgncyEmail() == null ? "" : signupInfo.getEmrgncyEmail() %>"></td>
			</tr>
			<tr id='overSeaTr1'>
				<td align='right' class='tdgl2' rowspan="2"><font size="3">海外居留生資料
				</font></td>
				<td class='tdGrayLight' colspan="3"><font size="3">海外地址：<span id='validate_signupInfo.overseaAddr'></span> <input id="signupInfo.overseaAddr" type="text" name="signupInfo.overseaAddr" size="80"  check="U1" maxlength='80' value="<%= signupInfo.getOverseaAddr() == null ? "" : signupInfo.getOverseaAddr() %>"></td>
			</tr>
			<tr id='overSeaTr2'>
				<td class='tdGrayLight' colspan="3">
					<table width='100%' border="0" cellspacing="0" cellpadding="0" >
						<tr>
							<td width='60%' colspan='2' align='left'>海外居留原因<font color=red><span id='validate_signupInfo.overseaReason'></span></font>：
								<select name='signupInfo.overseaReason' id="signupInfo.overseaReason" check="U1">
								<%=overseaReason%>
								</select>
								其他原因：<span id='validate_signupInfo.overseaReasonRmk'></span> <input id="signupInfo.overseaReasonRmk" type="text" name="signupInfo.overseaReasonRmk" size="20" maxlength='20' value="<%= signupInfo.getOverseaReasonRmk() == null ? "" : signupInfo.getOverseaReasonRmk() %>">
							</td>
						</tr>
						<tr>
							<td width='60%' colspan='2' align='left'>海外居留國別<font color=red><span id='validate_signupInfo.overseaNation'></span></font>：
								<select name='signupInfo.overseaNation' id='signupInfo.overseaNation' check="U1">
								<%=overseaNation%>
								</select>
								地點(省市)或其他國別：<span id='validate_signupInfo.overseaNationRmk'></span> <input id="signupInfo.overseaNationRmk" type="text" name="signupInfo.overseaNationRmk" size="20" maxlength='20' value="<%= signupInfo.getOverseaNationRmk() == null ? "" : signupInfo.getOverseaNationRmk() %>">
							</td>
						</tr>
						<tr>
							<td width='60%' colspan='2' align='left'>海外居留證件<font color=red><span id='validate_signupInfo.overseaDoc'></span></font>：
								<select name='signupInfo.overseaDoc' id='signupInfo.overseaDoc' check="U1">
								<%=overseaDoc%> 
								</select>
								其他證件：<span id='validate_signupInfo.overseaDocRmk'></span> <input id="signupInfo.overseaDocRmk" type="text" name="signupInfo.overseaDocRmk" size="20" maxlength='20' value="<%= signupInfo.getOverseaDocRmk() == null ? "" : signupInfo.getOverseaDocRmk() %>">
								效期至：<span id='validate_signupInfo.overseaDocDate'></span> <input id="signupInfo.overseaDocDate" type="text" name="signupInfo.overseaDocDate" size="8"  check="U1" maxlength='8' value="<%= signupInfo.getOverseaDocDate() == null ? "" : signupInfo.getOverseaDocDate() %>">(請輸入西元年8碼)
							</td>
						</tr>
					</table>
				</td>
			</tr>			
			<tr>
				<td align='right' class='tdgl2'>推薦人姓名<font color=red></font>：</td>
				<td class='tdGrayLight'><input type=text size='20' maxlength='20' name='signupInfo.recommendName' check="U0" value="<%= signupInfo.getRecommendName() == null ? "" : signupInfo.getRecommendName() %>"></td>
				<td align='right' class='tdgl2'>推薦人學號或身分證字號<font color=red></font>：</td>
				<td class='tdGrayLight'><input type="text" name='signupInfo.recommendId' check="U0" size='10' maxlength='10' value="<%= signupInfo.getRecommendId() == null ? "" : signupInfo.getRecommendId() %>"></td>
			</tr>
			<tr>
				<td align='right' class='tdgl2'>同意切結<font color=red>※</font>：</td>
				<td class='tdGrayLight' colspan='3'>
					<select name='signupInfo.docAgreeMk' check="U1">
						<option value="">請選擇</option>
						<option value="Y">我同意</option>
					</select>
					<font color=purple><b>本人保證以上所填各項資料及報名入學繳交之身分、學歷與相關證明文件，均與真實正本相符，確認無誤，如有虛假不實、冒用、假借、偽造、變造情事，除願負一切法律責任外，並同意依國立空中大學學生學則第8條及相關規定辦理，絕無異議。</b></font>
				</td>
			</tr>
			<tr>
				<td align='right' class='tdgl1'>系統產生的認證碼：<br />輸入上面的認證碼<font color=red><span id='validate_securityCode'></span></font>：</td>
				<td class='tdGrayLight' colspan="6"><img id='checkImg' border=0 src="/sol/signup/SolMainAction.do?method=showImage"><font color=red>請輸入圖上數字方可存檔</font><br />
				<input type=text size='4' maxlength='4' name='securityCode' check="U1"><font color="red"><%= security == null ? "" : security %></font>
				<a href="#" onclick="refreshImg();">刷新圖片</a> <font color='red'><b>※重要提醒：為使您可收到校務或教學相關訊息，請再次確認您的「個人電子信箱」是否正確無誤。</b></font>
				</td>
				
			</tr>
		</table>
		<!-- 編輯畫面結束 --></td>
		<td width="13" background="images/ap_index_mtb_06.gif" alt="排版用圖示">&nbsp;</td>
	</tr>
	<tr>
		<td width="13"><img src="images/ap_index_mtb_07.gif" alt="排版用圖示" width="13" height="15"></td>
		<td width="100%"><img src="images/ap_index_mtb_08.gif" alt="排版用圖示" width="100%" height="15"></td>
		<td width="13"><img src="images/ap_index_mtb_09.gif" alt="排版用圖示" width="13" height="15"></td>
	</tr>
</table>
<!-- 編輯全畫面結束 --></form>
<!-- 定義編輯的 Form 結束 -->

<!-- 讀取中div -->
<div class="modal"><div align="center" style="height:50%;"></div><div align="center">讀取中請稍後</div>
<!-- 	<div><img src="images/load.gif" /></div> -->
</div>

<div id="light" class="white_content">
	<table border="0" align="center" cellpadding="0" cellspacing="1">
            <tr>
                <td align="left" >
					致信用卡繳費同學：<br><br>
					係依據本服務條款提供本站各項服務。當您開始使用本服務時，即表示您已閱讀、了解並同意接受本服務條款之所有內容。如果您不同意本服務條款的內容，或者您所屬的國家或地域排除本服務條款內容之全部或部分時，您應立即停止使用本服務。此外，當您使用本服務之特定功能時，可能會依據該特定功能之性質，而須遵守本服務所另行公告之服務條款或相關規定。此另行公告之服務條款或相關規定亦均併入屬於本服務條款之一部分。本會有權於任何時間修改或變更本服務條款之內容，並公告於本服務網站上，請您隨時注意該等修改或變更。若您於任何修改或變更後繼續使用本服務，則視為您已閱讀、了解並同意接受該等修改或變更！<br><br>
					若您為未滿二十歲之未成年人，則應請您的父母或監護人閱讀、了解並同意本服務條款之所有內容及其後之修改變更，方得使用本服務。當您使用本服務時，即推定您的父母或監護人已閱讀、了解並同意接受本服務條款之所有內容及其後之修改變更。<br><br>
					
					<input type='checkbox' value='1' name='CHK' id='CHK' onclick='setCheckValue();'><label for='CHK'>我已經詳細閱讀並同意</label> <a href="http://www.gov.tw/utos.htm"  target = "_blank" STYLE="text-decoration:none" >服務條款</a> 和  <a href="http://www.gov.tw/privacy.htm"  target = "_blank" STYLE="text-decoration:none" >隱私權保護政策</a>

				</td>
            </tr>
            <tr> 
                <td align="center"><br><br>
                    <input type=button class="btn" value='繳　　費' name = "b1" id="b1" onkeypress="goPay();"onclick="goPay();" disabled >
                    　　&nbsp;&nbsp;&nbsp;
                    <input type=button class="btn" value='取消繳費' name = "b2"  onkeypress="document.getElementById('light').style.display='none';document.getElementById('fade').style.display='none'" onclick = "document.getElementById('light').style.display='none';document.getElementById('fade').style.display='none'">
                 </td>
            </tr>
            <tr> 
                <td align="center"><br><br>
                    <h2><font color="red">請勿關閉教務系統網頁，以免造成無法取得繳費訊息</font></h2>
                 </td>
            </tr>
        </table>

</div> 

<div id="fade" class="black_overlay">
</div> 



</body>
</html>
