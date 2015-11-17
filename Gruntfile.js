module.exports = function(grunt) {

	var pkg = grunt.file.readJSON('package.json');

	grunt.initConfig({
		
		connect:{
			server:{
				options:{
					port: 9000,
					livereload: true
				}
			}
		},

		sass:{
			dist:{
				options:{
					style:'expanded'
				},
				files:{
					'css/main.css': 'sass/main.scss'
				}
			}
		},

		autoprefixer:{
			options:{
				browsers: ['last 2 version', 'ie 9']
			},
			dist:{
				src: ['css/main.css']
			}
		},

		cssmin:{
			minify:{
				expand:true,
				src:['css/main.css'],
				dest:'',
				ext:'.min.css'
			}
		},


		watch:{
			html:{
				files: '**/*.html',
				tasks: '',
				options:{
					livereload: true
				}
			},
			sass:{
				files:['sass/**/*.scss'],
				tasks:['sass','autoprefixer','cssmin'],
				options:{
					livereload: true
				}
			}
		}
	});

	var taskName;
	for (taskName in pkg.devDependencies) {
		if (taskName.substring(0, 6)== 'grunt-') {
			grunt.loadNpmTasks(taskName);
		}
	}

	grunt.registerTask('default', ['connect','watch','sass','autoprefixer','cssmin']);
};
