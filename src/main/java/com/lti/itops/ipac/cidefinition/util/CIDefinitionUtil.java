/**
 * Copyright (c) 2019 LTI. All rights reserved.
 * @author Madhukara Patel
 */

package com.lti.itops.ipac.cidefinition.util;

import com.arangodb.ArangoCollection;
import com.arangodb.ArangoCursor;
import com.arangodb.ArangoDB;
import com.arangodb.ArangoDBException;
import com.arangodb.ArangoDatabase;
import com.arangodb.entity.BaseDocument;
import com.arangodb.entity.DocumentCreateEntity;
import com.arangodb.util.MapBuilder;
import com.arangodb.velocypack.VPackParser;
import com.arangodb.velocypack.VPackSlice;
import com.arangodb.velocypack.exception.VPackException;
import com.liferay.portal.kernel.json.JSONArray;
import com.liferay.portal.kernel.json.JSONException;
import com.liferay.portal.kernel.json.JSONFactoryUtil;
import com.liferay.portal.kernel.json.JSONObject;
import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import com.liferay.portal.kernel.service.PortalPreferencesLocalServiceUtil;
import com.liferay.portal.kernel.util.PortletKeys;

import com.lti.itops.ipac.cidefinition.constants.CIDefinitionPortletKeys;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.portlet.PortletPreferences;

public class CIDefinitionUtil {
	
	final static Log _log = LogFactoryUtil.getLog(CIDefinitionUtil.class);
	
	public static ArangoDatabase getDbConnection(PortletPreferences prefs) {
		
		String hostName = prefs.getValue(CIDefinitionPortletKeys.CI_HOST_IP,"");
		
		String portNumber = prefs.getValue(CIDefinitionPortletKeys.CI_PORT_NUMBER,"");
		
		String userName = prefs.getValue(CIDefinitionPortletKeys.CI_USER_NAME,"");
		
		String password = prefs.getValue(CIDefinitionPortletKeys.CI_PASSWORD,"");
		
		String dbName = prefs.getValue(CIDefinitionPortletKeys.CI_DATABASE_NAME,"");
			
		ArangoDB arangoDB = new ArangoDB.Builder().host(hostName,Integer.parseInt(portNumber)).user(userName).password(password).build();

		return arangoDB.db(dbName);
	}
	
	
	public static PortletPreferences getDBConfiguration(long companyId) {
		
		PortletPreferences prefs = PortalPreferencesLocalServiceUtil.getPreferences(companyId,PortletKeys.PREFS_OWNER_TYPE_COMPANY);
		
		return prefs;
	}
	
	
	public static List<BaseDocument> getCIDefinitiones(long companyId,int start ,int end) {

		
		List<BaseDocument> classLists = new ArrayList<BaseDocument>();
		
		try {
		
			PortletPreferences prefs = getDBConfiguration(companyId);
			
			ArangoDatabase arangoDB = getDbConnection(prefs);
			
			String query = "FOR t IN "+ prefs.getValue(CIDefinitionPortletKeys.CI_CLASS_NAME,"CI_Class") +" LIMIT "+ start +" , "+end+" RETURN t";
	
			Map<String, Object> bindVars = new MapBuilder().get();
			
			ArangoCursor<BaseDocument> cursor = arangoDB.query(query, bindVars, null,BaseDocument.class);
			  
			classLists =cursor.asListRemaining();
			 
		
		} catch (ArangoDBException e) {
			
			_log.error("Error in getCIDefinitiones ::: " +e.getMessage());
		}
		
		return classLists;
		
	}
	
	public static void addCIDefinition(long companyId,JSONObject classObject) {
		
		PortletPreferences prefs = getDBConfiguration(companyId);
		
		ArangoDatabase arangoDB = getDbConnection(prefs);
		
		ArangoCollection arangoCollection =  arangoDB.collection(prefs.getValue(CIDefinitionPortletKeys.CI_CLASS_NAME,"CI_Class"));
		
		VPackParser parser = new VPackParser.Builder().build();
		
		arangoCollection.insertDocument(parser.fromJson(classObject.toString()));
				
	}
	
public static List<BaseDocument> getCIChangeHistoryArray(long companyId, String key){
		
		List<BaseDocument> classLists = new ArrayList<BaseDocument>();
		try {
			
			PortletPreferences prefs = getDBConfiguration(companyId);
			
			ArangoDatabase arangoDB = getDbConnection(prefs);
		
			ArangoCollection arangoCollection =  arangoDB.collection(prefs.getValue(CIDefinitionPortletKeys.CHANGEHISTORY,"ChangeHistory"));
			
			JSONObject ciobjectFor=CIDefinitionUtil.getCIObjectAsJSON(companyId, key);
			
			JSONArray chis = ciobjectFor.getJSONArray(CIDefinitionPortletKeys.CHANGEHISTORY);
	  		
		  	List<Object> list=new ArrayList<Object>();

		  			for(int i=0;i<chis.length();i++){
				  		JSONObject jsnob =chis.getJSONObject(i);
		  		list.add(jsnob)	;
		  	}			  				
		  				
		  			List<Object> ChangeHistoryList1=new ArrayList<Object>();
		  			
		  			for(int i=0;i<list.size();i++){
		  				Object j=list.get(i);
		  			ChangeHistoryList1.add(j);
		  			
		  			}
			for(int i=0;i<ChangeHistoryList1.size();i++) {
				Object main=ChangeHistoryList1.get(i);
				List<BaseDocument> objectList = (List)ChangeHistoryList1;
				classLists.add((BaseDocument) objectList);
			}
			
			_log.info("Shashi Class list in UTIL"+classLists);
			_log.info("Shashi change in UTIL"+ChangeHistoryList1);
		}
		
		 catch (ArangoDBException e) {
				
				_log.error("Error in getCIChange History:  " +e.getMessage());
			}
		/*catch (JSONException e) {
				
				_log.error("Error in getCIChange History:  " +e.getMessage());
		}*/
		return classLists;
	}
	
	public static List<BaseDocument> getCIChangeHistory(long companyId, String key, int start ,int end){
		
		List<BaseDocument> classLists = new ArrayList<BaseDocument>();
		try {
			
			PortletPreferences prefs = getDBConfiguration(companyId);
			
			ArangoDatabase arangoDB = getDbConnection(prefs);
		
			ArangoCollection arangoCollection =  arangoDB.collection(prefs.getValue(CIDefinitionPortletKeys.CHANGEHISTORY,"ChangeHistory"));

			//BaseDocument doc = arangoCollection.getDocument(key,BaseDocument.class);
			
			//JSONArray historyArray = JSONFactoryUtil.createJSONArray(doc.getProperties().get("ChangeHistory").toString());
			
			//JSONArray historyArray = JSONFactoryUtil.createJSONArray(doc.getProperties().get("ChangeHistory").toString());

			/*String query = "FOR t IN "+ prefs.getValue(CIDefinitionPortletKeys.CHANGEHISTORY,"ChangeHistory")+" RETURN t";
	
			Map<String, Object> bindVars = new MapBuilder().get();*/
			

			
			String query = "FOR t IN "+ prefs.getValue(CIDefinitionPortletKeys.CHANGEHISTORY,"changeHistory") +" FILTER t.changeHistory == @changeHistory RETURN t";


			Map<String, Object> bindVars = new MapBuilder().put("key",key).get();

			ArangoCursor<BaseDocument> cursor = arangoDB.query(query, bindVars, null,BaseDocument.class);
			  
			classLists =cursor.asListRemaining(); 
			
			_log.info("class list "+classLists);

			_log.info("query "+query);
			
			_log.info("arangoio collec "+arangoCollection);

			_log.info("key  "+key);
			_log.info("bindVars  "+bindVars);
			_log.info("cursor=  "+cursor);


		}
		 catch (ArangoDBException e) {
				
				_log.error("Error in getCIChange History:  " +e.getMessage());
			}
		/*catch (JSONException e) {
				
				_log.error("Error in getCIChange History:  " +e.getMessage());
		}*/
		return classLists;
	}
	
	public static void updateCIDefinition(long companyId,String key ,JSONObject classObject) {
		
		try {
		
			PortletPreferences prefs = getDBConfiguration(companyId);
			
			ArangoDatabase arangoDB = getDbConnection(prefs);
			
			ArangoCollection arangoCollection =  arangoDB.collection(prefs.getValue(CIDefinitionPortletKeys.CI_CLASS_NAME,"CI_Class"));
			
			BaseDocument doc = arangoCollection.getDocument(key,BaseDocument.class);
			
			JSONArray historyArray = JSONFactoryUtil.createJSONArray(doc.getProperties().get("ChangeHistory").toString());
			
			JSONObject historyObject= JSONFactoryUtil.createJSONObject();
			
			historyObject.put("newValue", "string");
			historyObject.put("changeTimeStamp",new Date().getTime());
			historyObject.put("changedBy", "user");
			historyObject.put("attributeChanged", "string");
			historyObject.put("affectedAttributes", "string");
			historyObject.put("oldValue", "string");
			
			historyArray.put(historyObject);
			
			classObject.put("ChangeHistory", historyArray);
			
			VPackParser parser = new VPackParser.Builder().build();
			
			arangoCollection.updateDocument(key, parser.fromJson(classObject.toString()));
		
		}catch(Exception e) {
			
			_log.error("Error in updateCIDefinition ::: " + e.getMessage());
		}
	}
	
	public static JSONObject getCIDefinitionAsJSON(long companyId,String key) {
			
		JSONObject docObject  = JSONFactoryUtil.createJSONObject();
		
		PortletPreferences prefs = getDBConfiguration(companyId);
		
		ArangoDatabase arangoDB = getDbConnection(prefs);
		
		ArangoCollection arangoCollection =  arangoDB.collection(prefs.getValue(CIDefinitionPortletKeys.CI_CLASS_NAME,"CI_Class"));
		
		VPackParser parser = new VPackParser.Builder().build();
		
		VPackSlice classDoc = arangoCollection.getDocument(key, VPackSlice.class);
		
		try {
			
			 docObject = JSONFactoryUtil.createJSONObject(parser.toJson(classDoc));
		
		} catch (VPackException e) {
			
			_log.error("Error in getCIClassAsJOSN VPackException :::"+e.getLocalizedMessage());
		
		} catch (JSONException e) {
			
			_log.error("Error in getCIClassAsJOSN JSONException :::"+e.getLocalizedMessage());

		}
		
		return docObject;
	}
	
	public static BaseDocument getCIDefinition(long companyId,String key) {
		
		BaseDocument classDoc = new BaseDocument();
		
		try {
		
		PortletPreferences prefs = getDBConfiguration(companyId);
		
		ArangoDatabase arangoDB = getDbConnection(prefs);
		
		ArangoCollection arangoCollection =  arangoDB.collection(prefs.getValue(CIDefinitionPortletKeys.CI_CLASS_NAME,"CI_Class"));
		
		classDoc = arangoCollection.getDocument(key, BaseDocument.class);
		
		} catch(Exception e) {
			
			_log.error("Error in getCIDefinition ::" +e.getMessage());
			
		}
			
		return classDoc;
	}
	
	public static Integer getCIDefinitionCount(long companyId) {
		
		PortletPreferences prefs = getDBConfiguration(companyId);
		
		ArangoDatabase arangoDB = getDbConnection(prefs);
		
		String query = "FOR t IN "+ prefs.getValue(CIDefinitionPortletKeys.CI_CLASS_NAME,"CI_Class") +" RETURN t";

		Map<String, Object> bindVars = new MapBuilder().get();
		
		ArangoCursor<VPackSlice> cursor = arangoDB.query(query, bindVars, null,VPackSlice.class);
		
		return (int)cursor.count();
	}

	
	public static List<BaseDocument> getCIDefinitionByName(long companyId,String name) {
		
		PortletPreferences prefs = getDBConfiguration(companyId);
		
		ArangoDatabase arangoDB = getDbConnection(prefs);
		
		String query = "FOR t IN "+ prefs.getValue(CIDefinitionPortletKeys.CI_CLASS_NAME,"CI_Class") +" FILTER t.name == @name RETURN t";

		Map<String, Object> bindVars = new MapBuilder().put("name",name).get();
		
		ArangoCursor<BaseDocument> cursor = arangoDB.query(query, bindVars, null,BaseDocument.class);
		
		return cursor.asListRemaining();
	}
	
	
	public static List<BaseDocument> getCIObjects(long companyId,int start ,int end) {

		List<BaseDocument> classLists = new ArrayList<BaseDocument>();
		
		try {
		
			PortletPreferences prefs = getDBConfiguration(companyId);
			
			ArangoDatabase arangoDB = getDbConnection(prefs);
			
			String query = "FOR t IN "+ prefs.getValue(CIDefinitionPortletKeys.CI_OBJECT_NAME,"CI_Object") +" LIMIT "+ start +" , "+end+" RETURN t";
	
			Map<String, Object> bindVars = new MapBuilder().get();
			
			ArangoCursor<BaseDocument> cursor = arangoDB.query(query, bindVars, null,BaseDocument.class);
			  
			classLists =cursor.asListRemaining(); 
		
		} catch (ArangoDBException e) {
			
			_log.error("Error in getCIDefinitiones ::: " +e.getMessage());
		}
		
		return classLists;
		
	}
	
	public static List<BaseDocument> getCIObjectsByOrgIds(long companyId,List<String> orgIds,String cidefId,int start ,int end) {

		List<BaseDocument> classLists = new ArrayList<BaseDocument>();
		
		try {
		
			PortletPreferences prefs = getDBConfiguration(companyId);
			
			ArangoDatabase arangoDB = getDbConnection(prefs);
			
			/*String query = "FOR t IN "+ prefs.getValue(CIDefinitionPortletKeys.CI_OBJECT_NAME,"CI_Object") +" FILTER t.organizationId IN @organizationId && t.cidefinitionId IN @cidefinitionId LIMIT "+ start +" , "+end+" RETURN t";
			  Map<String, Object> bindVars = new MapBuilder().put("organizationId",orgIds).get();
			*/
			
			String query= 	"FOR t IN "+prefs.getValue(CIDefinitionPortletKeys.CI_OBJECT_NAME,"CI_Object") + " LET objectsIds = ( FOR edge IN "+prefs.getValue(CIDefinitionPortletKeys.CI_RELATION_NAME,"isObjectOf") +" FILTER edge._from == @from return edge._to"
					+") FILTER t._id IN objectsIds && t.organizationId IN @organizationId LIMIT "+start+","+end +" return t ";
			
			
			
			Map<String, Object> bindVars =new MapBuilder().get();
			 bindVars.put("organizationId", orgIds);
			 bindVars.put("from", cidefId);
			
			ArangoCursor<BaseDocument> cursor = arangoDB.query(query, bindVars, null,BaseDocument.class);
			  
			classLists = cursor.asListRemaining(); 
		
		} catch (ArangoDBException e) {
			
			_log.error("Error in getCIObjectsByOrgIds ::: " +e.getMessage());
		}
		
		return classLists;
		
	}
	
	public static int getCIObjectsByOrgIdsCount(long companyId,List<String> orgIds, String cidefId) {

		List<BaseDocument> classLists = new ArrayList<BaseDocument>();
		
		try {
		
			PortletPreferences prefs = getDBConfiguration(companyId);
			
			ArangoDatabase arangoDB = getDbConnection(prefs);
			
			/*String query = "FOR t IN "+ prefs.getValue(CIDefinitionPortletKeys.CI_OBJECT_NAME,"CI_Object") +" FILTER t.organizationId IN @organizationId && t.cidefinitionId IN @cidefinitionId RETURN t";
	
			  Map<String, Object> bindVars = new MapBuilder().put("organizationId",orgIds).get();
			  */
			
			String query="FOR t IN "+prefs.getValue(CIDefinitionPortletKeys.CI_OBJECT_NAME,"CI_Object") + " LET objectsIds = ( FOR edge IN "+prefs.getValue(CIDefinitionPortletKeys.CI_RELATION_NAME,"isObjectOf") +" FILTER edge._from == @from return edge._to"
                    +") FILTER t._id IN objectsIds &&  t.organizationId IN @organizationId return t " ; 
			
			
			Map<String, Object> bindVars =  new MapBuilder().get();
			 bindVars.put("organizationId", orgIds);
		     bindVars.put("from", cidefId);
			
			ArangoCursor<BaseDocument> cursor = arangoDB.query(query, bindVars, null,BaseDocument.class);
			  
			classLists = cursor.asListRemaining(); 
		
		} catch (ArangoDBException e) {
			
			_log.error("Error in getCIObjectsByOrgIdsCount ::: " +e.getMessage());
		}
		
		
		return classLists.size();
		
	}
	
	public static void insertCIObject(long companyId,String defenitionKey,JSONObject jsonObject) {
		
		try {
		
			PortletPreferences prefs = getDBConfiguration(companyId);
			
			ArangoDatabase arangoDB = getDbConnection(prefs);
			
			ArangoCollection arangoCollection =  arangoDB.collection(prefs.getValue(CIDefinitionPortletKeys.CI_OBJECT_NAME,"CI_Object"));
			
			VPackParser parser = new VPackParser.Builder().build();
			
			DocumentCreateEntity<VPackSlice> ciObject = arangoCollection.insertDocument(parser.fromJson(jsonObject.toString()));
		
			insertIsObjectOf(defenitionKey,ciObject.getId(),prefs,arangoDB);
			
			
		} catch (ArangoDBException e) {
			
			_log.error("Error in insertCIObject ::: " +e.getMessage());
		}
		
		
		
	}
	
	
	public static void insertIsObjectOf(String defenitionKey,String objectKey,PortletPreferences prefs,ArangoDatabase arangoDB) {
		
		Map<String, Object> edge = new HashMap<String, Object>();
		edge.put("_from", defenitionKey);
		edge.put("_to", objectKey);
		arangoDB.collection(prefs.getValue(CIDefinitionPortletKeys.CI_RELATION_NAME,"isObjectOf")).insertDocument(edge);
			
	}
	
	public static void updateCIObject(long companyId,String key ,JSONObject ciObject) {
		
		try {
		
			PortletPreferences prefs = getDBConfiguration(companyId);
			
			ArangoDatabase arangoDB = getDbConnection(prefs);
			
			ArangoCollection arangoCollection =  arangoDB.collection(prefs.getValue(CIDefinitionPortletKeys.CI_OBJECT_NAME,"CI_Object"));
			
			BaseDocument doc = arangoCollection.getDocument(key,BaseDocument.class);
			
			JSONArray historyArray = JSONFactoryUtil.createJSONArray(doc.getProperties().get("ChangeHistory").toString());
			
			JSONObject historyObject= JSONFactoryUtil.createJSONObject();
			
			historyObject.put("newValue", "string");
			historyObject.put("changeTimeStamp",new Date().getTime());
			historyObject.put("changedBy", "string");
			historyObject.put("attributeChanged", "string");
			historyObject.put("affectedAttributes", "string");
			historyObject.put("oldValue", "string");
			
			historyArray.put(historyObject);
			
			ciObject.put("ChangeHistory", historyArray);
			
			VPackParser parser = new VPackParser.Builder().build();
			
			arangoCollection.updateDocument(key, parser.fromJson(ciObject.toString()));
		
		}catch(Exception e) {
			
			_log.error("Error in updateCIObject ::: " + e.getMessage());
		}
	}
	
	
	public static List<BaseDocument> getCIObjectsbyCIDefinition(long companyId, String ciDefinitionId,int start ,int end) {
		
		List<BaseDocument> objDoc= new ArrayList<BaseDocument>();
		
		try {
			
			PortletPreferences prefs = getDBConfiguration(companyId);
			
			ArangoDatabase arangoDB = getDbConnection(prefs);
			
			String ciObjectQuery = "FOR ciobject IN "+prefs.getValue(CIDefinitionPortletKeys.CI_OBJECT_NAME,"CI_Object") + " LET objectsIds = ( FOR edge IN "+prefs.getValue(CIDefinitionPortletKeys.CI_RELATION_NAME,"isObjectOf") +" FILTER edge._from == @from return edge._to"
					+") FILTER ciobject._id IN objectsIds LIMIT "+start+","+end +" return ciobject ";
			
			_log.info(ciObjectQuery);
	
			Map<String, Object> bindVars = new MapBuilder().put("from",ciDefinitionId).get();
	 
			ArangoCursor<BaseDocument> cursor = arangoDB.query(ciObjectQuery, bindVars, null,BaseDocument.class);
	  
			objDoc = cursor.asListRemaining();
			
		}catch(Exception e) {
			
			_log.error("Error in getCIObjectsbyCIDefinition ::: " + e.getMessage());

		}
		
		return objDoc;
		
	}
	
	public static JSONObject getCIObjectAsJSON(long companyId,String key) {
		
		JSONObject docObject  = JSONFactoryUtil.createJSONObject();
		
		PortletPreferences prefs = getDBConfiguration(companyId);
		
		ArangoDatabase arangoDB = getDbConnection(prefs);
		
		ArangoCollection arangoCollection =  arangoDB.collection(prefs.getValue(CIDefinitionPortletKeys.CI_OBJECT_NAME,"CI_Object"));
		
		VPackParser parser = new VPackParser.Builder().build();
		
		VPackSlice classDoc = arangoCollection.getDocument(key, VPackSlice.class);
		
		try {
			
			 docObject = JSONFactoryUtil.createJSONObject(parser.toJson(classDoc));
		
		} catch (VPackException e) {
			
			_log.error("Error in getCIClassAsJOSN VPackException :::"+e.getLocalizedMessage());
		
		} catch (JSONException e) {
			
			_log.error("Error in getCIClassAsJOSN JSONException :::"+e.getLocalizedMessage());

		}
		
		return docObject;
	}
	
	public static BaseDocument getCIObject(long companyId,String key) {
		
		BaseDocument classDoc = new BaseDocument();
		
		try {
		
		PortletPreferences prefs = getDBConfiguration(companyId);
		
		ArangoDatabase arangoDB = getDbConnection(prefs);
		
		ArangoCollection arangoCollection =  arangoDB.collection(prefs.getValue(CIDefinitionPortletKeys.CI_OBJECT_NAME,"CI_Object"));
		
		classDoc = arangoCollection.getDocument(key, BaseDocument.class);
		
		} catch(Exception e) {
			
			_log.error("Error in getCIDefinition ::" +e.getMessage());
			
		}
			
		return classDoc;
	}
	
	public static void updatedefinitionStatus(long companyId,String key,boolean status) {
		try {
		
		PortletPreferences prefs = getDBConfiguration(companyId);
		
		ArangoDatabase arangoDB = getDbConnection(prefs);
		
		String ciObjectQuery = "FOR u IN " +prefs.getValue(CIDefinitionPortletKeys.CI_CLASS_NAME,"CI_Class")+ 
				"  FILTER u._key == @key" + 
				"  UPDATE u WITH {status:@status} in "+prefs.getValue(CIDefinitionPortletKeys.CI_CLASS_NAME,"CI_Class");
		
		 Map<String, Object> bindVars = new MapBuilder().put("key",key).get();
		 bindVars.put("status",status);
		 
		 arangoDB.query(ciObjectQuery, bindVars, null,BaseDocument.class);
		  
		} catch(Exception e) {
			
			_log.error("Error in updatedefinitionStatus ::" +e.getMessage());
			
		}
	}
	
	public static void updateObjectStatus(long companyId,String key,boolean status) {
		
		try {
		
		PortletPreferences prefs = getDBConfiguration(companyId);
		
		ArangoDatabase arangoDB = getDbConnection(prefs);
		
		String ciObjectQuery = "FOR u IN " +prefs.getValue(CIDefinitionPortletKeys.CI_OBJECT_NAME,"CI_Object")+ 
				"  FILTER u._key == @key" + 
				"  UPDATE u WITH {status:@status} in "+prefs.getValue(CIDefinitionPortletKeys.CI_OBJECT_NAME,"CI_Object");
		
		 Map<String, Object> bindVars = new MapBuilder().put("key",key).get();
		 
		 bindVars.put("status",status);
		 
		 arangoDB.query(ciObjectQuery, bindVars, null,BaseDocument.class);
		  
		} catch(Exception e) {
			
			_log.error("Error in updatedefinitionStatus ::" +e.getMessage());
			
		}
	}
	
	
	public static int getCIObjectsbyCIDefinitionCount(long companyId, String ciDefinitionId) {
        
        List<BaseDocument> objDoc= new ArrayList<BaseDocument>();
        
        try {
               
               PortletPreferences prefs = getDBConfiguration(companyId);
               
               ArangoDatabase arangoDB = getDbConnection(prefs);
               
               String ciObjectQuery = "FOR ciobject IN "+prefs.getValue(CIDefinitionPortletKeys.CI_OBJECT_NAME,"CI_Object") + " LET objectsIds = ( FOR edge IN "+prefs.getValue(CIDefinitionPortletKeys.CI_RELATION_NAME,"isObjectOf") +" FILTER edge._from == @from return edge._to"
                            +") FILTER ciobject._id IN objectsIds return ciobject " ;
 
               Map<String, Object> bindVars = new MapBuilder().put("from",ciDefinitionId).get();
 
               ArangoCursor<BaseDocument> cursor = arangoDB.query(ciObjectQuery, bindVars, null,BaseDocument.class);
   
               objDoc = cursor.asListRemaining();
               
        }catch(Exception e) {
               
               _log.error("Error in getCIObjectsbyCIDefinitionCount ::: " + e.getMessage());

        }
        
        return objDoc.size();
        
 }
	
	
	
	
	
	
}
