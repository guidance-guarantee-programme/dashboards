require 'travis'

def update_builds(repository)
  builds     = []
  repo       = Travis::Repository.find(repository)
  build      = repo.last_build
  build_info = {
    label: "Build #{build.number}",
    value: "[#{build.branch_info}], #{build.state} in #{build.duration}s",
    state: build.state
  }
  builds << build_info

  builds
end

config_file = File.dirname(File.expand_path(__FILE__)) + '/../config/travis.yml'
config      = YAML.load(File.open(config_file))

SCHEDULER.every('2m', first_in: '1s') {
  unless config['repositories'].nil?
    config['repositories'].each do |data_id, repo|
      send_event(data_id, { items: update_builds(repo) })
    end
  else
    puts 'No repositories for travis.org'
  end
}
