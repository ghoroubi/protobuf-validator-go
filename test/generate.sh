#!/bin/bash

for i in $(basename ./*.proto .proto); do
  :
  echo "generating ${i} service"

  echo "- grpc bindings"
  protoc -I . \
    --proto_path=. \
    --proto_path="$GOPATH/src" \
    --go_out . \
    --go_opt paths=source_relative \
    --go-grpc_out . \
    --go-grpc_opt paths=source_relative \
    --validator_out=. \
    "${i}".proto

  # move generated sources
  mkdir -p generated/"${i}"
  mv ./*.go generated/"${i}"/.

done
#BASE := command 'basename ./*.yml .yml'
#for i in $(basename ./*.yml .yml); do
#  :
#
#  echo " - grpc-gateway"
#  protoc -I . \
#    --proto_path=./google \
#    --proto_path=. \
#    --proto_path="$GOPATH/src" \
#     --govalidators_out=. \
#    --grpc-gateway_out . \
#    --grpc-gateway_opt logtostderr=true \
#    --grpc-gateway_opt paths=source_relative \
#    --grpc-gateway_opt grpc_api_configuration=./"${i}".yml \
#    "${i}".proto
#
#  # move generated sources
#  #  mkdir -p generated/"${i}"_Gateway
#  mv ./*.go generated/"${i}"/.
#
#done

echo "services generated"
