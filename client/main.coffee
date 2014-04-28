app = angular.module "dogekb", ["ui.router"]

# Setup ui-router
app.config ($stateProvider, $urlRouterProvider, $provide) ->
    # Make home the default state
    $urlRouterProvider.otherwise("/");

    # Setup our states
    $stateProvider
        .state "home",
            url: "/"
            templateUrl: "templates/home.html"
        .state "contact",
            url: "/contact"
            templateUrl: "templates/contact.html"
        .state "login",
            url: "/login"
            templateUrl: "templates/login.html"
            controller: "login"
        .state "signup",
            url: "/signup"
            templateUrl: "templates/signup.html"

    # Override q to add sucess and error functions
    # http://stackoverflow.com/a/17889426/375847
    $provide.decorator "$q", ($delegate) ->
        defer = $delegate.defer
        $delegate.defer = ->
            deferred = defer()
            deferred.promise.success = (fn) ->
                deferred.promise.then (value) ->
                    fn value
                return deferred.promise
            deferred.promise.error = (fn) ->
                deferred.promise.then null, (value) ->
                    fn value
                return deferred.promise
            return deferred
        return $delegate

# Keep the active nav up to date
app.controller "nav", ($scope, $state) ->
    $scope.$on "$stateChangeSuccess", (event, newState) ->
        $scope.activeState = newState.name

# Keep the auth status up to date
app.controller "authStatus", ($scope) ->
    $scope.loggedIn = false

    $scope.$on "login", ->
        $scope.loggedIn = true

# Handle the login page
app.controller "login", ($scope, authentication) ->
    $scope.email = "giodamelio@gmail.com"
    $scope.password = "hunter2"

    $scope.login = ->
        authentication.login($scope.email, $scope.password)
            .success (value) ->
                console.log value
            .error (value) ->
                console.log value

# Authentication service
app.factory "authentication", ($http, $window, $q, $rootScope) ->
    return {
        isAuthenticated: false
        login: (email, password) ->
            deferred = $q.defer()
            $http
                method: "POST"
                url: "/auth/login"
                data:
                    email: email
                    password: password
            .success (data, status, headers, config) =>
                # Save the token
                $window.sessionStorage.token = data.token

                # Save status in this service
                @isAuthenticated = true

                # Broadcast an event
                $rootScope.$broadcast "login"

                deferred.resolve "Success"
            .error (data, status, headers, config) =>
                # Erase the token if the user fails to log in
                delete $window.sessionStorage.token

                # Save status in this service
                @isAuthenticated = false

                deferred.reject "Fail"
            return deferred.promise
    }
