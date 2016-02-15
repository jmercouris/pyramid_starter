include:
  - webserver.package

Environment:
    virtualenv.managed:
        - name: /home/vagrant/environment
        - user: vagrant
        - requirements: salt://webserver/requirements.txt
        - require:
            - pkg: pyramid_packages

Run install:
    cmd.run:
      - name: /srv/salt/base/webserver_development/scripts/install.sh
      - cwd: /vagrant
      - user: vagrant
      - require:
        - virtualenv: Environment

Run start:
    cmd.run:
      - name: /srv/salt/base/webserver_development/scripts/start.sh >/dev/null 2>&1 &
      - cwd: /vagrant
      - user: vagrant
      - require:
        - cmd: "Run install"
