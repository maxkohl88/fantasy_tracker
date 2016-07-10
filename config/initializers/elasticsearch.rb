index_configs = YAML.load_file("config/elasticsearch.yml").symbolize_keys

client = Elasticsearch::Client.new

index_configs.each do |index, body|
	unless client.indices.exists? index: index
		client.indices.create index: index, body: body
	end
end
