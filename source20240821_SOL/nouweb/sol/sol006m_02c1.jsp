<%/* 
----------------------------------------------------------------------------------
File Name        : sol006m_02c1
Author            : 曾國昭
Description        : SOL006M_登錄報名審查結果 - 編輯控制頁面 (javascript)
Modification Log    :

Vers        Date           By                Notes
--------------    --------------    --------------    ----------------------------------
0.0.1        096/01/25    曾國昭        Code Generate Create
----------------------------------------------------------------------------------
*/%>
<%@ page contentType="text/html; charset=UTF-8" errorPage="/utility/errorpage.jsp" pageEncoding="MS950"%>
<%@ include file="/utility/header.jsp"%>
<%@ include file="/utility/jspageinit.jsp"%>

/** 匯入 javqascript Class */
doImport ("ErrorHandle.js, LoadingBar_0_2.js, Form.js, Ajax_0_2.js, ArrayUtil.js");

/** 初始設定頁面資訊 */
var    currPage        =    "<%=request.getRequestURI()%>";
var    printPage        =    "/sol/sol006m_01p1.htm";    //列印頁面
var    editMode        =    "ADD";                //編輯模式, ADD - 新增, MOD - 修改
var    _privateMessageTime    =    -1;                //訊息顯示時間(不自訂為 -1)
var    controlPage        =    "/sol/sol006m_01c2.jsp";    //控制頁面
var    queryObj        =    new queryObj();            //查詢元件
var enroll_status = "";


/** 網頁初始化 */
function page_init()
{
    page_init_start_2();

    /** === 初始欄位設定 === */
    /** 初始編輯欄位 */
    Form.iniFormSet('EDIT', 'IDNO', 'M',  10, 'A');
    Form.iniFormSet('EDIT', 'BIRTHDATE', 'M',  8, 'A');
    Form.iniFormSet('EDIT', 'NAME', 'M',  10, 'A');
    Form.iniFormSet('EDIT', 'STTYPE', 'M',  1, 'A');
    Form.iniFormSet('EDIT', 'SEX', 'M',  1, 'A');
    Form.iniFormSet('EDIT', 'SELF_IDENTITY_SEX', 'M',  1, 'A');
    Form.iniFormSet('EDIT', 'EDUBKGRD_GRADE', 'M',  1, 'A');
    Form.iniFormSet('EDIT', 'NATIONCODE', 'M',  10, 'A');
    Form.iniFormSet('EDIT', 'NEWNATION', 'M',  10, 'A');
    Form.iniFormSet('EDIT', 'RESIDENCE_DATE', 'M',  8, 'A');
    Form.iniFormSet('EDIT', 'CCENTER_CODE', 'M',  8, 'A');
    Form.iniFormSet('EDIT', 'PAYMENT_STATUS', 'M',  1, 'A');
    Form.iniFormSet('EDIT', 'PAYMENT_METHOD', 'M',  1, 'A');
    Form.iniFormSet('EDIT', 'CHECK_DOC', 'M',  1, 'A');
    Form.iniFormSet('EDIT', 'DOC_UNQUAL_REASON', 'M',  100, 'A');
    Form.iniFormSet('EDIT', 'HANDICAP_AUDIT_MK', 'M',  1, 'A');
    Form.iniFormSet('EDIT', 'HANDICAP_UNQUAL_REASON', 'M',  100, 'A');
    Form.iniFormSet('EDIT', 'LOW_INCOME_AUDIT', 'M',  1, 'A');
    Form.iniFormSet('EDIT', 'LOW_INCOME_UNQUAL_REASON', 'M',  100, 'A');
    Form.iniFormSet('EDIT', 'DRAFT_NO', 'M',  12, 'S', 12, 'A');
    Form.iniFormSet('EDIT', 'WRITEOFF_NO', 'M',  16, 'A');
    Form.iniFormSet('EDIT', 'EDUBKGRD', 'M',  50, 'A');
    Form.iniFormSet('EDIT', 'EDUBKGRD_AYEAR', 'M',  3, 'A');
    Form.iniFormSet('EDIT', 'AUDIT_RESULT', 'M',  1, 'A');
    Form.iniFormSet('EDIT', 'AUDIT_UNQUAL_REASON', 'M',  100, 'A');
	Form.iniFormSet('EDIT', 'STNO', 'S',  10);
	Form.iniFormSet('EDIT', 'NEW_RESIDENT_CHD', 'M',  1, 'A');
	Form.iniFormSet('EDIT', 'FATHER_NAME', 'M',  30, 'A');
	Form.iniFormSet('EDIT', 'FATHER_ORIGINAL_COUNTRY', 'M',  10, 'A');
	Form.iniFormSet('EDIT', 'MOTHER_NAME', 'M',  30, 'A');
	Form.iniFormSet('EDIT', 'MOTHER_ORIGINAL_COUNTRY', 'M',  10, 'A');	

    loadind_.showLoadingBar (15, "初始欄位完成");
    /** ================ */

    /** === 設定檢核條件 === */
    /** 編輯欄位 */
//    Form.iniFormSet('EDIT', 'PAYMENT_METHOD', 'AA', 'chkForm', '繳費方式');

    loadind_.showLoadingBar (20, "設定檢核條件完成");
    /** ================ */

    page_init_end_2();
    
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

/** 選擇其他時，顯示註記訊息*/
function changeMessage()
{
	if(_i('EDIT', 'HANDICAP_AUDIT_MK').value == "2")
		document.getElementById("HANDICAP_AUDIT_MK2").innerHTML  = "<font size='2'><b>※其他表無身心障礙申請</b></font>";
	else
		document.getElementById("HANDICAP_AUDIT_MK2").innerHTML  = "";
}

/** 選擇其他時，顯示註記訊息*/
function changeMessage2()
{
	if(_i('EDIT', 'LOW_INCOME_AUDIT').value == "2")
		document.getElementById("LOW_INCOME_AUDIT2").innerHTML  = "<font size='2'><b>※其他表無低收入戶申請</b></font>";
	else
		document.getElementById("LOW_INCOME_AUDIT2").innerHTML  = "";
}

/** 修改功能時呼叫 */
function doModify()
{
    var aa = <%=session.getAttribute("LOCK")%>;
    document.getElementById("PAYMENT_STATUS").disabled = false;
    document.getElementById("PAYMENT_METHOD").disabled = false;
    document.getElementById("TOTAL_RESULT").disabled = false;
    Form.iniFormSet('EDIT', 'PAYMENT_STATUS', 'R', 0);
    Form.iniFormSet('EDIT', 'PAYMENT_METHOD', 'R', 0);
    Form.iniFormSet('EDIT', 'TOTAL_RESULT' , 'R' , 0);
	Form.iniFormSet('EDIT', 'DRAFT_NO', 'R', 1);
	Form.iniFormSet('EDIT', 'PAYMENT_STATUS', 'D', 1);
	Form.iniFormSet('EDIT', 'PAYMENT_METHOD', 'D', 1);
	Form.iniFormSet('EDIT', 'HANDICAP_TYPE', 'D', 1);
	Form.iniFormSet('EDIT', 'HANDICAP_GRADE', 'D', 1);
	Form.iniFormSet('EDIT', 'ORIGIN_RACE', 'D', 1);
	Form.iniFormSet('EDIT', 'NEWNATION', 'D', 1);	
	Form.iniFormSet('EDIT', 'NEW_RESIDENT_CHD', 'D', 1);
	Form.iniFormSet('EDIT', 'FATHER_NAME', 'D', 1);	
	Form.iniFormSet('EDIT', 'FATHER_ORIGINAL_COUNTRY', 'D', 1);
	Form.iniFormSet('EDIT', 'MOTHER_NAME', 'D', 1);
	Form.iniFormSet('EDIT', 'MOTHER_ORIGINAL_COUNTRY', 'D', 1);
	Form.iniFormSet('EDIT', 'DOC_AGREE_MK', 'D', 1);
	Form.iniFormSet('EDIT', 'SELF_IDENTITY_SEX', 'D', 1);
    
	if(_i('EDIT', 'HANDICAP_TYPE').value == "" && _i('EDIT', 'HANDICAP_AUDIT_MK').value == "3")
		_i('EDIT', 'HANDICAP_AUDIT_MK').value = "2";
	if(_i('EDIT', 'LOW_INCOME_AUDIT').value == "")
		_i('EDIT', 'LOW_INCOME_AUDIT').value = "3";
	if(_i('EDIT', 'HANDICAP_AUDIT_MK').value == "2"){
		Form.iniFormSet('EDIT', 'HANDICAP_AUDIT_MK', 'D', 1);
		Form.iniFormSet('EDIT', 'HANDICAP_UNQUAL_REASON', 'R', 1);
	}else{
		Form.iniFormSet('EDIT', 'HANDICAP_AUDIT_MK', 'D', 0);
		Form.iniFormSet('EDIT', 'HANDICAP_UNQUAL_REASON', 'R', 0);
	}
	// if(_i('EDIT', 'LOW_INCOME_AUDIT').value == "2"){
		// Form.iniFormSet('EDIT', 'LOW_INCOME_AUDIT', 'D', 1);
		// Form.iniFormSet('EDIT', 'LOW_INCOME_UNQUAL_REASON', 'R', 1);
	// }else{
		// Form.iniFormSet('EDIT', 'LOW_INCOME_AUDIT', 'D', 0);
		// Form.iniFormSet('EDIT', 'LOW_INCOME_UNQUAL_REASON', 'R', 0);
	// }
	changeMessage();
	changeMessage2();

    /** 設定修改模式 */
    editMode        =    "UPD";
    EditStatus.innerHTML    =    "修改";

    /** 清除唯讀項目(KEY)*/
    Form.iniFormSet('EDIT', 'IDNO', 'R', 1);
    Form.iniFormSet('EDIT', 'BIRTHDATE', 'R', 1);
    Form.iniFormSet('EDIT', 'STTYPE' , 'R' , 1);
    Form.iniFormSet('EDIT', 'NATIONCODE' , 'R' , 1);
    Form.iniFormSet('EDIT', 'NEWNATION' , 'R' , 1);
    Form.iniFormSet('EDIT', 'EDUBKGRD_GRADE' , 'R' , 1);
    Form.iniFormSet('EDIT', 'EDUBKGRD' , 'R' , 1);
    Form.iniFormSet('EDIT', 'EDUBKGRD_AYEAR' , 'R' , 1);
    Form.iniFormSet('EDIT', 'WRITEOFF_NO' , 'R' , 1);
    Form.iniFormSet('EDIT', 'REG_MANNER' , 'R' , 1);
	Form.iniFormSet('EDIT', 'NEW_RESIDENT_CHD', 'D', 1);
	Form.iniFormSet('EDIT', 'FATHER_NAME', 'D', 1);	
	Form.iniFormSet('EDIT', 'FATHER_ORIGINAL_COUNTRY', 'D', 1);
	Form.iniFormSet('EDIT', 'MOTHER_NAME', 'D', 1);
	Form.iniFormSet('EDIT', 'MOTHER_ORIGINAL_COUNTRY', 'D', 1);   

    if(document.getElementById("NPAYMENT_BAR").value=="")
    {
        document.getElementById("CHKPAYMENT").checked =false;
        Form.iniFormSet('EDIT', 'NPAYMENT_BAR', 'R', 1);
    }else{
        document.getElementById("CHKPAYMENT").checked =true;
        Form.iniFormSet('EDIT', 'NPAYMENT_BAR', 'R', 0);
    }
    if(Form.getInput("EDIT", "SET")=="Y"){		
        document.getElementById("SAVE_BTN").disabled = false;
    }else{
        document.getElementById("SAVE_BTN").disabled = true;
	}	
	Form.iniFormSet('EDIT', 'TOTAL_DOC_CHECKBOX', 'D', 1);
	Form.iniFormSet('EDIT', 'AUDIT_DOC_CHECKBOX', 'D', 1);
	document.EDIT.AUDIT_DOC_CHECKBOX.checked=false;
	document.EDIT.TOTAL_DOC_CHECKBOX.checked=false;
	// 按身分別來關閉某些欄位  aa=1 表示中心
	if(aa==1){
        Form.iniFormSet('EDIT', 'PAYMENT_STATUS', 'R', 1);
        Form.iniFormSet('EDIT', 'PAYMENT_METHOD', 'R', 1);
        Form.iniFormSet('EDIT', 'TOTAL_RESULT' , 'R' , 1);
        document.getElementById("PAYMENT_STATUS").disabled = true;
        document.getElementById("PAYMENT_METHOD").disabled = true;
        document.getElementById("TOTAL_RESULT").disabled = true;
		
		// 只要免繳費有值或是繳費狀態為未繳費均可輸入免繳費原因
		//var isDisabled = _i("EDIT","NPAYMENT_BAR").value!=''||_i("EDIT","PAYMENT_STATUS").value=='1';
		// 只要已交付且有對帳批號，均不可輸入免繳費原因
		//if (_i("EDIT","BATNUM").value != ''){
		//   document.EDIT.CHKPAYMENT.disabled=true;
		 //  document.EDIT.NPAYMENT_BAR.disabled=true;
		//}else{
		 //  document.EDIT.NPAYMENT_BAR.disabled=false;
		//   document.EDIT.CHKPAYMENT.disabled=!isDisabled;
		//   Form.iniFormSet('EDIT', 'NPAYMENT_BAR', 'R', (document.getElementById("CHKPAYMENT").checked?0:1));
		//}
		
    }else{
		Form.iniFormSet('EDIT', 'CHECK_DOC', 'D', 1);
        Form.iniFormSet('EDIT', 'DOC_UNQUAL_REASON', 'R', 1);
        Form.iniFormSet('EDIT', 'HANDICAP_AUDIT_MK' , 'D' , 1);
		Form.iniFormSet('EDIT', 'HANDICAP_UNQUAL_REASON', 'R', 1);		
		Form.iniFormSet('EDIT', 'LOW_INCOME_AUDIT' , 'D' , 1);
		Form.iniFormSet('EDIT', 'LOW_INCOME_UNQUAL_REASON', 'R', 1);
        Form.iniFormSet('EDIT', 'NEW_RESIDENT_AUDIT_MK' , 'D' , 1);
		Form.iniFormSet('EDIT', 'NEW_RESIDENT_UNQUAL_REASON', 'R', 1);
		document.EDIT.CHKPAYMENT.disabled=true;
		Form.iniFormSet('EDIT', 'NPAYMENT_BAR', 'R', 1);
		Form.iniFormSet('EDIT', 'AUDIT_RESULT', 'D', 1);
        Form.iniFormSet('EDIT', 'AUDIT_UNQUAL_REASON', 'R', 1);
	}
	// 只要免繳費有值或是繳費狀態為未繳費均可輸入免繳費原因
	var isDisabled = _i("EDIT","NPAYMENT_BAR").value!=''||_i("EDIT","PAYMENT_STATUS").value=='1';
	// 只要已交付且有對帳批號，均不可輸入免繳費原因
	if (_i("EDIT","BATNUM").value != ''){
	   document.EDIT.CHKPAYMENT.disabled=true;
	   document.EDIT.NPAYMENT_BAR.disabled=true;
	}else{
	   document.EDIT.NPAYMENT_BAR.disabled=false;
	   document.EDIT.CHKPAYMENT.disabled=!isDisabled;
	   Form.iniFormSet('EDIT', 'NPAYMENT_BAR', 'R', (document.getElementById("CHKPAYMENT").checked?0:1));
	}
	_i("EDIT","BEFORE_NPAYMENT_BAR").value = _i("EDIT","NPAYMENT_BAR").value;

    /** 初始化 Form 顏色 */
    Form.iniFormColor();

        // if (document.getElementById("DRAFT_NO").value != null)  {
            // var a = new String();
            // a = document.getElementById("DRAFT_NO").value;
            // document.getElementById("DRAFT_NO1").value = a.substring(0,9);
            // document.getElementById("DRAFT_NO2").value = a.charAt(9);
        // }

    /** 設定 Focus */
        Form.iniFormSet('EDIT', 'CHECK_DOC', 'FC');
        
	getIdnoType();
        
}

function doSOLCK1()
{
	var    callBack    =    function doSOLCK1.callBack(ajaxData) {
	    var specialStudent = "";
	    var    msg     = "";
		var aa = <%=session.getAttribute("LOCK")%>;
	    if (ajaxData == null){
			return;
	    }else{
			msg=ajaxData.result.toString().split("|");
	    }
	    try
	    {
	        //雙主修生
			if(msg[0]=="2")
	        {
				_i('EDIT', 'SPECIAL_STUDENT_TMP').value = "2";
				if(_i('EDIT', 'AUDIT_RESULT').value == "0")
					document.EDIT.AUDIT_DOC_CHECKBOX.checked=true;
				if(_i('EDIT', 'TOTAL_RESULT').value == "0")
					document.EDIT.TOTAL_DOC_CHECKBOX.checked=true;
				if(aa==1)
					Form.iniFormSet('EDIT', 'AUDIT_DOC_CHECKBOX', 'D', 0);
				else
					Form.iniFormSet('EDIT', 'TOTAL_DOC_CHECKBOX', 'D', 0);
	        }else{
				_i('EDIT', 'SPECIAL_STUDENT_TMP').value = "";
				Form.iniFormSet('EDIT', 'AUDIT_DOC_CHECKBOX', 'D', 1);
				Form.iniFormSet('EDIT', 'TOTAL_DOC_CHECKBOX', 'D', 1);
				document.EDIT.AUDIT_DOC_CHECKBOX.checked=false;
				document.EDIT.TOTAL_DOC_CHECKBOX.checked=false;
			}
			/** 初始化 Form 顏色 */
			Form.iniFormColor();
	    }catch(ex){}
	    return;
    }
    sendFormData("EDIT", controlPage, "SOLCK1", callBack, "1111");
}

function chkgogo()
{
	Form.iniFormSet('EDIT', 'NPAYMENT_BAR', 'R', (document.getElementById("CHKPAYMENT").checked?0:1), 'V', (document.getElementById("CHKPAYMENT").checked?_i("EDIT","NPAYMENT_BAR").value:''));	
    Form.iniFormColor();
}

function aa(){
    if (document.getElementById("PAYMENT_METHOD").value == 0)   {
        // document.getElementById("DRAFT_NO1").value = "" ;
        // document.getElementById("DRAFT_NO2").value = "" ;
        // document.getElementById("DRAFT_NO1").disabled = true ;
        // document.getElementById("DRAFT_NO2").disabled = true ;
		document.getElementById("DRAFT_NO").value = "" ;
        document.getElementById("DRAFT_NO").disabled = true ;
    }else   {
        // document.getElementById("DRAFT_NO1").disabled = false ;
        // document.getElementById("DRAFT_NO2").disabled = false ;
		document.getElementById("DRAFT_NO").disabled = false ;
    }
}
function bb()   {
    if (document.getElementById("c1").checked == false)   {
        document.getElementById("AUDIT_RESULT").value = 1
        document.getElementById("AUDIT_RESULT").disabled = true ;
        document.getElementById("DOC_UNQUAL_REASON").disabled = false ;
    }else   {
        document.getElementById("DOC_UNQUAL_REASON").disabled = true ;
        document.getElementById("DOC_UNQUAL_REASON").value = "" ;
        document.getElementById("AUDIT_RESULT").disabled = false ;
    }
}

/**
按下編輯時呼叫
@param	args[0]	單數參數, 變數名稱 (KEY)
@param	args[1]	雙數參數, 變數值 (KEY)
*/
function doEdit_2(arguments)
{
	/** 開始處理 */
	Message.showProcess();

	var	editAry	=	arguments[0].split("|");

	for (i = 0; i < editAry.length; i += 2)
	{
		Form.setInput("EDIT", editAry[i], editAry[i + 1]);
	}
    doModify();
	if(Form.getInput('EDIT', 'ASYS') == "1")
		doSOLCK1();
	else
		_i('EDIT', 'SPECIAL_STUDENT_TMP').value == "";
    Message.hideProcess();
	
	// 原本沒有到後端取得資料,目前因額外多了幾個欄位(ex:地址/電話...)在這取得,其他欄位一樣不在這放值,因原本就被mark
	/** 送到後端處理 */
	var	callBack	=	function doEdit_2.callBack(ajaxData)
	{
		if (ajaxData == null|| ajaxData.data.length==0)
			return;
          
		_i("EDIT", "DMSTADDR_ZIP").value=ajaxData.data[0].DMSTADDR_ZIP;
		_i("EDIT", "DMSTADDR").value=ajaxData.data[0].DMSTADDR;
		_i("EDIT", "CRRSADDR_ZIP").value=ajaxData.data[0].CRRSADDR_ZIP;
		_i("EDIT", "CRRSADDR").value=ajaxData.data[0].CRRSADDR;
		_i("EDIT", "AREACODE_OFFICE").value=ajaxData.data[0].AREACODE_OFFICE;
		_i("EDIT", "TEL_OFFICE").value=ajaxData.data[0].TEL_OFFICE;
		_i("EDIT", "TEL_OFFICE_EXT").value=ajaxData.data[0].TEL_OFFICE_EXT;
		_i("EDIT", "AREACODE_HOME").value=ajaxData.data[0].AREACODE_HOME;
		_i("EDIT", "TEL_HOME").value=ajaxData.data[0].TEL_HOME;
		_i("EDIT", "MOBILE").value=ajaxData.data[0].MOBILE;
		_i("EDIT", "EMAIL").value=ajaxData.data[0].EMAIL;
		_i("EDIT", "NATIONCODE").value=ajaxData.data[0].NATIONCODE;
		_i("EDIT", "NEWNATION").value=ajaxData.data[0].NEWNATION;
		_i("EDIT", "EDUBKGRD_AYEAR").value=ajaxData.data[0].EDUBKGRD_AYEAR;
		_i("EDIT", "NEW_RESIDENT_CHD").value=ajaxData.data[0].NEW_RESIDENT_CHD;
		_i("EDIT", "FATHER_NAME").value=ajaxData.data[0].FATHER_NAME;
		_i("EDIT", "FATHER_ORIGINAL_COUNTRY").value=ajaxData.data[0].FATHER_ORIGINAL_COUNTRY;
		_i("EDIT", "MOTHER_NAME").value=ajaxData.data[0].MOTHER_NAME;
		_i("EDIT", "MOTHER_ORIGINAL_COUNTRY").value=ajaxData.data[0].MOTHER_ORIGINAL_COUNTRY;
		_i("EDIT", "NEW_RESIDENT_AUDIT_MK").value=ajaxData.data[0].NEW_RESIDENT_AUDIT_MK;
		_i("EDIT", "NEW_RESIDENT_UNQUAL_REASON").value=ajaxData.data[0].NEW_RESIDENT_UNQUAL_REASON;
		_i("EDIT", "DOC_AGREE_MK").value=ajaxData.data[0].DOC_AGREE_MK;
		_i("EDIT", "SELF_IDENTITY_SEX").value=ajaxData.data[0].SELF_IDENTITY_SEX;
		/** 停止處理 */		
	}
	sendFormData("EDIT", controlPage, "EDIT_QUERY_MODE", callBack);
}
/** 存檔功能時呼叫 */
function doSave()
{
    var aa = <%=session.getAttribute("LOCK")%>;
	if ( check() )  {
		if(aa==1){
	        if (StrUtil.trim(_i('EDIT', 'DRAFT_NO').value) != "")  {
	            if (StrUtil.trim(document.getElementById("DRAFT_NO").value).length == 11)   {
	                // var draft1 = document.getElementById("DRAFT_NO1").value ;
	                // var draft2 = document.getElementById("DRAFT_NO2").value;
	                // var draft = draft1.concat(draft2);
	                // document.getElementById("DRAFT_NO").value = draft ;
	                doSave_start();

	                /** 判斷新增無權限不處理 */
	                if (editMode == "NONE")
	                        return;

	                /** === 自定檢查 === */
	           //     loadind_.showLoadingBar (8, "自定檢核開始");

	                /** 資料檢核及設定, 當有錯誤處理方式為 Form.errAppend(Message) 累計錯誤訊息 */
	                //if (Form.getInput("EDIT", "SYS_CD") == "")
	                //    Form.errAppend("系統編號不可空白!!");

	            //    loadind_.showLoadingBar (10, "自定檢核完成");
	                /** ================ */

	                doSave_end();
	            }else{
					doSave_start();

	                /** 判斷新增無權限不處理 */
	                if (editMode == "NONE")
	                        return;

	                /** === 自定檢查 === */
	             //   loadind_.showLoadingBar (8, "自定檢核開始");

	                /** 資料檢核及設定, 當有錯誤處理方式為 Form.errAppend(Message) 累計錯誤訊息 */
	                //if (Form.getInput("EDIT", "SYS_CD") == "")
	                //    Form.errAppend("系統編號不可空白!!");
					Form.errAppend("請輸入正確匯票號碼(11碼)");

	             //   loadind_.showLoadingBar (10, "自定檢核完成");
	                /** ================ */

	                doSave_end();
				}
			}else{
				doSave_start();
                /** 判斷新增無權限不處理 */
	            if (editMode == "NONE")
	                return;
                /** === 自定檢查 === */
	      //      loadind_.showLoadingBar (8, "自定檢核開始");
                /** 資料檢核及設定, 當有錯誤處理方式為 Form.errAppend(Message) 累計錯誤訊息 */
	            //if (Form.getInput("EDIT", "SYS_CD") == "")
	            //    Form.errAppend("系統編號不可空白!!");
           //     loadind_.showLoadingBar (10, "自定檢核完成");
	            /** ================ */
                doSave_end();
			}             
		}else{
			doSave_start();
			/** 判斷新增無權限不處理 */
			if (editMode == "NONE")
				return;

	        /** === 自定檢查 === */
	     //   loadind_.showLoadingBar (8, "自定檢核開始");
			/** 資料檢核及設定, 當有錯誤處理方式為 Form.errAppend(Message) 累計錯誤訊息 */
	        //if (Form.getInput("EDIT", "SYS_CD") == "")
	        //    Form.errAppend("系統編號不可空白!!");
        //    loadind_.showLoadingBar (10, "自定檢核完成");
            /** ================ */
            doSave_end();
		}
	}
}

/** 存檔功能時呼叫結束 */
function doSave_end()
{
	/** 檢核設定欄位*/
	Form.startChkForm("EDIT");

	/** 減核錯誤處理 */
	if (!queryObj.valideMessage (Form))
		return;

	/** = 送出表單 = */
	/** 設定狀態 */
	var	actionMode	=	"";
	if (editMode == "ADD")
		actionMode	=	"ADD_MODE";
	else
		actionMode	=	"EDIT_MODE";

	/** 傳送至後端存檔 */
	var	callBack	=	function doSave_end.callBack(ajaxData)
	{
		if (ajaxData == null)
			return;

		/** 資料新增成功訊息 */
		if (editMode == "ADD")
		{
			/** 設定為新增模式 */
			doAdd();
			Message.openSuccess("A01");
		}
		/** 資料修改成功訊息 */
		else
		{
			//Message.openSuccess("A02", function (){top.hideView();});
			/** nono mark 2006/11/16 */
			//top.mainFrame.iniGrid();
			
			// 自動帶出下一筆的資料		
			/*if(ajaxData.result!=''){			
				_i("EDIT", "NEXT_STU_DATA").value=ajaxData.result;
				getNextStuData();
			}else{*/
				Message.openSuccess("A02");
				top.hideView();				
				top.mainFrame.iniGrid();
			//}			
			_i("EDIT", "NEXT_STU_DATA").value='';
		}
		
		/** 重設 Grid 2006/11/16 nono add, 2007/01/07 調整判斷方式 */
	//	if (chkHasQuery())
	//	{
		//	top.mainFrame.iniGrid();
	//	}
	}
	sendFormData("EDIT", controlPage, actionMode, callBack, "111111")
}

// 修改存檔完後帶下一個學生的資料
function getNextStuData()
{
	/** 開始處理 */
	Message.showProcess();

	/** 送到後端處理 */
	var	callBack	=	function getNextStuData.callBack(ajaxData)
	{	
		if (ajaxData == null|| ajaxData.data.length==0){
			Message.hideProcess();
			return;
        }
		
		for (column in ajaxData.data[0])		
			try{Form.iniFormSet("EDIT",	column, "KV", ajaxData.data[0][column]);}catch(ex){}

		doModify();
		
		// 判斷是否有雙主修的問題
		if(Form.getInput('EDIT', 'ASYS') == "1")
			doSOLCK1();
		else
			_i('EDIT', 'SPECIAL_STUDENT_TMP').value == "";

		/** 停止處理 */
		//by poto 	
		var ndate = DateUtil.getNowDate();
		var age   = DateUtil.getDayDiff(ndate,_i('EDIT', 'BIRTHDATE').value)/365;
		
		age   = Math.floor(age);		
		Form.setInput("EDIT", "AGE",age);
		Message.hideProcess();
	}
	sendFormData("EDIT", controlPage, "EDIT_QUERY_MODE", callBack, "1111");
}

function check()    {

//    if (document.getElementById("PAYMENT_STATUS").selectedIndex==1 || document.getElementById("PAYMENT_STATUS").selectedIndex==0){
//        document.getElementById("PAYMENT_METHOD").selectedIndex = 3;
//        document.getElementById("PAYMENT_METHOD").disabled = true ;
//        document.getElementById("AUDIT_RESULT").selectedIndex = 1;
//        document.getElementById("AUDIT_RESULT").disabled = true ;
//    }else{
//        document.getElementById("PAYMENT_METHOD").disabled = false ;
//        document.getElementById("AUDIT_RESULT").disabled = false ;
//    }

    // if (document.getElementById("HANDICAP_AUDIT_MK").selectedIndex == 2 & StrUtil.trim(document.getElementById("HANDICAP_UNQUAL_REASON").value) == "" ) {
        // alert("請輸入其他原因");
        // Form.iniFormSet('EDIT', 'HANDICAP_UNQUAL_REASON', 'FC');
        // return false ;
    // }
	if(_i('EDIT', 'HANDICAP_AUDIT_MK').value == "1" & StrUtil.trim(document.getElementById("HANDICAP_UNQUAL_REASON").value) == "")
	{
		alert("請輸入身心障礙不符原因");
        Form.iniFormSet('EDIT', 'HANDICAP_UNQUAL_REASON', 'FC');
        return false ;
	}
    // if (document.getElementById("LOW_INCOME_AUDIT").selectedIndex == 2 & StrUtil.trim(document.getElementById("LOW_INCOME_UNQUAL_REASON").value) == "" ) {
        // alert("請輸入其他原因");
        // Form.iniFormSet('EDIT', 'LOW_INCOME_UNQUAL_REASON', 'FC');
        // return false ;
    // }
	if (_i('EDIT', 'LOW_INCOME_AUDIT').value == "1" & StrUtil.trim(document.getElementById("LOW_INCOME_UNQUAL_REASON").value) == "" ) {
        alert("請輸入低收入戶不符原因");
        Form.iniFormSet('EDIT', 'LOW_INCOME_UNQUAL_REASON', 'FC');
        return false ;
    }
    if(_i('EDIT', 'NEW_RESIDENT_AUDIT_MK').value == "1" & StrUtil.trim(document.getElementById("NEW_RESIDENT_UNQUAL_REASON").value) == "")
	{
		alert("請輸入新住民子女不符原因");
        Form.iniFormSet('EDIT', 'NEW_RESIDENT_UNQUAL_REASON', 'FC');
        return false ;
	}
    // if (document.getElementById("CHECK_DOC").selectedIndex == 1 & document.getElementById("DOC_UNQUAL_REASON").value == "" ) {
        // alert("請輸入證件不符原因");
        // Form.iniFormSet('EDIT', 'DOC_UNQUAL_REASON', 'FC');
        // return false ;
    // }
	if (_i('EDIT', 'CHECK_DOC').value == "1" || _i('EDIT', 'CHECK_DOC').value == "2")
	{
		if(StrUtil.trim(document.getElementById("DOC_UNQUAL_REASON").value) == "" )
		{
			alert("請輸入證件不符原因");
			Form.iniFormSet('EDIT', 'DOC_UNQUAL_REASON', 'FC');
			return false ;
		}
    }
 //   if(document.getElementById("CHKPAYMENT").checked & document.getElementById("NPAYMENT_BAR").value=="")
 //   {
 //       alert("請輸入免繳費原因");
 //       Form.iniFormSet('EDIT', 'NPAYMENT_BAR', 'FC');
 //       return false ;
 //   }
    if (document.getElementById("AUDIT_RESULT").value == 1 & document.getElementById("AUDIT_UNQUAL_REASON").value == "" ) {
        alert("請輸入審查未通過原因");
        Form.iniFormSet('EDIT', 'AUDIT_UNQUAL_REASON', 'FC');
        return false ;
    }
	/*
	//中心審查(繳費狀態)
	if (document.getElementById("AUDIT_RESULT").value == 0 & document.getElementById("PAYMENT_STATUS").value != 2)   {
		alert("繳費狀態為'已繳費'，方可通過審查");
		return false ;
    }
	//教務處審查(繳費狀態)
	if (document.getElementById("TOTAL_RESULT").value == 0 & document.getElementById("PAYMENT_STATUS").value != 2)   {
		alert("繳費狀態為'已繳費'，方可通過審查");
		return false ;
    }
	*/
	//中心審查(證件)
	if (document.getElementById("AUDIT_RESULT").value == 0 & document.getElementById("CHECK_DOC").value != 0)   {
		alert("證件正本必須是'通過'，方可通過審查");
		return false ;
    }
	//中心審查(學歷)
	if (document.getElementById("AUDIT_RESULT").value == 0 & _i('EDIT', 'EDUBKGRD_GRADE').value == "")   {
		alert("尚未輸入'最高學歷類別'，請先補登資料，方可通過審查");
		return false ;
    }
	//教務處審查
	// if (document.getElementById("TOTAL_RESULT").value == 0 & document.getElementById("CHECK_DOC").value != 0)   {
		// alert("證件正本必須是'通過'，方可通過審查");
		// return false ;
    // }
	//教務處審查(學歷)
	if (document.getElementById("TOTAL_RESULT").value == 0 & _i('EDIT', 'EDUBKGRD_GRADE').value == "")   {
		alert("尚未輸入'最高學歷類別'，請先補登資料，方可通過審查");
		return false ;
    }
	/** 如為雙主修生 需繳交文件方可通過審查*/
	var tmp_st = _i('EDIT', 'SPECIAL_STUDENT_TMP').value;
	//教務處審查(雙主修)
	if((_i('EDIT', 'TOTAL_RESULT').value == "0" || _i('EDIT', 'TOTAL_RESULT').value == "4") && tmp_st=="2")
	{
		if(document.EDIT.TOTAL_DOC_CHECKBOX.checked==false)
		{
			alert("必須繳交放棄雙主修申請表方可通過審查!!");
			return;
		}
	}
	//中心審查(雙主修)
	if((_i('EDIT', 'AUDIT_RESULT').value == "0" || _i('EDIT', 'AUDIT_RESULT').value == "4") && tmp_st=="2")
	{
		if(document.EDIT.AUDIT_DOC_CHECKBOX.checked==false)
		{
			alert("必須繳交放棄雙主修申請表方可通過審查!!");
			return;
		}
	}
	
	/** **/
	
	
	if(enroll_status == "2" || enroll_status == "4") {
			alert("你非暫予學籍,不可以更改審核結果!");
			return;
	}
	
	/** 如為已經選課的學生  只可以選擇通過*/
	var REG_CHECK = _i('EDIT', 'REG_CHECK').value;
	var aa = <%=session.getAttribute("LOCK")%>;

	if(aa==1){
		//中心審查
		if(REG_CHECK=="N"){
			if(_i('EDIT', 'AUDIT_RESULT').value == "0" || _i('EDIT', 'AUDIT_RESULT').value == "4" ){
				//只能選0 跟 4 ---ok
			}else{
				if(_i('EDIT', 'ENROLL_STATUS').value != "1") {
				//只能選0 跟 4 ---ok
					alert("已選課,只能給予通過!");
					return;
				} 
			}
		}
	}else{
		//教務處審查
		if(REG_CHECK=="N"){
			if(_i('EDIT', 'TOTAL_RESULT').value == "0" || _i('EDIT', 'TOTAL_RESULT').value == "4"){
				//只能選0 跟 4 ---ok
			}else{
				//只能選0 跟 4 ---ok
				alert("已選課,只能給予通過或是待補件!");
				return;
			}
		}
		//中心審查
		if(REG_CHECK=="N"){
			if(_i('EDIT', 'AUDIT_RESULT').value == "0" || _i('EDIT', 'AUDIT_RESULT').value == "4"){
				//只能選0 跟 4 ---ok
			}else{
				//只能選0 跟 4 ---ok
				alert("已選課,只能給予通過或是待補件!");
				return;
				
			}
		}
	
	}
	
    if (document.getElementById("AUDIT_RESULT").value == 0)   {
        Form.setInput("EDIT", "AUDIT_UNQUAL_REASON", "");
    }

    return true ;
}
function doBack()
{
    document.getElementById("PAYMENT_METHOD").disabled = false ;
    document.getElementById("AUDIT_RESULT").disabled = false ;
    document.getElementById("DOC_UNQUAL_REASON").disabled = false ;
	
    /** 關閉新增 Frame */
    top.hideView();
}

// 異動學生資料-->開窗至SOL007M_02V1
function goSol007m02v1(){
	var keyValue = "IDNO_PARAM|" + _i("EDIT", "IDNO").value + 
				  "|BIRTHDATE_PARAM|" + _i("EDIT", "BIRTHDATE").value + 
				  "|ASYS_PARAM|" + _i("EDIT", "ASYS").value + 
				  "|AYEAR_PARAM|" + _i("EDIT", "AYEAR").value + 
				  "|SMS_PARAM|" + _i("EDIT", "SMS").value+
				  "|PRO_CODE|SOL006M";

	//doOpen(keyValue, 1200, 600, "/sol/sol007m_02v1.jsp");
	doOpen(keyValue, 1480, 600, "/sol/sol007m_.jsp");
	getNextStuData();
}

<!-- var	queryKeyStr	=	""; -->
<!-- function doOpen(keyStr, width, height, pageName) -->
<!-- { -->
<!-- 	/** 鍵值 */ -->
<!-- 	if (keyStr == null) -->
<!-- 		keyStr		=	queryKeyStr; -->
<!-- 	else -->
<!-- 		queryKeyStr	=	keyStr; -->

<!-- 	wdith	=	(width == null) ? 800 : width; -->
<!-- 	height	=	(height == null) ? 600 : height; -->

<!-- 	/** 將 Key 組在 URL 後面帶入 */ -->
<!-- 	var	keyAry		=	keyStr.split("|"); -->
<!-- 	var	keyUrlBuff	=	new StringBuffer(); -->

<!-- 	for (var i = 0; i < keyAry.length; i += 2) -->
<!-- 	{ -->
<!-- 		if (i == 0) -->
<!-- 			keyUrlBuff.append ("?" + keyAry[i] + "=" + StrUtil.urlEncode(keyAry[i + 1])); -->
<!-- 		else -->
<!-- 			keyUrlBuff.append ("&" + keyAry[i] + "=" + StrUtil.urlEncode(keyAry[i + 1])); -->
<!-- 	} -->

<!-- 	/** 2006/12/07 新增可自訂傳入頁面, 不傳預設為 c1 設定頁面 */ -->
<!-- 	if (pageName == null) -->
<!-- 		pageName	=	detailPage; -->

<!-- 	/** 2006/12/4 解決傳空字串有 Bug 的問題 */ -->
<!-- 	var	openUrl	=	""; -->
<!-- 	if (keyStr == '' && queryKeyStr == '') -->
<!-- 		openUrl	=	_vp + "mainframe_open.jsp?mainPage=" + StrUtil.urlEncode(pageName); -->
<!-- 	else -->
<!-- 		openUrl	=	_vp + "mainframe_open.jsp?mainPage=" + StrUtil.urlEncode(pageName) + "&keyParam=" + StrUtil.urlEncode(keyUrlBuff.toString()); -->

<!-- 	//WindowUtil.openObjDialog (openUrl, wdith, height, self); -->
<!-- 	window.open(openUrl, wdith, height, self); -->
<!-- } -->

/** ============================= 欲修正程式放置區 ======================================= */
/** 設定功能權限 */
function securityCheck()
{
    try
    {
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
        if (<%=AUTICFM.securityCheck (session, "EXP")%>)
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


function doCheckEnrollStatus() {
	
	if(_i('EDIT', 'STNO').value != "") {
	
		var    callBack    =    function doCheckEnrollStatus.callBack(ajaxData) {
	
		enroll_status = ajaxData.data[0].ENROLL_STATUS;
		doSave();
	    return;
	    }
	    sendFormData("EDIT", controlPage, "ENROLL", callBack);
	} else {
		doSave();
	}
	
}

function getIdnoType() {	
	var    callBack    =    function getIdnoType.callBack(ajaxData) {
		if (ajaxData == null){
			alert('ajax data = null ');
			return;
        }
        
       // if (ajaxData.data.length == 0){
	   //確認一下是不是新住民
	   //	checkIdType3();
       // } else {
       // 	document.getElementById('idnoType').innerText = '居留身分';
       //}
	}
	sendFormData("EDIT", "/sol/sol005m_01c2.jsp", "IDNO_GET_SEX", callBack);
	
}

function checkIdType3() {
	var    callBack    =    function checkIdType3.callBack(ajaxData) {
		if (ajaxData == null){
			return;
       	}
       	if (ajaxData.data.length != 0){
       		document.getElementById('idnoType').innerText = '新住民';
       	} else {
       		document.getElementById('idnoType').innerText = '中華民國身分';
       	}
	}
	
	sendFormData("EDIT", "/sol/sol005m_01c2.jsp", "CHECK_IDTYPE3", callBack);
}


