// Karma configuration
// Generated on Wed Jun 01 2016 17:37:40 GMT-0400 (EDT)

module.exports = function(config) {
  config.set({

    // base path that will be used to resolve all patterns (eg. files, exclude)
    basePath: '',


    // frameworks to use
    // available frameworks: https://npmjs.org/browse/keyword/karma-adapter
    frameworks: ['jasmine'],


    // list of files / patterns to load in the browser
    files: [
      './node_modules/angular/angular.js',
      './node_modules/angular-ui-router/release/angular-ui-router.js',
      './node_modules/angular-mocks/angular-mocks.js',
      './app/services/users/users.js',
      './app/services/pokemon/pokemon.js',
      './app/components/users/users.js',
      './app/components/profile/profile.js',
      './app/components/missingno/missingno.js',
      './app/filters/capitalize/capitalize.js',
      './app/app.js',
      './app/services/users/users.spec.js',
      './app/services/pokemon/pokemon.spec.js',
      './app/components/users/users.spec.js',
      './app/components/profile/profile.spec.js',
      './app/components/missingno/missingno.spec.js',
      './app/filters/capitalize/capitalize.spec.js'
    ],


    // list of files to exclude
    exclude: [
    ],


    // preprocess matching files before serving them to the browser
    // available preprocessors: https://npmjs.org/browse/keyword/karma-preprocessor
    preprocessors: {
    },


    // test results reporter to use
    // possible values: 'dots', 'progress'
    // available reporters: https://npmjs.org/browse/keyword/karma-reporter
    reporters: ['spec', 'sonarqubeUnit'],


    // web server port
    port: 9876,


    // enable / disable colors in the output (reporters and logs)
    colors: true,


    // level of logging
    // possible values: config.LOG_DISABLE || config.LOG_ERROR || config.LOG_WARN || config.LOG_INFO || config.LOG_DEBUG
    logLevel: config.LOG_INFO,


    // enable / disable watching file and executing tests whenever any file changes
    autoWatch: true,


    // start these browsers
    // available browser launchers: https://npmjs.org/browse/keyword/karma-launcher
    browsers: ['Chrome'],

    sonarQubeUnitReporter: {
      sonarQubeVersion: 'LATEST',
      outputFile: 'reports/ut_report.xml',
      overrideTestDescription: true,
      testPaths: [
        './app/components/users',
        './app/components/missingno',
        './app/components/profile',
        './app/filters/capitalize',
        './app/services/pokemon',
        './app/services/users'
      ],
      testFilePattern: '.spec.js',
      useBrowserName: false
    },

    plugins: [
      'karma-chrome-launcher',
      'karma-jasmine',
      'karma-sonarqube-unit-reporter',
      'karma-spec-reporter'
    ],

    // Continuous Integration mode
    // if true, Karma captures browsers, runs the tests and exits
    singleRun: false,

    // Concurrency level
    // how many browser should be started simultaneous
    concurrency: Infinity
  })
}
