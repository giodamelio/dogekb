app = angular.module "dogekb", ["ui.router", "ui.bootstrap", "ngCookies"]

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
        .state "logout",
            url: "/logout"
            onEnter: ($state, authentication) ->
                authentication.logout()
                $state.go "home"
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

app.run ($http, $cookieStore, authentication) ->
    $http
        method: "POST"
        url: "/auth/verify"
        data:
            token: $cookieStore.get("token")
    .success (data, status, headers, config) =>
        console.log data
        if data.message == "Token is good"
            authentication.isAuthenticated true, data
    .error (data, status, headers, config) =>
        # Erase the token if the user fails to log in
        $cookieStore.remove "token"

        # Save status in this service
        authentication.isAuthenticated false

# Keep the active nav up to date
app.controller "nav", ($scope, $state) ->
    $scope.$on "$stateChangeSuccess", (event, newState) ->
        $scope.activeState = newState.name

# Keep the auth status up to date
app.controller "authStatus", ($scope) ->
    $scope.loggedIn = false

    $scope.$on "login", (event, data) ->
        $scope.loggedIn = true
        $scope.email = data.email

    $scope.$on "logout", (event) ->
        $scope.loggedIn = false
        $scope.email = ""

# Handle the login page
app.controller "login", ($scope, $state, authentication) ->
    $scope.email = "giodamelio@gmail.com"
    $scope.password = "hunter2"

    $scope.login = ->
        authentication.login($scope.email, $scope.password)
            .success (value) ->
                $state.go "home"
            .error (value) ->
                console.log value

# Authentication service
app.factory "authentication", ($http, $cookieStore, $q, $rootScope) ->
    return {
        _isAuthenticated: false
        isAuthenticated: ->
            if arguments.length == 0
                # Getting value
                return @_isAuthenticated
            else
                # Setting value
                _isAuthenticated = arguments[0]

                if arguments[0]
                    $rootScope.$broadcast "login", arguments[1]
                else
                    $rootScope.$broadcast "logout"
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
                $cookieStore.put "token", data.token

                # Save status in this service
                @isAuthenticated true, data

                deferred.resolve data
            .error (data, status, headers, config) =>
                # Erase the token if the user fails to log in
                $cookieStore.remove "token"

                # Save status in this service
                @isAuthenticated false

                deferred.reject data
            return deferred.promise
        logout: ->
            # Delete the token
            $cookieStore.remove "token"

            # Send an event
            $rootScope.$broadcast "logout"
    }
