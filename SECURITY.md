# Security Policy

## Supported Versions

| Version | Supported          |
| ------- | ------------------ |
| 1.x.x   | :white_check_mark: |

## Reporting a Vulnerability

If you discover a security vulnerability in shellkit, please report it responsibly:

1. **Do NOT** open a public issue
2. Email the maintainers or use GitHub's private vulnerability reporting
3. Include:
   - Description of the vulnerability
   - Steps to reproduce
   - Potential impact
   - Suggested fix (if any)

We will:
- Acknowledge receipt within 48 hours
- Provide a detailed response within 7 days
- Work on a fix and release a patch
- Credit you in the security advisory (unless you prefer to remain anonymous)

## Security Best Practices for Users

When using shellkit:

1. **Never commit secrets** - Always use `.env.local` for API keys and sensitive data
2. **Review code before sourcing** - Understand what you're loading into your shell
3. **Keep dependencies updated** - Regularly update shellkit and tools it integrates with
4. **Use local.sh for sensitive configs** - Machine-specific sensitive settings should go here
5. **Check permissions** - Ensure shellkit files have appropriate permissions
6. **Audit regularly** - Review your configuration periodically

## Known Limitations

- shellkit sources and executes shell code - only use trusted sources
- Local files (`.env.local`, `local.sh`) are excluded from git but exist on your filesystem
- Shell functions have access to your system - review third-party additions carefully

## Security Considerations

This project:
- Does not collect or transmit data
- Does not make network requests (except optional tool installations)
- Does not require root/sudo access (except for optional package installations)
- Stores all configuration locally on your machine
