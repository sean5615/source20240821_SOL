<%/*  
----------------------------------------------------------------------------------
File Name        : sol051m_01c1
Author            : ����L
Description        : SOL051M_�n�����W�ǥ͸�� - ����� (javascript)
Modification Log    :

Vers        Date           By                Notes
--------------    --------------    --------------    ----------------------------------
0.0.1        096/02/27    ����L        Code Generate Create
----------------------------------------------------------------------------------
*/%>
<%@ page contentType="text/html; charset=UTF-8" errorPage="/utility/errorpage.jsp" pageEncoding="MS950"%>
<%@ include file="/utility/header.jsp"%>
<%@ include file="/utility/jspageinit.jsp"%>

/** �פJ javqascript Class */
doImport ("Query.js, ErrorHandle.js, LoadingBar_0_2.js, Form.js, Ajax_0_2.js, ArrayUtil.js, ReSize.js, SortTable.js");

/** ��l�]�w������T */
var    printPage        =    "/sol/sol005m_01p1.jsp";    //�C�L����
var    editMode        =    "ADD";                //�s��Ҧ�, ADD - �s�W, MOD - �ק�
var    lockColumnCount        =    -1;                //��w����
var    listShow        =    false;                //�O�_�@�i�J��ܸ��
var    _privateMessageTime    =    -1;                //�T����ܮɶ�(���ۭq�� -1)
var    pageRangeSize        =    10;                //�e���@����ܴX�����
var    controlPage        =    "/sol/sol0051_01c2.jsp";    //�����
var    checkObj        =    new checkObj();            //�ֿ露��
var    queryObj        =    new queryObj();            //�d�ߤ���
var    importSelect        =    false;                //�פJ������\��
var    noPermissAry        =    new Array();            //�S���v�����}�C
var SAVE_TYPEv = "0";

/** ������l�� */
function page_init1()
{

    /** ��l�W�h�a�Ӫ� Key ��� */
    iniMasterKeyColumn();
    document.getElementById("PRE_MAJOR_FACULTY").disabled=true ;		//���}��
    if(Form.getInput("EDIT","ASYS")=="2"){
        document.getElementById("PRE_MAJOR_FACULTY").disabled=false ;		//���}��
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

    /** �ץ��Y���}���۰ʱa�X */
//    Form.iniFormSet('EDIT', 'ASYS', 'KV', ASYS1 , 'R', 1);
//    Form.iniFormSet('EDIT', 'CENTER_CODE', 'KV', CENTER_CODE1 , 'R', 1);
//    Form.iniFormSet('EDIT', 'STTYPE', 'KV', STTYPE1 , 'R', 1);
//    _i("EDIT", "ASYS").fireEvent("onblur");
//    _i("EDIT", "CENTER_CODE").fireEvent("onblur");
//    _i("EDIT", "STTYPE").fireEvent("onblur");

    //alert("1");
    //document.getElementById("QUERY").style.display = "none";
    page_init_start_2();

    /** === ��l���]�w === */
    /** ��l�s����� */
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

    loadind_.showLoadingBar (15, "��l��짹��");
    /** ================ */
//    Form.iniFormSet('QUERY', 'IDNO', 'M',  10, 'A', 'I', 'U', 'R', '0');
//    Form.iniFormSet('QUERY', 'BIRTHDATE', 'M',  8, 'A', 'DT', 'R', '0');
    /** === �]�w�ˮֱ��� === */
    /** �s����� */
    Form.iniFormSet('EDIT', 'EDUBKGRD_GRADE', 'AA', 'chkForm', '�̰��Ǿ����O');
    Form.iniFormSet('EDIT', 'PRE_MAJOR_FACULTY', 'AA', 'chkForm', '�w�w�D�׾Ǩt');
    //Form.iniFormSet('EDIT', 'GETINFO', 'AA', 'chkForm', '��o�Ťj�ۥͨӷ�');
    Form.iniFormSet('EDIT', 'CENTER_CODE', 'AA', 'chkForm', '���W�ǲ߫��ɤ���');
    Form.iniFormSet('EDIT', 'STTYPE', 'AA', 'chkForm', '���W�����O');
    Form.iniFormSet('EDIT', 'NAME', 'M',  10,'AA', 'chkForm', '�m�W');
    Form.iniFormSet('EDIT', 'SEX', 'AA', 'chkForm', '�ʧO');
    Form.iniFormSet('EDIT', 'NATIONCODE', 'AA', 'chkForm', '���y�O');
    //Form.iniFormSet('EDIT', 'NEWNATION', 'AA', 'chkForm', '�s�������y�O');
    Form.iniFormSet('EDIT', 'CRRSADDR', 'M',  50,'AA', 'chkForm', '�q�T�a�}');
    Form.iniFormSet('EDIT','DMSTADDR_ZIP', 'M',  5,'AA', 'chkForm', '�q�T�ϽX');
    Form.iniFormSet('EDIT','CRRSADDR_ZIP', 'M',  5,'AA', 'chkForm', '���y�ϽX');
    Form.iniFormSet('EDIT', 'DMSTADDR', 'M',  50,'AA', 'chkForm', '���y�a�}');
    Form.iniFormSet('EDIT', 'EMAIL', 'M',  30,'AA', 'chkForm', '�ӤH�q�l�H�c�A�p�G�S���ӤH�q�l�H�c�A�ж�g�u0@0.0�v');
    Form.iniFormSet('EDIT', 'MOBILE','M',  10, 'AA', 'chkForm', '��ʹq�ܡA�p�G�S���ӤH����A�ж�g�u0000�v');
    Form.iniFormSet('EDIT', 'TUTOR_CLASS_MK', 'AA', 'chkForm', '�O�_�ѥ[�ɮv�Z');
    Form.iniFormSet('EDIT', 'EMRGNCY_NAME', 'M',  6,'AA', 'chkForm', '����p���H');
    Form.iniFormSet('EDIT', 'EMRGNCY_TEL','M',  17, 'AA', 'chkForm', '����p���H�q��');
    Form.iniFormSet('EDIT', 'EMRGNCY_RELATION', 'M',  10,'AA', 'chkForm', '����p���H���Y');
    Form.iniFormSet('EDIT', 'EMRGNCY_EMAIL','AA', 'chkForm', '����p���q�l�H�c');
    Form.iniFormSet('EDIT', 'DOC_AGREE_MK', 'AA', 'chkForm', '�P�N����');

//    Form.iniFormSet('EDIT', 'SCHOOL_NAME_OLD', 'M',  25,'AA', 'chkForm', '��ǮզW��');
//    Form.iniFormSet('EDIT', 'FACULTY_OLD', 'M',  25,'AA', 'chkForm', '���t');
//    Form.iniFormSet('EDIT', 'GRADE_OLD', 'M',  1,'AA', 'chkForm', '��~��');
//    Form.iniFormSet('EDIT', 'STNO_OLD', 'M',  20,'AA', 'chkForm', '��Ǹ�');
    //Form.iniFormSet('EDIT', 'REG_FEE', 'M',  6, 'A', 'N1','AA', 'chkForm', '���W�O�G');

    loadind_.showLoadingBar (20, "�]�w�ˮֱ��󧹦�");
    /** ================ */
    Form.iniFormColor();
    queryObj.endProcess ("���A����");
    //page_init_end_2();
    
    //var    gridObj    =    new Grid();
    //Query.setGridEvent(gridObj.scrollSize);
    doLock(Form.getInput("EDIT", "HANDICAP_TYPE"));
    //checkGETINFO();
    
}

/** ��l�W�h�a�Ӫ� Key ��� */
function iniMasterKeyColumn()
{
	/** �D Detail �������B�z */
	if (typeof(keyObj) == "undefined")
		return;
	/** ��� */
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
		//Form.setInput("EDIT", "edubkgrd1", "��ߪŤ��j��");
		//Form.setInput("EDIT", "edubkgrd2", "���~");
	//}
	
	/** �ǰe�ܫ�ݦs�� */
    var    callBack    =    function iniMasterKeyColumn.callBack(ajaxData)
    {
        if (ajaxData == null)
            return;

		if(ajaxData.result == "Y") {
			Form.setInput("EDIT", "edubkgrd1", "��ߪŤ��j��");
			Form.setInput("EDIT", "edubkgrd2", "���~");	
		}
        
    }
    sendFormData("EDIT", controlPage, "GET_GRAT003_CHECK", callBack)
	
	
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

/** �ק�\��ɩI�s */
function doModify()
{
    var edu = document.getElementById("EDUBKGRD").value;
    document.getElementById("EDUBKGRD").value = edu.split(",")[0];
    document.getElementById("EDUBKGRD1").value = edu.split(",")[1];
    document.getElementById("aaa").value = edu.split(",")[2];
    /** �]�w�ק�Ҧ� */
    editMode        =    "UPD";
    EditStatus.innerHTML    =    "�ק�";

    /** �M����Ū����(KEY)*/
    Form.iniFormSet('EDIT', 'IDNO', 'R', 1);
    Form.iniFormSet('EDIT', 'BIRTHDATE', 'R', 1);

	//���oGETINFO_TMP����
	//var checkBoxValue=_i("EDIT", "GETINFO_TMP").value;
    //var len = _i("EDIT", "GETINFO").length ;
    //for(var i=0;i<len;i++){
	//	_i("EDIT", "GETINFO")[i].checked = false;
	//}	
	
	// �@�Ӱj���ܬY���Ŀ諸��
	if(checkBoxValue!='')//�P�_---"�ư���o�Ťj�ۥͰT���ӷ�"����A�����Ū�
	{
		var a = checkBoxValue.split(",");
		for(var i=0;i<a.length;i++){
			document.getElementById("GETINFO_"+a[i]).checked = true;
		}
	}


    /** ��l�� Form �C�� */
    Form.iniFormColor();

    /** �]�w Focus */
    Form.iniFormSet('EDIT', 'CENTER_CODE', 'FC');
}

/** �s�ɥ\��ɩI�s */
function doSave1()
{
	document.forms["EDIT"].elements["SMS"].disabled = false;
	//document.forms["EDIT"].elements["SEX"].disabled = false;
	if(Form.getInput("EDIT", "SPECIAL_STUDENT") == "5"){
    	if(Form.getInput("EDIT", "STTYPE") == "2"){
    		alert("�ѩ�z�O��ץͭ׺�40�Ǥ��A���W�����O���i���u��ץ͡v�I");
    		return;
    	}
    }
	/*
	if(D_NO != ""){
    	if(D_NO.length != 11)
		{
			alert("�ײ����X��������11�X�I");
    		return;
		}
    }
	*/
	if(Form.getInput("EDIT", "STTYPE") == "1"){
    	var EDU = Form.getInput("EDIT", "EDUBKGRD_GRADE");
		if(EDU < '03'){
			alert("���W�Ťj���ץ�\"�J�ǾǾ����O\"���������H�W�I");
	    	return;
		}
	}
	
	if(Form.getInput("EDIT", "ASYS") == "2"){
    	var EDU = Form.getInput("EDIT", "EDUBKGRD_GRADE");
		if(EDU < '03'){
			alert("���W�űM\"�J�ǾǾ����O\"���������H�W�I");
	    	return;
		}
    }
    
    
    /**	   �N��~�d����	**/
    if(Form.getInput("EDIT", "IDTYPE2") == "Y" ) {
    	if(Form.getInput("EDIT", "RESIDENCE_DATE") == ""){
    		Form.errAppend("�~�d�Ҧ��Ĥ������g");
    	} else {
    		var baseDate = Form.getInput("EDIT", "RESIDENCE_BASEDATE");
    		if(baseDate != '') {
    			if(Form.getInput("EDIT", "RESIDENCE_DATE") < baseDate) {
	    			Form.errAppend("�~�d�Ҥ���ݤj�󵥩�t�γ]�w���");
	    		}
    		}    		
    	}
    }
    
    /**	   �N��s�������	**/
    if(Form.getInput("EDIT", "IDTYPE3") == "Y" ) {
    	if(Form.getInput("EDIT", "NEWNATION") == ""){
    		Form.errAppend("�s������O����g");
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
/** �s�ɥ\��ɩI�s���� */
function doSave_end1()
{
    /** �ˮֳ]�w���*/
    Form.startChkForm("EDIT");

    /** ��ֿ��~�B�z */
    if (!queryObj.valideMessage (Form))
        return;

    /** = �e�X��� = */
    /** �]�w���A */
//    alert(editMode);
    var    actionMode    =    "";
    if (editMode == "ADD")
        actionMode    =    "ADD_MODE";
    else
        actionMode    =    "EDIT_MODE";

    /** �ǰe�ܫ�ݦs�� */
    var    callBack    =    function doSave_end1.callBack(ajaxData)
    {
//        alert(ajaxData.result);
        if (ajaxData == null)
            return;

        /** ��Ʒs�W���\�T�� */
        if (editMode == "ADD")
        {
            /** �]�w���s�W�Ҧ� */
            doAdd();
            Message.openSuccess("A01");
			if(ajaxData.data[0].STNO != "")
				alert("�ӥ;Ǹ��G" + ajaxData.data[0].STNO);
			
            var paymentStatus = document.forms["EDIT"].elements["PAYMENT_STATUS"].value;
			
			if(paymentStatus == "2"){
				var status_tmp = _i('EDIT', 'NPAYMENT_BAR').value;
				if(status_tmp == "")
				{
					if(confirm("�O�_�C�L���ڡH")){
						document.getElementById("ASYS").disabled = false;
		    			doPrint('2');
		    		}
				}
	    	}else if(!(_i('EDIT', 'NPAYMENT_BAR').value!="" || _i('EDIT', 'REG_FEE').value == "0")){
	    		if(confirm("�O�_�C�Lú�O��H")){
	    			doPrint('1');
	    		}
	    	}
    		/* if(paymentStatus == "2"){
    			if(confirm("�O�_�C�L���ڡH")){
    				doPrint('2');
    			}
    		}else{
    			if(confirm("�O�_�C�Lú�O��H")){
    				doPrint('1');
    			}
    		} */
			document.getElementById("ASYS").disabled = true;
            top.mainFrame.location.href = 'sol005m_02v1.jsp';
        }
        /** ��ƭק令�\�T�� */
        else
        {
            Message.openSuccess("A02", function (){top.hideView();});
            //var r = confirm("�аݬO�_�C�Lú�O��H\n(�ثe���b���ն��q�A�|�Lú�O��)");
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
			alert("�п�J�Ǿ�");
    		return false;
    	}else{
    		return true;
    	}
    }
}

/** �B�z�C�L�ʧ@ */
function doPrint(value)
{
	doPrint_start();

	/** === �۩w�ˬd === */
	/* === LoadingBar === */
	/** ����ˮ֤γ]�w, �����~�B�z�覡�� Form.errAppend(Message) �֭p���~�T�� */
	//if (Form.getInput("QUERY", "SYS_CD") == "")
	//	Form.errAppend("�t�νs�����i�ť�!!");
	/** ================ */

	doPrint_end(value);
}

/** �B�z�C�L�ʧ@�}�l */
function doPrint_start()
{
	/** ���� onsubmit �\�ਾ��ưe�X */
	//event.returnValue	=	false;

	/** �}�Ҹ�ƳB�z�� */
	Message.showProcess();
}

/** �B�z�C�L�ʧ@���� */
function doPrint_end(value)
{
	/** ���� onsubmit �\�ਾ��ưe�X */
	//event.returnValue	=	false;

	/** �}�l�B�z */
	Message.showProcess();

	/** �ˮֳ]�w���*/
	//Form.startChkForm("QUERY");

	/** ��ֿ��~�B�z */
	if (!queryObj.valideMessage (Form))
		return;

	var	printWin	=	WindowUtil.openPrintWindow("", "Print");
	Form.doSubmit("EDIT", printPage + "?control_type=PRINT_MODE&status=" + value, "post", "Print");

	printWin.focus();

	/** ����B�z */
	Message.hideProcess();
}

/** ���� �a�} */
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
    /** ��l�� Form �C�� */
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

/**�q�T�a�}�}��*/
function addr()
{
	var tmp = _i('EDIT','CRRSADDR').value;
	if(_i('EDIT','CRRSADDR').value == "" || tmp.length <= 6)
		Form.openPhraseWindow("SOL004M_01_WINDOW", null, null, "�l���ϸ�, �����m���", [_i("EDIT", "CRRSADDR_ZIP"), _i("EDIT", "CRRSADDR")]);
	else
		Form.openPhraseWindow("SOL004M_01_WINDOW", null, null, "�l���ϸ�, �����m���", [_i("EDIT", "CRRSADDR_ZIP"), _i("EDIT", "CRRSADDR2")]);
}

/**�q�T�a�}BLUR*/
function addr2(tmp2)
{
	var tmp = _i('EDIT','CRRSADDR').value;
	if(_i('EDIT','CRRSADDR').value == "" || tmp.length <= 6)
		Form.blurData("SOL004M_01_BLUR", "CRRSADDR_ZIP", tmp2, ["CRRSADDR_ZIP", "CRRSADDR"], [_i("EDIT", "CRRSADDR"), _i("EDIT", "CRRSADDR")], true);
	else
		Form.blurData("SOL004M_01_BLUR", "CRRSADDR_ZIP", tmp2, ["CRRSADDR_ZIP", "CRRSADDR"], [_i("EDIT", "CRRSADDR2"), _i("EDIT", "CRRSADDR2")], true);
}

/**���y�a�}�}��*/
function addr_d()
{
	var tmp = _i('EDIT','DMSTADDR').value;
	if(_i('EDIT','DMSTADDR').value == "" || tmp.length <= 6)
		Form.openPhraseWindow("SOL004M_02_WINDOW", null, null, "�l���ϸ�, �����m���", [_i("EDIT", "DMSTADDR_ZIP"), _i("EDIT", "DMSTADDR")]);
	else
		Form.openPhraseWindow("SOL004M_02_WINDOW", null, null, "�l���ϸ�, �����m���", [_i("EDIT", "DMSTADDR_ZIP"), _i("EDIT", "DMSTADDR2")]);
}

/**���y�a�}BLUR*/
function addr_d2(tmp2)
{
	var tmp = _i('EDIT','DMSTADDR').value;
	if(_i('EDIT','DMSTADDR').value == "" || tmp.length <= 6)
		Form.blurData("SOL004M_02_BLUR", "DMSTADDR_ZIP", tmp2, ["DMSTADDR_ZIP", "DMSTADDR"], [_i("EDIT", "DMSTADDR"), _i("EDIT", "DMSTADDR")], true);
	else
		Form.blurData("SOL004M_02_BLUR", "DMSTADDR_ZIP", tmp2, ["DMSTADDR_ZIP", "DMSTADDR"], [_i("EDIT", "DMSTADDR2"), _i("EDIT", "DMSTADDR2")], true);
}

/**�q�l�H�c�榡�ˮ�*/
function checkEmail(mailStr)
{
	if(mailStr!=''){
		if((mailStr.indexOf("@")==-1 || mailStr.indexOf(".")==-1)){
			alert('�q�l�H�c�Ҷ��Ƥ�r�ή榡�����T�A�ЦA�T�{�C');
			return true;
		}
	}    
	return false;
}

/** ============================= ���ץ��{����m�� ======================================= */
/** �]�w�\���v�� */
function securityCheck()
{
    try
    {
        /** �d�� */
        if (!<%=AUTICFM.securityCheck (session, "QRY")%>)
        {
            noPermissAry[noPermissAry.length]    =    "QRY";
            try{Form.iniFormSet("QUERY", "QUERY_BTN", "D", 1);}catch(ex){}
        }
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
        if (!<%=AUTICFM.securityCheck (session, "EXP")%>)
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
function checkGETINFO(){

<!-- 	if( Form.getInput("EDIT", "GETINFO") =='1' ){ -->
<!-- 		Form.iniFormSet("EDIT", "GETINFO_NAME", "D", 0, "R", 0);	 -->
<!-- 	}else{ -->
<!-- 		Form.iniFormSet("EDIT", "GETINFO_NAME", "D", 1, "R", 1); -->
<!-- 	} -->
	Form.iniFormColor();
}