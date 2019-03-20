# Deploys k2 solr-indexer Service

stack_name = node['deploy']['fidelis']['environment']['stackname'] || node[:opsworks][:stack][:name]
instance_type = node["opsworks"]["instance"]["instance_type"]


node.override['event-deploy']['release'] = node['deploy']['fidelis']['environment']['release']
mysql_db_url = node['deploy']['fidelis']['environment']['mysql_master_host']
mysql_user = node['deploy']['fidelis']['environment']['mysql_user']
mysql_password = node['deploy']['fidelis']['environment']['mysql_password']


directory "/opt/k2/solr-indexer-config" do
    action :create
    owner node["tomcat"]["user"]
    group node["tomcat"]["group"]
    recursive true
end

template "/opt/k2/solr-indexer-config/solr_indexer.properties" do
  source "solr-indexer-service/solr_indexer.properties.erb"
  owner node["tomcat"]["user"]
  group node["tomcat"]["group"]
  action :create
end

execute "aws s3 cp  s3://k2.build/#{node['deploy']['fidelis']['environment']['release']}/solr-indexer-1.0.0-bin.tar.gz /opt/k2/ --region us-east-1"

bash "extract-indexer-service-tar" do
  cwd "/opt/k2"
  user "root"
  group "root"
  retries 2
  timeout 60
  code <<-EOH
    if [ -f /opt/k2/solr-indexer/bin/app.pid ]
      then
        /opt/k2/solr-indexer/bin/stop.sh > /tmp/indexer-stoplog 2>&1
        rm -rf /opt/k2/solr-indexer
        tar -xvzf solr-indexer-1.0.0-bin.tar.gz
        rm -rf solr-indexer-1.0.0-bin.tar.gz
      else
        tar -xvzf solr-indexer-1.0.0-bin.tar.gz
        rm -rf solr-indexer-1.0.0-bin.tar.gz
      fi
  EOH
end

# ["start.sh",'stop.sh'].each do |service_file|
#   cookbook_file "/opt/k2/solr-indexer/bin/#{service_file}" do
#     source "k2-services/#{service_file}"
#     owner node["tomcat"]["user"]
#     group node["tomcat"]["group"]
#     mode '0755'
#     action :create
#   end
# end

template "/opt/k2/solr-indexer/config/app.conf" do
  source "solr-indexer-service/app.conf.erb"
  mode '0777'
  owner node["tomcat"]["user"]
  group node["tomcat"]["group"]
  if instance_type.include?('.small')
    variables({
              :MIN_HEAP_SIZE => "-Xms256m",
              :MAX_HEAP_SIZE => "-Xmx256m",
    })
	elsif instance_type.include?('t2.large')
	    variables({
              :MIN_HEAP_SIZE => "-Xms2048m",
              :MAX_HEAP_SIZE => "-Xmx4096m",
			  })
		else instance_type.include?('m5.2xlarge')
		variables({
              :MIN_HEAP_SIZE => "-Xms6144m",
              :MAX_HEAP_SIZE => "-Xmx8192m",
			  })
  end
  action :create
end

execute "chown -R #{node["tomcat"]["user"]}:#{node["tomcat"]["group"]}  /opt/k2/solr-indexer"

bash "start-solr-indexer-service" do
  cwd "/opt/k2/solr-indexer/bin"
  user "root"
  group "root"
  retries 2
  timeout 60
  code <<-EOH
  if [ -f /opt/k2/solr-indexer/bin/app.pid ]
    then
      /opt/k2/solr-indexer/bin/stop.sh > /tmp/indexer-stoplog 2>&1
      /opt/k2/solr-indexer/bin/start.sh > /tmp/indexer-startlog 2>&1
    else
      /opt/k2/solr-indexer/bin/start.sh > /tmp/indexer-startlog 2>&1
  fi
  EOH
end
