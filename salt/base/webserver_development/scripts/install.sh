source /home/vagrant/environment/bin/activate
cd /vagrant/source
python setup.py develop
# Ignore setup scripts from unable to instantiate database (because it already exists)
initialize_source_db development.ini > /dev/null 2>&1 || true
