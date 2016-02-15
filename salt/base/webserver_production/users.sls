user:
  user.present:
    - shell: /bin/bash
    - home: /home/user

/home/user:
  file.directory:
    - name: /home/user
    - user: user
    - group: root
    - require:
      - user: user

