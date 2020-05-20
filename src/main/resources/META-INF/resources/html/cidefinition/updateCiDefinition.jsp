
<%@page import="com.liferay.portal.kernel.util.PortalUtil"%>
<%@page import="java.util.HashSet"%>
<%@page import="java.util.Arrays"%>
<%@page import="java.util.List"%>
<%@page import="com.lti.itops.ipac.cidefinition.util.CIDefinitionUtil"%>
<%@page import="com.liferay.portal.kernel.json.JSONObject"%>
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
	
	String key= ParamUtil.getString(request, "key");
	
%>



<portlet:renderURL var="backURL">
<portlet:param name="mvcPath" value="/html/cidefinition/displayciDefinition.jsp"/>

<portlet:param name="displayStyle" value="<%=displayStyle%>" />
</portlet:renderURL>


<portlet:renderURL var="inheritanceUrl" windowState="<%=LiferayWindowState.POP_UP.toString() %>">
	<portlet:param name="mvcPath" value="/html/cidefinition/inheritancepopup.jsp"/>
	<portlet:param name="key" value="<%=key%>" />
</portlet:renderURL>

 <portlet:actionURL var="updateCidefinitionURL" name="updateCidefinition">
    <portlet:param name="mvcPath" value="/html/cidefinition/displayciDefinition.jsp"/>
    <portlet:param name="displayStyle" value="<%=displayStyle%>" />
</portlet:actionURL>


<%
JSONObject cidefinition=null;

cidefinition= CIDefinitionUtil.getCIDefinitionAsJSON(themeDisplay.getCompanyId(), key);


PortalUtil.addPortletBreadcrumbEntry(request, cidefinition.getString(CIDefinitionPortletKeys.CI_NAME),backURL.toString());

PortalUtil.addPortletBreadcrumbEntry(request, " Update Ci Definition",themeDisplay.getURLCurrent());


%>

<div class="main-content-area">
  <div class="container-fluid">
    <div class="row">
      <div class="col-md-6">
	             <a href="<%=backURL.toString()%>"><i aria-hidden="true"
					class="ci icon-arrow-left " title="Back"></i> Update CI Definition </a>
	  </div>			
    </div>
    <hr class="devider" />
  </div>
  
  <div class="user-form mt-30 user-wrapper-form">
     <aui:form   action="${updateCidefinitionURL} " method="post" name="form" >
      <aui:fieldset-group markupView="lexicon">
        <input name="<portlet:namespace />key" value="<%=key%>" type="hidden" />
   
        <div class="form-fields-content">
        
           <aui:row>
           
           
           <aui:col span="6">
          
          <div class="input-feild">
			 <div class="form-group" id="formgroup">
				<aui:input label="CI Name" class="form-control input-default" type="text" name="ciname" value="<%=cidefinition.get(CIDefinitionPortletKeys.CI_NAME) %>" required="true" >
				 <aui:validator name="alpha" errorMessage="Accept Alphabates only"/>
				 <aui:validator name="maxLength">20</aui:validator>
				</aui:input>
			</div>
		 </div>
          
          </aui:col>
          
          <aui:col  span="6">
           <div class="input-feild">
               <div class="form-group" id="formgroup">
               
                <aui:input label="Description" class="form-control input-default" type="text" name="cidef" value="<%=cidefinition.get(CIDefinitionPortletKeys.DESCRIPTION)%>" required="true" >              
                <aui:validator name="alpha" errorMessage="Accept Alphabates only"/>
				 <aui:validator name="maxLength">20</aui:validator>
                </aui:input>
               
               </div>
           </div>
          </aui:col>
          
          
             
          </aui:row>
								
        </div>
         <div id="space"> 
        <aui:fieldset  collapsed="<%=true%>" collapsible="<%=true%>" label="Add Property" >
        <div class="taglib-header"  id="overflowTest">
          
		 <!-- <h3 class="header-title"><label id="">Add Property</label></h3>  -->

		 <div id="config-tool">
			 
			<% 
				 String [] keyArray = new String[]{CIDefinitionPortletKeys.CHANGEHISTORY, CIDefinitionPortletKeys.DESCRIPTION, CIDefinitionPortletKeys.CI_NAME, CIDefinitionPortletKeys.INHERITED_CLASS, "_rev", "_id", "_key",CIDefinitionPortletKeys.STATUS};
				 
				 JSONArray jsnArray = cidefinition.names ();
				 
				 String[] jsnkeyArray =new String[jsnArray.length()]; 
				 
				 for(int i=0; i<jsnArray.length(); i++)
				  { 
					 jsnkeyArray[i]= jsnArray.getString(i);
                  } 
				 
				 List<String> list1 = Arrays.asList(jsnkeyArray);
				 List<String> list2 =Arrays.asList(keyArray);
				
				 HashSet<String> union = new HashSet<String>(list1);
				 union.addAll(list2);
				 
				 HashSet<String> intersection =new HashSet<String>(list1);
				 intersection.retainAll(list2);
				 
				 union.removeAll(intersection);
				 
				 int j=1;
				 for(String propertyName: union)
				 {
					 
					String propertyType= cidefinition.getJSONObject(propertyName).getString("type");
					
					String ismandtry= cidefinition.getJSONObject(propertyName).getString("isMandatory");
					 
				    String propertyname= "propertyname"+j;
					String propertytype = "propertytype"+j;
					String mendatory= "mendatory"+j;
				 %>
	    
		  <div class="lfr-form-row lfr-form-row-outline">
			<div class="accordianContents">
 			    <aui:row>
 			    
				<aui:col width="20">
					<aui:input name="<%=propertyname%>" type="text" value="<%=propertyName %>" label="PropertyName">	
								<aui:validator name="alpha" errorMessage="Accept Alphabates only"/>
				                 <aui:validator name="maxLength">20</aui:validator>
				    </aui:input>		    
				</aui:col>
				
				<aui:col width="20">
					 <aui:select name="<%=propertytype%>" label="PropertyType">
					 
                        <option value="<%=propertyType%>"><%=propertyType%></option>
                        <option value="string">String</option>
                        <option value="number">Number</option>
                        <option value="singleref">Single Ref</option>
                        <option value="multipleref">Multiple Ref</option>
                        <option value="boolean">Boolean</option>
                        <option value="long">Long</option> 
                        
                    </aui:select>
				</aui:col>
				
				<aui:col width="20"><aui:input type="checkbox" name="<%=mendatory%>" label="is_Mendatory" value="<%=ismandtry%>"></aui:input></aui:col>
				</aui:row>
			</div>
		</div>
	                   
				<% j++; 
				} %> 
			
	 </div>
	</div>
	</aui:fieldset>
	</div>
	<div id="space">
	       <aui:button type="button" cssClass="btn  btn-primary btn-default" onClick="InherPopup()" value="Add/Remove_Inheritance">
		   </aui:button>
	 <div class="form-fields-content">
           
       <div class="input-feild">
		 <div class="form-group" >
			 <div id="myForm">
			 <input type="hidden" name="<portlet:namespace />classname"></input>
		 <% 
			 JSONArray inheritance = cidefinition.getJSONArray(CIDefinitionPortletKeys.INHERITED_CLASS);
		 
			 for(int i=0; i<inheritance.length(); i++)
				{
					String value= inheritance.getString(i);
					
					JSONObject CiName =CIDefinitionUtil.getCIDefinitionAsJSON(themeDisplay.getCompanyId(), value);	
			 %> 
		            <input class="form-control input-default" type="hidden" name="<portlet:namespace />classname" value="<%=value%>" required="required" readonly></input>
		 
		            <input class="form-control input-default" type="text" name="<portlet:namespace />labelname" value="<%=CiName.get(CIDefinitionPortletKeys.CI_NAME)%>" required="required" readonly></input>
		 
	           <%} %> 
            </div>
           <%--  <aui:fieldset  collapsed="<%=true%>" collapsible="<%=true%>" label="Updated Inheritance CI Definition" > --%>
		               <div id="labelname"></div>
		  <%--  </aui:fieldset> --%>
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
	            title: 'Add/Remove inheritance',
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


 
 
 


