/**
	* Peak_Tests - <description>
	* @author: Collin Parker
	* @version: 1.0
*/

@isTest
private class Peak_Tests {
	
	
	static testMethod void hasChangedTest() {
		
		
		List<sObject> oldList = generateTestData();
		Map<Id,sObject> accOldMap = Peak.toIdSObjMap(oldList,'Id');
		
		List<sObject> newList = oldList.deepClone(true);
		
		newList[0].put('AccountNumber','New Number inclusion');
		newList[1].put('AccountNumber','New Number exclusion');
		newList[2].put('AccountNumber','New Number generic');
		
		List<sObject> changeList = Peak.hasChanged(newList, accOldMap, 'AccountNumber', new Set<Object>{'New Number inclusion','New Number generic'}, true);
		System.assertEquals(2, changeList.size());
		
		
		changeList = Peak.hasChanged(newList, accOldMap, 'AccountNumber', new Set<Object>{'New Number inclusion','New Number generic'}, false);
		Integer listSize = changeList.size();
		System.assertEquals(newList.size() - 2, listSize);
		
		
		changeList = Peak.hasChanged(newList, accOldMap, 'AccountNumber', null, false);
		System.assertEquals(newList.size(), changeList.size() );
		
		
	}
	
	static testMethod void updateObjsTest() {
		
		List<sObject> oldList = generateTestData();
		
		List<sObject> updatedObjs = Peak.updateObjs(oldList, 'AccountNumber', 'UpdatedTestNumber');
		
		for (sObject sObj : updatedObjs) {
			System.assertEquals('UpdatedTestNumber', sObj.get('AccountNumber'));
		}
	}
	
	static testMethod void revertObjsTest() {
		
		List<sObject> oldList = generateTestData();
		Map<Id,sObject> oldMap = Peak.toIdSObjMap(oldList,'Id');
		
		List<sObject> newList = Peak.updateObjs(oldList.deepClone(true), 'AccountNumber', 'NewTestNumber');
		
		List<sObject> reObjs = Peak.revertObjs(newList, oldMap, 'AccountNumber');
		
		for (sObject sObj : reObjs) {
			System.assertNotEquals('NewTestNumber', sObj.get('AccountNumber'));
		}
		
	}
	
	static testMethod void dbRefreshTest() {
		
		List<sObject> oldList = generateTestData();
		List<sObject> refreshList = Peak.dbRefresh(oldList, 'Id, Site');
		
		for (sObject sObj : refreshList) {
			System.assertEquals(null,sObj.get('Site'));
		}
		
	}
	
	static testMethod void qStringMapTest() {
		
		List<sObject> oldList = generateTestData();
		Map<String,String> strMap = Peak.qStringMap('Account', 'Name', 'AccountNumber');
		System.assertEquals(oldList.size(),strMap.size());
	}
	
	static testMethod void toStringSetTest() {
		
		List<sObject> sObjs = generateTestData();
		Set<String> strSet = Peak.toStringSet( sObjs, 'Name' );
		System.assertEquals(sObjs.size(),strSet.size());
	}
	 
	static testMethod void toStringSObjMapTest() {
		
		List<sObject> sObjs = generateTestData();
		Map<String,sObject> objMap = Peak.toStringSObjMap(sObjs, 'Name');
		System.assertEquals(sObjs.size(), objMap.keySet().size());
	}
	
	static testMethod void toIdSObjMapTest() {
		
		List<sObject> sObjs = generateTestData();
		Map<Id,sObject> objMap = Peak.toIdSObjMap(sObjs, 'Id');
		System.assertEquals(sObjs.size(), objMap.keySet().size());
	}
	
	static testMethod void toMapListTest() {
		
		List<sObject> sObjs = generateTestData();
		List<String> keySet = new List<String>{'Name'};
		Map<String,List<sObject>> objMapList = Peak.toMapList(sObjs, keySet);
		System.assertEquals(sObjs.size(), objMapList.keySet().size());
	}
	
	static testMethod void pluckTest() {
	
		List<sObject> sObjs = generateTestData();
		List<Object> valList = Peak.pluck(sObjs, 'Name');
		
		System.assertEquals(sObjs.size(),valList.size());
		
		
		for (sObject sObj : sObjs) {
			valList = Peak.pluck(sObj, new List<String>{'Name','AccountNumber'});
			System.assertNotEquals(null, sObj.get('Name'));
			System.assertNotEquals(null, sObj.get('AccountNumber'));
		}
		
	}
	
	static testMethod void firstTest() {
		
		List<sObject> sObjs = generateTestData();
		sObject fObj = Peak.first(sObjs, 'Name', 'TestAccount:0');
		System.assertNotEquals(null,fObj);
		
	}
	
	static testMethod void latestTest() {
	
		List<sObject> sObjs = generateTestData();
		sObject lObj = Peak.latest(sObjs, 'LastModifiedDate');
		System.assertNotEquals(null,lObj);
	}
	
	static testMethod void concatTest() {
		
		List<sObject> sObjs = generateTestData();
		List<Object> strList = Peak.pluck(sObjs,'Name');
		
		String cStr = Peak.concat(strList);
		System.assertNotEquals(null,cStr);
		
		cStr = Peak.concat(strList, '|');
		System.assertNotEquals(null,cStr);
	}
	
	static testMethod void toSelOptsTest() {
	
		List<sObject> sObjs = generateTestData();
		List<SelectOption> selOpts = Peak.toSelOpts(sObjs, 'Id', 'Name');
		System.assertEquals(sObjs.size()+1, selOpts.size());
		
		selOpts = Peak.sort( Peak.toSelOpts( Peak.pluck(sObjs,'Name') ) );
		System.assertEquals(sObjs.size()+1, selOpts.size());
	}
		
	static testMethod void getObjFieldsTest() {
	
		List<String> objFields = Peak.getObjFields('Account');
		System.assertNotEquals(0, objFields.size());
	}

	static testMethod void getObjLookupFieldTest() {
		
		List<String> objFields = Peak.getObjLookupFields('Account');
		System.assertNotEquals(0, objFields.size());
	}
	
	static testMethod void createObjTest() {
		
		sObject sObj = Peak.createObj('Account', null );
		System.assertNotEquals(null,sObj);
	}

	
	private static List<sObject> generateTestData() {
	
		List<Account> accs = new List<Account>();
		
		for (Integer i = 0; i < 150; i++) {
			accs.add(new Account(Name='TestAccount:'+i,AccountNumber='AccNum:'+i));
		}
		
		insert accs;
		return accs;
	}
	
	
}