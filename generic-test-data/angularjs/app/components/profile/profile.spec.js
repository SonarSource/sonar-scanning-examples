describe('components.profile', function() {
  var $controller, PokemonFactory, $q, $httpBackend, $state;
  var API = 'http://pokeapi.co/api/v2/pokemon/';
  var RESPONSE_SUCCESS = {
    'id': 58,
    'name': 'growlithe',
    'sprites': {
      'front_default': 'http://pokeapi.co/media/sprites/pokemon/58.png'
    },
    'types': [{
      'type': { 'name': 'fire' }
    }]
  };
  var RESPONSE_ERROR = {
    'detail': 'Not found.'
  };

  beforeEach(angular.mock.module('ui.router'));
  beforeEach(angular.mock.module('api.pokemon'));
  beforeEach(angular.mock.module('components.profile'));


  beforeEach(inject(function(_$controller_, _Pokemon_, _$q_, _$httpBackend_, _$state_) {
    $controller = _$controller_;
    PokemonFactory = _Pokemon_;
    $q = _$q_;
    $httpBackend = _$httpBackend_;
    $state = _$state_;
  }));

  describe('ProfileController', function() {
    var ProfileController;

    beforeEach(function() {
      singleUser = {
        id: '2',
        name: 'Bob',
        role: 'Developer',
        location: 'New York',
        twitter: 'billybob',
        pokemon: { name: 'growlithe' }
      };

      ProfileController = $controller('ProfileController', { resolvedUser: singleUser, Pokemon: PokemonFactory, $state: $state });
    });

    it('should be defined', function() {
      expect(ProfileController).toBeDefined();
    });
  });

  describe('Profile Controller with a valid resolved user and a valid Pokemon', function() {
    var singleUser, ProfileController;

    beforeEach(function() {
      singleUser = {
        id: '2',
        name: 'Bob',
        role: 'Developer',
        location: 'New York',
        twitter: 'billybob',
        pokemon: { name: 'growlithe' }
      };

      spyOn(PokemonFactory, "findByName").and.callThrough();

      ProfileController = $controller('ProfileController', { resolvedUser: singleUser, Pokemon: PokemonFactory, $state: $state });
    });

    it('should set the view model user object to the resolvedUser', function() {
      expect(ProfileController.user).toEqual(singleUser);
    });

    it('should call Pokemon.findByName and return a Pokemon object', function() {
      expect(ProfileController.user.pokemon.id).toBeUndefined();
      expect(ProfileController.user.pokemon.name).toEqual('growlithe');
      expect(ProfileController.user.pokemon.image).toBeUndefined();
      expect(ProfileController.user.pokemon.type).toBeUndefined();
    
      $httpBackend.whenGET(API + singleUser.pokemon.name).respond(200, $q.when(RESPONSE_SUCCESS));
      $httpBackend.flush();

      expect(PokemonFactory.findByName).toHaveBeenCalledWith('growlithe');
      expect(ProfileController.user.pokemon.id).toEqual(58);
      expect(ProfileController.user.pokemon.name).toEqual('growlithe');
      expect(ProfileController.user.pokemon.image).toContain('.png');
      expect(ProfileController.user.pokemon.type).toEqual('fire');
    });
  });
  
  describe('Profile Controller with a valid resolved user and an invalid Pokemon', function () {
    var singleUser, ProfileController;

    beforeEach(function() {
      singleUser = {
        id: '2',
        name: 'Bob',
        role: 'Developer',
        location: 'New York',
        twitter: 'billybob',
        pokemon: { name: 'godzilla' }
      };

      spyOn(PokemonFactory, "findByName").and.callThrough();

      ProfileController = $controller('ProfileController', { resolvedUser: singleUser, Pokemon: PokemonFactory, $state: $state });
    });

    it('should call Pokemon.findByName and default to a placeholder image', function() {
      expect(ProfileController.user.pokemon.image).toBeUndefined();
    
      $httpBackend.whenGET(API + singleUser.pokemon.name).respond(404, $q.reject(RESPONSE_ERROR));
      $httpBackend.flush();

      expect(PokemonFactory.findByName).toHaveBeenCalledWith('godzilla');
      expect(ProfileController.user.pokemon.image).toEqual('http://i.imgur.com/HddtBOT.png');
    });
  });
  
  describe('Profile Controller with an invalid resolved user', function() {
    var singleUser, ProfileController;

    beforeEach(function() {
      spyOn($state, "go");
      spyOn(PokemonFactory, "findByName");

      ProfileController = $controller('ProfileController', { resolvedUser: singleUser, Pokemon: PokemonFactory, $state: $state });
    });

    it('should redirect to the 404 page', function() {
      expect(ProfileController.user).toBeUndefined();
      expect(PokemonFactory.findByName).not.toHaveBeenCalled();
      expect($state.go).toHaveBeenCalledWith('404');
    });
  });
});