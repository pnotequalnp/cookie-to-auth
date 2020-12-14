![Cabal](https://github.com/pnotequalnp/cookie-to-auth/workflows/Cabal/badge.svg)
![Nix](https://github.com/pnotequalnp/cookie-to-auth/workflows/Nix/badge.svg)

<div style="display: flex;">
  <img src="https://nixos.wiki/images/thumb/2/20/Home-nixos-logo.png/207px-Home-nixos-logo.png" height="50px"/>
  <img src="https://graphql-engine-cdn.hasura.io/img/hasura_logo_horizontal_white.svg" height="50px"/>
  <img src="http://jwt.io/img/logo-asset.svg" height="50px"/>
</div>

# cookie-to-auth
This is a tiny service which moves a [JWT](https://jwt.io/) from a `jwt`
cookie into an `Authorization` header in the format expected by
[Hasura](https://hasura.io/) before redirecting the request.
