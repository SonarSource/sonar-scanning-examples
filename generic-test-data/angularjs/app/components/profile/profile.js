(function() {
  'use strict';

  angular.module('components.profile', [])
  .controller('ProfileController', function(resolvedUser, Pokemon, $state) {
    var vm = this;

    if (resolvedUser) {
      vm.user = resolvedUser;
    } else {
      return $state.go('404');
    }

    Pokemon.findByName(vm.user.pokemon.name)
    .then(function(result) {
      vm.user.pokemon.id = result.id;
      vm.user.pokemon.image = result.sprites.front_default;
      vm.user.pokemon.type = result.types[0].type.name;
    })
    .catch(function(result) {
      vm.user.pokemon.image = 'http://i.imgur.com/HddtBOT.png';
    });
  })
  .config(function($stateProvider) {
    $stateProvider
      .state('profile', {
        url: '/user/:id',
        templateUrl: 'components/profile/profile.html',
        controller: 'ProfileController as pc',
        resolve: {
          resolvedUser: function(Users, $stateParams) {
            return Users.findById($stateParams.id);
          }
        }
      });
  });
})();