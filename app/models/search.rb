class Search

	def reset_player_index
		client.indices.delete index: :players
		create_player_mapping
	end

	def create_player_mapping
		client.indices.create index: 'players',
			body: {
				settings: {
					index: {
						number_of_shards: 1,
						number_of_replicas: 0,
						mapper: {
							dynamic: false
						}
					}
				},
				mappings: {
					rollup: {
						properties: {
							name: { type: 'string' },
							lifetime_win_percentage: { type: 'float' },
							league_id: { type: 'integer' },
							player_id: { type: 'integer' }
						}
					}
				}
			}
	end

	def client
		@client ||= Elasticsearch::Client.new
	end
end
