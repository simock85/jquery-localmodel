module.exports = function (grunt) {

    grunt.initConfig({
        pkg: grunt.file.readJSON('package.json'),
        coffee: {
            build: {
                src: 'src/jquery-localmodel.coffee',
                dest: 'src/jquery-localmodel.js'
            }
        },
        uglify: {
            options: {
                banner: '/*! <%= pkg.title || pkg.name %> - v<%= pkg.version %> - ' +
                    '<%= grunt.template.today("yyyy-mm-dd") %>\n' +
                    '* Copyright (c) <%= grunt.template.today("yyyy") %> <%= pkg.author.name %>;' +
                    ' License: <%= pkg.licenses[0].type %> */\n'
            },
            build: {
                src: '<%= coffee.build.dest %>',
                dest: 'dist/jquery-localmodel.min.js'
            }
        },
        qunit: {
            all: ['test/**/*.html']
        }
    });

    grunt.loadNpmTasks('grunt-contrib-coffee');
    grunt.loadNpmTasks('grunt-contrib-uglify');
    grunt.loadNpmTasks('grunt-contrib-qunit');

    grunt.registerTask('default', ['coffee', 'uglify']);
    grunt.registerTask('test', ['qunit']);
};