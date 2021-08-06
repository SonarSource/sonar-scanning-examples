(function() {
  'use strict';

  angular.module('components.users', [])
  .controller('UsersController', function(Users) {
    var vm = this;

    vm.users = Users.all();
  })
  .config(function($stateProvider) {
    $stateProvider
      .state('users', {
        url: '/users',
        templateUrl: 'components/users/users.html',
        controller: 'UsersController as uc'
      });
  });
})();