app = angular.module "dogekb", []

app.controller "helloWorld", ($scope) ->
    $scope.isRed = false
    $scope.toggleRedness = ->
        $scope.isRed = not $scope.isRed
