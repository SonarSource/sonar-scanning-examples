describe('components.missingno', function() {
  var $controller, MissingnoController;

  beforeEach(angular.mock.module('ui.router'));
  beforeEach(angular.mock.module('components.missingno'));

  beforeEach(inject(function(_$controller_) {
    $controller = _$controller_;
    MissingnoController = $controller('MissingnoController', {});
  }));

  it('should be defined', function() {
    expect(MissingnoController).toBeDefined();
  });
});