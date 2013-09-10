'use strict';

module.exports = function(grunt) {

  // Project configuration.
  grunt.initConfig({
    // Metadata.
    pkg: grunt.file.readJSON('package.json'),
    banner: '/*! <%= pkg.name %> - v<%= pkg.version %> - ' +
      '<%= grunt.template.today("yyyy-mm-dd") %>\n' +
      '<%= pkg.homepage ? "* " + pkg.homepage + "\\n" : "" %>' +
      '* Copyright (c) <%= grunt.template.today("yyyy") %> <%= pkg.author.name %>;' +
      ' Licensed <%= _.pluck(pkg.licenses, "type").join(", ") %> */\n',
    // Task configuration.
    concat: {
      options: {
        banner: '<%= banner %>',
        stripBanners: true
      },
      dist: {
        src: ['lib/<%= pkg.name %>.js'],
        dest: 'dist/<%= pkg.name %>.js'
      },
    },
    uglify: {
      options: {
        banner: '<%= banner %>'
      },
      dist: {
        src: '<%= concat.dist.dest %>',
        dest: 'dist/<%= pkg.name %>.min.js'
      },
    },
    coffee: {
      lib: {
        files: {
          'lib/ember-enumerology.js': ['lib/*.coffee', 'lib/transforms/*.coffee' ],
        }
      },
      spec: {
        bare: true,
        files: {
          'spec/ember-enumerology_spec.js': ['spec/*.coffee', 'spec/transforms/*.coffee'],
        }
      }
    },
    jasmine: {
      enumerology: {
        src: 'lib/ember-enumerology.js',
        options: {
          specs: 'spec/*_spec.js',
          helpers: 'spec/*_helper.js',
          vendor: [
            'bower_components/jquery/jquery.js',
            'bower_components/handlebars/handlebars.js',
            'bower_components/ember/ember.js'
          ]
        }
      }
    },
    watch: {
      coffee_lib: {
        files: 'lib/**/*.coffee',
        tasks: [ 'coffee:lib' ]
      },
      coffee_spec: {
        files: 'spec/**/*.coffee',
        tasks: [ 'coffee:spec' ]
      },
      lib: {
        files: 'lib/ember-enumerology.js',
        tasks: [ 'jasmine:enumerology' ]
      },
      spec: {
        files: 'spec/ember-enumerology_spec.js',
        tasks: [ 'jasmine:enumerology' ]
      }
    },
  });

  // These plugins provide necessary tasks.
  grunt.loadNpmTasks('grunt-contrib-concat');
  grunt.loadNpmTasks('grunt-contrib-uglify');
  grunt.loadNpmTasks('grunt-contrib-watch');
  grunt.loadNpmTasks('grunt-contrib-jasmine');
  grunt.loadNpmTasks('grunt-contrib-coffee');

  // Default task.
  grunt.registerTask('default', ['coffee:lib', 'coffee:spec', 'jasmine:enumerology', 'concat', 'uglify']);

};
