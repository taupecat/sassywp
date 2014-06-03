var gulp			= require('gulp'),
	sass			= require('gulp-ruby-sass'),
	autoprefixer	= require('gulp-autoprefixer'),
	minifycss		= require('gulp-minify-css'),
	rename			= require('gulp-rename'),
	clean			= require('gulp-clean'),
	gutil			= require('gulp-util');

// Styles
gulp.task('styles', function() {
	return gulp.src('src/sass/*.scss')
		.pipe(sass({ style: 'expanded' }))
		.on( 'error', gutil.log )
		.pipe(autoprefixer('last 2 version', 'safari 5', 'ie 8', 'ie 9', 'opera 12.1', 'ios 6', 'android 4'))
		.pipe(gulp.dest('wp-content/themes/twentythirteen/css'))
		.pipe(rename({suffix: '.min'}))
		.pipe(minifycss())
		.pipe(gulp.dest('wp-content/themes/twentythirteen/css'));
});

// Clean
gulp.task('clean', function() {
	return gulp.src(['wp-content/themes/twentythirteen/css'], {read: false})
		.pipe(clean());
});

// Default
gulp.task('default', ['clean'], function() {
	gulp.start('styles');
});

// Watch
gulp.task('watch', function() {
	gulp.start('default');

	// Watch .scss files
	gulp.watch('src/sass/**/*.scss', ['styles']);
});
