# Demo

This demo has a purpose to demonstrate a tuist.io problem with new Dependencies API.


# Replicate the problem

- Download this repo
- Run `tuist dependencies fetch`
- Run `tuist generate --open`
- Build target: `DemoApp-Debug` (this will works fine)
- Build target: `DemoApp-Prod-Debug` (this will fail with 'No such module' error)