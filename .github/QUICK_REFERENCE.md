# Quick Reference Card

**BetaVersion App - Developer Quick Reference**

Print this or keep it handy! 📌

---

## 🚀 Common Commands

### Daily Development

```bash
make run-dev          # Run development flavor
make test             # Run tests
make test-watch       # Run tests in watch mode
make format           # Format code
make analyze          # Analyze code
make check-all        # Run all checks (format, analyze, test)
```

### Building

```bash
make build-dev        # Build development APK
make build-stg        # Build staging APK
make build-prod       # Build production APK
```

### Maintenance

```bash
make clean            # Clean build artifacts
make get              # Get dependencies
make upgrade          # Upgrade dependencies
make gen              # Run code generation
make licenses         # Generate license report
```

### See All Commands

```bash
make help
```

---

## 📁 Project Structure

```
lib/
├── features/         # Feature modules
│   ├── auth/        # Authentication
│   ├── qbank/       # Question bank
│   ├── test/        # Tests
│   └── ...
├── core/            # Shared code
│   ├── common/
│   ├── network/
│   └── ui/
├── routes/          # Navigation
└── theme/           # Theming
```

---

## 🔄 Git Workflow

### Create Feature Branch

```bash
git checkout -b feature/your-feature-name
```

### Commit Changes

```bash
git add .
git commit -m "feat: add new feature"
```

**Commit Types**: `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`

### Before Push

```bash
make check-all
```

### Push & Create PR

```bash
git push origin feature/your-feature-name
```

Then create PR on GitHub

---

## ✅ Pre-Commit Checklist

- [ ] Code formatted (`make format`)
- [ ] No lint errors (`make analyze`)
- [ ] Tests passing (`make test`)
- [ ] No debug code left
- [ ] Environment vars not hardcoded
- [ ] Meaningful commit message

---

## 🐛 Debugging

### Flutter Doctor

```bash
flutter doctor -v
```

### Clean & Rebuild

```bash
make clean
make setup
flutter run
```

### View Logs

```bash
flutter logs
```

---

## 📖 Documentation Links

- [Contributing](CONTRIBUTING.md)
- [Architecture](../ARCHITECTURE.md)
- [Setup Guide](REPOSITORY_SETUP.md)
- [Support](SUPPORT.md)
- [Security](SECURITY.md)

---

## 🎯 Code Quality Standards

- **Line Length**: 80 characters
- **Quotes**: Single quotes
- **Trailing Commas**: Required
- **Indentation**: 2 spaces
- **Coverage**: >80%

---

## 🔐 Security Reminders

- ❌ Never commit `.env` files
- ❌ Never commit API keys
- ❌ Never commit keystore files
- ✅ Use environment variables
- ✅ Use Flutter Secure Storage

---

## 🆘 Getting Help

### Quick Help

- Slack: #mobile-dev
- Docs: GitHub Wiki
- Issues: GitHub Issues

### Emergency

- Slack: #emergency-mobile
- Email: emergency@betaversion.io

---

## 💡 Pro Tips

1. Use `make help` to see all commands
2. Run `make check-all` before committing
3. Install recommended VS Code extensions
4. Enable bracket colorization in settings
5. Use `// TODO:` for temporary code
6. Write tests for new features
7. Update CHANGELOG for releases

---

## 🎨 VS Code Shortcuts

- `F5` - Start debugging
- `Ctrl + .` - Quick fix
- `Ctrl + Shift + P` - Command palette
- `Ctrl + P` - Quick file open
- `Alt + Shift + F` - Format document

---

## 📱 Build Flavors

- **Development**: `--flavor development`
- **Staging**: `--flavor staging`
- **Production**: `--flavor production`

---

## 🧪 Testing

```bash
# All tests
make test

# Specific file
flutter test test/features/auth/auth_test.dart

# With coverage
make coverage
```

---

## 📦 Dependencies

### Update All

```bash
make upgrade
```

### Check Outdated

```bash
make outdated
```

### Add New Package

```bash
flutter pub add package_name
```

---

## 🎯 Performance

### Profile Mode

```bash
flutter run --profile
```

### Release Mode

```bash
flutter run --release
```

### Analyze Size

```bash
flutter build apk --analyze-size
```

---

## 📞 Contacts

- **Team Lead**: [Name/Slack]
- **DevOps**: #devops
- **QA**: #qa
- **Security**: security@betaversion.io

---

**Keep this handy! Print it or bookmark it.** 📌

Last Updated: November 2024
