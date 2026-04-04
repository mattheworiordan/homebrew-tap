class Remi < Formula
  desc "The missing CLI for Apple Reminders — with section support and iCloud sync"
  homepage "https://github.com/mattheworiordan/remi"
  url "https://github.com/mattheworiordan/remi/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "c93bab053dbf4eb2f37acec5d29d9bb0cdbbd5f0fde5f4fcde4cd6bbd0f7c178"
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
    (bin/"remi").chmod 0755

    # Install shell completions
    generate_completions_from_executable(bin/"remi", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/remi --version").strip

    # Test help output
    assert_match "Apple Reminders", shell_output("#{bin}/remi --help")
  end
end
