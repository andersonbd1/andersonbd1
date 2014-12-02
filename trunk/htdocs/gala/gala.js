angular.module('galaApp', ['ngRoute', 'ui.bootstrap'] //, function($compileProvider) {
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
  .controller('RegisterSaleController', function($scope, $location, $routeParams, $http) {
    $scope.saleSubmitted = undefined;

    $scope.itemSelected = undefined;
    $http.get('mocks/items.json').success(function(data) {
      $scope.items = data;
      for (var i=0; i < data.data.length; i++) {
        var searchStr = data.data[i]["A00_Item_#"] + " - " + data.data[i]["Business"] + " - " + data.data[i]["Item"];
        data.data[i].searchStr = searchStr;
      }
    });

    $scope.personSelected = undefined;
    $http.get('mocks/people.json').success(function(data) {
      $scope.people = data;
      for (var i=0; i < data.data.length; i++) {
        var fullName = data.data[i]["First_Names"] + " " + data.data[i]["Last_Names"];
        data.data[i].fullName = fullName;
      }
    });

    $scope.registerSale = function() {
      console.log('item: ' + $scope.itemSelected["A00_Item_#"]);
      console.log('person: ' + $scope.personSelected["Bid#"]);
      console.log('amount: ' + $scope.amount);

      var params = {
        "item": $scope.itemSelected["A00_Item_#"],
        "person": $scope.personSelected["Bid#"],
        "amount": $scope.amount
      }

      $http.post('mocks/registerSale.json', params)
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

