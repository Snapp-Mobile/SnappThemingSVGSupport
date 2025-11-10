# Change Log
All notable changes to this project will be documented in this file.

<!--
## [Unreleased] - yyyy-mm-dd

### Added
- [ISSUE-XXXX](http://tickets.projectname.com/browse/PROJECTNAME-XXXX)  
  Ticket title goes here.
- [ISSUE-YYYY](http://tickets.projectname.com/browse/PROJECTNAME-YYYY)  
  Ticket title goes here.

### Changed
- Describe changes here.

### Fixed
- Describe fixes here.

-->

## [0.0.4] - 2025-11-10

Build infrastructure improvements, API enhancements, and example application.

### Added
- Example SwiftUI application demonstrating SVG theme support with light, dark, and pink theme configurations.
- SwiftFormatLintPlugin dependency (1.0.4) for improved code linting.
- API support in `SnappThemingSVGSupportImageConverter` for both data and file URL-based image inputs via new `SnappThemingImageObject` parameter type.

### Changed
- Updated SnappTheming dependency from version 0.1.2 to track the "next" branch for latest features and fixes.
- Migrated from internal "SnappThemingSVGSupportSwiftFormatPlugin" to external SwiftFormatLintPlugin dependency.
- Refactored GitHub Actions workflow to use external `swift-coverage-action` for improved CI/CD maintainability.
- Simplified PR template to streamlined "What," "Why," "Changes" format.

### Removed
- Internal "SnappThemingSVGSupportSwiftFormatPlugin" build plugin in favor of external dependency management.
- Custom shell and JavaScript coverage extraction scripts, replaced by proven external action.

## [0.0.3] - 2025-02-25

Bug fixes and improvements

### Added
- License [here](https://github.com/Snapp-Mobile/SnappThemingSVGSupport/blob/main/LICENSE)


## [0.0.2] - 2025-01-30

### Added
- macOS support for the plugin


## [0.0.1] - 2025-01-21

### Added
- Initial version
