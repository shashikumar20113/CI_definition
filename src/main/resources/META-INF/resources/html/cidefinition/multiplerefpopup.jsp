<%@page import="com.arangodb.entity.BaseDocument"%>
<%@page import="com.lti.itops.ipac.cidefinition.util.CIDefinitionUtil"%>
<%@ include file="init.jsp"%>

<style>

.form-style
{

    padding: 25px;
   /*  margin-left: 425px;  */

}

#overflowTest {
 
 
  padding-top: 0px;
  padding-right: 0px;
  padding-bottom: 0px;
  padding-left: 0px;
  width: 100%;
  height: 260px;
  overflow: auto;
  border: 1px solid #ccc;
}

</style>

<%
try{
	String displayStyle = ParamUtil.getString(request, "displayStyle", "list");
	
	String cidefinitionid = ParamUtil.getString(request, "cidefinitionid");
	
    String Selectedvalues = ParamUtil.getString(request, "selectedvalues");
	
	String[] checkedval = Selectedvalues.split(",");
	
	String id= checkedval[0];
	
	String propname= checkedval[1];
	
	String name= checkedval[2];
	
	
	
	int count = CIDefinitionUtil.getCIObjectsbyCIDefinitionCount(themeDisplay.getCompanyId(), cidefinitionid);
	
	List<BaseDocument> ciobjects =CIDefinitionUtil.getCIObjectsbyCIDefinition(themeDisplay.getCompanyId(), cidefinitionid,0,count );

%>

<div class="lnt-popup"> 
  <div id="wrapperpopup">
    <h5 class="form-style">Select CI Objects</h5>
     <hr class="devider" />
     
     <form  class="form-style">     
     <div id="overflowTest">
      <%
      if(!ciobjects.isEmpty())
      {
        for(BaseDocument ciobject : ciobjects)
        {
        	String objectname= ciobject.getProperties().get(CIDefinitionPortletKeys.CI_OBJECT).toString();
        	
            
        
        
        %>
        <aui:input type="checkbox" datalabel="<%=propname%>" id="<%=id%>"  name="className" label="<%=objectname%>" value="<%=objectname%>" ></aui:input>
       
        <%
        }
      }else
      {
    	 
    	  %>
    	  
    	  <aui:input type="checkbox" datalabel="<%=propname%>" id="<%=id%>"  name="className" label="if feild is mendatory click on this checkbox" value="null" ></aui:input>
    	  <% 
      }
        %>
        </div>
         <aui:button type="submit" name="closeDialog" onClick="callparent()"></aui:button>
        
        </form>
        
       
   </div>
</div>


    <aui:script>

function callparent()
{
	      var selectedval=[];
	      
	      
	     /* var id = $(this).attr("id");
	  	  var propname=$(this).attr("datalabel");
	  	  var name = $(this).attr("name");
	       var value =$(this).val(); */
	       
	       $.each($("input[name='<portlet:namespace/>className']:checked"),function(){
	 		  
	 		  var objectval = {};
	 		  
	 		  objectval["label"] = $(this).attr("datalabel");
	 		  objectval["value"] = $(this).val();
	 		  objectval["id"]= $(this).attr("id");
			  objectval["name"]=$(this).attr("id");
			  
			  
	 		  selectedval.push(objectval);
	 	  
	 	      });
	 	     
	       
	       
	  
	      parent.parentMethodformultiref(selectedval); 
	      
	     
}

</aui:script>   


<%
}

catch(Exception ex)
{
	System.out.println(ex);
}



%>
           