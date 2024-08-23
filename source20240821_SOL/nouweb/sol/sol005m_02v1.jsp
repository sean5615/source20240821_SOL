
<%/*
----------------------------------------------------------------------------------
File Name        : sol005m_01v1
Author            : 曾國昭
Description        : SOL005M_登錄報名學生資料 - 顯示頁面
Modification Log    :

Vers        Date           By                Notes
--------------    --------------    --------------    ----------------------------------
0.0.1        096/02/27    曾國昭        Code Generate Create
----------------------------------------------------------------------------------
*/%>
<%@ page contentType="text/html; charset=UTF-8" errorPage="/utility/errorpage.jsp" pageEncoding="MS950"%>
<%@ include file="/utility/header.jsp"%>
<%@ page import="com.nou.sol.signup.po.*"%>
<%@page import="java.util.Vector"%>
<%@page import="com.nou.aut.AUTGETRANGE"%>
<%
session.setAttribute("SOLT005_01_SELECT", "NOU#select CODE AS SELECT_VALUE,CODE_NAME AS SELECT_TEXT from SYST001 where KIND='ASYS' and (CODE = '1' or CODE = '2') ORDER BY SELECT_VALUE, SELECT_TEXT");
session.setAttribute("SOLT005_02_SELECT", "NOU#select CODE AS SELECT_VALUE,CODE_NAME AS SELECT_TEXT from SYST001 where KIND='STTYPE' and code not in ('3','4') ORDER BY SELECT_VALUE, SELECT_TEXT");
session.setAttribute("SOLT005_031_SELECT", "NOU#select CENTER_CODE AS SELECT_VALUE,CENTER_ABBRNAME AS SELECT_TEXT from SYST002 WHERE CENTER_CODE not in ('00') ORDER BY DECODE(CENTER_CODE,'15','021',CENTER_CODE)");
session.setAttribute("SOLT005_032_SELECT", "NOU#select CENTER_CODE AS SELECT_VALUE,CENTER_ABBRNAME AS SELECT_TEXT from SYST002 WHERE CENTER_CODE not in ('00') ORDER BY DECODE(CENTER_CODE,'15','021',CENTER_CODE)");
session.setAttribute("SOLT005_04_SELECT", "NOU#select CODE AS SELECT_VALUE,CODE_NAME AS SELECT_TEXT from SYST001 where KIND='PAYMENT_MANNER' and (CODE = '5' or CODE = '6') ORDER BY SELECT_VALUE, SELECT_TEXT");
//session.setAttribute("SOLT005_05_SELECT", "NOU#select CODE AS SELECT_VALUE,CODE_NAME AS SELECT_TEXT from SYST001 where KIND='AUDIT_RESULT' ORDER BY SELECT_VALUE, SELECT_TEXT");
//session.setAttribute("SOLT005_06_SELECT", "NOU#select CODE AS SELECT_VALUE,CODE_NAME AS SELECT_TEXT from SYST001 where KIND='SMS' ORDER BY SELECT_VALUE, SELECT_TEXT");
session.setAttribute("SOLT005_07_SELECT", "NOU#select CODE AS SELECT_VALUE,CODE_NAME AS SELECT_TEXT from SYST001 where KIND='PAYMENT_STATUS' and (CODE = '1' or CODE = '2') ORDER BY SELECT_VALUE, SELECT_TEXT");
session.setAttribute("SOLT005_08_SELECT", "NOU#select CONCAT(a.FACULTY_CODE, a.TOTAL_CRS_NO) as SELECT_VALUE, a.TOTAL_CRS_NAME as SELECT_TEXT from syst008 a where a.ASYS = '1' and a.FACULTY_CODE not in  ('90','80','00') and a.TOTAL_CRS_NO like '0%' ORDER BY SELECT_VALUE, SELECT_TEXT");
session.setAttribute("SOLT005_09_SELECT", "NOU#select CONCAT(a.FACULTY_CODE, a.TOTAL_CRS_NO) as SELECT_VALUE, a.TOTAL_CRS_NAME as SELECT_TEXT from syst008 a where a.ASYS = '2' and a.FACULTY_CODE != '90' and a.TOTAL_CRS_NO like '0%' ORDER BY SELECT_VALUE, SELECT_TEXT");
session.setAttribute("SOLT005_10_SELECT", "NOU#select CODE AS SELECT_VALUE,CODE_NAME AS SELECT_TEXT from SYST001 where KIND='STTYPE' and code ='3' ORDER BY SELECT_VALUE, SELECT_TEXT");
//session.setAttribute("SOLT005_11_SELECT", "NOU#select CODE AS SELECT_VALUE,CODE_NAME AS SELECT_TEXT from SYST001 where KIND='EDUBKGRD_GRADE' ORDER BY SELECT_VALUE, SELECT_TEXT");
//session.setAttribute("SOLT005_12_SELECT", "NOU#select CODE AS SELECT_VALUE,CODE_NAME AS SELECT_TEXT from SYST001 where KIND='SPECIAL_STTYPE_MK' ORDER BY SELECT_VALUE, SELECT_TEXT");
session.setAttribute("SOLT005_13_SELECT", "NOU#select CODE AS SELECT_VALUE,CODE_NAME AS SELECT_TEXT from SYST001 where KIND='NATIONCODE' and code ='000' ORDER BY SELECT_VALUE, SELECT_TEXT");
session.setAttribute("SOLT005_14_SELECT", "NOU#select CODE AS SELECT_VALUE,CODE_NAME AS SELECT_TEXT from SYST001 where KIND='NATIONCODE' and code !='000' ORDER BY SELECT_VALUE, SELECT_TEXT");
session.setAttribute("SOLT007_22_SELECT", "NOU#select CODE AS SELECT_VALUE,CODE_NAME AS SELECT_TEXT from SYST001 where KIND='NATIONCODE' AND CODE != '000' ORDER BY SELECT_VALUE, SELECT_TEXT");
session.setAttribute("SOLT005_16_SELECT", "NOU#select CODE AS SELECT_VALUE,CODE_NAME AS SELECT_TEXT from SYST001 where KIND='NATIONCODE' and code ='000' ORDER BY SELECT_VALUE, SELECT_TEXT");
session.setAttribute("SOLT005_17_SELECT", "NOU#select CODE AS SELECT_VALUE,CODE_NAME AS SELECT_TEXT from SYST001 where KIND='EDUBKGRD_GRADE' AND CODE NOT IN ('15','16') ORDER BY SELECT_VALUE, SELECT_TEXT");
	/**取得行政人員所屬中心*/
	String user_id = (String) session.getAttribute("USER_ID");
	AUTGETRANGE aut = new AUTGETRANGE();
	aut.initRangeData(user_id);
	Vector centerVt = aut.getDEP_CODE("4","3");
	String cd="";
	if( centerVt.size()!=0)
	{
		cd += centerVt.get(0);
		// if(centerVt.size() >= 2)
		// {
			// cd += centerVt.get(0);
			// cd2 += "'" + centerVt.get(0) + "'";
			// cd3 += centerVt.get(0);
			// for(int i=1;i<centerVt.size();i++)
			// {
				// cd += ","+centerVt.get(i);
				// cd2 += ", '" + centerVt.get(i) + "'";
			// }
		// }else{
			// cd += centerVt.get(0);
			// cd2 += "'" + centerVt.get(0) + "'";
			// cd3 += centerVt.get(0);
		// }
	}else{	
		cd="00";//教務處(校本部人員)
	}

%>
<html>
<head>
<%@ include file="/utility/viewpageinit.jsp"%>
<script src="<%=vr%>script/framework/query1_1_0_2.jsp"></script>
<script src="sol005m_02c1.jsp"></script>


<noscript>
<p>您的瀏覽器不支援JavaScript語法，但是並不影響您獲取本網站的內容</p>
</noscript>
</head>
<body background="<%=vr%>images/ap_index_bg.jpg" alt="背景圖" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">

<!-- 定義查詢的 Form 起始 -->
<form name="QUERY" method="post" style="margin:0,0,5,0;">
<input type=hidden name="control_type"> 
<input type=hidden name="pageSize"> 
<input type=hidden name="pageNo"> 
<input type=hidden name="EXPORT_FILE_NAME"> 
<input type=hidden name="EXPORT_COLUMN_FILTER"> 
<TABLE id="QUERY_DIV" width="96%" border="0" align="center" cellpadding="0" cellspacing="0" summary="排版用表格">
	<tr>
		<td width="13"><img src="<%=vr%>images/ap_search_01.jpg" alt="排版用圖示" width="13" height="12"></td>
		<td width="100%"><img src="<%=vr%>images/ap_search_02.jpg" alt="排版用圖示" width="100%" height="12"></td>
		<td width="13"><img src="<%=vr%>images/ap_search_03.jpg" alt="排版用圖示" width="13" height="12"></td>
	</tr>
	<tr>
		<td width="13" background="<%=vr%>images/ap_search_04.jpg" alt="排版用圖示">&nbsp;</td>
		<td width="100%" valign="top" bgcolor="#C5E2C3"><!-- 按鈕畫面起始 -->
		<table width="100%" border="0" align="center" cellpadding="2" cellspacing="0" summary="排版用表格">
			<tr class="mtbGreenBg">
				<td align=left>【查詢畫面】<span id="old"></span></td>
				<td align=right>
				<div id="serach_btn"><input type=button class="btn" value='檢查是否可報名' onkeypress="doSOLCK();" onclick="doSOLCK();"></div>
				</td>
			</tr>
		</table>
		<!-- 按鈕畫面結束 --> <!-- 查詢畫面起始 -->
		<table id="table1" width="100%" border="0" align="center" cellpadding="2" cellspacing="1" summary="排版用表格">
			<tr>
				<td align='right'>報名學年期<font color=red>＊</font>：</td>
				<td>
				<input type=text name="AYEAR" value='<%=(String)session.getAttribute("SOL005m_nextayear")%>'>
				<select name='SMS' value='<%=(String)session.getAttribute("SOL005m_nextsms")%>'>
					<option value=''>請選擇</option>
					<script>Form.getSelectFromPhrase("SYST001_01_SELECT", "KIND", "SMS");</script>
				</select>
				</td>
				<td align='right'>學制<font color=red>＊</font>：</td>
				<td><select name='ASYS' id='ASYS' onchange="doPreMajor();checkIDNO();">
					<script>Form.getSelectFromPhrase("SOLT005_01_SELECT", null, null);</script>
				</select></td>
				<td align='right'>報名身分別<font color=red>＊</font>：</td>
				<td ><div id="sol005_sttype2"><select name='STTYPE' id='STTYPE2' onchange='hidden();'>
					<option value=''>請選擇</option>
					<script>Form.getSelectFromPhrase("SOLT005_02_SELECT", null, null);</script>
				</select></div></td>			
			</tr>
			<tr>
				<td align='right'>中華民國證件類別<font color=red>＊</font>：</td>
				<td><select name='idtype' id='idtype' onchange="getNationalCode()"> 
					<option value=''>請選擇</option>
					<option value='1'>身分證</option>
					<option value='2'>居留證</option>
					<option value='3'>護照</option>
				</select></td>
				<td align='right'>
				<span style="color:#037662;font-size:10pt">國籍別</span><font color=red>＊</font>：
				<select name='NATIONCODE' id="NATIONCODE">				
				</select>
				</td>
				<td align='left' >
					<div id="radioBoxArea" style='display:none;'>
<!-- 						<label><input type='radio' id='radioIdno' name='radioType' value='1'>身分證</label> -->
<!-- 						<label><input type='radio' id='radioPassportNo' name='radioType' value='2'>護照號碼</label> -->
					</div>
					<span style="color:#037662;font-size:10pt" id="type_exp" >身分證</span><font color=red>＊</font>：
					<input type=text name='IDNO' id='IDNO' onblur='checkIDNO();' maxlength='10' size = '10'><br>
					<span style="color:#037662;font-size:10pt" id="expDateSpan" >證件到期日<font color=red>＊</font>：</span>
					<span id='expDateInput'><input type=text name='EXP_DATE' id='EXP_DATE'><img src='/images/calendar.gif' alt='日曆圖示 ' style='cursor:hand' onkeypress='Calendar.showCalendar(this, _i("QUERY", "EXP_DATE"));' onclick='Calendar.showCalendar(this, _i("QUERY", "EXP_DATE"));'></span>
				</td>
				<td align='right'>出生日期<font color=red>＊</font>：</td>
				<td><input type=text name='BIRTHDATE' id='BIRTHDATE'><img src='/images/calendar.gif' alt='日曆圖示 ' style='cursor:hand' onkeypress='Calendar.showCalendar(this, _i("QUERY", "BIRTHDATE"));' onclick='Calendar.showCalendar(this, _i("QUERY", "BIRTHDATE"));'></td>
				
			</tr>
			<tr><td colspan='6' align='center'><span class="title"><font color=brown></font></span></td></tr>
		</table>
		
		<!-- 查詢畫面結束 --></td>
		<td width="13" background="<%=vr%>images/ap_search_06.jpg" alt="排版用圖示">&nbsp;</td>
	</tr>
	<tr>
		<td width="13"><img src="<%=vr%>images/ap_search_07.jpg" alt="排版用圖示" width="13" height="13"></td>
		<td width="100%"><img src="<%=vr%>images/ap_search_08.jpg" alt="排版用圖示" width="100%" height="13"></td>
		<td width="13"><img src="<%=vr%>images/ap_search_09.jpg" alt="排版用圖示" width="13" height="13"></td>
	</tr>
</table>
<!-- 查詢全畫面結束 --></form>
<!-- 定義查詢的 Form 結束 -->

<!-- 標題畫面起始 -->
<table width="96%" border="0" align="center" cellpadding="4" cellspacing="0" summary="排版用表格">
	<tr>
		<td>
		<table width="500" height="27" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td background="<%=vr%>images/ap_index_title.jpg" alt="排版用圖示"><span class="title">SOL005M_登錄現場報名學生資料</span></td>
			</tr>
		</table>
		</td>
	</tr>
</table>
<!-- 標題畫面結束 -->

<!-- 定義編輯的 Form 起始 -->
<form name="EDIT" method="post" onsubmit="doSave();" style="margin:5,0,0,0;">
<input type=hidden name="control_type"> 
<input type=hidden name="ROWSTAMP"> 
<input type=hidden name='ASYS'>
<input type=hidden name='SPECIAL_STUDENT'>
<input type=hidden name='SERNO'>
<input type=hidden name='PAYMENT_STATUS' value="1">
<input type=hidden name='DMSTADDR'>
<input type=hidden name='CRRSADDR'>
<input type=hidden name='TEL_OFFICE'>
<input type=hidden name='TEL_HOME'>
<input type=hidden name='MOBILE'>
<input type=hidden name='EMAIL'>
<input type=hidden name='MARRIAGE'>
<input type=hidden name='CD' value='<%=cd%>'>
<input type=hidden name='VOCATION'>
<input type=hidden name='EMRGNCY_NAME'>
<input type=hidden name='EMRGNCY_RELATION'>
<input type=hidden name='EMRGNCY_TEL'>
<input type=hidden name='AREACODE_OFFICE'>
<input type=hidden name='TEL_OFFICE_EXT'>
<input type=hidden name='AREACODE_HOME'>
<input type=hidden name='STNO'>
<input type=hidden name='IDTYPE2' id='IDTYPE2' value='N'>
<input type=hidden name='IDTYPE3' id='IDTYPE3' value='N'>
<input type=hidden name='idtype' id='idtype'>
<input type=hidden name='RESIDENCE_BASEDATE' id='RESIDENCE_BASEDATE' value=''>

<input type=hidden name='LIMIT' value='<%=(String)session.getAttribute("limit")%>'>

<!-- 編輯全畫面起始 -->
<TABLE id="EDIT_DIV" width="96%" border="0" align="center" cellpadding="0" cellspacing="0" summary="排版用表格">
	<tr>
		<td width="13"><img src="<%=vr%>images/ap_index_mtb_01.gif" alt="排版用圖示" width="13" height="14"></td>
		<td width="100%"><img src="<%=vr%>images/ap_index_mtb_02.gif" alt="排版用圖示" width="100%" height="14"></td>
		<td width="13"><img src="<%=vr%>images/ap_index_mtb_03.gif" alt="排版用圖示" width="13" height="14"></td>
	</tr>
	<tr>
		<td width="13" background="<%=vr%>images/ap_index_mtb_04.gif" alt="排版用圖示">&nbsp;</td>
		<td width="100%" valign="top" bgcolor="#FFFFFF"><!-- 按鈕畫面起始 -->
		<table width="100%" border="0" align="center" cellpadding="2" cellspacing="0" summary="排版用表格">
			<tr class="mtbGreenBg">
				<td align=left>【編輯畫面】- <span id='EditStatus'>新增</span></td>
				<td align=right>
				<div id="edit_btn">
					<input type=button name="SAVE_BTN" class="btn" value='繼續登錄報名完整資料' onkeypress='doSet("1");' onclick='doSet("1");'> 
					<input type=button class="btn" value='清  除' onkeypress='doSOLCK();' onclick='doSOLCK();'> 
					<input type=button name="SAVE_BTN" class="btn" value='存  檔' onkeypress='doSave();' onclick='doSave();'>
				</div>
				</td>
			</tr>
		</table>
		<!-- 按鈕畫面結束 --> <!-- 編輯畫面起始 -->
		<table id="table2" width="100%" border="0" align="center" cellpadding="2" cellspacing="0" summary="排版用表格">
			<tr>
				<td align='right' class='tdgl2'>學年<font color=red>＊</font>：</td>
				<td class='tdGrayLight'><input type=text id="AYEAR" name='AYEAR' readonly></td>
				<td align='right' class='tdgl2'>學期<font color=red>＊</font>：</td>
				<td class='tdGrayLight'><select name='SMS' id='SMS' disabled>
					<option value=''>請選擇</option>
					<script>Form.getSelectFromPhrase("SYST001_01_SELECT", "KIND", "SMS");</script>
				</select></td>
			</tr>
			<tr>
				<td align='right' class='tdgl1'>身分證字號<font color=red>＊</font>：</td>
				<td class='tdGrayLight'>
					<input type=text id="IDNO" name='IDNO' readonly>
				</td>
				<td align='right' class='tdgl1'>出生日期<font color=red>＊</font>：</td>
				<td class='tdGrayLight'><input type=text id="BIRTHDATE" name='BIRTHDATE' readonly></td>
			</tr>
			<tr>
				<td align='right' class='tdgl1'>法定性別<font color=red>＊</font>：</td>
				<td class='tdGrayLight'>
					<select name='SEX'>
                        <option value=''>請選擇</option>
                        <option value='1'>男</option>
                        <option value='2'>女</option>
                	</select>
				</td>
				<td align='right' class='tdgl1'>自我認同性別<font color=red></font>：</td>
				<td class='tdGrayLight'>
					<select name='SELF_IDENTITY_SEX'>
                        <option value=''>請選擇</option>
                        <option value='1'>男</option>
                        <option value='2'>女</option>
                        <option value='3'>非二元</option>
                	</select></td>
			</tr>
			<tr>
				<td align='right' class='tdgl1'><div id="centerCode">報名學習指導中心<font color=red>＊</font>：</div></td>
				<td class='tdGrayLight'><div id="centerCodeSelect"><select name='CENTER_CODE' id='CENTER_CODE'>
					<option value=''>請選擇</option>
					<script>Form.getSelectFromPhrase("SOLT005_031_SELECT", null, null);</script>
				</select></div></td>
				<td align='right' class='tdgl2'>報名身分別<font color=red>＊</font>：</td>
				<td class='tdGrayLight'><div id="sol005_sttype"><select name='STTYPE' id='STTYPE'>
					<option value=''>請選擇</option>
					<script>Form.getSelectFromPhrase("SOLT005_02_SELECT", null, null);</script>
				</select></div></td>
			</tr>
			<tr>
				<td align='right' class='tdgl2'>姓名<font color=red>＊</font>：</td>
				<td class='tdGrayLight'><input type=text name='NAME' id='NAME'></td>
				<td align='right' class='tdgl1'>國籍別<font color=red>＊</font>：</td>
				<td class='tdGrayLight' >
					<select name='NATIONCODE' id ='NATIONCODE'  disabled >
						<!-- <option value=''>請選擇</option>  -->
						<script>Form.getSelectFromPhrase("SYST001_01_SELECT","KIND","NATIONCODE");</script>
					</select>
					<!-- 新住民註記：<input type=text name='NEWNATION' > -->
				</td>
			</tr>
			<tr>
				<td align='right' class='tdgl2'>戶籍郵遞區號<font color=red>＊</font>：</td>
				<td class='tdGrayLight'><input type=text name='DMSTADDR_ZIP' id='DMSTADDR_ZIP' onchange='doAsMdszip()'></td>
				<td align='right' class='tdgl1'>新住民原國別：</td>
				<td class='tdGrayLight'>
					<select name='NEWNATION'>
							<option value="">請選擇</option>
							<script>Form.getSelectFromPhrase("SOLT007_22_SELECT", null, null);</script>
					</select>
				</td>				
			</tr>
			<tr>
				<td align='right' class='tdgl2'>通訊郵遞區號<span id='G11'></span>：</td>
				<td class='tdGrayLight'><input type=text name='CRRSADDR_ZIP' id='CRRSADDR_ZIP'><input type="checkbox" name = 'crrzip_as_mdszip' onclick='doAsMdszip()'>等同戶籍郵遞區號</td>
				<td align='right' class='tdgl1'>護照居留證到期日<font color=red ></font>：</td>
                <td class='tdGrayLight' colspan = "3" >
                    <input type=text id="RESIDENCE_DATE" name='RESIDENCE_DATE' >
                </td>
			</tr>
			<tr>
				<td align='right' class='tdgl2'>匯票號碼<font color=red></font>：</td>
				<td class='tdGrayLight'><input type=text name='DRAFT_NO' id='DRAFT_NO'></td>
				<td align='right' class='tdgl2'>繳費方式＼金額<font color=red>＊</font>：</td>
				<td class='tdGrayLight'>
					<select name='PAYMENT_METHOD' id='PAYMENT_METHOD' onchange="doDisabled(this.value)">
					<option value=''>請選擇</option>
					<script>Form.getSelectFromPhrase("SOLT005_04_SELECT", null, null);</script>
					<input type=text name='REG_FEE' id='REG_FEE'>
				</td>
			</tr>
			<tr>
				<td align='right' class='tdgl1'>證件正本是否符合<font color=red>＊</font>：</td>
				<td class='tdGrayLight' ><select name='CHECK_DOC' id='CHECK_DOC'>
					<option value=''>請選擇</option>
					<script>Form.getSelectFromPhrase("SYST001_01_SELECT", "KIND", "AUDIT_RESULT");</script>
				</select></td>
				<td align='right' class='tdgl1'>免繳費原因<font color=red></font>：</td>
				<td class='tdGrayLight' ><input type=text name='NPAYMENT_BAR' id='NPAYMENT_BAR'></td>
			</tr>
			<tr>
				<td align='right' class='tdgl2'>證件不符原因<font color=red></font>：</td>
				<td class='tdGrayLight' ><input type=text name='DOC_UNQUAL_REASON' id='DOC_UNQUAL_REASON'></td>
				<td align='right' class='tdgl1'>中心審查結果<font color=red>＊</font>：</td>
				<td class='tdGrayLight' ><select name='AUDIT_RESULT' id='AUDIT_RESULT'>
					<option value=''>請選擇</option>
					<script>Form.getSelectFromPhrase("SYST001_01_SELECT", "KIND", "AUDIT_RESULT");</script>
				</select><div id='checkbox_doc'></div></td>
				</td>
			</tr>
			<tr>
			<td align='right' class='tdgl1'><div id="preMajorFaculty">預定主修學系<font color=red>＊</font>：</div></td>
				<td class='tdGrayLight'>
					<div id="majorForSelect">
						<select name='PRE_MAJOR_FACULTY' id='PRE_MAJOR_FACULTY'>
							<option value="0000">尚未決定</option>
							<script>Form.getSelectFromPhrase("SOLT005_08_SELECT", null, null);</script>
						</select>
					</div>
				</td>
				<td align='right' class='tdgl2'>特殊生註記：</td>
				<td class='tdGrayLight' >
					<select name='SPECIAL_STTYPE_TYPE' id='SPECIAL_STTYPE_TYPE'>
						<option value="">請選擇</option>
						<script>Form.getSelectFromPhrase("SYST001_01_SELECT", "KIND", "SPECIAL_STTYPE_MK");</script>
					</select>
				</td>
			</tr>
			<tr>                
                
                <td align='right' class='tdgl2'>入學學歷類別<font color=red>＊</font>：</td>
                <td class='tdGrayLight'>
                    <select name='EDUBKGRD_GRADE'>
					<option value=''>請選擇</option>
                    <script>Form.getSelectFromPhrase("SOLT005_17_SELECT", null, null);</script>
					</select>
				</td>
				<td align='right' class='tdgl2'>導師班<font color=red>＊</font>：</td>
                <td class='tdGrayLight'>
                    <select name='TUTOR_CLASS_MK' >
					<option value='1'>隨機編班</option>
                    <!-- <script>Form.getSelectFromPhrase("SOLT007_05_SELECT", null, null);</script> --> 
                    </select>
						</td>
            </tr>
		</table>
		<!-- 編輯畫面結束 --></td>
		<td width="13" background="<%=vr%>images/ap_index_mtb_06.gif" alt="排版用圖示">&nbsp;</td>
	</tr>
	<tr>
		<td width="13"><img src="<%=vr%>images/ap_index_mtb_07.gif" alt="排版用圖示" width="13" height="15"></td>
		<td width="100%"><img src="<%=vr%>images/ap_index_mtb_08.gif" alt="排版用圖示" width="100%" height="15"></td>
		<td width="13"><img src="<%=vr%>images/ap_index_mtb_09.gif" alt="排版用圖示" width="13" height="15"></td>
	</tr>
</table>
<!-- 編輯全畫面結束 --></form>
<!-- 定義編輯的 Form 結束 -->

<!-- 定義查詢結果的 Form 起始 -->
<span id="menu1" style="display:'none'">
<form name="RESULT" method="post" style="margin:10,0,0,0;">
	<input type=hidden name="control_type">
	<input type=hidden keyColumn="Y" name="AYEAR">
	<input type=hidden keyColumn="Y" name="SMS">
	<input type=hidden keyColumn="Y" name="SERNO">

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
</span>
<!-- 定義查詢結果的 Form 結束 -->

<script>
    document.write ("<font color=\"white\">" + document.lastModified + "</font>");
    window.attachEvent("onload", page_init);
    window.attachEvent("onload", onloadEvent);
</script>
</body>
</html>
