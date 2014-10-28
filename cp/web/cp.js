angular.module('cpApp', ['ngRoute'])
  .config(function($routeProvider) {
    $routeProvider
      .when('/', {
        reloadOnSearch: false,
        controller:'MainController',
        templateUrl:'main.html'
      })
      .when('/class', {
        reloadOnSearch: true,
        controller:'ClassController',
        templateUrl:'classContent.html'
      })
      .otherwise({
        redirectTo:'/'
      });
  })
  .controller('MenuController', function($scope, $location, $routeParams) {
    $scope.cp = cp;
    $scope.classMenuClicked = function(idx) {
      console.log(idx);
      $location.path('/class').search({'id' : idx});
    }
    console.log(cp);
  })
  .controller('MainController', function($scope, $location, $routeParams) {
  })
  .controller('ClassController', function($scope, $location, $routeParams) {
    console.log('in ClassController');
    $scope.cp = cp;
    console.log($routeParams);
    if ($routeParams['id'] != null) {
      console.log('found idx');
      selectClass($scope, $routeParams.id);
    }
  })
var selectClass = function(scope, idx) {
  console.log(idx);
  console.log(scope.cp[idx]);
  scope.seriesSelected = cp[idx];
  scope.sd = cp[idx].seriesData;
  scope.classes = cp[idx].classes;
}

