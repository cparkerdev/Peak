/**
	* Peak - Static Utility Library for Apex
	* @author: Collin Parker
	* @version: 0.1
*/

public class Peak {

	
	static public List<sObject> hasChanged(List<sObject> newList, Map<Id,sObject> oldMap, String fieldName, Set<Object> compareSet, Boolean inclusiveCompare) {
		
		List<sObject> filteredList = new List<sObject>();
		
		for (sObject sObj : newList) {
		
			Object newVal = sObj.get(fieldName);
			
			//if null all records are new, else there are updates as well
			if (oldMap != null) {
				
				Id sObjId = sObj.Id;
				Object oldVal;
				
				//Get updated object previous state
				sObject oldSobj = oldMap.get(sObjId);

				//Is Updated and Changed
				if ( newVal != oldVal ) {
					compareFilter(filteredList, sObj, newVal, compareSet, inclusiveCompare);
				}
				
			} else {
				compareFilter(filteredList, sObj, newVal, compareSet, inclusiveCompare);
			}
		
		}
		
		return filteredList;
	}
	
	static public List<sObject> updateObjs(List<sObject> sObjs, String field, Object val) {
		for (sObject sObj : sObjs) {
			sObj.put(field,val);
		}
		return sObjs;
	}
	static public List<sObject> revertObjs(List<sObject> sObjs, Map<Id,sObject> oldMap, String fieldName) {
		
		for (sObject sObj : sObjs) {
			
			if (oldMap != null) {
				sObject oldsObj = oldMap.get(sObj.Id);
				if ( oldsObj != null ) {
					sObj.put(fieldName,oldsObj.get(fieldName));
				}
			}
			
		}
		
		return sObjs;
	}
	static public List<sObject> dbRefresh(List<sObject> oldList, String selectFields) {
		
		Set<String> idSet = toStringSet(oldList,'Id');
		
		Schema.SObjectType token = oldList[0].Id.getSObjectType();
		Schema.DescribeSObjectResult dRes = token.getDescribe();
		
		List<sObject> refList = Database.query('select '+selectFields+' from '+dRes.getName()+' where Id IN :idSet');
		
		return refList;
	}
	
	static public sObject createObj (String objName, Id objId ) {
		return Schema.getGlobalDescribe().get(objName).newSObject(objId);
	}
	
	static public Map<String,String> qStringMap(String sObjName, String keyField, String valueField) {
		
		Map<String,String> retMap = new Map<String,String>();
		
		List<sObject> sObjs = Database.query('select '+keyField+', '+valueField+' from '+sObjName+' where '+keyField+' != null');
		
		for (SObject sObj : sObjs) {
			if ( exists(sObj.get(keyField)) ) retMap.put( String.valueOf(sObj.get(keyField)), String.valueOf(sObj.get(valueField)) );
		}
		
		return retMap;
	}
	
	static public Set<String> toStringSet( List<sObject> sObjs, String fieldName  ) {
		Set<String> objSet = new Set<String>();
		for (sObject sObj : sObjs) {
			Object val = sObj.get(fieldName);
			if(val != null) objSet.add(String.valueOf(val));
		}
		return objSet;
	}
	static public Map<String,sObject> toStringSObjMap(List<sObject> sObjs, String keyField) {
	
		Map<String,sObject> retMap = new Map<String,sObject>();
		
		for (SObject sObj : sObjs) {
			if ( exists(getFieldValue(keyField,sObj)) ) {
				retMap.put( String.valueOf(getFieldValue(keyField,sObj)), sObj );
			}
		}
		
		return retMap;
		
	}
	static public Map<Id,sObject> toIdSObjMap(List<sObject> sObjs, String keyField) {
	
		Map<Id,sObject> retMap = new Map<Id,sObject>();
		
		for (SObject sObj : sObjs) {
			if ( exists(getFieldValue(keyField,sObj)) ) {
				retMap.put( (Id)getFieldValue(keyField,sObj), sObj );
			}
		}
		
		return retMap;
		
	}
	static public Map<String,List<sObject>> toMapList (List<sObject> sObjs, String[] keys) {
		
		Map<String,List<sObject>> ret = new Map<String,List<sObject>>();
		for (sObject sObj : sObjs) {
			
			String key = concat(pluck(sObj, keys));
			if ( ret.containsKey(key) ) {
				ret.get(key).add(sObj);
			} else {
				List<sObject> newList = new List<sObject>();
				newList.add(sObj);
				ret.put(key, newList);
			}
			
		}
		return ret;
	}
	
	
	static public List<String> pluck(List<sObject> sObjs, String field) {
	
		String[] ret = new List<String>();
		for (sObject sObj : sObjs) {		
			Object fVal = sObj.get(field);
			ret.add(String.valueOf(fVal));
		}
		return ret;
	}
	static public List<Object> pluck(sObject sObj, String[] fields) {
	
		List<Object> ret = new List<Object>();

		for (String f : fields) {		
			Object fVal = sObj.get(f);
			ret.add(fVal);
		}
		return ret;
	}
	
	static public sObject first (List<sObject> sObjs, String field, Object val) {
		sObject retObj;
		if ( sObjs != null ) {
			for (sObject sObj : sObjs) {
				if (sObj.get(field) == val) retObj = sObj; break;
			}
		}
		return retObj;
	}
	static public sObject latest (List<sObject> sObjs, String dateField ) {
		
		sObject latest;
		
		for (sObject sObj : sObjs) {
			
			if (latest == null) {
				latest = sObj;
			} else {
				
				Datetime objDate = (Datetime)sObj.get(dateField);
				if ( (Datetime)latest.get(dateField) < objDate ) latest = sObj;
			}
		}
		
		return latest;
	}
	

	static public String concat (List<Object> vals, String delimiter) {
		
		Object retStr;
		
		for ( Object v :  vals ) {
			if (retStr == null) {
				retStr = v;
			} else {
				retStr += ', '+v;
			}
		}
		return String.valueOf(retStr);
	}
	static public String concat (List<Object> vals) {
		String retStr;
		for ( Object v :  vals ) {
			if (retStr == null) {
				retStr = String.valueOf(v);
			} else {
				retStr += String.valueOf(v);
			}
		}
		return retStr;
	}
		
	static public List<SelectOption> toSelOpts (List<sObject> sObjs, String key, String val) {
	
		List<SelectOption> options = new List<SelectOption>();
		options.add(new SelectOption('','<Select Value>'));
			
		for (sObject sObj : sObjs) { 
			options.add(new SelectOption(String.valueOf(sObj.get(key)),String.valueOf(sObj.get(val))));
		}
		
		return options; 
	}
	static public List<SelectOption> toSelOpts (List<String> vals) {
	
		List<SelectOption> options = new List<SelectOption>();
		options.add(new SelectOption('','<Select Value>'));
			
		for (String v : vals) { 
			options.add(new SelectOption(v,v));
		}
		
		return options; 
	}
	
	static public List<SelectOption> sort (List<SelectOption> opts) {
		opts.sort();
		return opts;
	}
	
	static public List<String> getObjFields (String objName) {
	
		List<String> fields = new List<String>();
		sObjectType sType = Schema.getGlobalDescribe().get(objName);
			
		if (sType != null) {
				
			for (sObjectField sField : sType.getDescribe().fields.getMap().values()) {
				fields.add(sField.getDescribe().getName());	
			}
		}
		
		return fields; 
	}
	
	static public List<String> getObjLookupFields (String objName) {
	
		List<String> fields = new List<String>();
		sObjectType sType = Schema.getGlobalDescribe().get(objName);
			
		if (sType != null) {
				
			for (sObjectField sField : sType.getDescribe().fields.getMap().values()) {
				DescribeFieldResult res = sField.getDescribe();
				if (res.isIdLookup()) fields.add(res.getName());	
			}
		}
		
		return fields; 
	}
	

	
	
	static public Boolean exists(Object val) {
		
		if (val != null && String.valueOf(val) != '' ) {
			return true;	
		} else {
			return false;
		}
		
	}
	static void compareFilter(List<sObject> sObjs, sObject sObj, Object val, Set<Object> compareSet, Boolean inclusiveCompare) {
	
		if ( compareSet != null) {
			if (inclusiveCompare) {
				if ( compareSet.contains(val) ) sObjs.add(sObj); 
			} else  {
				if ( !compareSet.contains(val) ) sObjs.add(sObj); 
			}
		} else {
			sObjs.add(sObj);	
		}
		
	}
	static Object getFieldValue(String fieldName, sObject sObj) {
	
		Integer dotIndex = fieldName.indexOf('.');

		if ( dotIndex == -1 ) {
			return sObj.get(fieldName);
		} else {
			
			List<String> fieldNames = fieldName.split('\\.');
			SObject childSObj = sObj.getsObject(fieldNames[0]);
			if (childSObj != null) {
				return childSObj.get(fieldNames[1]);
			} else {
				return null;	
			}
		}
	}
	static void setFieldValue(String fieldName, Object fieldVal, sObject sObj) {
		if ( fieldVal != null ) {
			sObj.put(fieldName,fieldVal);
		} else {
			System.debug(fieldName+' is NULL');
			sObj.put(fieldName,fieldVal);
		}
	}
	

}