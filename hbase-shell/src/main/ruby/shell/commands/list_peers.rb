#
# Copyright The Apache Software Foundation
#
# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

module Shell
  module Commands
    class ListPeers < Command
      def help
        <<-EOF
List all replication peer clusters.

  hbase> list_peers
EOF
      end

      def command
        peers = replication_admin.list_peers

        formatter.header(%w[PEER_ID CLUSTER_KEY ENDPOINT_CLASSNAME
                            STATE REPLICATE_ALL NAMESPACES TABLE_CFS BANDWIDTH])

        peers.each do |peer|
          id = peer.getPeerId
          state = peer.isEnabled ? 'ENABLED' : 'DISABLED'
          config = peer.getPeerConfig
          namespaces = replication_admin.show_peer_namespaces(config)
          tableCFs = replication_admin.show_peer_tableCFs(id)
          formatter.row([id, config.getClusterKey,
                         config.getReplicationEndpointImpl, state,
                         config.replicateAllUserTables, namespaces, tableCFs,
                         config.getBandwidth])
        end

        formatter.footer
        peers
      end
    end
  end
end
