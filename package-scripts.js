module.exports = {
  scripts: {
    default: 'hugo',
    clean: 'rm -rf public resources data/* docker.txt',
    updateRepos: {
      docker:
        'curl -a "https://raw.githubusercontent.com/cibuilds/hugo/master/build-images.sh" > docker.txt'
    },
    build: 'nps clean && nps u.d && hugo --minify --gc',
    watch: 'nps build && hugo server'
  }
};
