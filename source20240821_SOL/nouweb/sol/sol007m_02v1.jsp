<%/*
----------------------------------------------------------------------------------
File Name        : sol007m_02v1
Author            : 曾國昭
Description        : SOL007M_異動報名新生資料 - 編輯顯示頁面
Modification Log    :

Vers        Date           By                Notes
--------------    --------------    --------------    ----------------------------------
1.0.1        097/07/30    barry         新增特殊生註記(SPECIAL_STTYPE_TYPE)欄位
1.0.0        097/07/15    barry         QA SOL10-01
0.0.1        096/01/29    曾國昭        Code Generate Create
----------------------------------------------------------------------------------
*/%>
<%@ page contentType="text/html; charset=UTF-8" errorPage="/utility/errorpage.jsp" pageEncoding="MS950"%>
<%@ include file="/utility/header.jsp"%>
<%@page import="java.util.Vector"%>
<%@page import="com.nou.aut.AUTGETRANGE"%>
<%
session.setAttribute("SOLT005_08_SELECT", "NOU#select CONCAT(a.FACULTY_CODE, a.TOTAL_CRS_NO) as SELECT_VALUE, a.TOTAL_CRS_NAME as SELECT_TEXT from syst008 a where a.ASYS = '1' and a.FACULTY_CODE != '90' and SUBSTR(a.TOTAL_CRS_NO,1,1)='0' ORDER BY SELECT_VALUE, SELECT_TEXT");
session.setAttribute("SOLT005_09_SELECT", "NOU#select CONCAT(a.FACULTY_CODE, a.TOTAL_CRS_NO) as SELECT_VALUE, a.TOTAL_CRS_NAME as SELECT_TEXT from syst008 a where a.ASYS = '2' and a.FACULTY_CODE != '90' ORDER BY SELECT_VALUE, SELECT_TEXT");
session.setAttribute("SOLT005_031_SELECT", "NOU#select CENTER_CODE AS SELECT_VALUE,CENTER_ABBRNAME AS SELECT_TEXT from SYST002 where CENTER_CODE NOT IN ('00') ORDER BY DECODE(CENTER_CODE,'15','021',CENTER_CODE)");
session.setAttribute("SOLT005_032_SELECT", "NOU#select CENTER_CODE AS SELECT_VALUE,CENTER_ABBRNAME AS SELECT_TEXT from SYST002 where CENTER_CODE NOT IN ('00') ORDER BY DECODE(CENTER_CODE,'15','021',CENTER_CODE)");
session.setAttribute("SOLT007_13_SELECT", "NOU#SELECT CODE AS SELECT_VALUE, CODE_NAME AS SELECT_TEXT FROM SYST001 WHERE KIND='ASYS' AND CODE IN('1','2') ORDER BY CODE");
session.setAttribute("SOLT007_01_SELECT", "NOU#select CODE AS SELECT_VALUE,CODE_NAME AS SELECT_TEXT from SYST001 where KIND='STTYPE' and CODE not in ('3','4') ORDER BY SELECT_VALUE, SELECT_TEXT");
session.setAttribute("SOLT007_20_SELECT", "NOU#select CODE AS SELECT_VALUE,CODE_NAME AS SELECT_TEXT from SYST001 where KIND='SPECIAL_STTYPE_MK' ORDER BY SELECT_VALUE, SELECT_TEXT");
session.setAttribute("SOLT007_09_SELECT", "NOU#select CODE AS SELECT_VALUE,CODE_NAME AS SELECT_TEXT from SYST001 where KIND='ORIGIN_RACE' and CODE not in ('0','1','2','99') ORDER BY SELECT_VALUE, SELECT_TEXT");
session.setAttribute("SOLT007_01_1_SELECT", "NOU#select CODE AS SELECT_VALUE,CODE_NAME AS SELECT_TEXT from SYST001 where KIND='STTYPE' and CODE = '3' ORDER BY SELECT_VALUE, SELECT_TEXT");
session.setAttribute("SOLT007_02_SELECT", "NOU#select CODE AS SELECT_VALUE,CODE_NAME AS SELECT_TEXT from SYST001 where KIND='EDUBKGRD_GRADE' AND CODE NOT IN ('15','16') ORDER BY SELECT_VALUE, SELECT_TEXT");
session.setAttribute("SOLT007_03_SELECT", "NOU#select CODE AS SELECT_VALUE,CODE_NAME AS SELECT_TEXT from SYST001 where KIND='VOCATION' ORDER BY DECODE(CODE,'13','031',CODE)");
session.setAttribute("SOLT007_04_SELECT", "NOU#SELECT FACULTY_CODE||TOTAL_CRS_NO AS SELECT_VALUE , TOTAL_CRS_NAME AS SELECT_TEXT FROM SYST008 WHERE ASYS='[ASYS]' ORDER BY FACULTY_CODE||TOTAL_CRS_NO");
session.setAttribute("SOLT007_05_SELECT", "NOU#select CODE AS SELECT_VALUE,CODE_NAME AS SELECT_TEXT from SYST001 where KIND='TUTOR_CLASS_MK' ORDER BY SELECT_VALUE, SELECT_TEXT");
session.setAttribute("SOLT007_06_SELECT", "NOU#select CODE AS SELECT_VALUE,CODE_NAME AS SELECT_TEXT from SYST001 where KIND='GETINFO' ORDER BY SELECT_VALUE, SELECT_TEXT");
session.setAttribute("SOLT007_07_SELECT", "NOU#select CODE AS SELECT_VALUE,CODE_NAME AS SELECT_TEXT from SYST001 where KIND='HANDICAP_TYPE' and CODE <> '00' ORDER BY SELECT_VALUE, SELECT_TEXT");
session.setAttribute("SOLT007_08_SELECT", "NOU#select CODE AS SELECT_VALUE,CODE_NAME AS SELECT_TEXT from SYST001 where KIND='HANDICAP_GRADE' and CODE <> '00' ORDER BY SELECT_VALUE, SELECT_TEXT");
session.setAttribute("SOLT007_10_SELECT", "NOU#select CODE AS SELECT_VALUE,CODE_NAME AS SELECT_TEXT from SYST001 where KIND='AUDIT_RESULT' ORDER BY SELECT_VALUE, SELECT_TEXT");
session.setAttribute("SOLT007_11_SELECT", "NOU#select CODE AS SELECT_VALUE,CODE_NAME AS SELECT_TEXT from SYST001 where KIND='SEX' ORDER BY SELECT_VALUE, SELECT_TEXT");
session.setAttribute("SOLT007_12_SELECT", "NOU#select CENTER_CODE AS SELECT_VALUE,CENTER_NAME AS SELECT_TEXT from SYST002 ORDER BY SELECT_VALUE, SELECT_TEXT");
session.setAttribute("SOLT007_14_SELECT", "NOU#select CODE AS SELECT_VALUE,CODE_NAME AS SELECT_TEXT from SYST001 where KIND='PAYMENT_STATUS' ORDER BY SELECT_VALUE, SELECT_TEXT");
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
%>
<%
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

	// 如有其他頁面連結過來時才會有值(ex:SOLT006M_02v1會開窗過來),如直接由SOLT007直接點編時則不會有值
	String keyParamTmp = Utility.nullToSpace(request.getParameter("keyParam"));
	String[] keyParam = keyParamTmp.equals("")?new String[6]:keyParamTmp.substring(1).split("&");	
%>
<%
	java.util.Vector dataVt = com.acer.util.DBUtil.getSQLData("sol007m_.jsp", "NOU", "SELECT CODE, CODE_NAME FROM SYST001 WHERE KIND = 'GETINFO' ORDER BY CODE");
	com.acer.db.VtResultSet rs	=	new com.acer.db.VtResultSet(dataVt);
	StringBuffer s = new StringBuffer();
	while(rs.next()) {
		s.append("<input type='checkbox' id='GETINFO_"+rs.getString("CODE")+"' name='GETINFO' value='"+rs.getString("CODE")+"' >"+rs.getString("CODE_NAME")+"&nbsp;&nbsp;");	
	}
	
%>
<html>
<head>
    <%@ include file="/utility/viewpageinit.jsp"%>
    <script src="<%=vr%>script/framework/query1_2_0_2.jsp"></script>
    <script src="sol007m_02c1.jsp"></script>
    <noscript>
        <p>您的瀏覽器不支援JavaScript語法，但是並不影響您獲取本網站的內容</p>
    </noscript>
</head>
<body background="<%=vr%>images/ap_index_bg.jpg" alt="背景圖" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">

<!-- 定義編輯的 Form 起始 -->
<form name="EDIT" method="post" onsubmit="doSave();" style="margin:5,0,0,0;">
    <input type=hidden name="control_type">
    <input type=hidden name="ROWSTAMP">
    <input type=hidden name="AYEAR">
    <input type=hidden name="SMS">
    <input type=hidden name="TOTAL_RESULT">
	<input type=hidden name="NUM">
    <input type=hidden name="AUDIT_RESULT">
	<input type=hidden name="IDNO_OLD">
    <input type=hidden name="BIRTHDATE_OLD">
	<input type=hidden name="SERNO">
	<!-- 以下參數當由其他頁面開窗連結過來時才會有值 -->
	<input type=hidden name="IDNO_PARAM" value="<%=Utility.nullToSpace(keyParam[0]).equals("")?"":keyParam[0].split("=")[1]%>">
	<input type=hidden name="BIRTHDATE_PARAM" value="<%=Utility.nullToSpace(keyParam[1]).equals("")?"":keyParam[1].split("=")[1]%>">
	<input type=hidden name="ASYS_PARAM" value="<%=Utility.nullToSpace(keyParam[2]).equals("")?"":keyParam[2].split("=")[1]%>">
	<input type=hidden name="AYEAR_PARAM" value="<%=Utility.nullToSpace(keyParam[3]).equals("")?"":keyParam[3].split("=")[1]%>">
	<input type=hidden name="SMS_PARAM" value="<%=Utility.nullToSpace(keyParam[4]).equals("")?"":keyParam[4].split("=")[1]%>">
	<input type=hidden name="PRO_CODE_PARAM" value="<%=Utility.nullToSpace(keyParam[5]).equals("")?"":keyParam[5].split("=")[1]%>">
	<input type=hidden name="INIT_ENROLL_STATUS">
	<input type=hidden name="INIT_STTYPE">
	<input type=hidden name="IS_OLD">
	<input type=hidden name="MARRIAGE"><!-- 原本有該欄位,後來拿掉,在這加上隱藏欄位,變動最小 -->
	<input type=hidden name="OLD_CENTER_CODE">
	<input type=hidden name="GETINFO_TMP">
	<input type=hidden name="PRO_CODE">
	<input type=hidden name="ENROLL_STATUS">
	
	
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
                                <input type=button class="btn" value='回查詢頁' onkeypress='doBack_self();'onclick='doBack_self();' id='btnBack' name='btnBack'>
                                <input type=button class="btn" value='清  除' onkeypress='doClear();'onclick='doClear();'>
                                <input type=button class="btn" value='存  檔' onclick='doSave();' onkeypress='doSave();' id="SAVE_BTN" name='SAVE_BTN'">
                            </div>
                        </td>
                    </tr>
                </table>
                <!-- 按鈕畫面結束 -->

                <!-- 編輯畫面起始 -->
                <table id="table2" width="100%" border="0" align="center" cellpadding="2" cellspacing="0" summary="排版用表格">
                    <tr>
                        <td align='right' class='tdgl1'>學號：</td>
                        <td class='tdGrayLight'><input type=text name='STNO' readonly><!-- &nbsp;<span id='idnoType'>查無資料</span> --></td>
						<td align='right' class='tdgl2'>學制：</td>
						<td class='tdGrayLight'><select name='ASYS'>
                            <script>Form.getSelectFromPhrase("SOLT007_13_SELECT", null, null);</script>
                            </select>
						</td>
                    </tr>
					<tr>
                        <td align='right' class='tdgl1'>身分證字號<font color=red>＊</font>：</td>
						<td class='tdGrayLight'>
						<input type=text name='IDNO' size = "10" maxlength = "10" readOnly>	
						　護照居留證到期日：<input type=text name='RESIDENCE_DATE' size = "8" maxlength = "8" >			
						</td>
                        <td align='right' class='tdgl1'>出生日期<font color=red>＊</font>：</td>
                        <td class='tdGrayLight'><input type=text name='BIRTHDATE'></td>
                    </tr>
                    <tr>
                        <td align='right' class='tdgl1'><div id="centerCode">報名學習指導中心<font color='red'>＊</font>：</div></td>
                        <td class='tdGrayLight'>
							<div id="centerCodeSelect">
                            <select name='CENTER_CODE'>
                                <script>Form.getSelectFromPhrase("SOLT005_031_SELECT", null, null);</script>
                            </select>
							</div>
						</td>
                        <td align='right' class='tdgl1'>報名身份別<font color=red>＊</font>：</td>
                        <td class='tdGrayLight'>
							<div id="sttypeSelect">
                            <select id='STTYPE' name='STTYPE' onchange='docheck();'>
                                <script>Form.getSelectFromPhrase("SOLT007_01_SELECT", null, null);</script>
                            </select>
							</div>
                        </td>
                    </tr>
                    <tr>
                        <td align='right' class='tdgl2'>姓名/別名：</td>
                        <td class='tdGrayLight'><input type=text name='NAME'><input type=text name='ALIAS'></td>
                        <td align='right' class='tdgl2'>性別：</td>
                        <td class='tdGrayLight'>
                        	法定性別
                            <select name='SEX' >
                                <option value="">請選擇</option>
                                <script>Form.getSelectFromPhrase("SOLT007_11_SELECT", null, null);</script>
                            </select><br>
                                                                                   自我認同性別
                            <select name='SELF_IDENTITY_SEX' >
                                <option value="">請選擇</option>
                                <script>Form.getSelectFromPhrase("SOLT007_11_SELECT", null, null);</script>
                            </select>
                        </td>
						
                    </tr>
                    <tr>
                        <td align='right' class='tdgl1'>英文姓名：</td>
                        <td class='tdGrayLight' ><input type=text name='ENG_NAME'></td>   
                        <td align='right' class='tdgl2'>國籍：</td>
                        <td class='tdGrayLight'>
							<select name='NATIONCODE'>
                                <option value="">請選擇</option>
								<script>Form.getSelectFromPhrase("SOLT007_20_SELECT", null, null);</script>
							</select>
							　新住民原國籍：
							<select name='NEWNATION'>
								<option value="">請選擇</option>
								<script>Form.getSelectFromPhrase("SOLT007_22_SELECT", null, null);</script>
							</select> 
						</td>                     
                    </tr>
                    <tr>
						<td align='right' class='tdgl2' rowspan="3">報名全修生<BR>入 學  學 歷<br>(選修生免填)</td>
						<td class='tdGrayLight' >校名全銜：
						<input id="EDUBKGRD" type="text" name="EDUBKGRD" size="40"></td>
						<td class='tdGrayLight' colspan="2">
									<select name="EDUBKGRD1">
										<option value="">請選擇</option>
										<option value="畢業">畢業</option>
										<option value="結業">結業</option>
										<option value="肄業">肄業</option>
										<option value="其他">其他</option>
									</select>
									<font color='GREEN'>畢(修)業學年度</font><input size="3" type=text name='EDUBKGRD_AYEAR'>
						</td>
                    </tr>
                    <!--<tr>
                            <td class='tdGrayLight' colspan="2" align="center">(請填證書上之校名全銜)</td>
                            <td class='tdGrayLight'>(畢業、結業、肄業等)</td>
                    </tr>
                    -->
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
								5.考試名稱及類科例：公務人員高等考試、二級考試人事行政科  <br>
								6.大學肄業者，請持高中（職）畢業或同等學歷報名
							</td>
                    </tr>
                    <tr>                        
                        <td align='right' class='tdgl1'>入學學歷類別<font color=red>＊</font>：</td>
                        <td class='tdGrayLight'  colspan='3'>
                            <select name='EDUBKGRD_GRADE'>
                                <script>Form.getSelectFromPhrase("SOLT007_02_SELECT", null, null);</script>
                            </select>
						</td>
					</tr>
                    <tr>
                        <td align='right' class='tdgl2'>ZIP/戶籍地址：</td>
                        <td class='tdGrayLight' colspan="3"><input type=text name='DMSTADDR_ZIP' size="5"><input type=text name='DMSTADDR' size="50"></td>
                    </tr>
                    <tr>
                        <td align='right' class='tdgl1'>ZIP/通訊地址：</td>
                        <td class='tdGrayLight' colspan="3"><input type=text name='CRRSADDR_ZIP' size="5"><input type=text name='CRRSADDR' size="50"></td>
                    </tr>
                    <tr>
                        <td align='right' class='tdgl2'>聯絡電話(公)：</td>
                        <td class='tdGrayLight'>(<input size="3" type=text name='AREACODE_OFFICE'>)<input size="8" type=text name='TEL_OFFICE'>分機：<input size="6" type=text name='TEL_OFFICE_EXT'></td>
                        <td align='right' class='tdgl2'>聯絡電話(宅)：</td>
                        <td class='tdGrayLight'>(<input size="3" type=text name='AREACODE_HOME'>)<input size="8" type=text name='TEL_HOME'></td>
                    </tr>
                    <tr>
                        <td align='right' class='tdgl1'>行動電話<font color=red>＊</font>：</td>
                        <td class='tdGrayLight'><input type=text name='MOBILE'><br>如果沒有個人手機，請填寫「0000」</td>
                        <td align='right' class='tdgl1'>個人電子信箱<font color=red>＊</font>：</td>
                        <td class='tdGrayLight'><input type=text name='EMAIL'><br>如果沒有個人電子信箱，請填寫「0@0.0」</td>
                    </tr>
			        <tr>
						<td align='right' class='tdgl1' colspan='1'>職業：</td>
						<td class='tdGrayLight' colspan="3">
							<select name='VOCATION'>
                                <script>Form.getSelectFromPhrase("SOLT007_03_SELECT", null, null);</script>
                            </select>
                            	服務機關(單位)全銜：<input id="VOCATION_DEPT" type="text" name="VOCATION_DEPT" size="50"
						</td>
					</tr>
					<tr>
						<td align='right' class='tdgl2'>緊急聯絡人<font color=red>＊</font>：</td>
						<td class='tdGrayLight' ><input type=text name='EMRGNCY_NAME' onkeydown="kdnext(9);kdEMRGNCY_NAME()"></td>
						<td align='right' class='tdgl2'>緊急聯絡人電話<font color=red>＊</font>：</td>
						<td class='tdGrayLight' ><input type=text name='EMRGNCY_TEL' onkeydown="kdnext(10);kdEMRGNCY_TEL()"></td>
					</tr>
					<tr>
						<td align='right' class='tdgl1'>緊急聯絡人關係<font color=red>＊</font>：</td>
						<td class='tdGrayLight' colspan='1'><input type=text name='EMRGNCY_RELATION' onkeydown="kdnext(11);kdEMRGNCY_RELATION()"></td>
						<td align='right' class='tdgl1'>緊急聯絡人電子信箱<font color=red>＊</font>：</td>
                        <td class='tdGrayLight'><input type=text name='EMRGNCY_EMAIL'></td>
					</tr>
					<tr>
                        <td align='right' class='tdgl2'><div id="preMajorFaculty">預定主修學系<font color='red'>＊</font>：</div></td>
	                    <td class='tdGrayLight'>
							<div id="majorForSelect">
								<select name='PRE_MAJOR_FACULTY' id='PRE_MAJOR_FACULTY'>
									<option value="0000">尚未決定</option>
									<script>Form.getSelectFromPhrase("SOLT005_08_SELECT", null, null);</script>
								</select>
							</div>
	                    </td>
                        <td align='right' class='tdgl2'>導師班<font color=red>＊</font>：</td>
                        <td class='tdGrayLight'>
                            <select name='TUTOR_CLASS_MK' >
								<option value='1'>隨機編班</option>
                                 <!-- <script>Form.getSelectFromPhrase("SOLT007_05_SELECT", null, null);</script> --> 
                            </select>
						</td>
					</tr>
                        <td align='right' class='tdgl1'>獲得空大招生來源(可複選)<font color=red>＊</font>：</td>
                        <td class='tdGrayLight' colspan='3'>
							<!-- 
                            <select name='GETINFO'  onclick ="checkGETINFO();">
								<option value="">請選擇</option>
                                <script>Form.getSelectFromPhrase("SOLT007_06_SELECT", null, null);</script>
                            </select>(學號：<input type="text" name="GETINFO_NAME" >)
							(學號：<input type="text" name="GETINFO_NAME" >)
							-->
							<%=s.toString()%>
							
						</td>
                    </tr>
                    <tr>
                        <td align='right' class='tdgl2'>持有身心障礙手冊者,請填類別：</td>
                        <td class='tdGrayLight'>
                            <select name='HANDICAP_TYPE'>
								<option value="">請選擇</option>
                                <script>Form.getSelectFromPhrase("SOLT007_07_SELECT", null, null);</script>
                            </select></td>
                        <td align='right' class='tdgl2'>身心障礙級別：</td>
                        <td colspan='3' class='tdGrayLight'>
                            <select name='HANDICAP_GRADE'>
								<option value="">請選擇</option>
                                <script>Form.getSelectFromPhrase("SOLT007_08_SELECT", null, null);</script>
                            </select></td>
                    </tr>
                    <tr>
                        <td align='right' class='tdgl1'>具有原住民身分者，請填族別</td>
                        <td class='tdGrayLight'>
                            <select name='ORIGIN_RACE'>
								<option value="">請選擇</option>
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
                        <td class='tdGrayLight' ><input type=text name='RECOMMEND_NAME'></td>
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
							<select id="DOC_AGREE_MK" name='DOC_AGREE_MK'>
								<option value="">請選擇</option>
								<option value="Y">我同意</option>
							</select>
							<font color=purple><b>本人保證以上所填各項資料及報名入學繳交之身分、學歷與相關證明文件，均與真實正本相符，確認無誤，如有虛假不實、冒用、假借、偽造、變造情事，除願負一切法律責任外，並同意依國立空中大學學生學則第8條及相關規定辦理，絕無異議。</b></font>
						</td>
					</tr>                    
                    <tr class="mtbGreenBg">
                        <td align=center colspan='6'><span id='EditStatus'>跨校生資料維護</span><input type="checkbox" id="CHKSTD" name="CHKSTD" value="on" onclick='chkgogo();'></td>
                    </tr>
                    <tr>
                        <td align='right' class='tdgl1'>原學校名稱：</td>
                        <td class='tdGrayLight'>
                            <input type="text" name="SCHOOL_NAME_OLD" id="SCHOOL_NAME_OLD" size="25" maxlength='25'>
                        </td>
                        <td align='right' class='tdgl1'>原系(科)名稱：</td>
                        <td class='tdGrayLight'>
                            <input type="text" name="FACULTY_OLD" id="FACULTY_OLD" size="25" maxlength='25'>
                        </td>
                    </tr>
                    <tr>
                        <td align='right' class='tdgl1'>原年級：</td>
                        <td class='tdGrayLight'>
                            <input type="text" name="GRADE_OLD" id="GRADE_OLD" size="1" maxlength='1'>
                        </td>
                        <td align='right' class='tdgl1'>原學號：</td>
                        <td class='tdGrayLight'>
                            <input type="text" name="STNO_OLD" id="STNO_OLD" size="20" maxlength='20'>
                        </td>
                    </tr>
<!--
                    <tr class="mtbGreenBg">
                        <td align=center colspan='6'><span id='EditStatus'>審查狀態</span></td>
                    </tr>
                    <tr>
                        <td align='right' class='tdgl1'>證件正本是否符合：</td>
                        <td class='tdGrayLight'>
                            <select name='CHECK_DOC' id='CHECK_DOC'>
                                <script>//Form.getSelectFromPhrase("SOLT007_10_SELECT", null, null);</script>
                            </select>
                        </td>
                        <td align='right' class='tdgl1'>證件不符原因</td>
                        <td class='tdGrayLight'>
                            <input type="text" name="DOC_UNQUAL_REASON" id="DOC_UNQUAL_REASON" size="40">
                        </td>
                    </tr>
                    <tr>
                        <td align='right' class='tdgl1'>繳費狀態：</td>
                        <td class='tdGrayLight'>
                            <select name='PAYMENT_STATUS' id='PAYMENT_STATUS'>
                                <script>//Form.getSelectFromPhrase("SOLT007_14_SELECT", null, null);</script>
                            </select>
                        </td>
                        <td align='right' class='tdgl1'>繳費方式：</td>
                        <td class='tdGrayLight'>
                            <select name='PAYMENT_METHOD' id='PAYMENT_METHOD'>
                                <script>//Form.getSelectFromPhrase("SOLT007_15_SELECT", null, null);</script>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td align='right' class='tdgl1'>匯票號碼：</td>
                        <td class='tdGrayLight'>
                            <input type="text" name="DRAFT_NO" id="DRAFT_NO" size="11">
                        </td>
                        <td align='right' class='tdgl1'>新生審查結果：</td>
                        <td colspan='3' class='tdGrayLight'>
                            <select name='AUDIT_RESULT'>
                                <script>//Form.getSelectFromPhrase("SOLT007_10_SELECT", null, null);</script>
                            </select>
                        </td>
                    </tr>
-->
                </table>
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

<!-- 標題畫面起始 -->
<table width="96%" border="0" align="center" cellpadding="4" cellspacing="0" summary="排版用表格">
    <tr>
        <td>
            <table width="500" height="27" border="0" cellpadding="0" cellspacing="0">
                <tr>
                    <td background="<%=vr%>images/ap_index_title.jpg" alt="排版用圖示">
                        　　<span class="title">SOL007M_異動報名新生資料</span>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
</table>
<!-- 標題畫面結束 -->

<script>
    document.write ("<font color=\"white\">" + document.lastModified + "</font>");
    window.attachEvent("onload", page_init);
    window.attachEvent("onload", onloadEvent);
</script>
</body>
</html>