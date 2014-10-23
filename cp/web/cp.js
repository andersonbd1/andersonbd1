angular.module('cpApp', [])
  .controller('CpController', function($scope) {
    $scope.cp = cp;

    $scope.classMenuClicked = function(idx) {
      console.log(idx);
      console.log($scope.cp[idx]);
    }

    console.log(cp);
  })
