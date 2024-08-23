<%/*  
----------------------------------------------------------------------------------
File Name        : sol051m_01c1
Author            : 曾國昭
Description        : SOL051M_登錄報名學生資料 - 控制頁面 (javascript)
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
doImport ("Query.js, ErrorHandle.js, LoadingBar_0_2.js, Form.js, Ajax_0_2.js, ArrayUtil.js, ReSize.js, SortTable.js");

/** 初始設定頁面資訊 */
var    printPage        =    "/sol/sol005m_01p1.jsp";    //列印頁面
var    editMode        =    "ADD";                //編輯模式, ADD - 新增, MOD - 修改
var    lockColumnCount        =    -1;                //鎖定欄位數
var    listShow        =    false;                //是否一進入顯示資料
var    _privateMessageTime    =    -1;                //訊息顯示時間(不自訂為 -1)
var    pageRangeSize        =    10;                //畫面一次顯示幾頁資料
var    controlPage        =    "/sol/sol0051_01c2.jsp";    //控制頁面
var    checkObj        =    new checkObj();            //核選元件
var    queryObj        =    new queryObj();            //查詢元件
var    importSelect        =    false;                //匯入選取欄位功能
var    noPermissAry        =    new Array();            //沒有權限的陣列
var SAVE_TYPEv = "0";

/** 網頁初始化 */
function page_init1()
{

    /** 初始上層帶來的 Key 資料 */
    iniMasterKeyColumn();
    document.getElementById("PRE_MAJOR_FACULTY").disabled=true ;		//關開窗
    if(Form.getInput("EDIT","ASYS")=="2"){
        document.getElementById("PRE_MAJOR_FACULTY").disabled=false ;		//關開窗
    }
//    var AYEAR1=<%=request.getParameter("AYEAR")%>;
//    var SMS1=<%=request.getParameter("SMS")%>;
//    var IDNO1=<%=request.getParameter("IDNO")%>;
//    var BIRTHDATE1=<%=request.getParameter("BIRTHDATE")%>;
//    var NAME1=<%=request.getParameter("NAME")%>;
//    var STTYPE1=<%=request.getParameter("STTYPE")%>;
//    var CENTER_CODE1=<%=request.getParameter("CENTER_CODE")%>;
//    var PAYMENT_METHOD1=<%=request.getParameter("PAYMENT_METHOD")%>;
//    var DRAFT_NO1=<%=request.getParameter("DRAFT_NO")%>;
//    var AUDIT_RESULT1=<%=request.getParameter("AUDIT_RESULT")%>;

//    alert("ASYS"+ASYS1);
//    alert("AYEAR"+AYEAR1);
//    alert("SMS"+SMS1);
//    alert("IDNO"+IDNO1);
//    alert("BIRTHDATE"+BIRTHDATE1);
//    alert("NAME"+NAME1);
//    alert("STTYPE"+STTYPE1);
//    alert("CENTER_CODE"+CENTER_CODE1);
//    alert("PAYMENT_METHOD"+PAYMENT_METHOD1);
//    alert("DRAFT_NO"+DRAFT_NO1);
//    alert("AUDIT_RESULT"+AUDIT_RESULT1);

    /** 修正若有開窗自動帶出 */
//    Form.iniFormSet('EDIT', 'ASYS', 'KV', ASYS1 , 'R', 1);
//    Form.iniFormSet('EDIT', 'CENTER_CODE', 'KV', CENTER_CODE1 , 'R', 1);
//    Form.iniFormSet('EDIT', 'STTYPE', 'KV', STTYPE1 , 'R', 1);
//    _i("EDIT", "ASYS").fireEvent("onblur");
//    _i("EDIT", "CENTER_CODE").fireEvent("onblur");
//    _i("EDIT", "STTYPE").fireEvent("onblur");

    //alert("1");
    //document.getElementById("QUERY").style.display = "none";
    page_init_start_2();

    /** === 初始欄位設定 === */
    /** 初始編輯欄位 */
    Form.iniFormSet('EDIT', 'IDNO', 'M',  10, 'A', 'D', '1', 'R', '1');
    Form.iniFormSet('EDIT', 'BIRTHDATE', 'M',  8, 'A', 'DT', 'R', '1');
//    Form.iniFormSet('EDIT', 'CENTER_CODE', 'M',  8, 'A');
//    Form.iniFormSet('EDIT', 'STTYPE', 'M',  1, 'A');
    Form.iniFormSet('EDIT', 'NAME', 'M',  10, 'A', 'R', '1');
    Form.iniFormSet('EDIT', 'SEX', 'M',  1, 'A');    
    Form.iniFormSet('EDIT', 'SELF_IDENTITY_SEX', 'M',  1, 'A');
    Form.iniFormSet('EDIT', 'NATIONCODE', 'M',  1, 'A');
    Form.iniFormSet('EDIT', 'CRRSADDR', 'M',  50, 'A');
    Form.iniFormSet('EDIT', 'TEL_OFFICE', 'M',  17, 'A', 'N1');
    Form.iniFormSet('EDIT', 'TEL_HOME', 'M',  17, 'A', 'N1');
    Form.iniFormSet('EDIT', 'AREACODE_HOME', 'M',  3, 'A', 'N1');
    Form.iniFormSet('EDIT', 'AREACODE_OFFICE', 'M',  3, 'A', 'N1');
    Form.iniFormSet('EDIT', 'TEL_OFFICE_EXT', 'M',  6, 'A', 'N1');
    Form.iniFormSet('EDIT', 'MOBILE', 'M',  15, 'A');
    Form.iniFormSet('EDIT', 'EMAIL', 'M',  120, 'A');
    //Form.iniFormSet('EDIT', 'EDUBKGRD', 'M',  50, 'A');
    Form.iniFormSet('EDIT', 'MARRIAGE', 'M',  1, 'A');
    Form.iniFormSet('EDIT', 'EDUBKGRD_GRADE', 'M',  2, 'A');
    Form.iniFormSet('EDIT', 'EDUBKGRD_AYEAR', 'M',  3, 'A', 'N1');
    Form.iniFormSet('EDIT', 'VOCATION', 'M',  2, 'A');
    Form.iniFormSet('EDIT', 'PRE_MAJOR_FACULTY', 'M',  1, 'A');
    Form.iniFormSet('EDIT', 'TUTOR_CLASS_MK', 'M',  1, 'A', 'D');
    Form.iniFormSet('EDIT', 'SPECIAL_STTYPE_TYPE', 'M',  2, 'A', 'D');
    //Form.iniFormSet('EDIT', 'GETINFO', 'M',  1, 'A');
    //Form.iniFormSet('EDIT', 'GETINFO_NAME', 'M',  10,'S',20, 'A');
    Form.iniFormSet('EDIT', 'HANDICAP_TYPE', 'M',  1, 'A');
    Form.iniFormSet('EDIT', 'HANDICAP_GRADE', 'M',  1, 'A');
    Form.iniFormSet('EDIT', 'ORIGIN_RACE', 'M',  1, 'A');
    Form.iniFormSet('EDIT', 'EMRGNCY_NAME', 'M', 10, 'A');
    Form.iniFormSet('EDIT', 'EMRGNCY_TEL', 'M', '17', 'A', 'N1');
    Form.iniFormSet('EDIT', 'EMRGNCY_RELATION', 'M', 10, 'S', 10);
    Form.iniFormSet('EDIT', 'EMRGNCY_EMAIL', 'M', 120);
    Form.iniFormSet('EDIT','DMSTADDR_ZIP', 'M', 5, 'A', 'N1');
    Form.iniFormSet('EDIT','CRRSADDR_ZIP', 'M', 5, 'A', 'N1');
	Form.iniFormSet('EDIT','DMSTADDR', 'FS');
	Form.iniFormSet('EDIT','CRRSADDR', 'FS');
	
    Form.iniFormSet('EDIT','ENG_NAME','M', 20 ,'U', 'A');
    Form.iniFormSet('EDIT', 'NEWNATION', 'S',1,'M', '10');
    
    Form.iniFormSet('EDIT', 'RECOMMEND_NAME', 'M',  10, 'A');
    Form.iniFormSet('EDIT', 'RECOMMEND_ID', 'M',  10, 'A');

    loadind_.showLoadingBar (15, "初始欄位完成");
    /** ================ */
//    Form.iniFormSet('QUERY', 'IDNO', 'M',  10, 'A', 'I', 'U', 'R', '0');
//    Form.iniFormSet('QUERY', 'BIRTHDATE', 'M',  8, 'A', 'DT', 'R', '0');
    /** === 設定檢核條件 === */
    /** 編輯欄位 */
    Form.iniFormSet('EDIT', 'EDUBKGRD_GRADE', 'AA', 'chkForm', '最高學歷類別');
    Form.iniFormSet('EDIT', 'PRE_MAJOR_FACULTY', 'AA', 'chkForm', '預定主修學系');
    //Form.iniFormSet('EDIT', 'GETINFO', 'AA', 'chkForm', '獲得空大招生來源');
    Form.iniFormSet('EDIT', 'CENTER_CODE', 'AA', 'chkForm', '報名學習指導中心');
    Form.iniFormSet('EDIT', 'STTYPE', 'AA', 'chkForm', '報名身分別');
    Form.iniFormSet('EDIT', 'NAME', 'M',  10,'AA', 'chkForm', '姓名');
    Form.iniFormSet('EDIT', 'SEX', 'AA', 'chkForm', '性別');
    Form.iniFormSet('EDIT', 'NATIONCODE', 'AA', 'chkForm', '國籍別');
    //Form.iniFormSet('EDIT', 'NEWNATION', 'AA', 'chkForm', '新住民原國籍別');
    Form.iniFormSet('EDIT', 'CRRSADDR', 'M',  50,'AA', 'chkForm', '通訊地址');
    Form.iniFormSet('EDIT','DMSTADDR_ZIP', 'M',  5,'AA', 'chkForm', '通訊區碼');
    Form.iniFormSet('EDIT','CRRSADDR_ZIP', 'M',  5,'AA', 'chkForm', '戶籍區碼');
    Form.iniFormSet('EDIT', 'DMSTADDR', 'M',  50,'AA', 'chkForm', '戶籍地址');
    Form.iniFormSet('EDIT', 'EMAIL', 'M',  30,'AA', 'chkForm', '個人電子信箱，如果沒有個人電子信箱，請填寫「0@0.0」');
    Form.iniFormSet('EDIT', 'MOBILE','M',  10, 'AA', 'chkForm', '行動電話，如果沒有個人手機，請填寫「0000」');
    Form.iniFormSet('EDIT', 'TUTOR_CLASS_MK', 'AA', 'chkForm', '是否參加導師班');
    Form.iniFormSet('EDIT', 'EMRGNCY_NAME', 'M',  6,'AA', 'chkForm', '緊急聯絡人');
    Form.iniFormSet('EDIT', 'EMRGNCY_TEL','M',  17, 'AA', 'chkForm', '緊急聯絡人電話');
    Form.iniFormSet('EDIT', 'EMRGNCY_RELATION', 'M',  10,'AA', 'chkForm', '緊急聯絡人關係');
    Form.iniFormSet('EDIT', 'EMRGNCY_EMAIL','AA', 'chkForm', '緊急聯絡電子信箱');
    Form.iniFormSet('EDIT', 'DOC_AGREE_MK', 'AA', 'chkForm', '同意切結');

//    Form.iniFormSet('EDIT', 'SCHOOL_NAME_OLD', 'M',  25,'AA', 'chkForm', '原學校名稱');
//    Form.iniFormSet('EDIT', 'FACULTY_OLD', 'M',  25,'AA', 'chkForm', '原科系');
//    Form.iniFormSet('EDIT', 'GRADE_OLD', 'M',  1,'AA', 'chkForm', '原年級');
//    Form.iniFormSet('EDIT', 'STNO_OLD', 'M',  20,'AA', 'chkForm', '原學號');
    //Form.iniFormSet('EDIT', 'REG_FEE', 'M',  6, 'A', 'N1','AA', 'chkForm', '報名費：');

    loadind_.showLoadingBar (20, "設定檢核條件完成");
    /** ================ */
    Form.iniFormColor();
    queryObj.endProcess ("狀態完成");
    //page_init_end_2();
    
    //var    gridObj    =    new Grid();
    //Query.setGridEvent(gridObj.scrollSize);
    doLock(Form.getInput("EDIT", "HANDICAP_TYPE"));
    //checkGETINFO();
    
}

/** 初始上層帶來的 Key 資料 */
function iniMasterKeyColumn()
{
	/** 非 Detail 頁面不處理 */
	if (typeof(keyObj) == "undefined")
		return;
	/** 塞值 */
	for (keyName in keyObj)
	{
		if(keyName == "AYEAR"){
			try {Form.iniFormSet("EDIT", keyName, "V", keyObj[keyName], "R", 1);}catch(ex){};
		}else{
			Form.setInput("EDIT", keyName, keyObj[keyName]);
		}
		//try {Form.iniFormSet("QUERY", keyName, "V", keyObj[keyName], "R", 1);}catch(ex){};
		
	}
	
	Form.iniFormColor();
	
	//if("11" == Form.getInput("EDIT", "EDUBKGRD_GRADE")) {
		//Form.setInput("EDIT", "edubkgrd1", "國立空中大學");
		//Form.setInput("EDIT", "edubkgrd2", "畢業");
	//}
	
	/** 傳送至後端存檔 */
    var    callBack    =    function iniMasterKeyColumn.callBack(ajaxData)
    {
        if (ajaxData == null)
            return;

		if(ajaxData.result == "Y") {
			Form.setInput("EDIT", "edubkgrd1", "國立空中大學");
			Form.setInput("EDIT", "edubkgrd2", "畢業");	
		}
        
    }
    sendFormData("EDIT", controlPage, "GET_GRAT003_CHECK", callBack)
	
	
}

/** 新增功能時呼叫 */
function doAdd()
{
    doAdd_start();

    /** 清除唯讀項目(KEY)*/
    Form.iniFormSet('EDIT', 'IDNO', 'R', 0);
    Form.iniFormSet('EDIT', 'BIRTHDATE', 'R', 0);


    /** 初始上層帶來的 Key 資料 */
    iniMasterKeyColumn();

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
    var edu = document.getElementById("EDUBKGRD").value;
    document.getElementById("EDUBKGRD").value = edu.split(",")[0];
    document.getElementById("EDUBKGRD1").value = edu.split(",")[1];
    document.getElementById("aaa").value = edu.split(",")[2];
    /** 設定修改模式 */
    editMode        =    "UPD";
    EditStatus.innerHTML    =    "修改";

    /** 清除唯讀項目(KEY)*/
    Form.iniFormSet('EDIT', 'IDNO', 'R', 1);
    Form.iniFormSet('EDIT', 'BIRTHDATE', 'R', 1);

	//取得GETINFO_TMP的值
	//var checkBoxValue=_i("EDIT", "GETINFO_TMP").value;
    //var len = _i("EDIT", "GETINFO").length ;
    //for(var i=0;i<len;i++){
	//	_i("EDIT", "GETINFO")[i].checked = false;
	//}	
	
	// 一個迴圈表示某次勾選的值
	if(checkBoxValue!='')//判斷---"排除獲得空大招生訊息來源"有選，不為空的
	{
		var a = checkBoxValue.split(",");
		for(var i=0;i<a.length;i++){
			document.getElementById("GETINFO_"+a[i]).checked = true;
		}
	}


    /** 初始化 Form 顏色 */
    Form.iniFormColor();

    /** 設定 Focus */
    Form.iniFormSet('EDIT', 'CENTER_CODE', 'FC');
}

/** 存檔功能時呼叫 */
function doSave1()
{
	document.forms["EDIT"].elements["SMS"].disabled = false;
	//document.forms["EDIT"].elements["SEX"].disabled = false;
	if(Form.getInput("EDIT", "SPECIAL_STUDENT") == "5"){
    	if(Form.getInput("EDIT", "STTYPE") == "2"){
    		alert("由於您是選修生修滿40學分，報名身份別不可為「選修生」！");
    		return;
    	}
    }
	/*
	if(D_NO != ""){
    	if(D_NO.length != 11)
		{
			alert("匯票號碼必須等於11碼！");
    		return;
		}
    }
	*/
	if(Form.getInput("EDIT", "STTYPE") == "1"){
    	var EDU = Form.getInput("EDIT", "EDUBKGRD_GRADE");
		if(EDU < '03'){
			alert("報名空大全修生\"入學學歷類別\"必須高中以上！");
	    	return;
		}
	}
	
	if(Form.getInput("EDIT", "ASYS") == "2"){
    	var EDU = Form.getInput("EDIT", "EDUBKGRD_GRADE");
		if(EDU < '03'){
			alert("報名空專\"入學學歷類別\"必須高中以上！");
	    	return;
		}
    }
    
    
    /**	   代表居留身分	**/
    if(Form.getInput("EDIT", "IDTYPE2") == "Y" ) {
    	if(Form.getInput("EDIT", "RESIDENCE_DATE") == ""){
    		Form.errAppend("居留證有效日期未填寫");
    	} else {
    		var baseDate = Form.getInput("EDIT", "RESIDENCE_BASEDATE");
    		if(baseDate != '') {
    			if(Form.getInput("EDIT", "RESIDENCE_DATE") < baseDate) {
	    			Form.errAppend("居留證日期需大於等於系統設定日期");
	    		}
    		}    		
    	}
    }
    
    /**	   代表新住民身分	**/
    if(Form.getInput("EDIT", "IDTYPE3") == "Y" ) {
    	if(Form.getInput("EDIT", "NEWNATION") == ""){
    		Form.errAppend("新住民原國別未填寫");
    	}
    }
    
    if(checkEmail(_i("EDIT", "EMAIL").value)){
		return false;
	}
	
    if ( check() )   {
        Form.setInput("EDIT","SAVE_TYPE",SAVE_TYPEv) ;
        doSave_start();
        editMode = "ADD";

        doSave_end1();
    }
}
//function doQQ(){
//    top.mainFrame.location.href    =    'sol005m_02v1.jsp';
//}
/** 存檔功能時呼叫結束 */
function doSave_end1()
{
    /** 檢核設定欄位*/
    Form.startChkForm("EDIT");

    /** 減核錯誤處理 */
    if (!queryObj.valideMessage (Form))
        return;

    /** = 送出表單 = */
    /** 設定狀態 */
//    alert(editMode);
    var    actionMode    =    "";
    if (editMode == "ADD")
        actionMode    =    "ADD_MODE";
    else
        actionMode    =    "EDIT_MODE";

    /** 傳送至後端存檔 */
    var    callBack    =    function doSave_end1.callBack(ajaxData)
    {
//        alert(ajaxData.result);
        if (ajaxData == null)
            return;

        /** 資料新增成功訊息 */
        if (editMode == "ADD")
        {
            /** 設定為新增模式 */
            doAdd();
            Message.openSuccess("A01");
			if(ajaxData.data[0].STNO != "")
				alert("該生學號：" + ajaxData.data[0].STNO);
			
            var paymentStatus = document.forms["EDIT"].elements["PAYMENT_STATUS"].value;
			
			if(paymentStatus == "2"){
				var status_tmp = _i('EDIT', 'NPAYMENT_BAR').value;
				if(status_tmp == "")
				{
					if(confirm("是否列印收據？")){
						document.getElementById("ASYS").disabled = false;
		    			doPrint('2');
		    		}
				}
	    	}else if(!(_i('EDIT', 'NPAYMENT_BAR').value!="" || _i('EDIT', 'REG_FEE').value == "0")){
	    		if(confirm("是否列印繳費單？")){
	    			doPrint('1');
	    		}
	    	}
    		/* if(paymentStatus == "2"){
    			if(confirm("是否列印收據？")){
    				doPrint('2');
    			}
    		}else{
    			if(confirm("是否列印繳費單？")){
    				doPrint('1');
    			}
    		} */
			document.getElementById("ASYS").disabled = true;
            top.mainFrame.location.href = 'sol005m_02v1.jsp';
        }
        /** 資料修改成功訊息 */
        else
        {
            Message.openSuccess("A02", function (){top.hideView();});
            //var r = confirm("請問是否列印繳費單？\n(目前仍在測試階段，尚無繳費單)");
            top.mainFrame.location.href    =    'sol005m_02v1.jsp';
            /** nono mark 2006/11/16 */
            //top.mainFrame.iniGrid();
        }
    }
    sendFormData("EDIT", controlPage, actionMode, callBack)
}

function goBack(){
	top.mainFrame.location.href = 'sol005m_02v1.jsp';
}

function check()
{
    var sttype = document.forms["EDIT"].elements["STTYPE"].value;
    var e1 = document.forms["EDIT"].elements["edubkgrd1"].value;
    var e2 = document.forms["EDIT"].elements["edubkgrd2"].value;
    //var e3 = document.forms["EDIT"].elements["edubkgrd3"].value;
    
    if (sttype == '2')    {
        return true ;
    }else{
    	if(e1 == "" || e2 == ""){
    		document.forms["EDIT"].elements["SMS"].disabled = true;
			//document.forms["EDIT"].elements["SEX"].disabled = true;
			alert("請輸入學歷");
    		return false;
    	}else{
    		return true;
    	}
    }
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
	//event.returnValue	=	false;

	/** 開啟資料處理中 */
	Message.showProcess();
}

/** 處理列印動作結束 */
function doPrint_end(value)
{
	/** 取消 onsubmit 功能防止重複送出 */
	//event.returnValue	=	false;

	/** 開始處理 */
	Message.showProcess();

	/** 檢核設定欄位*/
	//Form.startChkForm("QUERY");

	/** 減核錯誤處理 */
	if (!queryObj.valideMessage (Form))
		return;

	var	printWin	=	WindowUtil.openPrintWindow("", "Print");
	Form.doSubmit("EDIT", printPage + "?control_type=PRINT_MODE&status=" + value, "post", "Print");

	printWin.focus();

	/** 停止處理 */
	Message.hideProcess();
}

/** 拷貝 地址 */
function doCopy()
{
    if (document.getElementById("same").checked == true)   {
        var a = document.getElementById("DMSTADDR").value;
        var b = document.getElementById("DMSTADDR_ZIP").value;
        document.getElementById("CRRSADDR").value = a ;
        document.getElementById("CRRSADDR_ZIP").value = b ;
        document.getElementById("CRRSADDR").disabled = true ;
        document.getElementById("CRRSADDR_ZIP").disabled = true ;
    }else   {
        document.getElementById("CRRSADDR").disabled = false ;
        document.getElementById("CRRSADDR_ZIP").disabled = false ;
    }
    /** 初始化 Form 顏色 */
    Form.iniFormColor();
}

function doLock(value){
	var theForm = document.forms["EDIT"];
	if(value == '' || value == '00'){
		theForm.elements["HANDICAP_GRADE"].value = "";
		theForm.elements["HANDICAP_GRADE"].disabled = true;
	}else{
		theForm.elements["HANDICAP_GRADE"].disabled = false;
	}
	Form.iniFormColor();
}

/**通訊地址開窗*/
function addr()
{
	var tmp = _i('EDIT','CRRSADDR').value;
	if(_i('EDIT','CRRSADDR').value == "" || tmp.length <= 6)
		Form.openPhraseWindow("SOL004M_01_WINDOW", null, null, "郵遞區號, 縣市鄉鎮區", [_i("EDIT", "CRRSADDR_ZIP"), _i("EDIT", "CRRSADDR")]);
	else
		Form.openPhraseWindow("SOL004M_01_WINDOW", null, null, "郵遞區號, 縣市鄉鎮區", [_i("EDIT", "CRRSADDR_ZIP"), _i("EDIT", "CRRSADDR2")]);
}

/**通訊地址BLUR*/
function addr2(tmp2)
{
	var tmp = _i('EDIT','CRRSADDR').value;
	if(_i('EDIT','CRRSADDR').value == "" || tmp.length <= 6)
		Form.blurData("SOL004M_01_BLUR", "CRRSADDR_ZIP", tmp2, ["CRRSADDR_ZIP", "CRRSADDR"], [_i("EDIT", "CRRSADDR"), _i("EDIT", "CRRSADDR")], true);
	else
		Form.blurData("SOL004M_01_BLUR", "CRRSADDR_ZIP", tmp2, ["CRRSADDR_ZIP", "CRRSADDR"], [_i("EDIT", "CRRSADDR2"), _i("EDIT", "CRRSADDR2")], true);
}

/**戶籍地址開窗*/
function addr_d()
{
	var tmp = _i('EDIT','DMSTADDR').value;
	if(_i('EDIT','DMSTADDR').value == "" || tmp.length <= 6)
		Form.openPhraseWindow("SOL004M_02_WINDOW", null, null, "郵遞區號, 縣市鄉鎮區", [_i("EDIT", "DMSTADDR_ZIP"), _i("EDIT", "DMSTADDR")]);
	else
		Form.openPhraseWindow("SOL004M_02_WINDOW", null, null, "郵遞區號, 縣市鄉鎮區", [_i("EDIT", "DMSTADDR_ZIP"), _i("EDIT", "DMSTADDR2")]);
}

/**戶籍地址BLUR*/
function addr_d2(tmp2)
{
	var tmp = _i('EDIT','DMSTADDR').value;
	if(_i('EDIT','DMSTADDR').value == "" || tmp.length <= 6)
		Form.blurData("SOL004M_02_BLUR", "DMSTADDR_ZIP", tmp2, ["DMSTADDR_ZIP", "DMSTADDR"], [_i("EDIT", "DMSTADDR"), _i("EDIT", "DMSTADDR")], true);
	else
		Form.blurData("SOL004M_02_BLUR", "DMSTADDR_ZIP", tmp2, ["DMSTADDR_ZIP", "DMSTADDR"], [_i("EDIT", "DMSTADDR2"), _i("EDIT", "DMSTADDR2")], true);
}

/**電子信箱格式檢核*/
function checkEmail(mailStr)
{
	if(mailStr!=''){
		if((mailStr.indexOf("@")==-1 || mailStr.indexOf(".")==-1)){
			alert('電子信箱所填資料文字或格式不正確，請再確認。');
			return true;
		}
	}    
	return false;
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

/** 檢查權限 - 有權限/無權限(true/false) */
function chkSecure(secureType)
{
    if (noPermissAry.toString().indexOf(secureType) != -1)
        return false;
    else
        return true
}
/** ====================================================================================== */
function checkGETINFO(){

<!-- 	if( Form.getInput("EDIT", "GETINFO") =='1' ){ -->
<!-- 		Form.iniFormSet("EDIT", "GETINFO_NAME", "D", 0, "R", 0);	 -->
<!-- 	}else{ -->
<!-- 		Form.iniFormSet("EDIT", "GETINFO_NAME", "D", 1, "R", 1); -->
<!-- 	} -->
	Form.iniFormColor();
}