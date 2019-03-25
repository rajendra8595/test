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
