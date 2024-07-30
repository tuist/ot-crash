#!/bin/sh

# configure node for distributed erlang with IPV6 support
if [ ! -z "$TUIST_USE_IPV6" ]; then
  export ERL_AFLAGS="-proto_dist inet6_tcp"
  export ECTO_IPV6="true"
fi
