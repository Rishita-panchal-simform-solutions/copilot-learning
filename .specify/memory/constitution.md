<!--
SYNC IMPACT REPORT
==================
Version change: (template) → 1.0.0
Modified principles: N/A (initial fill from template)
Added sections:
  - Core Principles (5 principles fully defined)
  - Technology Stack & Development Standards
  - Development Workflow
  - Governance
Removed sections: None
Templates requiring updates:
  - .specify/templates/plan-template.md ✅ reviewed — Constitution Check gates align
  - .specify/templates/spec-template.md ✅ reviewed — no changes required
  - .specify/templates/tasks-template.md ✅ reviewed — task phases align with principles
  - .github/prompts/*.md ✅ reviewed — prompt files use generic references, no stale agent names
Follow-up TODOs:
  - TODO(RATIFICATION_DATE): Original project adoption date unknown; fill when confirmed.
-->

# GithubCopilotLearning Constitution

## Core Principles

### I. MVVM Architecture (NON-NEGOTIABLE)

The project MUST follow a strict MVVM pattern with unidirectional data flow:
**Model → ViewModel → Controller → View**.

- API calls MUST originate in ViewModels; Controllers MUST NOT call APIs directly.
- Controllers MUST observe ViewModels via protocol delegates — no direct property polling.
- UI mutations (view updates, animations, layout changes) MUST occur exclusively in
  Controllers or Views, never inside ViewModels or Models.
- Navigation MUST use `UINavigationController` push/pop. Creating new VC instances to
  replace existing stack entries, or resetting the entire stack for simple back-navigation,
  is FORBIDDEN.

**Rationale**: Enforces testability, predictable state, and clear ownership boundaries
across the codebase.

### II. Networking via NetworkService (NON-NEGOTIABLE)

All network I/O MUST flow through `NetworkService` → `APIRequestServices`.

- Direct `URLSession` usage is FORBIDDEN.
- Direct `AF.request(...)` (bare Alamofire) calls outside `NetworkService` are FORBIDDEN.
- Every API endpoint MUST be declared as a `static let` constant in `AppKey.swift`.
  Hardcoded URL strings in individual feature files are FORBIDDEN.
- Internet connectivity MUST be verified with `Connectivity.verifyInternetConnection()`
  before initiating any API call.

**Rationale**: Centralised networking ensures consistent auth, error handling, logging,
and makes endpoint inventory discoverable in one place.

### III. Delegate-First Communication (NON-NEGOTIABLE)

Protocol delegates are the ONLY approved mechanism for ViewModel → Controller callbacks
and for service → consumer callbacks.

- Closure-based completion handlers for API results are FORBIDDEN in new code.
- Every custom delegate protocol MUST be declared `AnyObject`-constrained and stored as
  a `weak var` to prevent retain cycles.
- Service classes (non-ViewModel helpers that perform async work) MUST also expose their
  results via protocol delegates, not closures.

**Rationale**: Uniform callback style reduces cognitive overhead, prevents capture-list
bugs, and keeps communication patterns grep-able across the codebase.

### IV. Code Quality & Safety

- **Safe optionals**: Force-unwrap (`!`) and force-cast (`as!`) are FORBIDDEN unless the
  developer can prove — with an inline comment — that the value is guaranteed non-nil at
  that site (e.g., a storyboard outlet).
- **Early exit**: `guard` statements MUST be used for precondition checks that would cause
  a function to return early. Nested `if-let` pyramids are not acceptable.
- **Dead code**: Commented-out code, unused variables/functions/imports, and no-op
  lifecycle override stubs MUST be removed before merge.
- **Code organisation**: Each logical block MUST be separated into a clearly labeled
  `extension` preceded by a `// MARK: -` comment.
- **Naming**: `camelCase` for variables and functions; `PascalCase` for types.
  All names MUST be descriptive — single-letter names are limited to loop indices.
- **Value types**: `struct` MUST be preferred over `class` for data models and DTOs
  that do not require identity semantics or inheritance.

**Rationale**: Predictable, crash-resistant code that any team member can read and
maintain without institutional knowledge.

### V. UI Threading & Design Standards

- UI updates MUST be dispatched to the main thread. Background-thread UI mutations are
  FORBIDDEN.
- Remote images MUST be loaded via Kingfisher with `DownsamplingImageProcessor` at the
  target view size; raw `UIImage(contentsOfFile:)` or uncached downloads are not
  acceptable for remote assets.
- Colours and image names MUST NOT be inlined as string or hex literals. They MUST be
  defined as named asset catalog entries and referenced through a constants enum
  (e.g., `AppColors`, `AppImages`) or generated `R.swift` accessors.
- Storyboards and XIB files MUST be used for all screen layouts. Programmatic-only layouts
  require explicit justification.
- Size Classes MUST be applied for adaptive layouts. iPad (`Regular × Regular`) font sizes
  MUST be at least 4 pt larger than the compact-class baseline.
- Heavy or blocking operations (image processing, large data transforms) MUST be moved to
  a background `DispatchQueue` and only surface results on the main thread.

**Rationale**: Consistent visual quality, crash prevention, and accessible UI across all
supported device families.

## Technology Stack & Development Standards

- **Language**: Swift 5.0+
- **Platform**: iOS (minimum deployment target as declared in `project.yml`)
- **Dependency managers**: CocoaPods (primary) + Swift Package Manager
- **Networking**: NetworkEngine XCFramework (Alamofire-based)
- **Image loading**: Kingfisher
- **Secrets management**: Arkana — API keys and secrets MUST NOT appear in source code
- **Linting**: SwiftLint MUST pass with zero violations before any pull request is merged.
  The project follows the [Raywenderlich Swift Style Guide][style-guide].
- **Error tracking**: Sentry integration MUST remain active in all non-debug schemes.
- **Logging**: Use the project's `Logger/` module; `print()` statements are for debug
  builds only and MUST be wrapped in `DebugPrint` utilities.

## Development Workflow

1. **Branching**: Feature branches follow the `###-feature-name` convention.
2. **Secrets**: Run `arkana` after updating `.env`, then `pod install`. Never commit
   `.env` to source control.
3. **Connectivity gate**: Every ViewModel method that triggers a network call MUST call
   `Connectivity.verifyInternetConnection()` first and handle the offline case gracefully.
4. **Review checklist**: All pull requests MUST be verified against all five Core
   Principles before approval.
5. **Documentation**: Public methods and classes MUST carry a documentation comment
   (`/** ... */`) describing parameters, return value, and notable side effects.
6. **Testing**: XCTest is the approved testing framework. UI tests use `XCUITest`.
   New features SHOULD include unit tests for ViewModel logic.
7. **Beta distribution**: TestFlight is the approved channel for beta builds.
   Internal testers are managed via App Store Connect.

## Governance

This constitution supersedes all other coding guidelines, style documents, and verbal
agreements for the GithubCopilotLearning project. In the event of a conflict between this
document and any other artefact, this constitution takes precedence.

**Amendment procedure**:
1. Propose the change in a pull request that updates this file.
2. State the reason, the before/after diff of the affected principle(s), and any migration
   impact on existing code.
3. Increment `CONSTITUTION_VERSION` following semantic versioning:
   - **MAJOR**: Removal or redefinition of an existing principle in a backward-incompatible
     way.
   - **MINOR**: Addition of a new principle or materially expanded guidance.
   - **PATCH**: Clarifications, wording refinements, or typo fixes.
4. Update the `LAST_AMENDED_DATE` to the merge date.
5. Propagate changes to dependent templates (`.specify/templates/`) and prompt files
   (`.github/prompts/`) as needed.

**Compliance review**: All pull requests are subject to a constitution compliance check.
Reviewers MUST reject PRs that introduce violations of any NON-NEGOTIABLE principle
without an approved exception documented in this file.

Use `.github/copilot-instructions.md` for detailed, example-driven development guidance
that elaborates on these principles.

**Version**: 1.0.0 | **Ratified**: TODO(RATIFICATION_DATE): confirm original project adoption date | **Last Amended**: 2026-04-08
