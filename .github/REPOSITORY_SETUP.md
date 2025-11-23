# Enterprise-Level Repository Setup Guide

This document provides an overview of the enterprise-level repository setup for the BetaVersion App project.

## Table of Contents

- [Overview](#overview)
- [Configuration Files](#configuration-files)
- [GitHub Features](#github-features)
- [Code Quality](#code-quality)
- [CI/CD](#cicd)
- [Development Workflow](#development-workflow)
- [Best Practices](#best-practices)

## Overview

This repository has been configured with enterprise-level features to ensure:

- **Code Quality**: Strict linting and analysis rules
- **Consistency**: Standardized formatting and conventions
- **Security**: Automated security checks and policies
- **Collaboration**: Clear contribution guidelines and templates
- **Automation**: CI/CD pipelines and automated checks

## Configuration Files

### Root Directory

#### `.editorconfig`

- Defines consistent coding styles across different editors
- Enforces indentation, line endings, and character encoding
- Automatically applied by most IDEs

#### `.gitattributes`

- Controls how Git handles different file types
- Defines merge strategies for specific files
- Marks generated files appropriately
- Handles line endings across platforms

#### `.env.example`

- Template for environment variables
- Documents all required configuration
- Separate configs for development, staging, and production
- **Never commit actual `.env` files!**

#### `analysis_options.yaml`

- Comprehensive Dart/Flutter linting rules
- Strict type checking enabled
- Excludes generated files from analysis
- 200+ lint rules for code quality

#### `CHANGELOG.md`

- Tracks all notable changes to the project
- Follows semantic versioning
- Categorizes changes (Added, Changed, Fixed, etc.)
- Update with every release

#### `Makefile`

- Common automation tasks
- Run `make help` to see all available commands
- Simplifies repetitive development tasks

### `.github` Directory

#### Issue Templates

Located in `.github/ISSUE_TEMPLATE/`:

1. **`bug_report.md`**

   - Template for reporting bugs
   - Includes device info, steps to reproduce, logs

2. **`feature_request.md`**

   - Template for suggesting features
   - Includes user stories, impact assessment

3. **`performance_issue.md`**

   - Template for performance problems
   - Includes metrics and profiling data

4. **`config.yml`**
   - Configures issue template behavior
   - Adds helpful links to documentation

#### Pull Request Template

Located at `.github/PULL_REQUEST_TEMPLATE.md`:

- Comprehensive PR checklist
- Code quality, testing, and security checks
- Before/after screenshots section
- Breaking changes documentation

#### Workflows

Located in `.github/workflows/`:

1. **`pr-checks.yml`**
   - Runs on every pull request
   - Code quality checks (lint, format, analyze)
   - Automated testing with coverage
   - Build verification
   - Security scanning
   - PR metadata validation

#### Other GitHub Files

1. **`CODEOWNERS`**

   - Defines code ownership by path
   - Auto-assigns reviewers for PRs
   - Update with your team structure

2. **`CONTRIBUTING.md`**

   - Complete contribution guidelines
   - Development setup instructions
   - Coding standards and conventions
   - Commit message format
   - PR process

3. **`CODE_OF_CONDUCT.md`**

   - Community guidelines
   - Expected behavior standards
   - Enforcement policies

4. **`SECURITY.md`**

   - Security policy
   - How to report vulnerabilities
   - Security best practices
   - Supported versions

5. **`dependabot.yml`**

   - Automated dependency updates
   - Checks for security vulnerabilities
   - Groups updates intelligently
   - Weekly update schedule

6. **`labeler.yml`**
   - Automatic PR labeling
   - Labels based on file changes
   - Categorizes by feature, platform, type

### `.vscode` Directory

#### `settings.json`

Enhanced with:

- **Bracket pair colorization** - Colors matching brackets
- **Bracket guides** - Visual guides for code blocks
- **File nesting** - Groups related files in explorer
- Flutter/Dart specific settings
- Git integration settings

#### `extensions.json`

Recommended VS Code extensions:

- Flutter & Dart tools
- Code quality extensions
- Git tools
- Documentation helpers
- Productivity enhancers

## GitHub Features

### Issue Templates

- **Bug Reports**: Structured bug reporting
- **Feature Requests**: Organized feature suggestions
- **Performance Issues**: Detailed performance tracking

### Pull Request Template

- Comprehensive checklist
- Testing requirements
- Security considerations
- Breaking changes documentation

### Automated Labels

- Auto-labels based on file changes
- Categorizes by feature, platform, type
- Helps with issue/PR organization

### Code Owners

- Automatic reviewer assignment
- Team-based ownership
- Path-based assignments

### Dependabot

- Automated dependency updates
- Security vulnerability alerts
- Weekly update schedule
- Grouped updates by type

## Code Quality

### Linting Rules

- 200+ enabled lint rules
- Strict type checking
- Consistent code style
- Error prevention rules

### Analysis Configuration

- Excludes generated files
- Treats certain issues as errors
- Strict language features enabled

### Formatting

- 80 character line limit
- Single quotes preferred
- Trailing commas required
- Consistent indentation (2 spaces)

## CI/CD

### PR Checks Workflow

Runs automatically on every PR:

1. **Code Quality**

   - Format verification
   - Lint checks
   - Static analysis

2. **Testing**

   - Unit tests
   - Widget tests
   - Coverage reporting

3. **Build Verification**

   - Development build
   - Staging build

4. **Security**

   - Secret scanning
   - Dependency vulnerability checks

5. **PR Metadata**
   - Conventional commit validation
   - PR size warnings

### Existing Workflows

- Production deployment
- Staging deployment
- GitHub releases
- Build and deploy pipeline

## Development Workflow

### Getting Started

1. **Clone and Setup**

   ```bash
   git clone https://github.com/betaversionio/App.git
   cd App
   make setup
   ```

2. **Install Recommended Extensions**

   - Open VS Code
   - Accept the extension recommendations

3. **Configure Environment**
   ```bash
   cp .env.example .env
   # Edit .env with your configuration
   ```

### Daily Workflow

1. **Create Feature Branch**

   ```bash
   git checkout -b feature/your-feature-name
   ```

2. **Make Changes**

   - Write code
   - Follow linting rules
   - Add tests

3. **Run Checks**

   ```bash
   make check-all  # Runs format, analyze, test
   ```

4. **Commit Changes**

   ```bash
   git commit -m "feat: add new feature"
   # Follow conventional commits format
   ```

5. **Push and Create PR**
   ```bash
   git push origin feature/your-feature-name
   # Create PR on GitHub
   ```

### Common Commands

```bash
# Development
make run-dev              # Run development flavor
make test                 # Run tests
make test-watch           # Run tests in watch mode
make coverage             # Generate coverage report

# Code Quality
make format               # Format code
make analyze              # Analyze code
make check-all            # Run all checks

# Building
make build-dev            # Build development APK
make build-stg            # Build staging APK
make build-prod           # Build production APK

# Dependencies
make get                  # Get dependencies
make upgrade              # Upgrade dependencies
make outdated             # Check outdated packages

# Code Generation
make gen                  # Run code generation
make gen-watch            # Run in watch mode

# Utilities
make clean                # Clean build artifacts
make doctor               # Run Flutter doctor
make help                 # Show all commands
```

## Best Practices

### Commits

- Use conventional commit format
- Write clear, descriptive messages
- Keep commits focused and atomic
- Reference issues in commit messages

### Pull Requests

- Fill out the PR template completely
- Add screenshots for UI changes
- Ensure all checks pass
- Request reviews from appropriate team members
- Keep PRs reasonably sized (<1000 lines)

### Code Quality

- Run `make check-all` before committing
- Write tests for new features
- Maintain >80% code coverage
- Follow Dart/Flutter best practices
- Use meaningful variable names

### Security

- Never commit secrets or API keys
- Use `.env` for configuration
- Review security policy before committing
- Report vulnerabilities responsibly

### Documentation

- Update README for major changes
- Update CHANGELOG for releases
- Document complex logic with comments
- Keep API documentation up to date

### Testing

- Write unit tests for business logic
- Write widget tests for UI components
- Write integration tests for critical flows
- Run tests before pushing

## Features Summary

### ✅ What's Included

- **Documentation**

  - Contributing guidelines
  - Code of conduct
  - Security policy
  - Changelog template

- **GitHub Templates**

  - Issue templates (bug, feature, performance)
  - Pull request template
  - Code owners file

- **Code Quality**

  - Comprehensive linting rules
  - Strict analysis configuration
  - EditorConfig for consistency
  - Git attributes for proper handling

- **CI/CD**

  - PR validation workflow
  - Automated testing
  - Security scanning
  - Build verification

- **Automation**

  - Dependabot for dependencies
  - Auto-labeling for PRs
  - Makefile for common tasks

- **VS Code**
  - Enhanced settings (bracket colorization, file nesting)
  - Recommended extensions
  - Debug configurations
  - Task definitions

### 📋 What You Should Do Next

1. **Update Team Information**

   - Edit `.github/CODEOWNERS` with actual team members
   - Update contact emails in SECURITY.md
   - Configure team access in GitHub settings

2. **Configure Secrets**

   - Add repository secrets for CI/CD
   - Set up deployment credentials
   - Configure Firebase service accounts

3. **Enable Branch Protection**

   - Protect `main` and `dev` branches
   - Require PR reviews
   - Require status checks to pass
   - Enable administrator enforcement

4. **Set Up Environments**

   - Configure GitHub environments
   - Add environment-specific secrets
   - Set up deployment approvals

5. **Review and Customize**
   - Review all templates and adjust for your needs
   - Customize lint rules if needed
   - Add project-specific documentation

## Maintenance

### Regular Tasks

- **Weekly**: Review Dependabot PRs
- **Monthly**: Update dependencies
- **Per Release**: Update CHANGELOG
- **Quarterly**: Review and update documentation
- **As Needed**: Adjust lint rules based on team feedback

### Keeping Up to Date

- Monitor GitHub Security Advisories
- Review Flutter/Dart updates
- Update CI/CD workflows as needed
- Keep documentation current

## Support

- **Documentation**: Check the [wiki](https://github.com/betaversionio/App/wiki)
- **Discussions**: Use [GitHub Discussions](https://github.com/betaversionio/App/discussions)
- **Issues**: Report bugs or request features via issue templates
- **Security**: Report vulnerabilities via SECURITY.md guidelines

---

**Last Updated**: November 2024

This setup provides a solid foundation for enterprise-level development. Customize it to fit your team's specific needs!
