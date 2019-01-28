module.exports = {
  scripts: {
    default: 'hugo',
    clean: 'rm -rf public resources data/*',
    updateRepos: {
      copr:
        'curl -s "https://copr.fedorainfracloud.org/api_2/builds?project_id=12493&limit=1" > data/copr.json',
      snap:
        'curl -s "https://search.apps.ubuntu.com/api/v1/search?q=hugo" > data/snap.json',
      github:
        'curl -s "https://api.github.com/repos/gohugoio/hugo/releases/latest" > data/github.json',
      docker:
        'curl -a "https://raw.githubusercontent.com/cibuilds/hugo/master/build-images.sh" > docker.txt'
    },
    build: 'nps clean && nps u.c u.s u.g u.d && hugo --minify --gc',
    watch: 'hugo server'
  }
};
