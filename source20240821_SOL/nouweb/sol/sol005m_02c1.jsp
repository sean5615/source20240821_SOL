<%/*
----------------------------------------------------------------------------------
File Name        : sol005m_01c1
Author            : 曾國昭
Description        : SOL005M_登錄報名學生資料 - 控制頁面 (javascript)
Modification Log    :

Vers        Date           By                Notes
--------------    --------------    --------------    ----------------------------------
0.0.1        096/02/27    曾國昭        Code Generate Create
----------------------------------------------------------------------------------
*/%>
<%@ page contentType="text/html; charset=UTF-8" errorPage="/utility/errorpage.jsp" pageEncoding="MS950"%>
<%@ include file="/utility/header.jsp"%>
<%@ include file="/utility/jspageinit.jsp"%>

/** 匯入 javqascript Class */
doImport ("Query.js, ErrorHandle.js, LoadingBar_0_2.js, Form.js, Ajax_0_2.js, ArrayUtil.js, ReSize.js, SortTable.js,Check.js");

/** 初始設定頁面資訊 */
var    printPage        =    "/sol/sol005m_01p1.jsp";    //列印頁面
var    editMode        =    "ADD";                //編輯模式, ADD - 新增, MOD - 修改
var    lockColumnCount        =    -1;                //鎖定欄位數
var    listShow        =    false;                //是否一進入顯示資料
var    _privateMessageTime    =    -1;                //訊息顯示時間(不自訂為 -1)
var    pageRangeSize        =    10;                //畫面一次顯示幾頁資料
var    controlPage        =    "/sol/sol005m_01c2.jsp";    //控制頁面
var    checkObj        =    new checkObj();            //核選元件
var    queryObj        =    new queryObj();            //查詢元件
var    importSelect        =    false;                //匯入選取欄位功能
var    noPermissAry        =    new Array();            //沒有權限的陣列
var SAVE_TYPEv = "0";
var checkHtml = false;
/** 網頁初始化 */
function page_init()
{
    document.getElementById("EDIT").style.display = "none";
    //page_init_start();

    loadind_    =    new LoadingBar();
    /** 權限檢核 */
    securityCheck();

    /** === 初始欄位設定 === */
    /** 初始上層帶來的 Key 資料 */
    iniMasterKeyColumn();

    /** 初始查詢欄位 */
    Form.iniFormSet('QUERY', 'IDNO', 'S',  10, 'A', 'U','FC');
    Form.iniFormSet('QUERY', 'BIRTHDATE', 'M',  8, 'S',  8, 'A', 'N1', 'DT');
    Form.iniFormSet('QUERY', 'ASYS', 'M',  1, 'A');
	Form.iniFormSet('QUERY', 'STTYPE', 'M',  2);
	Form.iniFormSet('QUERY', 'AYEAR', 'M',  3, 'S', 3, 'A', 'F', 3, 'N1');
	Form.iniFormSet('QUERY', 'SMS', 'M',  1, 'S', 1);
	Form.iniFormSet('QUERY', 'NATIONCODE', 'M',  3, 'S', 1);
	Form.iniFormSet('QUERY', 'EXP_DATE', 'M',  8, 'S',  8, 'A', 'N1', 'DT');

    /** 初始編輯欄位 */
    Form.iniFormSet('EDIT', 'IDNO', 'M',  10, 'S',  10, 'A');
    Form.iniFormSet('EDIT', 'BIRTHDATE', 'M',  8, 'S',  8, 'A', 'N1', 'DT');
    Form.iniFormSet('EDIT', 'AYEAR', 'M',  3, 'S',  3, 'A');
    Form.iniFormSet('EDIT', 'SMS', 'M',  1, 'A');
    Form.iniFormSet('EDIT', 'NAME', 'M',  10, 'A');
    Form.iniFormSet('EDIT', 'STTYPE', 'M',  2, 'A');
    Form.iniFormSet('EDIT', 'CENTER_CODE', 'M',  2, 'A');
    Form.iniFormSet('EDIT', 'PAYMENT_METHOD', 'M',  1, 'A');
    Form.iniFormSet('EDIT', 'DRAFT_NO', 'M',  11, 'A', 'D', 1);
    Form.iniFormSet('EDIT', 'AUDIT_RESULT', 'M',  1);
    Form.iniFormSet('EDIT', 'PRE_MAJOR_FACULTY', 'M',  4, 'A');
	Form.iniFormSet('EDIT', 'DMSTADDR_ZIP', 'M',  7, 'A');
	Form.iniFormSet('EDIT', 'CRRSADDR_ZIP', 'M',  7, 'A');

    loadind_.showLoadingBar (15, "初始欄位完成");
    /** ================ */

    /** === 設定檢核條件 === */
    /** 查詢欄位 */
    Form.iniFormSet('QUERY', 'IDNO', 'AA', 'chkForm', '身分證字號');
    Form.iniFormSet('QUERY', 'BIRTHDATE', 'AA', 'chkForm', '出生日期');
    Form.iniFormSet('QUERY', 'ASYS', 'AA', 'chkForm', '學制');
	Form.iniFormSet('QUERY', 'STTYPE', 'AA', 'chkForm', '報名身份別');
	Form.iniFormSet('QUERY', 'NATIONCODE', 'AA', 'chkForm', '國籍別');
	Form.iniFormSet('QUERY', 'AYEAR', 'AA', 'chkForm', '報名學年');
	Form.iniFormSet('QUERY', 'SMS', 'AA', 'chkForm', '報名學期');
	Form.iniFormSet('QUERY', 'idtype', 'AA', 'chkForm', '中華民國證件類別');

    /** 編輯欄位 */
    Form.iniFormSet('EDIT', 'IDNO', 'AA', 'chkForm', '身分證字號');
    Form.iniFormSet('EDIT', 'BIRTHDATE', 'AA', 'chkForm', '出生日期');
    Form.iniFormSet('EDIT', 'SEX', 'AA', 'chkForm', '性別');
    Form.iniFormSet('EDIT', 'AYEAR', 'AA', 'chkForm', '學年');
    Form.iniFormSet('EDIT', 'SMS', 'AA', 'chkForm', '學期');
    Form.iniFormSet('EDIT', 'NAME', 'AA', 'chkForm', '姓名');
    Form.iniFormSet('EDIT', 'STTYPE', 'AA', 'chkForm', '報名身份別');
    Form.iniFormSet('EDIT', 'CENTER_CODE', 'AA', 'chkForm', '報名指導中心');
    //Form.iniFormSet('EDIT', 'PAYMENT_METHOD', 'AA', 'chkForm', '繳費方式');
    Form.iniFormSet('EDIT', 'PAYMENT_STATUS', 'AA', 'chkForm', '繳費狀態');
	Form.iniFormSet('EDIT', 'REG_FEE', 'AA', 'chkForm', '繳費金額');
    Form.iniFormSet('EDIT', 'CHECK_DOC', 'AA', 'chkForm', '證件正本是否符合');
    Form.iniFormSet('EDIT', 'AUDIT_RESULT', 'AA', 'chkForm', '中心審查結果');
    Form.iniFormSet('EDIT', 'PRE_MAJOR_FACULTY', 'AA', 'chkForm', '預定主修');
	Form.iniFormSet('EDIT', 'EDUBKGRD_GRADE', 'AA', 'chkForm', '最高學歷類別');
	Form.iniFormSet('EDIT', 'DMSTADDR_ZIP', 'AA', 'chkForm', '戶籍郵遞區號');
    Form.iniFormSet('EDIT', 'CRRSADDR_ZIP', 'AA', 'chkForm', '通訊郵遞區號');

    loadind_.showLoadingBar (20, "設定核條件完成");
    /** ================ */
	G11.innerHTML = "<font color=red>＊</font>";
        queryObj.endProcess ("資料處理完成");
    //page_init_end();

	getNationalCode();
    /** 初始化 Form 顏色 */
    Form.iniFormColor();
	_i('EDIT','CENTER_CODE').value = _i('EDIT','CD').value;
	//_i('EDIT','EDUBKGRD_GRADE').value = "00";
	_i('QUERY','SMS').value = "<%=(String)session.getAttribute("SOL005m_nextsms")%>";
}

/**
初始化 Grid 內容
@param    stat    呼叫狀態(init -> 網頁初始化)
*/
function iniGrid(stat)
{
    var    gridObj    =    new Grid();

    iniGrid_start(gridObj)

    /** 設定表頭 */
    gridObj.heaherHTML.append
    (
        "<table id=\"RsultTable\" class='sortable' width=\"100%\" border=\"1\" cellpadding=\"2\" cellspacing=\"0\" bordercolor=\"#E6E6E6\">\
            <tr class=\"mtbGreenBg\">\
                <td width=20>&nbsp;</td>\
            </tr>"
    );

    if (stat == "init" && !listShow)
    {
        /** 初始化及不顯示資料只秀表頭 */
        document.getElementById("grid-scroll").innerHTML    =    gridObj.heaherHTML.toString().replace(/\t/g, "") + "</table>";
    }
    else
    {
        /** 處理連線取資料 */
        //var    ajaxData    =    iniGrid_middle();
        /** 頁次區間同步 */
        Form.setInput ("QUERY", "pageSize",    Form.getInput("RESULT", "_scrollSize"));
        Form.setInput ("QUERY", "pageNo",    Form.getInput("RESULT", "_goToPage"));

        /** 處理連線取資料 */
        var    callBack    =    function iniGrid.callBack(ajaxData)
        {
            if (ajaxData == null)
                return;

            /** 設定表身 */
            var    keyValue    =    "";
            var    editStr        =    "";
            var    delStr        =    "";
            var    exportBuff    =    new StringBuffer();

            for (var i = 0; i < ajaxData.data.length; i++, gridObj.rowCount++)
            {
                keyValue    =    "ASYS|" + ajaxData.data[i].ASYS + "|AYEAR|" + ajaxData.data[i].AYEAR + "|SMS|" + ajaxData.data[i].SMS + "|IDNO|" + ajaxData.data[i].IDNO + "|BIRTHDATE|" + ajaxData.data[i].BIRTHDATE;

                /** 判斷權限 */
                if (chkSecure("DEL"))
                    delStr    =    "onkeypress=\"doDelete('" + keyValue + "');\"onclick=\"doDelete('" + keyValue + "');\"><a href=\"javascript:void(0)\">刪</a>";
                else
                    delStr    =    ">刪";

                if (chkSecure("UPD"))
                    editStr    =    "onkeypress=\"doEdit('" + keyValue + "');\"onclick=\"doEdit('" + keyValue + "');\"><a href=\"javascript:void(0)\">編</a>";
                else
                    editStr    =    ">編";

                gridObj.gridHtml.append
                (
                    "<tr class=\"listColor0" + ((gridObj.rowCount % 2) + 1) + "\">\
                        <td align=center " + editStr + "</td>\
                    </tr>"
                );

                exportBuff.append
                (

                );
            }
            gridObj.gridHtml.append ("</table>");
            Form.setInput ("RESULT", "ALL_CONTENT", exportBuff.toString());

            /** 無符合資料 */
            if (ajaxData.data.length == 0)
                gridObj.gridHtml.append ("<font color=red><b>　　　查無符合資料!!</b></font>");

            iniGrid_end(ajaxData, gridObj);
        }
        sendFormData("QUERY", controlPage, "QUERY_MODE", callBack);
    }
}

/** 處理匯出動作 */
function doExport(type)
{
    var    header        =    "\r\n";

    /** 處理匯入功能 匯出種類, 標題, 一次幾筆, 程式名稱, 寬度, 高度 */
    processExport(type, header, 4, 'sol005m', 500, 200);
}

/** 查詢功能時呼叫 */
function doQuery()
{
    doQuery_start();

    /** === 自定檢查 === */
    loadind_.showLoadingBar (8, "自定檢核開始");

    /** 資料檢核及設定, 當有錯誤處理方式為 Form.errAppend(Message) 累計錯誤訊息 */
    //if (Form.getInput("QUERY", "SYS_CD") == "")
    //    Form.errAppend("系統編號不可空白!!");

    loadind_.showLoadingBar (10, "自定檢核完成");
    /** ================ */

    return doQuery_end();
}

/** 新增功能時呼叫 */
function doAdd()
{
    doAdd_start();

    /** 清除唯讀項目(KEY)*/
    Form.iniFormSet('EDIT', 'ASYS', 'R', 0);
    Form.iniFormSet('EDIT', 'AYEAR', 'R', 0);
    Form.iniFormSet('EDIT', 'SMS', 'R', 0);
//    Form.iniFormSet('EDIT', 'IDNO', 'R', 1);
//    Form.iniFormSet('EDIT', 'BIRTHDATE', 'R', 1);

    /** 初始上層帶來的 Key 資料 */
    iniMasterKeyColumn();
	_i('QUERY','IDNO').value='';
	_i('QUERY','BIRTHDATE').value='';
	_i('QUERY','NATIONCODE').value='000';
	_i('QUERY','STTYPE').value='';
	_i('QUERY','EXP_DATE').value='';
    /** 設定 Focus */
    Form.iniFormSet('EDIT', 'IDNO', 'FC');

    /** 初始化 Form 顏色 */
    Form.iniFormColor();

    /** 停止處理 */
    queryObj.endProcess ("新增狀態完成");
}

/** 修改功能時呼叫 */
function doModify()
{
    /** 設定修改模式 */
    editMode        =    "UPD";
    EditStatus.innerHTML    =    "修改";

    /** 清除唯讀項目(KEY)*/
    Form.iniFormSet('EDIT', 'ASYS', 'R', 1);
    Form.iniFormSet('EDIT', 'AYEAR', 'R', 1);
    Form.iniFormSet('EDIT', 'SMS', 'R', 1);
//    Form.iniFormSet('EDIT', 'IDNO', 'R', 1);
//    Form.iniFormSet('EDIT', 'BIRTHDATE', 'R', 1);

    /** 初始化 Form 顏色 */
    Form.iniFormColor();

    /** 設定 Focus */
    Form.iniFormSet('EDIT', 'NAME', 'FC');
}

/** 存檔功能時呼叫 */
function doSave()
{
	document.forms["EDIT"].elements["SMS"].disabled = false;
	var sttype = document.forms["EDIT"].elements["STTYPE"].value;
    var preMajor = document.forms["EDIT"].elements["PRE_MAJOR_FACULTY"].value;
    if(sttype == '' && checkHtml){
    	alert("請選擇報名身份別");
    	return;
    }else if(preMajor == '' && checkHtml){
    	alert("請選擇預定主修");
    	return;
    }
    
       
    if(Form.getInput("EDIT", "SPECIAL_STUDENT") == "5"){
    	if(Form.getInput("EDIT", "STTYPE") == "2"){
    		alert("由於您是選修生修滿40學分，報名身份別不可為「選修生」！");
    		return;
    	}
    }
	
	 if(Form.getInput("EDIT", "STTYPE") == "1"){
    	var EDU = Form.getInput("EDIT", "EDUBKGRD_GRADE");
		if(EDU < '03'){
			alert("報名空大全修生\"入學學歷類別\"必須高中以上！");
	    	return;
		}
    }
	
	if(Form.getInput("EDIT", "STTYPE") == "3"){
    	var EDU = Form.getInput("EDIT", "EDUBKGRD_GRADE");
		if(EDU < '03'){
			alert("報名空專\"入學學歷類別\"必須高中以上！");
	    	return;
		}
    }
	
	var D_NO = Form.getInput("EDIT", "DRAFT_NO");
	
	if(D_NO != ""){
    	if(D_NO.length != 11)
		{
			alert("匯票號碼必須等於11碼！");
    		return;
		}
    }
	
	var tmp_st = _i('EDIT', 'SPECIAL_STUDENT').value;
	if((_i('EDIT', 'AUDIT_RESULT').value == "0" || _i('EDIT', 'AUDIT_RESULT').value == "4") && tmp_st=="2")
	{
		if(document.EDIT.DOC_CHECKBOX.checked==false)
		{
			alert("必須繳交放棄雙主修申請表方可通過審查!!");
			return;
		}
	}
    
    doSave_start();
    

    /** 判斷新增無權限不處理 */
    if (editMode == "NONE")
        return;

    /** === 自定檢查 === */
    loadind_.showLoadingBar (8, "自定檢核開始");
	
	
    /** 資料檢核及設定, 當有錯誤處理方式為 Form.errAppend(Message) 累計錯誤訊息 */
	if (Form.getInput("EDIT", "REG_FEE") != ""){
		if(Form.getInput("EDIT", "REG_FEE") == "0")
		{
			if(Form.getInput("EDIT", "PAYMENT_METHOD") != "5")
				Form.errAppend("免繳費(繳費金額=0)，繳費方式請選現金!");
			if(Form.getInput("EDIT", "NPAYMENT_BAR") == "")
				Form.errAppend("免繳費(繳費金額=0)，請輸入免繳費原因!");
		}else{
			if(Form.getInput("EDIT", "PAYMENT_METHOD") == "")
				Form.errAppend("請輸入繳費方式!");
		}
    }
	
	if (Form.getInput("EDIT", "PAYMENT_METHOD") == "6"){
    	if(Form.getInput("EDIT", "DRAFT_NO") == ""){
    		Form.errAppend("繳費方式為匯票時，請輸入匯票號碼!!");
    	}
    }
    
    /**	   代表居留身分	**/
    if(Form.getInput("EDIT", "IDTYPE2") == "Y" ) {
    	if(Form.getInput("EDIT", "RESIDENCE_DATE") == ""){
    		Form.errAppend("居留證有效日期未填寫，請確認！");
    	} else {
    		var baseDate = Form.getInput("EDIT", "RESIDENCE_BASEDATE");
    		if(baseDate != '') {
    			if(Form.getInput("EDIT", "RESIDENCE_DATE") < baseDate) {
	    			Form.errAppend("證件到期日必需大於等於學期證件基準日！");
	    		}
    		}    		
    	}
    }
    
    /**	   代表新住民身分	**/
    if(Form.getInput("EDIT", "IDTYPE3") == "Y" ) {
    	if(Form.getInput("EDIT", "NEWNATION") == ""){
    		Form.errAppend("新住民原國別未填寫，請確認！");
    	}
    }

    loadind_.showLoadingBar (10, "自定檢核完成");
    /** ================ */

    if(doSave_end()){
    	var paymentStatus = document.forms["EDIT"].elements["PAYMENT_STATUS"].value;
    	document.forms["EDIT"].elements["SMS"].disabled = true;
    	document.getElementById("EDIT").style.display = "none";
    	if(paymentStatus == "2"){
			var status_tmp = _i('EDIT', 'NPAYMENT_BAR').value;
			if(status_tmp == "")
			{
				if(confirm("是否列印收據？")){
	    			doPrint('2');
	    		}
			}
    	}else if(!(_i('EDIT', 'NPAYMENT_BAR').value!="" || _i('EDIT', 'REG_FEE').value == "0")){
    		if(confirm("是否列印繳費單？")){
    			doPrint('1');
    		}
    	}
		/** 設定為新增模式 */
		doAdd();
    }
}

/** 存檔功能時呼叫結束 */
function doSave_end()
{
	/** 檢核設定欄位*/
	Form.startChkForm("EDIT");
	
	/** 減核錯誤處理 */
	if (!queryObj.valideMessage (Form))
	{
		document.forms["EDIT"].elements["SMS"].disabled = true;
		return;
	}

	/** = 送出表單 = */
	/** 設定狀態 */
	var	actionMode	=	"";
	if (editMode == "ADD")
		actionMode	=	"ADD_MODE";
	else
		actionMode	=	"EDIT_MODE";

	var	callBack	=	function doSave_end.callBack(ajaxData)
	{
		if (ajaxData == null)
			return false;

		/** 停止處理 */
		Message.hideProcess();

		if (editMode == "ADD"){
			Message.openSuccess("A01");			
		}else{
			Message.openSuccess("A02");			
		}	
		
		if(ajaxData.data[0].ERROR != ""){
			alert(ajaxData.data[0].ERROR);
			return false;
		}		
		
		if(ajaxData.data[0].STNO != ""){
			alert("該生學號：" + ajaxData.data[0].STNO);
		}	
		/** 重設 Grid 2006/11/16 nono add, 2007/01/07 調整判斷方式 */
		/*
		if (chkHasQuery())
		{
			iniGrid();
		}
		*/
	}
	sendFormData("EDIT", controlPage, actionMode, callBack, "1111");
	return true;
}


//非中華民國身份報名，警示訊息
function alertNationMsg()
{
	if( Form.getInput("QUERY", "NATIONCODE") !='000' ){
		//alert('一、依據空中大學設置條例第16條規定：「空中大學得招收已取得在臺　　居留許可之無戶籍國民、外國人、香港、澳門居民及大陸地區人民　　為全修生及選修生；其招生、輔導及其他相關事項之規定，由空中　　大學擬訂，國立者，報中央主管機關核定…」。　　　　　　　　二、依僑生回國就學及輔導辦法第5條第1項規定，本校不得招收僑生。三、依前述規定，本校不得招收未具中華民國國籍及未取得在臺居留許　　可之外籍人士。　　　　　　　　　　　　　　　　　　　　　　四、非本國籍人士，但已具有中華民國國籍或已取得在臺居留許可者，　　請務須勾選國別並詳填切結書。　　　　　　　　　　　　　　五、請妥慎審核學生入學相關資料，一旦發現不符資格者，將註銷其原　　學籍資料。');
		window.showModalDialog("/sol/sol005m_02v2.jsp",'window','dialogWidth=520px;dialogHeight=480px');
		return;
	}
}

//先用IDNO檢查是否重複報名
function checkIDNO()
{
	if( Form.getInput("QUERY", "IDNO") != ''){
		var idno = Form.getInput("QUERY", "IDNO");
		var idnoFirst = idno.substring(0,1);
		
		if(Form.getInput("QUERY", "idtype") == '3') {
		
			if(Form.getInput("QUERY", "radioType") == '1') {
			//type=3 但選身分證字號 在這做檢核
				if( !Check.chkIDNO(Form.getInput("QUERY", "IDNO")) &&Form.getInput("QUERY", "NATIONCODE")=='000' ){
					alert('身分證統一編號輸入錯誤，請確認！');
					Form.setInput("QUERY", "IDNO","");
					return;
				} else {
					getIdnoCheck();
				}
				
			} else {
				if(idno.length < 9) {
					alert('護照統一證號輸入錯誤，請確認！');
					Form.setInput("QUERY", "IDNO","");
					return;
				} else {
					getIdnoCheck();
				}
			}
			
		} else {
			//上面代表中華民國身分
			if( !Check.chkIDNO(Form.getInput("QUERY", "IDNO")) &&Form.getInput("QUERY", "NATIONCODE")=='000' ){
				alert('身分證統一編號輸入錯誤，請確認！');
				Form.setInput("QUERY", "IDNO","");
				return;
			} else {
				getIdnoCheck();
			}
			
			if(Form.getInput("QUERY", "NATIONCODE") != '000') {
				//下面表示非中華民國身分證號檢核
				//格式，用正則表示式比對第一個字母是否為英文字母
				
				var idno = Form.getInput("QUERY", "IDNO");
				
				if(isNaN(idno.substr(2,8)) || 
		                (!/^[A-Z]$/.test(idno.substr(0,1)))){
		            alert("居留證統一證號有誤，請確認！");
		            Form.setInput("QUERY", "IDNO","");
		            return;
		        }
				
				//進DB撈ID2的值
				var    callBack    =    function checkIDNO.callBack(ajaxData) {
					if (ajaxData == null){
						alert('ajax data = null ');
						return;
			        }
			        
			        if (ajaxData.data.length == 0){
			        	//第二碼無對應到資料庫內欄位
			        	alert('居留證統一證號錯誤，證號第二碼非系統參數設定資料！');
			        	Form.setInput("QUERY", "IDNO","");
			        	return;
			        } else {
			        	if("8" == (idno.substr(1,1)) || "9" == (idno.substr(1,1))){
			        		if( !Check.chkIDNO(Form.getInput("QUERY", "IDNO"))){
								alert('居留證統一證號有誤，請確認！');
					        	Form.setInput("QUERY", "IDNO","");
					            return;
							} else {
								alert('此為新居留證統一證號，請再次確認證號；並詢問是否為空大舊生，若是請務必更新學籍身分證號再進行新生報名！');
								alertNationMsg();
					            getIdnoCheck();
							}
			        	} else {
			        		var idHeader = "ABCDEFGHJKLMNPQRSTUVXYWZIO"; //按照轉換後權數的大小進行排序
					        //這邊把身分證字號轉換成準備要對應的
					        idno = (idHeader.indexOf(idno.substring(0,1))+10) + 
					        '' + ((idHeader.indexOf(idno.substr(1,1))+10) % 10) + '' + idno.substr(2,8);
					        //開始進行身分證數字的相乘與累加，依照順序乘上1987654321
					 
					        s = parseInt(idno.substr(0,1)) + 
					        parseInt(idno.substr(1,1)) * 9 + 
					        parseInt(idno.substr(2,1)) * 8 + 
					        parseInt(idno.substr(3,1)) * 7 +            
					        parseInt(idno.substr(4,1)) * 6 + 
					        parseInt(idno.substr(5,1)) * 5 + 
					        parseInt(idno.substr(6,1)) * 4 + 
					        parseInt(idno.substr(7,1)) * 3 + 
					        parseInt(idno.substr(8,1)) * 2 + 
					        parseInt(idno.substr(9,1));
					 
					        //檢查號碼 = 10 - 相乘後個位數相加總和之尾數。
					        checkNum = parseInt(idno.substr(10,1));
					        //模數 - 總和/模數(10)之餘數若等於第九碼的檢查碼，則驗證成功
					        ///若餘數為0，檢查碼就是0
					        if((s % 10) == 0 || (10 - s % 10) == checkNum){
					            alertNationMsg();
					            getIdnoCheck();
					        }
					        else{
					        	alert('居留證統一證號有誤，請確認！');
					        	Form.setInput("QUERY", "IDNO","");
					            return;
					        }
			        	}       			        
			        }
				}
				sendFormData("QUERY", controlPage, "IDNO_GET_SEX", callBack);
			}
		}
	}
	
	
}

function getIdnoCheck() {
	var	callBack	=	function getIdnoCheck.callBack(ajaxData)
	{
		if (ajaxData == null)
			return false;
		if(ajaxData.data[0].NUM != 0)
		{
			alert("身分證統一編號已報名，不可重複報名!!");
			_i('QUERY', 'IDNO').value = "";
			Form.iniFormSet('QUERY', 'IDNO', 'FC');
		} else {
			/* 2020/04/14 新增 除了身分證號以外其他都要拿這個值判斷居留證\護照到期日 */
			if(_i("QUERY","idtype").value != "1" ){
				getBaseDate();
			}
			
		}
	}
	sendFormData("QUERY", controlPage, "CHECK_IDNO_MODE", callBack);
}

function doDisabled(value){
	if(value == "6"){
		document.forms["EDIT"].elements["DRAFT_NO"].disabled = false;
	}else{
		document.forms["EDIT"].elements["DRAFT_NO"].value = "";
		document.forms["EDIT"].elements["DRAFT_NO"].disabled = true;
	}
	
	//設定繳費狀態
	if(value == "" || value == null){
		document.forms["EDIT"].elements["PAYMENT_STATUS"].value = "1";
	}else{
		document.forms["EDIT"].elements["PAYMENT_STATUS"].value = "2";
	}
	Form.iniFormColor();
}

/** 處理列印動作 */
function doPrint(value)
{
	doPrint_start();

	/** === 自定檢查 === */
	/* === LoadingBar === */
	/** 資料檢核及設定, 當有錯誤處理方式為 Form.errAppend(Message) 累計錯誤訊息 */
	//if (Form.getInput("QUERY", "SYS_CD") == "")
	//	Form.errAppend("系統編號不可空白!!");
	/** ================ */

	doPrint_end(value);
}

/** 處理列印動作開始 */
function doPrint_start()
{
	/** 取消 onsubmit 功能防止重複送出 */
	event.returnValue	=	false;

	/** 開啟資料處理中 */
	Message.showProcess();
}

/** 處理列印動作結束 */
function doPrint_end(value)
{
	/** 取消 onsubmit 功能防止重複送出 */
	event.returnValue	=	false;

	/** 開始處理 */
	Message.showProcess();

	/** 檢核設定欄位*/
	Form.startChkForm("QUERY");

	/** 減核錯誤處理 */
	if (!queryObj.valideMessage (Form))
		return;

	var	printWin	=	WindowUtil.openPrintWindow("", "Print");
	Form.doSubmit("QUERY", printPage + "?control_type=PRINT_MODE&status=" + value, "post", "Print");

	printWin.focus();

	/** 停止處理 */
	Message.hideProcess();
}

function doSOLCK()
{
    /** 檢核設定欄位*/
	Form.startChkForm("QUERY");
	
	/** 減核錯誤處理 */
	if (!queryObj.valideMessage (Form))
	{
		return;
	}
	//alert("1");
    if(document.getElementById("IDNO").value =="" || document.getElementById("BIRTHDATE").value =="" || document.getElementById("ASYS").value =="" || document.getElementById("STTYPE2").value =="")
    {
        alert("必要欄位要輸入");
        return;
    }
    else
    {
        Form.iniFormSet('QUERY', 'IDNO', 'AA', 'chkForm', 'IDNO');
        Form.iniFormSet('QUERY', 'BIRTHDATE', 'AA', 'chkForm', 'BIRTHDATE');
        Form.iniFormSet('QUERY', 'ASYS', 'AA', 'chkForm', 'ASYS');
    }
    //alert("2");
	
	
	var year1 = "";
	var date1 = "";
	var year2 = _i('QUERY','BIRTHDATE').value.charAt(0) + _i('QUERY','BIRTHDATE').value.charAt(1) + _i('QUERY','BIRTHDATE').value.charAt(2) + _i('QUERY','BIRTHDATE').value.charAt(3);
	var date2 = _i('QUERY','BIRTHDATE').value.charAt(4) + _i('QUERY','BIRTHDATE').value.charAt(5) + _i('QUERY','BIRTHDATE').value.charAt(6) + _i('QUERY','BIRTHDATE').value.charAt(7);
	var check = 0;
	var name = _i("EDIT","NAME").value;  // 以該身分證字號+生日 看資料庫中是否有相關資料,如有則用資料的的姓名
	var isOld = "N";
	/* 檢查該生的年齡能否報名**/
	var    callBack    =    function doSOLCK.callBack(ajaxData) {
		if(ajaxData == null || ajaxData.data.length == 0){
			alert("查無學期基準日，請先設定該學期學期基準日");
			check=1;
        	return;
        }
		year1 = StrUtil.getBStr(ajaxData.data[0].ENROLL_BASEDATE,4);
		date1 = ajaxData.data[0].ENROLL_BASEDATE.charAt(4)+ajaxData.data[0].ENROLL_BASEDATE.charAt(5)+ajaxData.data[0].ENROLL_BASEDATE.charAt(6)+ajaxData.data[0].ENROLL_BASEDATE.charAt(7);
		Form.setInput("EDIT", "NPAYMENT_BAR", "");
		Form.setInput("EDIT", "PAYMENT_METHOD", "");
		Form.setInput("EDIT", "REG_FEE", "");
		if(year1-year2 > 100){
			alert("報名學生超過年滿100歲 請確認!!");
		}
		//20140516 Maggie 改成空大全修生不限制年齡(只要有高中畢業證書即可)，比照空專
		//if(_i('QUERY', 'STTYPE').value == '1')
		//{
		//	if(year1-year2 == 20){
		//		if(date1-date2 < 0){
		//			alert("報名全修生必須年滿20歲!!");
		//			check=1;
		//		}
		//	}else if(year1-year2 < 20){
		//		alert("報名全修生必須年滿20歲!!");
		//		check=1;
		//	}
		//}
		if(_i('QUERY', 'STTYPE').value == '2')
		{
			if(year1-year2 == 18){
				if(date1-date2 < 0){
					alert("報名選修生必須年滿18歲!!");
					check=1;
				}
			}else if(year1-year2 < 18){
				alert("報名選修生必須年滿18歲!!");
				check=1;
			}
		}
		
		name = ajaxData.data[0].NAME;
		isOld = ajaxData.data[0].IS_OLD;
		//新增專科生年齡檢查，需滿16歲  20090320 by barry
		// 20100209 north 改成空專不限制年齡(只要有高中畢業證書即可)
	//	if(_i('QUERY', 'STTYPE').value == '3')
	//	{
	//		if(year1-year2 == 16){
	//			if(date1-date2 < 0){
	//				alert("報名專科生必須年滿16歲!!");
	//				check=1;
	//			}
	//		}else if(year1-year2 < 16){
	//			alert("報名專科生必須年滿16歲!!");
	//			check=1;
	//		}
	//	}
	}
	sendFormData("QUERY", controlPage, "GET_ENROLL_BASEDATE", callBack,false);
	
	if(check==1)
	{
		document.getElementById("EDIT").style.display = "none";
		return;
	}
	
	/*************************************************************** 2020/04/14 新增 ***************************************************************/
	/**	   代表不是用台灣身分證字號 所以要去檢核日期	**/
	if(_i("QUERY","idtype").value != "1" ){
		var baseDate = Form.getInput("EDIT", "RESIDENCE_BASEDATE");
   		if(baseDate != '') {
   			if(Form.getInput("QUERY", "EXP_DATE") < baseDate) {
   				if(_i("QUERY","idtype").value == "2" ){
   					alert("居留證到期日必填，資料未符合當學期居留證效期基準日！");
   				} else {
   					alert("護照到期日必填，資料未符合當學期在學基準日！");
   				}
    			
    			return;
    		} else {
    			_i("EDIT","RESIDENCE_DATE").value = Form.getInput("QUERY", "EXP_DATE");
    		}
   		} else {
   			alert('系統尚未完成設定，無法取得基準日');
   		}
	}
	
    var    callBack    =    function doSOLCK.callBack(ajaxData) {
        SAVE_TYPEv ="0";
        var specialStudent = "";
        var    msg     = "";

        if (ajaxData == null){
           SAVE_TYPEv ="-1";
        }else {
           msg=ajaxData.result.toString().split("|");
        }
        document.getElementById("checkbox_doc").innerHTML = "";
        try
        {
            if(msg[0]=="2")
            {
                var r = confirm("請問是否放棄雙主修？");
				// alert("msg[3]<br>請至學籍放棄雙主修才可報名!!");
				// SAVE_TYPEv ="-1";
                if (r==true)  {
                    /**放棄"1"*/
                    alert(msg[1]);
                    SAVE_TYPEv ="2";
                    specialStudent = "2";
					document.getElementById("checkbox_doc").innerHTML = "確定繳交放棄雙主修文件<input type=checkbox name='DOC_CHECKBOX'>";
					Form.setInput("EDIT", "NPAYMENT_BAR", "舊生");
					Form.setInput("EDIT", "REG_FEE", "0");
					Form.setInput("EDIT", "PAYMENT_METHOD", "5");
					if(Form.getInput("QUERY", "STTYPE") == "2")
					{
						alert("雙主修生只能報名全修生");
						Form.setInput("QUERY", "STTYPE", "1");
					}
					doDisabled(5);
                }
                else
                {
                    /**不放棄*/
                    alert(msg[3]);
                    SAVE_TYPEv ="-1";
                }
            }
			// msg[0]=1表示執行SOLCKBO後為可報名狀態
            else if(msg[0]=="OK"||msg[0]=="1")
            {
                //可報名，不做另何事
                alert("可報名");
            }
            else if(msg[0]=="4") //應屆畢業生"3"
            {
                    alert(msg[1]);
                    SAVE_TYPEv ="4";
                    specialStudent = "4";
					Form.setInput("EDIT", "NPAYMENT_BAR", "舊生");
					Form.setInput("EDIT", "REG_FEE", "0");
					Form.setInput("EDIT", "PAYMENT_METHOD", "5");
					doDisabled(5);
            }
            else if(msg[0]=="5")//舊選轉新全"2"
            {
                if(_i('QUERY','STTYPE').value=="2")
				{
					alert("已經是選修生，不可再報名選修生!!");
					SAVE_TYPEv ="-1";
				}else{
					alert(msg[1]);
					SAVE_TYPEv ="5";
					specialStudent = "5";
					Form.setInput("EDIT", "NPAYMENT_BAR", "舊選修生修滿40學分");
					Form.setInput("EDIT", "REG_FEE", "0");
					Form.setInput("EDIT", "PAYMENT_METHOD", "5");
					doDisabled(5);
				}
            }
            else if(msg[0]=="13")//空大畢業生
            {
                    alert(msg[1]);
                    SAVE_TYPEv ="13";
                    specialStudent = "13";
                    Form.setInput("EDIT", "NPAYMENT_BAR", "空大畢業生");
					Form.setInput("EDIT", "REG_FEE", "0");
					Form.setInput("EDIT", "PAYMENT_METHOD", "5");
					Form.setInput("EDIT","EDUBKGRD_GRADE","11");
					
					doDisabled(5);
            }
            else if(msg[0]=="14")//空專畢業生
            {
                alert(msg[1]);
                SAVE_TYPEv ="14";
                specialStudent = "14";
                Form.setInput("EDIT", "NPAYMENT_BAR", "空專畢業生");
				Form.setInput("EDIT", "REG_FEE", "0");
				Form.setInput("EDIT", "PAYMENT_METHOD", "5");
				doDisabled(5);
            }
			// 舊選修生修不滿40學分且空大畢業過
			else if(msg[0]=="6.1")
            {
				if(_i('QUERY','STTYPE').value=="2")
				{
					alert("已經是選修生，不可再報名選修生!!");
					SAVE_TYPEv ="-1";
				}else{
					alert(msg[1]);
                    SAVE_TYPEv ="6";  // 後端處理方式和舊選修生修不滿40學分一樣,只是差在不收費和顯示不收費原因
                    specialStudent = "13";
                    Form.setInput("EDIT", "NPAYMENT_BAR", "空大畢業生");
					Form.setInput("EDIT", "REG_FEE", "0");
					Form.setInput("EDIT", "PAYMENT_METHOD", "5");
					doDisabled(5);
				}
            }
			// 舊選修生修不滿40學分且空專畢業過
			else if(msg[0]=="6.2")
            {
				if(_i('QUERY','STTYPE').value=="2")
				{
					alert("已經是選修生，不可再報名選修生!!");
					SAVE_TYPEv ="-1";
				}else{
                    alert(msg[1]);
                    SAVE_TYPEv ="6";  // 後端處理方式和舊選修生修不滿40學分一樣,只是差在不收費和顯示不收費原因
                    specialStudent = "14";
                    Form.setInput("EDIT", "NPAYMENT_BAR", "空專畢業生");
					Form.setInput("EDIT", "REG_FEE", "0");
					Form.setInput("EDIT", "PAYMENT_METHOD", "5");
					doDisabled(5);
				}
            }
			// 舊選修生修不滿40學分且不曾空大空專畢業
			else if(msg[0]=="6")
            {
                if(_i('QUERY','STTYPE').value=="2")
				{
					alert("已經是選修生，不可再報名選修生!!");
					SAVE_TYPEv ="-1";
				}else{
					alert(msg[1]);
					if(confirm("選修生未滿40學分,是否有其他學歷證明？"))
					{
						SAVE_TYPEv ="6";
	                    specialStudent = "6";
						//選轉全未滿40學分，有其他學歷證明，須繳報名費  2008/08/14 by barry
						//舊選修生未修滿40學分,報新全修，免繳報名費2014/4/25 by Maggie
						Form.setInput("EDIT", "NPAYMENT_BAR", "選修生未滿40學分有其他學歷證明");
						Form.setInput("EDIT", "REG_FEE", "0");
						Form.setInput("EDIT", "PAYMENT_METHOD", "5");
						doDisabled(5);
					}
					else
					{
						SAVE_TYPEv="-1";
					}
				}
            }
			else if(msg[0]=="20")//舊全修生修滿40學分,就讀空專免繳報名費
            {
                alert(msg[1]);
                SAVE_TYPEv ="20";
                specialStudent = "20";
                Form.setInput("EDIT", "NPAYMENT_BAR", "全修生修滿40學分");
				Form.setInput("EDIT", "REG_FEE", "0");
				Form.setInput("EDIT", "PAYMENT_METHOD", "5");
				doDisabled(5);
            }          
			// 學籍中已有該資料,但所輸入的生日有誤
            else if(msg[0]=="18")
            {
				alert('請檢查輸入的身分證字號或生日是否有誤，請確認！');
				SAVE_TYPEv="-1";
			}else{
                alert(msg[1]);
                SAVE_TYPEv="-1";
            }

            if(SAVE_TYPEv != "-1"){
            	document.getElementById("EDIT").style.display = "inline";
                var idno = Form.getInput("QUERY","IDNO");
                var bh = Form.getInput("QUERY","BIRTHDATE");
                var asys = Form.getInput("QUERY","ASYS");
                var ayear = Form.getInput("QUERY","AYEAR");
        		var sms = Form.getInput("QUERY","SMS");
				var sttype = Form.getInput("QUERY","STTYPE");
        		
                Form.setInput("EDIT","IDNO",idno);
                Form.setInput("EDIT","BIRTHDATE",bh);
                Form.setInput("EDIT","ASYS",asys);
                Form.setInput("EDIT","AYEAR",ayear);
                Form.setInput("EDIT","SMS",sms);
				if(Form.getInput("EDIT","REG_FEE") == "")
					Form.setInput("EDIT","REG_FEE",msg[msg.length -1]);
                Form.setInput("EDIT","SPECIAL_STUDENT",specialStudent);
				Form.setInput("EDIT","STTYPE",sttype);
				//Form.setInput("EDIT","EDUBKGRD_GRADE","00");
				Form.setInput("EDIT","AUDIT_RESULT","");
				Form.setInput("EDIT","CHECK_DOC","");
				Form.setInput("EDIT","CENTER_CODE",Form.getInput("EDIT","CD"));
				Form.setInput("EDIT","DOC_UNQUAL_REASON","");
				Form.setInput("EDIT", "NAME", name);
				Form.setInput("EDIT","CRRSADDR_ZIP","");
				Form.setInput("EDIT","DMSTADDR_ZIP","");
				if(Form.getInput("EDIT","ASYS") == "1")
					Form.setInput("EDIT","PRE_MAJOR_FACULTY","0000");
				else
					Form.setInput("EDIT","PRE_MAJOR_FACULTY","");
				Form.setInput("EDIT","SEX",Form.getInput("EDIT","SEX"));
				//alert(Form.getInput("QUERY","NATIONCODE"));
				Form.setInput("EDIT","NATIONCODE",Form.getInput("QUERY","NATIONCODE"));
				
                Form.iniFormSet('EDIT', 'IDNO', 'R', 1);
                Form.iniFormSet('EDIT', 'BIRTHDATE', 'R', 1);
                Form.iniFormSet('EDIT', 'AYEAR', 'R', 1);
        		Form.iniFormSet('EDIT', 'SMS', 'R', 1);
				Form.iniFormSet('EDIT', 'STTYPE', 'D', 1);
				Form.iniFormSet('EDIT', 'NAME', 'R', (isOld=='Y'?'1':'0'));
				Form.iniFormSet('EDIT', 'CRRSADDR_ZIP', 'R', 0);
				
				
                Form.iniFormColor();
				//65歲以上沒有免繳報名費的規定  2008/08/14 by barry
                // if(year1-year2 == 65 && _i('EDIT', 'NPAYMENT_BAR').value==""){
					// if(date1-date2 >= 0){
						// Form.setInput("EDIT", "NPAYMENT_BAR", "超過或滿65歲");
						// Form.setInput("EDIT", "REG_FEE", "0");
						// Form.setInput("EDIT", "PAYMENT_METHOD", "5");
						// doDisabled(5);
					// }
				// }else if(year1-year2 > 65 && _i('EDIT', 'NPAYMENT_BAR').value==""){
					// Form.setInput("EDIT", "NPAYMENT_BAR", "超過或滿65歲");
					// Form.setInput("EDIT", "REG_FEE", "0");
					// Form.setInput("EDIT", "PAYMENT_METHOD", "5");
					// doDisabled(5);
				// }
                doChkOldStd();				
                if(specialStudent == "2" || specialStudent == "4" || specialStudent == "5" 
                   || specialStudent == "13" || specialStudent == "14"|| specialStudent == "20"){ 					
				   //by poto加上==20也要做這段 因為空專不能有 預定主修科別　所以前沒做
                	// doGetData();					
                }
				
				// 改成只要有舊資料就要帶出來   20100415
				doGetData();
				document.getElementById("crrzip_as_mdszip").checked = null;
				G11.innerHTML = "<font color=red>＊</font>";
            }else{
            	document.getElementById("EDIT").style.display = "none";
            }

        }catch(ex){}
    }
    sendFormData("QUERY", controlPage, "SOLCK", callBack, "1111");
	
	//只有舊選轉新全要用舊學號
	if((SAVE_TYPEv == "5" || SAVE_TYPEv == "6") && _i('EDIT','STTYPE').value == "1"&& _i('EDIT','ASYS').value == "1"){
		var    callBack    =    function doSOLCK.callBack(ajaxData) {
			if (ajaxData == null){
				alert('ajaxData = null');
				
	        }else {
				_i('EDIT','STNO').value = ajaxData.data[0].STNO;
	        }
		}
		sendFormData("QUERY", controlPage, "getStuSTNO", callBack);
	}else{
		_i('EDIT','STNO').value = "";
	}
	
	doLockInput();
	_i('EDIT','idtype').value = _i("QUERY","idtype").value;
	
	if(_i("QUERY","NATIONCODE").value != "000" ){
		_i('EDIT', 'NEWNATION').value = _i("QUERY","NATIONCODE").value;
	}
	
		
}

function doSet(SetType)
{
    if(document.getElementById("AYEAR").value =="" || document.getElementById("SMS").value =="" 
    	|| document.getElementById("IDNO").value =="" || document.getElementById("BIRTHDATE").value =="" 
    	|| document.getElementById("NAME").value =="" || document.getElementById("STTYPE").value =="" 
    	|| document.getElementById("CENTER_CODE").value =="" || document.getElementById("PAYMENT_METHOD").value ==""
    	|| document.getElementById("PAYMENT_STATUS").value =="" || document.getElementById("CHECK_DOC").value ==""
    	|| document.getElementById("AUDIT_RESULT").value =="" || document.getElementById("PRE_MAJOR_FACULTY").value ==""
    	|| document.getElementById("SEX").value =="") {
        alert("必要欄位請輸入!");
        return;
    }else if(document.getElementById("PAYMENT_METHOD").value == "6"){
		var draftNo = document.getElementById("DRAFT_NO").value; 
        if(draftNo == ""){
        	alert("匯票號碼必須輸入!");
        	return;
        }else if(draftNo.length != 11)
		{
			alert("匯票號碼必須等於11碼！");
    		return;
		}
    }
	
	var tmp_st = _i('EDIT', 'SPECIAL_STUDENT').value;
	if((_i('EDIT', 'AUDIT_RESULT').value == "0" || _i('EDIT', 'AUDIT_RESULT').value == "4") && tmp_st=="2")
	{
		if(document.EDIT.DOC_CHECKBOX.checked==false)
		{
			alert("必須繳交放棄雙主修申請表方可通過審查!!");
			return;
		}
	}
	
	
    
    document.forms["EDIT"].elements["SMS"].disabled = false;
    var ASYS = document.getElementById("ASYS").value;
    var AYEAR = document.getElementById("AYEAR").value;
    var SMS = document.getElementById("SMS").value;
    var IDNO = document.getElementById("IDNO").value;
    var BIRTHDATE = document.getElementById("BIRTHDATE").value;
    var NAME = document.getElementById("NAME").value;
    var STTYPE = document.getElementById("STTYPE").value;
    var NATIONCODE = document.getElementById("NATIONCODE").value;
    var NEWNATION = document.getElementById("NEWNATION").value;
    var CENTER_CODE = document.getElementById("CENTER_CODE").value;
    var PAYMENT_METHOD = document.getElementById("PAYMENT_METHOD").value;
    var DRAFT_NO = document.getElementById("DRAFT_NO").value;
    var AUDIT_RESULT = document.getElementById("AUDIT_RESULT").value;
    var PAYMENT_STATUS = document.getElementById("PAYMENT_STATUS").value;
    var CHECK_DOC = document.getElementById("CHECK_DOC").value;
    var PRE_MAJOR_FACULTY = document.getElementById("PRE_MAJOR_FACULTY").value;
    var SERNO = document.getElementById("SERNO").value;
    var DOC_UNQUAL_REASON = document.getElementById("DOC_UNQUAL_REASON").value;
    var SPECIAL_STUDENT = document.getElementById("SPECIAL_STUDENT").value; 
    
    var DMSTADDR = document.getElementById("DMSTADDR").value;
    var DMSTADDR_ZIP = document.getElementById("DMSTADDR_ZIP").value;
    var CRRSADDR = document.getElementById("CRRSADDR").value;
    var CRRSADDR_ZIP = document.getElementById("CRRSADDR_ZIP").value;
    var TEL_OFFICE = document.getElementById("TEL_OFFICE").value;
    var TEL_HOME = document.getElementById("TEL_HOME").value;
    var MOBILE = document.getElementById("MOBILE").value;
    var EMAIL = document.getElementById("EMAIL").value;
    var MARRIAGE = document.getElementById("MARRIAGE").value;
    var VOCATION = document.getElementById("VOCATION").value;
    var EMRGNCY_NAME = document.getElementById("EMRGNCY_NAME").value;
    var EMRGNCY_RELATION = document.getElementById("EMRGNCY_RELATION").value;
    var EMRGNCY_TEL = document.getElementById("EMRGNCY_TEL").value;
    var EDUBKGRD_GRADE = document.getElementById("EDUBKGRD_GRADE").value;
    var AREACODE_OFFICE = document.getElementById("AREACODE_OFFICE").value;
    var TEL_OFFICE_EXT = document.getElementById("TEL_OFFICE_EXT").value;
    var AREACODE_HOME = document.getElementById("AREACODE_HOME").value;
	var NPAYMENT_BAR = document.getElementById("NPAYMENT_BAR").value;
	var NATIONCODE = document.getElementById("NATIONCODE").value;
	var NEWNATION = document.getElementById("NEWNATION").value;
	var RESIDENCE_DATE = document.getElementById("RESIDENCE_DATE").value;
	var IDTYPE2 = document.getElementById("IDTYPE2").value;
	var IDTYPE3 = document.getElementById("IDTYPE3").value;
	var RESIDENCE_BASEDATE = document.getElementById("RESIDENCE_BASEDATE").value;
	var STNO = _i('EDIT','STNO').value;
	var SEX = _i('EDIT','SEX').value;
	var SPECIAL_STTYPE_TYPE = _i('EDIT','SPECIAL_STTYPE_TYPE').value;
	var idtype = _i('EDIT','idtype').value;
//    alert("ASYS=>"+ASYS);
//    alert("AYEAR=>"+AYEAR);
//    alert("SMS=>"+SMS);
//    alert("IDNO=>"+IDNO);
//    alert("BIRTHDATE=>"+BIRTHDATE);
//    alert("NAME=>"+NAME);
//    alert("STTYPE=>"+STTYPE);
//    alert("CENTER_CODE=>"+CENTER_CODE);
//    alert("PAYMENT_METHOD=>"+PAYMENT_METHOD);
//    alert("DRAFT_NO=>"+DRAFT_NO);
//    alert("AUDIT_RESULT=>"+AUDIT_RESULT);


    doEdit1("ASYS|"+ASYS
    		+"|AYEAR|"+AYEAR
    		+"|SMS|"+SMS
    		+"|IDNO|"+IDNO
    		+"|BIRTHDATE|"+BIRTHDATE
    		+"|NAME|"+NAME
    		+"|STTYPE|"+STTYPE
    		+"|CENTER_CODE|"+CENTER_CODE
    		+"|PAYMENT_METHOD|"+PAYMENT_METHOD
    		+"|DRAFT_NO|"+DRAFT_NO
    		+"|AUDIT_RESULT|"+AUDIT_RESULT
    		+"|PAYMENT_STATUS|"+PAYMENT_STATUS
    		+"|CHECK_DOC|"+CHECK_DOC
    		+"|PRE_MAJOR_FACULTY|"+PRE_MAJOR_FACULTY
    		+"|SERNO|"+SERNO
    		+"|DOC_UNQUAL_REASON|"+DOC_UNQUAL_REASON
    		+"|SPECIAL_STUDENT|"+SPECIAL_STUDENT
    		+"|NEWNATION|"+NEWNATION
    		+"|NATIONCODE|"+NATIONCODE
    		+"|RESIDENCE_DATE|"+RESIDENCE_DATE 
    		+"|DMSTADDR|"+DMSTADDR
    		+"|DMSTADDR_ZIP|"+DMSTADDR_ZIP
    		+"|CRRSADDR|"+CRRSADDR
    		+"|CRRSADDR_ZIP|"+CRRSADDR_ZIP
    		+"|TEL_OFFICE|"+TEL_OFFICE
    		+"|TEL_HOME|"+TEL_HOME
    		+"|MOBILE|"+MOBILE
    		+"|EMAIL|"+EMAIL
    		+"|MARRIAGE|"+MARRIAGE
    		+"|VOCATION|"+VOCATION
    		+"|EMRGNCY_NAME|"+EMRGNCY_NAME
    		+"|EMRGNCY_RELATION|"+EMRGNCY_RELATION
    		+"|EMRGNCY_TEL|"+EMRGNCY_TEL
    		+"|EDUBKGRD_GRADE|"+EDUBKGRD_GRADE
    		+"|AREACODE_OFFICE|"+AREACODE_OFFICE
    		+"|TEL_OFFICE_EXT|"+TEL_OFFICE_EXT
    		+"|AREACODE_HOME|"+AREACODE_HOME
			+"|STNO|"+STNO
			+"|SEX|"+SEX
			+"|SPECIAL_STTYPE_TYPE|"+SPECIAL_STTYPE_TYPE
			+"|NPAYMENT_BAR|"+NPAYMENT_BAR
			+"|IDTYPE2|"+IDTYPE2
			+"|IDTYPE3|"+IDTYPE3
			+"|RESIDENCE_BASEDATE|"+RESIDENCE_BASEDATE
			+"|idtype|"+idtype
			+"|RESIDENCE_DATE|"+RESIDENCE_DATE
    		+"|SAVE_TYPE|"+SAVE_TYPEv, "/sol/sol005"+SetType.toString()+"_.jsp");

//    top.viewFrame.location.href = '/sol/sol0051_01v1.jsp?AYEAR='+096+'&SMS='+1+'&ASYS='+1+'&STNO='+881001001;
//    top.showView();

}

function doEdit1(keyStr, pageName)
{
    var    queryKeyStr    =    "";

    if (keyStr == null)
        keyStr        =    queryKeyStr;
    else
        queryKeyStr    =    keyStr;

    var    keyAry        =    keyStr.split("|");
    var    keyUrlBuff    =    new StringBuffer();

    for (var i = 0; i < keyAry.length; i += 2)
    {
        if (i == 0)
            keyUrlBuff.append ("?" + keyAry[i] + "=" + StrUtil.urlEncode(keyAry[i + 1]));
        else
            keyUrlBuff.append ("&" + keyAry[i] + "=" + StrUtil.urlEncode(keyAry[i + 1]));
    }

    if (pageName == null)
        pageName    =    detailPage;
    var    openUrl    =    "";
    //alert(pageName);
    if (keyStr == '' && queryKeyStr == '')
        openUrl    =    _vp +"mainframe_open.jsp?mainPage=" + StrUtil.urlEncode(pageName);
    else
        openUrl    =    _vp +"mainframe_open.jsp?mainPage=" + StrUtil.urlEncode(pageName) + "&keyParam=" + StrUtil.urlEncode(keyUrlBuff.toString());

    top.pageFrame.all("detailFrame").src = openUrl;
        top.showDetail();
}

function doChkOldStd()
{
    var    callBack    =    function doChkOldStd.callBack(ajaxData2)
    {
        if(ajaxData2.result=="Y")
        {
         	document.getElementById("old").innerHTML = "<font color='red'>該學生為舊生</font>";
        }else{
        	document.getElementById("old").innerHTML = "";
        }
    }
    sendFormData("QUERY", controlPage, "CHKOLDSTD",callBack);
}

function doGetData()
{
    var    callBack    =    function doGetData.callBack(ajaxData3)
    {				
        if(ajaxData3 == null||ajaxData3.data.length==0){
        	return;
        }		
        Form.setInput("EDIT", "NAME", ajaxData3.data[0].NAME);
        Form.setInput("EDIT", "DMSTADDR", ajaxData3.data[0].DMSTADDR);
        Form.setInput("EDIT", "DMSTADDR_ZIP", ajaxData3.data[0].DMSTADDR_ZIP);
        Form.setInput("EDIT", "CRRSADDR", ajaxData3.data[0].CRRSADDR);
        Form.setInput("EDIT", "CRRSADDR_ZIP", ajaxData3.data[0].CRRSADDR_ZIP);
        Form.setInput("EDIT", "TEL_OFFICE", ajaxData3.data[0].TEL_OFFICE);
        Form.setInput("EDIT", "TEL_HOME", ajaxData3.data[0].TEL_HOME);
        Form.setInput("EDIT", "MOBILE", ajaxData3.data[0].MOBILE);
        Form.setInput("EDIT", "EMAIL", ajaxData3.data[0].EMAIL);
        Form.setInput("EDIT", "MARRIAGE", ajaxData3.data[0].MARRIAGE);
        Form.setInput("EDIT", "VOCATION", ajaxData3.data[0].VOCATION);
        Form.setInput("EDIT", "EMRGNCY_NAME", ajaxData3.data[0].EMRGNCY_NAME);
        Form.setInput("EDIT", "EMRGNCY_RELATION", ajaxData3.data[0].EMRGNCY_RELATION);
        Form.setInput("EDIT", "EMRGNCY_TEL", ajaxData3.data[0].EMRGNCY_TEL);
        //Form.setInput("EDIT", "EDUBKGRD_GRADE", ajaxData3.data[0].EDUBKGRD_GRADE);
        Form.setInput("EDIT", "AREACODE_OFFICE", ajaxData3.data[0].AREACODE_OFFICE);
        Form.setInput("EDIT", "TEL_OFFICE_EXT", ajaxData3.data[0].TEL_OFFICE_EXT);
        Form.setInput("EDIT", "AREACODE_HOME", ajaxData3.data[0].AREACODE_HOME);
    }
    sendFormData("QUERY", controlPage, "GETDATA",callBack);
}

function doAsMdszip()
{
    var checkbox = document.getElementById("crrzip_as_mdszip");
	
	if(checkbox.checked){
		G11.innerHTML = "";
		Form.setInput("EDIT", "CRRSADDR_ZIP", Form.getInput("EDIT","DMSTADDR_ZIP"));
		Form.iniFormSet('EDIT', 'CRRSADDR_ZIP', 'R', 1);
	}
	else{
		G11.innerHTML = "<font color=red>＊</font>";
		Form.setInput("EDIT", "CRRSADDR_ZIP", "");
		Form.iniFormSet('EDIT', 'CRRSADDR_ZIP', 'R', 0);
	}
	Form.iniFormColor();
}

/** ============================= 欲修正程式放置區 ======================================= */
/** 設定功能權限 */
function securityCheck()
{
    try
    {
        /** 查詢 */
        if (!<%=AUTICFM.securityCheck (session, "QRY")%>)
        {
            noPermissAry[noPermissAry.length]    =    "QRY";
            try{Form.iniFormSet("QUERY", "QUERY_BTN", "D", 1);}catch(ex){}
        }
        /** 新增 */
        if (!<%=AUTICFM.securityCheck (session, "ADD")%>)
        {
            noPermissAry[noPermissAry.length]    =    "ADD";
            editMode    =    "NONE";
            try{Form.iniFormSet("EDIT", "ADD_BTN", "D", 1);}catch(ex){}
        }
        /** 修改 */
        if (!<%=AUTICFM.securityCheck (session, "UPD")%>)
        {
            noPermissAry[noPermissAry.length]    =    "UPD";
        }
        /** 新增及修改 */
        if (!chkSecure("ADD") && !chkSecure("UPD"))
        {
            try{Form.iniFormSet("EDIT", "SAVE_BTN", "D", 1);}catch(ex){}
        }
        /** 刪除 */
        if (!<%=AUTICFM.securityCheck (session, "DEL")%>)
        {
            noPermissAry[noPermissAry.length]    =    "DEL";
            try{Form.iniFormSet("RESULT", "DEL_BTN", "D", 1);}catch(ex){}
        }
        /** 匯出 */
        if (!<%=AUTICFM.securityCheck (session, "EXP")%>)
        {
            noPermissAry[noPermissAry.length]    =    "EXP";
            try{Form.iniFormSet("RESULT", "EXPORT_BTN", "D", 1);}catch(ex){}
            try{Form.iniFormSet("QUERY", "EXPORT_ALL_BTN", "D", 1);}catch(ex){}
        }
        /** 列印 */
        if (!<%=AUTICFM.securityCheck (session, "PRT")%>)
        {
            noPermissAry[noPermissAry.length]    =    "PRT";
            try{Form.iniFormSet("RESULT", "PRT_BTN", "D", 1);}catch(ex){}
            try{Form.iniFormSet("QUERY", "PRT_ALL_BTN", "D", 1);}catch(ex){}
        }
    }
    catch (ex)
    {
    }
}

function doPreMajor(){
	checkHtml = true;
	var asys = Form.getInput("QUERY","ASYS");
	Form.setInput("EDIT","ASYS",asys);
	if(asys == '1'){
		document.getElementById("centerCode").innerHTML = "報名學習指導中心<font color='red'>＊</font>：";
		document.getElementById("preMajorFaculty").innerHTML = "預定主修學系<font color='red'>＊</font>：";
		document.getElementById("majorForSelect").innerHTML = "<select name='PRE_MAJOR_FACULTY' id='PRE_MAJOR_FACULTY'><option value='0000'>尚未決定</option>"+Form.getSelectFromPhrase("SOLT005_08_SELECT", null, null, false)+"</select>";
		document.getElementById("sol005_sttype").innerHTML = "<select name='STTYPE' id='STTYPE' onchange='hidden();'><option value=''>請選擇</option>"+Form.getSelectFromPhrase("SOLT005_02_SELECT", null, null, false)+"</select>";
		document.getElementById("sol005_sttype2").innerHTML = "<select name='STTYPE' id='STTYPE2' onchange='hidden();'><option value=''>請選擇</option>"+Form.getSelectFromPhrase("SOLT005_02_SELECT", null, null, false)+"</select>";
		document.getElementById("centerCodeSelect").innerHTML = "<select name='CENTER_CODE' id='CENTER_CODE'><option value=''>請選擇</option>"+Form.getSelectFromPhrase("SOLT005_031_SELECT", null, null, false)+"</select>";
		_i('EDIT', 'CENTER_CODE').removeAttribute("chkForm");
		Form.iniFormSet('EDIT', 'CENTER_CODE', 'AA', 'chkForm', '預定主修學系');
		_i('EDIT','CENTER_CODE').value = _i('EDIT','CD').value;
	}else if(asys == '2'){
		document.getElementById("centerCode").innerHTML = "報名教學輔導處<font color='red'>＊</font>：";
		document.getElementById("preMajorFaculty").innerHTML = "預定主修科別<font color=red>＊</font>：";
		document.getElementById("majorForSelect").innerHTML = "<select name='PRE_MAJOR_FACULTY' id='PRE_MAJOR_FACULTY'><option value=''>請選擇</option>"+Form.getSelectFromPhrase("SOLT005_09_SELECT", null, null, false)+"</select>";
		document.getElementById("sol005_sttype").innerHTML = "<select name='STTYPE' id='STTYPE' onchange='hidden();'><option value=''>請選擇</option>"+Form.getSelectFromPhrase("SOLT005_10_SELECT", null, null, false)+"</select>";
		document.getElementById("sol005_sttype2").innerHTML = "<select name='STTYPE' id='STTYPE2' onchange='hidden();'><option value=''>請選擇</option>"+Form.getSelectFromPhrase("SOLT005_10_SELECT", null, null, false)+"</select>";
		document.getElementById("centerCodeSelect").innerHTML = "<select name='CENTER_CODE' id='CENTER_CODE'><option value=''>請選擇</option>"+Form.getSelectFromPhrase("SOLT005_032_SELECT", null, null, false)+"</select>";
		_i('EDIT', 'CENTER_CODE').removeAttribute("chkForm");
		Form.iniFormSet('EDIT', 'CENTER_CODE', 'AA', 'chkForm', '預定主修科別');
		_i('EDIT','CENTER_CODE').value = _i('EDIT','CD').value;
	}
	Form.setInput("EDIT", "NPAYMENT_BAR", "");
	Form.setInput("EDIT", "REG_FEE", "");
	Form.setInput("EDIT", "PAYMENT_METHOD", "");
	document.getElementById("EDIT").style.display = "none";
}

/**隱藏編輯區*/
function hidden()
{
	Form.setInput("EDIT", "NPAYMENT_BAR", "");
	Form.setInput("EDIT", "REG_FEE", "");
	Form.setInput("EDIT", "PAYMENT_METHOD", "");
	document.getElementById("EDIT").style.display = "none";
}

function getNationalCode(){

	if(_i("QUERY","idtype").value == "1" ){
		document.getElementById("radioBoxArea").innerHTML = "";
		document.getElementById("radioBoxArea").style.display="none";
		
		document.getElementById("type_exp").innerHTML= "身分證統一編號";
		Form.getDynSelectFromPhrase(_i("QUERY","NATIONCODE"), "SOLT005_13_SELECT", false ,"","");
		document.getElementById("expDateSpan").style.display="none";
		document.getElementById("expDateInput").style.display="none";
		
	}else if(_i("QUERY","idtype").value == "2" ){
		document.getElementById("radioBoxArea").innerHTML = "";
		document.getElementById("radioBoxArea").style.display="none";
		
		document.getElementById("type_exp").innerHTML= "居留證統一證號";
		Form.getDynSelectFromPhrase(_i("QUERY","NATIONCODE"), "SOLT005_14_SELECT", true ,"","");
		document.getElementById("expDateSpan").innerHTML="證件到期日<font color=red>＊</font>：永久居留99991231 <br>";
		document.getElementById("expDateSpan").style.display="inline";
		document.getElementById("expDateInput").style.display="inline";
		
	}else if(_i("QUERY","idtype").value == "3" ){
		/* 2020/04/29新增 */
		Form.getDynSelectFromPhrase(_i("QUERY","NATIONCODE"), "SOLT005_16_SELECT", false ,"","");
		document.getElementById("radioBoxArea").style.display="block";		
		document.getElementById("radioBoxArea").innerHTML= "<label><input type='radio' id='radioIdno' name='radioType' value='1' onclick='radioBoxChange(1)' checked><font color=blue>身分證統一編號</font></label>" +
														   "<label><input type='radio' id='radioPassportNo' name='radioType' value='2' onclick='radioBoxChange(2)'>中華民國護照無身分證統一編號</label>";
		//預設身分證字號
		radioBoxChange(1);														   
														   
														   							
		//document.getElementById("type_exp").innerHTML= "護照統一證號";
		Form.getDynSelectFromPhrase(_i("QUERY","NATIONCODE"), "SOLT005_16_SELECT", true ,"",""); 
		//document.getElementById("expDateSpan").innerHTML="護照到期日<font color=red>＊</font>：";
		//document.getElementById("expDateSpan").style.display="inline";
		//document.getElementById("expDateInput").style.display="inline";
		
	}else {
		document.getElementById("radioBoxArea").innerHTML = "";
		document.getElementById("radioBoxArea").style.display="none";
		
		document.getElementById("type_exp").innerHTML= "身分證統一編號";
		Form.getDynSelectFromPhrase(_i("QUERY","NATIONCODE"), "SOLT005_13_SELECT", true ,"","");
		document.getElementById("expDateSpan").style.display="none";
		document.getElementById("expDateInput").style.display="none";		
	}
}

/** 護照號碼判斷要秀護照日期或是身分證字號(1表示身分證 2表示護照號碼) */
function radioBoxChange(type){
	switch(type) {
		case 1:
			document.getElementById("type_exp").innerHTML= "身分證統一編號";
			document.getElementById("expDateSpan").style.display="inline";
			document.getElementById("expDateInput").style.display="inline";
			breaks;
		case 2:
			document.getElementById("type_exp").innerHTML= "護照統一證號";
			document.getElementById("expDateSpan").style.display="inline";
			document.getElementById("expDateInput").style.display="inline";
			breaks;
		default:
			
	}
}

/** 檢查權限 - 有權限/無權限(true/false) */
function chkSecure(secureType)
{
    if (noPermissAry.toString().indexOf(secureType) != -1)
        return false;
    else
        return true
}


/** 20200327新加入 檢查可報名後執行動作 */
function doLockInput() {

	if(_i('QUERY', 'idtype').value != '3') {
		var    callBack    =    function doLockInput.callBack(ajaxData) {
			if (ajaxData == null){
				alert('ajax data = null ');
				return;
	        }
	        
	        if (ajaxData.data.length == 0){
	        	var sex = Form.getInput("QUERY", "IDNO").substring(1, 2);
				Form.setInput("EDIT","SEX", sex);
				//確認一下是不是新住民
				checkIdType3();
	        } else {
	        	Form.setInput("EDIT","SEX", ajaxData.data[0].CODE_NAME);
	        	Form.setInput("EDIT","IDTYPE2", "Y");
	        	//如果有居留身分 去查日期 先放HIDDEN 等存檔時再比對
	        	//getBaseDate();
	        }
		}
		sendFormData("QUERY", controlPage, "IDNO_GET_SEX", callBack);	
	}
}

function getBaseDate() {
	var    callBack    =    function getBaseDate.callBack(ajaxData) {
		if (ajaxData == null){
			return;
       	}
       	if (ajaxData.data.length != 0){ 
			Form.setInput("EDIT","RESIDENCE_BASEDATE", ajaxData.data[0].RESIDENCE_BASEDATE);
       	}
	}
	
	sendFormData("QUERY", controlPage, "GET_RESIDENCE_BASEDATE", callBack);
}

function checkIdType3() {
	var    callBack    =    function getBaseDate.callBack(ajaxData) {
		if (ajaxData == null){
			return;
       	}
       	if (ajaxData.data.length != 0){	       	
			Form.setInput("EDIT","IDTYPE3", "Y");
       	}
	}
	
	sendFormData("QUERY", controlPage, "CHECK_IDTYPE3", callBack);
}

/** ====================================================================================== */