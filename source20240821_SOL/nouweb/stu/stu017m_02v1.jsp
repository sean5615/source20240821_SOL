<%/*
----------------------------------------------------------------------------------
File Name		: stu002m_02v1
Author			: matt
Description		: 維護學籍資料 - 編輯顯示頁面
Modification Log	:

Vers		Date       	By            	Notes
--------------	--------------	--------------	----------------------------------
0.0.1		096/01/24	matt    		Code Generate Create
0.0.2		096/11/06	poto    	    架構修改 for QA
0.0.3		097/03/19	lin	    	    若權限為校本部行政人員才開放學籍資料的存檔按鈕
----------------------------------------------------------------------------------
*/%>
<%@ page contentType="text/html; charset=UTF-8" errorPage="/utility/errorpage.jsp" pageEncoding="MS950"%>
<%@ include file="/utility/header.jsp"%>
<%@ page import="java.util.*"%>

<jsp:useBean id="AUTGETRANGE" scope="session" class="com.nou.aut.AUTGETRANGE" />

<%
String  DEP_CODE =com.acer.util.Utility.checkNull(request.getParameter("DEP_CODE"), "");
String ASYS = (String)session.getAttribute("ASYS");
if("1".equals(ASYS)){
	session.setAttribute("FACULTY_CODE", "UNT#SELECT FACULTY_CODE AS SELECT_VALUE, FACULTY_NAME AS SELECT_TEXT FROM SYST003 WHERE FACULTY_CODE != '90' AND FACULTY_CODE != '70' ORDER BY FACULTY_CODE");
}else{
	session.setAttribute("FACULTY_CODE", "UNT#SELECT FACULTY_CODE AS SELECT_VALUE, FACULTY_NAME AS SELECT_TEXT FROM SYST003 ORDER BY FACULTY_CODE ");
}
%>
<html>
<head>
	<%@ include file="/utility/viewpageinit.jsp"%>
	<script src="<%=vr%>script/framework/query1_2_0_2.jsp"></script>
	<script src="stu017m_02c1.jsp"></script>
	<noscript>
		<p>您的瀏覽器不支援JavaScript語法，但是並不影響您獲取本網站的內容</p>
	</noscript>
</head>
<body background="<%=vr%>images/ap_index_bg.jpg" alt="背景圖" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">

<!-- 標題畫面起始 -->
<table width="96%" border="0" align="center" cellpadding="4" cellspacing="0" summary="排版用表格">
	<tr>
		<td>
			<table width="500" height="27" border="0" cellpadding="0" cellspacing="0">
				<tr>
					<td background="<%=vr%>images/ap_index_title.jpg" alt="排版用圖示">
						　　<span class="title">STU017M_查詢學籍資料</span>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
<span id='TabBtn1'class='tab_non_select' onclick="doTab(3, 1);">基本資料</span>
<span id='TabBtn2'class='tab_select' onclick="doTab(3, 2);">學籍資料</span>
<span id='TabBtn3'class='tab_non_select' onclick="doTab(3, 3);">學習歷程資料</span>
<!-- 標題畫面結束 -->
<!-- 定義編輯的 Form 起始 -->
<div style='padding:5px;border:1px solid #aaa;'>
	<div id='TabCnt1' style='display:none'>
		<form name="EDIT" method="post" onsubmit="doSave();" style="margin:5,0,0,0;">
			<input type=hidden name="control_type">
			<input type=hidden name="ROWSTAMP">
			<input type=hidden name="STNO">
			<input type=hidden name="ASYS">
			<input type=hidden name="DEP_CODE">	
			<input type=hidden name="SGU_CODE">	
			<input type=hidden name="PRE_MAJOR_FACULTY">
			<input type=hidden name="STOP_PRVLG_SAYEARSMS">
			<input type=hidden name="STOP_PRVLG_EAYEARSMS">	
			<input type=hidden name="SPECIAL_STTYPE_TYPE">	
			<input type=hidden name="SPECIAL_AYEAR">	
			<input type=hidden name="SPECIAL_SMS">	
			<input type=hidden name="TMPV">	
			<input type=hidden name="EDUBKGRD">
			<input type=hidden name="stno"  value="<%=com.acer.util.Utility.checkNull(request.getParameter("stno"), "")%>">		
			<input type=hidden name="backTo"  value="<%=com.acer.util.Utility.checkNull(request.getParameter("backTo"), "")%>">		
			<input type=hidden name="LINK"  value="<%=com.acer.util.Utility.checkNull(request.getParameter("LINK"), "")%>">		

			<!-- 編輯全畫面起始 -->
			<TABLE id="EDIT_DIV" width="96%" border="0" align="center" cellpadding="0" cellspacing="0" summary="排版用表格">
				<tr>
					<td width="13"><img src="<%=vr%>images/ap_index_mtb_01.gif" alt="排版用圖示" width="13" height="14"></td>
					<td width="100%"><img src="<%=vr%>images/ap_index_mtb_02.gif" alt="排版用圖示" width="100%" height="14"></td>
					<td width="13"><img src="<%=vr%>images/ap_index_mtb_03.gif" alt="排版用圖示" width="13" height="14"></td>
				</tr>
				<tr>
					<td width="13" background="<%=vr%>images/ap_index_mtb_04.gif" alt="排版用圖示">&nbsp;</td>
					<td width="100%" valign="top" bgcolor="#FFFFFF">
						<!-- 按鈕畫面起始 -->
						<table width="100%" border="0" align="center" cellpadding="2" cellspacing="0" summary="排版用表格">
							<tr class="mtbGreenBg">
								<td align=left>【編輯畫面】- <span id='EditStatus'>新增</span></td>
								<td align=right>
									<div id="edit_btn">
									<% if(request.getParameter("OPEN_WIN_BY_SGU008M") == null){ %>
										<input type=button class="btn" id="a1" value='回查詢頁' onkeypress='doBack();'onclick='doBack();'>
									<% }else if(request.getParameter("OPEN_WIN_BY_SGU008M").equals("YES")){ %>
										<input type=button class="btn" id="a1" value='關閉視窗' onkeypress='doClose1()' onclick='doClose1()'>
									<% } %>
										<!--
										<input type=button name="CLEAR_BTN" class="btn" value='清  除' onkeypress='doClear();'onclick='doClear();'>
										<input type=submit name="SAVE_BTN" class="btn" value='存  檔'>
										-->
									</div>
								</td>
							</tr>
						</table>
						<!-- 按鈕畫面結束 -->

						<!-- 編輯畫面起始 -->
						<table id="table2" width="100%" border="0" align="center" cellpadding="2" cellspacing="0" summary="排版用表格">
							<tr>
								<td align='right' class='tdgl1'>身分證字號<font color=red>＊</font>：</td>
								<td class='tdGrayLight'><input type=text name='IDNO'></td>
								<td align='right' class='tdgl1'>出生日期<font color=red>＊</font>：</td>
								<td class='tdGrayLight'><input type=text name='BIRTHDATE'></td>
							</tr>
							<tr>
								<td align='right' class='tdgl2'>姓名<font color=red>＊</font>：</td>
								<td class='tdGrayLight'><input type=text name='NAME'>
								別名：<input type=text name='ALIAS'>
								</td>
								<td align='right' class='tdgl2'>英文姓名：</td>
								<td class='tdGrayLight'><input type=text name='ENG_NAME'></td>
							</tr>
							 <tr>						
								<td align='right' class='tdgl1'>國籍<font color=red>＊</font>：</td>
								<td class='tdGrayLight' >
									<select name='NATIONCODE'>
										<option value=''>請選擇</option>
										<script>Form.getSelectFromPhrase("SYST001_01_SELECT","KIND","NATIONCODE");</script>
									</select>
									<input type=text name='BIRTHPLACE' style='width:0px' readonly>
									<input type='text' name='BIRTHPLACE' style='width:0px' readonly>
									</td>
								<td align='right' class='tdgl1' nowrap>新住民原國別：</td>
								<td  class='tdGrayLight'>
								<select name='NEWNATION'>
										<option value=''>請選擇</option>
										<script>Form.getSelectFromPhrase("SYST001_01_SELECT","KIND","NATIONCODE");</script>
								</select>
								</td>
							</tr>
							<tr>
								<td align='right' class='tdgl1' nowrap>護照號碼：</td>
								<td class='tdGrayLight'><input type=text name='PASSPORT_NO'>
									護照或居留證有效日期：<span id="span1" >
												   <input type=text Column='RESIDENCE_DATE' name='RESIDENCE_DATE'>
												   </span>
												   <img src='/images/calendar.gif' id='img1' alt='日曆圖示 'style='cursor:hand' onkeypress='Calendar.showCalendar(this, _i("EDIT", "RESIDENCE_DATE"));'onclick='Calendar.showCalendar(this, _i("EDIT", "RESIDENCE_DATE"));'>
								</td>
								<td align='right' class='tdgl1'>法定性別<font color=red>＊</font>：</td>
								<td class='tdGrayLight'>
									<select name='SEX'>
										<option value=''>請選擇</option>
										<script>Form.getSelectFromPhrase("SYST001_01_SELECT","KIND","SEX");</script>
									</select>
									自我認同性別：
									<select name='SELF_IDENTITY_SEX'>
										<option value=''>請選擇</option>
										<script>Form.getSelectFromPhrase("SYST001_01_SELECT","KIND","SEX");</script>
									</select>
								</td>
							</tr>
							<tr>
								<td align='right' class='tdgl2'>婚姻狀況：</td>
								<td class='tdGrayLight'>
									<select name='MARRIAGE'>
										<option value=''>請選擇</option>
										<script>Form.getSelectFromPhrase("SYST001_01_SELECT","KIND","MARRIAGE");</script>
									</select>
								</td>
								<td align='right' class='tdgl2'>職業<font color=red>＊</font>：</td>
								<td class='tdGrayLight'>
									<select name='VOCATION'>
										<option value=''>請選擇</option>
										<script>Form.getSelectFromPhrase("SYST001_01_SELECT","KIND","VOCATION");</script>
									</select>
								</td>
							</tr>
							<tr>
								<td align='right' class='tdgl1' style='display:none'>學歷等級<font color=red>＊</font>：</td>
								<td class='tdGrayLight' style='display:none'>
									<select name='EDUBKGRD_GRADE'>
										<option value=''>請選擇</option>
										<script>Form.getSelectFromPhrase("SYST001_01_SELECT","KIND","EDUBKGRD_GRADE");</script>
									</select>
								</td>
<!-- 								<td align='right' class='tdgl1'>電子信箱：</td> -->
<!-- 								<td class='tdGrayLight'><input type=text name='EMAIL'></td> -->
							</tr>
							<tr>
								<td align='right' class='tdgl2'>戶籍地址：</td>
								<td class='tdGrayLight'>
									郵遞區號(<input type=text Column='ZIP' name='DMSTADDR_ZIP' onblur='Form.blurData("SYST006_01_BLUR", "ZIP", this.value , ["ZIP_CITY","ZIP_TOWN"],[_i("EDIT", "DMSTADDR_ZIP_CITY"),_i("EDIT", "DMSTADDR_ZIP_TOWN")], true);'>)
									<img src='/images/select.gif' id='ADDR1' alt='開窗選取' style='cursor:hand' onclick='Form.openPhraseWindow("SYST006_01_WINDOW", "","", "郵遞區號,縣市,鄉鎮區", [_i("EDIT", "DMSTADDR_ZIP"),_i("EDIT", "DMSTADDR_ZIP_CITY"),_i("EDIT", "DMSTADDR_ZIP_TOWN")]);'>
									<input type=text name='DMSTADDR'>
									<input type=hidden Column='ZIP_CITY' name='DMSTADDR_ZIP_CITY'>
									<input type=hidden Column='ZIP_TOWN' name='DMSTADDR_ZIP_TOWN' onpropertychange=setADDR("1")>
								</td>
								<td align='right' class='tdgl1'>電子信箱：</td>
								<td class='tdGrayLight'><input type=text name='EMAIL'></td>
							</tr>
							<tr>
								<td align='right' class='tdgl1'>通訊地址<font color='red'>＊</font>：</td>
								<td class='tdGrayLight' colspan="3">
									郵遞區號(<input type=text Column='ZIP' name='CRRSADDR_ZIP' onblur='Form.blurData("SYST006_01_BLUR", "ZIP", this.value , ["ZIP_CITY","ZIP_TOWN"],[_i("EDIT", "CRRSADDR_ZIP_CITY"),_i("EDIT", "CRRSADDR_ZIP_TOWN")], true);'>)
									<img src='/images/select.gif' id='ADDR2' alt='開窗選取' style='cursor:hand' onclick='Form.openPhraseWindow("SYST006_01_WINDOW", "","", "郵遞區號,縣市,鄉鎮區", [_i("EDIT", "CRRSADDR_ZIP"),_i("EDIT", "CRRSADDR_ZIP_CITY"),_i("EDIT", "CRRSADDR_ZIP_TOWN")]);'>
									<input type=text name='CRRSADDR'>
									<input type=hidden Column='ZIP_CITY' name='CRRSADDR_ZIP_CITY'>
									<input type=hidden Column='ZIP_TOWN' name='CRRSADDR_ZIP_TOWN' onpropertychange=setADDR("2")>
								</td>
							</tr>
							<tr>
								<td align='right' class='tdgl2'>電話(公)：</td>
								<td class='tdGrayLight'>(<input type=text name='AREACODE_OFFICE'>)<input type=text name='TEL_OFFICE'>分機<input type=text name='TEL_OFFICE_EXT'> ex:(02)12345678</td>
								<td align='right' class='tdgl2'>電話(宅)：</td>
								<td class='tdGrayLight'>(<input type=text name='AREACODE_HOME'>)<input type=text name='TEL_HOME'> ex:(02)12345678</td>
							</tr>
							<tr>
								<td align='right' class='tdgl1'>行動電話：</td>
								<td class='tdGrayLight'><input type=text name='MOBILE'>ex:0932123456</td>
								<td align='right' class='tdgl1' nowrap>傳真電話：</td>
								<td  class='tdGrayLight'><input type=text name='FAX_TEL'></td>
							</tr>
							<tr>
								<td align='right' class='tdgl1'>緊急聯絡人：</td>
								<td class='tdGrayLight'><input type=text name='EMRGNCY_NAME'>
								緊急聯絡人電話：<input type=text name='EMRGNCY_TEL'>
								</td>
								<td align='right' class='tdgl2' nowrap>緊急聯絡人關係：</td>
								<td colspan='5' class='tdGrayLight'><input type=text name='EMRGNCY_RELATION'></td>
							</tr>
							<tr>							
								
							    
							</tr>
							<tr>							
								<td align='right' class='tdgl1' nowrap>原住民：</td>
								<td class='tdGrayLight'><input type=text name='PARENTS_RACE' readonly></td>
							    <td align='right' class='tdgl1' nowrap>身心障礙類別：</td>
								<td  class='tdGrayLight'><input type=text name='HANDICAP_TYPE' readonly></td>
							</tr>
						    <tr>							
								<td align='right' class='tdgl1'>新住民子女：</td>
		                        <td class='tdGrayLight' colspan ='3'><input type=text name='NEW_RESIDENT_CHD' readonly></td>
		                        </td>
							</tr>
							<tr id ="SPECIAL_MK_DATA" style='display:none'>							
								<td align='right' class='tdgl1' nowrap>特殊註記：</td>
								<td class='tdGrayLight' colspan ='3'><input type=text name='SPECIAL_MK' readonly></td>
							</tr>
						</table>
						<!-- 編輯畫面結束 -->
					</td>
					<td width="13" background="<%=vr%>images/ap_index_mtb_06.gif" alt="排版用圖示">&nbsp;</td>
				</tr>
				<tr>
					<td width="13"><img src="<%=vr%>images/ap_index_mtb_07.gif" alt="排版用圖示" width="13" height="15"></td>
					<td width="100%"><img src="<%=vr%>images/ap_index_mtb_08.gif" alt="排版用圖示" width="100%" height="15"></td>
					<td width="13"><img src="<%=vr%>images/ap_index_mtb_09.gif" alt="排版用圖示" width="13" height="15"></td>
				</tr>
			</table>
			<!-- 編輯全畫面結束 -->
		</form>
		<!-- 定義編輯的 Form 結束 -->
	</div>

	<!--學籍資料-->
	<div id='TabCnt2' style='display:'>
		<form name="TAB2" method="post" style="margin:5,0,0,0;" onsubmit="doSave1();">
		<input type=hidden name="check">
			<!-- 編輯全畫面起始 -->
			<TABLE id="EDIT_DIV_TAB2" width="96%" border="0" align="center" cellpadding="0" cellspacing="0" summary="排版用表格">
				<tr>
					<td width="13"><img src="<%=vr%>images/ap_index_mtb_01.gif" alt="排版用圖示" width="13" height="14"></td>
					<td width="100%"><img src="<%=vr%>images/ap_index_mtb_02.gif" alt="排版用圖示" width="100%" height="14"></td>
					<td width="13"><img src="<%=vr%>images/ap_index_mtb_03.gif" alt="排版用圖示" width="13" height="14"></td>
				</tr>
				<tr>
					<td width="13" background="<%=vr%>images/ap_index_mtb_04.gif" alt="排版用圖示">&nbsp;</td>
					<td width="100%" valign="top" bgcolor="#FFFFFF">
						<!-- 按鈕畫面起始 -->
						<table width="100%" border="0" align="center" cellpadding="2" cellspacing="0" summary="排版用表格">
							<tr class="mtbGreenBg">
								<td align=left>【編輯畫面】- <span id='EditStatus'>新增</span></td>
								<td align=right>
									<div id="edit_btn">
										<input type=button class="btn" id="a5" value='多次畢業資訊' onkeypress="doOpen1();" onclick="doOpen1();">									
										<% if(request.getParameter("OPEN_WIN_BY_SGU008M") == null){ %>
											<input type=button class="btn" id="a2" value='回查詢頁' onkeypress='doBack();'onclick='doBack();'>
										<% }else if(request.getParameter("OPEN_WIN_BY_SGU008M").equals("YES")){ %>
											<input type=button class="btn" id="a2" value='關閉視窗' onkeypress='doClose1()' onclick='doClose1()'>
										<% } %>
									</div>
								</td>
							</tr>
						</table>
						<!-- 按鈕畫面結束 -->

						<!-- 編輯畫面起始 -->
						<table id="table2" width="100%" border="0" align="center" cellpadding="2" cellspacing="0" summary="排版用表格">
							<tr>
								<td align='right' class='tdgl1'>學號：</td>
								<td class='tdGrayLight'><input type=text name='STNO'><input type=text name='NAME'></td>
								<td align='right' class='tdgl2'>中心別：</td>
								<td class='tdGrayLight'><input type=text name='CENTER_CODE'></td>
							</tr>
							<tr>
								<td align='right' class='tdgl1'>報名身份別：</td>
								<td class='tdGrayLight'><input type=text name='STTYPE'></td>
								<td align='right' class='tdgl2'>新生入學學年期：</td>
								<td class='tdGrayLight'>
								<input type=text name='ENROLL_AYEAR'>								
								<select name='ENROLL_SMS'>
										<option value=''>請選擇</option>
										<script>Form.getSelectFromPhrase("SYST001_01_SELECT","KIND","SMS");</script>
								</select>
								</td>
							</tr>
							<tr>
								<td align='right' class='tdgl1'>新全修生入學學年期：</td>
								<td class='tdGrayLight'><input type=text name='FTSTUD_ENROLL_AYEAR'>
								<select name='FTSTUD_ENROLL_SMS'>
										<option value=''>請選擇</option>
										<script>Form.getSelectFromPhrase("SYST001_01_SELECT","KIND","SMS");</script>
								</select>
								</td>
								<td align='right' class='tdgl1' nowrap>雙主修註記：</td>
								<td class='tdGrayLight'><input type=text name='DBMAJOR_MK'></td>
								
							</tr>
							<tr style='display:none'>
								<td align='right' class='tdgl1'>專班起學年期：</td>
								<td class='tdGrayLight'><input type=text name='SAYEAR' >
								<select name='SSMS'>
										<option value=''>請選擇</option>
										<script>Form.getSelectFromPhrase("SYST001_01_SELECT","KIND","SMS");</script>
								</select>
								</td>
								<td align='right' class='tdgl2'>專班迄學年期：</td>
								<td class='tdGrayLight'><input type=text name='EAYEAR'>
								<select name='ESMS'>
										<option value=''>請選擇</option>
										<script>Form.getSelectFromPhrase("SYST001_01_SELECT","KIND","SMS");</script>
								</select>
								</td>
							</tr>
							<tr>								
								<td align='right' class='tdgl2'>停權起學年期：</td>								
								<td class='tdGrayLight'>
									<input type=text name='STOP_PRVLG_SAYEAR'>
									<select name='STOP_PRVLG_SSMS'>
										<option value=''>請選擇</option>
										<script>Form.getSelectFromPhrase("SYST001_01_SELECT","KIND","SMS");</script>
									</select>
								</td>
								<td align='right' class='tdgl1'>停權迄學年期：</td>
								<td class='tdGrayLight'>
								<input type=text name='STOP_PRVLG_EAYEAR'>
									<select name='STOP_PRVLG_ESMS'>										
										<option value=''>請選擇</option>
										<script>Form.getSelectFromPhrase("SYST001_01_SELECT","KIND","SMS");</script>
									</select>
								</td>
							</tr>
							<tr>
							<td align='right' class='tdgl1'>最近一次畢業學年期：</td>
								<td class='tdGrayLight'>
									<input type=text name='GRAD_AYEAR'>
									<select name='GRAD_SMS'>										
										<script>Form.getSelectFromPhrase("SYST001_01_SELECT","KIND","SMS");</script>
									</select>
								</td>								
								<td align='right' class='tdgl2'>退學學年期：</td>
								<td class='tdGrayLight'>
									<input type=text name='DROPOUT_AYEAR'>
									<select name='DROPOUT_SMS'>										
										<script>Form.getSelectFromPhrase("SYST001_01_SELECT","KIND","SMS");</script>
									</select>
								</td>
							</tr>
							<tr>
								<td align='right' class='tdgl1'>預定主修學系：</td>								
								<td class='tdGrayLight'>
									<select name='PRE_MAJOR_FACULTY'>
										<option value=''>請選擇</option>
										<script>Form.getSelectFromPhrase("FACULTY_CODE","","");</script>
									</select>
								</td>
								</td>
								<td align='right' class='tdgl2' nowrap>最近一次畢業學系(科)：</td>
								<td class='tdGrayLight'><input type=text name='GRAD_MAJOR_FACULTY'></td>
							</tr>							
							<tr>
								<td align='right' class='tdgl1' nowrap>是否參加導師班：</td>
								<td class='tdGrayLight'><input type=text name='TUTOR_CLASS_MK'></td>
								<td align='right' class='tdgl2' nowrap>是否曾經跨校報名註記：</td>
								<td class='tdGrayLight'><input type=text name='OTHER_REG_MK'></td>
							</tr>
							<tr>
								<td align='right' class='tdgl1' nowrap>當學期學籍狀態：</td>
								<td class='tdGrayLight'><div id='ENROLL_STATUS'></div></td>
								<td align='right' class='tdgl2'>空大Email：</td>
								<td class='tdGrayLight'><input type=text name='NOU_EMAIL'></td>
							</tr>
							<tr>
								<td align='right' class='tdgl2' >專班代號：</td>
								<td class='tdGrayLight'><input type=text name='SPCLASS_CODE'></td>
								<td align='right' class='tdgl2' nowrap>空專科組別：</td>
								<td class='tdGrayLight'><input type=text name='J_FACULTY_CODE'></td>
								<td align='right' class='tdgl2' nowrap style='display:none'>專班類別：</td>
								<td class='tdGrayLight' style='display:none'><input type=text name='SPCLASS_TYPE'></td>
							</tr>
							<tr>
								<td align='right' class='tdgl1'>報名全修生入學學歷：</td>
								<td class='tdGrayLight' colspan=3><input type=text name='EDUBKGRD'>
								<font color='GREEN'>畢(修)業學年度</font><input size="3" type=text name='EDUBKGRD_AYEAR'>					
							</tr>
							<tr>
								<td align='right' class='tdgl1'>學歷類別<font color=red>＊</font>：</td>
								<td class='tdGrayLight' >
									<select name='EDUBKGRD_GRADE'>
										<option value=''>請選擇</option>
										<script>Form.getSelectFromPhrase("SYST001_01_SELECT","KIND","EDUBKGRD_GRADE");</script>
									</select> 
								</td>
								<td align='right' class='tdgl1'>報名入學學力：</td>
								<td class='tdGrayLight'><span id='EduabilType'>　</span></td>
							</tr>
							<tr>
								<td align='right' class='tdgl1'>畢業類別<font color=red>＊</font>：</td>
								<td class='tdGrayLight' >
									<input type=text name='GRAD_KIND_1' disabled>
									<!-- 
									<select name='GRAD_KIND' disabled>
										<script>Form.getSelectFromPhrase("SYST001_01_SELECT","KIND","GRAD_KIND");</script>
									</select>
									 -->
								</td>
								<td align='right' class='tdgl1'>畢業學力類別：</td>
								<td class='tdGrayLight'><input type=text name='EDUBKGRD_ABILITY' disabled></td>
							</tr>
							<tr style='display:none'>
								<td align='right' class='tdgl2'>減免類別：<br>(永久錄案)</td>
								<td class='tdGrayLight' colspan=3><input type=text name='REDUCE_TYPE'></td>							
							</tr>
							<tr>
								<td align='right' class='tdgl1'>特殊專班註記：</td>
								<td class='tdGrayLight'>
									<select name='SPECIAL_STTYPE_TYPE'>
										<option value=''>請選擇</option>
										<script>Form.getSelectFromPhrase("SYST001_01_SELECT","KIND","SPECIAL_STTYPE_MK");</script>
									</select>
								</td>
								<td align='right' class='tdgl1'>起始學年期：</td>
								<td class='tdGrayLight'>
									<input type=text name='SPECIAL_AYEAR'>
									<select name='SPECIAL_SMS'>										
										<option value=''>請選擇</option>
										<script>Form.getSelectFromPhrase("SYST001_01_SELECT","KIND","SMS");</script>
									</select>
								</td>
							</tr>
							<tr>
								<td align='right' class='tdgl1'>累計實得學分：</td>
								<td class='tdGrayLight'>
									<input type=text name='ACCUM_PASS_CRD' disabled>
								</td>
								<td align='right' class='tdgl1'>累計抵免學分：</td>
								<td class='tdGrayLight'>
									<input type=text name='ACCUM_REPL_CRD' disabled>									
								</td>
							</tr>
							<tr>
								<td align='right' class='tdgl1'>累計減修學分：</td>
								<td class='tdGrayLight'>
									<input type=text name='ACCUM_REDUCE_CRD' disabled>
								</td>
								<td align='right' class='tdgl1'>旁聽生註記：</td>
								<td class='tdGrayLight'>
									<select name='INFORMAL_STUTYPE'>
										<option value=''>請選擇</option>
										<script>Form.getSelectFromPhrase("SYST001_01_SELECT","KIND","INFORMAL_STUTYPE");</script>
									</select>
								</td>
									
								</td>
							</tr>
						</table>
						<!-- 編輯畫面結束 -->
					</td>
					<td width="13" background="<%=vr%>images/ap_index_mtb_06.gif" alt="排版用圖示">&nbsp;</td>
				</tr>
				<tr>
					<td width="13"><img src="<%=vr%>images/ap_index_mtb_07.gif" alt="排版用圖示" width="13" height="15"></td>
					<td width="100%"><img src="<%=vr%>images/ap_index_mtb_08.gif" alt="排版用圖示" width="100%" height="15"></td>
					<td width="13"><img src="<%=vr%>images/ap_index_mtb_09.gif" alt="排版用圖示" width="13" height="15"></td>
				</tr>
			</table>
			<!-- 編輯全畫面結束 -->
		</form>
		<!-- 定義編輯的 Form 結束 -->
	</div>

	<!--歷程資料-->
	<div id='TabCnt3' style='display:none'>
		<!-- 定義查詢的 Form 起始 -->
		<form name="QUERY" method="post" onsubmit="doQuery();" style="margin:0,0,5,0;">
			<input type=hidden name="control_type">
			<input type=hidden name="pageSize">
			<input type=hidden name="pageNo">
			<input type=hidden name="EXPORT_FILE_NAME">
			<input type=hidden name="EXPORT_COLUMN_FILTER">
			<input type=hidden name="STNO">
			<input type=hidden name="ASYS">
		</form>
		<!-- 定義查詢的 Form 結束 -->
		<!-- 定義查詢結果的 Form 起始 -->
		<form name="RESULT" method="post" style="margin:10,0,0,0;">
			<input type=hidden name="control_type">
			<input type=hidden keyColumn="Y" name="IDNO">
			<input type=hidden keyColumn="Y" name="BIRTHDATE">
			<input type=hidden name="STNO">	

			<!-- 查詢結果畫面起始 -->
			<table width="96%" border="0" align="center" cellpadding="0" cellspacing="0" summary="排版用表格">
				<tr>
					<td width="13"><img src="<%=vr%>images/ap_index_mtb_01.gif" alt="排版用圖示" width="13" height="14"></td>
					<td width="100%"><img src="<%=vr%>images/ap_index_mtb_02.gif" alt="排版用圖示" width="100%" height="14"></td>
					<td width="13"><img src="<%=vr%>images/ap_index_mtb_03.gif" alt="排版用圖示" width="13" height="14"></td>
				</tr>
				<tr>
					<td width="13" background="<%=vr%>images/ap_index_mtb_04.gif" alt="排版用圖示">&nbsp;</td>
					<td width="100%" bgcolor="#FFFFFF">
						<table width="100%" border="0" cellspacing="0" cellpadding="2" summary="排版用表格">
							<tr>
								<!-- 查詢結果按鈕起始 -->
								<td align=left>
									<% if(request.getParameter("OPEN_WIN_BY_SGU008M") == null){ %>
										<input type=button class="btn" value='回查詢頁' onkeypress='doBack();'onclick='doBack();'>
									<% }else if(request.getParameter("OPEN_WIN_BY_SGU008M").equals("YES")){ %>
										<input type=button class="btn" value='關閉視窗' onkeypress='doClose1()' onclick='doClose1()'>
									<% } %>
								</td>
								<!-- 查詢結果按鈕結束 -->

								<!-- 分頁字串起始 -->
								<td align=right nowrap>
									<div id="page">
										<b>
											<span id="pageStr"></span>
											【<input type='text' name='_scrollSize' size=2 value='10' style="text-align:center">
											<input type=button value='筆' onkeypress="setPageSize();"onclick="setPageSize();">
											<input type='text' name='_goToPage' size=2 value='1' style="text-align:right">
											/ <span id="totalPage"></span> <input type=button value='頁' onkeypress='gotoPage(null)'onclick='gotoPage(null)'>
											<span id="totalRow">0</span> 筆】

										</b>
									</div>
								</td>
								<!-- 分頁字串結束 -->
							</tr>
						</table>
						<!-- 查詢結果功能畫面起始 -->
						<div id="grid-scroll" style="overflow:auto;width:100%;height:300;"></div>
						<input type=hidden name='EXPORT_FILE_NAME'>
						<textarea name='EXPORT_CONTENT' cols=80 rows=3 style='display:none'></textarea>
						<textarea name='ALL_CONTENT' cols=80 rows=3 style='display:none'></textarea>
						<!-- 查詢結果功能畫面結束 -->
					</td>
					<td width="13" background="<%=vr%>images/ap_index_mtb_06.gif" alt="排版用圖示">&nbsp;</td>
				</tr>
				<tr>
					<td width="13"><img src="<%=vr%>images/ap_index_mtb_07.gif" alt="排版用圖示" width="13" height="15"></td>
					<td width="100%"><img src="<%=vr%>images/ap_index_mtb_08.gif" alt="排版用圖示" width="100%" height="15"></td>
					<td width="13"><img src="<%=vr%>images/ap_index_mtb_09.gif" alt="排版用圖示" width="13" height="15"></td>
				</tr>
			</table>
			<!-- 查詢結果畫面結束 -->
		</form>
		<!-- 定義查詢結果的 Form 結束 -->
	</div>
</div>



<script>
	document.write ("<font color=\"white\">" + document.lastModified + "</font>");
	window.attachEvent("onload", page_init);
	window.attachEvent("onload", onloadEvent);
</script>
</body>
</html>