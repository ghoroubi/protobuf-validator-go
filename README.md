# Golang ProtoBuf Validator Compiler

[![Apache 2.0 License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](LICENSE)

This package is a plugin that uses google protobuf validators to generate validation methods for grpc inputs. You can
use this plugin with `protoc` utility.

## Requirements

- Go 1.13 or higher (recommended, although there is no problem using with earlier versions)
- [Protobuf](https://github.com/protocolbuffers/protobuf)

## Usage

Declare a protobuf (version 3):

```proto
syntax = "proto3";
package protobuf.validator;
option go_package = ".;pb";
import "gitlab.yourypto.com/core/common-modules/protobuf-validator-go/validator.proto";

message SubMessage {
  // an integer, only little than 10 and greater than 0.
  int32 i = 1 [(validator.field) = {int_gt: 0, int_lt: 10}];
  // an integer, only little than or equal to  10 and greater than or equal to 0.
  double f = 2 [(validator.field) = {int_gte: 0, int_lte: 10}];
}

message MainMessage {
  // a string lowercase alpha-numeric of 8 to 20 characters.
  string username = 1 [(validator.field) = {regex: "^[a-z0-9]{8,20}$"}];
  // for mandatory fields use `msg_exist`, error if null.
  SubMessage msg = 2 [(validator.field) = {msg_exists : true}];
}
```

Using this package you don't have to change your generated codes.

### Generated code

```go
func (s *SubMessage) Validate() error {
    if !(s.I > 0) {
        return errors.New("validation failed, SubMessage.I must be greater than '0'")
    }
    if !(s.I < 10) {
        return fmt.Errorf("validation failed, SubMessage.I must be less than '10'")
    }
    if !(s.F >= 0) {
        return fmt.Errorf("validation failed, SubMessage.F must be greater than or equal to '0'")
    }
    if !(s.F <= 1) {
        return fmt.Errorf("validation failed, SubMessage.F must be less than or equal to '10'")
    }
    
    return nil
}

var _regex_Main_Username = regexp.MustCompile("^[a-z0-9]{5,30}$")

func (m *MainMessage) Validate() error {
    if !_regex_MainMessage_Username.MatchString(m.Username) {
        return fmt.Errorf("validation failed, MainMessage.Username must match to regex '^[a-z0-9]{8,20}$'")
    }
    if nil == m.Msg {
        return fmt.Errorf("validation failed: MainMessage.Msg message must exist")
    }
    if this.Inner != nil {
        if err := validators.CallValidatorIfExists(m.Msg); err != nil {
            return err
        }
    }

    return nil
}
```

## Installing and using

When you want to compile your protobuf using `protoc` all of the plugins should have a binary in your $PATH. When you
use go get for fetching this plugin package, a binary would be created in $GOBIN, so add $GOBIN to your $PATH:

```sh
export PATH=${PATH}:${GOPATH}/bin
```

The last step is adding some parameter for using the plugin, you can see an example here:

```sh
protoc  
  --proto_path=${GOPATH}/src 
  --proto_path=${GOPATH}/src/github.com/google/protobuf/src 
  --proto_path=. 
  --go_out=. 
  --govalidators_out=. 
  *.proto
```

The result is a grpc stub *.pb.go file plus message.validator.pb.go which validates your code. note that generated
golang structures have a Validate method that returns an error.

## License

`protobuf-validator-go` is released under the Apache 2.0 license. See the [LICENSE](LICENSE) file.
