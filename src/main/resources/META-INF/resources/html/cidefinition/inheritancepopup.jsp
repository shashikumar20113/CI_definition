<%@page import="java.util.Arrays"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.liferay.portal.kernel.json.JSONFactoryUtil"%>
<%@page import="com.arangodb.entity.BaseDocument"%>
<%@page import="java.util.List"%>
<%@page import="com.liferay.portal.kernel.util.ParamUtil"%>
<%@page import="com.lti.itops.ipac.cidefinition.util.CIDefinitionUtil"%>
<%@page import="com.liferay.portal.kernel.json.JSONObject"%>
<%@ include file="init.jsp"%>

<style>

.form-style
{

    padding: 19px;
   /*  margin-left: 425px;  */

}

</style>

<%

try{

    String displayStyle = ParamUtil.getString(request, "displayStyle", "list");
	
	String Key= ParamUtil.getString(request, "key");
	
	String Selectedvalues = ParamUtil.getString(request, "selectedvalues");
	
	String[] checkedval = Selectedvalues.split(" ");
	
	List<String> checkvalue = new ArrayList<String>();
	
	checkvalue=Arrays.asList(checkedval);
		
%>
<div class="lnt-popup"> 
  <div id="wrapperpopup">
    <h5 class="form-style">Select CI Definitions</h5>
     <hr class="devider" />
     
     <form  class="form-style">      
              
	<%
       int count= CIDefinitionUtil.getCIDefinitionCount(themeDisplay.getCompanyId());

	     List<BaseDocument> listofobject = CIDefinitionUtil.getCIDefinitiones(themeDisplay.getCompanyId(),0,count);
	     
         if(!listofobject.isEmpty()) 
         {
             for(BaseDocument basedoc: listofobject)
                {
                        
	               String className= basedoc.getProperties().get(CIDefinitionPortletKeys.CI_NAME).toString();
	                   
	                if(!basedoc.getKey().equalsIgnoreCase(Key))
	                {               	  
                      if(checkvalue.contains(basedoc.getKey()))
                         {              
    %>
                             <aui:input type="checkbox" datalabel="<%=className%>"  name="className" label="<%=className%>" value="<%=basedoc.getKey()%>" checked="true"></aui:input> 
             
                       <% } else{ %>
                                    <aui:input type="checkbox" datalabel="<%=className%>"   name="className" label="<%=className%>" value="<%=basedoc.getKey()%>" ></aui:input> 
           <%     
                                }
	                }  
	                    
	           } 
            %> 
             <aui:button type="submit" name="closeDialog" onClick="callparent()"></aui:button>
           <%   
         }
         
         else	 
         {
          out.println("No CI definitions are Present");
         }
         
         
	        %> 
           
         
     </form>
  </div>
</div>


<aui:script>

function callparent()
{
	      var selectedval=[];
	  
	      $.each($("input[name='<portlet:namespace/>className']:checked"),function(){
		  
		  var objectval = {};
		  
		  objectval["label"] = $(this).attr("datalabel");
		  objectval["value"] = $(this).val();
		  
		  selectedval.push(objectval);
	  
	      });
	     
	      parent.parentMethod(selectedval); 
	      
	     
}

</aui:script>

<%

}

catch(Exception ex)
{
   System.out.println(ex);	
}

%>

