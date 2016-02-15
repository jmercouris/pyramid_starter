include:
  - webserver.package

Environment:
    virtualenv.managed:
        - name: /home/user/environment
        - user: user
        - requirements: salt://webserver/requirements.txt
        - require:
            - pkg: pyramid_packages

Run install:
    cmd.run:
      - name: /srv/salt/base/webserver_production/scripts/install.sh
      - cwd: /home/user
      - user: user

nginx_configuration:
  file.managed:
    - name: /etc/nginx/sites-available/source
    - source: salt://webserver_production/configuration_files/source
    - mode: 644
    - require:
      - pkg: nginx

nginx-default:
  file.absent:
        - name: /etc/nginx/sites-available/default
        - require:
              - pkg: nginx

nginx-default-en:
  file.absent:
        - name: /etc/nginx/sites-enabled/default
        - require:
              - pkg: nginx

/etc/nginx/sites-enabled/astrologized:
  file.symlink:
    - target: /etc/nginx/sites-available/source
    - require:
      - file: nginx_configuration

restart_nginx:
  cmd.run:
    - name: sudo /etc/init.d/nginx restart
    - require:
      - file: /etc/nginx/sites-enabled/source

Run start:
    cmd.run:
      - name: /srv/salt/base/webserver_production/scripts/start.sh >/dev/null 2>&1 &
      - cwd: /home/user
      - user: user
      - require:
        - cmd: "Run install"
