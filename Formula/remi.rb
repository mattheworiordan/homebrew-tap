class Remi < Formula
  desc "The missing CLI for Apple Reminders — with section support and iCloud sync"
  homepage "https://github.com/mattheworiordan/remi"
  url "https://github.com/mattheworiordan/remi/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "0019dfc4b32d63c1392aa264aed2253c1e0c2fb09216f8e2cc269bbfb8bb49b5"
  license "MIT"

  depends_on "node"
  depends_on :macos

  def install
    # Install Node.js dependencies
    system "npm", "install", *std_npm_args(prefix: false)

    # Build TypeScript
    system "npx", "tsc"
    system "chmod", "+x", "dist/cli/index.js"

    # Compile Swift helpers
    system "bash", "src/swift/build.sh"

    # Install to libexec (Node.js app pattern)
    libexec.install "dist", "node_modules", "package.json", "src/swift"

    # Create wrapper script
    (bin/"remi").write <<~SH
      #!/bin/bash
      exec "#{Formula["node"].opt_bin}/node" "#{libexec}/dist/cli/index.js" "$@"
    SH

    # Install shell completions
    generate_completions_from_executable(bin/"remi", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/remi --version").strip

    # Test help output
    assert_match "Apple Reminders", shell_output("#{bin}/remi --help")
  end
end
