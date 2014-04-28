app = angular.module "dogekb", ["ui.router"]

# Setup ui-router
app.config ($stateProvider, $urlRouterProvider) ->
    # Make home the default state
    $urlRouterProvider.otherwise("/");

    # Setup our states
    $stateProvider
        .state("home",
            url: "/"
            templateUrl: "templates/home.html"
        )
        .state("about",
            url: "/about"
            templateUrl: "templates/about.html"
        )
        .state("contact",
            url: "/contact"
            templateUrl: "templates/contact.html"
        )

# Keep the active nav up to date
app.controller "nav", ($scope, $state) ->
    $scope.$on "$stateChangeSuccess", (event, newState) ->
        $scope.activeState = newState.name
