(function() {
  'use strict';

  angular.module('components.missingno', [])
  .controller('MissingnoController', function() {
    var vm = this;
  })
  .config(function($stateProvider) {
    $stateProvider
      .state('404', {
        url: '/404',
        templateUrl: 'components/missingno/missingno.html',
        controller: 'MissingnoController as mn'
      });
  });
})();