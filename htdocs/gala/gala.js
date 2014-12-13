angular.module('galaApp', ['ngSanitize', 'ngRoute', 'ui.bootstrap', 'ui.select'] //, function($compileProvider) {
  //}
  )
  .config(function($routeProvider, $compileProvider, $httpProvider, $sceDelegateProvider) {
    $compileProvider.aHrefSanitizationWhitelist(/^\s*(https?|ftp|mailto|file|itms):/);
    //$sceDelegateProvider.resourceUrlWhitelist(['^(?:http(?:s)?:\/\/)?(?:[^\.]+\.)?\(vimeo|youtube)\.com(/.*)?$', 'self']);
    //$sceDelegateProvider.resourceUrlWhitelist(/^\s*http:\/\/gd.benanderson.us.*/);
    $routeProvider
      .when('/', {
        controller:'RegisterSaleController',
        templateUrl:'partials/registerSale.html'
      })
      .when('/people', {
        controller:'PeopleController',
        templateUrl:'partials/people.html'
      })
      .otherwise({
        redirectTo:'/'
      });
    $httpProvider.interceptors.push(function($rootScope) {
      $rootScope.numOutstandingRequests = {val: 0};
      return {
       'request': function(config) {
          $rootScope.numOutstandingRequests.val++;
          //console.log('numOutstandingRequests.val++ = ' + $rootScope.numOutstandingRequests.val + ' ' + config.url);
          //console.log(config);
          return config;
        },

        'response': function(response) {
          $rootScope.numOutstandingRequests.val--;
          //console.log('numOutstandingRequests.val-- = ' + $rootScope.numOutstandingRequests.val + ' ' + response.config.url);
          //console.log(response);
          return response;
        }
      };
    });
  })
  .filter('trusted', ['$sce', function ($sce) {
    return function(url) {
        return $sce.trustAsResourceUrl(url);
    };
  }])
  .controller('ParentController', function($rootScope, $scope, $location, $routeParams, $http, $modal) {
    $rootScope.$watch('numOutstandingRequests.val', function(newValue, oldValue) {
      if (typeof newValue == "undefined" || newValue == null) {
        newValue = 0;
      }
      if (typeof oldValue == "undefined" || oldValue == null) {
        oldValue = 0;
      }
      if (newValue > 0 && oldValue == 0) {
        $rootScope.openLoadingModal();
      } else if (newValue == 0 && oldValue > 0) {
        $rootScope.closeLoadingModal();
      }
    });
    $scope.initialDataAvailable = {val: false};
    $scope.peopleAvailable = {val: false};
    $scope.itemsAvailable = {val: false};

    $scope.personSelected = {val: undefined};
    $scope.itemSelected = {val: undefined};
    $scope.amount = {val: undefined};
    $scope.purchases = {val: undefined};
    $scope.tabs = [
      {label: "Register Sale", link: "#/"},
      {label: "Purchases By Person", link: "#/people"}
    ];
    $scope.selectedTab = $scope.tabs[0];    
    for (var i=0; i < $scope.tabs.length; i++) {
      var tab = $scope.tabs[i];
      if ($location.path().indexOf(tab.link.substring(1)) != -1) {
        $scope.selectedTab = tab;
      }
    }
    $scope.useMocks = false;
    $scope.showJson = false;
    $scope.urls = {};
    var sc = $scope.urls;
    if (!$scope.useMocks) {
      var baseUrl = 'https://script.google.com/macros/s/AKfycbyS_HfztKiChcRDjfo1yNvrNGtolex1TuFcwplLciboEtweNPII/exec?callback=JSON_CALLBACK&';
      sc.fetchAllItemsUrl = baseUrl + 'action=fetchAllItems';
      sc.fetchAllPeopleUrl = baseUrl + 'action=fetchAllPeople';
      
      sc.registerSaleUrl = baseUrl + 'action=registerSale';
      sc.getPurchasesUrl = baseUrl + 'action=getPurchases';
      sc.deletePurchaseUrl = baseUrl + 'action=deleteSale';
      
    } else {
      sc.fetchAllItemsUrl = 'mocks/items.js?callback=JSON_CALLBACK';
      sc.fetchAllPeopleUrl = 'mocks/people.js?callback=JSON_CALLBACK';
      sc.registerSaleUrl = 'mocks/registerSale.json';
    }

    $scope.itemType = {};
    $scope.itemTypes = [
      {
        "key": "silentAuction",
        "display": "Silent Auction",
      },{
        "key": "liveAuction",
        "display": "Live Auction",
      },{
        "key": "paddleCall",
        "display": "Paddle Call",
      },{
        "key": "balloon",
        "display": "Balloon",
      },{
        "key": "winePull",
        "display": "Wine Pull",
      }
    ];
    $scope.itemTypesByKey = {};
    for (var i=0; i < $scope.itemTypes.length; i++) {
      $scope.itemTypesByKey[$scope.itemTypes[i].key] = $scope.itemTypes[i];
    }
    console.log($scope.itemTypesByKey);

    $http.jsonp($scope.urls.fetchAllPeopleUrl).success(function(data) {
      $scope.people = data;
      for (var i=0; i < data.data.length; i++) {
        var fullName = data.data[i]["First_Names"] + " " + data.data[i]["Last_Names"];
        data.data[i].fullName = fullName;
      }
      $scope.peopleAvailable.val = true;
    });

    $http.jsonp($scope.urls.fetchAllItemsUrl).success(function(data) {
      $scope.items = data;
      $scope.itemsById = {};
      for (var i=0; i < data.data.length; i++) {
        var searchStr = data.data[i]["A00_Item_#"] + " - " + data.data[i]["Business"] + " - " + data.data[i]["Item"];
        data.data[i].searchStr = searchStr;
        $scope.itemsById[data.data[i]["A00_Item_#"]] = data.data[i];
      }
      $scope.itemsAvailable.val = true;
    });

    $rootScope.loadingModal = {val: null};
    $rootScope.openLoadingModal = function() {
      if ($rootScope.loadingModal.val == null) {
        $rootScope.loadingModal.val = $modal.open({
          templateUrl: 'partials/loading.html',
          controller: 'ModalController',
          backdrop : 'static'
        });
      }
    }
    $rootScope.closeLoadingModal = function() {
      $rootScope.loadingModal.val.close();
      $rootScope.loadingModal.val = null;
    }
    $rootScope.openLoadingModal();
  })
  .controller('ModalController', function($scope, $location, $routeParams, $http) {
  })
  .controller('TabsController', function($scope, $location, $routeParams, $http) {
    $scope.setSelectedTab = function(tab) {
      $scope.selectedTab = tab;
    }
    
    $scope.tabClass = function(tab) {
      if ($scope.selectedTab == tab) {
        return "active";
      } else {
        return "";
      }
    }
  })
  .controller('RegisterSaleController', function($scope, $location, $routeParams, $http) {
    $scope.saleSubmitted = undefined;

    $scope.formSubmitAttempted = false;
    $scope.fieldErrors = {};
    $scope.getClass = function(field) {
      if ($scope.formSubmitAttempted && field.hasError) {
        return "has-error";
      }
    }

    $scope.$watch('itemType.selected', function(newValue, oldValue) {
      console.log(newValue);
      if (newValue && (newValue.key == "silentAuction")) {
        $scope.itemSelected.disabled = false;
      } else if (newValue && (newValue.key == "liveAuction")) {
        $scope.itemSelected.disabled = false;
      } else if (newValue && (newValue.key == "paddleCall")) {
        $scope.itemSelected.disabled = true;
        $scope.itemSelected.val = null;
      } else if (newValue && (newValue.key == "balloon")) {
        $scope.itemSelected.disabled = true;
        $scope.itemSelected.val = null;
      } else if (newValue && (newValue.key == "winePull")) {
        $scope.itemSelected.disabled = true;
        $scope.itemSelected.val = null;
      } else {
        $scope.itemSelected.disabled = false;
      }
    });

    $scope.registerSale = function() {
      $scope.formSubmitAttempted = true;

      var formValid = true;
      if ($scope.personSelected.val == null || $scope.personSelected.val["Bid#"] == null) {
        $scope.personSelected.hasError = true;
        formValid = false;
      } else {
        $scope.personSelected.hasError = false;
      }
      if ($scope.itemType.selected == null) {
        $scope.itemType.hasError = true;
        formValid = false;
      } else {
        $scope.itemType.hasError = false;
      }
      if (!$scope.itemSelected.disabled && ($scope.itemSelected.val == null || $scope.itemSelected.val["A00_Item_#"] == null)) {
        $scope.itemSelected.hasError = true;
        formValid = false;
      } else {
        $scope.itemSelected.hasError = false;
      }
      if ($scope.amount.val == null) {
        $scope.amount.hasError = true;
        formValid = false;
      } else {
        $scope.amount.hasError = false;
      }
      if (!formValid) {
        return false;
      }

      var registerMeth = null;
      if (!$scope.useMocks) {
        var urlWParams = $scope.urls.registerSaleUrl + 
          '&people_id=' + $scope.personSelected.val["Bid#"] + 
          '&amount=' + $scope.amount.val + 
          '&description=' + $scope.itemType.selected.key;

        if (!$scope.itemSelected.disabled) {
          urlWParams = urlWParams + '&item_id=' + $scope.itemSelected.val["A00_Item_#"];
        } else {
          urlWParams = urlWParams + '&type=' + $scope.itemType.selected.key;
        }

        registerMeth = $http.jsonp(urlWParams);
      } else {
        var params = {
          "person": $scope.personSelected.val["Bid#"],
          "amount": $scope.amount.val,
          "description": $scope.itemType.selected.key
        }
        if (!$scope.itemSelected.disabled) {
          params["item"] = $scope.itemSelected.val["A00_Item_#"];
        }
        registerMeth = $http.post('mocks/registerSale.json', params)
      }
      registerMeth
        .success(function(data, status, headers, config) {
          $scope.saleSubmitted = true;
          $scope.saleSubmittedClass = "alert-success";
          $scope.saleSubmittedMessage = "sale registered successfully";
          $scope.itemType.selected = null;
          $scope.itemSelected.val = null;
          $scope.amount.val = null;
        }).error(function(data, status, headers, config) {
          $scope.saleSubmitted = true;
          $scope.saleSubmittedClass = "alert-danger";
          $scope.saleSubmittedMessage = "sale registration failed";
        });
    }
  })
  .controller('PeopleController', function($scope, $location, $routeParams, $http) {
    $scope.purchasesDisplayedForBidNum = null;

    $scope.$on('$routeChangeSuccess', function(scope, next, current){
      $scope.personChanged();
    });
    $scope.getPurchases = function() {
      $http.jsonp($scope.urls.getPurchasesUrl + '&people_id=' + $scope.personSelected.val["Bid#"]).success(function(data) {
        $scope.purchasesDisplayedForBidNum = $scope.personSelected.val["Bid#"];
        $scope.purchases.val = data;
        for (var i=0; i < data.data.length; i++) {
          data.data[i].item = $scope.itemsById[data.data[i]["Item_Id"]];
          data.data[i].itemType = $scope.itemTypesByKey[data.data[i]["Description"]];
        }
      });
    }
    $scope.personChanged = function() {
      if ($scope.personSelected.val != null && $scope.personSelected.val["Bid#"] != null && 
            $scope.personSelected.val["Bid#"] != $scope.purchasesDisplayedForBidNum) {
        $scope.purchases.val = null;
        $scope.getPurchases();
      } else {
        $scope.purchases.val = undefined
      }
    };
    $scope.deletePurchase = function(p) {
      console.log('personId: '+$scope.personSelected.val["Bid#"]);
      console.log('itemId: '+p.Item_Id);
      var amt = p.Amount.substring(1, p.Amount.length-3);
      console.log('amount: '+ amt);
      var urlWParams = $scope.urls.deletePurchaseUrl + 
        '&people_id=' + $scope.personSelected.val["Bid#"] + 
        '&amount=' + amt + 
        '&item_id=' + p.Item_Id;

      $http.jsonp(urlWParams).success(function(data) {
        $scope.getPurchases();
      });
    }
  })
