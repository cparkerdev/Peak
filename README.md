# Peak v0.1

Static Function Utility Library for Apex. 
Inspired by underscorejs, attempts to remove redundant for loops in code.


## Example

	// Only return records where the Site has changed and does not equal HQ
	List<sObject> changedObjs = Peak.hasChanged(trigger.new, trigger.oldMap, 'Site', new List<String>{'HQ'}, false);
	
	// Revert records to previous values for the specified field
	List<sObject> revertObjs = Peak.revertObjs(trigger.new, trigger.oldMap, 'Site');


## Methods


- **hasChanged**<br/>
	Definition: `List<sObject> hasChanged(List<sObject> newList, Map<Id,sObject> oldMap, String fieldName, Set<Object> compareSet, Boolean inclusiveCompare)`
	Usage: `List<sObject> changedObjs = Peak.hasChanged(trigger.new, trigger.oldMap, 'Site', new List<String>{'HQ'}, false);`


- **updateObjs**<br/>
	Definition: `List<sObject> updateObjs(List<sObject> sObjs, String field, Object val)`<br/>
	Usage: `List<sObject> updatedObjs = Peak.updateObjs(trigger.new, 'Name', 'New Account Name');`<br/>


- **revertObjs**<br/>
	Definition: `List<sObject> revertObjs(List<sObject> sObjs, Map<Id,sObject> oldMap, String fieldName)`<br/>
	Usage: `List<sObject> revertedObjs = Peak.revertObjs(trigger.new, 'Site');`<br/>


- **dbRefresh**<br/>
	Definition: `List<sObject> dbRefresh(List<sObject> oldList, String selectFields)`<br/>
	Usage: `List<sObject> refreshedObjs = Peak.dbRefresh(accountList,'Id, Name, Site');`<br/>


- **createObj**<br/>
	Definition: `sObject createObj(String objName, Id objId)`<br/>
	Usage: `sObject newObj = Peak.createObj('Account', null);`<br/>


- **qStringMap**<br/>
	Definition: `Map<String,String> qStringMap(String sObjName, String keyField, String valueField)`<br/>
	Usage: `Map<String,String> strMap = Peak.qStringMap('Account', 'Name', 'AccountNumber');`<br/>


- **toStringSet**<br/>
	Definition: `Set<String> toStringSet( List<sObject> sObjs, String fieldName)`<br/>
	Usage: `Set<String> strSet = Peak.toStringSet(accountList, 'Name');`<br/>


- **toStringSObjMap**<br/>
	Definition: `Map<String,sObject> toStringSObjMap(List<sObject> sObjs, String keyField)`<br/>
	Usage: `Map<String,sObject> sObjMap = Peak.toStringSObjMap(accountList, 'Name');`<br/>


- **toIdSObjMap**<br/>
	Definition: `Map<Id,sObject> toIdSObjMap(List<sObject> sObjs, String keyField)`<br/>
	Usage: `Map<Id,sObject> sObjMap = Peak.toIdSObjMap(List<sObject> sObjs, String keyField);`<br/>


- **toMapList**<br/>
	Definition: `Map<String,List<sObject>> toMapList(List<sObject> sObjs, String[] keys)`<br/>
	Usage: `Map<String,List<sObject>> sObjMapList = Peak.toMapList(accountList, new List<String>{'AccountNumber'});`<br/>


- **pluck**<br/>
	Definition: `List<String> pluck(List<sObject> sObjs, String field)`<br/>
	Usage: `List<String> strList = Peak.pluck(accountList, 'Name');`<br/>
	Definition: `List<Object> pluck(sObject sObj, String[] fields)`<br/>
	Usage: `List<Object> Peak.pluck(accountObj, new List<String>{'Name','AccountNumber'});`<br/>
	

- **first**<br/>
	Definition: `sObject first(List<sObject> sObjs, String field, Object val)`<br/>
	Usage: `sObject accObj = Peak.first(List<sObject> sObjs, String field, Object val);`<br/>


- **latest**<br/>
	Definition: `sObject latest(List<sObject> sObjs, String dateField)`<br/>
	Usage: `sObject sObj = Peak.latest(accountList, 'LastModifiedDate');`<br/>


- **concat**<br/>
	Definitions: `String concat(List<Object> vals, String delimiter)`<br/>
	Usage: `String str = Peak.concat(new List<String>{'val1','val2'}, '|');`<br/>
	Definition: `String concat(List<Object> vals)`<br/>
	Usage: `Strign str = Peak.concat(new List<String>{'val1','val2'});`<br/>
	

- **toSelOpts**<br/>
	Definition: `List<SelectOption> toSelOpts(List<sObject> sObjs, String key, String val)`<br/>
	Usage: `List<SelectOption> selOpts = Peak.toSelOpts(accountList, 'Name', 'AccountNumber');`<br/>
	Definition: `List<SelectOption> toSelOpts(List<String> vals)`<br/>
	Usage: `List<SelectOption> selOpts = Peak.toSelOpts(new List<String>{'val1','val2','val3'});`<br/>


- **sort**<br/>
	Definition: `List<SelectOption> sort(List<SelectOption> opts)`<br/>
	Usage: `List<SelectOption> sortedOpts = Peak.sort(selectOptionsList);`<br/>


- **getObjFields**<br/>
	Definition: `List<String> getObjFields(String objName)`<br/>
	Usage: `List<String> fieldList = Peak.getObjFields('Account');`<br/>


- **getObjLookupFields**<br/>
	Definition: `List<String> getObjLookupFields(String objName)`<br/>
	Usage: `List<String> lookupFields = Peak.getObjLookupFields('Account');`<br/>



##License
The MIT License (MIT)

Copyright (c) 2013 Collin Parker &lt;Mr.Collin.Parker@gmail.com&gt;

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.