<%/*
----------------------------------------------------------------------------------
File Name        : sol0051_01v1
Author            : 曾國昭
Description        : SOL0051_登錄報名學生資料 - 顯示頁面
Modification Log    :

Vers        Date           By                Notes
--------------    --------------    --------------    ----------------------------------
0.0.1        096/02/27    曾國昭        Code Generate Create
----------------------------------------------------------------------------------
*/%>
<%@ page contentType="text/html; charset=UTF-8" errorPage="/utility/errorpage.jsp" pageEncoding="MS950"%>
<%@ include file="/utility/header.jsp"%>
<%@page import="java.util.Vector"%>
<%@page import="com.nou.aut.AUTGETRANGE"%>
<%
session.setAttribute("SOLT007_01_SELECT", "NOU#select CODE AS SELECT_VALUE,CODE_NAME AS SELECT_TEXT from SYST001 where KIND='STTYPE' AND CODE = '" + request.getParameter("STTYPE") +"' ORDER BY SELECT_VALUE, SELECT_TEXT");
session.setAttribute("SOLT007_02_SELECT", "NOU#select CODE AS SELECT_VALUE,CODE_NAME AS SELECT_TEXT from SYST001 where KIND='EDUBKGRD_GRADE' and CODE not in ('15','16') ORDER BY SELECT_VALUE, SELECT_TEXT");
session.setAttribute("SOLT007_03_SELECT", "NOU#select CODE AS SELECT_VALUE,CODE_NAME AS SELECT_TEXT from SYST001 where KIND='VOCATION' ORDER BY DECODE(CODE,'13','031',CODE)"); 
session.setAttribute("SOLT007_041_SELECT", "NOU#select CONCAT(a.FACULTY_CODE, a.TOTAL_CRS_NO) as SELECT_VALUE, a.TOTAL_CRS_NAME as SELECT_TEXT from syst008 a where a.ASYS = '1' and a.FACULTY_CODE != '90' and a.TOTAL_CRS_NO like '0%' ORDER BY SELECT_VALUE, SELECT_TEXT");
session.setAttribute("SOLT007_042_SELECT", "NOU#select CONCAT(a.FACULTY_CODE, a.TOTAL_CRS_NO) as SELECT_VALUE, a.TOTAL_CRS_NAME as SELECT_TEXT from syst008 a where a.ASYS = '2' and a.FACULTY_CODE != '90' and a.TOTAL_CRS_NO like '0%' ORDER BY SELECT_VALUE, SELECT_TEXT");
session.setAttribute("SOLT007_05_SELECT", "NOU#select CODE AS SELECT_VALUE,CODE_NAME AS SELECT_TEXT from SYST001 where KIND='TUTOR_CLASS_MK' ORDER BY SELECT_VALUE, SELECT_TEXT");
session.setAttribute("SOLT007_06_SELECT", "NOU#select CODE AS SELECT_VALUE,CODE_NAME AS SELECT_TEXT from SYST001 where KIND='GETINFO' ORDER BY SELECT_VALUE, SELECT_TEXT");
session.setAttribute("SOLT007_07_SELECT", "NOU#select CODE AS SELECT_VALUE,CODE_NAME AS SELECT_TEXT from SYST001 where KIND='HANDICAP_TYPE' ORDER BY SELECT_VALUE, SELECT_TEXT");
session.setAttribute("SOLT007_08_SELECT", "NOU#select CODE AS SELECT_VALUE,CODE_NAME AS SELECT_TEXT from SYST001 where KIND='HANDICAP_GRADE' ORDER BY SELECT_VALUE, SELECT_TEXT");
session.setAttribute("SOLT007_09_SELECT", "NOU#select CODE AS SELECT_VALUE,CODE_NAME AS SELECT_TEXT from SYST001 where KIND='ORIGIN_RACE' AND CODE<>'99' ORDER BY SELECT_VALUE, SELECT_TEXT");
session.setAttribute("SOLT007_10_SELECT", "NOU#select CODE AS SELECT_VALUE,CODE_NAME AS SELECT_TEXT from SYST001 where KIND='AUDIT_RESULT' ORDER BY SELECT_VALUE, SELECT_TEXT");
session.setAttribute("SOLT007_11_SELECT", "NOU#select CODE AS SELECT_VALUE,CODE_NAME AS SELECT_TEXT from SYST001 where KIND='SEX' ORDER BY SELECT_VALUE, SELECT_TEXT");
session.setAttribute("SOLT007_12_SELECT", "NOU#select CENTER_CODE AS SELECT_VALUE,CENTER_ABBRNAME AS SELECT_TEXT from SYST002 WHERE CENTER_CODE = '" + request.getParameter("CENTER_CODE") + "' ORDER BY SELECT_VALUE, SELECT_TEXT");
session.setAttribute("SOLT007_13_SELECT", "NOU#select CODE AS SELECT_VALUE,CODE_NAME AS SELECT_TEXT from SYST001 where KIND='ASYS' AND CODE = '" + request.getParameter("ASYS") + "' ORDER BY SELECT_VALUE, SELECT_TEXT");
session.setAttribute("SOLT007_14_SELECT", "NOU#select CODE AS SELECT_VALUE,CODE_NAME AS SELECT_TEXT from SYST001 where KIND='SMS' ORDER BY SELECT_VALUE, SELECT_TEXT");
session.setAttribute("SOLT007_15_SELECT", "NOU#select CODE AS SELECT_VALUE,CODE_NAME AS SELECT_TEXT from SYST001 where KIND='PAYMENT_METHOD' ORDER BY SELECT_VALUE, SELECT_TEXT");
session.setAttribute("SOLT007_16_DYNSELECT", "NOU#SELECT FACULTY_CODE||TOTAL_CRS_NO AS SELECT_VALUE , TOTAL_CRS_NAME AS SELECT_TEXT FROM SYST008 WHERE ASYS='[ASYS]' ORDER BY FACULTY_CODE||TOTAL_CRS_NO");
session.setAttribute("SOLT007_17_SELECT", "NOU#select CODE AS SELECT_VALUE,CODE_NAME AS SELECT_TEXT from SYST001 where KIND='SMS' ORDER BY SELECT_VALUE, SELECT_TEXT");
session.setAttribute("SOLT007_18_SELECT", "NOU#select CENTER_CODE AS SELECT_VALUE,CENTER_ABBRNAME AS SELECT_TEXT from SYST002 where CENTER_CODE not in ('00') ORDER BY DECODE(CENTER_CODE,'15','021',CENTER_CODE)");
session.setAttribute("SOLT007_19_SELECT", "NOU#select CENTER_CODE AS SELECT_VALUE,CENTER_ABBRNAME AS SELECT_TEXT from SYST002 where CENTER_CODE not in ('00') ORDER BY DECODE(CENTER_CODE,'15','021',CENTER_CODE)");
session.setAttribute("SOLT007_20_SELECT", "NOU#select CODE AS SELECT_VALUE,CODE_NAME AS SELECT_TEXT from SYST001 where KIND='NATIONCODE' ORDER BY SELECT_VALUE, SELECT_TEXT");
session.setAttribute("SOLT007_21_SELECT", "NOU#select CODE AS SELECT_VALUE,CODE_NAME AS SELECT_TEXT from SYST001 where KIND='SPECIAL_STTYPE_MK' ORDER BY SELECT_VALUE, SELECT_TEXT");
session.setAttribute("SOLT007_22_SELECT", "NOU#select CODE AS SELECT_VALUE,CODE_NAME AS SELECT_TEXT from SYST001 where KIND='NATIONCODE' AND CODE != '000' ORDER BY SELECT_VALUE, SELECT_TEXT");
session.setAttribute("SOLT007_23_SELECT", "NOU#select CODE AS SELECT_VALUE,CODE_NAME AS SELECT_TEXT from SYST001 where KIND='OVERSEA_REASON' ORDER BY SELECT_VALUE, SELECT_TEXT");
session.setAttribute("SOLT007_24_SELECT", "NOU#select CODE AS SELECT_VALUE,CODE_NAME AS SELECT_TEXT from SYST001 where KIND='OVERSEA_DOC' ORDER BY SELECT_VALUE, SELECT_TEXT");
session.setAttribute("SOLT007_25_SELECT", "NOU#select CODE AS SELECT_VALUE,CODE_NAME AS SELECT_TEXT from SYST001 where KIND='OVERSEA_NATION' ORDER BY SELECT_VALUE, SELECT_TEXT");
session.setAttribute("SOL004M_01_BLUR", "NOU#SELECT a.ZIP CRRSADDR_ZIP, (a.ZIP_CITY||a.ZIP_TOWN) CRRSADDR FROM SYST006 a where a.ZIP = '[CRRSADDR_ZIP]' ORDER BY a.ZIP");
session.setAttribute("SOL004M_01_WINDOW", "NOU#SELECT a.ZIP CRRSADDR_ZIP, (a.ZIP_CITY||a.ZIP_TOWN) CRRSADDR FROM SYST006 a order by a.ZIP");
session.setAttribute("SOL004M_02_BLUR", "NOU#SELECT a.ZIP DMSTADDR_ZIP, (a.ZIP_CITY||a.ZIP_TOWN) DMSTADDR FROM SYST006 a where a.ZIP = '[DMSTADDR_ZIP]' ORDER BY a.ZIP");
session.setAttribute("SOL004M_02_WINDOW", "NOU#SELECT a.ZIP DMSTADDR_ZIP, (a.ZIP_CITY||a.ZIP_TOWN) DMSTADDR FROM SYST006 a order by a.ZIP");
session.setAttribute("SOLT007_22_SELECT", "NOU#select CODE AS SELECT_VALUE,CODE_NAME AS SELECT_TEXT from SYST001 where KIND='NATIONCODE' AND CODE != '000' ORDER BY SELECT_VALUE, SELECT_TEXT");

	
	/**取得行政人員所屬中心*/
	String user_id = (String) session.getAttribute("USER_ID");
	AUTGETRANGE aut = new AUTGETRANGE();
	aut.initRangeData(user_id);
	Vector centerVt = aut.getDEP_CODE("4","3");
	String YEAR = DateUtil.getNowCYear();
	String cd="";
	if( centerVt.size()!=0)
	{
		cd += centerVt.get(0);
	}else{	
		cd="00";	//教務處(校本部)
	}
%>
<%
	java.util.Vector dataVt = com.acer.util.DBUtil.getSQLData("sol007m_.jsp", "NOU", "SELECT CODE, CODE_NAME FROM SYST001 WHERE KIND = 'GETINFO' ORDER BY CODE");
	com.acer.db.VtResultSet rs	=	new com.acer.db.VtResultSet(dataVt);
	StringBuffer s = new StringBuffer();
	while(rs.next()) {
		s.append("<input type='checkbox' id='GETINFO_"+rs.getString("CODE")+"' name='GETINFO_"+rs.getString("CODE")+"' value='"+rs.getString("CODE")+"' >"+rs.getString("CODE_NAME")+"&nbsp;&nbsp;");	
	}
	
%>
<html>
<head>
    <%@ include file="/utility/viewpageinit.jsp"%>
    <script src="<%=vr%>script/framework/query1_2_0_2.jsp"></script>
    <script src="sol0051_01c1.jsp"></script>
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
</form>
    <!-- 查詢全畫面起始
    <TABLE id="QUERY_DIV" width="96%" border="0" align="center" cellpadding="0" cellspacing="0" summary="排版用表格">
        <tr>
            <td width="13"><img src="<%=vr%>images/ap_search_01.jpg" alt="排版用圖示" width="13" height="12"></td>
            <td width="100%"><img src="<%=vr%>images/ap_search_02.jpg" alt="排版用圖示" width="100%" height="12"></td>
            <td width="13"><img src="<%=vr%>images/ap_search_03.jpg" alt="排版用圖示" width="13" height="12"></td>
        </tr>
        <tr>
            <td width="13" background="<%=vr%>images/ap_search_04.jpg" alt="排版用圖示">&nbsp;</td>
            <td width="100%" valign="top" bgcolor="#C5E2C3">
                <!-- 按鈕畫面起始
                <table width="100%" border="0" align="center" cellpadding="2" cellspacing="0" summary="排版用表格">
                    <tr class="mtbGreenBg">
                        <td align=left>【查詢畫面】</td>
                        <td align=right>
                            <div id="serach_btn">
                                <input type=button class="btn" value='檢查是否可報名' name="SOLCK" onkeypress="doSOLCK();" onclick="doSOLCK();">
                            </div>
                        </td>
                    </tr>
                </table>
                <!-- 按鈕畫面結束

                <!-- 查詢畫面起始
                <table id="table1" width="100%" border="0" align="center" cellpadding="2" cellspacing="1" summary="排版用表格">
                    <tr>
                        <td align='right'>身分證字號<font color=red>＊</font>：</td>
                        <td><input type=text name='IDNO' value=<%=request.getParameter("IDNO")%>></td>
                        <td align='right'>出生日期<font color=red>＊</font>：</td>
                        <td colspan='1'><input type=text name='BIRTHDATE' value=<%=request.getParameter("BIRTHDATE")%>><img src='/images/calendar.gif' alt='日曆圖示 'style='cursor:hand' onkeypress='Calendar.showCalendar(this, _i("QUERY", "BIRTHDATE"));'onclick='Calendar.showCalendar(this, _i("QUERY", "BIRTHDATE"));'></td>
                                                <td align='right'>學制<font color=red>＊</font>：</td>
                        <td colspan='3'>
                            <select name='ASYS'>
                            </select>
                        </td>
                    </tr>
                </table>
                <!-- 查詢畫面結束
            </td>
            <td width="13" background="<%=vr%>images/ap_search_06.jpg" alt="排版用圖示">&nbsp;</td>
        </tr>
        <tr>
            <td width="13"><img src="<%=vr%>images/ap_search_07.jpg" alt="排版用圖示" width="13" height="13"></td>
            <td width="100%"><img src="<%=vr%>images/ap_search_08.jpg" alt="排版用圖示" width="100%" height="13"></td>
            <td width="13"><img src="<%=vr%>images/ap_search_09.jpg" alt="排版用圖示" width="13" height="13"></td>
        </tr>
    </table>
    <!-- 查詢全畫面結束
</form> -->
<!-- 定義查詢的 Form 結束 -->
        <!-- 定義編輯的 Form 起始 -->
        <form id="EDIT" name="EDIT" method="post" onsubmit="doSave1();" style="margin:5,0,0,0;">
            <input type=hidden name="control_type">
            <input type=hidden name="ROWSTAMP">
            <input type=hidden name="PAYMENT_METHOD">
            <input type=hidden name="DRAFT_NO">
            <input type=hidden name="AUDIT_RESULT">
            <input type=hidden name="PAYMENT_STATUS">
            <input type=hidden name="CHECK_DOC">
            <input type=hidden name="SERNO">
			<input type=hidden name="CD" value='<%=cd%>'>
            <input type=hidden name="DOC_UNQUAL_REASON">
            <input type=hidden name="SAVE_TYPE">
            <input type=hidden name="SPECIAL_STUDENT">
            <input type=hidden name="NPAYMENT_BAR">
			<input type=hidden name='STNO'>
			<input type=hidden Column='CRRSADDR' name="CRRSADDR2">
			<input type=hidden Column='DMSTADDR' name="DMSTADDR2">
			<input type=hidden name='LIMIT' value='<%=(String)session.getAttribute("limit")%>'>
			<input type=hidden name="GETINFO_TMP" >
			
			<input type=hidden name='IDTYPE2' value=''>
			<input type=hidden name='IDTYPE3' value=''>
			<input type=hidden name='idtype' value=''>
			<input type=hidden name='RESIDENCE_BASEDATE' value=''>

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
                                        <input type=button class="btn" value='回上一頁' onclick="goBack();" name='QUERY_BTN'>
                                        <input type=button class="btn" value='清  除' onkeypress='doClear();'onclick='doClear();'>
                                        <input type=button name="SAVE_BTN" class="btn" value='存  檔' onclick="doSave1();" onkeypress="doSave1();">
                                    </div>
                                </td>
                            </tr>
                        </table>
                        <!-- 按鈕畫面結束 -->

                        <!-- 編輯畫面起始 -->
                        <table id="table2" width="100%" border="0" align="center" cellpadding="2" cellspacing="0" summary="排版用表格">
                            <tr>
                                <td align='right' class='tdgl2'>學年<font color=red>＊</font>：</td>
                                <td class='tdGrayLight'><input type=text name='AYEAR' disabled></td>
                                <td align='right' class='tdgl2'>學期<font color=red >＊</font>：</td>
                                <td class='tdGrayLight'>
                                    <select name='SMS' disabled>
                                        <option value=''>請選擇</option>
                                        <script>Form.getSelectFromPhrase("SOLT007_14_SELECT", null, null);</script>
                                </select></td>
                            </tr>
							<tr>
								<td class='tdgl1' align='right'>學制</td>
								<td class='tdGrayLight' align='left' colspan='1'>
                                <select id='ASYS' name='ASYS' disabled>
                                    <option value=''>請選擇</option>
                                    <script>Form.getSelectFromPhrase("SOLT007_13_SELECT", null, null);</script>
                                </select>
                                	身分證字號<input type=text name='IDNO' id= 'IDNO' disabled><br>
                                	護照居留證到期日：<input type=text id="RESIDENCE_DATE" name='RESIDENCE_DATE' >
                                </td>
                                <td class='tdgl1' align='right'>出生日期</td>
                                <td class='tdGrayLight'><input type=text name='BIRTHDATE' id='BIRTHDATE' disabled></td>
                            </tr>
                            <%
                            String major = (String) request.getParameter("ASYS");
                            %>
                            <tr>
                                <td align='right' class='tdgl2'>報名<%= "1".equals(major) == true ? "學習指導中心" : "教學輔導處" %><font color=red>＊</font>：</td>
                                <td class='tdGrayLight'>
                                    <select name='CENTER_CODE' disabled>
                                        <option value=''>請選擇</option>
                                        <script>Form.getSelectFromPhrase("SOLT007_12_SELECT", null, null);</script>
                                </select></td>
                                <td align='right' class='tdgl2'>報名身分別<font color=red>＊</font>：</td>
                                <td class='tdGrayLight'>
                                    <select id="STTYPE" name='STTYPE' disabled>
                                        <option value=''>請選擇</option>
                                        <script>Form.getSelectFromPhrase("SOLT007_01_SELECT", null, null);</script>
                                </select></td>
                            </tr>
                            <tr>
                                <td align='right' class='tdgl1'>姓名<font color=red>＊</font>：</td>
                                <td class='tdGrayLight'><input type=text name='NAME' disabled></td>
                                <td align='right' class='tdgl1'>法定性別<font color=red >＊</font>：</td>
                                <td class='tdGrayLight'>
                                    <select name='SEX'  disabled>
                                        <option value=''>請選擇</option>
                                        <script>Form.getSelectFromPhrase("SOLT007_11_SELECT", null, null);</script>
                                </select>
                                	自我認同性別：
                                	<select name='SELF_IDENTITY_SEX'>
                                        <option value=''>請選擇</option>
                                        <script>Form.getSelectFromPhrase("SOLT007_11_SELECT", null, null);</script>
                                	</select>
                                </td>
                            </tr>
                            <tr>
                                <td align='right' class='tdgl1'>英文姓名：</td>
                                <td class='tdGrayLight'><input type=text name='ENG_NAME' >(同護照英文名稱)</td>
                                <td align='right' class='tdgl2'>國籍別<font color=red>＊</font>：</td>
                                <td class='tdGrayLight' id ='NATIONCODE' >
									<select name='NATIONCODE' disabled>
									<!-- <option value=''>請選擇</option>  -->
									<script>Form.getSelectFromPhrase("SYST001_01_SELECT","KIND","NATIONCODE");</script>
									</select>
									新住民原國籍：
									<select name='NEWNATION'>
										<option value="">請選擇</option>
										<script>Form.getSelectFromPhrase("SOLT007_22_SELECT", null, null);</script>
									</select>
								</td>
                            </tr>
							<tr>
                                <td align='right' class='tdgl2' STYLE='display:none'>婚姻狀況：</td>
                                <td class='tdGrayLight' STYLE='display:none'><input type=radio name='MARRIAGE' value="0">已婚<input type=radio name='MARRIAGE' value="1" checked>未婚<input type=radio name='MARRIAGE' value="2">其他</td>
                                <td align='right' class='tdgl1'>入學學歷類別<font color=red>＊</font>：</td>
                                <td class='tdGrayLight' colspan='3'>
                                    <select name='EDUBKGRD_GRADE'>
                                        <option value=''>請選擇</option>
                                        <script>Form.getSelectFromPhrase("SOLT007_02_SELECT", null, null);</script>
                                </select></td>
                            </tr>
                            <tr>
                                <td align='right' class='tdgl1' rowspan="4"><font size="3">報名全修生<BR>入學學歷<br>(選修生免填)</font></td>
                                <td class='tdGrayLight' colspan="3"><font size="3">校名全銜：
                                <input id="edubkgrd1" type="text" name="edubkgrd1" size="40">
                                <!-- 
                                </td>
                                <td class='tdGrayLight' >
                                 -->
                                    <select name="edubkgrd2">
                                        <option value=""></option>
                                        <option value="畢業">畢業</option>
                                        <option value="結業">結業</option>
                                        <option value="肄業">肄業</option>
										<option value="其他">其他</option>
                                </select>
                                <font color='GREEN'>畢(修)業學年度</font><input size="3" type=text name='EDUBKGRD_AYEAR'>
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
								<td class='tdGrayLight' colspan="3">填寫範例：<br>
								1.畢業生例：台灣省立大山高級中學 畢業 <br>
								2.結業生例：台灣省立大山高級工業職業學校附設高級工業職業進修補習學校 結業 <br>
								3.肄業生例：台灣省立大山高級中學 肄業修畢二下課程可升級 <br>
								4.技術士證例：丙級技術士證五年以上、乙級技術士證二年以上 <br>
								5.考試名稱及類科例：公務人員高等考試、二級考試人事行政科 <br>
								6.大學肄業者，請持高中（職）畢業或同等學歷報名
							</td>
							</tr>
                            <tr>
                                <td align='right' class='tdgl2'>戶籍地址<font color=red>＊</font>：</td>
                                <td class='tdGrayLight' colspan="3"><input type=text id="DMSTADDR_ZIP" Column='DMSTADDR_ZIP' name='DMSTADDR_ZIP' onblur='addr_d2(this.value)' size="5" >
								<img src='/images/select.gif' name='bt1' alt='開窗選取' style='cursor:hand' onkeypress='addr_d();' onclick='addr_d();'>
								地址<input type=text id="DMSTADDR" Column='DMSTADDR' name='DMSTADDR' size="50" >
                                <br><input type="checkbox" name="same" onkeypress="doCopy();" onclick="doCopy();">如戶籍地址與通訊地址相同，請打勾</td></br>
                            </tr>
                            <tr>
                                <td align='right' class='tdgl2'>通訊地址<font color=red>＊</font>：</td>
                                <td class='tdGrayLight' colspan="3"><input type=text id="CRRSADDR_ZIP" Column='CRRSADDR_ZIP' name='CRRSADDR_ZIP' onblur='addr2(this.value)' size="5" >
								<img src='/images/select.gif' name='bt1' alt='開窗選取' style='cursor:hand' onkeypress='addr();' onclick='addr();'>
								地址<input type=text id="CRRSADDR" Column='CRRSADDR' name='CRRSADDR' size="50"  ></td>
                            </tr>
                            <tr>
                                <td align='right' class='tdgl2'>聯絡電話(公)：</td>
                                <td class='tdGrayLight'>(<input size="3" type=text name='AREACODE_OFFICE'>)<input size="8" type=text name='TEL_OFFICE'>分機：<input size="6" type=text name='TEL_OFFICE_EXT'></td>
                                <td align='right' class='tdgl1'>聯絡電話(宅)：</td>
                                <td class='tdGrayLight'>(<input size="3" type=text name='AREACODE_HOME'>)<input size="8" type=text name='TEL_HOME'></td>
                            </tr>
                            <tr>
                                <td align='right' class='tdgl1'>行動電話<font color=red>＊</font>：</td>
                                <td class='tdGrayLight'><input type=text name='MOBILE'><br>如果沒有個人手機，請填寫「0000」</td>
                                <td align='right' class='tdgl1'>個人電子信箱<font color=red>＊</font>：</td>
                                <td class='tdGrayLight'><input type=text name='EMAIL'><br>如果沒有個人電子信箱，請填寫「0@0.0」</td>
                            </tr>
							<tr>
								<td align='right' class='tdgl2'>緊急聯絡人<font color=red>＊</font>：</td>
                                <td class='tdGrayLight' ><input type=text name='EMRGNCY_NAME'></td>
								<td align='right' class='tdgl2'>緊急聯絡人電話<font color=red>＊</font>：</td>
                                <td class='tdGrayLight' ><input type=text name='EMRGNCY_TEL'></td>
							</tr>
							<tr>
								<td align='right' class='tdgl2'>緊急聯絡人關係<font color=red>＊</font>：</td>
                                <td class='tdGrayLight' colspan='1'><input type=text name='EMRGNCY_RELATION'></td>
                                <td align='right' class='tdgl1'>緊急聯絡人電子信箱<font color=red>＊</font>：</td>
                        		<td class='tdGrayLight'><input type=text name='EMRGNCY_EMAIL'></td>
							</tr>
                            
							<tr>
								<td class='tdGrayLight' colspan="3"></td>
							</tr>
							<tr>
								<td class='tdGrayLight' colspan="3"></td>
							</tr> 
                            <tr>
                                <td align='right' class='tdgl2'><%= "1".equals(major) == true ? "預定主修學系" : "預定主修學科" %>：</td>
                                <td class='tdGrayLight'>
                                    <select name='PRE_MAJOR_FACULTY'>
                                        <%
                                        
                                        if("1".equals(major)){
                                        %>
                                        	<option value="0000">尚未決定</option>
											<script>Form.getSelectFromPhrase("SOLT007_041_SELECT", null, null);</script>
                                        <%
                                        }else if("2".equals(major)){
                                        %>
                                        	<script>Form.getSelectFromPhrase("SOLT007_042_SELECT", null, null);</script>
                                        <%
                                        }
                                        %>
                                        
                                </select></td>
                                <td align='right' class='tdgl2'>導師班<font color=red>＊</font>：</td>
                                <td class='tdGrayLight' disabled >
                                    <select name='TUTOR_CLASS_MK'>
										<option value='1'>隨機編班</option>
                                        <!-- <script>Form.getSelectFromPhrase("SOLT007_05_SELECT", null, null);</script> -->
                                </select></td>
                            </tr>
                            <tr>
                                <td align='right' class='tdgl1'>職業：</td>
                                <td class='tdGrayLight' colspan='3'>
                                    <select name='VOCATION'>
                                        <option value=''>請選擇</option>
                                        <script>Form.getSelectFromPhrase("SOLT007_03_SELECT", null, null);</script>
                                	</select>
                                		服務機關(單位)全銜：<input id="VOCATION_DEPT" type="text" name="VOCATION_DEPT" size="50">
                                </td>
                            </tr>
                            <tr>
                                <td align='right' class='tdgl1'>獲得空大招生來源(可複選)<font color=red>＊</font>：</td>
                                <td class='tdGrayLight' colspan='3'>
                                	<%=s.toString() %>
                                </td>    
                            </tr>
                            <tr>
                                <td align='right' class='tdgl1'>持有身心障礙手冊者,請填類別：</td>
                                <td class='tdGrayLight'>
                                    <select name='HANDICAP_TYPE' onchange="doLock(this.value);">
                                    	<option value=''>請選擇</option>
                                        <script>Form.getSelectFromPhrase("SOLT007_07_SELECT", null, null);</script>
                                </select></td>
                                <td align='right' class='tdgl2'>身心障礙級別：</td>
                                <td colspan='1' class='tdGrayLight'>
                                    <select name='HANDICAP_GRADE'>
                                    	<option value=''>請選擇</option>
                                        <script>Form.getSelectFromPhrase("SOLT007_08_SELECT", null, null);</script>
                                </select></td>
                            </tr>
                            <tr>
                                <td align='right' class='tdgl2'>具有原住民身分者，請填族別</td>
                                <td class='tdGrayLight' colspan='1'>
                                    <select name='ORIGIN_RACE'>
										<option value=''>請選擇</option>
                                        <script>Form.getSelectFromPhrase("SOLT007_09_SELECT", null, null);</script>
                                </select>族</td>
                                <td align='right' class='tdgl1'>特殊生註記：</td>
		                        <td colspan='3' class='tdGrayLight'>
		                            <select name='SPECIAL_STTYPE_TYPE'>
										<option value="">請選擇</option>
		                                <script>Form.getSelectFromPhrase("SOLT007_21_SELECT", null, null);</script>
		                            </select></td>                                
                            </tr>                                
                            <tr>
		                        <td align='right' class='tdgl1'>新住民子女</td>
		                        <td class='tdGrayLight' colspan='3'>
									<select name='NEW_RESIDENT_CHD'>
										<option value=""   >否</option>
										<option value="2"  >是</option>
									</select>
									父親姓名<input type=text size='20' maxlength='20' name='FATHER_NAME' ">
									父親原國別	<select name='FATHER_ORIGINAL_COUNTRY'>
			                                <option value="">請選擇</option>
											<script>Form.getSelectFromPhrase("SOLT007_20_SELECT", null, null);</script>
											</select>
									母親姓名<input type=text size='20' maxlength='20' name='MOTHER_NAME'">
									母親原國別	<select name='MOTHER_ORIGINAL_COUNTRY'>
			                                <option value="">請選擇</option>
											<script>Form.getSelectFromPhrase("SOLT007_20_SELECT", null, null);</script>
											</select>
								</td>
		                    </tr>
                            <tr>
								<td align='right' class='tdgl2'>推薦人姓名<font color=red></font>：</td>
                                <td class='tdGrayLight' ><input type=text name='RECOMMEND_NAME' ></td>
								<td align='right' class='tdgl2'>推薦人學號或身份證字號<font color=red></font>：</td>
                                <td class='tdGrayLight' ><input type=text name='RECOMMEND_ID'></td>
							</tr>
							<tr>
								<td align='right' class='tdgl2' rowspan="4">海外居留生資料</td>
								<td class='tdGrayLight' colspan="3">海外地址：
								<input id="OVERSEA_ADDR" type="text" name="OVERSEA_ADDR" size="80"></td>
		                    </tr>                 
		                    <tr>
		                        <td class='tdGrayLight' colspan="3">海外居留原因：
									<select name='OVERSEA_REASON'>
										<option value="">請選擇</option>
		                                <script>Form.getSelectFromPhrase("SOLT007_23_SELECT", null, null);</script>
		                            </select>
		                            	其他原因：<input id="OVERSEA_REASON_RMK" type="text" name="OVERSEA_REASON_RMK" size="30">
								</td>
		                    </tr>
		                    <tr>
		                        <td class='tdGrayLight' colspan="3">海外居留國別：
									<select name='OVERSEA_NATION'>
										<option value="">請選擇</option>
		                                <script>Form.getSelectFromPhrase("SOLT007_25_SELECT", null, null);</script>
		                            </select>
		                            	地點(省市)或其他國別：<input id="OVERSEA_NATION_RMK" type="text" name="OVERSEA_NATION_RMK" size="30">
								</td>
		                    </tr>
		                    <tr>
		                        <td class='tdGrayLight' colspan="3">海外居留證件：
									<select name='OVERSEA_DOC'>
										<option value="">請選擇</option>
		                                <script>Form.getSelectFromPhrase("SOLT007_24_SELECT", null, null);</script>
		                            </select>
		                            	其他證件：<input id="OVERSEA_DOC_RMK" type="text" name="OVERSEA_DOC_RMK" size="30">
		                            	效期至：<input id="OVERSEA_DOC_DATE" type="text" name="OVERSEA_DOC_DATE" size="10">
								</td>
		                    </tr>
		                    <tr>
								<td align='right' class='tdgl2'>同意切結<font color=red>※</font>：</td>
								<td class='tdGrayLight' colspan='3'>
									<select name='DOC_AGREE_MK'>
										<option value="">請選擇</option>
										<option value="Y">我同意</option>
									</select>
									<font color=purple><b>本人保證以上所填各項資料及報名入學繳交之身分、學歷與相關證明文件，均與真實正本相符，確認無誤，如有虛假不實、冒用、假借、偽造、變造情事，除願負一切法律責任外，並同意依國立空中大學學生學則第8條及相關規定辦理，絕無異議。</b></font>
								</td>
							</tr>
    <!-- <tr>
        <td align='right' class='tdgl1'>原學校名稱<font color=red>＊</font>：</td>
        <td class='tdGrayLight'><input type=text name='SCHOOL_NAME_OLD'></td>
        <td align='right' class='tdgl1'>原科系<font color=red>＊</font>：</td>
        <td class='tdGrayLight'><input type=text name='FACULTY_OLD'></td>
    </tr>
    <tr>
        <td align='right' class='tdgl1'>原年級<font color=red>＊</font>：</td>
        <td class='tdGrayLight'><input type=text name='GRADE_OLD'></td>
        <td align='right' class='tdgl2'>原學號<font color=red>＊</font>：</td>
        <td class='tdGrayLight'><input type=text name='STNO_OLD'></td>
    </tr>-->
    
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

<!-- 定義查詢結果的 Form 起始 -->
<!-- 定義查詢結果的 Form 結束 -->

<!-- 標題畫面起始 -->
<table width="96%" border="0" align="center" cellpadding="4" cellspacing="0" summary="排版用表格">
    <tr>
        <td>
            <table width="500" height="27" border="0" cellpadding="0" cellspacing="0">
                <tr>
                    <td background="<%=vr%>images/ap_index_title.jpg" alt="排版用圖示">
                        　　				<span class="title">SOL005M_登錄報名學生資料</span>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
</table>
<!-- 標題畫面結束 -->

<script>
    document.write ("<font color=\"white\">" + document.lastModified + "</font>");
    window.attachEvent("onload", page_init1);
    window.attachEvent("onload", onloadEvent);
</script>
</body>
</html>