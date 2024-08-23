<%/*
----------------------------------------------------------------------------------
File Name        : sol005m_01c1
Author            : ����L
Description        : SOL005M_�n�����W�ǥ͸�� - ����� (javascript)
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
doImport ("Query.js, ErrorHandle.js, LoadingBar_0_2.js, Form.js, Ajax_0_2.js, ArrayUtil.js, ReSize.js, SortTable.js,Check.js");

/** ��l�]�w������T */
var    printPage        =    "/sol/sol005m_01p1.jsp";    //�C�L����
var    editMode        =    "ADD";                //�s��Ҧ�, ADD - �s�W, MOD - �ק�
var    lockColumnCount        =    -1;                //��w����
var    listShow        =    false;                //�O�_�@�i�J��ܸ��
var    _privateMessageTime    =    -1;                //�T����ܮɶ�(���ۭq�� -1)
var    pageRangeSize        =    10;                //�e���@����ܴX�����
var    controlPage        =    "/sol/sol005m_01c2.jsp";    //�����
var    checkObj        =    new checkObj();            //�ֿ露��
var    queryObj        =    new queryObj();            //�d�ߤ���
var    importSelect        =    false;                //�פJ������\��
var    noPermissAry        =    new Array();            //�S���v�����}�C
var SAVE_TYPEv = "0";
var checkHtml = false;
/** ������l�� */
function page_init()
{
    document.getElementById("EDIT").style.display = "none";
    //page_init_start();

    loadind_    =    new LoadingBar();
    /** �v���ˮ� */
    securityCheck();

    /** === ��l���]�w === */
    /** ��l�W�h�a�Ӫ� Key ��� */
    iniMasterKeyColumn();

    /** ��l�d����� */
    Form.iniFormSet('QUERY', 'IDNO', 'S',  10, 'A', 'U','FC');
    Form.iniFormSet('QUERY', 'BIRTHDATE', 'M',  8, 'S',  8, 'A', 'N1', 'DT');
    Form.iniFormSet('QUERY', 'ASYS', 'M',  1, 'A');
	Form.iniFormSet('QUERY', 'STTYPE', 'M',  2);
	Form.iniFormSet('QUERY', 'AYEAR', 'M',  3, 'S', 3, 'A', 'F', 3, 'N1');
	Form.iniFormSet('QUERY', 'SMS', 'M',  1, 'S', 1);
	Form.iniFormSet('QUERY', 'NATIONCODE', 'M',  3, 'S', 1);
	Form.iniFormSet('QUERY', 'EXP_DATE', 'M',  8, 'S',  8, 'A', 'N1', 'DT');

    /** ��l�s����� */
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

    loadind_.showLoadingBar (15, "��l��짹��");
    /** ================ */

    /** === �]�w�ˮֱ��� === */
    /** �d����� */
    Form.iniFormSet('QUERY', 'IDNO', 'AA', 'chkForm', '�����Ҧr��');
    Form.iniFormSet('QUERY', 'BIRTHDATE', 'AA', 'chkForm', '�X�ͤ��');
    Form.iniFormSet('QUERY', 'ASYS', 'AA', 'chkForm', '�Ǩ�');
	Form.iniFormSet('QUERY', 'STTYPE', 'AA', 'chkForm', '���W�����O');
	Form.iniFormSet('QUERY', 'NATIONCODE', 'AA', 'chkForm', '���y�O');
	Form.iniFormSet('QUERY', 'AYEAR', 'AA', 'chkForm', '���W�Ǧ~');
	Form.iniFormSet('QUERY', 'SMS', 'AA', 'chkForm', '���W�Ǵ�');
	Form.iniFormSet('QUERY', 'idtype', 'AA', 'chkForm', '���إ����ҥ����O');

    /** �s����� */
    Form.iniFormSet('EDIT', 'IDNO', 'AA', 'chkForm', '�����Ҧr��');
    Form.iniFormSet('EDIT', 'BIRTHDATE', 'AA', 'chkForm', '�X�ͤ��');
    Form.iniFormSet('EDIT', 'SEX', 'AA', 'chkForm', '�ʧO');
    Form.iniFormSet('EDIT', 'AYEAR', 'AA', 'chkForm', '�Ǧ~');
    Form.iniFormSet('EDIT', 'SMS', 'AA', 'chkForm', '�Ǵ�');
    Form.iniFormSet('EDIT', 'NAME', 'AA', 'chkForm', '�m�W');
    Form.iniFormSet('EDIT', 'STTYPE', 'AA', 'chkForm', '���W�����O');
    Form.iniFormSet('EDIT', 'CENTER_CODE', 'AA', 'chkForm', '���W���ɤ���');
    //Form.iniFormSet('EDIT', 'PAYMENT_METHOD', 'AA', 'chkForm', 'ú�O�覡');
    Form.iniFormSet('EDIT', 'PAYMENT_STATUS', 'AA', 'chkForm', 'ú�O���A');
	Form.iniFormSet('EDIT', 'REG_FEE', 'AA', 'chkForm', 'ú�O���B');
    Form.iniFormSet('EDIT', 'CHECK_DOC', 'AA', 'chkForm', '�ҥ󥿥��O�_�ŦX');
    Form.iniFormSet('EDIT', 'AUDIT_RESULT', 'AA', 'chkForm', '���߼f�d���G');
    Form.iniFormSet('EDIT', 'PRE_MAJOR_FACULTY', 'AA', 'chkForm', '�w�w�D��');
	Form.iniFormSet('EDIT', 'EDUBKGRD_GRADE', 'AA', 'chkForm', '�̰��Ǿ����O');
	Form.iniFormSet('EDIT', 'DMSTADDR_ZIP', 'AA', 'chkForm', '���y�l���ϸ�');
    Form.iniFormSet('EDIT', 'CRRSADDR_ZIP', 'AA', 'chkForm', '�q�T�l���ϸ�');

    loadind_.showLoadingBar (20, "�]�w�ֱ��󧹦�");
    /** ================ */
	G11.innerHTML = "<font color=red>��</font>";
        queryObj.endProcess ("��ƳB�z����");
    //page_init_end();

	getNationalCode();
    /** ��l�� Form �C�� */
    Form.iniFormColor();
	_i('EDIT','CENTER_CODE').value = _i('EDIT','CD').value;
	//_i('EDIT','EDUBKGRD_GRADE').value = "00";
	_i('QUERY','SMS').value = "<%=(String)session.getAttribute("SOL005m_nextsms")%>";
}

/**
��l�� Grid ���e
@param    stat    �I�s���A(init -> ������l��)
*/
function iniGrid(stat)
{
    var    gridObj    =    new Grid();

    iniGrid_start(gridObj)

    /** �]�w���Y */
    gridObj.heaherHTML.append
    (
        "<table id=\"RsultTable\" class='sortable' width=\"100%\" border=\"1\" cellpadding=\"2\" cellspacing=\"0\" bordercolor=\"#E6E6E6\">\
            <tr class=\"mtbGreenBg\">\
                <td width=20>&nbsp;</td>\
            </tr>"
    );

    if (stat == "init" && !listShow)
    {
        /** ��l�ƤΤ���ܸ�ƥu�q���Y */
        document.getElementById("grid-scroll").innerHTML    =    gridObj.heaherHTML.toString().replace(/\t/g, "") + "</table>";
    }
    else
    {
        /** �B�z�s�u����� */
        //var    ajaxData    =    iniGrid_middle();
        /** �����϶��P�B */
        Form.setInput ("QUERY", "pageSize",    Form.getInput("RESULT", "_scrollSize"));
        Form.setInput ("QUERY", "pageNo",    Form.getInput("RESULT", "_goToPage"));

        /** �B�z�s�u����� */
        var    callBack    =    function iniGrid.callBack(ajaxData)
        {
            if (ajaxData == null)
                return;

            /** �]�w�� */
            var    keyValue    =    "";
            var    editStr        =    "";
            var    delStr        =    "";
            var    exportBuff    =    new StringBuffer();

            for (var i = 0; i < ajaxData.data.length; i++, gridObj.rowCount++)
            {
                keyValue    =    "ASYS|" + ajaxData.data[i].ASYS + "|AYEAR|" + ajaxData.data[i].AYEAR + "|SMS|" + ajaxData.data[i].SMS + "|IDNO|" + ajaxData.data[i].IDNO + "|BIRTHDATE|" + ajaxData.data[i].BIRTHDATE;

                /** �P�_�v�� */
                if (chkSecure("DEL"))
                    delStr    =    "onkeypress=\"doDelete('" + keyValue + "');\"onclick=\"doDelete('" + keyValue + "');\"><a href=\"javascript:void(0)\">�R</a>";
                else
                    delStr    =    ">�R";

                if (chkSecure("UPD"))
                    editStr    =    "onkeypress=\"doEdit('" + keyValue + "');\"onclick=\"doEdit('" + keyValue + "');\"><a href=\"javascript:void(0)\">�s</a>";
                else
                    editStr    =    ">�s";

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

            /** �L�ŦX��� */
            if (ajaxData.data.length == 0)
                gridObj.gridHtml.append ("<font color=red><b>�@�@�@�d�L�ŦX���!!</b></font>");

            iniGrid_end(ajaxData, gridObj);
        }
        sendFormData("QUERY", controlPage, "QUERY_MODE", callBack);
    }
}

/** �B�z�ץX�ʧ@ */
function doExport(type)
{
    var    header        =    "\r\n";

    /** �B�z�פJ�\�� �ץX����, ���D, �@���X��, �{���W��, �e��, ���� */
    processExport(type, header, 4, 'sol005m', 500, 200);
}

/** �d�ߥ\��ɩI�s */
function doQuery()
{
    doQuery_start();

    /** === �۩w�ˬd === */
    loadind_.showLoadingBar (8, "�۩w�ˮֶ}�l");

    /** ����ˮ֤γ]�w, �����~�B�z�覡�� Form.errAppend(Message) �֭p���~�T�� */
    //if (Form.getInput("QUERY", "SYS_CD") == "")
    //    Form.errAppend("�t�νs�����i�ť�!!");

    loadind_.showLoadingBar (10, "�۩w�ˮ֧���");
    /** ================ */

    return doQuery_end();
}

/** �s�W�\��ɩI�s */
function doAdd()
{
    doAdd_start();

    /** �M����Ū����(KEY)*/
    Form.iniFormSet('EDIT', 'ASYS', 'R', 0);
    Form.iniFormSet('EDIT', 'AYEAR', 'R', 0);
    Form.iniFormSet('EDIT', 'SMS', 'R', 0);
//    Form.iniFormSet('EDIT', 'IDNO', 'R', 1);
//    Form.iniFormSet('EDIT', 'BIRTHDATE', 'R', 1);

    /** ��l�W�h�a�Ӫ� Key ��� */
    iniMasterKeyColumn();
	_i('QUERY','IDNO').value='';
	_i('QUERY','BIRTHDATE').value='';
	_i('QUERY','NATIONCODE').value='000';
	_i('QUERY','STTYPE').value='';
	_i('QUERY','EXP_DATE').value='';
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
    /** �]�w�ק�Ҧ� */
    editMode        =    "UPD";
    EditStatus.innerHTML    =    "�ק�";

    /** �M����Ū����(KEY)*/
    Form.iniFormSet('EDIT', 'ASYS', 'R', 1);
    Form.iniFormSet('EDIT', 'AYEAR', 'R', 1);
    Form.iniFormSet('EDIT', 'SMS', 'R', 1);
//    Form.iniFormSet('EDIT', 'IDNO', 'R', 1);
//    Form.iniFormSet('EDIT', 'BIRTHDATE', 'R', 1);

    /** ��l�� Form �C�� */
    Form.iniFormColor();

    /** �]�w Focus */
    Form.iniFormSet('EDIT', 'NAME', 'FC');
}

/** �s�ɥ\��ɩI�s */
function doSave()
{
	document.forms["EDIT"].elements["SMS"].disabled = false;
	var sttype = document.forms["EDIT"].elements["STTYPE"].value;
    var preMajor = document.forms["EDIT"].elements["PRE_MAJOR_FACULTY"].value;
    if(sttype == '' && checkHtml){
    	alert("�п�ܳ��W�����O");
    	return;
    }else if(preMajor == '' && checkHtml){
    	alert("�п�ܹw�w�D��");
    	return;
    }
    
       
    if(Form.getInput("EDIT", "SPECIAL_STUDENT") == "5"){
    	if(Form.getInput("EDIT", "STTYPE") == "2"){
    		alert("�ѩ�z�O��ץͭ׺�40�Ǥ��A���W�����O���i���u��ץ͡v�I");
    		return;
    	}
    }
	
	 if(Form.getInput("EDIT", "STTYPE") == "1"){
    	var EDU = Form.getInput("EDIT", "EDUBKGRD_GRADE");
		if(EDU < '03'){
			alert("���W�Ťj���ץ�\"�J�ǾǾ����O\"���������H�W�I");
	    	return;
		}
    }
	
	if(Form.getInput("EDIT", "STTYPE") == "3"){
    	var EDU = Form.getInput("EDIT", "EDUBKGRD_GRADE");
		if(EDU < '03'){
			alert("���W�űM\"�J�ǾǾ����O\"���������H�W�I");
	    	return;
		}
    }
	
	var D_NO = Form.getInput("EDIT", "DRAFT_NO");
	
	if(D_NO != ""){
    	if(D_NO.length != 11)
		{
			alert("�ײ����X��������11�X�I");
    		return;
		}
    }
	
	var tmp_st = _i('EDIT', 'SPECIAL_STUDENT').value;
	if((_i('EDIT', 'AUDIT_RESULT').value == "0" || _i('EDIT', 'AUDIT_RESULT').value == "4") && tmp_st=="2")
	{
		if(document.EDIT.DOC_CHECKBOX.checked==false)
		{
			alert("����ú�������D�ץӽЪ��i�q�L�f�d!!");
			return;
		}
	}
    
    doSave_start();
    

    /** �P�_�s�W�L�v�����B�z */
    if (editMode == "NONE")
        return;

    /** === �۩w�ˬd === */
    loadind_.showLoadingBar (8, "�۩w�ˮֶ}�l");
	
	
    /** ����ˮ֤γ]�w, �����~�B�z�覡�� Form.errAppend(Message) �֭p���~�T�� */
	if (Form.getInput("EDIT", "REG_FEE") != ""){
		if(Form.getInput("EDIT", "REG_FEE") == "0")
		{
			if(Form.getInput("EDIT", "PAYMENT_METHOD") != "5")
				Form.errAppend("�Kú�O(ú�O���B=0)�Aú�O�覡�п�{��!");
			if(Form.getInput("EDIT", "NPAYMENT_BAR") == "")
				Form.errAppend("�Kú�O(ú�O���B=0)�A�п�J�Kú�O��]!");
		}else{
			if(Form.getInput("EDIT", "PAYMENT_METHOD") == "")
				Form.errAppend("�п�Jú�O�覡!");
		}
    }
	
	if (Form.getInput("EDIT", "PAYMENT_METHOD") == "6"){
    	if(Form.getInput("EDIT", "DRAFT_NO") == ""){
    		Form.errAppend("ú�O�覡���ײ��ɡA�п�J�ײ����X!!");
    	}
    }
    
    /**	   �N��~�d����	**/
    if(Form.getInput("EDIT", "IDTYPE2") == "Y" ) {
    	if(Form.getInput("EDIT", "RESIDENCE_DATE") == ""){
    		Form.errAppend("�~�d�Ҧ��Ĥ������g�A�нT�{�I");
    	} else {
    		var baseDate = Form.getInput("EDIT", "RESIDENCE_BASEDATE");
    		if(baseDate != '') {
    			if(Form.getInput("EDIT", "RESIDENCE_DATE") < baseDate) {
	    			Form.errAppend("�ҥ����饲�ݤj�󵥩�Ǵ��ҥ��Ǥ�I");
	    		}
    		}    		
    	}
    }
    
    /**	   �N��s�������	**/
    if(Form.getInput("EDIT", "IDTYPE3") == "Y" ) {
    	if(Form.getInput("EDIT", "NEWNATION") == ""){
    		Form.errAppend("�s������O����g�A�нT�{�I");
    	}
    }

    loadind_.showLoadingBar (10, "�۩w�ˮ֧���");
    /** ================ */

    if(doSave_end()){
    	var paymentStatus = document.forms["EDIT"].elements["PAYMENT_STATUS"].value;
    	document.forms["EDIT"].elements["SMS"].disabled = true;
    	document.getElementById("EDIT").style.display = "none";
    	if(paymentStatus == "2"){
			var status_tmp = _i('EDIT', 'NPAYMENT_BAR').value;
			if(status_tmp == "")
			{
				if(confirm("�O�_�C�L���ڡH")){
	    			doPrint('2');
	    		}
			}
    	}else if(!(_i('EDIT', 'NPAYMENT_BAR').value!="" || _i('EDIT', 'REG_FEE').value == "0")){
    		if(confirm("�O�_�C�Lú�O��H")){
    			doPrint('1');
    		}
    	}
		/** �]�w���s�W�Ҧ� */
		doAdd();
    }
}

/** �s�ɥ\��ɩI�s���� */
function doSave_end()
{
	/** �ˮֳ]�w���*/
	Form.startChkForm("EDIT");
	
	/** ��ֿ��~�B�z */
	if (!queryObj.valideMessage (Form))
	{
		document.forms["EDIT"].elements["SMS"].disabled = true;
		return;
	}

	/** = �e�X��� = */
	/** �]�w���A */
	var	actionMode	=	"";
	if (editMode == "ADD")
		actionMode	=	"ADD_MODE";
	else
		actionMode	=	"EDIT_MODE";

	var	callBack	=	function doSave_end.callBack(ajaxData)
	{
		if (ajaxData == null)
			return false;

		/** ����B�z */
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
			alert("�ӥ;Ǹ��G" + ajaxData.data[0].STNO);
		}	
		/** ���] Grid 2006/11/16 nono add, 2007/01/07 �վ�P�_�覡 */
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


//�D���إ��ꨭ�����W�Aĵ�ܰT��
function alertNationMsg()
{
	if( Form.getInput("QUERY", "NATIONCODE") !='000' ){
		//alert('�@�B�̾ڪŤ��j�ǳ]�m���Ҳ�16���W�w�G�u�Ť��j�Ǳo�ۦ��w���o�b�O�@�@�~�d�\�i���L���y����B�~��H�B����B�D���~���Τj���a�ϤH���@�@�����ץͤο�ץ͡F��ۥ͡B���ɤΨ�L�����ƶ����W�w�A�ѪŤ��@�@�j�����q�A��ߪ̡A�������D�޾����֩w�K�v�C�@�@�@�@�@�@�@�@�G�B�̹��ͦ^��N�Ǥλ��ɿ�k��5����1���W�w�A���դ��o�ۦ����͡C�T�B�̫e�z�W�w�A���դ��o�ۦ����㤤�إ�����y�Υ����o�b�O�~�d�\�@�@�i���~�y�H�h�C�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�|�B�D�����y�H�h�A���w�㦳���إ�����y�Τw���o�b�O�~�d�\�i�̡A�@�@�аȶ��Ŀ��O�øԶ�����ѡC�@�@�@�@�@�@�@�@�@�@�@�@�@�@���B�Ч��V�f�־ǥͤJ�Ǭ�����ơA�@���o�{���Ÿ��̡A�N���P���@�@���y��ơC');
		window.showModalDialog("/sol/sol005m_02v2.jsp",'window','dialogWidth=520px;dialogHeight=480px');
		return;
	}
}

//����IDNO�ˬd�O�_���Ƴ��W
function checkIDNO()
{
	if( Form.getInput("QUERY", "IDNO") != ''){
		var idno = Form.getInput("QUERY", "IDNO");
		var idnoFirst = idno.substring(0,1);
		
		if(Form.getInput("QUERY", "idtype") == '3') {
		
			if(Form.getInput("QUERY", "radioType") == '1') {
			//type=3 ���鶴���Ҧr�� �b�o���ˮ�
				if( !Check.chkIDNO(Form.getInput("QUERY", "IDNO")) &&Form.getInput("QUERY", "NATIONCODE")=='000' ){
					alert('�����ҲΤ@�s����J���~�A�нT�{�I');
					Form.setInput("QUERY", "IDNO","");
					return;
				} else {
					getIdnoCheck();
				}
				
			} else {
				if(idno.length < 9) {
					alert('�@�ӲΤ@�Ҹ���J���~�A�нT�{�I');
					Form.setInput("QUERY", "IDNO","");
					return;
				} else {
					getIdnoCheck();
				}
			}
			
		} else {
			//�W���N���إ��ꨭ��
			if( !Check.chkIDNO(Form.getInput("QUERY", "IDNO")) &&Form.getInput("QUERY", "NATIONCODE")=='000' ){
				alert('�����ҲΤ@�s����J���~�A�нT�{�I');
				Form.setInput("QUERY", "IDNO","");
				return;
			} else {
				getIdnoCheck();
			}
			
			if(Form.getInput("QUERY", "NATIONCODE") != '000') {
				//�U����ܫD���إ��ꨭ���Ҹ��ˮ�
				//�榡�A�Υ��h��ܦ����Ĥ@�Ӧr���O�_���^��r��
				
				var idno = Form.getInput("QUERY", "IDNO");
				
				if(isNaN(idno.substr(2,8)) || 
		                (!/^[A-Z]$/.test(idno.substr(0,1)))){
		            alert("�~�d�ҲΤ@�Ҹ����~�A�нT�{�I");
		            Form.setInput("QUERY", "IDNO","");
		            return;
		        }
				
				//�iDB��ID2����
				var    callBack    =    function checkIDNO.callBack(ajaxData) {
					if (ajaxData == null){
						alert('ajax data = null ');
						return;
			        }
			        
			        if (ajaxData.data.length == 0){
			        	//�ĤG�X�L�������Ʈw�����
			        	alert('�~�d�ҲΤ@�Ҹ����~�A�Ҹ��ĤG�X�D�t�ΰѼƳ]�w��ơI');
			        	Form.setInput("QUERY", "IDNO","");
			        	return;
			        } else {
			        	if("8" == (idno.substr(1,1)) || "9" == (idno.substr(1,1))){
			        		if( !Check.chkIDNO(Form.getInput("QUERY", "IDNO"))){
								alert('�~�d�ҲΤ@�Ҹ����~�A�нT�{�I');
					        	Form.setInput("QUERY", "IDNO","");
					            return;
							} else {
								alert('�����s�~�d�ҲΤ@�Ҹ��A�ЦA���T�{�Ҹ��F�ø߰ݬO�_���Ťj�¥͡A�Y�O�аȥ���s���y�����Ҹ��A�i��s�ͳ��W�I');
								alertNationMsg();
					            getIdnoCheck();
							}
			        	} else {
			        		var idHeader = "ABCDEFGHJKLMNPQRSTUVXYWZIO"; //�����ഫ���v�ƪ��j�p�i��Ƨ�
					        //�o��⨭���Ҧr���ഫ���ǳƭn������
					        idno = (idHeader.indexOf(idno.substring(0,1))+10) + 
					        '' + ((idHeader.indexOf(idno.substr(1,1))+10) % 10) + '' + idno.substr(2,8);
					        //�}�l�i�樭���ҼƦr���ۭ��P�֥[�A�̷Ӷ��ǭ��W1987654321
					 
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
					 
					        //�ˬd���X = 10 - �ۭ���Ӧ�Ƭۥ[�`�M�����ơC
					        checkNum = parseInt(idno.substr(10,1));
					        //�Ҽ� - �`�M/�Ҽ�(10)���l�ƭY����ĤE�X���ˬd�X�A�h���Ҧ��\
					        ///�Y�l�Ƭ�0�A�ˬd�X�N�O0
					        if((s % 10) == 0 || (10 - s % 10) == checkNum){
					            alertNationMsg();
					            getIdnoCheck();
					        }
					        else{
					        	alert('�~�d�ҲΤ@�Ҹ����~�A�нT�{�I');
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
			alert("�����ҲΤ@�s���w���W�A���i���Ƴ��W!!");
			_i('QUERY', 'IDNO').value = "";
			Form.iniFormSet('QUERY', 'IDNO', 'FC');
		} else {
			/* 2020/04/14 �s�W ���F�����Ҹ��H�~��L���n���o�ӭȧP�_�~�d��\�@�Ө���� */
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
	
	//�]�wú�O���A
	if(value == "" || value == null){
		document.forms["EDIT"].elements["PAYMENT_STATUS"].value = "1";
	}else{
		document.forms["EDIT"].elements["PAYMENT_STATUS"].value = "2";
	}
	Form.iniFormColor();
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
	event.returnValue	=	false;

	/** �}�Ҹ�ƳB�z�� */
	Message.showProcess();
}

/** �B�z�C�L�ʧ@���� */
function doPrint_end(value)
{
	/** ���� onsubmit �\�ਾ��ưe�X */
	event.returnValue	=	false;

	/** �}�l�B�z */
	Message.showProcess();

	/** �ˮֳ]�w���*/
	Form.startChkForm("QUERY");

	/** ��ֿ��~�B�z */
	if (!queryObj.valideMessage (Form))
		return;

	var	printWin	=	WindowUtil.openPrintWindow("", "Print");
	Form.doSubmit("QUERY", printPage + "?control_type=PRINT_MODE&status=" + value, "post", "Print");

	printWin.focus();

	/** ����B�z */
	Message.hideProcess();
}

function doSOLCK()
{
    /** �ˮֳ]�w���*/
	Form.startChkForm("QUERY");
	
	/** ��ֿ��~�B�z */
	if (!queryObj.valideMessage (Form))
	{
		return;
	}
	//alert("1");
    if(document.getElementById("IDNO").value =="" || document.getElementById("BIRTHDATE").value =="" || document.getElementById("ASYS").value =="" || document.getElementById("STTYPE2").value =="")
    {
        alert("���n���n��J");
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
	var name = _i("EDIT","NAME").value;  // �H�Ө����Ҧr��+�ͤ� �ݸ�Ʈw���O�_���������,�p���h�θ�ƪ����m�W
	var isOld = "N";
	/* �ˬd�ӥͪ��~�֯�_���W**/
	var    callBack    =    function doSOLCK.callBack(ajaxData) {
		if(ajaxData == null || ajaxData.data.length == 0){
			alert("�d�L�Ǵ���Ǥ�A�Х��]�w�ӾǴ��Ǵ���Ǥ�");
			check=1;
        	return;
        }
		year1 = StrUtil.getBStr(ajaxData.data[0].ENROLL_BASEDATE,4);
		date1 = ajaxData.data[0].ENROLL_BASEDATE.charAt(4)+ajaxData.data[0].ENROLL_BASEDATE.charAt(5)+ajaxData.data[0].ENROLL_BASEDATE.charAt(6)+ajaxData.data[0].ENROLL_BASEDATE.charAt(7);
		Form.setInput("EDIT", "NPAYMENT_BAR", "");
		Form.setInput("EDIT", "PAYMENT_METHOD", "");
		Form.setInput("EDIT", "REG_FEE", "");
		if(year1-year2 > 100){
			alert("���W�ǥͶW�L�~��100�� �нT�{!!");
		}
		//20140516 Maggie �令�Ťj���ץͤ�����~��(�u�n���������~�ҮѧY�i)�A��ӪűM
		//if(_i('QUERY', 'STTYPE').value == '1')
		//{
		//	if(year1-year2 == 20){
		//		if(date1-date2 < 0){
		//			alert("���W���ץͥ����~��20��!!");
		//			check=1;
		//		}
		//	}else if(year1-year2 < 20){
		//		alert("���W���ץͥ����~��20��!!");
		//		check=1;
		//	}
		//}
		if(_i('QUERY', 'STTYPE').value == '2')
		{
			if(year1-year2 == 18){
				if(date1-date2 < 0){
					alert("���W��ץͥ����~��18��!!");
					check=1;
				}
			}else if(year1-year2 < 18){
				alert("���W��ץͥ����~��18��!!");
				check=1;
			}
		}
		
		name = ajaxData.data[0].NAME;
		isOld = ajaxData.data[0].IS_OLD;
		//�s�W�M��ͦ~���ˬd�A�ݺ�16��  20090320 by barry
		// 20100209 north �令�űM������~��(�u�n���������~�ҮѧY�i)
	//	if(_i('QUERY', 'STTYPE').value == '3')
	//	{
	//		if(year1-year2 == 16){
	//			if(date1-date2 < 0){
	//				alert("���W�M��ͥ����~��16��!!");
	//				check=1;
	//			}
	//		}else if(year1-year2 < 16){
	//			alert("���W�M��ͥ����~��16��!!");
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
	
	/*************************************************************** 2020/04/14 �s�W ***************************************************************/
	/**	   �N���O�Υx�W�����Ҧr�� �ҥH�n�h�ˮ֤��	**/
	if(_i("QUERY","idtype").value != "1" ){
		var baseDate = Form.getInput("EDIT", "RESIDENCE_BASEDATE");
   		if(baseDate != '') {
   			if(Form.getInput("QUERY", "EXP_DATE") < baseDate) {
   				if(_i("QUERY","idtype").value == "2" ){
   					alert("�~�d�Ҩ���饲��A��ƥ��ŦX��Ǵ��~�d�ҮĴ���Ǥ�I");
   				} else {
   					alert("�@�Ө���饲��A��ƥ��ŦX��Ǵ��b�ǰ�Ǥ�I");
   				}
    			
    			return;
    		} else {
    			_i("EDIT","RESIDENCE_DATE").value = Form.getInput("QUERY", "EXP_DATE");
    		}
   		} else {
   			alert('�t�Ω|�������]�w�A�L�k���o��Ǥ�');
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
                var r = confirm("�аݬO�_������D�סH");
				// alert("msg[3]<br>�Цܾ��y������D�פ~�i���W!!");
				// SAVE_TYPEv ="-1";
                if (r==true)  {
                    /**���"1"*/
                    alert(msg[1]);
                    SAVE_TYPEv ="2";
                    specialStudent = "2";
					document.getElementById("checkbox_doc").innerHTML = "�T�wú�������D�פ��<input type=checkbox name='DOC_CHECKBOX'>";
					Form.setInput("EDIT", "NPAYMENT_BAR", "�¥�");
					Form.setInput("EDIT", "REG_FEE", "0");
					Form.setInput("EDIT", "PAYMENT_METHOD", "5");
					if(Form.getInput("QUERY", "STTYPE") == "2")
					{
						alert("���D�ץͥu����W���ץ�");
						Form.setInput("QUERY", "STTYPE", "1");
					}
					doDisabled(5);
                }
                else
                {
                    /**�����*/
                    alert(msg[3]);
                    SAVE_TYPEv ="-1";
                }
            }
			// msg[0]=1��ܰ���SOLCKBO�ᬰ�i���W���A
            else if(msg[0]=="OK"||msg[0]=="1")
            {
                //�i���W�A�����t���
                alert("�i���W");
            }
            else if(msg[0]=="4") //�������~��"3"
            {
                    alert(msg[1]);
                    SAVE_TYPEv ="4";
                    specialStudent = "4";
					Form.setInput("EDIT", "NPAYMENT_BAR", "�¥�");
					Form.setInput("EDIT", "REG_FEE", "0");
					Form.setInput("EDIT", "PAYMENT_METHOD", "5");
					doDisabled(5);
            }
            else if(msg[0]=="5")//�¿���s��"2"
            {
                if(_i('QUERY','STTYPE').value=="2")
				{
					alert("�w�g�O��ץ͡A���i�A���W��ץ�!!");
					SAVE_TYPEv ="-1";
				}else{
					alert(msg[1]);
					SAVE_TYPEv ="5";
					specialStudent = "5";
					Form.setInput("EDIT", "NPAYMENT_BAR", "�¿�ץͭ׺�40�Ǥ�");
					Form.setInput("EDIT", "REG_FEE", "0");
					Form.setInput("EDIT", "PAYMENT_METHOD", "5");
					doDisabled(5);
				}
            }
            else if(msg[0]=="13")//�Ťj���~��
            {
                    alert(msg[1]);
                    SAVE_TYPEv ="13";
                    specialStudent = "13";
                    Form.setInput("EDIT", "NPAYMENT_BAR", "�Ťj���~��");
					Form.setInput("EDIT", "REG_FEE", "0");
					Form.setInput("EDIT", "PAYMENT_METHOD", "5");
					Form.setInput("EDIT","EDUBKGRD_GRADE","11");
					
					doDisabled(5);
            }
            else if(msg[0]=="14")//�űM���~��
            {
                alert(msg[1]);
                SAVE_TYPEv ="14";
                specialStudent = "14";
                Form.setInput("EDIT", "NPAYMENT_BAR", "�űM���~��");
				Form.setInput("EDIT", "REG_FEE", "0");
				Form.setInput("EDIT", "PAYMENT_METHOD", "5");
				doDisabled(5);
            }
			// �¿�ץͭפ���40�Ǥ��B�Ťj���~�L
			else if(msg[0]=="6.1")
            {
				if(_i('QUERY','STTYPE').value=="2")
				{
					alert("�w�g�O��ץ͡A���i�A���W��ץ�!!");
					SAVE_TYPEv ="-1";
				}else{
					alert(msg[1]);
                    SAVE_TYPEv ="6";  // ��ݳB�z�覡�M�¿�ץͭפ���40�Ǥ��@��,�u�O�t�b�����O�M��ܤ����O��]
                    specialStudent = "13";
                    Form.setInput("EDIT", "NPAYMENT_BAR", "�Ťj���~��");
					Form.setInput("EDIT", "REG_FEE", "0");
					Form.setInput("EDIT", "PAYMENT_METHOD", "5");
					doDisabled(5);
				}
            }
			// �¿�ץͭפ���40�Ǥ��B�űM���~�L
			else if(msg[0]=="6.2")
            {
				if(_i('QUERY','STTYPE').value=="2")
				{
					alert("�w�g�O��ץ͡A���i�A���W��ץ�!!");
					SAVE_TYPEv ="-1";
				}else{
                    alert(msg[1]);
                    SAVE_TYPEv ="6";  // ��ݳB�z�覡�M�¿�ץͭפ���40�Ǥ��@��,�u�O�t�b�����O�M��ܤ����O��]
                    specialStudent = "14";
                    Form.setInput("EDIT", "NPAYMENT_BAR", "�űM���~��");
					Form.setInput("EDIT", "REG_FEE", "0");
					Form.setInput("EDIT", "PAYMENT_METHOD", "5");
					doDisabled(5);
				}
            }
			// �¿�ץͭפ���40�Ǥ��B�����Ťj�űM���~
			else if(msg[0]=="6")
            {
                if(_i('QUERY','STTYPE').value=="2")
				{
					alert("�w�g�O��ץ͡A���i�A���W��ץ�!!");
					SAVE_TYPEv ="-1";
				}else{
					alert(msg[1]);
					if(confirm("��ץͥ���40�Ǥ�,�O�_����L�Ǿ��ҩ��H"))
					{
						SAVE_TYPEv ="6";
	                    specialStudent = "6";
						//���������40�Ǥ��A����L�Ǿ��ҩ��A��ú���W�O  2008/08/14 by barry
						//�¿�ץͥ��׺�40�Ǥ�,���s���סA�Kú���W�O2014/4/25 by Maggie
						Form.setInput("EDIT", "NPAYMENT_BAR", "��ץͥ���40�Ǥ�����L�Ǿ��ҩ�");
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
			else if(msg[0]=="20")//�¥��ץͭ׺�40�Ǥ�,�NŪ�űM�Kú���W�O
            {
                alert(msg[1]);
                SAVE_TYPEv ="20";
                specialStudent = "20";
                Form.setInput("EDIT", "NPAYMENT_BAR", "���ץͭ׺�40�Ǥ�");
				Form.setInput("EDIT", "REG_FEE", "0");
				Form.setInput("EDIT", "PAYMENT_METHOD", "5");
				doDisabled(5);
            }          
			// ���y���w���Ӹ��,���ҿ�J���ͤ馳�~
            else if(msg[0]=="18")
            {
				alert('���ˬd��J�������Ҧr���Υͤ�O�_���~�A�нT�{�I');
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
				//65���H�W�S���Kú���W�O���W�w  2008/08/14 by barry
                // if(year1-year2 == 65 && _i('EDIT', 'NPAYMENT_BAR').value==""){
					// if(date1-date2 >= 0){
						// Form.setInput("EDIT", "NPAYMENT_BAR", "�W�L�κ�65��");
						// Form.setInput("EDIT", "REG_FEE", "0");
						// Form.setInput("EDIT", "PAYMENT_METHOD", "5");
						// doDisabled(5);
					// }
				// }else if(year1-year2 > 65 && _i('EDIT', 'NPAYMENT_BAR').value==""){
					// Form.setInput("EDIT", "NPAYMENT_BAR", "�W�L�κ�65��");
					// Form.setInput("EDIT", "REG_FEE", "0");
					// Form.setInput("EDIT", "PAYMENT_METHOD", "5");
					// doDisabled(5);
				// }
                doChkOldStd();				
                if(specialStudent == "2" || specialStudent == "4" || specialStudent == "5" 
                   || specialStudent == "13" || specialStudent == "14"|| specialStudent == "20"){ 					
				   //by poto�[�W==20�]�n���o�q �]���űM���঳ �w�w�D�׬�O�@�ҥH�e�S��
                	// doGetData();					
                }
				
				// �令�u�n���¸�ƴN�n�a�X��   20100415
				doGetData();
				document.getElementById("crrzip_as_mdszip").checked = null;
				G11.innerHTML = "<font color=red>��</font>";
            }else{
            	document.getElementById("EDIT").style.display = "none";
            }

        }catch(ex){}
    }
    sendFormData("QUERY", controlPage, "SOLCK", callBack, "1111");
	
	//�u���¿���s���n���¾Ǹ�
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
        alert("���n���п�J!");
        return;
    }else if(document.getElementById("PAYMENT_METHOD").value == "6"){
		var draftNo = document.getElementById("DRAFT_NO").value; 
        if(draftNo == ""){
        	alert("�ײ����X������J!");
        	return;
        }else if(draftNo.length != 11)
		{
			alert("�ײ����X��������11�X�I");
    		return;
		}
    }
	
	var tmp_st = _i('EDIT', 'SPECIAL_STUDENT').value;
	if((_i('EDIT', 'AUDIT_RESULT').value == "0" || _i('EDIT', 'AUDIT_RESULT').value == "4") && tmp_st=="2")
	{
		if(document.EDIT.DOC_CHECKBOX.checked==false)
		{
			alert("����ú�������D�ץӽЪ��i�q�L�f�d!!");
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
         	document.getElementById("old").innerHTML = "<font color='red'>�Ӿǥͬ��¥�</font>";
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
		G11.innerHTML = "<font color=red>��</font>";
		Form.setInput("EDIT", "CRRSADDR_ZIP", "");
		Form.iniFormSet('EDIT', 'CRRSADDR_ZIP', 'R', 0);
	}
	Form.iniFormColor();
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

function doPreMajor(){
	checkHtml = true;
	var asys = Form.getInput("QUERY","ASYS");
	Form.setInput("EDIT","ASYS",asys);
	if(asys == '1'){
		document.getElementById("centerCode").innerHTML = "���W�ǲ߫��ɤ���<font color='red'>��</font>�G";
		document.getElementById("preMajorFaculty").innerHTML = "�w�w�D�׾Ǩt<font color='red'>��</font>�G";
		document.getElementById("majorForSelect").innerHTML = "<select name='PRE_MAJOR_FACULTY' id='PRE_MAJOR_FACULTY'><option value='0000'>�|���M�w</option>"+Form.getSelectFromPhrase("SOLT005_08_SELECT", null, null, false)+"</select>";
		document.getElementById("sol005_sttype").innerHTML = "<select name='STTYPE' id='STTYPE' onchange='hidden();'><option value=''>�п��</option>"+Form.getSelectFromPhrase("SOLT005_02_SELECT", null, null, false)+"</select>";
		document.getElementById("sol005_sttype2").innerHTML = "<select name='STTYPE' id='STTYPE2' onchange='hidden();'><option value=''>�п��</option>"+Form.getSelectFromPhrase("SOLT005_02_SELECT", null, null, false)+"</select>";
		document.getElementById("centerCodeSelect").innerHTML = "<select name='CENTER_CODE' id='CENTER_CODE'><option value=''>�п��</option>"+Form.getSelectFromPhrase("SOLT005_031_SELECT", null, null, false)+"</select>";
		_i('EDIT', 'CENTER_CODE').removeAttribute("chkForm");
		Form.iniFormSet('EDIT', 'CENTER_CODE', 'AA', 'chkForm', '�w�w�D�׾Ǩt');
		_i('EDIT','CENTER_CODE').value = _i('EDIT','CD').value;
	}else if(asys == '2'){
		document.getElementById("centerCode").innerHTML = "���W�оǻ��ɳB<font color='red'>��</font>�G";
		document.getElementById("preMajorFaculty").innerHTML = "�w�w�D�׬�O<font color=red>��</font>�G";
		document.getElementById("majorForSelect").innerHTML = "<select name='PRE_MAJOR_FACULTY' id='PRE_MAJOR_FACULTY'><option value=''>�п��</option>"+Form.getSelectFromPhrase("SOLT005_09_SELECT", null, null, false)+"</select>";
		document.getElementById("sol005_sttype").innerHTML = "<select name='STTYPE' id='STTYPE' onchange='hidden();'><option value=''>�п��</option>"+Form.getSelectFromPhrase("SOLT005_10_SELECT", null, null, false)+"</select>";
		document.getElementById("sol005_sttype2").innerHTML = "<select name='STTYPE' id='STTYPE2' onchange='hidden();'><option value=''>�п��</option>"+Form.getSelectFromPhrase("SOLT005_10_SELECT", null, null, false)+"</select>";
		document.getElementById("centerCodeSelect").innerHTML = "<select name='CENTER_CODE' id='CENTER_CODE'><option value=''>�п��</option>"+Form.getSelectFromPhrase("SOLT005_032_SELECT", null, null, false)+"</select>";
		_i('EDIT', 'CENTER_CODE').removeAttribute("chkForm");
		Form.iniFormSet('EDIT', 'CENTER_CODE', 'AA', 'chkForm', '�w�w�D�׬�O');
		_i('EDIT','CENTER_CODE').value = _i('EDIT','CD').value;
	}
	Form.setInput("EDIT", "NPAYMENT_BAR", "");
	Form.setInput("EDIT", "REG_FEE", "");
	Form.setInput("EDIT", "PAYMENT_METHOD", "");
	document.getElementById("EDIT").style.display = "none";
}

/**���ýs���*/
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
		
		document.getElementById("type_exp").innerHTML= "�����ҲΤ@�s��";
		Form.getDynSelectFromPhrase(_i("QUERY","NATIONCODE"), "SOLT005_13_SELECT", false ,"","");
		document.getElementById("expDateSpan").style.display="none";
		document.getElementById("expDateInput").style.display="none";
		
	}else if(_i("QUERY","idtype").value == "2" ){
		document.getElementById("radioBoxArea").innerHTML = "";
		document.getElementById("radioBoxArea").style.display="none";
		
		document.getElementById("type_exp").innerHTML= "�~�d�ҲΤ@�Ҹ�";
		Form.getDynSelectFromPhrase(_i("QUERY","NATIONCODE"), "SOLT005_14_SELECT", true ,"","");
		document.getElementById("expDateSpan").innerHTML="�ҥ�����<font color=red>��</font>�G�ä[�~�d99991231 <br>";
		document.getElementById("expDateSpan").style.display="inline";
		document.getElementById("expDateInput").style.display="inline";
		
	}else if(_i("QUERY","idtype").value == "3" ){
		/* 2020/04/29�s�W */
		Form.getDynSelectFromPhrase(_i("QUERY","NATIONCODE"), "SOLT005_16_SELECT", false ,"","");
		document.getElementById("radioBoxArea").style.display="block";		
		document.getElementById("radioBoxArea").innerHTML= "<label><input type='radio' id='radioIdno' name='radioType' value='1' onclick='radioBoxChange(1)' checked><font color=blue>�����ҲΤ@�s��</font></label>" +
														   "<label><input type='radio' id='radioPassportNo' name='radioType' value='2' onclick='radioBoxChange(2)'>���إ����@�ӵL�����ҲΤ@�s��</label>";
		//�w�]�����Ҧr��
		radioBoxChange(1);														   
														   
														   							
		//document.getElementById("type_exp").innerHTML= "�@�ӲΤ@�Ҹ�";
		Form.getDynSelectFromPhrase(_i("QUERY","NATIONCODE"), "SOLT005_16_SELECT", true ,"",""); 
		//document.getElementById("expDateSpan").innerHTML="�@�Ө����<font color=red>��</font>�G";
		//document.getElementById("expDateSpan").style.display="inline";
		//document.getElementById("expDateInput").style.display="inline";
		
	}else {
		document.getElementById("radioBoxArea").innerHTML = "";
		document.getElementById("radioBoxArea").style.display="none";
		
		document.getElementById("type_exp").innerHTML= "�����ҲΤ@�s��";
		Form.getDynSelectFromPhrase(_i("QUERY","NATIONCODE"), "SOLT005_13_SELECT", true ,"","");
		document.getElementById("expDateSpan").style.display="none";
		document.getElementById("expDateInput").style.display="none";		
	}
}

/** �@�Ӹ��X�P�_�n�q�@�Ӥ���άO�����Ҧr��(1��ܨ����� 2����@�Ӹ��X) */
function radioBoxChange(type){
	switch(type) {
		case 1:
			document.getElementById("type_exp").innerHTML= "�����ҲΤ@�s��";
			document.getElementById("expDateSpan").style.display="inline";
			document.getElementById("expDateInput").style.display="inline";
			breaks;
		case 2:
			document.getElementById("type_exp").innerHTML= "�@�ӲΤ@�Ҹ�";
			document.getElementById("expDateSpan").style.display="inline";
			document.getElementById("expDateInput").style.display="inline";
			breaks;
		default:
			
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


/** 20200327�s�[�J �ˬd�i���W�����ʧ@ */
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
				//�T�{�@�U�O���O�s���
				checkIdType3();
	        } else {
	        	Form.setInput("EDIT","SEX", ajaxData.data[0].CODE_NAME);
	        	Form.setInput("EDIT","IDTYPE2", "Y");
	        	//�p�G���~�d���� �h�d��� ����HIDDEN ���s�ɮɦA���
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