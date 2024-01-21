<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Reform.ascx.cs" Inherits="Custom.Reform" %>
<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate" />
<meta http-equiv="Pragma" content="no-cache" />      
<meta http-equiv="Expires" content="0" />


<script src="/applications/hr/jquery.min.js"></script>  

    <table>
        <tr>
            <td colspan="2">
			<div id="errorSameApprover">
<asp:Literal ID="errorSameApprover" runat="server"></asp:Literal>   
</div>
            </td>
        </tr>
		<tr>
            <td colspan="2">
			<hr/> 
			</td>
			</tr>
		 <tr>
            <td colspan="2">
<font color="red">   ΠΡΟΣΟΧΗ! </font> Σιγουρευτείτε ότι θα επισυνάψετε <br/> 
    (α) Σκαναρισμένη Υπογεγραμμένη Δήλωση  <br />
    (β) Βεβαίωση από Εργασία Συζύγου ή άλλο Δικαιολογητικό (π.χ. Οικογενειακή Μερίδα για Μονογονεϊκή Οικογένεια) <br />
    (γ) Οποιοδήποτε άλλο ειδικό δικαιολογητικό απαιτείται   <br /> 
    Μπορείτε να κατεβάσετε το (α) από <a target='_blank' href='/applications/hr/Shared Documents/KGExpenseRequest.docx'>εδω </a>
    
            </td>
            
        </tr>
		<tr><td colspan="2"><hr/></td></tr> 
        <tr>
            <td>
                Αιτών  
            </td>
            <td>
<asp:Literal ID="requestorName" runat="server"></asp:Literal>   
            </td>
            </tr>
        <tr>
            <td>
                Αρ. Μητρώου
            </td>
            <td>
<asp:Literal ID="requestorCode" runat="server"></asp:Literal>   
            </td>
        </tr>
        <tr>
            <td>
             Τρέχουσα Κατάσταση Αίτησης
            </td>
            <td>
<asp:Literal ID="dispStatus" runat="server"></asp:Literal>   
            </td>
        </tr>
		
         <tr>
            <td>
             Αίτημα
            </td>
            <td>
Παρακαλώ να μου εγκρίνετε την καταβολή του ποσού το οποίο μου αναλογεί, <br />
                βάσει της Εγκυκλίου 4629/16/08.09.2022 της Τράπεζας <br />
                για τη φιλοξενία του παιδιού μου στον Βρεφονηπιακό/Παιδικό Σταθμό ή Νηπιαγωγείο 
            </td>
        </tr>
      
    </table>

<script>



    function isInReadMode() {
        return (window.location.href.toLowerCase().indexOf("dispform.aspx") > -1);
    }
    function isNewDocument() {
        return (window.location.href.toLowerCase().indexOf("newform.aspx") > -1);
    }

    function isForComposer() {
        if (isNewDocument()) { return true; }
        var status = $("[title='Κατασταση']").val();
        return status === 'Επιστροφή για Υποβολή';
    }

    function disableField(fieldName, isRequired) {
        var req = '';
        if (isRequired) { req = ' Required Field'; }
        $("[title='" + fieldName + req + "']").each(function () {
            $(this).closest('td').replaceWith("<div>" + this.value + "</div>");
        })
    }
	
	 function disableMultiLineText(fieldName, isRequired) {
        var req = '';
        if (isRequired) { req = ' Required Field'; }
        $("[title='" + fieldName + req + "']").each(function () {
            $(this).closest('td').replaceWith("<div>" + this.value.replace(/\n\r?/g, '<br />') + "</div>");
        })
    }


    function disablePeoplePicker(fieldName) {

        $("[title^='" + fieldName + "']").prop('disabled', true);
        //$("[title^='"+ fieldName +"']").each(function() { console.log (this.title);  this.style.background-color='lightgray'});
        //$("[title^='"+ displayName +"'] > .sp-peoplepicker-editorInput").prop('disabled', true);
        $("[title^='" + fieldName + "']").find(".sp-peoplepicker-delImage").hide();
    }

    function hideField(fieldName) {
        if (isInReadMode()) {
            $("[name='SPBookmark_" + fieldName + "']").closest('tr').hide();
        }
        else {
            $("nobr:contains('" + fieldName + "')").closest('tr').hide();
        }
    }

    function hideStandardFields() {
        hideField('OldStatus');
        hideField('Τιτλος');
    }

    function disableStandardFields() {

        //disableField('Κατασταση'); 
        disableMultiLineText('Ιστορικο', false);

        disablePeoplePicker('1ος Εγκρινων');
        disablePeoplePicker('2ος Εγκρινων');
        disablePeoplePicker('Εκκρεμει Σε');
    }





    function disableOtherFields() {
        var status = $("[title='Κατασταση']").val();
        if (status === 'Εγκρίθηκε' || status === 'Απορρίφθηκε') {
            disableField('Κατασταση', false);
            disableField('Σχολια', false);
            disableMultiLineText('Σχολια Υποβολης', false);

        }
        if (isForComposer()) {
            disableField('Σχολια', false);
        }
        else {
            disableMultiLineText('Σχολια Υποβολης', false);
            disableField('ΑΜ Συνηπηρετουντος Συζυγου', false);
            disableField('Ονομα Παιδικου Σταθμου', true);
            disableField('Ημ Γεννησης Παιδιου', true);
            disableField('Ονομα Παιδιου', true);
            disableField('Επωνυμο Παιδιου', true);
        }
    }


    function handleStatusDropDown() {
        var errorSameApprover = $('#errorSameApprover').text();
        console.log('errorSameApprover=' + errorSameApprover);
        var status = $("[title='OldStatus']").val();
        var validStatuses = '';
        if (isNewDocument()) { validStatuses = '#Εκκρεμεί 1η Έγκριση#' };
        if (status === 'Εκκρεμεί 1η Έγκριση' && !isNewDocument()) { validStatuses = '#Εκκρεμεί 1η Έγκριση#Επιστροφή για Υποβολή#Εκκρεμεί 2η Έγκριση#Απορρίφθηκε#' };
        if (status === 'Εκκρεμεί 2η Έγκριση') {
            if (errorSameApprover.trim() === '') {
                validStatuses = '#Εκκρεμεί 2η Έγκριση#Επιστροφή στην 1η Έγκριση#Εγκρίθηκε#Απορρίφθηκε#';
            }
            else {
                validStatuses = '#Εκκρεμεί 2η Έγκριση#Επιστροφή στην 1η Έγκριση#Απορρίφθηκε#';
            }
        };
        if (status === 'Επιστροφή στην 1η Έγκριση') { validStatuses = 'Επιστροφή στην 1η Έγκριση#Επιστροφή για Υποβολή#Εκκρεμεί 2η Έγκριση#Απορρίφθηκε#' };
        if (status === 'Επιστροφή για Υποβολή') { validStatuses = '#Επιστροφή για Υποβολή#Εκκρεμεί 1η Έγκριση#' };
        console.log('validStatuses:' + validStatuses);
        $("[title='Κατασταση']  option").each(function () {
            var key = '#' + this.value + '#';
            console.log(key);
            if (validStatuses.indexOf(key) === -1) {
                this.disabled = true;
                this.style.color = 'lightgray';
            }
        })
        // //statusField.remove().end().append('<option value="Εκκρεμεί 1η Έγκριση">Εκκρεμεί 1η Έγκριση</option>'); 
        // var statusField =  $("[title='Κατασταση']") ; 
        // var options = statusField.o
        // for(var i=0; i<options.length; i++) {
        // if(options[i].innerHTML == 'Εκκρεμεί 1η Έγκριση' || options[i].innerHTML == 'Εκκρεμεί 2η Έγκριση') {
        // theSelect.removeChild(options[i]);
        // i--; // options have now less element, then decrease i
        // }
        // }
    }

    $(document).ready(function () {
        // alert($("[title='Κατασταση']").val()); 
        hideStandardFields();
        disableStandardFields();
        disableOtherFields();
        handleStatusDropDown();

        // disableField('DispName') ; 
        // disableField('Σχολια') ; 
        // disableField('DispStatus'); 
        // disableField('NextApprover'); 

    });


</script>