#
# Cookbook Name:: percona
# Recipe:: replication
#

require "shellwords"

passwords = EncryptedPasswords.new(node, node["percona"]["encrypted_data_bag"])
server = node["percona"]["server"]
replication_sql = server["replication"]["replication_sql"]

root_pass = passwords.root_password.to_s
root_pass = Shellwords.escape(root_pass).prepend("-p") unless root_pass.empty?

# define access grants
template replication_sql do
  source "replication.sql.erb"
  variables(replication_password: passwords.replication_password)
  owner "root"
  group "root"
  mode "0600"
  sensitive true
  only_if { server["replication"]["host"] != "" || server["role"].include?("master") }
end

execute "mysql import dump" do
  command "/usr/bin/mysql #{root_pass} < #{node["percona"]["server"]["replication"]["master_dump"]}"
  action :nothing
  sensitive true
  subscribes :run, resources("template[#{replication_sql}]"), :immediately
  notifies :restart, "service[mysql]", :immediately if node["percona"]["auto_restart"]
end unless node["percona"]["server"]["replication"]["master_dump"].empty? || node['percona']['server']['role'].include?('master')

execute "mysql setup replication" do  # ~FC009 - `sensitive`
  command "/usr/bin/mysql #{root_pass} < #{replication_sql}"
  action :nothing
  subscribes :run, resources("template[#{replication_sql}]"), :immediately
  notifies :restart, "service[mysql]", :immediately if node["percona"]["auto_restart"]
  sensitive true
end

execute "mysqldump --all-databases --master-data=1" do
  command "mysqldump #{root_pass} --all-databases --master-data=1 > #{node["percona"]["server"]["replication"]["master_dump"]}"
  action :nothing
  subscribes :run, resources("execute[mysql setup replication]"), :delayed unless node["percona"]["server"]["replication"]["master_dump"].empty? && node['percona']['server']['role'].include?('slave')
  sensitive true
end
