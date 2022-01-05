package auth

import (
	"fmt"

	"github.com/casbin/casbin"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
)

// model and policy arguments are paths to the files where we defined
// the model (which will configure Casbin's authorization mechanism
// - which in this case will be ACL) and the policy (which is a CSV
// file containing our ACL table).
func New(model, policy string) *Authorizer {
	enforcer := casbin.NewEnforcer(model, policy)
	return &Authorizer{
		enforcer: enforcer,
	}
}

type Authorizer struct {
	enforcer *casbin.Enforcer
}

// Returns whether the given subject is permitted to run the given
// action on the given object based on the model and policy used in
// Casbin's configuration.
func (a *Authorizer) Authorize(sub, obj, action string) error {
	if !a.enforcer.Enforce(sub, obj, action) {
		msg := fmt.Sprintf(
			"%s not permitted to %s to %s",
			sub,
			action,
			obj,
		)
		st := status.New(codes.PermissionDenied, msg)
		return st.Err()
	}
	return nil
}
