// Copyright 2021 Nima Ghoroubi. All Rights Reserved.
// See LICENSE for licensing terms.

package validator

import "strings"

// Validator is a general interface that allows a message to be validated.
type Validator interface {
	Validate() error
}

func CallValidatorIfExists(candidate interface{}) error {
	if validator, ok := candidate.(Validator); ok {
		return validator.Validate()
	}
	return nil
}

//FieldErrors ...
type FieldErrors struct {
	FieldStack []string
	NestedErr  error
}

func (f *FieldErrors) Error() string {
	return "invalid field " + strings.Join(f.FieldStack, ".") + ": " + f.NestedErr.Error()
}

// FieldError wraps a given Validator error providing a message call stack.
func FieldError(fieldName string, err error) error {
	if fErr, ok := err.(*FieldErrors); ok {
		fErr.FieldStack = append([]string{fieldName}, fErr.FieldStack...)
		return err
	}
	return &FieldErrors{
		FieldStack: []string{fieldName},
		NestedErr:  err,
	}
}
