(function() {
  'use strict';

  angular.module('filters.capitalize', [])
  .filter('capitalize', function() {
    return function(word) {
      return (word) ? word.charAt(0).toUpperCase() + word.substring(1) : '';
    };
  });
})();