#
# Cookbook Name:: percona
# Recipe:: pam_auth
#

passwords = EncryptedPasswords.new(node, node["percona"]["encrypted_data_bag"])

cookbook_file "/etc/pam.d/mysqld" do
  source "mysqld"
  owner "root"
  group "root"
  mode "0644"
end

cookbook_file "/etc/mysql/pam_auth.sql" do
  source "pam_auth.sql"
  owner "root"
  group "root"
  mode "0600"
end

# execute access grants
if passwords.root_password && !passwords.root_password.empty?
  # Intent is to check whether the root_password works, and use it to
  # load the grants if so.  If not, try loading without a password
  # and see if we get lucky
  execute "mysql-install-pam_auth" do
    command "/usr/bin/mysql -p'#{passwords.root_password}' -e '' &> /dev/null > /dev/null &> /dev/null ; if [ $? -eq 0 ] ; then /usr/bin/mysql -p'#{passwords.root_password}' < /etc/mysql/grants.sql ; else /usr/bin/mysql < /etc/mysql/grants.sql ; fi ;" # rubocop:disable LineLength
    action :nothing
    subscribes :run, resources("template[/etc/mysql/pam_auth.sql]"), :immediately
  end
else
  # Simpler path...  just try running the grants command
  execute "mysql-install-pam_auth" do
    command "/usr/bin/mysql < /etc/mysql/grants.sql"
    action :nothing
    subscribes :run, resources("template[/etc/mysql/pam_auth.sql]"), :immediately
  end
end
