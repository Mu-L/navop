# Navop Brand and Compatibility Contract

## Public identity that must remain

- Product name: `Navop`
- Repository: `feigeCode/navop`
- macOS bundle/icon: `Navop.app`, `Navop.icns`
- Release archives and packages: `navop-<target>.*`, `navop_*.deb`, `navop-*.rpm`, AppImage names using `navop`
- License and icon: `NAVOP_LICENSE`, `resources/navop-icon.png`
- User-visible UI, locale, help, installer, release, package, and workflow text must say Navop.

## Internal compatibility identifiers that must remain

- `onetcli` binary and CLI names
- `ProviderType::OnetCli`, `OnetCliApp`, and `onet_cli`
- `onetcli.app_info`, `onetcli-public-mcp`, and `ONETCLI_*`
- `~/.config/onetcli` and `.onetcli-sync`
- `com.onetcli.app`
- Updater compatibility for the legacy `OnetCli.app` bundle

These identifiers are protocols, persisted data, API contracts, or upgrade compatibility. Do not rename them merely for visual consistency.

## Content that must not return

- `.github/workflows/release-docs.yml`
- `.github/workflows/test-docs.yml`
- Newly imported `docs/` changes
- `feigeCode/onetcli` as the current public product repository URL
- User-visible `OnetCli`, `Onet CLI`, or `Onetcli` branding

## Conflict rule

Prefer upstream behavior and implementation improvements. Reapply Navop identity only at public surfaces, and retain the compatibility identifiers above. Treat every newly added old-brand string as suspicious; approve it only when its compatibility purpose is evident from code and tests.
