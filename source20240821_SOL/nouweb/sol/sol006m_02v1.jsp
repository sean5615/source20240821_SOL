<%/*
----------------------------------------------------------------------------------
File Name        : sol006m_02v1
Author            : 曾國昭
Description        : SOL006M_登錄報名審查結果 - 編輯顯示頁面
Modification Log    :

Vers        Date           By                Notes
--------------    --------------    --------------    ----------------------------------
0.0.1        096/01/25    曾國昭        Code Generate Create
----------------------------------------------------------------------------------
*/%>
<%@ page contentType="text/html; charset=UTF-8" errorPage="/utility/errorpage.jsp" pageEncoding="MS950"%>
<%@ include file="/utility/header.jsp"%>
<% 
session.setAttribute("SOLT006_01_SELECT", "NOU#select CODE AS SELECT_VALUE,CODE_NAME AS SELECT_TEXT from SYST001 where KIND='PAYMENT_MANNER' ORDER BY SELECT_VALUE, SELECT_TEXT");
session.setAttribute("SOLT006_02_SELECT", "NOU#select SYST001.CODE AS SELECT_VALUE, SYST001.CODE_NAME AS SELECT_TEXT, DECODE(B.CODE, '0', '0','1', '1','2', '5','3', '3','4', '4') AS CODE from SYST001, (SELECT CODE FROM SYST001 WHERE KIND='AUDIT_RESULT') B where KIND='AUDIT_RESULT' AND SYST001.CODE=B.CODE ORDER BY CODE");
session.setAttribute("SOLT006_02_2_SELECT", "NOU#select CODE AS SELECT_VALUE, CODE_NAME AS SELECT_TEXT from SYST001 where KIND='AUDIT_RESULT' and CODE <>'5' order by ORDER_NUM");
session.setAttribute("SOLT006_03_SELECT", "NOU#select CODE AS SELECT_VALUE,CODE_NAME AS SELECT_TEXT from SYST001 where KIND='STTYPE' ORDER BY SELECT_VALUE, SELECT_TEXT");
session.setAttribute("SOLT006_04_SELECT", "NOU#select CODE AS SELECT_VALUE,CODE_NAME AS SELECT_TEXT from SYST001 where KIND='EDUBKGRD_GRADE' ORDER BY SELECT_VALUE, SELECT_TEXT");
session.setAttribute("SOLT006_05_SELECT", "NOU#select CODE AS SELECT_VALUE,CODE_NAME AS SELECT_TEXT from SYST001 where KIND='PAYMENT_STATUS' ORDER BY SELECT_VALUE, SELECT_TEXT");
session.setAttribute("SOLT006_06_SELECT", "NOU#select CODE AS SELECT_VALUE,CODE_NAME AS SELECT_TEXT from SYST001 where KIND='REG_MANNER' ORDER BY SELECT_VALUE, SELECT_TEXT");
session.setAttribute("SOLT006_07_SELECT", "NOU#select CODE AS SELECT_VALUE,CODE_NAME AS SELECT_TEXT from SYST001 where KIND='HANDICAP_TYPE' ORDER BY SELECT_VALUE, SELECT_TEXT");
session.setAttribute("SOLT006_08_SELECT", "NOU#select CODE AS SELECT_VALUE,CODE_NAME AS SELECT_TEXT from SYST001 where KIND='HANDICAP_GRADE' ORDER BY SELECT_VALUE, SELECT_TEXT");
session.setAttribute("SOLT006_09_SELECT", "NOU#select CODE AS SELECT_VALUE,CODE_NAME AS SELECT_TEXT from SYST001 where KIND='ORIGIN_RACE' ORDER BY SELECT_VALUE, SELECT_TEXT");
session.setAttribute("SOLT007_11_SELECT", "NOU#select CODE AS SELECT_VALUE,CODE_NAME AS SELECT_TEXT from SYST001 where KIND='SEX' ORDER BY SELECT_VALUE, SELECT_TEXT");
session.setAttribute("SOLT007_22_SELECT", "NOU#select CODE AS SELECT_VALUE,CODE_NAME AS SELECT_TEXT from SYST001 where KIND='NATIONCODE' ORDER BY SELECT_VALUE, SELECT_TEXT");
%>
<html>
<head>
    <%@ include file="/utility/viewpageinit.jsp"%>
    <script src="<%=vr%>script/framework/query1_2_0_2.jsp"></script>
    <script src="sol006m_02c1.jsp"></script>
    <noscript>
        <p>您的瀏覽器不支援JavaScript語法，但是並不影響您獲取本網站的內容</p>
    </noscript>
</head>
<body background="<%=vr%>images/ap_index_bg.jpg" alt="背景圖" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">

<!-- 定義編輯的 Form 起始 -->
<form name="EDIT" method="post" onsubmit="doSave();" style="margin:5,0,0,0;">
    <input type=hidden name="control_type">
    <input type=hidden name="ROWSTAMP">
    <input type=hidden name="ASYS">
    <input type=hidden name="SMS">
    <input type=hidden name="CSMS">
    <input type=hidden name="AYEAR">
    <input type=hidden name="CENTER_CODE">
    <input type=hidden name="SEX">
    <input type=hidden name="SET">
	<input type=hidden name="REG_CHECK">
    <input type=hidden name="STTYPE">
    <input type=hidden name="EDUBKGRD_GRADE">
    <input type=hidden name="REG_MANNER">
    <input type=hidden name="CAUDIT_RESULT">
	<input type=hidden name="SPECIAL_STUDENT_TMP">
	<input type=hidden name="PRO_CODE">
	<input type=hidden name="BEFORE_NPAYMENT_BAR">
	<input type=hidden name="BEFORE_NPAYMENT_BAR">
	<input type=hidden name="BATNUM">
	
	<!-- 存檔後要帶出下一筆時所需的資訊 -->
	<input type=hidden name="NEXT_STU_DATA">  
		
	<!-- 沒用的廢欄位 -->
	<input type=hidden name="CTOTAL_RESULT">
	<input type=hidden name="PAYABLE_AMT">
	
	
	<!--<input type=hidden name="HANDICAP_TYPE">-->

    <!-- 編輯全畫面起始 -->
    <TABLE id="EDIT_DIV" width="96%" border="0" align="center" cellpadding="0" cellspacing="0" summary="排版用表格">
        <tr>
            <td width="13"><img src="<%=vr%>images/ap_index_mtb_01.gif" alt="排版用圖示" width="13" height="14"></td>
            <td width="100%"><img src="<%=vr%>images/ap_index_mtb_02.gif" alt="排版用圖示" width="100%" height="14"></td>
            <td width="13"><img src="<%=vr%>images/ap_index_mtb_03.gif" alt="排版用圖示" width="13" height="14"></td>
        </tr>
        <tr>
            <td width="13" background="<%=vr%>images/ap_index_mtb_04.gif" alt="排版用圖示">　</td>
            <td width="100%" valign="top" bgcolor="#FFFFFF">
                <!-- 按鈕畫面起始 -->
                <table width="100%" border="0" align="center" cellpadding="2" cellspacing="0" summary="排版用表格">
                    <tr class="mtbGreenBg">
                        <td align=left>【編輯畫面】- <span id='EditStatus'>新增</span></td>
                        <td align=right>
                            <div id="edit_btn">
                                <input type=button class="btn" value='回查詢頁' onkeypress='doBack();top.mainFrame.iniGrid();'onclick='doBack();top.mainFrame.iniGrid();'>
								<input type=button class="btn" value='異動學生資料' onkeypress='goSol007m02v1();'onclick='goSol007m02v1();'>
                                <input type=button class="btn" value='清  除' onkeypress='doClear();'onclick='doClear();'>
                                <input type=button name="SAVE_BTN" class="btn" value='存  檔' onkeypress='doCheckEnrollStatus();'onclick='doCheckEnrollStatus();'>
                            </div>
                        </td>
                    </tr>
                </table>
                <!-- 按鈕畫面結束 -->

                <!-- 編輯畫面起始 -->
                <table id="table2" width="100%" border="0" align="center" cellpadding="2" cellspacing="0" summary="排版用表格">
                    <tr>
                        <td align='right' class='tdgl1'>身分證字號：</td>
                        <td class='tdGrayLight'><input type=text name='IDNO'>
                      	  居留證到期日：<input type=text name='RESIDENCE_DATE' size = "8" maxlength = "8" readonly>
                        </td>
                        <td align='right' class='tdgl1'>出生日期：</td>
                        <td class='tdGrayLight'><input id="BIRTHDATE" type=text name='BIRTHDATE'></td>
                    </tr>
                    <tr>
                        <td align='right' class='tdgl2'>姓名：</td>
                        <td class='tdGrayLight'><input type=text name='NAME' readonly><!-- &nbsp;<span id='idnoType'>查無資料</span> --> </td>
                        <td align='right' class='tdgl2'>報名身分別：</td>
                        <td class='tdGrayLight'><input id="CSTTYPE" type=text name='CSTTYPE' readonly></td>
                    </tr>
                    <tr>
                    <td align='right' class='tdgl1'>年齡：</td>
                        <td class='tdGrayLight'><input type=text id="AGE" name='AGE' readonly></td>
                        <td align='right' class='tdgl1'>性別：</td>
                        <td class='tdGrayLight'>
                        	法定性別<input type=text name='CSEX' readonly>
                        <br>
                                                                                   自我認同性別
                            <select name='SELF_IDENTITY_SEX' >
                                <option value="">請選擇</option>
                                <script>Form.getSelectFromPhrase("SOLT007_11_SELECT", null, null);</script>
                            </select>	
                        </td>
                    </tr>
					<tr>
						<td align='right' class='tdgl2'>學號：</td>
                        <td class='tdGrayLight'><input type=text id="STNO" name='STNO' readonly></td>
                        <td align='right' class='tdgl2'>報名學習指導中心：</td>
                        <td class='tdGrayLight'><input type=TEXT name='CCENTER_CODE' readonly></td>
                    </tr>
                    <tr>
                        <td align='right' class='tdgl1'>入學學歷類別：</td>
                        <td class='tdGrayLight'><input id="CEDUBKGRD_GRADE" type=text name='CEDUBKGRD_GRADE' readonly> </td>
                        <td align='right' class='tdgl1'>校名全銜：</td>
                        <td class='tdGrayLight'><input type=text name='EDUBKGRD' size="40" readonly></td>
                    </tr>
					<tr>
                        <td align='right' class='tdgl2'>ZIP/戶籍地址：</td>
                        <td class='tdGrayLight'><input type=text name='DMSTADDR_ZIP' size="5" readonly><input type=text name='DMSTADDR' size="50" readonly></td>
                        <td align='right' class='tdgl2'>畢(修)業學年度：</td>
                        <td class='tdGrayLight'><input type=text name='EDUBKGRD_AYEAR' size="3" readonly></td>
                    </tr>
                    <tr>
                        <td align='right' class='tdgl1'>ZIP/通訊地址：</td>
                        <td class='tdGrayLight' colspan="1"><input type=text name='CRRSADDR_ZIP' size="5" readonly><input type=text name='CRRSADDR' size="50" readonly></td>
                    	<td align='right' class='tdgl2'>國籍：</td>
                        <td class='tdGrayLight'>
							<select name='NATIONCODE' disabled>
								<script>Form.getSelectFromPhrase("SYST001_01_SELECT","KIND","NATIONCODE");</script>
							</select>
							<br>新住民原國籍：
							<select name='NEWNATION'>
								<option value="">請選擇</option>
								<script>Form.getSelectFromPhrase("SOLT007_22_SELECT", null, null);</script>
							</select>
                        </td>
                    </tr>
                    
                    <tr>
                        <td align='right' class='tdgl2'>聯絡電話(公)：</td>
                        <td class='tdGrayLight'>(<input size="3" type=text name='AREACODE_OFFICE' readonly>)<input size="8" type=text name='TEL_OFFICE' readonly>分機：<input size="6" type=text name='TEL_OFFICE_EXT' readonly></td>
                        <td align='right' class='tdgl2'>聯絡電話(宅)：</td>
                        <td class='tdGrayLight'>(<input size="3" type=text name='AREACODE_HOME' readonly>)<input size="8" type=text name='TEL_HOME' readonly></td>
                    </tr>
                    <tr>
                        <td align='right' class='tdgl1'>行動電話：</td>
                        <td class='tdGrayLight'><input type=text name='MOBILE' readonly></td>
                        <td align='right' class='tdgl1'>電子信箱：</td>
                        <td class='tdGrayLight'><input type=text name='EMAIL' readonly></td>
                    </tr>
                    <tr>
                        <td align='right' class='tdgl2'>已繳報名費：</td>
                        <td class='tdGrayLight'><input type=text name='PAID_AMT' readonly></td>
                        <td align='right' class='tdgl2'>報名方式：</td>
                        <td class='tdGrayLight'>
                            <input type=text name='CREG_MANNER' readonly>
                        </td>
                    </tr>
					<tr>
                        <td align='right' class='tdgl1'>繳費狀態：</td>
                        <td class='tdGrayLight'>
                        <input type=HIDDEN name='PAYMENT_STATUS1' value="Y是" onclick="check();"><input type='hidden'  id="rn" name='PAYMENT_STATUS1' value="N否" onclick="check();">
                            <select id="PAYMENT_STATUS" name='PAYMENT_STATUS' onchange="check();">
                                <option value=''>選擇</option>
                                <script>Form.getSelectFromPhrase("SOLT006_05_SELECT", null, null);</script>
                            </select>
                        </td>
                        <td align='right' class='tdgl1'>繳費方式</td>
                        <td class='tdGrayLight'>
                            <select id="PAYMENT_METHOD" name='PAYMENT_METHOD' onchange="aa();">
                                <option value=''>選擇</option>
                                <script>Form.getSelectFromPhrase("SOLT006_01_SELECT", null, null);</script>
                            </select>
                        </td>
                    </tr>
					<tr>
						<td align='right' class='tdgl2'>銷帳編號：</td>
                        <td class='tdGrayLight'><input type=text name='WRITEOFF_NO' readonly></td>
                       <td align='right' class='tdgl2'>匯票號碼：</td>
                       <td class='tdGrayLight'><input type=text id="DRAFT_NO" name='DRAFT_NO'></td>
                    </tr>
					<tr>
						<td align='right' class='tdgl1'><font color=red>身心障礙類別：</font></td>
                        <td class='tdGrayLight'>
							<select id="HANDICAP_TYPE" name='HANDICAP_TYPE'>
                            <option value=''>請選擇</option>
                            <script>Form.getSelectFromPhrase("SOLT006_07_SELECT", null, null);</script>
                        </select>
						</td>
                        <td align='right' class='tdgl1'><font color=red>身心障礙級別：</font></td>
                        <td class='tdGrayLight'>
							<select id="HANDICAP_GRADE" name='HANDICAP_GRADE'>
                            <option value=''>請選擇</option>
                            <script>Form.getSelectFromPhrase("SOLT006_08_SELECT", null, null);</script>
                        </select>
						</td>
                    </tr>
					<tr>
						<td align='right' class='tdgl2'><font color=red>原住民族別：</font></td>
                        <td class='tdGrayLight' colspan='1'>
						<select id="ORIGIN_RACE" name='ORIGIN_RACE'>
                            <option value=''>請選擇</option>
                            <script>Form.getSelectFromPhrase("SOLT006_09_SELECT", null, null);</script>
                        </select>
						</td>
						<td align='right' class='tdgl2'><font color=red>新住民：</font></td>
                        <td class='tdGrayLight' colspan='1'>
						<select name='NEWNATION'>
								<option value="">請選擇</option>
								<script>Form.getSelectFromPhrase("SOLT007_22_SELECT", null, null);</script>
						</select>
						</td>
                    </tr>
                    <tr>
                        <td align='right' class='tdgl1'><font color=red>新住民子女：</font></td>
                        <td class='tdGrayLight' colspan='3'>
							<select id="NEW_RESIDENT_CHD" name='NEW_RESIDENT_CHD'>
								<option value=""   >否</option>
								<option value="2"  >是</option>
							</select>
							父親姓名<input type=text size='20' maxlength='20' name='FATHER_NAME' ">
							父親原國別	<select id="FATHER_ORIGINAL_COUNTRY" name='FATHER_ORIGINAL_COUNTRY'>
	                                <option value="">請選擇</option>
									<script>Form.getSelectFromPhrase("SOLT007_22_SELECT", null, null);</script>
									</select>
							母親姓名<input type=text size='20' maxlength='20' name='MOTHER_NAME'">
							母親原國別	<select id="MOTHER_ORIGINAL_COUNTRY" name='MOTHER_ORIGINAL_COUNTRY'>
	                                <option value="">請選擇</option>
									<script>Form.getSelectFromPhrase("SOLT007_22_SELECT", null, null);</script>
									</select>
						</td>
                    </tr>                    
                    <tr>
						<td align='right' class='tdgl2'>同意切結<font color=red></font>：</td>
						<td class='tdGrayLight' colspan='3'>
							<select id="DOC_AGREE_MK" name='DOC_AGREE_MK'>
								<option value="">請選擇</option>
								<option value="Y">我同意</option>
							</select>
							<font color=purple><b>本人保證以上所填各項資料及報名入學繳交之身分、學歷與相關證明文件，均與真實正本相符，確認無誤，如有虛假不實、冒用、假借、偽造、變造情事，除願負一切法律責任外，並同意依國立空中大學學生學則第8條及相關規定辦理，絕無異議。</b></font>
						</td>
					</tr>
                    <div>
                    <tr>
                        <td align='center' class='tdgl2' colspan="4">教務處審查</td>
                    </tr>
                    
                    <tr>
                        <td align='right' class='tdgl2'>教務處初審結果：</td>
                        <td class='tdGrayLight'>
                            <select name='TOTAL_RESULT' id='TOTAL_RESULT'>
                                <script>Form.getSelectFromPhrase("SOLT006_02_SELECT", null, null);</script>
                            </select><br><font size=2><b>確定繳交放棄雙主修文件</b></font><input type=checkbox name='TOTAL_DOC_CHECKBOX'>
                        </td>
						<td align='right' class='tdgl2'>審查不符原因：</td>
                        <td class='tdGrayLight'><input id="AUDIT_UNQUAL_REASON1" type=text name='AUDIT_UNQUAL_REASON1'>
						</td>
                    </tr>
                    </div>
                    <tr>
                        <td align='center' class='tdgl1' colspan="4">中心現場審查</td>
                    </tr>
                    <tr>
                        <td align='right' class='tdgl2' nowrap>證件正本是否符合：</td>
                        <td class='tdGrayLight'>
                            <select name='CHECK_DOC' id='CHECK_DOC'>
                                <script>Form.getSelectFromPhrase("SOLT006_02_2_SELECT", null, null);</script>
                            </select>
                        </td>
                        <td align='right' class='tdgl2'>證件不符原因：</td>
                        <td class='tdGrayLight'><input type=text id="DOC_UNQUAL_REASON" name='DOC_UNQUAL_REASON'></td>
                    </tr>
                    <tr>
                        <td align='right' class='tdgl1' nowrap>身心障礙審查結果：</td>
                        <td class='tdGrayLight'>
                        <select id="HANDICAP_AUDIT_MK" name='HANDICAP_AUDIT_MK' onChange='changeMessage();'>
                                <script>Form.getSelectFromPhrase("SOLT006_02_2_SELECT", null, null);</script>
                            </select><br><span id='HANDICAP_AUDIT_MK2'></span></td>
                        <td align='right' class='tdgl1' nowrap>身心障礙不符原因：</td>
                        <td class='tdGrayLight'><input id="HANDICAP_UNQUAL_REASON" type=text name='HANDICAP_UNQUAL_REASON'></td>
                    </tr>
                    <tr>
                        <td align='right' class='tdgl2' nowrap>低收入戶審查結果：</td>
                        <td class='tdGrayLight'>
                            <select id="LOW_INCOME_AUDIT" name='LOW_INCOME_AUDIT' onChange='changeMessage2();'>
                                <script>Form.getSelectFromPhrase("SOLT006_02_2_SELECT", null, null);</script>
                            </select><br><span id='LOW_INCOME_AUDIT2'></td>
                        <td align='right' class='tdgl2' nowrap>低收入戶不符原因：</td>
                        <td class='tdGrayLight'><input id="liur" type=text name='LOW_INCOME_UNQUAL_REASON'></td>
                    </tr>
                    <tr>
                        <td align='right' class='tdgl2' nowrap>新住民子女審查結果：</td>
                        <td class='tdGrayLight'>
                            <select id="NEW_RESIDENT_AUDIT_MK" name='NEW_RESIDENT_AUDIT_MK' onChange='changeMessage2();'>
                                <script>Form.getSelectFromPhrase("SOLT006_02_2_SELECT", null, null);</script>
                            </select><br><span id='NEW_RESIDENT_AUDIT_MK2'></td>
                        <td align='right' class='tdgl2' nowrap>新住民子女不符原因：</td>
                        <td class='tdGrayLight'><input id="liur" type=text name='NEW_RESIDENT_UNQUAL_REASON'></td>
                    </tr>
                    <tr>
                        <td align='right' class='tdgl1'>免繳費註記：</td>
                        <td class='tdGrayLight'><input type="checkbox" id="CHKPAYMENT" name="CHKPAYMENT" value="on" onclick='chkgogo();'></td>
                        <td align='right' class='tdgl1'>免繳費原因：</td>
                        <td class='tdGrayLight'><input type=text name='NPAYMENT_BAR' size='50' readonly></td>
                    </tr>
                    
                    <tr>
                        <td align='right' class='tdgl2'>中心審查結果：</td>
                        <td class='tdGrayLight'>
                            <select id="AUDIT_RESULT" name='AUDIT_RESULT'>
                                <script>Form.getSelectFromPhrase("SOLT006_02_SELECT", null, null);</script>
                            </select><br><font size=2><b>確定繳交放棄雙主修文件</b></font><input type=checkbox name='AUDIT_DOC_CHECKBOX'>
                        </td>
                        <td align='right' class='tdgl2'>審查不符原因：</td>
                        <td colspan='1' class='tdGrayLight'><input id="AUDIT_UNQUAL_REASON" type=text name='AUDIT_UNQUAL_REASON'></td>
                    </tr>
                </table>
                <!-- 編輯畫面結束 -->
            </td>
            <td width="13" background="<%=vr%>images/ap_index_mtb_06.gif" alt="排版用圖示">　</td>
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
                        　　<span class="title">SOL006M_登錄報名審查結果</span>
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