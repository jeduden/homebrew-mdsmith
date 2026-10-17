class Mdsmith < Formula
  desc "Fast Markdown linter and formatter with cross-file integrity checks"
  homepage "https://mdsmith.dev"
  version "0.57.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/jeduden/mdsmith/releases/download/v0.57.0/mdsmith-darwin-arm64"
      sha256 "ea1e6bd6674d0739cae8b142afc902699b659a79fa4f1cb0c23ff4744e3c9648"
    end
    on_intel do
      url "https://github.com/jeduden/mdsmith/releases/download/v0.57.0/mdsmith-darwin-amd64"
      sha256 "8bb497fbe44531d46551182a0986690d870550ffa3ae364101c961db258aa654"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jeduden/mdsmith/releases/download/v0.57.0/mdsmith-linux-arm64"
      sha256 "7b14d883ebdfd20a8c72df9ff43a89660ff3aa82f770feea218340e16ecf38da"
    end
    on_intel do
      url "https://github.com/jeduden/mdsmith/releases/download/v0.57.0/mdsmith-linux-amd64"
      sha256 "e58bbd3bd312cbc12814daa115f7bf954cbce39a48a819e55cd253c704d2a153"
    end
  end

  def install
    # Each platform block downloads exactly one raw binary; rename
    # whatever was staged to the canonical command name.
    bin.install Dir["*"].first => "mdsmith"
  end

  test do
    assert_match "mdsmith v#{version}", shell_output("#{bin}/mdsmith version")
  end
end
