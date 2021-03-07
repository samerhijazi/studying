# Ref.
* https://hyperledger-fabric.readthedocs.io/en/release-1.4/
* https://hyperledger-fabric-ca.readthedocs.io/en/release-1.4/

# Bootstrap-Base
* https://github.com/hyperledger/fabric         # /bin/ && /config/
* https://github.com/hyperledger/fabric-ca      # /bin/fabric-ca-client && /bin/fabric-ca-server

# Names
* CA (Certificate Authorities): issue identities by generating a public and private key.
* MSP (Member Service Provider): contains a list of permissioned identities
* Orderer: validates & generates a new configuration transaction, and packages it into a block, then broadcaste to all peers on the channel.
* AnchorPeer: define the location of peer which can be used for "cross-org gossip communication".
* TLS (Transport Layer Security): Secure all communication between nodes. Certificates for Transport/communications. 

# Life-Cycle
* Generate configuration crypto
* Generate configuration genesis
* Generate configuration channel
* Generate configuration anchor
..................................
* Expand Network: Peer
* Expand Network: Anchor
* Expand Network: Channel
* Expand Network: MultiOrg
..................................
* Chaincode install
* Chaincode upgrade
..................................
* Infrastrukture: CouchDB
* Infrastrukture: Kafka
..................................
* CA (Certificate Authorities)
* TLS (Transport Layer Security)
* Discovery

# Settings 'TX'
* Organizations
* Capabilities
* Application
* Orderer
* Channel
* Profiles