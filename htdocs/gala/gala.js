angular.module('galaApp', ['ngSanitize', 'ngRoute', 'ui.bootstrap', 'ui.select'] //, function($compileProvider) {
  //}
  )
  .config(function($routeProvider, $compileProvider) {
    $compileProvider.aHrefSanitizationWhitelist(/^\s*(https?|ftp|mailto|file|itms):/);
    $routeProvider
      .when('/', {
        controller:'RegisterSaleController',
        templateUrl:'partials/registerSale.html'
      })
      .otherwise({
        redirectTo:'/'
      });
  })
  .controller('RegisterSaleController', function($rootScope, $scope, $location, $routeParams, $http) {
    $rootScope.useMocks = false;
    var sc = $rootScope;
    console.log(sc);
    if (!$scope.useMocks) {
      var baseUrl = 'https://script.google.com/macros/s/AKfycbyS_HfztKiChcRDjfo1yNvrNGtolex1TuFcwplLciboEtweNPII/exec?';
      sc.fetchAllItemsUrl = baseUrl + 'action=fetchAllItems';
      sc.fetchAllPeopleUrl = baseUrl + 'action=fetchAllPeople';
      
      sc.registerSaleUrl = baseUrl + 'action=registerSale';
      sc.getPurchasesUrl = baseUrl + 'action=getPurchases';
    } else {
      sc.fetchAllItemsUrl = 'mocks/items.json';
      sc.fetchAllPeopleUrl = 'mocks/people.json';
      sc.registerSaleUrl = 'mocks/registerSale.json';
    }

    //$scope.itemTypeSelected = undefined;
    $scope.saleSubmitted = undefined;
    //$scope.itemType = undefined;

    $scope.itemType = {};
    $scope.itemTypes = [
      {
        "key": "silentAuction",
        "display": "silent auction",
      },{
        "key": "liveAuction",
        "display": "live auction",
      },{
        "key": "paddleCall",
        "display": "paddle call",
      },{
        "key": "balloon",
        "display": "balloon",
      },{
        "key": "winePull",
        "display": "wine pull",
      }
    ];

    $scope.countries = [ // Taken from https://gist.github.com/unceus/6501985
      {name: 'Afghanistan', code: 'AF'},
      {name: 'Åland Islands', code: 'AX'},
      {name: 'Albania', code: 'AL'},
      {name: 'Algeria', code: 'DZ'},
      {name: 'American Samoa', code: 'AS'},
      {name: 'Andorra', code: 'AD'},
    ]

    $scope.itemSelected = undefined;
    $http.get($scope.fetchAllItemsUrl).success(function(data) {
      $scope.items = data;
      for (var i=0; i < data.data.length; i++) {
        var searchStr = data.data[i]["A00_Item_#"] + " - " + data.data[i]["Business"] + " - " + data.data[i]["Item"];
        data.data[i].searchStr = searchStr;
      }
    });

    $scope.personSelected = undefined;
    $http.get($scope.fetchAllPeopleUrl).success(function(data) {
      $scope.people = data;
      for (var i=0; i < data.data.length; i++) {
        var fullName = data.data[i]["First_Names"] + " " + data.data[i]["Last_Names"];
        data.data[i].fullName = fullName;
      }
    });

    $scope.registerSale = function() {
      console.log('item type: ' + $scope.itemType.selected.key);
      console.log('item: ' + $scope.itemSelected["A00_Item_#"]);
      console.log('person: ' + $scope.personSelected["Bid#"]);
      console.log('amount: ' + $scope.amount);

      var registerMeth = null;
      if (!$scope.useMocks) {
        var urlWParams = $scope.registerSaleUrl + 
          '&item_id=' + $scope.itemSelected["A00_Item_#"] + 
          '&people_id=' + $scope.personSelected["Bid#"] + 
          '&amount=' + $scope.amount + 
          '&description=' + $scope.itemType.selected.key;

        registerMeth = $http.get(urlWParams);
      } else {
        var params = {
          "item": $scope.itemSelected["A00_Item_#"],
          "person": $scope.personSelected["Bid#"],
          "amount": $scope.amount,
          "description": $scope.itemType.selected.key
        }
        registerMeth = $http.post('mocks/registerSale.json', params)
      }
      registerMeth
        .success(function(data, status, headers, config) {
          $scope.saleSubmitted = true;
          $scope.saleSubmittedClass = "alert-success";
          $scope.saleSubmittedMessage = "sale registered successfully";
        }).error(function(data, status, headers, config) {
          $scope.saleSubmitted = true;
          $scope.saleSubmittedClass = "alert-danger";
          $scope.saleSubmittedMessage = "sale registration failed";
        });
    }

  })

