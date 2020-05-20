



<%@page import="com.arangodb.entity.BaseDocument"%>
<%@page import="com.lti.itops.ipac.cidefinition.util.CIDefinitionUtil"%>
<%@ include file="init.jsp"%>


<style>

.form-style
{

    padding: 19px;
   /*  margin-left: 425px;  */

}


.select
{
  margin-top:28px;
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
     <div class="form-style" >
        <div id="overflowTest">
        <%
        
        if(!ciobjects.isEmpty())
        {
        	boolean odd=true;
        for(BaseDocument ciobject : ciobjects)
        {
        	String objectname= ciobject.getProperties().get(CIDefinitionPortletKeys.CI_OBJECT).toString();
        	
        
        
        
        %>
       <%--  <form  class="form-style">
        <aui:fieldset-group markupView="lexicon"> --%>
        
       <%--  <aui:fieldset  collapsed="<%=true%>" collapsible="<%=true%>" label="<%=String.valueOf(objectname)%>" > --%>
       
        <aui:row>
            <aui:col span="3">
            
              <aui:input type="text" datalabel="<%=propname%>" id ="<%=id%>" name="classname" label="<%=objectname%>"  value="<%=objectname%>" readonly="readonly"></aui:input>
              
            </aui:col>
            <aui:col span="3">
                   <a class="btn btn-primary select" onClick="callparent(this)"  datalabel="<%=propname%>" id ="<%=id%>" value="<%=objectname%>" valueid="<%= ciobject.getKey()%>">
			  		<!-- <i class="ci icon-add-1"></i> -->select
					</a>
			</aui:col>
		</aui:row>
               
             <%-- <aui:button type="submit" name="closeDialog" onClick="callparent()"></aui:button> --%>
        
        <%-- </aui:fieldset>
        </aui:fieldset-group>
        </form>
        --%>
        <%
        }
        }
        else
        { 
        	%>
        	<aui:input type="checkbox" datalabel="<%=propname%>" id="<%=id%>"  name="className" label="if feild is mendatory click on this checkbox" value="null" ></aui:input>
        	<a class="btn btn-primary" onClick="callparent(this)"  datalabel="<%=propname%>" id ="<%=id%>" value="null" valueid="null">
			  		<!-- <i class="ci icon-add-1"></i> -->select
					</a>
        	<% 
        }
        
        %>
        
        
        </div>
       </div> 
   </div>
</div>
   
   
   <aui:script>

function callparent(item)
{
	      var selectedval=[];
	      
	      
	     /*  var id = $(item).attr("id");
	  	  var propname=$(item).attr("datalabel");
	  	  var name = $(item).attr("name");
	       */
	  /* */
	       /* $.each($("input[name='<portlet:namespace/>classname']:hidden"),function(){
		   */
		  var objectval = {};
		  
		  objectval["label"] = $(item).attr("datalabel");
		  objectval["value"] = $(item).attr("value");
		  objectval["id"]= $(item).attr("id");
		  objectval["name"]=$(item).attr("id");
		  objectval["valueid"]=$(item).attr("valueid");
		  
		  /* alert($(item).attr("valueid"))
		  alert($(item).attr("value"));
	       alert($(item).attr("id"));
	       alert($(item).attr("datalabel"));	 */	  
		  selectedval.push(objectval);
	  
	     /*  });  */
	    /*  alert(selectedval); */
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