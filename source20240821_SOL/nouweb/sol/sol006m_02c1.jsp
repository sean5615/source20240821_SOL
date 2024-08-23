<%/* 
----------------------------------------------------------------------------------
File Name        : sol006m_02c1
Author            : ����L
Description        : SOL006M_�n�����W�f�d���G - �s�豱��� (javascript)
Modification Log    :

Vers        Date           By                Notes
--------------    --------------    --------------    ----------------------------------
0.0.1        096/01/25    ����L        Code Generate Create
----------------------------------------------------------------------------------
*/%>
<%@ page contentType="text/html; charset=UTF-8" errorPage="/utility/errorpage.jsp" pageEncoding="MS950"%>
<%@ include file="/utility/header.jsp"%>
<%@ include file="/utility/jspageinit.jsp"%>

/** �פJ javqascript Class */
doImport ("ErrorHandle.js, LoadingBar_0_2.js, Form.js, Ajax_0_2.js, ArrayUtil.js");

/** ��l�]�w������T */
var    currPage        =    "<%=request.getRequestURI()%>";
var    printPage        =    "/sol/sol006m_01p1.htm";    //�C�L����
var    editMode        =    "ADD";                //�s��Ҧ�, ADD - �s�W, MOD - �ק�
var    _privateMessageTime    =    -1;                //�T����ܮɶ�(���ۭq�� -1)
var    controlPage        =    "/sol/sol006m_01c2.jsp";    //�����
var    queryObj        =    new queryObj();            //�d�ߤ���
var enroll_status = "";


/** ������l�� */
function page_init()
{
    page_init_start_2();

    /** === ��l���]�w === */
    /** ��l�s����� */
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

    loadind_.showLoadingBar (15, "��l��짹��");
    /** ================ */

    /** === �]�w�ˮֱ��� === */
    /** �s����� */
//    Form.iniFormSet('EDIT', 'PAYMENT_METHOD', 'AA', 'chkForm', 'ú�O�覡');

    loadind_.showLoadingBar (20, "�]�w�ˮֱ��󧹦�");
    /** ================ */

    page_init_end_2();
    
}

/** �s�W�\��ɩI�s */
function doAdd()
{
    doAdd_start();

    /** �M����Ū����(KEY)*/
    Form.iniFormSet('EDIT', 'IDNO', 'R', 0);
    Form.iniFormSet('EDIT', 'BIRTHDATE', 'R', 0);


    /** ��l�W�h�a�Ӫ� Key ��� */
    iniMasterKeyColumn();

    /** �]�w Focus */
    Form.iniFormSet('EDIT', 'IDNO', 'FC');

    /** ��l�� Form �C�� */
    Form.iniFormColor();

    /** ����B�z */
    queryObj.endProcess ("�s�W���A����");
}

/** ��ܨ�L�ɡA��ܵ��O�T��*/
function changeMessage()
{
	if(_i('EDIT', 'HANDICAP_AUDIT_MK').value == "2")
		document.getElementById("HANDICAP_AUDIT_MK2").innerHTML  = "<font size='2'><b>����L��L���߻�ê�ӽ�</b></font>";
	else
		document.getElementById("HANDICAP_AUDIT_MK2").innerHTML  = "";
}

/** ��ܨ�L�ɡA��ܵ��O�T��*/
function changeMessage2()
{
	if(_i('EDIT', 'LOW_INCOME_AUDIT').value == "2")
		document.getElementById("LOW_INCOME_AUDIT2").innerHTML  = "<font size='2'><b>����L��L�C���J��ӽ�</b></font>";
	else
		document.getElementById("LOW_INCOME_AUDIT2").innerHTML  = "";
}

/** �ק�\��ɩI�s */
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

    /** �]�w�ק�Ҧ� */
    editMode        =    "UPD";
    EditStatus.innerHTML    =    "�ק�";

    /** �M����Ū����(KEY)*/
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
	// �������O�������Y�����  aa=1 ��ܤ���
	if(aa==1){
        Form.iniFormSet('EDIT', 'PAYMENT_STATUS', 'R', 1);
        Form.iniFormSet('EDIT', 'PAYMENT_METHOD', 'R', 1);
        Form.iniFormSet('EDIT', 'TOTAL_RESULT' , 'R' , 1);
        document.getElementById("PAYMENT_STATUS").disabled = true;
        document.getElementById("PAYMENT_METHOD").disabled = true;
        document.getElementById("TOTAL_RESULT").disabled = true;
		
		// �u�n�Kú�O���ȩάOú�O���A����ú�O���i��J�Kú�O��]
		//var isDisabled = _i("EDIT","NPAYMENT_BAR").value!=''||_i("EDIT","PAYMENT_STATUS").value=='1';
		// �u�n�w��I�B����b�帹�A�����i��J�Kú�O��]
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
	// �u�n�Kú�O���ȩάOú�O���A����ú�O���i��J�Kú�O��]
	var isDisabled = _i("EDIT","NPAYMENT_BAR").value!=''||_i("EDIT","PAYMENT_STATUS").value=='1';
	// �u�n�w��I�B����b�帹�A�����i��J�Kú�O��]
	if (_i("EDIT","BATNUM").value != ''){
	   document.EDIT.CHKPAYMENT.disabled=true;
	   document.EDIT.NPAYMENT_BAR.disabled=true;
	}else{
	   document.EDIT.NPAYMENT_BAR.disabled=false;
	   document.EDIT.CHKPAYMENT.disabled=!isDisabled;
	   Form.iniFormSet('EDIT', 'NPAYMENT_BAR', 'R', (document.getElementById("CHKPAYMENT").checked?0:1));
	}
	_i("EDIT","BEFORE_NPAYMENT_BAR").value = _i("EDIT","NPAYMENT_BAR").value;

    /** ��l�� Form �C�� */
    Form.iniFormColor();

        // if (document.getElementById("DRAFT_NO").value != null)  {
            // var a = new String();
            // a = document.getElementById("DRAFT_NO").value;
            // document.getElementById("DRAFT_NO1").value = a.substring(0,9);
            // document.getElementById("DRAFT_NO2").value = a.charAt(9);
        // }

    /** �]�w Focus */
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
	        //���D�ץ�
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
			/** ��l�� Form �C�� */
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
���U�s��ɩI�s
@param	args[0]	��ưѼ�, �ܼƦW�� (KEY)
@param	args[1]	���ưѼ�, �ܼƭ� (KEY)
*/
function doEdit_2(arguments)
{
	/** �}�l�B�z */
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
	
	// �쥻�S�����ݨ��o���,�ثe�]�B�~�h�F�X�����(ex:�a�}/�q��...)�b�o���o,��L���@�ˤ��b�o���,�]�쥻�N�Qmark
	/** �e���ݳB�z */
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
		/** ����B�z */		
	}
	sendFormData("EDIT", controlPage, "EDIT_QUERY_MODE", callBack);
}
/** �s�ɥ\��ɩI�s */
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

	                /** �P�_�s�W�L�v�����B�z */
	                if (editMode == "NONE")
	                        return;

	                /** === �۩w�ˬd === */
	           //     loadind_.showLoadingBar (8, "�۩w�ˮֶ}�l");

	                /** ����ˮ֤γ]�w, �����~�B�z�覡�� Form.errAppend(Message) �֭p���~�T�� */
	                //if (Form.getInput("EDIT", "SYS_CD") == "")
	                //    Form.errAppend("�t�νs�����i�ť�!!");

	            //    loadind_.showLoadingBar (10, "�۩w�ˮ֧���");
	                /** ================ */

	                doSave_end();
	            }else{
					doSave_start();

	                /** �P�_�s�W�L�v�����B�z */
	                if (editMode == "NONE")
	                        return;

	                /** === �۩w�ˬd === */
	             //   loadind_.showLoadingBar (8, "�۩w�ˮֶ}�l");

	                /** ����ˮ֤γ]�w, �����~�B�z�覡�� Form.errAppend(Message) �֭p���~�T�� */
	                //if (Form.getInput("EDIT", "SYS_CD") == "")
	                //    Form.errAppend("�t�νs�����i�ť�!!");
					Form.errAppend("�п�J���T�ײ����X(11�X)");

	             //   loadind_.showLoadingBar (10, "�۩w�ˮ֧���");
	                /** ================ */

	                doSave_end();
				}
			}else{
				doSave_start();
                /** �P�_�s�W�L�v�����B�z */
	            if (editMode == "NONE")
	                return;
                /** === �۩w�ˬd === */
	      //      loadind_.showLoadingBar (8, "�۩w�ˮֶ}�l");
                /** ����ˮ֤γ]�w, �����~�B�z�覡�� Form.errAppend(Message) �֭p���~�T�� */
	            //if (Form.getInput("EDIT", "SYS_CD") == "")
	            //    Form.errAppend("�t�νs�����i�ť�!!");
           //     loadind_.showLoadingBar (10, "�۩w�ˮ֧���");
	            /** ================ */
                doSave_end();
			}             
		}else{
			doSave_start();
			/** �P�_�s�W�L�v�����B�z */
			if (editMode == "NONE")
				return;

	        /** === �۩w�ˬd === */
	     //   loadind_.showLoadingBar (8, "�۩w�ˮֶ}�l");
			/** ����ˮ֤γ]�w, �����~�B�z�覡�� Form.errAppend(Message) �֭p���~�T�� */
	        //if (Form.getInput("EDIT", "SYS_CD") == "")
	        //    Form.errAppend("�t�νs�����i�ť�!!");
        //    loadind_.showLoadingBar (10, "�۩w�ˮ֧���");
            /** ================ */
            doSave_end();
		}
	}
}

/** �s�ɥ\��ɩI�s���� */
function doSave_end()
{
	/** �ˮֳ]�w���*/
	Form.startChkForm("EDIT");

	/** ��ֿ��~�B�z */
	if (!queryObj.valideMessage (Form))
		return;

	/** = �e�X��� = */
	/** �]�w���A */
	var	actionMode	=	"";
	if (editMode == "ADD")
		actionMode	=	"ADD_MODE";
	else
		actionMode	=	"EDIT_MODE";

	/** �ǰe�ܫ�ݦs�� */
	var	callBack	=	function doSave_end.callBack(ajaxData)
	{
		if (ajaxData == null)
			return;

		/** ��Ʒs�W���\�T�� */
		if (editMode == "ADD")
		{
			/** �]�w���s�W�Ҧ� */
			doAdd();
			Message.openSuccess("A01");
		}
		/** ��ƭק令�\�T�� */
		else
		{
			//Message.openSuccess("A02", function (){top.hideView();});
			/** nono mark 2006/11/16 */
			//top.mainFrame.iniGrid();
			
			// �۰ʱa�X�U�@�������		
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
		
		/** ���] Grid 2006/11/16 nono add, 2007/01/07 �վ�P�_�覡 */
	//	if (chkHasQuery())
	//	{
		//	top.mainFrame.iniGrid();
	//	}
	}
	sendFormData("EDIT", controlPage, actionMode, callBack, "111111")
}

// �ק�s�ɧ���a�U�@�Ӿǥͪ����
function getNextStuData()
{
	/** �}�l�B�z */
	Message.showProcess();

	/** �e���ݳB�z */
	var	callBack	=	function getNextStuData.callBack(ajaxData)
	{	
		if (ajaxData == null|| ajaxData.data.length==0){
			Message.hideProcess();
			return;
        }
		
		for (column in ajaxData.data[0])		
			try{Form.iniFormSet("EDIT",	column, "KV", ajaxData.data[0][column]);}catch(ex){}

		doModify();
		
		// �P�_�O�_�����D�ת����D
		if(Form.getInput('EDIT', 'ASYS') == "1")
			doSOLCK1();
		else
			_i('EDIT', 'SPECIAL_STUDENT_TMP').value == "";

		/** ����B�z */
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
        // alert("�п�J��L��]");
        // Form.iniFormSet('EDIT', 'HANDICAP_UNQUAL_REASON', 'FC');
        // return false ;
    // }
	if(_i('EDIT', 'HANDICAP_AUDIT_MK').value == "1" & StrUtil.trim(document.getElementById("HANDICAP_UNQUAL_REASON").value) == "")
	{
		alert("�п�J���߻�ê���ŭ�]");
        Form.iniFormSet('EDIT', 'HANDICAP_UNQUAL_REASON', 'FC');
        return false ;
	}
    // if (document.getElementById("LOW_INCOME_AUDIT").selectedIndex == 2 & StrUtil.trim(document.getElementById("LOW_INCOME_UNQUAL_REASON").value) == "" ) {
        // alert("�п�J��L��]");
        // Form.iniFormSet('EDIT', 'LOW_INCOME_UNQUAL_REASON', 'FC');
        // return false ;
    // }
	if (_i('EDIT', 'LOW_INCOME_AUDIT').value == "1" & StrUtil.trim(document.getElementById("LOW_INCOME_UNQUAL_REASON").value) == "" ) {
        alert("�п�J�C���J�ᤣ�ŭ�]");
        Form.iniFormSet('EDIT', 'LOW_INCOME_UNQUAL_REASON', 'FC');
        return false ;
    }
    if(_i('EDIT', 'NEW_RESIDENT_AUDIT_MK').value == "1" & StrUtil.trim(document.getElementById("NEW_RESIDENT_UNQUAL_REASON").value) == "")
	{
		alert("�п�J�s����l�k���ŭ�]");
        Form.iniFormSet('EDIT', 'NEW_RESIDENT_UNQUAL_REASON', 'FC');
        return false ;
	}
    // if (document.getElementById("CHECK_DOC").selectedIndex == 1 & document.getElementById("DOC_UNQUAL_REASON").value == "" ) {
        // alert("�п�J�ҥ󤣲ŭ�]");
        // Form.iniFormSet('EDIT', 'DOC_UNQUAL_REASON', 'FC');
        // return false ;
    // }
	if (_i('EDIT', 'CHECK_DOC').value == "1" || _i('EDIT', 'CHECK_DOC').value == "2")
	{
		if(StrUtil.trim(document.getElementById("DOC_UNQUAL_REASON").value) == "" )
		{
			alert("�п�J�ҥ󤣲ŭ�]");
			Form.iniFormSet('EDIT', 'DOC_UNQUAL_REASON', 'FC');
			return false ;
		}
    }
 //   if(document.getElementById("CHKPAYMENT").checked & document.getElementById("NPAYMENT_BAR").value=="")
 //   {
 //       alert("�п�J�Kú�O��]");
 //       Form.iniFormSet('EDIT', 'NPAYMENT_BAR', 'FC');
 //       return false ;
 //   }
    if (document.getElementById("AUDIT_RESULT").value == 1 & document.getElementById("AUDIT_UNQUAL_REASON").value == "" ) {
        alert("�п�J�f�d���q�L��]");
        Form.iniFormSet('EDIT', 'AUDIT_UNQUAL_REASON', 'FC');
        return false ;
    }
	/*
	//���߼f�d(ú�O���A)
	if (document.getElementById("AUDIT_RESULT").value == 0 & document.getElementById("PAYMENT_STATUS").value != 2)   {
		alert("ú�O���A��'�wú�O'�A��i�q�L�f�d");
		return false ;
    }
	//�аȳB�f�d(ú�O���A)
	if (document.getElementById("TOTAL_RESULT").value == 0 & document.getElementById("PAYMENT_STATUS").value != 2)   {
		alert("ú�O���A��'�wú�O'�A��i�q�L�f�d");
		return false ;
    }
	*/
	//���߼f�d(�ҥ�)
	if (document.getElementById("AUDIT_RESULT").value == 0 & document.getElementById("CHECK_DOC").value != 0)   {
		alert("�ҥ󥿥������O'�q�L'�A��i�q�L�f�d");
		return false ;
    }
	//���߼f�d(�Ǿ�)
	if (document.getElementById("AUDIT_RESULT").value == 0 & _i('EDIT', 'EDUBKGRD_GRADE').value == "")   {
		alert("�|����J'�̰��Ǿ����O'�A�Х��ɵn��ơA��i�q�L�f�d");
		return false ;
    }
	//�аȳB�f�d
	// if (document.getElementById("TOTAL_RESULT").value == 0 & document.getElementById("CHECK_DOC").value != 0)   {
		// alert("�ҥ󥿥������O'�q�L'�A��i�q�L�f�d");
		// return false ;
    // }
	//�аȳB�f�d(�Ǿ�)
	if (document.getElementById("TOTAL_RESULT").value == 0 & _i('EDIT', 'EDUBKGRD_GRADE').value == "")   {
		alert("�|����J'�̰��Ǿ����O'�A�Х��ɵn��ơA��i�q�L�f�d");
		return false ;
    }
	/** �p�����D�ץ� ��ú�����i�q�L�f�d*/
	var tmp_st = _i('EDIT', 'SPECIAL_STUDENT_TMP').value;
	//�аȳB�f�d(���D��)
	if((_i('EDIT', 'TOTAL_RESULT').value == "0" || _i('EDIT', 'TOTAL_RESULT').value == "4") && tmp_st=="2")
	{
		if(document.EDIT.TOTAL_DOC_CHECKBOX.checked==false)
		{
			alert("����ú�������D�ץӽЪ��i�q�L�f�d!!");
			return;
		}
	}
	//���߼f�d(���D��)
	if((_i('EDIT', 'AUDIT_RESULT').value == "0" || _i('EDIT', 'AUDIT_RESULT').value == "4") && tmp_st=="2")
	{
		if(document.EDIT.AUDIT_DOC_CHECKBOX.checked==false)
		{
			alert("����ú�������D�ץӽЪ��i�q�L�f�d!!");
			return;
		}
	}
	
	/** **/
	
	
	if(enroll_status == "2" || enroll_status == "4") {
			alert("�A�D�Ȥ����y,���i�H���f�ֵ��G!");
			return;
	}
	
	/** �p���w�g��Ҫ��ǥ�  �u�i�H��ܳq�L*/
	var REG_CHECK = _i('EDIT', 'REG_CHECK').value;
	var aa = <%=session.getAttribute("LOCK")%>;

	if(aa==1){
		//���߼f�d
		if(REG_CHECK=="N"){
			if(_i('EDIT', 'AUDIT_RESULT').value == "0" || _i('EDIT', 'AUDIT_RESULT').value == "4" ){
				//�u���0 �� 4 ---ok
			}else{
				if(_i('EDIT', 'ENROLL_STATUS').value != "1") {
				//�u���0 �� 4 ---ok
					alert("�w���,�u�൹���q�L!");
					return;
				} 
			}
		}
	}else{
		//�аȳB�f�d
		if(REG_CHECK=="N"){
			if(_i('EDIT', 'TOTAL_RESULT').value == "0" || _i('EDIT', 'TOTAL_RESULT').value == "4"){
				//�u���0 �� 4 ---ok
			}else{
				//�u���0 �� 4 ---ok
				alert("�w���,�u�൹���q�L�άO�ݸɥ�!");
				return;
			}
		}
		//���߼f�d
		if(REG_CHECK=="N"){
			if(_i('EDIT', 'AUDIT_RESULT').value == "0" || _i('EDIT', 'AUDIT_RESULT').value == "4"){
				//�u���0 �� 4 ---ok
			}else{
				//�u���0 �� 4 ---ok
				alert("�w���,�u�൹���q�L�άO�ݸɥ�!");
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
	
    /** �����s�W Frame */
    top.hideView();
}

// ���ʾǥ͸��-->�}����SOL007M_02V1
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
<!-- 	/** ��� */ -->
<!-- 	if (keyStr == null) -->
<!-- 		keyStr		=	queryKeyStr; -->
<!-- 	else -->
<!-- 		queryKeyStr	=	keyStr; -->

<!-- 	wdith	=	(width == null) ? 800 : width; -->
<!-- 	height	=	(height == null) ? 600 : height; -->

<!-- 	/** �N Key �զb URL �᭱�a�J */ -->
<!-- 	var	keyAry		=	keyStr.split("|"); -->
<!-- 	var	keyUrlBuff	=	new StringBuffer(); -->

<!-- 	for (var i = 0; i < keyAry.length; i += 2) -->
<!-- 	{ -->
<!-- 		if (i == 0) -->
<!-- 			keyUrlBuff.append ("?" + keyAry[i] + "=" + StrUtil.urlEncode(keyAry[i + 1])); -->
<!-- 		else -->
<!-- 			keyUrlBuff.append ("&" + keyAry[i] + "=" + StrUtil.urlEncode(keyAry[i + 1])); -->
<!-- 	} -->

<!-- 	/** 2006/12/07 �s�W�i�ۭq�ǤJ����, ���ǹw�]�� c1 �]�w���� */ -->
<!-- 	if (pageName == null) -->
<!-- 		pageName	=	detailPage; -->

<!-- 	/** 2006/12/4 �ѨM�ǪŦr�꦳ Bug �����D */ -->
<!-- 	var	openUrl	=	""; -->
<!-- 	if (keyStr == '' && queryKeyStr == '') -->
<!-- 		openUrl	=	_vp + "mainframe_open.jsp?mainPage=" + StrUtil.urlEncode(pageName); -->
<!-- 	else -->
<!-- 		openUrl	=	_vp + "mainframe_open.jsp?mainPage=" + StrUtil.urlEncode(pageName) + "&keyParam=" + StrUtil.urlEncode(keyUrlBuff.toString()); -->

<!-- 	//WindowUtil.openObjDialog (openUrl, wdith, height, self); -->
<!-- 	window.open(openUrl, wdith, height, self); -->
<!-- } -->

/** ============================= ���ץ��{����m�� ======================================= */
/** �]�w�\���v�� */
function securityCheck()
{
    try
    {
        /** �s�W */
        if (!<%=AUTICFM.securityCheck (session, "ADD")%>)
        {
            noPermissAry[noPermissAry.length]    =    "ADD";
            editMode    =    "NONE";
            try{Form.iniFormSet("EDIT", "ADD_BTN", "D", 1);}catch(ex){}
        }
        /** �ק� */
        if (!<%=AUTICFM.securityCheck (session, "UPD")%>)
        {
            noPermissAry[noPermissAry.length]    =    "UPD";
        }
        /** �s�W�έק� */
        if (!chkSecure("ADD") && !chkSecure("UPD"))
        {
            try{Form.iniFormSet("EDIT", "SAVE_BTN", "D", 1);}catch(ex){}
        }
        /** �R�� */
        if (!<%=AUTICFM.securityCheck (session, "DEL")%>)
        {
            noPermissAry[noPermissAry.length]    =    "DEL";
            try{Form.iniFormSet("RESULT", "DEL_BTN", "D", 1);}catch(ex){}
        }
        /** �ץX */
        if (<%=AUTICFM.securityCheck (session, "EXP")%>)
        {
            noPermissAry[noPermissAry.length]    =    "EXP";
            try{Form.iniFormSet("RESULT", "EXPORT_BTN", "D", 1);}catch(ex){}
            try{Form.iniFormSet("QUERY", "EXPORT_ALL_BTN", "D", 1);}catch(ex){}
        }
        /** �C�L */
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

/** �ˬd�v�� - ���v��/�L�v��(true/false) */
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
	   //�T�{�@�U�O���O�s���
	   //	checkIdType3();
       // } else {
       // 	document.getElementById('idnoType').innerText = '�~�d����';
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
       		document.getElementById('idnoType').innerText = '�s���';
       	} else {
       		document.getElementById('idnoType').innerText = '���إ��ꨭ��';
       	}
	}
	
	sendFormData("EDIT", "/sol/sol005m_01c2.jsp", "CHECK_IDTYPE3", callBack);
}


