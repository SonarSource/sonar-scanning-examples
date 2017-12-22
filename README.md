### These instuctions assume a local VirtualBox environment
This local environment has been testeed on a Windows 10 machine with 12G RAM. Pre-requites are as follows:
- Latest version of VirtualBox
- Latest version of GitBash
- Latest version of Vagrant
  - Install Vagrant Host Manager plugin by running `vagrant plugin install vagrant-hostmanager` in Git bash. This will update host files on both guest and host machines

##### Follow these instructions sequentially:
- Open a GitBash shell
- `git clone https://github.com/SonarSource/sonar-scanning-examples.git`
- `cd sonar-scanning-examples`
- `vagrant up` _(This will start jenkins and SonarQube)_
- `vagrant ssh`
- `docker ps -a` _(This is to check jenkins and SonarQube are running)_
  - If SonarQube is shown as running then navigate to http://node1:9000 _(username/password admin/admin)_ in your web browser and login
  - Install the following SonarQube plugins: `CSS, Checkstyle, Code Smells, Findbugs, PMD, Rules Compliance Index (RCI), Web and jDepend`
  - Follow instructions to restart SonarQube
- `cd /vagrant/sonarqube-scanner-maven`
- `alias mvn='docker container run -it --rm --name maven -v ~/.m2:/root/.m2 -v /var/run/docker.sock:/var/run/docker.sock -v $PWD:/maven -w /maven maven:alpine mvn'` _(Note that maven local repository will be built at ~/.m2)_
- `mvn --version` _(This should print Maven version along with Java version)_
- `mvn clean install`
  - maven surefire plugin is configured to ignore test failures so the build will not stop
  - target/classes/git.properties will be created and contains git branch, commit and committer info
- `mvn org.sonarsource.scanner.maven:sonar-maven-plugin:3.4.0.905:sonar -Dsonar.host.url=http://node1:9000`
