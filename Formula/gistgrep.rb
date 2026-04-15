class Gistgrep < Formula
  desc "Search your GitHub gists at the speed of grep — with AI summaries"
  homepage "https://github.com/mattheworiordan/gistgrep"
  url "https://github.com/mattheworiordan/gistgrep/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "ff7b08fdd7022424c15ee5a2cb6808f3a1c873b82b4d2826255f4add6b313460"
  license "MIT"

  depends_on "gh"
  depends_on "fzf"
  depends_on :macos

  def install
    bin.install "bin/gistgrep"
  end

  def caveats
    <<~EOS
      gistgrep needs the `gh` CLI authenticated:
        gh auth login

      On-device AI summaries require macOS 26+ with Apple Intelligence enabled
      and Xcode Command Line Tools for the one-time Swift bridge compile:
        xcode-select --install

      Check your setup with:
        gistgrep --doctor
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gistgrep --version")
  end
end
