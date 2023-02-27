({
 addItem: function(component, newItem) {
    var addItem = component.getItem("addItem");
    addItem.setParams({ "item": item });
    addItem.fire();
            component.set("v.newItem",{ 'sobjectType': 'Camping_Item__c',
                    'Name': '',
                    'Quantity__c': 0,
                    'Price__c': 0,
                    'Packed__c': false });
},
    

validateItemForm: function(component) {
	var validExpense = component.find('itemform').reduce(function (validSoFar, inputCmp) {
					inputCmp.showHelpMessageIfInvalid();
					return validSoFar && inputCmp.get('v.validity').valid;
				}, true);

		return validExpense;
	}
})