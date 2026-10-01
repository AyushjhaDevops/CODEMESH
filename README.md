# CodeMesh

A production-grade collaborative cloud development platform where developers can create projects, write code, execute code in secure sandboxes, collaborate in real time, share resources, use Git, perform code reviews, manage tasks, use databases, use an AI coding assistant, build applications, deploy them, and monitor them.

## Project Vision

CodeMesh is built incrementally through 24 phases, each delivering production-quality components with comprehensive testing, documentation, and security considerations.

## Technology Stack

### Frontend
- Next.js 14+
- React 18+
- TypeScript
- Tailwind CSS
- Monaco Editor

### Backend
- Node.js 20+
- TypeScript
- NestJS
- REST APIs
- WebSockets (Collaboration)

### Database
- PostgreSQL 15+
- Prisma ORM

### Infrastructure
- Docker & Docker Compose
- Redis (Caching/Realtime)
- MinIO (S3-compatible Storage)
- Kubernetes (Production)
- Terraform (IaC)

### Observability
- OpenTelemetry
- Prometheus
- Grafana
- Centralized Logging

## Repository Structure

```
codemesh/
├── apps/
│   ├── web/                 # Next.js frontend
│   ├── api/                 # NestJS backend API
│   ├── collaboration/       # WebSocket/CRDT service
│   └── execution/           # Isolated code execution service
├── packages/
│   ├── database/            # Prisma schema & migrations
│   ├── ui/                  # Shared React components
│   ├── types/               # Shared TypeScript types
│   ├── auth/                # Authentication/Authorization
│   ├── config/              # Configuration management
│   └── utils/               # Shared utilities
├── infrastructure/
│   ├── docker/              # Dockerfiles
│   ├── kubernetes/          # K8s manifests
│   ├── terraform/           # Infrastructure as code
│   └── monitoring/          # Prometheus/Grafana configs
├── docs/                    # Architecture & design docs
├── scripts/                 # Utility scripts
├── tests/                   # Integration/E2E tests
├── docker-compose.yml       # Local development
├── package.json             # Monorepo root
├── tsconfig.json            # TypeScript config
├── .env.example             # Environment template
└── README.md                # This file
```

## Development Principles

- **Modular Architecture**: Clean separation of concerns
- **SOLID Principles**: Where appropriate and beneficial
- **Strong TypeScript**: No `any` types without justification
- **Security First**: Secure defaults, defense in depth
- **Production Quality**: Not toy implementations
- **Well Tested**: Meaningful coverage for all features
- **Well Documented**: Code and architecture documentation
- **Observable**: Structured logging and tracing
- **Scalable**: Designed for growth

## Database Principles

- All schema changes via migrations
- Foreign keys enforced
- Strategic indexing
- Transactions for multi-step operations
- N+1 query prevention
- Plaintext passwords never stored
- Secrets never in source code

## API Principles

- Consistent response formats
- Comprehensive error handling
- Request validation on all endpoints
- Authentication/Authorization guards
- Rate limiting where appropriate
- Full API documentation

## Security Principles

**All user input is untrusted.**

Key focus areas:
- Authentication (mFA, Sessions, Token rotation)
- Authorization (RBAC, Resource ownership)
- CSRF/XSS prevention
- SQL injection prevention
- Command injection prevention
- Path traversal prevention
- SSRF prevention
- Secure file handling
- Container isolation
- Resource limits
- Secret management

## Getting Started

### Prerequisites
- Node.js 20+ (or use Docker)
- Docker & Docker Compose
- PostgreSQL 15+
- Redis

### Local Development

1. **Clone the repository**
   ```bash
   git clone https://github.com/AyushjhaDevops/CodeMesh.git
   cd CodeMesh
   ```

2. **Install dependencies**
   ```bash
   npm install
   ```

3. **Set up environment**
   ```bash
   cp .env.example .env.local
   ```

4. **Start development services**
   ```bash
   docker-compose up -d
   ```

5. **Run migrations**
   ```bash
   npm run db:migrate
   ```

6. **Start development servers**
   ```bash
   npm run dev
   ```

## Development Workflow

### Running Tests
```bash
npm run test
npm run test:e2e
```

### Linting & Type Checking
```bash
npm run lint
npm run type-check
```

### Building for Production
```bash
npm run build
```

## Phase Progress

- [ ] Phase 0: Repository Scaffolding ✅ (Current)
- [ ] Phase 1: Core Infrastructure Setup
- [ ] Phase 2: Authentication System
- [ ] Phase 3: Project Management
- [ ] Phase 4: Code Editor
- [ ] Phase 5-24: Additional features

## Architecture Decisions

See [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) for detailed architecture decisions, patterns, and rationale.

## Security

- This is a security-sensitive project
- Never commit secrets or credentials
- Report security issues privately (see SECURITY.md)
- All code execution is isolated and sandboxed
- Refer to [docs/SECURITY.md](docs/SECURITY.md) for security guidelines

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for development guidelines.

## License

MIT

## Support

For issues, questions, or suggestions, please open a GitHub issue.
