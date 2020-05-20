
<%@page import="com.liferay.portal.kernel.util.PortalUtil"%>
<%@page import="com.liferay.portal.kernel.json.JSONArray"%>
<%@page import="com.liferay.portal.kernel.json.JSON"%>
<%@page import="com.liferay.portal.kernel.portlet.LiferayWindowState"%>
<%@page import="com.liferay.portal.kernel.util.ParamUtil"%>
<%@ include file="init.jsp"%>
<%@ include file="/html/cidefinition/navigation.jsp" %>

<style>

.bttn{
background-color:#1458e9;
color: #ffffff;
}

#overflowTest {
 
  
  padding-top: 5px;
  padding-right: 15px;
  padding-bottom: 5px;
  padding-left: 15px;
  width: 100%;
  height: 260px;
  overflow: auto;
  border: 1px solid #ccc;
}

#space {
 
  
  padding-top: 15px;
  
  
  
  
}
#innerspace {
 
  
  padding-top: 5px;
  
  padding-bottom: 5px;
  
  
}

#formgroup {
 
  padding-bottom: -15px;
  margin-bottom: -20px;
  
  
}

</style>


<%
try{
	String displayStyle = ParamUtil.getString(request, "displayStyle", "list");
%>
<portlet:renderURL var="backURL">
<portlet:param name="mvcPath" value="/html/cidefinition/displayciDefinition.jsp"/>

<portlet:param name="displayStyle" value="<%=displayStyle%>" />
</portlet:renderURL>


<portlet:renderURL var="inheritanceUrl" windowState="<%=LiferayWindowState.POP_UP.toString() %>">
	<portlet:param name="mvcPath" value="/html/cidefinition/inheritancepopup.jsp"/>
</portlet:renderURL>

 <portlet:actionURL var="addCidefinitionURL" name="addCidefinition">
    <portlet:param name="mvcPath" value="/html/cidefinition/displayciDefinition.jsp"/>
</portlet:actionURL>


<%

PortalUtil.addPortletBreadcrumbEntry(request, "Ci Definitions",backURL.toString());

PortalUtil.addPortletBreadcrumbEntry(request, "Add Ci Definition",themeDisplay.getURLCurrent());

%>

<div class="main-content-area">
  <div class="container-fluid">
    <div class="row">
      <div class="col-md-6">
	             <a href="<%=backURL.toString()%>"><i aria-hidden="true"
					class="ci icon-arrow-left " title="Back"></i> CI Definition form</a>
	  </div>			
    </div>
    <hr class="devider" />
  </div>
  
  <div class="user-form mt-30 user-wrapper-form">
     <aui:form   action="${addCidefinitionURL} " method="post" name="form" >
     <aui:fieldset-group markupView="lexicon">
        <div class="form-fields-content" >
           
          <aui:row>
          
             <%--Shashi changes Newer one is below --%>
           <aui:col span="6">
          
          <div class="input-feild">
			 <div class="form-group" id="formgroup">
			   
			   <%--Shashi changes --%>
				 <aui:input label="CI Definition Name" class="form-control input-default" type="text" name="ciname" value="" required="true" >
				 <aui:validator name="alpha" errorMessage="Accept Alphabates only"/>
				 <aui:validator name="maxLength">20</aui:validator>
				 </aui:input>
                 
			</div>
		 </div>
          
          </aui:col>
          
          <aui:col  span="6">
           <div class="input-feild">
               <div class="form-group" id="formgroup">
               
                 <%--Shashi changes --%>
               <aui:input label="Description" class="form-control input-default" type="text" name="cidef" value="" required="true">           
               <aui:validator name="alpha" errorMessage="Accept Alphabates only"/>
               <aui:validator name="maxLength">20</aui:validator>
               </aui:input>
                 
               </div>
           </div>
          </aui:col>
          
      <%--     <aui:col  span="6">
           <div class="input-feild">
               <div class="form-group" id="formgroup">
                 
               <aui:input label="CI Definition" class="form-control input-default" type="text" name="cidef" value="" required="true"></aui:input>
                 
               </div>
           </div>
          </aui:col>
          
          <aui:col span="6">
          
          <div class="input-feild">
			 <div class="form-group" id="formgroup">
			   
				 <aui:input label="CI Name" class="form-control input-default" type="text" name="ciname" value="" required="true" ></aui:input>
                
			</div>
		 </div>
          
          </aui:col> --%>
             
          </aui:row>   
           								
        </div>
      <!--  <div>
       
        <h3 class="header-title"><label id="">Add Property</label></h3>
       </div>  -->
       <div id="space">
       <aui:fieldset  collapsed="<%=true%>" collapsible="<%=true%>" label="Add Property" >
    <div class="taglib-header" id="overflowTest">
        
		 
	
	 <div id="config-tool">
		<div class="lfr-form-row lfr-form-row-outline">
			<div class="accordianContents">
			<aui:row>
				<aui:col width="20">
					<aui:input name="propertyname1" label="PropertyName">
					<aui:validator name="alpha" errorMessage="Accept Alphabates only"/>
				    <aui:validator name="maxLength">20</aui:validator>	
				    </aui:input>
				</aui:col>
				<aui:col width="20">
					 <aui:select name="propertytype1" label="PropertyType">
					
                        <option value="string">String</option>
                        <option value="number">Number</option>
                        <option value="singleref">Single Ref</option>
                        <option value="multipleref">Multiple Ref</option>
                        <option value="boolean">Boolean</option>
                        <option value="long">Long</option>
                     
                    </aui:select>
				</aui:col>
				<aui:col width="20"><aui:input type="checkbox" name="mendatory1" label="is_Mendatory" ></aui:input></aui:col>
			</aui:row>
			</div>
		</div>
	 </div>
    </div>
	</aui:fieldset>
	</div>
	<div id="space">
	
	       <aui:button type="button" cssClass="btn  btn-primary btn-default" onClick="InherPopup()" value="Add_Inheritance">
		   </aui:button>
			<div class="form-fields-content">
           
		         <div class="input-feild">
					<div class="form-group" id="innerspace">
					   <div id="myForm">
		                  <input type="hidden" name="<portlet:namespace />classname"></input>
		               </div>
		               
		               <aui:fieldset  collapsed="<%=true%>" collapsible="<%=true%>" label="Added Inheritance CI Definition" >
		               <div id="labelname"></div>
		               </aui:fieldset>
					</div>
				 </div>
								
            </div>		
	</div>
	
	
	<aui:button-row>
	 <aui:button type="submit" name="save" ></aui:button>
	 <aui:button type="cancel" href="<%=backURL.toString()%>"></aui:button>
	</aui:button-row> 
    <aui:script>

	AUI().use('liferay-auto-fields', function(A) {
		afields=new Liferay.AutoFields({
			contentBox : '#config-tool',
			fieldIndexes : '<portlet:namespace />configIndexes'
		}).render();
	});
    </aui:script>
    </aui:fieldset-group>
     </aui:form>
     
  </div>
</div>

<aui:script>
function InherPopup()
{
	var selectedval="";
	$("#myForm").children("input:hidden").each(function () {
		
		selectedval=selectedval+" "+$(this).val(); 
	  });
	
	AUI().use('aui-base',
            'liferay-util-window','liferay-portlet-url','aui-node',function(A) {    
		
		var url = '${inheritanceUrl}'+"&<portlet:namespace />selectedvalues="+selectedval;
	window.popUpWindow=Liferay.Util.Window.getWindow(
	  {
	            dialog: {
	                      centered: true,
	                      constrain2view: true,
	                      modal: true,
	                      destroyOnHide:false,
	                      resizable: false,
							width: 1000,
							height: 500,
	                     },
	            id: 'AddineritanceDialog',
	            title: 'Add inheritance',
	            uri: url
	  });
	
	});
}

</aui:script>
<aui:script>

function parentMethod(selectedval)
{	
       document.getElementById("labelname").innerHTML = "";	
	   document.getElementById("myForm").innerHTML = ""; 
		
			 var x = document.createElement("INPUT");
			 x.setAttribute("type", "hidden");
			 
			 x.setAttribute("Name", "<portlet:namespace />classname");
			 		 
			 document.getElementById("myForm").appendChild(x);
			 		 
		for(var cont=0; cont<selectedval.length; cont++)	
		{
				  
				     var obj = selectedval[cont];
				  
					 var y = document.createElement("INPUT");
					 y.setAttribute("type", "hidden");
					 y.setAttribute("value", obj["value"]);
					 y.setAttribute("Name", "<portlet:namespace />classname");
					 y.setAttribute("class", "form-control input-default");
					 y.setAttribute("readonly", "readonly");
					 
					 document.getElementById("myForm").appendChild(y);
	 
					 var z = document.createElement("INPUT");
					 z.setAttribute("type", "text");
					 z.setAttribute("value", obj["label"]);
					 z.setAttribute("Name", "<portlet:namespace />labelname");
					 z.setAttribute("class", "form-control input-default");
					 z.setAttribute("readonly", "readonly");
					 
					 document.getElementById("labelname").appendChild(z);
	 
		}	
		window.popUpWindow.destroy();
}

</aui:script>

<% 
}

catch(Exception ex)
{
	System.out.println("exception"+ex);
%>
	<liferay-ui:error key="page-error" message="page-error">
	</liferay-ui:error>
<%
}
%>

